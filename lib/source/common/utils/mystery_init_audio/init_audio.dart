import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mystery/source/common/utils/mystery_init_audio/audio_model.dart';

class MysteryInitAudio extends StatefulWidget {
  const MysteryInitAudio({
    super.key,
    required this.child,
    required this.pref,
  });

  final Widget child;
  final SharedPreferences pref;

  @override
  State<MysteryInitAudio> createState() => _MysteryInitAudioState();
}

class _MysteryInitAudioState extends State<MysteryInitAudio> {
  late final MysteryAudioModel model;

  @override
  void initState() {
    super.initState();
    model = MysteryAudioModel(widget.pref);
  }

  @override
  Widget build(BuildContext context) {
    return MysteryAudioProvider(
      model: model,
      child: FotbalovyInitAudioWidget(child: widget.child),
    );
  }

  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }
}

class FotbalovyInitAudioWidget extends StatefulWidget {
  const FotbalovyInitAudioWidget({super.key, required this.child});

  final Widget child;

  @override
  State<FotbalovyInitAudioWidget> createState() =>
      FotbalovyInitAudioWidgetState();
}

class FotbalovyInitAudioWidgetState extends State<FotbalovyInitAudioWidget>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final model = MysteryAudioProvider.read(context).model;
    model.playOrPauseMusic();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (AppLifecycleState.paused == state) {
      final model = MysteryAudioProvider.read(context).model;
      await model.pauseMusic();
    } else if (AppLifecycleState.resumed == state) {
      final model = MysteryAudioProvider.read(context).model;
      if (model.music) {
        await model.playMusic();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (value) async {
        final model = MysteryAudioProvider.read(context).model;
        if (model.music) {
          await model.pauseMusic();
        }
      },
      child: widget.child,
    );
  }
}
