import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  bool _isFilled = false;
  bool _showSubmitButton = true;
  bool _isRounded = false;
  bool _useDropdown = false;
  bool _useDialog = false;

  bool get useDialog => _useDialog;

  set useDialog(bool value) {
    _useDialog = value;
    notifyListeners();
  }

  bool get useDropdown => _useDropdown;

  set useDropdown(bool value) {
    _useDropdown = value;
    notifyListeners();
  }

  bool get isRounded => _isRounded;

  set isRounded(bool value) {
    _isRounded = value;
    notifyListeners();
  }

  bool get showSubmitButton => _showSubmitButton;

  set showSubmitButton(bool value) {
    _showSubmitButton = value;
    notifyListeners();
  }

  bool get isFilled => _isFilled;

  set isFilled(bool value) {
    _isFilled = value;
    notifyListeners();
  }
}
