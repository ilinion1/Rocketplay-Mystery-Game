import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mystery/source/common/consts/app_images.dart';
import 'package:mystery/source/common/widgets/custom_title.dart';
import 'package:mystery/source/features/controllers/date_time_controller.dart';
import 'package:mystery/source/features/controllers/money_controller.dart';

class DailyPage extends StatefulWidget {
  const DailyPage({super.key});

  @override
  State<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  bool opened = false;

  Widget giveMoneyWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '+50',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10.w),
            SvgPicture.asset(AppIcons.money, width: 22.w),
          ],
        ),
        Image.asset('assets/images/star.png', width: 100.w),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MysteryDateTimeCubit, DateTime>(
      builder: (context, state) {
        final difference = state.difference(DateTime.now());
        final myDuration = (const Duration(days: 1) + difference);
        final formattedDuration =
            "${myDuration.inHours}:${(myDuration.inMinutes % 60).toString().padLeft(2, '0')}:${(myDuration.inSeconds % 60).toString().padLeft(2, '0')}";
        final decoration = BoxDecoration(
          gradient: (difference.inDays < -1)
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF3D4769),
                    Color(0xFF1E253C),
                  ],
                )
              : null,
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
              leadingWidth: 40.w,
              title: const CustomTitle(text: 'Daily Reward'),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: DecoratedBox(
                decoration: decoration,
                child: SizedBox(
                  // height: 164.h,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 15.h),
                      if (difference.inDays < -1)
                        Text(
                          'Daily Reward',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      SizedBox(height: 14.h),
                      // text: (difference.inDays >= -1)
                      //   ? 'Next Daily Reward in $formattedDuration'
                      //   : 'Daily Reward',
                      if (difference.inDays >= -1)
                        SizedBox(
                          height: 100,
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              'Next Reward in $formattedDuration',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        ),
                      if (!opened && difference.inDays < -1)
                        Column(
                          children: [
                            SizedBox(
                              width: 280.w,
                              child: Text(
                                'Open the box and find out what you won!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                opened = true;
                                setState(() {});
                                await Future.delayed(
                                    const Duration(seconds: 2));
                                opened = false;
                                if (!mounted) return;
                                await context
                                    .read<MysteryDateTimeCubit>()
                                    .setDateTime();
                                if (!mounted) return;
                                await context
                                    .read<MysteryMoneyCubit>()
                                    .setMoney(20);
                                setState(() {});
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/guess_star.png',
                                      width: 100.w),
                                  SizedBox(height: 10.h),
                                  Image.asset('assets/images/guess_star.png',
                                      width: 100.w),
                                  SizedBox(height: 10.h),
                                  Image.asset('assets/images/guess_star.png',
                                      width: 100.w),
                                ],
                              ),
                            ),
                          ],
                        ),
                      if (opened && difference.inDays < -1) giveMoneyWidget(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
