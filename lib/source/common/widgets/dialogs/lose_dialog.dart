import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystery/source/common/widgets/custom_button.dart';

class LoseDialog extends StatelessWidget {
  const LoseDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      child: DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            image: const DecorationImage(
              image: AssetImage('assets/images/lose_dialog.png'),
              fit: BoxFit.contain,
            )
            // gradient: const LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   colors: [
            //     Color(0xFF7D7D7D),
            //     Color(0xFF24383F),
            //   ],
            // ),
            ),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 18.h),
              Text(
                'Game over',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                'You missed',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: 173.w,
                height: 44.h,
                child: SuperCustomButton(
                  onPressed: () => Navigator.pop(context),
                  text: 'Try again',
                ),
              ),
              SizedBox(height: 18.h),
            ],
          ),
        ),
      ),
    );
  }
}
