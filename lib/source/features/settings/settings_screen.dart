import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mystery/source/common/consts/app_colors.dart';
import 'package:mystery/source/common/consts/app_images.dart';
import 'package:mystery/source/common/consts/app_text_styles.dart';
import 'package:mystery/source/common/utils/mystery_init_audio/audio_model.dart';
import 'package:mystery/source/common/widgets/custom_snackbar.dart';
import 'package:mystery/source/features/settings/ad_screen.dart';
import 'package:mystery/source/features/settings/daily_reward_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = MysteryAudioProvider.watch(context);
    final decoration = BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF3D4769),
          Color(0xFF1E253C),
        ],
      ),
      borderRadius: BorderRadius.circular(30.r),
    );
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.background),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.black45,
        appBar: AppBar(
          toolbarHeight: 120.h,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          foregroundColor: Colors.white,
          title: Row(
            children: [
              IconButton(
                style:
                    IconButton.styleFrom(backgroundColor: AppColors.background),
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
              Text('Settings  ', style: AppTextStyles.header16),
            ],
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          child: Column(
            children: [
              DecoratedBox(
                decoration: decoration,
                child: Row(
                  children: [
                    SizedBox(width: 30.w),
                    Text(
                      'Sound',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      inactiveTrackColor: const Color(0xFF100C22),
                      inactiveThumbColor: Colors.grey,
                      activeTrackColor: const Color(0xFFFFC700),
                      activeColor: Colors.white,
                      value: model.music,
                      onChanged: (value) async {
                        await model.toggleMusic();
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              DecoratedBox(
                decoration: decoration,
                child: Row(
                  children: [
                    SizedBox(width: 30.w),
                    Text(
                      'Daily Reward',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFF100C22),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const DailyPage(),
                        ),
                      ),
                      icon: Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 24.w,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              DecoratedBox(
                decoration: decoration,
                child: Row(
                  children: [
                    SizedBox(width: 30.w),
                    Text(
                      'Get coins',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFF100C22),
                      ),
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AdScreen(
                              videoAsset: switch (Random().nextInt(3)) {
                                1 => 'assets/videos/GameAd1.mp4',
                                2 => 'assets/videos/GameAd2.mp4',
                                _ => 'assets/videos/GameAd3.mp4',
                              },
                            ),
                          ),
                        );
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackbar.callSnackbar(50, context),
                        );
                      },
                      icon: Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 24.w,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
