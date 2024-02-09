import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystery/source/common/utils/mystery_init_audio/init_audio.dart';
import 'package:mystery/source/features/controllers/date_time_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mystery/source/common/widgets/anim_splash.dart';
import 'package:mystery/source/features/controllers/money_controller.dart';
import 'package:mystery/source/features/app/screens/main_screen.dart';

class App extends StatelessWidget {
  const App({super.key, required this.pref});

  final SharedPreferences pref;

  @override
  Widget build(BuildContext context) {
    return MysteryInitAudio(
      pref: pref,
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => MysteryMoneyCubit(pref),
            ),
            BlocProvider(
              create: (context) => MysteryDateTimeCubit(pref),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Mystery',
            theme: ThemeData.dark(useMaterial3: true).copyWith(
              scaffoldBackgroundColor: Colors.transparent,
            ),
            home: const MysteryProgressBar(
              child: MysteryMainScreen(),
            ),
          ),
        ),
      ),
    );
  }
}
