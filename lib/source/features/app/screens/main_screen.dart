import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mystery/source/common/consts/app_colors.dart';
import 'package:mystery/source/common/consts/app_images.dart';
import 'package:mystery/source/common/consts/app_text_styles.dart';
import 'package:mystery/source/common/widgets/background_image.dart';
import 'package:mystery/source/common/widgets/custom_button.dart';
import 'package:mystery/source/features/controllers/money_controller.dart';
import 'package:mystery/source/features/pair_element/pair_element_screen.dart';
import 'package:mystery/source/features/settings/settings_screen.dart';
import 'package:mystery/source/features/space_dangerous/space_dangerous_screen.dart';
import 'package:mystery/source/features/space_adventures/space_adventures_screen.dart';

class MysteryMainScreen extends StatelessWidget {
  const MysteryMainScreen({super.key});

  Widget openScreen(int index) {
    return switch (index) {
      0 => const MysteryPairElementsScreen(),
      1 => const SuperSaperScreen(),
      2 => const WheelGameScreen(),
      _ => const MysteryPairElementsScreen(),
    };
  }

  String nameScreens(int index) {
    return switch (index) {
      0 => 'Space Cards',
      1 => 'Dangeros Space',
      2 => 'Space Adventures',
      _ => 'Space Cards',
    };
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundImage(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80.h,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: SvgPicture.asset(AppIcons.logo, width: 110.w),
          actions: [
            Row(
              children: [
                SvgPicture.asset(AppIcons.money),
                SizedBox(width: 4.w),
                BlocBuilder<MysteryMoneyCubit, int>(
                  builder: (context, state) {
                    return Text('$state', style: AppTextStyles.text14);
                  },
                ),
                SizedBox(width: 16.w),
                IconButton(
                  style: IconButton.styleFrom(
                      backgroundColor: AppColors.background),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  ),
                  icon: SvgPicture.asset(AppIcons.settings, width: 24.w),
                ),
                SizedBox(width: 16.w),
              ],
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: <Widget>[
                ...List.generate(
                  3,
                  (index) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 9.h),
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/game_${index + 1}.png',
                          width: double.infinity,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 17.h,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nameScreens(index),
                                style: AppTextStyles.header16,
                              ),
                              SizedBox(height: 18.h),
                              SuperCustomButton(
                                text: 'Play',
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => openScreen(index),
                                  ),
                                ),
                                isSmall: true,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
