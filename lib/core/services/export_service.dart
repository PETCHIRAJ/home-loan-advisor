import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:csv/csv.dart';
import '../utils/currency_formatter.dart';
import '../../models/loan_model.dart';

/// Service for exporting loan data in various formats
/// 
/// Supports:
/// - PDF export with charts and professional formatting
/// - CSV export with detailed amortization schedule
/// - Share functionality for both formats
/// - Loan summary and breakdown reports
class ExportService {
  
  /// Export loan data and amortization schedule as PDF
  static Future<String> exportToPDF({
    required LoanModel loan,
    required List<Map<String, dynamic>> schedule,
    List<Map<String, dynamic>>? yearlySummary,
    bool includeCharts = true,
  }) async {
    final pdf = pw.Document();
    const theme = PdfPageFormat.a4;
    
    // Calculate totals
    final totalInterest = loan.totalInterest;
    final totalAmount = loan.totalAmount;
    final monthlyEMI = loan.monthlyEMI;
    
    // Add cover page
    pdf.addPage(
      pw.Page(
        pageFormat: theme,
        build: (context) => _buildCoverPage(loan, monthlyEMI, totalInterest, totalAmount),
      ),
    );
    
    // Add loan summary page
    pdf.addPage(
      pw.Page(
        pageFormat: theme,
        build: (context) => _buildSummaryPage(loan, monthlyEMI, totalInterest, totalAmount),
      ),
    );
    
    // Add charts page if requested
    if (includeCharts) {
      pdf.addPage(
        pw.Page(
          pageFormat: theme,
          build: (context) => _buildChartsPage(loan, totalInterest),
        ),
      );
    }
    
    // Add yearly summary if provided
    if (yearlySummary != null && yearlySummary.isNotEmpty) {
      pdf.addPage(
        pw.Page(
          pageFormat: theme,
          build: (context) => _buildYearlySummaryPage(yearlySummary),
        ),
      );
    }
    
    // Add detailed amortization schedule (paginated)
    const pageSize = 25; // Records per page
    for (int i = 0; i < schedule.length; i += pageSize) {
      final pageData = schedule.skip(i).take(pageSize).toList();
      final pageNumber = (i ~/ pageSize) + 1;
      final totalPages = (schedule.length / pageSize).ceil();
      
      pdf.addPage(
        pw.Page(
          pageFormat: theme,
          build: (context) => _buildSchedulePage(pageData, pageNumber, totalPages),
        ),
      );
    }
    
    // Save PDF to temporary directory
    final directory = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'home_loan_report_$timestamp.pdf';
    final file = File('${directory.path}/$fileName');
    
    await file.writeAsBytes(await pdf.save());
    
    return file.path;
  }
  
  /// Export loan data as CSV
  static Future<String> exportToCSV({
    required List<Map<String, dynamic>> schedule,
    bool includeSummary = true,
    LoanModel? loan,
  }) async {
    final List<List<String>> csvData = [];
    
    // Add summary if requested
    if (includeSummary && loan != null) {
      csvData.add(['LOAN SUMMARY']);
      csvData.add([]);
      csvData.add(['Loan Amount', CurrencyFormatter.formatCurrency(loan.loanAmount)]);
      csvData.add(['Interest Rate', '${loan.annualInterestRate}% per annum']);
      csvData.add(['Tenure', '${loan.tenureYears} years']);
      csvData.add(['Monthly EMI', CurrencyFormatter.formatCurrency(loan.monthlyEMI)]);
      csvData.add(['Total Interest', CurrencyFormatter.formatCurrency(loan.totalInterest)]);
      csvData.add(['Total Amount', CurrencyFormatter.formatCurrency(loan.totalAmount)]);
      csvData.add([]);
      csvData.add(['AMORTIZATION SCHEDULE']);
      csvData.add([]);
    }
    
    // Add headers
    csvData.add(['Month', 'EMI', 'Principal', 'Interest', 'Remaining Balance']);
    
    // Add data rows
    for (final entry in schedule) {
      csvData.add([
        entry['month'].toString(),
        entry['emi'].toStringAsFixed(2),
        entry['principal'].toStringAsFixed(2),
        entry['interest'].toStringAsFixed(2),
        entry['balance'].toStringAsFixed(2),
      ]);
    }
    
    // Convert to CSV string
    final csvString = const ListToCsvConverter().convert(csvData);
    
    // Save to temporary directory
    final directory = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'amortization_schedule_$timestamp.csv';
    final file = File('${directory.path}/$fileName');
    
    await file.writeAsString(csvString);
    
    return file.path;
  }
  
  /// Share file using the system share dialog
  static Future<void> shareFile({
    required String filePath,
    String? subject,
    String? text,
  }) async {
    final file = XFile(filePath);
    final fileName = filePath.split('/').last;
    
    await Share.shareXFiles(
      [file],
      subject: subject ?? 'Home Loan Report - $fileName',
      text: text ?? 'Here is your home loan analysis report.',
    );
  }
  
  /// Build PDF cover page
  static pw.Widget _buildCoverPage(
    LoanModel loan,
    double monthlyEMI,
    double totalInterest,
    double totalAmount,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Header
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(20),
          decoration: pw.BoxDecoration(
            color: PdfColors.blue,
            borderRadius: pw.BorderRadius.circular(10),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'HOME LOAN ADVISOR',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Comprehensive Loan Analysis Report',
                style: const pw.TextStyle(
                  fontSize: 16,
                  color: PdfColors.white,
                ),
              ),
            ],
          ),
        ),
        
        pw.SizedBox(height: 40),
        
        // Loan overview
        pw.Text(
          'Loan Overview',
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        
        pw.SizedBox(height: 20),
        
        _buildInfoRow('Loan Amount:', CurrencyFormatter.formatCurrency(loan.loanAmount)),
        _buildInfoRow('Interest Rate:', '${loan.annualInterestRate}% per annum'),
        _buildInfoRow('Tenure:', '${loan.tenureYears} years (${loan.totalMonths} months)'),
        
        pw.SizedBox(height: 30),
        
        // Key figures
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(15),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Column(
            children: [
              pw.Text(
                'Key Financial Figures',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 15),
              _buildInfoRow('Monthly EMI:', CurrencyFormatter.formatCurrency(monthlyEMI), isHighlight: true),
              _buildInfoRow('Total Interest:', CurrencyFormatter.formatCurrency(totalInterest)),
              _buildInfoRow('Total Amount Payable:', CurrencyFormatter.formatCurrency(totalAmount)),
            ],
          ),
        ),
        
        pw.Spacer(),
        
        // Footer
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(15),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey100,
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Column(
            children: [
              pw.Text(
                'Generated on ${DateTime.now().toLocal().toString().split(' ')[0]}',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                'This report contains detailed amortization schedule and loan analysis',
                style: const pw.TextStyle(fontSize: 10),
                textAlign: pw.TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  /// Build PDF summary page
  static pw.Widget _buildSummaryPage(
    LoanModel loan,
    double monthlyEMI,
    double totalInterest,
    double totalAmount,
  ) {
    final interestPercentage = (totalInterest / loan.loanAmount * 100);
    
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Loan Analysis Summary',
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        
        pw.SizedBox(height: 20),
        
        // Monthly breakdown
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(15),
          decoration: pw.BoxDecoration(
            color: PdfColors.blue50,
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Monthly Payment Breakdown',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              
              // First month calculation
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Monthly EMI:'),
                  pw.Text(CurrencyFormatter.formatCurrency(monthlyEMI)),
                ],
              ),
              
              pw.SizedBox(height: 5),
              
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('First Month Interest:'),
                  pw.Text(CurrencyFormatter.formatCurrency(
                    loan.loanAmount * loan.annualInterestRate / 100 / 12
                  )),
                ],
              ),
              
              pw.SizedBox(height: 5),
              
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('First Month Principal:'),
                  pw.Text(CurrencyFormatter.formatCurrency(
                    monthlyEMI - (loan.loanAmount * loan.annualInterestRate / 100 / 12)
                  )),
                ],
              ),
            ],
          ),
        ),
        
        pw.SizedBox(height: 20),
        
        // Cost analysis
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(15),
          decoration: pw.BoxDecoration(
            color: PdfColors.orange50,
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Cost Analysis',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              
              _buildInfoRow('Principal Amount:', CurrencyFormatter.formatCurrency(loan.loanAmount)),
              _buildInfoRow('Total Interest Cost:', CurrencyFormatter.formatCurrency(totalInterest)),
              _buildInfoRow('Interest as % of Principal:', '${interestPercentage.toStringAsFixed(1)}%'),
              _buildInfoRow('Total Cost of Loan:', CurrencyFormatter.formatCurrency(totalAmount)),
            ],
          ),
        ),
        
        pw.SizedBox(height: 20),
        
        // Key insights
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(15),
          decoration: pw.BoxDecoration(
            color: PdfColors.green50,
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Key Insights & Recommendations',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              
              _buildBulletPoint('Early principal payments can save significant interest'),
              _buildBulletPoint('Consider bi-weekly payments instead of monthly'),
              _buildBulletPoint('Review and refinance if rates drop significantly'),
              _buildBulletPoint('Track progress with our 20 money-saving strategies'),
              
              if (interestPercentage > 80)
                _buildBulletPoint('⚠️ High interest cost - consider shorter tenure or larger down payment'),
            ],
          ),
        ),
      ],
    );
  }
  
  /// Build charts page
  static pw.Widget _buildChartsPage(LoanModel loan, double totalInterest) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Loan Composition Analysis',
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        
        pw.SizedBox(height: 30),
        
        // Principal vs Interest pie chart representation
        pw.Container(
          width: double.infinity,
          height: 200,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  'Principal vs Interest Breakdown',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: [
                    pw.Column(
                      children: [
                        pw.Container(
                          width: 60,
                          height: 60,
                          decoration: const pw.BoxDecoration(
                            color: PdfColors.blue,
                            shape: pw.BoxShape.circle,
                          ),
                          child: pw.Center(
                            child: pw.Text(
                              '${(loan.loanAmount / (loan.loanAmount + totalInterest) * 100).toStringAsFixed(0)}%',
                              style: pw.TextStyle(
                                color: PdfColors.white,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text('Principal'),
                        pw.Text(
                          CurrencyFormatter.formatCurrencyCompact(loan.loanAmount),
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    
                    pw.Column(
                      children: [
                        pw.Container(
                          width: 60,
                          height: 60,
                          decoration: const pw.BoxDecoration(
                            color: PdfColors.orange,
                            shape: pw.BoxShape.circle,
                          ),
                          child: pw.Center(
                            child: pw.Text(
                              '${(totalInterest / (loan.loanAmount + totalInterest) * 100).toStringAsFixed(0)}%',
                              style: pw.TextStyle(
                                color: PdfColors.white,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text('Interest'),
                        pw.Text(
                          CurrencyFormatter.formatCurrencyCompact(totalInterest),
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        pw.SizedBox(height: 30),
        
        // Payment timeline representation
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(15),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey50,
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Payment Timeline',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 15),
              
              // Timeline bars
              for (int year = 1; year <= loan.tenureYears; year += 5)
                pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Row(
                    children: [
                      pw.SizedBox(
                        width: 60,
                        child: pw.Text('Year $year:', style: const pw.TextStyle(fontSize: 10)),
                      ),
                      pw.Expanded(
                        child: pw.Container(
                          height: 12,
                          decoration: pw.BoxDecoration(
                            color: year <= 5 ? PdfColors.blue : 
                                   year <= 15 ? PdfColors.orange : PdfColors.red,
                            borderRadius: pw.BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Text(
                        CurrencyFormatter.formatCurrencyCompact(loan.monthlyEMI * 12),
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
  
  /// Build yearly summary page
  static pw.Widget _buildYearlySummaryPage(List<Map<String, dynamic>> yearlySummary) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Yearly Payment Summary',
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        
        pw.SizedBox(height: 20),
        
        // Table
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          children: [
            // Header
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey100),
              children: [
                _buildTableCell('Year', isHeader: true),
                _buildTableCell('Total EMI', isHeader: true),
                _buildTableCell('Principal', isHeader: true),
                _buildTableCell('Interest', isHeader: true),
                _buildTableCell('Balance', isHeader: true),
              ],
            ),
            
            // Data rows
            for (final row in yearlySummary)
              pw.TableRow(
                children: [
                  _buildTableCell('${row['year']}'),
                  _buildTableCell(CurrencyFormatter.formatCurrencyCompact(row['totalEMI'])),
                  _buildTableCell(CurrencyFormatter.formatCurrencyCompact(row['totalPrincipal'])),
                  _buildTableCell(CurrencyFormatter.formatCurrencyCompact(row['totalInterest'])),
                  _buildTableCell(CurrencyFormatter.formatCurrencyCompact(row['endingBalance'])),
                ],
              ),
          ],
        ),
      ],
    );
  }
  
  /// Build schedule page
  static pw.Widget _buildSchedulePage(
    List<Map<String, dynamic>> pageData,
    int pageNumber,
    int totalPages,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Amortization Schedule',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              'Page $pageNumber of $totalPages',
              style: const pw.TextStyle(fontSize: 12),
            ),
          ],
        ),
        
        pw.SizedBox(height: 15),
        
        // Table
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          columnWidths: const {
            0: pw.FlexColumnWidth(1),
            1: pw.FlexColumnWidth(2),
            2: pw.FlexColumnWidth(2),
            3: pw.FlexColumnWidth(2),
            4: pw.FlexColumnWidth(2),
          },
          children: [
            // Header
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.blue50),
              children: [
                _buildTableCell('Month', isHeader: true),
                _buildTableCell('EMI', isHeader: true),
                _buildTableCell('Principal', isHeader: true),
                _buildTableCell('Interest', isHeader: true),
                _buildTableCell('Balance', isHeader: true),
              ],
            ),
            
            // Data rows
            for (final row in pageData)
              pw.TableRow(
                children: [
                  _buildTableCell('${row['month']}'),
                  _buildTableCell(CurrencyFormatter.formatCurrencyCompact(row['emi'])),
                  _buildTableCell(CurrencyFormatter.formatCurrencyCompact(row['principal'])),
                  _buildTableCell(CurrencyFormatter.formatCurrencyCompact(row['interest'])),
                  _buildTableCell(CurrencyFormatter.formatCurrencyCompact(row['balance'])),
                ],
              ),
          ],
        ),
        
        pw.Spacer(),
        
        // Footer
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey50,
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Text(
            'All amounts are in Indian Rupees (₹). EMI = Equated Monthly Installment',
            style: const pw.TextStyle(fontSize: 10),
            textAlign: pw.TextAlign.center,
          ),
        ),
      ],
    );
  }
  
  // Helper methods
  static pw.Widget _buildInfoRow(String label, String value, {bool isHighlight = false}) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: isHighlight ? 14 : 12,
              fontWeight: isHighlight ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: isHighlight ? 14 : 12,
              fontWeight: pw.FontWeight.bold,
              color: isHighlight ? PdfColors.blue : PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }
  
  static pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 12 : 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }
  
  static pw.Widget _buildBulletPoint(String text) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('• ', style: const pw.TextStyle(fontSize: 12)),
          pw.Expanded(
            child: pw.Text(
              text,
              style: const pw.TextStyle(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}