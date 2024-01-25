import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:home_widget/home_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wepic/util/toast.dart';
import 'package:wepic/widget/wepic_image.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  XFile? _image;
  String appGroupId = 'group.wepic_group';
  String name = 'wepic';
  String iosWidgetName = 'wepic';

  CameraController? _cameraController;
  List<CameraDescription>? _cameras = [];
  int selectedCameraIndex = 0;

  @override
  void initState() {
    HomeWidget.setAppGroupId(appGroupId);
    printDevice();
    _initializeCamera();
    super.initState();
  }

  printDevice() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final iosInfo = await deviceInfo.iosInfo;
    String? deviceId = iosInfo.identifierForVendor;
    prefs.setString('deviceId', deviceId!);
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _cameraController = CameraController(
        _cameras![0],
        ResolutionPreset.medium,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await _cameraController!.initialize();
      setState(() {});
    }
  }

  Future<File> cropSquare(File originalFile) async {
    img.Image image = img.decodeImage(originalFile.readAsBytesSync())!;

    int shortestSide = min(image.width, image.height);
    int startX = (image.width - shortestSide) ~/ 2;
    int startY = (image.height - shortestSide) ~/ 2;

    img.Image croppedImg = img.copyCrop(image,
        x: startX, y: startY, width: shortestSide, height: shortestSide);

    // 새로운 파일에 저장
    final croppedFile = File(originalFile.path)
      ..writeAsBytesSync(img.encodeJpg(croppedImg));
    return croppedFile;
  }

  void pressedShutter() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      final cameraImage = await _cameraController!.takePicture();
      File originalFile = File(cameraImage.path);
      File croppedFile = await cropSquare(originalFile);
      setState(() {
        _image = XFile(croppedFile.path);
      });
      final image = FileImage(croppedFile);
      final completer = Completer<void>();

      final stream = image.resolve(ImageConfiguration.empty);
      stream.addListener(
        ImageStreamListener(
          (info, _) => completer.complete(),
          onError: (error, stackTrace) => completer.completeError(error),
        ),
      );

      await completer.future;
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('공유하기'),
            content: Column(children: [
              SizedBox(height: 10),
              Image.file(File(_image!.path)),
              SizedBox(height: 10),
              Text('다음 사진을 방에 공유하시겠습니까?')
            ]),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text("취소"),
                onPressed: () {
                  Get.back();
                  setState(() {
                    _image = null;
                  });
                },
              ),
              CupertinoDialogAction(
                child: const Text("공유하기"),
                textStyle: const TextStyle(color: Colors.blue),
                onPressed: () async {
                  String filename = await HomeWidget.renderFlutterWidget(
                    WepicWidgetImage(imageFile: File(_image!.path)),
                    key: 'fileName',
                  );
                  await HomeWidget.saveWidgetData('fileName', filename);

                  await HomeWidget.updateWidget(
                    name: name,
                    iOSName: iosWidgetName,
                  );
                  Get.back();
                  setState(() {
                    _image = null;
                  });
                  showToast('공유가 완료되었습니다');
                },
              ),
            ],
          );
        },
      );
      EasyLoading.dismiss();
    } else {
      showToast('카메라를 사용할 수 없는 상태입니다');
    }
  }

  void pressedGallery() async {
    final ImagePicker _picker = ImagePicker();
    EasyLoading.show(
      status: '갤러리에서 이미지 불러오는 중...',
    );

    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File originalFile = File(pickedFile.path);
      File croppedFile = await cropSquare(originalFile);

      setState(() {
        _image = XFile(croppedFile.path);
      });
      final image = FileImage(croppedFile);
      final completer = Completer<void>();

      final stream = image.resolve(ImageConfiguration.empty);
      stream.addListener(
        ImageStreamListener(
          (info, _) => completer.complete(),
          onError: (error, stackTrace) => completer.completeError(error),
        ),
      );

      await completer.future;
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('공유하기'),
            content: Column(children: [
              SizedBox(height: 10),
              Image.file(File(_image!.path)),
              SizedBox(height: 10),
              Text('다음 사진을 방에 공유하시겠습니까?')
            ]),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text("취소"),
                onPressed: () {
                  Get.back();
                  setState(() {
                    _image = null;
                  });
                },
              ),
              CupertinoDialogAction(
                child: const Text("공유하기"),
                textStyle: const TextStyle(color: Colors.blue),
                onPressed: () async {
                  String filename = await HomeWidget.renderFlutterWidget(
                    WepicWidgetImage(imageFile: File(_image!.path)),
                    key: 'fileName',
                  );
                  await HomeWidget.saveWidgetData('fileName', filename);

                  await HomeWidget.updateWidget(
                    name: name,
                    iOSName: iosWidgetName,
                  );
                  Get.back();
                  setState(() {
                    _image = null;
                  });
                  showToast('공유가 완료되었습니다');
                },
              ),
            ],
          );
        },
      );
    }
    EasyLoading.dismiss();
  }

  void pressedRotate() {
    selectedCameraIndex = selectedCameraIndex == 0 ? 1 : 0;
    CameraDescription selectedCamera = _cameras![selectedCameraIndex];
    _cameraController =
        CameraController(selectedCamera, ResolutionPreset.medium);

    _cameraController!.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  void pressedSettings() {
    Get.toNamed('/setting');
  }

  void pressedHistory() {
    Get.toNamed('/history');
  }

  Widget _cameraPreviewWidget() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Text(
        '카메라를 사용할 수 없는 상태\nor 불러오는 중입니다.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
        ),
      );
    }

    return ClipRect(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: 480,
                height: 640,
                child: CameraPreview(_cameraController!),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              onPressed: pressedSettings, icon: const Icon(Icons.settings)),
          actions: [
            IconButton(
                onPressed: pressedHistory, icon: const Icon(Icons.history))
          ]),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width / 8,
            ),
            Container(
              child: Center(child: _cameraPreviewWidget()),
              width: MediaQuery.of(context).size.width / 1.1,
              height: MediaQuery.of(context).size.width / 1.1,
              decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width / 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.photo),
                  onPressed: pressedGallery,
                  iconSize: 40,
                ),
                GestureDetector(
                  onTap: pressedShutter,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.blue),
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black12,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.cached),
                  onPressed: pressedRotate,
                  iconSize: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
