import re
import os

errors = """
  error - Undefined name 'context' - lib\\features\\auth\\presentation\\pending_screen.dart:183:96 - undefined_identifier
  error - The getter 'defaultText54' isn't defined for the type 'AppColors' - lib\\features\\auth\\presentation\\success_screen.dart:62:41 - undefined_getter
  error - Undefined name 'context' - lib\\features\\auth\\view_model\\invite\\finish_path_screen.dart:226:49 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\auth\\view_model\\invite\\finish_path_screen.dart:230:78 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\auth\\view_model\\invite\\invite_outside_path_screen.dart:155:19 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\auth\\view_model\\invite\\invite_outside_path_screen.dart:163:17 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\auth\\view_model\\invite\\invite_outside_path_screen.dart:176:17 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\auth\\view_model\\invite\\invite_outside_path_screen.dart:183:17 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\auth\\view_model\\invite\\invite_outside_path_screen.dart:227:17 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\auth\\view_model\\invite\\invites_on_path_screen.dart:185:14 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\auth\\view_model\\invite\\invites_on_path_screen.dart:232:28 - undefined_identifier
  error - Undefined name 'context' - lib\\features\\auth\\view_model\\invite\\invites_on_path_screen.dart:240:28 - undefined_identifier
"""

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

fixes = {}
for line in errors.strip().split('\n'):
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
        print(f"Not found: {full_path}")
        continue
    with open(full_path, 'r', encoding='utf-8') as f:
        content = f.read().split('\n')
        
    for linenum in linenums:
        idx = linenum - 1
        if idx < len(content):
            for k, v in reverse_map.items():
                content[idx] = content[idx].replace(k, v)
            content[idx] = content[idx].replace("context.colors.defaultText54", "Colors.black54")
                
    with open(full_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(content))
    print(f"Fixed {full_path}")
