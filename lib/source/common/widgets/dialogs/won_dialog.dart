import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mystery/source/common/consts/app_images.dart';
import 'package:mystery/source/common/widgets/custom_button.dart';

class WonDialog extends StatelessWidget {
  const WonDialog({super.key, required this.money});

  final int money;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image.asset('assets/images/win_dialog.png'),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Big Win!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppIcons.money, width: 22.w),
                  SizedBox(width: 10.w),
                  Text(
                    '$money',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: 173.w,
                height: 44.h,
                child: SuperCustomButton(
                  onPressed: () => Navigator.pop(context),
                  text: 'Continue',
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ],
      ),
    );
  }
}
