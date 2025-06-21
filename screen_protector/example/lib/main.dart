import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:screen_protector/screen_protector.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _protectionStatus = 'Unknown';

  @override
  void initState() {
    super.initState();
    enableScreenProtection();
  }

  Future<void> enableScreenProtection() async {
    String statusMessage;
    try {
      bool isProtected = await ScreenProtector.enableScreenProtection();
      statusMessage = isProtected ? 'Screen protection enabled' : 'Failed to enable protection';
    } on PlatformException {
      statusMessage = 'Error enabling screen protection.';
    }

    if (!mounted) return;

    setState(() {
      _protectionStatus = statusMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin Example App'),
        ),
        body: Center(
          child: Text('Status: $_protectionStatus\n'),
        ),
      ),
    );
  }
}
