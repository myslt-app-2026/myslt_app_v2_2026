/// Helpers for Sri Lankan NIC numbers.
/// Old format: 9 digits + V/X (e.g. 975401234V)
/// New format: 12 digits (e.g. 199754001234)
enum NicGender { male, female }

class NicInfo {
  const NicInfo({required this.dateOfBirth, required this.gender});

  final DateTime dateOfBirth;
  final NicGender gender;
}

class NicUtils {
  static final RegExp _oldFormat = RegExp(r'^\d{9}[VX]$');
  static final RegExp _newFormat = RegExp(r'^\d{12}$');

  static String normalize(String input) => input.trim().toUpperCase();

  /// Returns date of birth + gender, or null if the NIC number is not valid.
  static NicInfo? parse(String input) {
    final nic = normalize(input);
    final int year;
    final int dayCode;

    if (_oldFormat.hasMatch(nic)) {
      year = 1900 + int.parse(nic.substring(0, 2));
      dayCode = int.parse(nic.substring(2, 5));
    } else if (_newFormat.hasMatch(nic)) {
      year = int.parse(nic.substring(0, 4));
      dayCode = int.parse(nic.substring(4, 7));
    } else {
      return null;
    }

    if (year < 1900 || year > DateTime.now().year) return null;

    // Women have 500 added to the day-of-year number.
    final isFemale = dayCode > 500;
    final day = isFemale ? dayCode - 500 : dayCode;

    final dob = _fromDayOfYear(year, day);
    if (dob == null) return null;

    return NicInfo(
      dateOfBirth: dob,
      gender: isFemale ? NicGender.female : NicGender.male,
    );
  }

  /// NIC day numbers always count 29 February (day 60), even in non-leap years.
  static DateTime? _fromDayOfYear(int year, int day) {
    final leap = (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
    var d = day;
    if (!leap) {
      if (day == 60) return null; // 29 Feb does not exist this year
      if (day > 60) d = day - 1;
    }
    if (d < 1 || d > (leap ? 366 : 365)) return null;
    return DateTime.utc(year, 1, 1).add(Duration(days: d - 1));
  }
}