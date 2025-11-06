#!/usr/bin/env python3
"""
Parallel Module Auditor
Audits all modules simultaneously for comprehensive review
"""

import json
import re
import os
from pathlib import Path
from typing import Dict, List
from concurrent.futures import ThreadPoolExecutor, as_completed

class ParallelModuleAuditor:
    def __init__(self, root_dir: str):
        self.root_dir = Path(root_dir)
        self.code_dir = self.root_dir / "lib"
        self.specs_dir = self.root_dir / "docs" / "specs"
        self.results = {}
    
    def load_extraction_data(self) -> Dict:
        """Load enhanced extraction data"""
        extraction_file = self.root_dir / "docs" / "enhanced_audit_extraction.json"
        if extraction_file.exists():
            with open(extraction_file, 'r', encoding='utf-8') as f:
                return json.load(f)
        return {}
    
    def audit_module(self, module_num: str, module_data: Dict, screens: List, widgets: List) -> Dict:
        """Comprehensive audit of a single module"""
        print(f"  Auditing Module {module_num}: {module_data.get('name', 'Unknown')}...")
        
        module_screens = [s for s in screens if s.get('module') == module_num]
        
        audit = {
            "module_number": module_num,
            "module_name": module_data.get('name', 'Unknown'),
            "purpose": module_data.get('purpose', ''),
            "capabilities": self._audit_capabilities(module_data, module_screens),
            "screens": self._audit_screens(module_screens, module_data),
            "navigation": self._audit_navigation(module_screens),
            "buttons_links": self._audit_buttons_links(module_screens),
            "flows": self._audit_flows(module_screens),
            "state_handling": self._audit_state_handling(module_screens),
            "backend_integration": self._audit_backend_integration(module_screens),
            "testing_status": self._check_testing(module_screens),
        }
        
        return audit
    
    def _audit_capabilities(self, module_data: Dict, screens: List) -> Dict:
        """Audit capabilities against code"""
        capabilities = []
        
        # Get capabilities from features if core_capabilities is empty
        features = module_data.get('features', [])
        for feature in features[:25]:  # Limit to first 25
            match = re.match(r'\*\*(.+?)\*\*:\s*(.+)', feature)
            if match:
                cap_name = match.group(1).strip()
                cap_desc = match.group(2).strip()
                
                # Check if implemented in screens
                found = False
                evidence = []
                
                for screen in screens:
                    screen_name = screen.get('name', '').lower()
                    features_data = screen.get('features', {})
                    widget_methods = features_data.get('widget_methods', [])
                    action_methods = features_data.get('action_methods', [])
                    
                    # Check for capability keywords
                    keywords = cap_name.lower().split()
                    for keyword in keywords:
                        if keyword in screen_name:
                            found = True
                            evidence.append(f"Screen: {screen.get('name')}")
                            break
                        for method in widget_methods + action_methods:
                            if keyword in method.lower():
                                found = True
                                evidence.append(f"Method: {method}")
                                break
                
                capabilities.append({
                    "name": cap_name,
                    "description": cap_desc[:100],  # Truncate
                    "found_in_code": found,
                    "evidence": evidence[:3],
                    "status": "IMPLEMENTED" if found else "MISSING"
                })
        
        return {
            "total": len(capabilities),
            "implemented": sum(1 for c in capabilities if c.get('found_in_code')),
            "missing": sum(1 for c in capabilities if not c.get('found_in_code')),
            "list": capabilities
        }
    
    def _audit_screens(self, screens: List, module_data: Dict) -> Dict:
        """Audit screens for implementation status"""
        screen_audits = []
        
        for screen in screens:
            screen_path = self.code_dir / screen.get('path')
            impl = screen.get('implementation', {})
            
            # Check if screen file exists and is readable
            file_exists = screen_path.exists()
            
            # Check implementation completeness
            has_state = impl.get('has_stateful', False)
            has_loading = impl.get('has_loading_state', False)
            has_empty = impl.get('has_empty_state', False)
            has_error = impl.get('has_error_state', False)
            has_navigation = impl.get('has_navigation', False)
            
            # Determine status
            if file_exists and has_state:
                if impl.get('api_calls_count', 0) > 0:
                    status = "WIRED"
                elif impl.get('has_mock_data', False):
                    status = "MOCK"
                else:
                    status = "IMPLEMENTED"
            elif file_exists:
                status = "PARTIAL"
            else:
                status = "MISSING"
            
            screen_audits.append({
                "name": screen.get('name'),
                "path": screen.get('path'),
                "file_exists": file_exists,
                "status": status,
                "has_loading_state": has_loading,
                "has_empty_state": has_empty,
                "has_error_state": has_error,
                "has_navigation": has_navigation,
                "api_calls": impl.get('api_calls_count', 0),
                "mock_data": impl.get('has_mock_data', False),
            })
        
        return {
            "total": len(screens),
            "implemented": sum(1 for s in screen_audits if s['status'] in ['IMPLEMENTED', 'WIRED', 'MOCK']),
            "partial": sum(1 for s in screen_audits if s['status'] == 'PARTIAL'),
            "missing": sum(1 for s in screen_audits if s['status'] == 'MISSING'),
            "list": screen_audits
        }
    
    def _audit_navigation(self, screens: List) -> Dict:
        """Audit navigation paths"""
        navigation_issues = []
        
        for screen in screens:
            screen_path = self.code_dir / screen.get('path')
            if not screen_path.exists():
                continue
            
            try:
                with open(screen_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                # Check for Navigator usage
                navigator_calls = re.findall(r'Navigator\.(push|pop|pushReplacement)', content)
                
                # Check for broken navigation
                broken_nav = []
                
                # Find all Navigator.push calls
                push_calls = re.finditer(r'Navigator\.push\([^)]+MaterialPageRoute\([^)]+builder:\s*\([^)]+\)\s*=>\s*(\w+)\s*\(', content)
                for match in push_calls:
                    screen_class = match.group(1)
                    # Check if screen class exists
                    if not any(s.get('class_name') == screen_class for s in screens):
                        broken_nav.append(f"Navigates to {screen_class} (not found)")
                
                if broken_nav:
                    navigation_issues.append({
                        "screen": screen.get('name'),
                        "issues": broken_nav
                    })
            except Exception as e:
                navigation_issues.append({
                    "screen": screen.get('name'),
                    "error": str(e)
                })
        
        return {
            "total_screens": len(screens),
            "screens_with_navigation": len([s for s in screens if s.get('implementation', {}).get('has_navigation', False)]),
            "issues": navigation_issues
        }
    
    def _audit_buttons_links(self, screens: List) -> Dict:
        """Audit buttons and links for dead ends"""
        dead_buttons = []
        
        for screen in screens:
            screen_path = self.code_dir / screen.get('path')
            if not screen_path.exists():
                continue
            
            try:
                with open(screen_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                # Find buttons with onPressed/onTap
                button_pattern = r'(onPressed|onTap):\s*\(\)\s*\{[^}]*\}'
                buttons = re.finditer(button_pattern, content)
                
                for button in buttons:
                    button_code = button.group(0)
                    # Check if it's empty or just has TODO
                    if '// TODO' in button_code or button_code.count('{') == button_code.count('}'):
                        dead_buttons.append({
                            "screen": screen.get('name'),
                            "issue": "Empty button handler",
                            "code": button_code[:100]
                        })
                
                # Find IconButton with empty onPressed
                icon_button_pattern = r'IconButton\([^)]*onPressed:\s*\(\)\s*\{[^}]*\}[^)]*\)'
                icon_buttons = re.finditer(icon_button_pattern, content)
                for btn in icon_buttons:
                    btn_code = btn.group(0)
                    if btn_code.count('{') <= 1:  # Empty or minimal
                        dead_buttons.append({
                            "screen": screen.get('name'),
                            "issue": "Empty IconButton handler",
                            "code": btn_code[:100]
                        })
                
            except Exception as e:
                pass
        
        return {
            "total_checked": len(screens),
            "dead_buttons": len(dead_buttons),
            "issues": dead_buttons[:20]  # Limit to first 20
        }
    
    def _audit_flows(self, screens: List) -> Dict:
        """Audit user flows"""
        flows = []
        
        # Common flows to check
        common_flows = [
            "Create → View → Edit → Delete",
            "List → Detail → Action",
            "Search → Filter → Select",
            "Compose → Send → View",
        ]
        
        # For each screen, check if it supports common flows
        for screen in screens:
            screen_path = self.code_dir / screen.get('path')
            if not screen_path.exists():
                continue
            
            try:
                with open(screen_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                features = screen.get('features', {})
                widget_methods = features.get('widget_methods', [])
                action_methods = features.get('action_methods', [])
                
                # Check for CRUD operations
                has_create = any('create' in m.lower() for m in action_methods)
                has_read = any('load' in m.lower() or 'fetch' in m.lower() for m in action_methods)
                has_update = any('update' in m.lower() or 'edit' in m.lower() for m in action_methods)
                has_delete = any('delete' in m.lower() for m in action_methods)
                
                flows.append({
                    "screen": screen.get('name'),
                    "has_create": has_create,
                    "has_read": has_read,
                    "has_update": has_update,
                    "has_delete": has_delete,
                    "flow_complete": has_create and has_read and (has_update or has_delete)
                })
            except:
                pass
        
        return {
            "total_screens": len(screens),
            "screens_with_flows": len([f for f in flows if f.get('flow_complete')]),
            "flows": flows
        }
    
    def _audit_state_handling(self, screens: List) -> Dict:
        """Audit state handling (loading, empty, error)"""
        state_issues = []
        
        for screen in screens:
            impl = screen.get('implementation', {})
            has_loading = impl.get('has_loading_state', False)
            has_empty = impl.get('has_empty_state', False)
            has_error = impl.get('has_error_state', False)
            
            if not (has_loading and has_empty and has_error):
                missing = []
                if not has_loading:
                    missing.append("loading")
                if not has_empty:
                    missing.append("empty")
                if not has_error:
                    missing.append("error")
                
                state_issues.append({
                    "screen": screen.get('name'),
                    "missing_states": missing
                })
        
        return {
            "total_screens": len(screens),
            "complete_state_handling": len(screens) - len(state_issues),
            "issues": state_issues
        }
    
    def _audit_backend_integration(self, screens: List) -> Dict:
        """Audit backend integration status"""
        integration_status = {
            "wired": 0,
            "mock": 0,
            "not_wired": 0,
            "screens": []
        }
        
        for screen in screens:
            impl = screen.get('implementation', {})
            api_calls = impl.get('api_calls_count', 0)
            has_mock = impl.get('has_mock_data', False)
            
            if api_calls > 0:
                status = "WIRED"
                integration_status["wired"] += 1
            elif has_mock:
                status = "MOCK"
                integration_status["mock"] += 1
            else:
                status = "NOT_WIRED"
                integration_status["not_wired"] += 1
            
            integration_status["screens"].append({
                "screen": screen.get('name'),
                "status": status,
                "api_calls": api_calls,
                "mock_data": has_mock
            })
        
        return integration_status
    
    def _check_testing(self, screens: List) -> Dict:
        """Check testing status"""
        test_dir = self.root_dir / "test"
        test_files = list(test_dir.rglob("*.dart")) if test_dir.exists() else []
        
        # Simple check - count test files
        return {
            "test_files_count": len(test_files),
            "screens_count": len(screens),
            "coverage_estimate": f"{min(100, len(test_files) * 10)}%"
        }
    
    def audit_all_modules_parallel(self):
        """Audit all modules in parallel"""
        data = self.load_extraction_data()
        
        modules = data.get('modules', {})
        screens = data.get('screens', [])
        widgets = data.get('widgets', [])
        
        print(f"\nAuditing all {len(modules)} modules in parallel...\n")
        
        # Use ThreadPoolExecutor for parallel processing
        with ThreadPoolExecutor(max_workers=8) as executor:
            futures = {
                executor.submit(
                    self.audit_module,
                    module_num,
                    module_data,
                    screens,
                    widgets
                ): module_num
                for module_num, module_data in modules.items()
            }
            
            for future in as_completed(futures):
                module_num = futures[future]
                try:
                    audit_result = future.result()
                    self.results[module_num] = audit_result
                    print(f"  ✅ Module {module_num} complete")
                except Exception as e:
                    print(f"  ❌ Module {module_num} error: {e}")
                    self.results[module_num] = {"error": str(e)}
        
        return self.results
    
    def save_results(self, output_file: str):
        """Save audit results"""
        output_path = self.root_dir / output_file
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(self.results, f, indent=2)
        print(f"\nResults saved to {output_path}")

if __name__ == "__main__":
    auditor = ParallelModuleAuditor(".")
    results = auditor.audit_all_modules_parallel()
    auditor.save_results("docs/parallel_audit_results.json")
    print("\nParallel audit complete!")

