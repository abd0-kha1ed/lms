import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player_app/constant.dart';
import 'package:video_player_app/core/widget/custom_alert_dioalog.dart';
import 'package:video_player_app/generated/locale_keys.g.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  String? userName;
  String? userRole;
  String? userCode;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        final List<String> collections = ['students', 'assistants', 'teachers'];

        for (String collection in collections) {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection(collection)
              .doc(currentUser.uid)
              .get();

          if (userDoc.exists) {
            final data = userDoc.data() as Map<String, dynamic>;
            setState(() {
              userName = data['name'] ?? 'Unknown Name';
              userRole = data['role'] ?? 'Unknown Role';
              userCode = data['code'] ?? 'Unknown Code';
              isLoading = false;
            });
            return;
          }
        }

        // If the user is not found in any collection
        setState(() {
          userName = 'User Not Found';
          userRole = 'Unknown Role';
          userCode = 'Unknown Code';
          isLoading = false;
        });
      }
    } catch (e) {
      // print("Error fetching user data: $e");
      setState(() {
        userName = 'Error';
        userRole = 'Error';
        userCode = 'Error';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentLanguage = context.locale.languageCode;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          LocaleKeys.settings.tr(),
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // User Info Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            userName ?? '',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                userRole ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                userCode ?? '',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Language Selection Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            LocaleKeys.language.tr(),
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: kPrimaryColor),
                          ),
                          DropdownButton<String>(
                            value: currentLanguage,
                            onChanged: (String? newLanguage) {
                              if (newLanguage != null) {
                                context.setLocale(Locale(newLanguage));
                              }
                            },
                            items: const [
                              DropdownMenuItem(
                                value: 'en',
                                child: Text('English'),
                              ),
                              DropdownMenuItem(
                                value: 'ar',
                                child: Text('عربي'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Logout Button
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const CustomAlertDialogWidget();
                          },
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.red,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Text(
                                LocaleKeys.logout.tr(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              Icon(
                                Icons.logout,
                                color: Colors.white,
                                size: 33,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
