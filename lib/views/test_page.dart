import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? controller;
  List<CameraDescription> cameras = [];
  int selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      controller = CameraController(
          cameras[selectedCameraIndex], ResolutionPreset.medium);
      controller!.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    }
  }

  void takePicture() async {
    if (!controller!.value.isTakingPicture) {
      final XFile file = await controller!.takePicture();
      // 여기서 file.path를 사용하여 이미지를 저장하거나 표시할 수 있습니다.
    }
  }

  void switchCamera() {
    selectedCameraIndex =
        selectedCameraIndex < cameras.length - 1 ? selectedCameraIndex + 1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    controller = CameraController(selectedCamera, ResolutionPreset.medium);

    controller!.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CameraPreview(controller!),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                child: Icon(Icons.camera),
                onPressed: takePicture,
              ),
              SizedBox(width: 20),
              FloatingActionButton(
                child: Icon(Icons.switch_camera),
                onPressed: switchCamera,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
