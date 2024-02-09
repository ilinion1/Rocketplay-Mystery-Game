import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystery/source/common/consts/app_text_styles.dart';

class MysteryProgressBar extends StatefulWidget {
  const MysteryProgressBar({super.key, required this.child});

  final Widget child;

  @override
  State<MysteryProgressBar> createState() => _MysteryProgressBarState();
}

class _MysteryProgressBarState extends State<MysteryProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addStatusListener(splashListener);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  void splashListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => widget.child,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(splashListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/splash.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(60.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Text("Loading ${(_controller.value * 100).toInt()}%", style: AppTextStyles.header24.copyWith(color: Colors.black,),);   
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
