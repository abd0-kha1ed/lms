import 'package:Ahmed_Hamed_lecture/feature/secure%20video/data/model/video_model.dart';
import 'package:Ahmed_Hamed_lecture/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


class DescriptionSection extends StatelessWidget {
  const DescriptionSection({super.key, required this.videoModel});
  final VideoModel videoModel;
  @override
  Widget build(BuildContext context) {
    void openWhatsApp(String phone) async {
      Uri whatsappUrl = Uri.parse('https://wa.me/$phone');
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl);
      } else {
        throw "Could not open WhatsApp";
      }
    }

    void lunchCustomUrl(String url) async {
      Uri customUrl = Uri.parse(url);
      if (await canLaunchUrl(customUrl)) {
        await launchUrl(customUrl);
      } else {
        throw "Could not open WhatsApp";
      }
    }

    void lunchYoutube(String url) async {
      Uri customUrl = Uri.parse(url);
      if (await canLaunchUrl(customUrl)) {
        await launchUrl(customUrl);
      } else {
        throw "Could not open WhatsApp";
      }
    }

    void lunchFacebook(String url) async {
      Uri customUrl = Uri.parse(url);
      if (await canLaunchUrl(customUrl)) {
        await launchUrl(customUrl);
      } else {
        throw "Could not open WhatsApp";
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          Text(videoModel.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          const SizedBox(height: 5),
          Container(
            padding: EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color.fromARGB(255, 226, 217, 217)),
            child: Text(videoModel.description!),
          ),
          const SizedBox(height: 5),
          const Divider(),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(LocaleKeys.khadmaty.tr(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(
                // Format the createdAt date to "YYYY-MM-DD"
                DateFormat('yyyy-MM-dd').format(videoModel.createdAt.toDate()),
                style: const TextStyle(fontSize: 16), // Optional styling
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    lunchCustomUrl('https://lms.5dmaty.com/public/');
                  },
                  icon: Icon(Icons.link, size: 32)),
              IconButton(
                  onPressed: () {
                    openWhatsApp('201065189050');
                  },
                  icon: Icon(FontAwesomeIcons.whatsapp, size: 32)),
              IconButton(
                  onPressed: () {
                    lunchYoutube('https://youtube.com/@5dmate-support?si=69cfPeuRYa1gMLvo');
                  },
                  icon: Icon(FontAwesomeIcons.youtube, size: 32)),
              IconButton(
                  onPressed: () {
                    lunchFacebook(
                        'https://www.facebook.com/share/18iUB8Yamt/');
                  },
                  icon: Icon(FontAwesomeIcons.facebook, size: 32))
            ],
          )
        ],
      ),
    );
  }
}
