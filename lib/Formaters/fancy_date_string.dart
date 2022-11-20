class FancyDateString {
  final int minutes;

  FancyDateString(this.minutes);

  @override
  String toString() {
    if (minutes < 60) {
      return '${minutes.toString()} min';
    } else if (minutes < 1440) {
      return '${minutes ~/ 60}h ${minutes % 60}m';
    } else if (minutes < 525600) {
      return '${minutes ~/ 1440}d ${(minutes % 1440) ~/ 60}h';
    } else {
      return '${minutes ~/ 525600}y ${(minutes % 525600) ~/ 1440}d';
    }
  }
}