import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wepic/util/toast.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  bool devicePermission = false;
  bool locationPermission = false;
  bool isPermissionLoading = false;

  void handleAcceptPermission() async {
    EasyLoading.show(status: '사용자 등록중입니다...');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final iosInfo = await deviceInfo.iosInfo;
    String? deviceId = iosInfo.identifierForVendor;
    prefs.setString('deviceId', deviceId!);

    Map<Permission, PermissionStatus> statuses = await [
      Permission.photos,
      Permission.camera,
    ].request();
    await prefs.setBool('termsAccepted', true);
    if (statuses[Permission.photos]!.isGranted &&
        statuses[Permission.camera]!.isGranted) {
    } else {
      showToast('권한 하용을 하지 않을 경우 사용에 제한이 있을 수 있습니다.');
    }

    EasyLoading.dismiss();
    // ignore: use_build_context_synchronously
    showDialog(
        context: context,
        builder: (context) {
          final TextEditingController _nicknameController =
              TextEditingController();

          return CupertinoAlertDialog(
            title: const Text('닉네임 등록'),
            content: CupertinoTextField(
              style: const TextStyle(
                color: Colors.black,
              ),
              controller: _nicknameController,
              placeholder: '새로운 닉네임을 입력해주세요.',
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Get.back();
                },
                child: const Text('취소'),
              ),
              CupertinoDialogAction(
                onPressed: () async {
                  final newNickname = _nicknameController.text;
                  Get.offAllNamed('/room');
                },
                child: const Text('등록'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SafeArea(
          child: ListView(
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              const SizedBox(
                height: 100,
              ),
              Text(
                '위픽 이용하기위해\n아래 권한 허용이 필요해요.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 48,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Text(
                    '아래 내용에 전체 동의합니다',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        devicePermission = true;
                        locationPermission = true;
                      });
                    },
                    child: Image.asset(
                      devicePermission && locationPermission
                          ? 'lib/assets/icon/checkbox_enable.png'
                          : 'lib/assets/icon/checkbox_disable.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 48,
              ),
              buildPermissionRow(
                '기기 및 앱 등록',
                '서비스 최적화 및 오류 확인',
                devicePermission,
                () => setState(() => devicePermission = !devicePermission),
              ),
              const SizedBox(
                height: 24,
              ),
              buildPermissionRow(
                '카메라 접근 권한',
                '다른 사용자에게 사진 공유',
                locationPermission,
                () => setState(() => locationPermission = !locationPermission),
              ),
              const SizedBox(
                height: 230,
              ),
              GestureDetector(
                onTap: devicePermission &&
                        locationPermission &&
                        !isPermissionLoading
                    ? handleAcceptPermission
                    : null,
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: devicePermission &&
                            locationPermission &&
                            !isPermissionLoading
                        ? Colors.blue
                        : Colors.grey,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Center(
                    child: Text('시작하기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
        if (isPermissionLoading)
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white.withOpacity(0.8),
            child: const Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            )),
          ),
      ]),
    );
    ;
  }
}

Widget buildPermissionRow(
  String title,
  String subtitle,
  bool isChecked,
  VoidCallback onTap,
) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              textScaleFactor: 1.0,
              TextSpan(
                  text: '$title ',
                  children: [
                    TextSpan(
                        text: '(필수)',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ))
                  ],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  )),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      GestureDetector(
        onTap: onTap,
        child: Image.asset(
          isChecked
              ? 'lib/assets/icon/checkbox_enable.png'
              : 'lib/assets/icon/checkbox_disable.png',
          width: 32,
          height: 32,
        ),
      ),
    ],
  );
}
