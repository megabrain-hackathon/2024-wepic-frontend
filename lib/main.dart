import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wepic/controller/saved_images_controller.dart';
import 'package:wepic/views/camera_page.dart'; // 이 경로는 실제 파일 경로에 맞게 수정해야 함
import 'package:wepic/views/history_page.dart';
import 'package:wepic/views/init_page.dart'; // 이 경로는 실제 파일 경로에 맞게 수정해야 함
import 'package:wepic/views/room_check_page.dart';
import 'package:wepic/views/setting_page.dart';

void main() {
  runApp(const MainApp());
}

enum AppState {
  initPage,
  roomPage,
  cameraPage,
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<AppState> _initialCheck() async {
    final prefs = await SharedPreferences.getInstance();
    bool initialAccept = prefs.getString('nickname') != null;
    bool roomExists = prefs.getString('roomId') != null;

    if (!initialAccept) {
      return AppState.initPage;
    } else if (!roomExists) {
      return AppState.roomPage;
    } else {
      return AppState.cameraPage;
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(SavedImagesController());
    return GetMaterialApp(
      home: FutureBuilder<AppState>(
        future: _initialCheck(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            switch (snapshot.data) {
              case AppState.initPage:
                return const InitPage();
              case AppState.roomPage:
                return const RoomCheckPage(); // 실제 RoomPage 위젯으로 교체해야 함
              case AppState.cameraPage:
              default:
                return CameraPage();
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      builder: EasyLoading.init(),
      getPages: [
        GetPage(name: '/', page: () => CameraPage()),
        GetPage(name: '/init', page: () => const InitPage()),
        GetPage(name: '/room', page: () => const RoomCheckPage()),
        GetPage(name: '/setting', page: () => const SettingPage()),
        GetPage(name: '/history', page: () => const HistoryPage()),
        // 필요한 경우 여기에 더 많은 페이지를 추가할 수 있음
      ],
    );
  }
}
