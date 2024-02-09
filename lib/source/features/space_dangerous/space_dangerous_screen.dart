import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mystery/source/common/consts/app_images.dart';
import 'package:mystery/source/common/consts/app_text_styles.dart';
import 'package:mystery/source/common/utils/gap.dart';
import 'package:mystery/source/common/widgets/background_image.dart';
import 'package:mystery/source/common/widgets/custom_bottom_sheet.dart';
import 'package:mystery/source/common/widgets/custom_snackbar.dart';
import 'package:mystery/source/common/widgets/custom_title.dart';
import 'package:mystery/source/features/controllers/money_controller.dart';
import 'package:mystery/source/common/widgets/dialogs/lose_dialog.dart';
import 'package:mystery/source/common/widgets/dialogs/won_dialog.dart';
import 'package:mystery/source/common/widgets/custom_help_screen.dart';

enum SaperItems { stars, trash }

class SuperSaperScreen extends StatefulWidget {
  const SuperSaperScreen({super.key});

  @override
  State<SuperSaperScreen> createState() => _SuperSaperScreenState();
}

class _SuperSaperScreenState extends State<SuperSaperScreen> {
  late final List<SaperItems?> items;
  List<bool> opened = List.generate(25, (index) => false);

  int money = 0;
  int friends = 0;
  bool isGameStarted = false;

  @override
  void initState() {
    super.initState();
    items = List.generate(3, (index) => SaperItems.trash);
    items.addAll(List.generate(12, (index) => SaperItems.stars));
    items.addAll(List.generate(10, (index) => null));
    items.shuffle();
  }

  void restartGame() {
    money = 0;
    friends = 0;
    isGameStarted = false;
    opened = List.filled(25, false);
    items.shuffle();
    setState(() {});
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
          title: const CustomTitle(text: 'Dangerous Space'),
          actions: [
            GuideButton(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You must collect all the stars that are hidden on this field.',
                    style: AppTextStyles.text14,
                  ),
                  MysteryGap.height(8.h),
                  Image.asset('assets/images/friend_star.png', width: 50.w),
                  MysteryGap.height(8.h),
                  Text(
                    'For each stars, you will receive x0.4 to your bet.\n\nBut there are also traps on the field, and if you fall into them, your bet will be burned.',
                    style: AppTextStyles.text14,
                  ),
                  MysteryGap.height(8.h),
                  Image.asset('assets/images/enemy_trash.png', width: 50.w),
                  MysteryGap.height(8.h),
                  Text(
                    'Be careful and very careful. Let\'s hit the road!',
                    style: AppTextStyles.text14,
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
          ],
        ),
        body: Column(
          children: [
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 8.h,
                crossAxisSpacing: 8.h,
                mainAxisExtent: 65.h,
              ),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                if (opened[index]) {
                  final item = items[index];
                  return Image.asset(
                    'assets/images/${item == null ? 'empty' : item.name}.png',
                    fit: BoxFit.contain,
                  );
                } else {
                  return GestureDetector(
                    onTap: () async {
                      if (!isGameStarted) return;
                      opened[index] = true;
                      setState(() {});
                      if (items[index] == SaperItems.trash) {
                        log('Game over');
                        restartGame();
                        showDialog(
                          context: context,
                          barrierColor: Colors.black87,
                          builder: (context) => const LoseDialog(),
                        );
                      } else if (items[index] == SaperItems.stars) {
                        log('x0.2');
                        friends++;
                        setState(() {});
                        if (friends == 12) {
                          final totalMoney =
                              (money + friends * 0.2 * money).toInt();
                          await context
                              .read<MysteryMoneyCubit>()
                              .setMoney(totalMoney);
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackbar.callSnackbar(totalMoney, context),
                          );
                          restartGame();
                          if (!mounted) return;
                          showDialog(
                            context: context,
                            barrierColor: Colors.black87,
                            builder: (context) => WonDialog(
                              money: totalMoney,
                            ),
                          );
                        }
                      }
                    },
                    child: Image.asset(
                      'assets/images/closed.png',
                      fit: BoxFit.contain,
                    ),
                  );
                }
              },
            ),
            MysteryGap.height(14.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset('assets/images/friend_star.png', width: 65.w),
                Text('${12 - friends}', style: AppTextStyles.header16),
                Text(
                  '< Left on the field >',
                  style: AppTextStyles.caption12.copyWith(
                    color: const Color(0xFF7591F3),
                  ),
                ),
                Text('3', style: AppTextStyles.header16),
                Image.asset('assets/images/enemy_trash.png', width: 65.w),
              ],
            ),
          ],
        ),
        bottomSheet: CustomBottomSheet(
          receiveMoney: (money + friends * 0.2 * money).toInt() == 0
              ? null
              : (money + friends * 0.2 * money).toInt(),
          onButtonPressed: (money) async {
            if (isGameStarted) {
              final totalMoney =
                  (this.money + friends * 0.2 * this.money).toInt();
              await context.read<MysteryMoneyCubit>().setMoney(totalMoney);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackbar.callSnackbar(totalMoney, context),
              );
              restartGame();
            } else {
              await context.read<MysteryMoneyCubit>().setMoney(-money);
              isGameStarted = true;
              this.money = money;
              setState(() {});
            }
          },
        ),
      ),
    );
  }
}

class GuideButton extends StatelessWidget {
  const GuideButton({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: const Color(0xFF7591F3),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomHelpScreen(
              title: 'Dangeros Space',
              child: child,
            ),
          ),
        );
      },
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Guide',
            style: AppTextStyles.caption12.copyWith(color: Colors.black),
          ),
          SizedBox(width: 4.w),
          SvgPicture.asset(AppIcons.guide, width: 24.w),
        ],
      ),
    );
  }
}
