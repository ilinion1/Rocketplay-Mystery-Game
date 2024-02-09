import 'package:flutter/material.dart';
import 'package:mystery/source/common/consts/app_images.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({
    super.key,
    required this.child,
    this.image = AppImages.background,
  });

  final String image;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
