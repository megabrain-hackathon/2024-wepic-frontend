import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wepic/widget/user_profile_card.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '설정',
        ),
      ),
      body: NestedScrollView(
        physics: const ClampingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            const SliverAppBar(
              expandedHeight: 230,
              leading: SizedBox(),
              flexibleSpace: FlexibleSpaceBar(
                background: UserCard(),
              ),
            ),
          ];
        },
        body: ListView(
          physics: const ClampingScrollPhysics(),
          children: [
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                '방 나가기',
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                          title: const Text("방 나가기"),
                          content: const Text(
                              "정말 방을 나가시겠습니까?\n친구들과 교류를 할 수 없게 됩니다."),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: const Text("취소"),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                            CupertinoDialogAction(
                              child: const Text("방 나가기"),
                              textStyle: const TextStyle(color: Colors.red),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ],
                        ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text(
                '개인정보 처리방침',
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
