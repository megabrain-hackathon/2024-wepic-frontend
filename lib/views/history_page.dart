import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wepic/controller/saved_images_controller.dart';
import 'package:wepic/util/toast.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put<SavedImagesController>(SavedImagesController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '내가 공유한 사진',
        ),
      ),
      body: SafeArea(
        child: Obx(
          () => PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: controller.savedImages.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 8,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(File(
                                controller.savedImages[index])), // 저장된 이미지 표시
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      width: MediaQuery.of(context).size.width / 1.1,
                      height: MediaQuery.of(context).size.width / 1.1,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '나',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 20,
                        ),
                        const Text('2023-05-28 12:00',
                            style: TextStyle(color: Color(0xff5c5c5c))),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 18,
                    ),
                    Container(
                      child: IconButton(
                        icon: const Icon(Icons.ios_share),
                        onPressed: () {
                          showToast('사실 공유 안됨 ㅋㅋ');
                        },
                        iconSize: 40,
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
