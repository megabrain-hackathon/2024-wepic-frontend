import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wepic/views/camera_page.dart';
import 'package:wepic/views/history_page.dart';
import 'package:wepic/views/setting_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: CameraPage(),
      builder: EasyLoading.init(),
      getPages: [
        GetPage(
          name: '/',
          page: () => CameraPage(),
        ),
        GetPage(
          name: '/history',
          page: () => const HistoryPage(),
        ),
        GetPage(
          name: '/setting',
          page: () => const SettingPage(),
        )
      ],
    );
  }
}
