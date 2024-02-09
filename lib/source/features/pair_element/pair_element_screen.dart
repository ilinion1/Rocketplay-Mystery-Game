import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystery/source/common/consts/app_text_styles.dart';
import 'package:mystery/source/common/widgets/background_image.dart';
import 'package:mystery/source/common/widgets/custom_bottom_sheet.dart';
import 'package:mystery/source/common/widgets/custom_snackbar.dart';
import 'package:mystery/source/common/utils/gap.dart';
import 'package:mystery/source/common/widgets/custom_title.dart';
import 'package:mystery/source/features/controllers/money_controller.dart';
import 'package:mystery/source/common/widgets/dialogs/lose_dialog.dart';
import 'package:mystery/source/common/widgets/dialogs/won_dialog.dart';
import 'package:mystery/source/features/pair_element/level.dart';
import 'package:mystery/source/features/space_dangerous/space_dangerous_screen.dart';

class MysteryPairElementsScreen extends StatefulWidget {
  const MysteryPairElementsScreen({super.key});

  @override
  State<MysteryPairElementsScreen> createState() =>
      _MysteryPairElementsScreenState();
}

class _MysteryPairElementsScreenState extends State<MysteryPairElementsScreen> {
  late List<int> type;

  // Card flipped or not
  late List<bool> cardFlips;

  // Card flipped & is done
  late List<bool> isDone;

  // for check
  int selectedIndex = -1;
  bool? success;
  bool isPause = true;
  bool isGameStarted = false;

  // score
  int score = 0;
  int money = 0;

  @override
  void initState() {
    super.initState();
    type = List.generate(15, (index) => index + 1);
    cardFlips = List.filled(30, false);
    isDone = List.filled(30, false);
    type
      ..addAll(List.from(type))
      ..shuffle();
  }

  void _mysteryRefreshLevel() {
    type = List.generate(15, (index) => index + 1);
    cardFlips = List.filled(30, false);
    isDone = List.filled(30, false);
    type
      ..addAll(List.from(type))
      ..shuffle();
    _mysteryShowCards();
  }

  void _mysteryShowCards() {
    isPause = true;
    setState(() {});
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      cardFlips = switch (5) {
        5 => List.filled(30, true),
        _ => List.generate(8, (index) => true),
      };
      setState(() {});
    });
    setState(() {});
    Future.delayed(const Duration(seconds: 6), () {
      if (!mounted) return;
      isPause = false;

      cardFlips = List.filled(30, false);
      setState(() {});
    });
  }

  // Game Status
  Future<void> _mysteryIsWon() async {
    if (isDone.where((element) => element == false).isNotEmpty) return;

    final totalMoney = (money + score * 0.5 * money).toInt();
    //! await SettingsProvider.read(context)!.model.setMoney(totalMoney);
    isGameStarted = false;
    setState(() {});
    _mysteryOnTryAgainPressed();

    setState(() {});
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => WonDialog(
        money: totalMoney,
      ),
    );
  }

  void _mysteryIsLose() {
    isGameStarted = false;
    _mysteryOnTryAgainPressed();
    isDone = List.filled(30, false);
    cardFlips = List.filled(30, false);
    setState(() {});
    showDialog(context: context, builder: (ctx) => const LoseDialog());
  }

  void _mysteryOnItemPressed(int itemIndex) async {
    if (isPause || isDone[itemIndex] || selectedIndex == itemIndex) return;
    setState(() {
      cardFlips[itemIndex] = !cardFlips[itemIndex];
    });
    if (selectedIndex == -1) {
      // if item is not selected
      selectedIndex = itemIndex;
      success = null;
    } else if (type[selectedIndex] != type[itemIndex]) {
      // if items isn't same
      success = false;
      isPause = true;
      Future.delayed(const Duration(milliseconds: 500), () async {
        isPause = false;
        cardFlips[itemIndex] = false;
        cardFlips[selectedIndex] = false;
        selectedIndex = -1;
        setState(() {});
        _mysteryIsLose();
      });
    } else if (type[selectedIndex] == type[itemIndex]) {
      // if items is same
      final isDoneIndex = selectedIndex;
      selectedIndex = -1;
      success = true;
      isPause = true;
      score++;
      Future.delayed(const Duration(milliseconds: 500), () async {
        isPause = false;
        isDone[isDoneIndex] = true;
        isDone[itemIndex] = true;
        success = null;
        setState(() {});
        await _mysteryIsWon();
      });
    }
    setState(() {});
  } // Buttons pressed

  void _mysteryOnTryAgainPressed() {
    selectedIndex = -1;
    success = null;
    isPause = true;
    money = 0;
    score = 0;
    setState(() {});
  }

  final moneys = <int>[10, 25, 50, 100, 200, 500];
  final colors = <Color>[
    const Color(0xFF15084D).withAlpha(60),
    const Color(0xFF1B70A0).withAlpha(60),
    const Color(0xFFA416A6).withAlpha(60),
    const Color(0xFF7F9B10).withAlpha(60),
    const Color(0xFFFFE792).withAlpha(60),
    const Color(0xFF00EAC0).withAlpha(60),
  ];

  @override
  Widget build(BuildContext context) {
    return BackgroundImage(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80.h,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          foregroundColor: Colors.white,
          title: const CustomTitle(text: 'Space Cards'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            GuideButton(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your task is to find pairs of elements that are hidden under the cards.',
                    style: AppTextStyles.text14,
                  ),
                  MysteryGap.height(8.h),
                  Image.asset('assets/images/empty_block.png', width: 50.w),
                  MysteryGap.height(8.h),
                  Text(
                    'For each pair found you will receive x0.2 to your bet.',
                    style: AppTextStyles.text14,
                  ),
                  MysteryGap.height(8.h),
                  Row(
                    children: List.generate(
                      6,
                      (index) => Padding(
                        padding: EdgeInsets.only(left: index == 0 ? 0 : 8.w),
                        child: SizedBox(
                          width: 50.w,
                          child: IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: colors[index],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            onPressed: () {},
                            icon: Text('+${moneys[index]}',
                                style: AppTextStyles.caption12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  MysteryGap.height(8.h),
                  Text(
                    'When your attempt is unsuccessful, your bet will be burned. \n\nYou can withdraw your money halfway through, at any time during the game.',
                    style: AppTextStyles.text14,
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MysteryLevel(
              type: type,
              cardFlips: cardFlips,
              isDone: isDone,
              success: success,
              onItemPressed: (int itemIndex) =>
                  _mysteryOnItemPressed(itemIndex),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 23.w),
              child: Row(
                children: [
                  Image.asset('assets/images/pair_element/stack.png',
                      height: 58.h),
                  SizedBox(width: 20.w),
                  Text(
                    '${15 - isDone.where((element) => element == true).length ~/ 2}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Paired elements left',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        bottomSheet: CustomBottomSheet(
          receiveMoney: (money + score * 0.5 * money).toInt() == 0
              ? null
              : (money + score * 0.5 * money).toInt(),
          onButtonPressed: (money) async {
            if (isGameStarted) {
              if (isPause) return;
              final totalMoney =
                  (this.money + score * 0.5 * this.money).toInt();
              await context.read<MysteryMoneyCubit>().setMoney(totalMoney);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackbar.callSnackbar(totalMoney, context),
              );
              isGameStarted = false;
              isDone = List.filled(30, false);
              cardFlips = List.filled(30, false);
              _mysteryOnTryAgainPressed();
              setState(() {});
            } else {
              _mysteryRefreshLevel();
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
