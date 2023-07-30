class TimeUtilities {
  static int getInitialIndex() {
    DateTime now = DateTime.now();
    if (now.weekday == DateTime.sunday) {
      return 0;
    }
    return now.weekday - 1;
  }

  static String formatTime(int value) {
    if (value <= 9) {
      return '0$value';
    }
    return '$value';
  }
}
