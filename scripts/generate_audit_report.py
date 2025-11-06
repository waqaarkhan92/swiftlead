#!/usr/bin/env python3
"""
Generate Human-Readable Audit Report from Matrices
Creates detailed markdown report for manual review
"""

import json
from pathlib import Path
from typing import Dict

class AuditReportGenerator:
    def __init__(self, root_dir: str):
        self.root_dir = Path(root_dir)
        self.matrices_file = self.root_dir / "docs" / "comparison_matrices.json"
        self.extraction_file = self.root_dir / "docs" / "enhanced_audit_extraction.json"
    
    def load_data(self) -> tuple:
        """Load matrices and extraction data"""
        with open(self.matrices_file, 'r', encoding='utf-8') as f:
            matrices = json.load(f)
        with open(self.extraction_file, 'r', encoding='utf-8') as f:
            extraction = json.load(f)
        return matrices, extraction
    
    def generate_module_report(self, module_num: str, matrix: Dict, module_data: Dict) -> str:
        """Generate markdown report for a single module"""
        lines = []
        
        # Header
        lines.append(f"## Module {module_num}: {module_data.get('name', 'Unknown')}\n")
        lines.append(f"**Purpose:** {module_data.get('purpose', 'N/A')}\n\n")
        
        # Statistics Summary
        stats = matrix.get('statistics', {})
        lines.append("### 📊 Summary Statistics\n\n")
        
        cap_stats = stats.get('capabilities', {})
        lines.append(f"- **Capabilities:** {cap_stats.get('implemented', 0)}/{cap_stats.get('total', 0)} implemented ({cap_stats.get('coverage', '0%')})")
        lines.append(f"- **Screens:** {stats.get('screens', {}).get('documented', 0)}/{stats.get('screens', {}).get('total', 0)} documented ({stats.get('screens', {}).get('coverage', '0%')})\n\n")
        
        # Specs → Code Audit
        lines.append("### 🔍 Specs → Code Audit\n\n")
        lines.append("#### Core Capabilities\n\n")
        lines.append("| Capability | Product Def | Code Implementation | Status | Evidence |\n")
        lines.append("|------------|-------------|----------------------|--------|----------|\n")
        
        specs_to_code = matrix.get('specs_to_code', {})
        for cap in specs_to_code.get('capabilities', []):
            status_emoji = {
                'IMPLEMENTED': '✅',
                'WIRED': '🔌',
                'MOCK': '🔄',
                'MISSING': '❌'
            }.get(cap.get('status', 'MISSING'), '❓')
            
            evidence = ', '.join(cap.get('evidence', [])[:2]) if cap.get('evidence') else 'None'
            if len(evidence) > 80:
                evidence = evidence[:77] + '...'
            
            lines.append(f"| {cap.get('capability', 'N/A')} | ✅ | {'✅' if cap.get('found_in_code') else '❌'} | {status_emoji} {cap.get('status', 'MISSING')} | {evidence} |\n")
        
        lines.append("\n")
        
        # Code → Specs Audit
        lines.append("### 📝 Code → Specs Audit\n\n")
        lines.append("#### Screens in Code\n\n")
        lines.append("| Screen | Code File | In Specs? | Implementation Status |\n")
        lines.append("|--------|-----------|-----------|----------------------|\n")
        
        code_to_specs = matrix.get('code_to_specs', {})
        for screen in code_to_specs.get('screens', []):
            in_specs = '✅' if screen.get('found_in_specs') else '❌'
            impl = screen.get('implementation', {})
            
            # Determine implementation status
            if impl.get('api_calls_count', 0) > 0:
                impl_status = '🔌 Wired'
            elif impl.get('has_mock_data', False):
                impl_status = '🔄 Mock'
            elif impl.get('has_stateful', False):
                impl_status = '✅ Implemented'
            else:
                impl_status = '⚠️ Basic'
            
            lines.append(f"| {screen.get('screen', 'N/A')} | `{screen.get('path', 'N/A')}` | {in_specs} | {impl_status} |\n")
        
        lines.append("\n")
        
        # Gaps & Issues
        lines.append("### ⚠️ Gaps & Issues\n\n")
        
        # Missing capabilities
        missing_caps = [c for c in specs_to_code.get('capabilities', []) 
                       if c.get('status') == 'MISSING']
        if missing_caps:
            lines.append("#### Missing from Code:\n")
            for cap in missing_caps[:5]:  # Top 5
                lines.append(f"- ❌ **{cap.get('capability')}**: Not implemented\n")
            lines.append("\n")
        
        # Undocumented screens
        undocumented = [s for s in code_to_specs.get('screens', []) 
                       if not s.get('found_in_specs')]
        if undocumented:
            lines.append("#### Undocumented Screens:\n")
            for screen in undocumented[:5]:  # Top 5
                lines.append(f"- ⚠️ **{screen.get('screen')}**: Exists in code but not found in specs\n")
            lines.append("\n")
        
        # Implementation Notes
        lines.append("### 📋 Implementation Notes\n\n")
        lines.append("- ⚠️ **Testing Status:** Not yet audited\n")
        lines.append("- ⚠️ **Wiring Status:** See individual capability status\n")
        lines.append("- ⚠️ **Manual Review:** Required for detailed verification\n\n")
        
        lines.append("---\n\n")
        
        return ''.join(lines)
    
    def generate_full_report(self) -> str:
        """Generate complete audit report"""
        matrices, extraction = self.load_data()
        
        lines = []
        
        # Header
        lines.append("# Comprehensive Frontend Audit Report\n\n")
        lines.append("**Generated:** 2025-11-05\n")
        lines.append("**Purpose:** Complete audit of specs vs code, code vs specs, testing status, and wiring status\n\n")
        lines.append("---\n\n")
        
        # Executive Summary
        lines.append("## 📊 Executive Summary\n\n")
        
        total_modules = len(matrices)
        total_capabilities = sum(
            m.get('statistics', {}).get('capabilities', {}).get('total', 0)
            for m in matrices.values()
        )
        total_implemented = sum(
            m.get('statistics', {}).get('capabilities', {}).get('implemented', 0)
            for m in matrices.values()
        )
        total_screens = sum(
            m.get('statistics', {}).get('screens', {}).get('total', 0)
            for m in matrices.values()
        )
        
        lines.append(f"- **Total Modules:** {total_modules}\n")
        lines.append(f"- **Total Capabilities:** {total_capabilities}\n")
        if total_capabilities > 0:
            lines.append(f"- **Implemented Capabilities:** {total_implemented} ({total_implemented/total_capabilities*100:.1f}%)\n")
        else:
            lines.append(f"- **Implemented Capabilities:** {total_implemented} (N/A)\n")
        lines.append(f"- **Total Screens:** {total_screens}\n\n")
        
        lines.append("### 🎯 Overall Status\n\n")
        lines.append("- ✅ **Specs → Code:** Capability comparison complete\n")
        lines.append("- ✅ **Code → Specs:** Screen documentation check complete\n")
        lines.append("- ⚠️ **Testing Status:** Not yet audited\n")
        lines.append("- ⚠️ **Wiring Status:** Partial (see individual modules)\n\n")
        
        lines.append("---\n\n")
        
        # Module-by-Module Reports
        lines.append("## 📋 Module-by-Module Audit\n\n")
        
        modules_data = extraction.get('modules', {})
        for module_num in sorted(matrices.keys(), key=int):
            matrix = matrices[module_num]
            module_data = modules_data.get(module_num, {})
            module_report = self.generate_module_report(module_num, matrix, module_data)
            lines.append(module_report)
        
        # Next Steps
        lines.append("## 🚀 Next Steps\n\n")
        lines.append("### Immediate Actions:\n")
        lines.append("1. **Manual Review:** Review each module's gaps and issues\n")
        lines.append("2. **Testing Audit:** Verify testing status for each feature\n")
        lines.append("3. **Wiring Audit:** Identify what needs backend integration\n")
        lines.append("4. **Documentation:** Document any undocumented screens\n")
        lines.append("5. **Implementation:** Prioritize missing capabilities\n\n")
        
        lines.append("### Review Priority:\n")
        lines.append("1. **High Priority:** Modules with >20% missing capabilities\n")
        lines.append("2. **Medium Priority:** Modules with undocumented screens\n")
        lines.append("3. **Low Priority:** Modules with minor gaps\n\n")
        
        return ''.join(lines)
    
    def save_report(self, report: str, output_file: str):
        """Save report to markdown file"""
        output_path = self.root_dir / output_file
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(report)
        print(f"\nReport saved to {output_path}")

if __name__ == "__main__":
    generator = AuditReportGenerator(".")
    report = generator.generate_full_report()
    generator.save_report(report, "docs/COMPREHENSIVE_AUDIT_REPORT.md")
    print("\nAudit report generated!")
