// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomCheckPage extends StatelessWidget {
  const RoomCheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 8,
        ),
        const Text('위픽',
            style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold)),
        SizedBox(
          height: MediaQuery.of(context).size.height / 15,
        ),
        ElevatedButton(
            onPressed: () async {
              EasyLoading.show(status: '방을 만드는 중입니다...');
              final prefs = await SharedPreferences.getInstance();
              String? username = await prefs.getString('nickname');
              String? id = await prefs.getString('deviceId');

              EasyLoading.dismiss();
              showDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: const Text('방 코드: 123456'),
                      content: Column(
                        children: [
                          Text('방 코드를 초대할 사람에게 공유하세요'),
                        ],
                      ),
                      actions: [
                        CupertinoDialogAction(
                          onPressed: () {
                            prefs.setString('roomId', '123456');
                            Get.back();
                            Get.offNamed('/camera');
                          },
                          child: const Text('확인'),
                        ),
                        CupertinoDialogAction(
                          onPressed: () {
                            Share.share('위픽 방 코드를 공유할게요\n방 코드: 123456');
                            prefs.setString('roomId', '123456');
                            Get.back();
                            Get.offNamed('/camera');
                          },
                          child: const Text('공유하기'),
                        ),
                      ],
                    );
                  });
            },
            child: const Text('방 만들기',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        SizedBox(
          height: MediaQuery.of(context).size.height / 20,
        ),
        ElevatedButton(
            onPressed: () {},
            child: const Text('방 참가하기',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
      ]),
    );
  }
}
