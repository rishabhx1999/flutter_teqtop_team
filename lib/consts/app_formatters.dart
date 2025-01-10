class AppFormatters {
  AppFormatters._();

  static final RegExp validNameExp = RegExp('[a-zA-Z]');
  static final RegExp validContactNoExp = RegExp('[0-9]');
  static final RegExp validUrlExp = RegExp(r"^(https?:\/\/)?"
      r"([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}"
      r"(\/[a-zA-Z0-9-._~:\/?#@!$&'()*+,;=]*)?$");
}
