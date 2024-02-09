import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mystery/source/common/consts/app_colors.dart';
import 'package:mystery/source/common/consts/app_images.dart';
import 'package:mystery/source/common/consts/app_text_styles.dart';

class CustomTitle extends StatelessWidget {
  const CustomTitle({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          style: IconButton.styleFrom(backgroundColor: AppColors.background),
          onPressed: () => Navigator.pop(context),
          icon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(AppIcons.leftArrow, width: 16.w),
              SizedBox(width: 6.w),
              Text('Back', style: AppTextStyles.caption12),
              SizedBox(width: 6.w),
            ],
          ),
        ),
        SizedBox(width: 16.w),
        Text(text, style: AppTextStyles.header16),
      ],
    );
  }
}
