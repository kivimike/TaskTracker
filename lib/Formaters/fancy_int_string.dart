class FancyIntString {
  final int value;

  FancyIntString(this.value);

  @override
  String toString() {
    if (value < 1000) {
      return value.toString();
    } else if (value >= 1000 && value < 1000000) {
      int factor = (value / 1000).floor();
      return '${factor}k';
    } else if (value >= 1000000 && value < 1000000000) {
      int factor = (value / 1000000).floor();
      return '${factor}M';
    } else if (value >= 1000000000) {
      int factor = (value / 1000000000).floor();
      return '${factor}B';
    } else {
      return super.toString();
    }
  }
}