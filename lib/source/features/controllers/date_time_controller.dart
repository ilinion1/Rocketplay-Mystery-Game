import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MysteryDateTimeCubit extends Cubit<DateTime> {
  final SharedPreferences pref;
  MysteryDateTimeCubit(this.pref) : super(_DateTimeStorage(pref).getDateTime());

  Future<void> setDateTime() async {
    emit(DateTime.now());
    await _DateTimeStorage(pref).setDateTime(state);
  }

  bool checkDailyLogin() {
    final difference = state.difference(DateTime.now());
    return difference.inDays < -1;
  }
}

class _DateTimeStorage {
  final SharedPreferences pref;
  _DateTimeStorage(this.pref);

  Future<void> setDateTime(DateTime dateTime) async {
    final dateTimeFilter = dateTime.toIso8601String();
    await pref.setString('date_time', dateTimeFilter);
  }

  DateTime getDateTime() {
    final dateTime = pref.getString('date_time') ?? "2012-02-27";
    return DateTime.parse(dateTime);
  }
}
