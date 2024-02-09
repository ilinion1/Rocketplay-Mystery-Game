import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mystery/source/common/consts/app_images.dart';
import 'package:mystery/source/common/consts/app_text_styles.dart';
import 'package:mystery/source/common/utils/gap.dart';
import 'package:mystery/source/common/widgets/custom_text_field.dart';
import 'package:mystery/source/features/controllers/money_controller.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    super.key,
    required this.onButtonPressed,
    this.receiveMoney,
  });

  final int? receiveMoney;

  final Function(int) onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.r),
            topRight: Radius.circular(12.r),
          ),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF3D4769),
              Color(0xFF20263E),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MysteryGap.height(22.h),
              Row(
                children: [
                  Text(
                    'Your Bet:',
                    style: AppTextStyles.caption12.copyWith(
                      color: const Color(0xFF7591F3),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Balance:',
                    style: AppTextStyles.caption12.copyWith(
                      color: const Color(0xFF7591F3),
                    ),
                  ),
                  MysteryGap.width(4.w),
                  SvgPicture.asset(AppIcons.money, width: 24.w),
                  MysteryGap.width(4.w),
                  BlocBuilder<MysteryMoneyCubit, int>(
                    builder: (context, state) {
                      return Text('$state', style: AppTextStyles.text14);
                    },
                  ),
                ],
              ),
              MysteryGap.height(16.h),
              CustomTextField(
                text: receiveMoney != null ? 'Receive: $receiveMoney' : 'Play',
                onButtonPressed: onButtonPressed,
              ),
              MysteryGap.height(10.h),
            ],
          ),
        ),
      ),
    );
  }
}
