import 'package:flutter/material.dart';

class MysteryBlockButton extends ValueNotifier<bool> {
  MysteryBlockButton(super.value);

  void setBlockButton(bool value) {
    this.value = value;
    notifyListeners();
  }
}

abstract class MysteryAppProvider {
  static final blockButton = MysteryBlockButton(false);
}
