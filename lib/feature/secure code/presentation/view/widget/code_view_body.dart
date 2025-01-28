import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/core/utils/function/custom_snack_bar.dart';
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
  int index = 0;
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

    final filteredCodes = allCodes.where((code) => videoCodesList.contains(code.code)).toList();

    return filteredCodes;
  });
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
          customSnackBar(context, 'Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No codes available.'));
        }
        final codes = snapshot.data!;
        return ListView.builder(
          itemCount: codes.length,
          itemBuilder: (context, index) {
            final code = codes[index];
            return CodeItem(
                title: code.code,
                codeIndex: index + 1,
                color: code.isUsed == false ? kPrimaryColor : Colors.red);
          },
        );
      },
    );
  }
}
