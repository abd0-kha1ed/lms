import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/feature/secure%20code/data/code_model.dart';
import 'package:video_player_app/feature/secure%20code/presentation/view/widget/code_Item.dart';
import 'package:video_player_app/feature/secure%20video/data/model/video_model.dart';

class CodeViewBody extends StatefulWidget {
  const CodeViewBody({super.key, required this.videoModel});
  final VideoModel videoModel;

  @override
  State<CodeViewBody> createState() => _CodeViewBodyState();
}

class _CodeViewBodyState extends State<CodeViewBody> {
  Stream<List<CodeModel>> getCodesForVideo(String videoId) {
    return FirebaseFirestore.instance
        .collection('videos')
        .doc(videoId)
        .snapshots()
        .asyncMap((docSnapshot) async {
      final data = docSnapshot.data();
      if (data == null || !data.containsKey('codes')) return [];

      final videoCodesList = List<String>.from(data['codes']);

      final codesQuery = await FirebaseFirestore.instance
          .collection('codes')
          .where('videoId', isEqualTo: videoId)
          .get();

      final allCodes = codesQuery.docs
          .map((doc) => CodeModel.fromFirestore(doc.data()))
          .toList();

      final filteredCodes =
          allCodes.where((code) => videoCodesList.contains(code.code)).toList();

      return allCodes;
    });
  }

  Future<pw.Font> loadArabicFont() async {
    final ByteData fontData =
        await rootBundle.load("assets/fonts/Amiri-Regular.ttf");
    return pw.Font.ttf(fontData);
  }

  Future<void> generatePdf(List<CodeModel> codes) async {
    final pdf = pw.Document();
    final arabicFont = await loadArabicFont();

    pdf.addPage(
      pw.Page(
        theme: pw.ThemeData.withFont(base: arabicFont),
        build: (pw.Context context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('قائمة الأكواد العشوائية',
                    style: pw.TextStyle(
                        font: arabicFont,
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('الحالة',
                              style: pw.TextStyle(
                                  font: arabicFont,
                                  fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('الكود',
                              style: pw.TextStyle(
                                  font: arabicFont,
                                  fontWeight: pw.FontWeight.bold)),
                        ),
                      ],
                    ),
                    ...codes.map((code) => pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text(
                                  code.isUsed ? 'مُستخدم' : 'غير مستخدم',
                                  style: pw.TextStyle(font: arabicFont)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text(code.code,
                                  style: pw.TextStyle(
                                      font: arabicFont,
                                      fontWeight: pw.FontWeight.bold)),
                            ),
                          ],
                        )),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/codes_list.pdf');
    await file.writeAsBytes(await pdf.save());

    // فتح ملف PDF بعد الحفظ
    await OpenFile.open(file.path);

    print('تم حفظ ملف PDF في: ${file.path}');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CodeModel>>(
      stream: getCodesForVideo(widget.videoModel.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('حدث خطأ: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('لا توجد أكواد متوفرة حاليًا.',
                style: TextStyle(fontSize: 16)),
          );
        }
        final codes = snapshot.data!;
        return Scaffold(
          body: ListView.builder(
            itemCount: codes.length,
            itemBuilder: (context, index) {
              final code = codes[index];
              return CodeItem(
                title: code.code,
                codeIndex: index + 1,
                color: code.isUsed == false ? Colors.green : Colors.red,
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => generatePdf(snapshot.data!),
            backgroundColor: Colors.teal,
            child: const Icon(Icons.picture_as_pdf, color: Colors.white),
          ),
        );
      },
    );
  }
}
