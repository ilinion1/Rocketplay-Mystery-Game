import 'dart:math';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystery/source/common/consts/app_text_styles.dart';
import 'package:mystery/source/common/widgets/background_image.dart';
import 'package:mystery/source/common/widgets/custom_bottom_sheet.dart';
import 'package:mystery/source/common/widgets/custom_snackbar.dart';
import 'package:mystery/source/common/widgets/custom_title.dart';
import 'package:mystery/source/features/controllers/block_button_controller.dart';
import 'package:mystery/source/features/controllers/money_controller.dart';
import 'package:mystery/source/features/space_dangerous/space_dangerous_screen.dart';

class WheelGameScreen extends StatefulWidget {
  const WheelGameScreen({super.key});

  @override
  State<WheelGameScreen> createState() => _WheelGameScreenState();
}

class _WheelGameScreenState extends State<WheelGameScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  DateTime? dateTime;

  final List<dynamic> items = [5, 2, 1, 2, 10, 2.5, 1, 10, 1.5, 2.5];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(animate);
  }

  @override
  void dispose() async {
    _controller.removeListener(animate);
    _controller.dispose();
    super.dispose();
  }

  void animate() {
    if (!mounted) return;
    setState(() {});
  }

  void _spinAdventureWheel(int money) async {
    _controller.repeat();
    final random = Random();
    final nextInt = random.nextInt(1000) + 2000;
    final duration = Duration(milliseconds: nextInt);
    await Future.delayed(duration);
    if (!mounted) return;
    _controller.stop();
    final value = 1 - _controller.value;
    for (int i = 0; i < items.length; i++) {
      if (i / items.length <= value && value <= (i + 1) / items.length) {
        final amount = (items[i] * money).toInt();
        await context.read<MysteryMoneyCubit>().setMoney(amount);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackbar.callSnackbar(amount, context),
        );
      }
    }
    MysteryAppProvider.blockButton.setBlockButton(false);
  }

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
          title: const CustomTitle(text: 'Space Adventures'),
          actions: [
            GuideButton(
              child: Text(
                'Spin the wheel and earn bonuses on your bets',
                style: AppTextStyles.text14,
              ),
            ),
            SizedBox(width: 16.w),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: Image.asset('assets/images/cat.png', width: 142.w),
                      ),
                      Transform.rotate(
                        angle: _controller.value * 2 * pi,
                        child: Container(
                          width: double.infinity,
                          height: 400.h,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/wheel.png',
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Image.asset(
                    'assets/images/triangle_wheel.png',
                    width: 100.w,
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomSheet: const SpeenWheelBottomSheet(),
      ),
    );
  }
}

class SpeenWheelBottomSheet extends StatelessWidget {
  const SpeenWheelBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      onButtonPressed: (money) async {
        MysteryAppProvider.blockButton.setBlockButton(true);
        await context.read<MysteryMoneyCubit>().setMoney(-money);
        if (!context.mounted) return;
        context
            .findAncestorStateOfType<_WheelGameScreenState>()!
            ._spinAdventureWheel(money);
      },
    );
  }
}
