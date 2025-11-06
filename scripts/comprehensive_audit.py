#!/usr/bin/env python3
"""
Comprehensive Frontend Audit Script
Performs detailed specs vs code and code vs specs audit
"""

import json
import os
import re
from pathlib import Path
from typing import Dict, List, Set, Tuple

class ComprehensiveAuditor:
    def __init__(self, root_dir: str):
        self.root_dir = Path(root_dir)
        self.specs_dir = self.root_dir / "docs" / "specs"
        self.code_dir = self.root_dir / "lib"
        self.results = {
            "modules": {},
            "summary": {
                "total_modules": 0,
                "total_screens": 0,
                "total_widgets": 0,
                "specs_to_code": {},
                "code_to_specs": {},
                "testing_status": {},
                "wiring_status": {}
            }
        }
    
    def load_extraction_data(self) -> Dict:
        """Load previously extracted data"""
        extraction_file = self.root_dir / "docs" / "audit_extraction.json"
        if extraction_file.exists():
            with open(extraction_file, 'r', encoding='utf-8') as f:
                return json.load(f)
        return {}
    
    def audit_screen_implementation(self, screen_path: str, module_num: str) -> Dict:
        """Audit a single screen for implementation status"""
        screen_file = self.code_dir / screen_path
        if not screen_file.exists():
            return {"status": "MISSING", "details": {}}
        
        try:
            with open(screen_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            details = {
                "file_exists": True,
                "has_state_management": "StatefulWidget" in content or "setState" in content,
                "has_loading_state": "isLoading" in content or "SkeletonLoader" in content,
                "has_empty_state": "EmptyStateCard" in content or "empty" in content.lower(),
                "has_error_state": "error" in content.lower() or "ErrorStateCard" in content,
                "navigation_imports": len(re.findall(r'Navigator\.(push|pop)', content)),
                "widget_methods": len(re.findall(r'Widget\s+_build\w+\(', content)),
                "action_methods": len(re.findall(r'void\s+_handle\w+\(', content)),
                "api_calls": len(re.findall(r'await\s+\w+\.(fetch|get|post|put|delete)', content)),
                "mock_data": "Mock" in content or "mock" in content.lower(),
                "backend_integration": "TODO.*backend" in content or "Backend verification" in content,
            }
            
            # Determine status
            if details["has_state_management"] and details["widget_methods"] > 0:
                if details["mock_data"] and not details["api_calls"]:
                    status = "IMPLEMENTED_MOCK"
                elif details["api_calls"] > 0:
                    status = "IMPLEMENTED_WIRED"
                else:
                    status = "IMPLEMENTED_BASIC"
            else:
                status = "PARTIAL"
            
            return {"status": status, "details": details}
            
        except Exception as e:
            return {"status": "ERROR", "error": str(e)}
    
    def audit_widget_usage(self, widget_name: str) -> Dict:
        """Check if widget is used and documented"""
        # Check if widget file exists
        widget_file = self.code_dir / "widgets" / f"{widget_name}.dart"
        if not widget_file.exists():
            # Try to find in subdirectories
            widget_files = list(self.code_dir.glob(f"widgets/**/{widget_name}.dart"))
            if widget_files:
                widget_file = widget_files[0]
            else:
                return {"status": "NOT_FOUND"}
        
        # Check usage across codebase
        usage_count = 0
        for dart_file in self.code_dir.rglob("*.dart"):
            if dart_file != widget_file:
                try:
                    with open(dart_file, 'r', encoding='utf-8') as f:
                        if widget_name in f.read():
                            usage_count += 1
                except:
                    pass
        
        return {
            "status": "FOUND",
            "file": str(widget_file.relative_to(self.code_dir)),
            "usage_count": usage_count
        }
    
    def audit_module_comprehensive(self, module_num: str, module_data: Dict, 
                                   screens: List, widgets: List) -> Dict:
        """Comprehensive audit for a single module"""
        module_screens = [s for s in screens if s.get('module') == module_num]
        
        audit = {
            "module_number": module_num,
            "module_name": module_data.get("name", "Unknown"),
            "specs_to_code": {
                "capabilities": [],
                "screens": [],
                "widgets": []
            },
            "code_to_specs": {
                "screens": [],
                "widgets": [],
                "features": []
            },
            "implementation_status": {
                "implemented": 0,
                "partial": 0,
                "missing": 0,
                "mock": 0,
                "wired": 0
            }
        }
        
        # Audit each screen
        for screen in module_screens:
            screen_audit = self.audit_screen_implementation(screen['path'], module_num)
            audit["code_to_specs"]["screens"].append({
                "name": screen['name'],
                "path": screen['path'],
                "audit": screen_audit
            })
            
            # Update status counts
            status = screen_audit.get("status", "UNKNOWN")
            if status == "IMPLEMENTED_WIRED":
                audit["implementation_status"]["wired"] += 1
                audit["implementation_status"]["implemented"] += 1
            elif status == "IMPLEMENTED_MOCK":
                audit["implementation_status"]["mock"] += 1
                audit["implementation_status"]["implemented"] += 1
            elif status == "IMPLEMENTED_BASIC":
                audit["implementation_status"]["implemented"] += 1
            elif status == "PARTIAL":
                audit["implementation_status"]["partial"] += 1
            else:
                audit["implementation_status"]["missing"] += 1
        
        return audit
    
    def run_comprehensive_audit(self):
        """Run full comprehensive audit"""
        print("Loading extraction data...")
        extraction_data = self.load_extraction_data()
        
        if not extraction_data:
            print("No extraction data found. Run audit_extractor.py first.")
            return
        
        modules = extraction_data.get("modules", {})
        screens = extraction_data.get("screens", [])
        widgets = extraction_data.get("widgets", [])
        
        print(f"\nAuditing {len(modules)} modules...")
        
        for module_num in sorted(modules.keys(), key=int):
            print(f"  Auditing Module {module_num}: {modules[module_num]['name']}...")
            audit = self.audit_module_comprehensive(
                module_num,
                modules[module_num],
                screens,
                widgets
            )
            self.results["modules"][module_num] = audit
        
        # Generate summary
        self.results["summary"]["total_modules"] = len(modules)
        self.results["summary"]["total_screens"] = len(screens)
        self.results["summary"]["total_widgets"] = len(widgets)
        
        return self.results
    
    def save_results(self, output_file: str):
        """Save audit results"""
        output_path = self.root_dir / output_file
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(self.results, f, indent=2)
        print(f"\nAudit results saved to {output_path}")

if __name__ == "__main__":
    auditor = ComprehensiveAuditor(".")
    results = auditor.run_comprehensive_audit()
    auditor.save_results("docs/comprehensive_audit_results.json")
    print("\nComprehensive audit complete!")

