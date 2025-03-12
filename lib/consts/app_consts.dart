import 'package:teqtop_team/config/size_config.dart';

class AppConsts {
  AppConsts._();

  static const String appName = 'Teqtop Team';
  static const double tabFontFactor = 1.5;
  static const double mobileFontFactor = 1.0;

  // static const String imgInitialUrl = "https://dev.team.teqtop.com";
  static const String imgInitialUrl = "https://new.teqtop.com";
  static const Set<String> supportedHTMLTags = {
    "a",
    "abbr",
    "acronym",
    "address",
    "area",
    "article",
    "aside",
    "audio",
    "b",
    "base",
    "bdi",
    "bdo",
    "big",
    "blockquote",
    "body",
    "br",
    "button",
    "canvas",
    "caption",
    "center",
    "cite",
    "code",
    "col",
    "colgroup",
    "data",
    "datalist",
    "dd",
    "del",
    "details",
    "dfn",
    "dialog",
    "dir",
    "div",
    "dl",
    "dt",
    "em",
    "embed",
    "fieldset",
    "figcaption",
    "figure",
    "font",
    "footer",
    "form",
    "frame",
    "frameset",
    "h1",
    "h2",
    "h3",
    "h4",
    "h5",
    "h6",
    "head",
    "header",
    "hgroup",
    "hr",
    "html",
    "i",
    "iframe",
    "img",
    "input",
    "ins",
    "kbd",
    "label",
    "legend",
    "li",
    "link",
    "main",
    "map",
    "mark",
    "menu",
    "meta",
    "meter",
    "nav",
    "noscript",
    "object",
    "ol",
    "optgroup",
    "option",
    "output",
    "p",
    "param",
    "picture",
    "pre",
    "progress",
    "q",
    "rp",
    "rt",
    "ruby",
    "s",
    "samp",
    "script",
    "section",
    "select",
    "small",
    "source",
    "span",
    "strong",
    "style",
    "sub",
    "summary",
    "sup",
    "svg",
    "table",
    "tbody",
    "td",
    "template",
    "textarea",
    "tfoot",
    "th",
    "thead",
    "time",
    "title",
    "tr",
    "track",
    "tt",
    "u",
    "ul",
    "var",
    "video",
    "wbr"
  };

  // static const String imgInitialUrl = "https://updateteamportal.teqtop.com";

  // false on release
  static const bool isDebug = true;

  static double commonFontSizeFactor =
      SizeConfig.isMobile ? mobileFontFactor : tabFontFactor;

  //Data Transfer Keys
  static String keyEmployeeId = 'key_employee_id';
  static String keyDriveURL = 'key_drive_url';
  static String keyDriveFolderDetail = 'key_drive_folder_detail';
  static String keyId = 'key_id';
  static String keyProjectId = 'key_project_id';
  static String keyTaskId = 'key_task_id';
  static String keyEmployeeProfilePhoto = 'key_employee_profile_photo';
  static String keyEmployeeName = 'key_employee_name';
  static String keyDailyReportDate = 'key_daily_report_date';
  static String keyCreatedDateTime = 'key_created_date_time';
  static String keyModifiedDateTime = 'key_modified_date_time';
  static String keyEmployeeAssignedProjectsHours =
      'key_employee_assigned_projects_hours';
  static String keyEmployeeAssignedProjectsHoursId =
      'key_employee_assigned_projects_hours_id';
  static String keyImagesURLS = 'key_images_urls';
  static String keyIndex = 'key_index';
}
