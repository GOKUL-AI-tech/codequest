import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfCertificateService {
  PdfCertificateService._();
  static final PdfCertificateService instance = PdfCertificateService._();

  /// Builds a landscape A4 PDF document containing the high-resolution certificate image.
  Future<Uint8List> generatePdfBytes(Uint8List imageBytes) async {
    final pdf = pw.Document();
    final pdfImage = pw.MemoryImage(imageBytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return pw.FullPage(
            ignoreMargins: true,
            child: pw.Center(
              child: pw.Image(pdfImage, fit: pw.BoxFit.contain),
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  /// Downloads and saves the PDF file to disk, and triggers the native Save-as-PDF / Print dialog.
  Future<File> downloadPdf({
    required Uint8List imageBytes,
    required String languageName,
    required String username,
  }) async {
    final pdfBytes = await generatePdfBytes(imageBytes);
    final sanitizedUser = username.replaceAll(RegExp(r'[^\w\-]'), '_');
    final sanitizedLang = languageName.replaceAll(RegExp(r'[^\w\-]'), '_');
    final fileName = 'CodeQuest_${sanitizedLang}_Certificate_${sanitizedUser}.pdf';

    Directory outputDir;
    try {
      final downloads = await getDownloadsDirectory();
      outputDir = downloads ?? await getApplicationDocumentsDirectory();
    } catch (_) {
      outputDir = await getApplicationDocumentsDirectory();
    }

    final file = File('${outputDir.path}/$fileName');
    await file.writeAsBytes(pdfBytes);

    // Open system PDF layout preview / Save-as-PDF dialog
    await Printing.layoutPdf(
      name: 'CodeQuest_${sanitizedLang}_Certificate',
      format: PdfPageFormat.a4.landscape,
      onLayout: (format) async => pdfBytes,
    );

    return file;
  }

  /// Directly opens the native system share sheet with the PDF file.
  Future<void> sharePdf({
    required Uint8List imageBytes,
    required String languageName,
    required String username,
  }) async {
    final pdfBytes = await generatePdfBytes(imageBytes);
    final sanitizedUser = username.replaceAll(RegExp(r'[^\w\-]'), '_');
    final sanitizedLang = languageName.replaceAll(RegExp(r'[^\w\-]'), '_');
    final fileName = 'CodeQuest_${sanitizedLang}_Certificate_${sanitizedUser}.pdf';

    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: fileName,
    );
  }
}
