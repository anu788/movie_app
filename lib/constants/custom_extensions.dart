// extension to capitalize the first letter of a string
extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

extension NumExtentions on num {
  String minuteToHours() {
    if (this == 0) return "0h 0m";
    if (this < 60) return "${this}m";
    int hours = (this / 60).floor();
    int minutes = (this % 60).floor();
    return "${hours}h ${minutes}m";
  }
}
