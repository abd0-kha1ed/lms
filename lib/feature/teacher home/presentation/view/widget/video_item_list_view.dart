import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:video_player_app/feature/teacher%20home/presentation/view/widget/video_container.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class VideoItemListView extends StatelessWidget {
  const VideoItemListView({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height * 0.27,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        'https://yt3.googleusercontent.com/96CYBF7jrMfaFOYsiKRCUvBj_MHw1mytQyPo-SItjAn-LkrUO77ZVusowBiyGa5PrXtmnic9=s900-c-k-c0x00ffffff-no-rj',
                      )),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'title',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.edit))
                ],
              ),
              Row(
                children: [
                  Text(LocaleKeys.videoUploadedBy.tr()),
                  const Text(
                    'Abdo Khaled',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text('6 months ago'),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  VideoContainer(
                      text: LocaleKeys.twelve.tr(), color: Colors.red),
                  VideoContainer(
                    text: LocaleKeys.visible.tr(),
                    color: Colors.teal,
                    icon: Icons.visibility,
                  ),
                  VideoContainer(
                    text: LocaleKeys.approved.tr(),
                    color: Colors.green,
                    icon: Icons.check,
                  ),
                  Icon(Icons.lock_open, size: 30),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

