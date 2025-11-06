#!/usr/bin/env python3
"""
Generate Detailed Comparison Matrices
Compares specs vs code and code vs specs for comprehensive audit
"""

import json
import re
from pathlib import Path
from typing import Dict, List

class ComparisonMatrixGenerator:
    def __init__(self, root_dir: str):
        self.root_dir = Path(root_dir)
        self.extraction_file = self.root_dir / "docs" / "enhanced_audit_extraction.json"
        self.results = {}
    
    def load_extraction_data(self) -> Dict:
        """Load enhanced extraction data"""
        with open(self.extraction_file, 'r', encoding='utf-8') as f:
            return json.load(f)
    
    def find_screens_for_module(self, module_num: str, screens: List) -> List:
        """Find all screens belonging to a module"""
        return [s for s in screens if s.get('module') == module_num]
    
    def find_widgets_for_module(self, module_num: str, widgets: List, module_name: str) -> List:
        """Find widgets that might belong to a module (by name matching)"""
        # Simple heuristic: match widget names/categories with module keywords
        module_keywords = module_name.lower().split()
        relevant_widgets = []
        
        for widget in widgets:
            widget_name = widget.get('name', '').lower()
            widget_path = widget.get('path', '').lower()
            
            # Check if widget name or path contains module keywords
            for keyword in module_keywords:
                if keyword in widget_name or keyword in widget_path:
                    relevant_widgets.append(widget)
                    break
        
        return relevant_widgets
    
    def compare_capabilities_to_code(self, capabilities: List, screens: List) -> Dict:
        """Compare spec capabilities to code implementation"""
        comparison = []
        
        for capability in capabilities:
            cap_name = capability.get('name', '')
            cap_desc = capability.get('description', '')
            
            # Check if capability exists in code
            found_in_code = False
            implementation_status = "MISSING"
            evidence = []
            
            # Search screens for capability indicators
            for screen in screens:
                screen_name = screen.get('name', '').lower()
                features = screen.get('features', {})
                widget_methods = features.get('widget_methods', [])
                action_methods = features.get('action_methods', [])
                
                # Check if capability keywords appear in screen
                cap_keywords = cap_name.lower().split()
                for keyword in cap_keywords:
                    if keyword in screen_name:
                        found_in_code = True
                        evidence.append(f"Screen: {screen.get('name')}")
                        break
                    
                    # Check widget methods
                    for method in widget_methods:
                        if keyword in method.lower():
                            found_in_code = True
                            evidence.append(f"Method: {method} in {screen.get('name')}")
                            break
                    
                    # Check action methods
                    for method in action_methods:
                        if keyword in method.lower():
                            found_in_code = True
                            evidence.append(f"Action: {method} in {screen.get('name')}")
                            break
            
            if found_in_code:
                # Check implementation status
                impl = screen.get('implementation', {})
                if impl.get('api_calls_count', 0) > 0:
                    implementation_status = "WIRED"
                elif impl.get('has_mock_data', False):
                    implementation_status = "MOCK"
                else:
                    implementation_status = "IMPLEMENTED"
            
            comparison.append({
                "capability": cap_name,
                "description": cap_desc,
                "status": implementation_status,
                "found_in_code": found_in_code,
                "evidence": evidence[:3],  # Limit to 3 items
            })
        
        return comparison
    
    def compare_screens_to_specs(self, screens: List, module_data: Dict) -> Dict:
        """Compare code screens to specs"""
        comparison = []
        
        for screen in screens:
            screen_name = screen.get('name', '')
            screen_path = screen.get('path', '')
            
            # Check if screen is documented in specs
            found_in_specs = False
            spec_reference = ""
            
            # Search module data for screen references
            module_name = module_data.get('name', '').lower()
            module_keywords = module_name.split()
            
            # Check if screen name matches module keywords
            screen_keywords = screen_name.replace('_', ' ').split()
            if any(kw in screen_keywords for kw in module_keywords):
                found_in_specs = True
                spec_reference = f"Module {module_data.get('number')}: {module_data.get('name')}"
            
            # Check capabilities for screen references
            capabilities = module_data.get('core_capabilities', [])
            for cap in capabilities:
                cap_name = cap.get('name', '').lower()
                if any(kw in cap_name for kw in screen_keywords):
                    found_in_specs = True
                    spec_reference = f"Capability: {cap.get('name')}"
                    break
            
            comparison.append({
                "screen": screen_name,
                "path": screen_path,
                "found_in_specs": found_in_specs,
                "spec_reference": spec_reference,
                "implementation": screen.get('implementation', {}),
            })
        
        return comparison
    
    def generate_module_matrix(self, module_num: str, module_data: Dict, 
                               screens: List, widgets: List) -> Dict:
        """Generate comparison matrix for a single module"""
        
        # Use features as capabilities if core_capabilities is empty
        capabilities = module_data.get('core_capabilities', [])
        if not capabilities:
            # Fallback: extract from features list
            features = module_data.get('features', [])
            for feature in features[:20]:  # Limit to first 20
                # Extract capability name from feature string (format: **Name:** Description)
                match = re.match(r'\*\*(.+?)\*\*:\s*(.+)', feature)
                if match:
                    capabilities.append({
                        "name": match.group(1).strip(),
                        "description": match.group(2).strip()
                    })
        
        # Specs → Code
        specs_to_code = {
            "capabilities": self.compare_capabilities_to_code(
                capabilities,
                screens
            ),
            "interactions": [],  # TODO: Implement interaction comparison
            "ui_components": [],  # TODO: Implement UI component comparison
        }
        
        # Code → Specs
        code_to_specs = {
            "screens": self.compare_screens_to_specs(screens, module_data),
            "widgets": [],  # TODO: Implement widget comparison
        }
        
        # Calculate statistics
        capabilities_count = len(module_data.get('core_capabilities', []))
        implemented_count = sum(1 for c in specs_to_code['capabilities'] 
                              if c['status'] in ['IMPLEMENTED', 'WIRED', 'MOCK'])
        missing_count = sum(1 for c in specs_to_code['capabilities'] 
                          if c['status'] == 'MISSING')
        
        screens_count = len(screens)
        documented_screens = sum(1 for s in code_to_specs['screens'] 
                               if s['found_in_specs'])
        undocumented_screens = screens_count - documented_screens
        
        return {
            "module_number": module_num,
            "module_name": module_data.get('name', ''),
            "specs_to_code": specs_to_code,
            "code_to_specs": code_to_specs,
            "statistics": {
                "capabilities": {
                    "total": capabilities_count,
                    "implemented": implemented_count,
                    "missing": missing_count,
                    "coverage": f"{(implemented_count/capabilities_count*100):.1f}%" if capabilities_count > 0 else "0%"
                },
                "screens": {
                    "total": screens_count,
                    "documented": documented_screens,
                    "undocumented": undocumented_screens,
                    "coverage": f"{(documented_screens/screens_count*100):.1f}%" if screens_count > 0 else "0%"
                }
            }
        }
    
    def generate_all_matrices(self):
        """Generate comparison matrices for all modules"""
        data = self.load_extraction_data()
        
        modules = data.get('modules', {})
        screens = data.get('screens', [])
        widgets = data.get('widgets', [])
        
        matrices = {}
        
        for module_num in sorted(modules.keys(), key=int):
            module_data = modules[module_num]
            module_screens = self.find_screens_for_module(module_num, screens)
            module_widgets = self.find_widgets_for_module(
                module_num, widgets, module_data.get('name', '')
            )
            
            print(f"Generating matrix for Module {module_num}: {module_data.get('name')}...")
            matrix = self.generate_module_matrix(
                module_num,
                module_data,
                module_screens,
                module_widgets
            )
            matrices[module_num] = matrix
        
        return matrices
    
    def save_matrices(self, matrices: Dict, output_file: str):
        """Save matrices to JSON"""
        output_path = self.root_dir / output_file
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(matrices, f, indent=2)
        print(f"\nMatrices saved to {output_path}")

if __name__ == "__main__":
    generator = ComparisonMatrixGenerator(".")
    matrices = generator.generate_all_matrices()
    generator.save_matrices(matrices, "docs/comparison_matrices.json")
    print("\nComparison matrices generated!")

