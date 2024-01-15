import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  return TimerNotifier();
});

class TimerNotifier extends StateNotifier<TimerState> {
  TimerNotifier() : super(TimerState());

  Timer? timer;

  initDateTimer({
    void Function()? onFinish,
    required DateTime? date,
  }) {
    cancelTimer();
    if (date == null) return;
    _verifyDateTimer(date: date, onFinish: onFinish);

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      _verifyDateTimer(date: date, onFinish: onFinish);
    });
  }

  _verifyDateTimer({
    void Function()? onFinish,
    required DateTime date,
  }) {
    state = state.copyWith(
      timerOn: true,
    );
    DateTime now = DateTime.now();

    if (date.hour <= now.hour &&
        date.minute <= now.minute &&
        date.second <= now.second) {
      //si la hora ya pasó
      cancelTimer();
      if (onFinish != null) {
        onFinish();
      }
    } else {
      int minutesDifference = date.minute - now.minute;
      int secondsDifference = date.second - now.second;

      if (secondsDifference < 0) {
        secondsDifference += 60;
        minutesDifference--;
      }

      state = state.copyWith(
        timerText:
            '${format2digits(minutesDifference)}:${format2digits(secondsDifference)}',
      );
    }
  }

  String format2digits(int value) {
    if (value < 10) {
      return '0$value';
    }

    return '$value';
  }

  cancelTimer() {
    if (timer != null) {
      timer!.cancel();
      state = state.copyWith(
        timerOn: false,
      );
    }
  }
}

class TimerState {
  final String timerText;
  final bool timerOn;

  TimerState({
    this.timerText = '',
    this.timerOn = false,
  });

  TimerState copyWith({
    String? timerText,
    bool? timerOn,
  }) =>
      TimerState(
        timerText: timerText ?? this.timerText,
        timerOn: timerOn ?? this.timerOn,
      );
}
