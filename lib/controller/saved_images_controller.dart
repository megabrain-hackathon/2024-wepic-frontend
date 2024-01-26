import 'package:get/get.dart';

class SavedImagesController extends GetxController {
  var savedImages = <String>[].obs; // .obs를 사용하여 반응형 상태 관리

  void addImage(String imagePath) {
    savedImages.add(imagePath); // 이미지 경로 추가
  }
}
