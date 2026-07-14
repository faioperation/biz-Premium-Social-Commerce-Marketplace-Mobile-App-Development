import os
import re

constants_import = "import 'package:ecommerce_bizsolutio/core/constants/app_constants.dart';"

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()
    
    if '£' not in content:
        return
        
    if 'app_constants.dart' in filepath:
        return
        
    # Replace '£' with '${AppConstants.currencySymbol}' inside strings
    # But wait, sometimes it's already inside a string like '£${...}' -> '${AppConstants.currencySymbol}${...}'
    new_content = content.replace('£', '${AppConstants.currencySymbol}')
    
    # Check if import exists
    if 'AppConstants' in new_content and constants_import not in new_content:
        # insert after the first import or at the top
        import_match = re.search(r'^import .*?;', new_content, re.MULTILINE)
        if import_match:
            new_content = new_content[:import_match.end()] + '\n' + constants_import + new_content[import_match.end():]
        else:
            new_content = constants_import + '\n\n' + new_content
            
    with open(filepath, 'w') as f:
        f.write(new_content)

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))

print("Replacement complete.")
