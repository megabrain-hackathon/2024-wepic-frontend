import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wepic/util/toast.dart';

class UserCard extends StatefulWidget {
  const UserCard({super.key});

  @override
  State<UserCard> createState() => _UserProfileCardState();
}

class _UserProfileCardState extends State<UserCard> {
  void changeUsernameState(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (nickname == value) return;
    if (value.isEmpty) {
      showToast('닉네임을 입력하세요.');
    } else if (value.length < 3 || value.length > 10) {
      showToast('닉네임은 3글자 이상 10글자 이하로 입력해주세요.');
    } else if (!RegExp(r'^[a-zA-Z가-힣_]*[a-zA-Z가-힣][a-zA-Z가-힣_]*$')
        .hasMatch(value)) {
      showToast('닉네임은 한글, 영어, 숫자만 입력 가능합니다.');
    } else {
      EasyLoading.show(status: '닉네임 변경 중...');
      // final response = await postChangeNickname(value);
      // if (response?.statusCode != 200) {
      //   EasyLoading.showError('닉네임 변경 실패!');
      //   return;
      // }
      // setState(() {
      //   lc.nickname = value;
      // });
      // prefs.setString('nick-name', value);
      // EasyLoading.showSuccess('닉네임 변경 완료!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
      ),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 40.0,
                  backgroundColor: Colors.blue,
                ),
                const SizedBox(width: 16.0),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '김동현',
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 8,
                      )
                    ],
                  ),
                ),
                Expanded(child: Container()),
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    size: 20,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          final TextEditingController _nicknameController =
                              TextEditingController();

                          return CupertinoAlertDialog(
                            title: const Text('닉네임 변경'),
                            content: CupertinoTextField(
                              style: const TextStyle(
                                color: Colors.white,
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
                                onPressed: () {
                                  final newNickname = _nicknameController.text;
                                  Get.back();
                                },
                                child: const Text('변경'),
                              ),
                            ],
                          );
                        });
                  },
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('나의 방',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
            Expanded(
              child: CupertinoScrollbar(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    SizedBox(
                      width: 100,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('신종웅'),
                        subtitle: const Text('방장👑'),
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('김동현'),
                        subtitle: const Text('참가자'),
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('김경민'),
                        subtitle: const Text('참가자'),
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('임채성'),
                        subtitle: const Text('참가자'),
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
