#!/usr/bin/env python3
"""
Comprehensive Frontend Audit Extractor
Extracts structured data from specs and code for comparison
"""

import os
import re
import json
from pathlib import Path
from typing import Dict, List, Set

class AuditExtractor:
    def __init__(self, root_dir: str):
        self.root_dir = Path(root_dir)
        self.specs_dir = self.root_dir / "docs" / "specs"
        self.code_dir = self.root_dir / "lib"
        self.results = {
            "modules": {},
            "screens": [],
            "widgets": [],
            "models": [],
            "services": []
        }
    
    def extract_modules_from_specs(self):
        """Extract all modules from Product Definition"""
        product_def = self.specs_dir / "Product_Definition_v2.5.1_10of10.md"
        if not product_def.exists():
            return {}
        
        modules = {}
        current_module = None
        
        with open(product_def, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Find all module sections (### 3.X)
        module_pattern = r'^### 3\.(\d+)\s+(.+?)$'
        matches = re.finditer(module_pattern, content, re.MULTILINE)
        
        for match in matches:
            module_num = match.group(1)
            module_name = match.group(2).strip()
            modules[module_num] = {
                "number": module_num,
                "name": module_name,
                "features": [],
                "capabilities": []
            }
        
        # Extract core capabilities for each module
        for module_num, module_data in modules.items():
            pattern = rf'^### 3\.{module_num}\s+{re.escape(module_data["name"])}(.*?)(?=^### 3\.|\Z)'
            match = re.search(pattern, content, re.MULTILINE | re.DOTALL)
            if match:
                section = match.group(1)
                # Extract capabilities
                capabilities = re.findall(r'^- \*\*(.+?)\*\*:', section, re.MULTILINE)
                module_data["capabilities"] = capabilities
        
        return modules
    
    def extract_screens_from_code(self):
        """Extract all screens from lib/screens/"""
        screens_dir = self.code_dir / "screens"
        if not screens_dir.exists():
            return []
        
        screens = []
        for screen_file in screens_dir.rglob("*.dart"):
            if screen_file.name.endswith("_screen.dart") or screen_file.name == "main_navigation.dart":
                rel_path = screen_file.relative_to(self.code_dir)
                screens.append({
                    "path": str(rel_path),
                    "name": screen_file.stem,
                    "module": self._infer_module(screen_file),
                    "features": self._extract_features_from_screen(screen_file)
                })
        
        return screens
    
    def _infer_module(self, screen_file: Path) -> str:
        """Infer module from file path"""
        parts = screen_file.parts
        if len(parts) > 2 and parts[-2] in ["screens"]:
            # Check parent directory
            parent = screen_file.parent.name
            module_map = {
                "inbox": "3.1",
                "ai_hub": "3.11",
                "jobs": "3.3",
                "calendar": "3.4",
                "money": "3.5",
                "contacts": "3.6",
                "reviews": "3.7",
                "notifications": "3.8",
                "settings": "3.12",
                "home": "3.10",
                "onboarding": "3.14",
                "reports": "3.16",
                "quotes": "3.5",
            }
            return module_map.get(parent, "unknown")
        return "unknown"
    
    def _extract_features_from_screen(self, screen_file: Path) -> List[str]:
        """Extract feature names from screen file"""
        features = []
        try:
            with open(screen_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Look for widget methods that indicate features
            widget_pattern = r'Widget\s+_build(\w+)\([^)]*\)'
            widgets = re.findall(widget_pattern, content)
            features.extend([f"build_{w.lower()}" for w in widgets])
            
            # Look for action methods
            action_pattern = r'void\s+_handle(\w+)\([^)]*\)'
            actions = re.findall(action_pattern, content)
            features.extend([f"handle_{a.lower()}" for a in actions])
            
        except Exception as e:
            print(f"Error reading {screen_file}: {e}")
        
        return features
    
    def extract_widgets_from_code(self):
        """Extract all widgets from lib/widgets/"""
        widgets_dir = self.code_dir / "widgets"
        if not widgets_dir.exists():
            return []
        
        widgets = []
        for widget_file in widgets_dir.rglob("*.dart"):
            rel_path = widget_file.relative_to(self.code_dir)
            widgets.append({
                "path": str(rel_path),
                "name": widget_file.stem,
                "category": self._infer_widget_category(widget_file)
            })
        
        return widgets
    
    def _infer_widget_category(self, widget_file: Path) -> str:
        """Infer widget category from path"""
        parts = widget_file.parts
        if len(parts) > 2:
            return parts[-2]  # e.g., "global", "components", "forms"
        return "unknown"
    
    def extract_models_from_code(self):
        """Extract all models from lib/models/"""
        models_dir = self.code_dir / "models"
        if not models_dir.exists():
            return []
        
        models = []
        for model_file in models_dir.rglob("*.dart"):
            rel_path = model_file.relative_to(self.code_dir)
            models.append({
                "path": str(rel_path),
                "name": model_file.stem
            })
        
        return models
    
    def run_extraction(self):
        """Run all extraction methods"""
        print("Extracting modules from specs...")
        self.results["modules"] = self.extract_modules_from_specs()
        
        print("Extracting screens from code...")
        self.results["screens"] = self.extract_screens_from_code()
        
        print("Extracting widgets from code...")
        self.results["widgets"] = self.extract_widgets_from_code()
        
        print("Extracting models from code...")
        self.results["models"] = self.extract_models_from_code()
        
        return self.results
    
    def save_results(self, output_file: str):
        """Save extraction results to JSON"""
        output_path = self.root_dir / output_file
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(self.results, f, indent=2)
        print(f"Results saved to {output_path}")

if __name__ == "__main__":
    extractor = AuditExtractor(".")
    results = extractor.run_extraction()
    extractor.save_results("docs/audit_extraction.json")
    print(f"\nExtraction complete!")
    print(f"Modules found: {len(results['modules'])}")
    print(f"Screens found: {len(results['screens'])}")
    print(f"Widgets found: {len(results['widgets'])}")
    print(f"Models found: {len(results['models'])}")

