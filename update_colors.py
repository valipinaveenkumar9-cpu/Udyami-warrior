import os
import re

lib_dir = r"c:\office\projects\uk-circle-partners\lib"

color_map = {
    r"const Color\(0xFF16233A\)": "context.colors.primaryDarkBlue",
    r"Color\(0xFF16233A\)": "context.colors.primaryDarkBlue",
    
    r"const Color\(0xFFEEF1F6\)": "context.colors.lightGreyBlue",
    r"Color\(0xFFEEF1F6\)": "context.colors.lightGreyBlue",
    
    r"const Color\(0xFF2C4470\)": "context.colors.secondaryText",
    r"Color\(0xFF2C4470\)": "context.colors.secondaryText",
    
    r"const Color\(0xFFDCE4EF\)": "context.colors.disabledBorder",
    r"Color\(0xFFDCE4EF\)": "context.colors.disabledBorder",
    
    r"const Color\(0xFFF7F9FC\)": "context.colors.pageBackground",
    r"Color\(0xFFF7F9FC\)": "context.colors.pageBackground",
    
    r"const Color\(0xFF8FA2C0\)": "context.colors.subtitleText",
    r"Color\(0xFF8FA2C0\)": "context.colors.subtitleText",
    
    r"const Color\(0xFF1E7A54\)": "context.colors.greenSuccess",
    r"Color\(0xFF1E7A54\)": "context.colors.greenSuccess",
    
    r"const Color\(0xFFF2A93B\)": "context.colors.orangeWarning",
    r"Color\(0xFFF2A93B\)": "context.colors.orangeWarning",
    
    r"Colors\.white": "context.colors.cardBackground",
    r"Colors\.transparent": "context.colors.transparent",
    r"const Color\(0xFF000000\)": "context.colors.defaultText",
    r"Color\(0xFF000000\)": "context.colors.defaultText",
    r"Colors\.black": "context.colors.defaultText",
}

# Regex for stripping const before widget names and collections
const_pattern = re.compile(r'\bconst\s+(?=[A-Z\[\{])')

def process_file(filepath):
    # skip main.dart and app_colors.dart
    if filepath.endswith('main.dart') or filepath.endswith('app_colors.dart'):
        return

    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    original = content
    
    for pattern, repl in color_map.items():
        content = re.sub(pattern, repl, content)
        
    if content != original:
        # Strip all 'const ' before words starting with capital letters, or [, or {
        content = const_pattern.sub('', content)
        
        # Add import
        import_stmt = "import 'package:uk_circle_partners/core/thems/app_colors.dart';"
        if 'app_colors.dart' not in content:
            # find first import
            idx = content.find("import '")
            if idx != -1:
                end = content.find('\n', idx)
                content = content[:end+1] + import_stmt + '\n' + content[end+1:]
            else:
                content = import_stmt + '\n' + content
                
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated {filepath}")

for root, _, files in os.walk(lib_dir):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))
