import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player_app/core/widget/custom_icon_button.dart';

class WhatsPhone extends StatelessWidget {
  const WhatsPhone({
    super.key,
    required this.phoneNumber,
  });

  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    void openWhatsApp(String phone) async {
      Uri whatsappUrl = Uri.parse('https://wa.me/+20$phone');
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl);
      } else {
        throw "Could not open WhatsApp";
      }
    }

    void openPhoneDialer(String phone) async {
      Uri telUrl = Uri.parse('tel:$phone');
      if (await canLaunchUrl(telUrl)) {
        await launchUrl(telUrl);
      } else {
        throw "Could not open Phone Dialer";
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomIconButton(
          icon: const Icon(
            FontAwesomeIcons.whatsapp,
            color: Colors.green,
          ),
          onPressed: () {
            openWhatsApp(phoneNumber);
          },
        ),
        CustomIconButton(
            onPressed: () {
              openPhoneDialer(phoneNumber);
            },
            icon: const Icon(
              Icons.phone,
              color: Colors.green,
            ))
      ],
    );
  }
}
