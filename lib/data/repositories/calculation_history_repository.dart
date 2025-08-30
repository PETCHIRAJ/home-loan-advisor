import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/entities/calculation_history.dart';

/// Repository interface for calculation history
abstract class CalculationHistoryRepository {
  Future<Either<String, List<CalculationHistory>>> getAllHistory();
  Future<Either<String, List<HistoryItem>>> getAllHistoryItems();
  Future<Either<String, CalculationHistory?>> getHistoryById(String id);
  Future<Either<String, void>> saveHistory(CalculationHistory history);
  Future<Either<String, void>> updateHistory(CalculationHistory history);
  Future<Either<String, void>> deleteHistory(String id);
  Future<Either<String, void>> clearAllHistory();
  Future<Either<String, List<CalculationHistory>>> getBookmarkedHistory();
  Future<Either<String, List<CalculationHistory>>> getHistoryByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
  Future<Either<String, HistoryStats>> getHistoryStats();
  Future<Either<String, List<CalculationHistory>>> searchHistory(String query);
  Future<Either<String, String>> exportHistoryAsCSV();
  Future<Either<String, String>> exportHistoryAsText();
}

/// Implementation of calculation history repository using SharedPreferences
class CalculationHistoryRepositoryImpl implements CalculationHistoryRepository {
  static const String _historyKey = 'calculation_history';
  static const String _historyItemsKey = 'calculation_history_items';
  static const int _maxHistoryCount = 50;
  
  final SharedPreferences _prefs;
  
  CalculationHistoryRepositoryImpl(this._prefs);

  @override
  Future<Either<String, List<CalculationHistory>>> getAllHistory() async {
    try {
      final historyJson = _prefs.getString(_historyKey);
      if (historyJson == null) {
        return const Right([]);
      }

      final List<dynamic> historyList = json.decode(historyJson);
      final List<CalculationHistory> history = historyList
          .map((json) => CalculationHistory.fromJson(json as Map<String, dynamic>))
          .toList();

      // Sort by timestamp, newest first
      history.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return Right(history);
    } catch (e) {
      return Left('Failed to load calculation history: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<HistoryItem>>> getAllHistoryItems() async {
    try {
      final historyItemsJson = _prefs.getString(_historyItemsKey);
      if (historyItemsJson == null) {
        return const Right([]);
      }

      final List<dynamic> itemsList = json.decode(historyItemsJson);
      final List<HistoryItem> items = itemsList
          .map((json) => HistoryItem.fromJson(json as Map<String, dynamic>))
          .toList();

      // Sort by timestamp, newest first
      items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return Right(items);
    } catch (e) {
      return Left('Failed to load history items: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, CalculationHistory?>> getHistoryById(String id) async {
    try {
      final allHistoryResult = await getAllHistory();
      return allHistoryResult.fold(
        (error) => Left(error),
        (history) {
          final foundHistory = history.where((h) => h.id == id).firstOrNull;
          return Right(foundHistory);
        },
      );
    } catch (e) {
      return Left('Failed to get history by ID: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> saveHistory(CalculationHistory history) async {
    try {
      final allHistoryResult = await getAllHistory();
      return allHistoryResult.fold(
        (error) => Left(error),
        (existingHistory) async {
          // Add new history at the beginning
          final updatedHistory = [history, ...existingHistory];
          
          // Keep only the most recent entries (max limit)
          final trimmedHistory = updatedHistory.take(_maxHistoryCount).toList();
          
          // Save full history
          final historyJson = json.encode(trimmedHistory.map((h) => h.toJson()).toList());
          await _prefs.setString(_historyKey, historyJson);
          
          // Save lightweight history items for quick access
          final historyItems = trimmedHistory.map((h) => HistoryItem.fromCalculationHistory(h)).toList();
          final itemsJson = json.encode(historyItems.map((h) => h.toJson()).toList());
          await _prefs.setString(_historyItemsKey, itemsJson);
          
          return const Right(null);
        },
      );
    } catch (e) {
      return Left('Failed to save calculation history: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> updateHistory(CalculationHistory updatedHistory) async {
    try {
      final allHistoryResult = await getAllHistory();
      return allHistoryResult.fold(
        (error) => Left(error),
        (existingHistory) async {
          // Find and update the specific history item
          final updatedList = existingHistory.map((h) {
            return h.id == updatedHistory.id ? updatedHistory : h;
          }).toList();
          
          // Save updated history
          final historyJson = json.encode(updatedList.map((h) => h.toJson()).toList());
          await _prefs.setString(_historyKey, historyJson);
          
          // Update history items too
          final historyItems = updatedList.map((h) => HistoryItem.fromCalculationHistory(h)).toList();
          final itemsJson = json.encode(historyItems.map((h) => h.toJson()).toList());
          await _prefs.setString(_historyItemsKey, itemsJson);
          
          return const Right(null);
        },
      );
    } catch (e) {
      return Left('Failed to update calculation history: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> deleteHistory(String id) async {
    try {
      final allHistoryResult = await getAllHistory();
      return allHistoryResult.fold(
        (error) => Left(error),
        (existingHistory) async {
          // Remove the specific history item
          final updatedHistory = existingHistory.where((h) => h.id != id).toList();
          
          // Save updated history
          final historyJson = json.encode(updatedHistory.map((h) => h.toJson()).toList());
          await _prefs.setString(_historyKey, historyJson);
          
          // Update history items too
          final historyItems = updatedHistory.map((h) => HistoryItem.fromCalculationHistory(h)).toList();
          final itemsJson = json.encode(historyItems.map((h) => h.toJson()).toList());
          await _prefs.setString(_historyItemsKey, itemsJson);
          
          return const Right(null);
        },
      );
    } catch (e) {
      return Left('Failed to delete calculation history: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> clearAllHistory() async {
    try {
      await _prefs.remove(_historyKey);
      await _prefs.remove(_historyItemsKey);
      return const Right(null);
    } catch (e) {
      return Left('Failed to clear history: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<CalculationHistory>>> getBookmarkedHistory() async {
    try {
      final allHistoryResult = await getAllHistory();
      return allHistoryResult.fold(
        (error) => Left(error),
        (history) {
          final bookmarked = history.where((h) => h.isBookmarked).toList();
          return Right(bookmarked);
        },
      );
    } catch (e) {
      return Left('Failed to get bookmarked history: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<CalculationHistory>>> getHistoryByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final allHistoryResult = await getAllHistory();
      return allHistoryResult.fold(
        (error) => Left(error),
        (history) {
          final filtered = history.where((h) {
            return h.timestamp.isAfter(startDate.subtract(const Duration(days: 1))) &&
                   h.timestamp.isBefore(endDate.add(const Duration(days: 1)));
          }).toList();
          return Right(filtered);
        },
      );
    } catch (e) {
      return Left('Failed to get history by date range: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, HistoryStats>> getHistoryStats() async {
    try {
      final allHistoryResult = await getAllHistory();
      return allHistoryResult.fold(
        (error) => Left(error),
        (history) {
          if (history.isEmpty) {
            return const Right(HistoryStats(
              totalCalculations: 0,
              averageLoanAmount: 0,
              averageInterestRate: 0,
              mostCommonTenure: 0,
              totalPotentialSavings: 0,
              bookmarkedCount: 0,
            ));
          }

          final totalCalculations = history.length;
          final bookmarkedCount = history.where((h) => h.isBookmarked).length;
          
          final averageLoanAmount = history
              .map((h) => h.parameters.loanAmount)
              .reduce((a, b) => a + b) / totalCalculations;
          
          final averageInterestRate = history
              .map((h) => h.parameters.interestRate)
              .reduce((a, b) => a + b) / totalCalculations;
          
          final totalPotentialSavings = history
              .map((h) => h.result.taxBenefits.totalAnnualSavings)
              .reduce((a, b) => a + b);
          
          // Find most common tenure
          final tenureMap = <int, int>{};
          for (final h in history) {
            tenureMap[h.parameters.tenureYears] = (tenureMap[h.parameters.tenureYears] ?? 0) + 1;
          }
          final mostCommonTenure = tenureMap.entries
              .reduce((a, b) => a.value > b.value ? a : b).key;

          // Get first and last calculation dates
          final sortedHistory = [...history]..sort((a, b) => a.timestamp.compareTo(b.timestamp));
          
          return Right(HistoryStats(
            totalCalculations: totalCalculations,
            averageLoanAmount: averageLoanAmount,
            averageInterestRate: averageInterestRate,
            mostCommonTenure: mostCommonTenure,
            totalPotentialSavings: totalPotentialSavings,
            firstCalculationDate: sortedHistory.first.timestamp,
            lastCalculationDate: sortedHistory.last.timestamp,
            bookmarkedCount: bookmarkedCount,
          ));
        },
      );
    } catch (e) {
      return Left('Failed to get history stats: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<CalculationHistory>>> searchHistory(String query) async {
    try {
      final allHistoryResult = await getAllHistory();
      return allHistoryResult.fold(
        (error) => Left(error),
        (history) {
          final lowercaseQuery = query.toLowerCase();
          
          final filtered = history.where((h) {
            // Search in name
            if (h.name != null && h.name!.toLowerCase().contains(lowercaseQuery)) {
              return true;
            }
            
            // Search in loan amount
            if (h.parameters.loanAmount.toString().contains(query)) {
              return true;
            }
            
            // Search in interest rate
            if (h.parameters.interestRate.toString().contains(query)) {
              return true;
            }
            
            // Search in tenure
            if (h.parameters.tenureYears.toString().contains(query)) {
              return true;
            }
            
            return false;
          }).toList();
          
          return Right(filtered);
        },
      );
    } catch (e) {
      return Left('Failed to search history: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, String>> exportHistoryAsCSV() async {
    try {
      final allHistoryResult = await getAllHistory();
      return allHistoryResult.fold(
        (error) => Left(error),
        (history) {
          if (history.isEmpty) {
            return const Right('No history to export');
          }

          final csvData = StringBuffer();
          
          // CSV Header
          csvData.writeln('Date,Name,Loan Amount,Interest Rate,Tenure Years,Monthly EMI,Total Interest,Total Amount,Tax Savings,PMAY Eligible');
          
          // CSV Data
          for (final h in history) {
            final date = '${h.timestamp.day}/${h.timestamp.month}/${h.timestamp.year}';
            final name = h.name?.replaceAll(',', ';') ?? 'Unnamed';
            final loanAmount = h.parameters.loanAmount.toStringAsFixed(0);
            final interestRate = h.parameters.interestRate.toStringAsFixed(2);
            final tenure = h.parameters.tenureYears.toString();
            final monthlyEMI = h.result.monthlyEMI.toStringAsFixed(0);
            final totalInterest = h.result.totalInterest.toStringAsFixed(0);
            final totalAmount = h.result.totalAmount.toStringAsFixed(0);
            final taxSavings = h.result.taxBenefits.totalAnnualSavings.toStringAsFixed(0);
            final pmayEligible = h.result.pmayBenefit?.isEligible ?? false;
            
            csvData.writeln('$date,$name,$loanAmount,$interestRate,$tenure,$monthlyEMI,$totalInterest,$totalAmount,$taxSavings,$pmayEligible');
          }
          
          return Right(csvData.toString());
        },
      );
    } catch (e) {
      return Left('Failed to export CSV: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, String>> exportHistoryAsText() async {
    try {
      final allHistoryResult = await getAllHistory();
      return allHistoryResult.fold(
        (error) => Left(error),
        (history) {
          if (history.isEmpty) {
            return const Right('No history to export');
          }

          final textData = StringBuffer();
          textData.writeln('📊 Home Loan Calculator History Export');
          textData.writeln('Generated on: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}');
          textData.writeln('Total Calculations: ${history.length}');
          textData.writeln('=' * 50);
          textData.writeln();

          for (int i = 0; i < history.length; i++) {
            final h = history[i];
            textData.writeln('${i + 1}. ${h.name ?? 'Calculation ${i + 1}'}');
            textData.writeln('   Date: ${h.timestamp.day}/${h.timestamp.month}/${h.timestamp.year}');
            textData.writeln('   Loan Amount: ₹${h.parameters.loanAmount.toStringAsFixed(0)}');
            textData.writeln('   Interest Rate: ${h.parameters.interestRate.toStringAsFixed(2)}%');
            textData.writeln('   Tenure: ${h.parameters.tenureYears} years');
            textData.writeln('   Monthly EMI: ₹${h.result.monthlyEMI.toStringAsFixed(0)}');
            textData.writeln('   Total Interest: ₹${h.result.totalInterest.toStringAsFixed(0)}');
            textData.writeln('   Tax Savings: ₹${h.result.taxBenefits.totalAnnualSavings.toStringAsFixed(0)}');
            if (h.result.pmayBenefit?.isEligible == true) {
              textData.writeln('   PMAY Subsidy: ₹${h.result.pmayBenefit!.subsidyAmount.toStringAsFixed(0)}');
            }
            textData.writeln();
          }
          
          return Right(textData.toString());
        },
      );
    } catch (e) {
      return Left('Failed to export text: ${e.toString()}');
    }
  }
}