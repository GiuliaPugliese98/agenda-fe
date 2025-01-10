class RegexUtils {
  static final RegExp regexEmail = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static final RegExp regexPassword = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');
  static final RegExp regexText = RegExp(r'[a-zA-Z]');
}