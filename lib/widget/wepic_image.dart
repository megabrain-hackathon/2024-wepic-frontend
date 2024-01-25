import 'dart:io';

import 'package:flutter/material.dart';

class WepicWidgetImage extends StatelessWidget {
  final File imageFile;

  const WepicWidgetImage({
    super.key,
    required this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.file(imageFile),
    );
  }
}
