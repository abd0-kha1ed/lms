import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/core/utils/function/custom_snack_bar.dart';
import 'package:video_player_app/feature/secure%20code/data/code_model.dart';
import 'package:video_player_app/feature/secure%20code/presentation/view/widget/code_Item.dart';

class CodeViewBody extends StatefulWidget {
  const CodeViewBody({super.key, required this.videoId});
  final String videoId;

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
        .map((docSnapshot) {
      final data = docSnapshot.data();
      if (data == null || !data.containsKey('codes')) return [];
      final codesList = data['codes'] as List<dynamic>;
      return codesList.map((code) {
        return CodeModel(
          code: code.toString(),
          isUsed: false,
          videoId: videoId,
          createdAt: Timestamp.now(),
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CodeModel>>(
      stream: getCodesForVideo(widget.videoId),
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
