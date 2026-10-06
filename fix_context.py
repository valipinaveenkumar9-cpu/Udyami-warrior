import os

reverse_map = {
    "context.colors.primaryDarkBlue": "Color(0xFF16233A)",
    "context.colors.lightGreyBlue": "Color(0xFFEEF1F6)",
    "context.colors.secondaryText": "Color(0xFF2C4470)",
    "context.colors.disabledBorder": "Color(0xFFDCE4EF)",
    "context.colors.pageBackground": "Color(0xFFF7F9FC)",
    "context.colors.subtitleText": "Color(0xFF8FA2C0)",
    "context.colors.greenSuccess": "Color(0xFF1E7A54)",
    "context.colors.orangeWarning": "Color(0xFFF2A93B)",
    "context.colors.cardBackground": "Colors.white",
    "context.colors.transparent": "Colors.transparent",
    "context.colors.defaultText": "Color(0xFF000000)",
}

errors = """
  error - Undefined name 'context' - lib\\features\\auth\\view_model\\path\\path_details_screen.dart:219:56 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\auth\\view_model\\path\\path_details_screen.dart:246:17 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\auth\\view_model\\path\\path_details_screen.dart:254:17 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\auth\\view_model\\path\\path_details_screen.dart:265:17 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\auth\\view_model\\path\\path_details_screen.dart:271:17 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\auth\\view_model\\path\\path_details_screen.dart:284:39 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\auth\\view_model\\path\\path_details_screen.dart:290:41 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\auth\\view_model\\path\\path_details_screen.dart:293:17 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\auth\\view_model\\path\\path_details_screen.dart:303:61 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\auth\\view_model\\path\\path_details_screen.dart:304:60 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\auth\\view_model\\refer\\referrals_screen.dart:172:22 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\auth\\view_model\\refer\\referrals_screen.dart:219:28 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\auth\\view_model\\rewards\\statement_screen.dart:163:26 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\auth\\view_model\\rewards\\statement_screen.dart:201:32 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\profile\\presentation\\leaderboard_screen.dart:178:49 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\profile\\presentation\\leaderboard_screen.dart:196:50 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\profile\\presentation\\leaderboard_screen.dart:198:83 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\profile\\presentation\\leaderboard_screen.dart:206:36 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\profile\\presentation\\leaderboard_screen.dart:206:67 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\profile\\presentation\\leaderboard_screen.dart:215:58 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\profile\\presentation\\leaderboard_screen.dart:226:86 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\profile\\presentation\\leaderboard_screen.dart:231:57 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\profile\\presentation\\leaderboard_screen.dart:238:80 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\profile\\presentation\\messages_screen.dart:95:68 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\profile\\presentation\\messages_screen.dart:120:30 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\profile\\presentation\\messages_screen.dart:128:30 - undefined_identifier
  error - The getter 'defaultText12' isn't defined for the type 'AppColors' - lib\\features\\profile\\presentation\\messages_screen.dart:149:35 - undefined_getter
"""

def fix_errors():
    lines = errors.strip().split('\n')
    fixes = {}
    for line in lines:
        parts = line.split('-')
        if len(parts) >= 3:
            file_info = parts[-2].strip()
            if ':' in file_info:
                filepath = file_info.split(':')[0].strip()
                linenum = int(file_info.split(':')[1])
                if filepath not in fixes:
                    fixes[filepath] = set()
                fixes[filepath].add(linenum)
                
    for filepath, linenums in fixes.items():
        full_path = os.path.join(r"c:\office\projects\uk-circle-partners", filepath)
        if not os.path.exists(full_path):
            continue
            
        with open(full_path, 'r', encoding='utf-8') as f:
            content = f.read().split('\n')
            
        for linenum in linenums:
            idx = linenum - 1
            if idx < len(content):
                for k, v in reverse_map.items():
                    content[idx] = content[idx].replace(k, v)
                content[idx] = content[idx].replace("context.colors.defaultText12", "Color(0xFF16233A)")
                
        with open(full_path, 'w', encoding='utf-8') as f:
            f.write('\n'.join(content))
        print(f"Fixed {full_path}")

fix_errors()
