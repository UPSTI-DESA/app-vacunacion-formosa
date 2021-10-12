import 'package:flutter/widgets.dart';

import 'package:sistema_vacunacion/src/providers/sistema/providerresult_providers.dart';

enum ProviderState { Idle, Busy }

class BaseChangeNotifier extends ChangeNotifier {
  ProviderState _state = ProviderState.Idle;
  String? _stateMessage;

  ProviderState get state => _state;
  String? get stateMessage => _stateMessage;

  bool get isIdle => _state == ProviderState.Idle;
  bool get isBusy => _state == ProviderState.Busy;

  ProviderResult createProviderResult(
    ProviderResultType type, {
    String? message,
  }) {
    idle();
    return ProviderResult(type, message: message);
  }

  idle({String? message}) {
    setState(ProviderState.Idle, message: message);
  }

  busy({String? message}) {
    setState(ProviderState.Busy, message: message);
  }

  setState(ProviderState state, {String? message}) {
    _stateMessage = message;
    _state = state;
    notifyListeners();
  }
}
