#!/usr/bin/env python3
"""
Enhanced Frontend Audit Extractor
Extracts detailed features, capabilities, interactions, and backend requirements from specs
"""

import os
import re
import json
from pathlib import Path
from typing import Dict, List, Set

class EnhancedAuditExtractor:
    def __init__(self, root_dir: str):
        self.root_dir = Path(root_dir)
        self.specs_dir = self.root_dir / "docs" / "specs"
        self.code_dir = self.root_dir / "lib"
        self.results = {
            "modules": {},
            "screens": [],
            "widgets": [],
            "models": [],
            "extraction_metadata": {}
        }
    
    def extract_detailed_modules_from_specs(self):
        """Extract detailed module information from Product Definition"""
        product_def = self.specs_dir / "Product_Definition_v2.5.1_10of10.md"
        if not product_def.exists():
            return {}
        
        modules = {}
        
        with open(product_def, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Find all module sections (### 3.X)
        module_pattern = r'^### 3\.(\d+)\s+(.+?)$'
        matches = list(re.finditer(module_pattern, content, re.MULTILINE))
        
        for i, match in enumerate(matches):
            module_num = match.group(1)
            module_name = match.group(2).strip()
            
            # Get section content (until next module or end)
            start_pos = match.end()
            if i + 1 < len(matches):
                end_pos = matches[i + 1].start()
            else:
                end_pos = len(content)
            
            section_content = content[start_pos:end_pos]
            
            modules[module_num] = {
                "number": module_num,
                "name": module_name,
                "purpose": self._extract_purpose(section_content),
                "core_capabilities": self._extract_core_capabilities(section_content),
                "features": self._extract_features(section_content),
                "interactions": self._extract_interactions(section_content),
                "ui_components": self._extract_ui_components(section_content),
                "enhancements": self._extract_enhancements(section_content),
                "future_features": self._extract_future_features(section_content),
                "automations": self._extract_automations(section_content),
            }
        
        return modules
    
    def _extract_purpose(self, content: str) -> str:
        """Extract purpose statement"""
        purpose_match = re.search(r'\*\*Purpose:\*\*(.+?)(?=\n\n|\*\*|$)', content, re.DOTALL)
        if purpose_match:
            return purpose_match.group(1).strip()
        return ""
    
    def _extract_core_capabilities(self, content: str) -> List[str]:
        """Extract core capabilities list"""
        capabilities = []
        # Look for "Core Capabilities:" section
        capabilities_match = re.search(r'\*\*Core Capabilities:\*\*(.*?)(?=\*\*|🆕|🔮|\*\*Interactions|\*\*UI|\*\*Automations|$)', content, re.DOTALL)
        if capabilities_match:
            cap_section = capabilities_match.group(1)
            # Extract bullet points - handle nested bullets
            # Pattern: - **Name:** Description (may span multiple lines until next - ** or empty line)
            pattern = r'^- \*\*(.+?)\*\*:\s*((?:[^\n]|\n(?!- \*\*|\n\n))+?)(?=\n- \*\*|\n\n|\Z)'
            bullets = re.findall(pattern, cap_section, re.MULTILINE | re.DOTALL)
            for bullet in bullets:
                cap_name = bullet[0].strip()
                cap_desc = bullet[1].strip() if len(bullet) > 1 else ""
                # Clean up description (remove extra whitespace, handle nested bullets)
                cap_desc = re.sub(r'\n\s+-', ' -', cap_desc)  # Convert nested bullets to inline
                cap_desc = ' '.join(cap_desc.split())  # Normalize whitespace
                capabilities.append({
                    "name": cap_name,
                    "description": cap_desc
                })
        
        # If no capabilities found, try using features list as fallback
        if not capabilities:
            features = self._extract_features(content)
            for feature in features[:15]:  # Limit to first 15
                # Extract capability name from feature string
                match = re.match(r'\*\*(.+?)\*\*:', feature)
                if match:
                    capabilities.append({
                        "name": match.group(1).strip(),
                        "description": feature.replace(match.group(0), '').strip()
                    })
        
        return capabilities
    
    def _extract_features(self, content: str) -> List[str]:
        """Extract feature list"""
        features = []
        # Look for numbered or bulleted feature lists
        feature_pattern = r'^[-*]\s+(.+?)(?=\n[-*] |\n\n|\Z)'
        matches = re.finditer(feature_pattern, content, re.MULTILINE)
        for match in matches:
            feature = match.group(1).strip()
            if feature and len(feature) > 10:  # Filter out very short items
                features.append(feature)
        return features[:20]  # Limit to first 20 to avoid noise
    
    def _extract_interactions(self, content: str) -> List[str]:
        """Extract interaction patterns"""
        interactions = []
        # Look for "Interactions:" section
        interactions_match = re.search(r'\*\*Interactions?:\*\*(.*?)(?=\*\*|$)', content, re.DOTALL)
        if interactions_match:
            inter_section = interactions_match.group(1)
            bullets = re.findall(r'^-\s+(.+?)(?=\n- |\n\n|\Z)', inter_section, re.MULTILINE)
            for bullet in bullets:
                interactions.append(bullet.strip())
        return interactions
    
    def _extract_ui_components(self, content: str) -> List[str]:
        """Extract UI component references"""
        components = []
        # Look for "UI Components:" or "UI Enhancements:" section
        ui_match = re.search(r'\*\*UI\s+(?:Components|Enhancements?):\*\*(.*?)(?=\*\*|$)', content, re.DOTALL)
        if ui_match:
            ui_section = ui_match.group(1)
            # Extract component names (usually capitalized CamelCase)
            component_names = re.findall(r'\b([A-Z][a-zA-Z0-9]+)\b', ui_section)
            components.extend(component_names)
        return list(set(components))  # Remove duplicates
    
    def _extract_enhancements(self, content: str) -> List[str]:
        """Extract v2.5.1 enhancements"""
        enhancements = []
        # Look for enhancement sections
        enh_match = re.search(r'🆕\s+v2\.5\.1\s+Enhancements?:(.*?)(?=🔮|🆕|\*\*|$)', content, re.DOTALL)
        if enh_match:
            enh_section = enh_match.group(1)
            bullets = re.findall(r'^-\s+\*\*(.+?)\*\*:?\s*(.+?)(?=\n- |\n\n|\Z)', enh_section, re.MULTILINE)
            for bullet in bullets:
                enhancements.append({
                    "name": bullet[0].strip(),
                    "description": bullet[1].strip() if len(bullet) > 1 else ""
                })
        return enhancements
    
    def _extract_future_features(self, content: str) -> List[str]:
        """Extract future features"""
        future = []
        # Look for future features section
        future_match = re.search(r'🔮\s+Future\s+Features?:(.*?)(?=🔮|🆕|\*\*|$)', content, re.DOTALL)
        if future_match:
            future_section = future_match.group(1)
            bullets = re.findall(r'^-\s+\*\*(.+?)\*\*:?\s*(.+?)(?=\n- |\n\n|\Z)', future_section, re.MULTILINE)
            for bullet in bullets:
                future.append({
                    "name": bullet[0].strip(),
                    "description": bullet[1].strip() if len(bullet) > 1 else ""
                })
        return future
    
    def _extract_automations(self, content: str) -> List[str]:
        """Extract automation patterns"""
        automations = []
        # Look for "Automations:" section
        auto_match = re.search(r'\*\*Automations?:\*\*(.*?)(?=\*\*|$)', content, re.DOTALL)
        if auto_match:
            auto_section = auto_match.group(1)
            bullets = re.findall(r'^-\s+(.+?)(?=\n- |\n\n|\Z)', auto_section, re.MULTILINE)
            for bullet in bullets:
                automations.append(bullet.strip())
        return automations
    
    def extract_screens_from_code(self):
        """Extract all screens with detailed information"""
        screens_dir = self.code_dir / "screens"
        if not screens_dir.exists():
            return []
        
        screens = []
        for screen_file in screens_dir.rglob("*.dart"):
            if screen_file.name.endswith("_screen.dart") or screen_file.name == "main_navigation.dart":
                screen_info = self._analyze_screen_file(screen_file)
                screens.append(screen_info)
        
        return screens
    
    def _analyze_screen_file(self, screen_file: Path) -> Dict:
        """Analyze a screen file for detailed information"""
        rel_path = screen_file.relative_to(self.code_dir)
        
        try:
            with open(screen_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Extract class name
            class_match = re.search(r'class\s+(\w+Screen)', content)
            class_name = class_match.group(1) if class_match else screen_file.stem
            
            # Extract features (widget builders and handlers)
            widget_methods = re.findall(r'Widget\s+(_build\w+)\([^)]*\)', content)
            action_methods = re.findall(r'void\s+(_handle\w+)\([^)]*\)', content)
            private_methods = re.findall(r'void\s+(_\w+)\([^)]*\)', content)
            
            # Check for state management
            has_stateful = "StatefulWidget" in content or "extends State" in content
            has_setstate = "setState" in content
            
            # Check for state handling
            has_loading = "isLoading" in content or "SkeletonLoader" in content or "_buildLoadingState" in content
            has_empty = "EmptyStateCard" in content or "_buildEmptyState" in content or "isEmpty" in content
            has_error = "error" in content.lower() or "ErrorStateCard" in content or "_buildErrorState" in content
            
            # Check for navigation
            has_navigation = "Navigator" in content or "Navigator.push" in content
            
            # Check for API calls
            api_calls = len(re.findall(r'await\s+\w+\.(fetch|get|post|put|delete|patch)', content))
            
            # Check for mock data
            has_mock = "Mock" in content or "mock" in content.lower() or "TODO.*backend" in content
            
            # Check for backend integration comments
            backend_notes = re.findall(r'#.*backend|//.*backend|/\*.*backend', content, re.IGNORECASE)
            
            # Extract imports
            imports = re.findall(r'^import\s+[\'"].+?[\'"];', content, re.MULTILINE)
            
            return {
                "path": str(rel_path),
                "name": screen_file.stem,
                "class_name": class_name,
                "module": self._infer_module(screen_file),
                "features": {
                    "widget_methods": widget_methods,
                    "action_methods": action_methods,
                    "private_methods": list(set(private_methods))[:10],  # Limit
                },
                "implementation": {
                    "has_stateful": has_stateful,
                    "has_setstate": has_setstate,
                    "has_loading_state": has_loading,
                    "has_empty_state": has_empty,
                    "has_error_state": has_error,
                    "has_navigation": has_navigation,
                    "api_calls_count": api_calls,
                    "has_mock_data": has_mock,
                    "backend_notes": len(backend_notes) > 0,
                },
                "imports_count": len(imports),
            }
        except Exception as e:
            return {
                "path": str(rel_path),
                "name": screen_file.stem,
                "error": str(e)
            }
    
    def _infer_module(self, screen_file: Path) -> str:
        """Infer module from file path"""
        parent = screen_file.parent.name
        module_map = {
            "inbox": "3.1",
            "ai_hub": "3.11",
            "jobs": "3.3",
            "calendar": "3.4",
            "money": "3.5",
            "quotes": "3.5",
            "contacts": "3.6",
            "reviews": "3.7",
            "notifications": "3.8",
            "settings": "3.12",
            "home": "3.10",
            "onboarding": "3.14",
            "reports": "3.16",
            "support": "unknown",
            "legal": "unknown",
        }
        return module_map.get(parent, "unknown")
    
    def extract_widgets_from_code(self):
        """Extract widgets with usage information"""
        widgets_dir = self.code_dir / "widgets"
        if not widgets_dir.exists():
            return []
        
        widgets = []
        for widget_file in widgets_dir.rglob("*.dart"):
            widget_info = self._analyze_widget_file(widget_file)
            widgets.append(widget_info)
        
        return widgets
    
    def _analyze_widget_file(self, widget_file: Path) -> Dict:
        """Analyze a widget file"""
        rel_path = widget_file.relative_to(self.code_dir)
        
        try:
            with open(widget_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Extract class name
            class_match = re.search(r'class\s+(\w+)', content)
            class_name = class_match.group(1) if class_match else widget_file.stem
            
            # Check if it's a StatelessWidget or StatefulWidget
            is_stateless = "StatelessWidget" in content
            is_stateful = "StatefulWidget" in content
            
            return {
                "path": str(rel_path),
                "name": widget_file.stem,
                "class_name": class_name,
                "category": self._infer_widget_category(widget_file),
                "type": "StatelessWidget" if is_stateless else ("StatefulWidget" if is_stateful else "Unknown"),
            }
        except Exception as e:
            return {
                "path": str(rel_path),
                "name": widget_file.stem,
                "error": str(e)
            }
    
    def _infer_widget_category(self, widget_file: Path) -> str:
        """Infer widget category from path"""
        parts = widget_file.parts
        if len(parts) > 2:
            return parts[-2]  # e.g., "global", "components", "forms"
        return "unknown"
    
    def extract_models_from_code(self):
        """Extract models with field information"""
        models_dir = self.code_dir / "models"
        if not models_dir.exists():
            return []
        
        models = []
        for model_file in models_dir.rglob("*.dart"):
            model_info = self._analyze_model_file(model_file)
            models.append(model_info)
        
        return models
    
    def _analyze_model_file(self, model_file: Path) -> Dict:
        """Analyze a model file"""
        rel_path = model_file.relative_to(self.code_dir)
        
        try:
            with open(model_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Extract class name
            class_match = re.search(r'class\s+(\w+)', content)
            class_name = class_match.group(1) if class_match else model_file.stem
            
            # Extract fields (basic extraction)
            fields = re.findall(r'final\s+(\w+)\s+(\w+);', content)
            
            return {
                "path": str(rel_path),
                "name": model_file.stem,
                "class_name": class_name,
                "fields": [{"type": f[0], "name": f[1]} for f in fields],
            }
        except Exception as e:
            return {
                "path": str(rel_path),
                "name": model_file.stem,
                "error": str(e)
            }
    
    def run_extraction(self):
        """Run all extraction methods"""
        print("Extracting detailed modules from specs...")
        self.results["modules"] = self.extract_detailed_modules_from_specs()
        
        print("Extracting detailed screens from code...")
        self.results["screens"] = self.extract_screens_from_code()
        
        print("Extracting widgets from code...")
        self.results["widgets"] = self.extract_widgets_from_code()
        
        print("Extracting models from code...")
        self.results["models"] = self.extract_models_from_code()
        
        # Add metadata
        self.results["extraction_metadata"] = {
            "modules_count": len(self.results["modules"]),
            "screens_count": len(self.results["screens"]),
            "widgets_count": len(self.results["widgets"]),
            "models_count": len(self.results["models"]),
        }
        
        return self.results
    
    def save_results(self, output_file: str):
        """Save extraction results to JSON"""
        output_path = self.root_dir / output_file
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(self.results, f, indent=2)
        print(f"\nResults saved to {output_path}")

if __name__ == "__main__":
    extractor = EnhancedAuditExtractor(".")
    results = extractor.run_extraction()
    extractor.save_results("docs/enhanced_audit_extraction.json")
    print(f"\nEnhanced extraction complete!")
    print(f"Modules: {results['extraction_metadata']['modules_count']}")
    print(f"Screens: {results['extraction_metadata']['screens_count']}")
    print(f"Widgets: {results['extraction_metadata']['widgets_count']}")
    print(f"Models: {results['extraction_metadata']['models_count']}")

