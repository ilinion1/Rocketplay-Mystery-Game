import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystery/source/common/widgets/background_image.dart';
import 'package:mystery/source/common/widgets/custom_title.dart';

class CustomHelpScreen extends StatelessWidget {
  const CustomHelpScreen({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BackgroundImage(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 80.h,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: CustomTitle(text: title),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: child,
        ),
      ),
    );
  }
}
