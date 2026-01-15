#!/usr/bin/env python3
"""
ARB File Sorter for Flutter Localization

Sorts ARB files alphabetically while keeping keys and metadata together:
1. @@locale at the top
2. Translation keys (alphabetically) with their @metadata immediately after
3. Each key-metadata pair stays together

Usage:
    python3 scripts/sort_arb.py                    # Sort all ARB files
    python3 scripts/sort_arb.py lib/l10n/app_en.arb  # Sort specific file
"""

import json
import sys
from pathlib import Path
from typing import Dict, Any, OrderedDict
from collections import OrderedDict as ODict


def sort_arb_file(file_path: Path) -> bool:
    """
    Sort an ARB file alphabetically while keeping keys and metadata together.
    
    Args:
        file_path: Path to the ARB file
        
    Returns:
        True if file was sorted successfully, False otherwise
    """
    try:
        # Read the file
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        if not isinstance(data, dict):
            print(f"❌ {file_path.name}: Not a valid JSON object")
            return False
        
        # Build sorted dictionary
        sorted_data = ODict()
        
        # 1. Add @@locale first if it exists
        if '@@locale' in data:
            sorted_data['@@locale'] = data['@@locale']
        
        # 2. Get all translation keys (non-metadata, non-@@locale)
        translation_keys = []
        for key in data.keys():
            if not key.startswith('@') and key != '@@locale':
                translation_keys.append(key)
        
        # 3. Sort translation keys alphabetically
        translation_keys.sort()
        
        # 4. Add each key followed immediately by its metadata (if exists)
        for key in translation_keys:
            # Add the translation key
            sorted_data[key] = data[key]
            
            # Add metadata immediately after if it exists
            metadata_key = f'@{key}'
            if metadata_key in data:
                sorted_data[metadata_key] = data[metadata_key]
        
        # Write back to file with proper formatting
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(sorted_data, f, indent=2, ensure_ascii=False)
            f.write('\n')  # Add trailing newline
        
        print(f"✅ {file_path.name}: Sorted successfully ({len(translation_keys)} keys)")
        return True
        
    except json.JSONDecodeError as e:
        print(f"❌ {file_path.name}: Invalid JSON - {e}")
        return False
    except Exception as e:
        print(f"❌ {file_path.name}: Error - {e}")
        return False


def main():
    """Main entry point for the script."""
    if len(sys.argv) > 1:
        # Sort specific files provided as arguments
        files = [Path(arg) for arg in sys.argv[1:]]
    else:
        # Sort all ARB files in lib/l10n/
        l10n_dir = Path('lib/l10n')
        if not l10n_dir.exists():
            print(f"❌ Directory not found: {l10n_dir}")
            print("Make sure you run this from the project root")
            sys.exit(1)
        
        files = list(l10n_dir.glob('*.arb'))
        if not files:
            print(f"❌ No ARB files found in {l10n_dir}")
            sys.exit(1)
    
    print(f"📝 Sorting {len(files)} ARB file(s)...\n")
    
    success_count = 0
    for file_path in files:
        if not file_path.exists():
            print(f"❌ File not found: {file_path}")
            continue
        
        if sort_arb_file(file_path):
            success_count += 1
    
    print(f"\n✅ Successfully sorted {success_count}/{len(files)} file(s)")
    
    if success_count < len(files):
        sys.exit(1)


if __name__ == '__main__':
    main()
