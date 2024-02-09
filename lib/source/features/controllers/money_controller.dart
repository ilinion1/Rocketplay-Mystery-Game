import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MysteryMoneyCubit extends Cubit<int> {
  final SharedPreferences pref;
  MysteryMoneyCubit(this.pref) : super(_MoneyStorage(pref).getMoney());

  Future<void> setMoney(int value) async {
    emit(state + value);
    await _MoneyStorage(pref).setMoney(state);
  }
}

class _MoneyStorage {
  final SharedPreferences pref;
  _MoneyStorage(this.pref);

  Future<void> setMoney(int value) async {
    await pref.setInt('money', value);
  }

  int getMoney() {
    return pref.getInt('money') ?? 10000;
  }
}
