import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player_app/feature/secure%20video/data/model/video_model.dart';

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

    void lunchCustomUrl(String Url) async {
      Uri customUrl = Uri.parse(Url);
      if (await canLaunchUrl(customUrl)) {
        await launchUrl(customUrl);
      } else {
        throw "Could not open WhatsApp";
      }
    }

    void lunchYoutube(String Url) async {
      Uri customUrl = Uri.parse(Url);
      if (await canLaunchUrl(customUrl)) {
        await launchUrl(customUrl);
      } else {
        throw "Could not open WhatsApp";
      }
    }

    void lunchFacebook(String Url) async {
      Uri customUrl = Uri.parse(Url);
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
              const Text('Abdo Khaled',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(videoModel.createdAt.toDate().toString())
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    lunchCustomUrl('https://www.islamweb.net/ar/');
                  },
                  icon: Icon(Icons.link)),
              IconButton(
                  onPressed: () {
                    openWhatsApp('201007287335');
                  },
                  icon: Icon(FontAwesomeIcons.whatsapp)),
              IconButton(
                  onPressed: () {
                    lunchYoutube('https://www.youtube.com/@Mo_HassanTV');
                  },
                  icon: Icon(FontAwesomeIcons.youtube)),
              IconButton(
                  onPressed: () {
                    lunchFacebook(
                        'https://www.facebook.com/profile.php?id=100021770539965');
                  },
                  icon: Icon(FontAwesomeIcons.facebook))
            ],
          )
        ],
      ),
    );
  }
}
