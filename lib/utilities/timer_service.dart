import 'dart:async';

class TimerService {
  Timer? timer;
  bool is40SecCompleted = false;
  bool isTimerOn = false;

  void startTimer() {
    is40SecCompleted = false;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      isTimerOn = true;
      print("Timer Value := ${timer.tick}");
      if (timer.tick >= 40) {
        is40SecCompleted = true;
        isTimerOn = false;
        timer.cancel();
      }
    });
  }

  void verifyTimer() {
    if (!isTimerOn) {
      startTimer();
    }
  }
}
