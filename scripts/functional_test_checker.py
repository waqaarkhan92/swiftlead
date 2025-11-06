#!/usr/bin/env python3
"""
Functional Test Checker
Checks for dead buttons, broken flows, and missing functionality
"""

import re
from pathlib import Path
from typing import Dict, List

class FunctionalTestChecker:
    def __init__(self, root_dir: str):
        self.root_dir = Path(root_dir)
        self.code_dir = self.root_dir / "lib"
        self.issues = {
            "dead_buttons": [],
            "broken_navigation": [],
            "empty_handlers": [],
            "missing_error_handling": [],
            "missing_state_handling": [],
            "todo_comments": [],
        }
    
    def check_all_screens(self):
        """Check all screens for functional issues"""
        screens_dir = self.code_dir / "screens"
        
        for screen_file in screens_dir.rglob("*.dart"):
            if screen_file.name.endswith("_screen.dart"):
                self._check_screen(screen_file)
    
    def _check_screen(self, screen_file: Path):
        """Check a single screen for issues"""
        try:
            with open(screen_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            screen_name = screen_file.stem
            
            # Check for dead buttons
            self._check_dead_buttons(content, screen_name)
            
            # Check for broken navigation
            self._check_broken_navigation(content, screen_name)
            
            # Check for empty handlers
            self._check_empty_handlers(content, screen_name)
            
            # Check for missing error handling
            self._check_error_handling(content, screen_name)
            
            # Check for missing state handling
            self._check_state_handling(content, screen_name)
            
            # Check for TODO comments (potential issues)
            self._check_todos(content, screen_name)
            
        except Exception as e:
            self.issues["dead_buttons"].append({
                "screen": screen_file.name,
                "error": f"Could not read file: {str(e)}"
            })
    
    def _check_dead_buttons(self, content: str, screen_name: str):
        """Check for buttons with empty handlers"""
        # Pattern: onPressed: () {}
        empty_handler = r'on(?:Pressed|Tap):\s*\(\)\s*\{\s*\}'
        matches = re.finditer(empty_handler, content)
        
        for match in matches:
            # Get context (line number)
            line_num = content[:match.start()].count('\n') + 1
            self.issues["dead_buttons"].append({
                "screen": screen_name,
                "line": line_num,
                "issue": "Empty button handler",
                "code": match.group(0)
            })
        
        # Check for TODO in handlers
        todo_handler = r'on(?:Pressed|Tap):\s*\(\)\s*\{[^}]*//\s*TODO'
        matches = re.finditer(todo_handler, content)
        for match in matches:
            line_num = content[:match.start()].count('\n') + 1
            self.issues["dead_buttons"].append({
                "screen": screen_name,
                "line": line_num,
                "issue": "TODO in button handler",
                "code": match.group(0)[:100]
            })
    
    def _check_broken_navigation(self, content: str, screen_name: str):
        """Check for broken navigation paths"""
        # Find Navigator.push calls
        nav_pattern = r'Navigator\.push\([^)]+MaterialPageRoute\([^)]+builder:\s*\([^)]+\)\s*=>\s*(\w+)\([^)]*\)'
        matches = re.finditer(nav_pattern, content)
        
        for match in matches:
            target_screen = match.group(1)
            # Check if target screen file exists
            target_file = self.code_dir / "screens" / f"{target_screen.lower()}_screen.dart"
            if not target_file.exists():
                # Try to find it
                found = False
                for screen_file in (self.code_dir / "screens").rglob("*.dart"):
                    if screen_file.stem == target_screen.lower() or target_screen.lower() in screen_file.stem:
                        found = True
                        break
                
                if not found:
                    line_num = content[:match.start()].count('\n') + 1
                    self.issues["broken_navigation"].append({
                        "screen": screen_name,
                        "line": line_num,
                        "issue": f"Navigates to {target_screen} (not found)",
                        "target": target_screen
                    })
    
    def _check_empty_handlers(self, content: str, screen_name: str):
        """Check for empty handler methods"""
        # Pattern: void _handleSomething() {}
        empty_method = r'void\s+_handle\w+\([^)]*\)\s*\{\s*\}'
        matches = re.finditer(empty_method, content)
        
        for match in matches:
            method_name = re.search(r'_handle\w+', match.group(0))
            if method_name:
                line_num = content[:match.start()].count('\n') + 1
                self.issues["empty_handlers"].append({
                    "screen": screen_name,
                    "line": line_num,
                    "method": method_name.group(0),
                    "issue": "Empty handler method"
                })
    
    def _check_error_handling(self, content: str, screen_name: str):
        """Check for missing error handling"""
        # Check if screen has try-catch blocks
        has_try_catch = 'try {' in content and 'catch' in content
        
        # Check if screen has error state
        has_error_state = 'ErrorStateCard' in content or '_buildErrorState' in content or 'error' in content.lower()
        
        if not has_try_catch and not has_error_state:
            # Check if it needs error handling (has async operations)
            has_async = 'Future<void>' in content or 'async' in content
            if has_async:
                self.issues["missing_error_handling"].append({
                    "screen": screen_name,
                    "issue": "Has async operations but no error handling"
                })
    
    def _check_state_handling(self, content: str, screen_name: str):
        """Check for missing state handling"""
        has_loading = 'isLoading' in content or 'SkeletonLoader' in content or '_buildLoadingState' in content
        has_empty = 'EmptyStateCard' in content or '_buildEmptyState' in content
        has_error = 'ErrorStateCard' in content or '_buildErrorState' in content
        
        missing = []
        if not has_loading:
            missing.append("loading")
        if not has_empty:
            missing.append("empty")
        if not has_error:
            missing.append("error")
        
        if missing:
            self.issues["missing_state_handling"].append({
                "screen": screen_name,
                "missing_states": missing
            })
    
    def _check_todos(self, content: str, screen_name: str):
        """Check for TODO comments"""
        todos = re.findall(r'//\s*TODO[^\n]*', content)
        if todos:
            self.issues["todo_comments"].append({
                "screen": screen_name,
                "count": len(todos),
                "todos": todos[:5]  # First 5
            })
    
    def run_checks(self):
        """Run all functional checks"""
        print("Checking all screens for functional issues...")
        self.check_all_screens()
        
        # Summary
        total_issues = sum(len(v) for v in self.issues.values() if isinstance(v, list))
        print(f"\nFound {total_issues} potential issues:")
        print(f"  - Dead buttons: {len(self.issues['dead_buttons'])}")
        print(f"  - Broken navigation: {len(self.issues['broken_navigation'])}")
        print(f"  - Empty handlers: {len(self.issues['empty_handlers'])}")
        print(f"  - Missing error handling: {len(self.issues['missing_error_handling'])}")
        print(f"  - Missing state handling: {len(self.issues['missing_state_handling'])}")
        print(f"  - TODO comments: {len(self.issues['todo_comments'])}")
        
        return self.issues
    
    def save_results(self, output_file: str):
        """Save results to JSON"""
        import json
        output_path = self.root_dir / output_file
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(self.issues, f, indent=2)
        print(f"\nResults saved to {output_file}")

if __name__ == "__main__":
    checker = FunctionalTestChecker(".")
    issues = checker.run_checks()
    checker.save_results("docs/functional_test_issues.json")

