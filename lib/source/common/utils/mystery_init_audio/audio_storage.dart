import 'package:shared_preferences/shared_preferences.dart';

class MysteryAudioStorage {
  final SharedPreferences pref;
  MysteryAudioStorage(this.pref);

  //* ========= Music =========== *//
  Future<void> setupMusic(bool value) async {
    await pref.setBool('music', value);
  }

  bool getMusic() {
    return pref.getBool('music') ?? false;
  }

  //* ========= Sounds =========== *//
  Future<void> setupSounds(bool value) async {
    await pref.setBool('sounds', value);
  }

  bool getSounds() {
    return pref.getBool('sounds') ?? false;
  }
}
