import os
import re

lib_dir = r"c:\office\projects\uk-circle-partners\lib"

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Skip files that don't have appBar: AppBar(
    if 'appBar: AppBar(' not in content:
        return
        
    idx = content.find('appBar: AppBar(')
    new_content = ""
    last_idx = 0
    modified = False
    
    while idx != -1:
        start_paren = idx + len('appBar: AppBar')
        count = 0
        end_paren = -1
        for i in range(start_paren, len(content)):
            if content[i] == '(':
                count += 1
            elif content[i] == ')':
                count -= 1
                if count == 0:
                    end_paren = i
                    break
        
        if end_paren != -1:
            new_content += content[last_idx:idx] + "appBar: const CustomAppBar()"
            if end_paren + 1 < len(content) and content[end_paren + 1] == ',':
                new_content += ","
                last_idx = end_paren + 2
            else:
                last_idx = end_paren + 1
            modified = True
        else:
            new_content += content[last_idx:idx+len('appBar: AppBar(')]
            last_idx = idx + len('appBar: AppBar(')
            
        idx = content.find('appBar: AppBar(', last_idx)
        
    new_content += content[last_idx:]
    
    if modified:
        import_stmt = "import 'package:uk_circle_partners/core/widgets/custom_app_bar.dart';"
        if 'custom_app_bar.dart' not in new_content:
            import_idx = new_content.find("import '")
            if import_idx != -1:
                end_import = new_content.find('\n', import_idx)
                new_content = new_content[:end_import+1] + import_stmt + '\n' + new_content[end_import+1:]
            else:
                new_content = import_stmt + '\n' + new_content
                
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Updated {filepath}")

for root, _, files in os.walk(lib_dir):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))
