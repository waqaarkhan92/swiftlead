#!/usr/bin/env python3
"""
Alignment Analyzer - Compare specification and implementation inventories
"""

import json
import re
from typing import Dict, List, Set
from difflib import SequenceMatcher

def normalize_name(name: str) -> str:
    """Normalize name for comparison"""
    return re.sub(r'[^a-z0-9]', '', name.lower())

def similarity_ratio(a: str, b: str) -> float:
    """Calculate similarity between two strings"""
    return SequenceMatcher(None, normalize_name(a), normalize_name(b)).ratio()

def extract_module_from_path(path: str) -> str:
    """Extract module name from file path"""
    parts = path.split('/')
    if 'lib' in parts:
        idx = parts.index('lib')
        if idx + 1 < len(parts):
            return parts[idx + 1]
    return ''

def find_matching_code_items(spec_item: Dict, code_items: List[Dict]) -> List[Dict]:
    """Find code items that match a spec item"""
    matches = []
    spec_name = spec_item['name']
    spec_module = spec_item.get('module', '')
    expected_files = spec_item.get('expectedFiles', [])

    for code_item in code_items:
        score = 0
        reasons = []

        # Check file path matching
        if expected_files:
            for expected_file in expected_files:
                if code_item['file'] in expected_file or expected_file in f"lib/{code_item['file']}":
                    score += 50
                    reasons.append(f"file_match:{expected_file}")
                    break

        # Check module matching
        code_module = extract_module_from_path(code_item['file'])
        if code_module and spec_module and code_module == spec_module:
            score += 20
            reasons.append(f"module_match:{spec_module}")

        # Check name similarity
        code_desc = code_item.get('description', '')
        code_classes = ' '.join(code_item.get('classNames', []))

        name_sim = max(
            similarity_ratio(spec_name, code_desc),
            similarity_ratio(spec_name, code_classes),
            max([similarity_ratio(spec_name, cls) for cls in code_item.get('classNames', [])] or [0])
        )

        if name_sim > 0.6:
            score += int(name_sim * 30)
            reasons.append(f"name_sim:{name_sim:.2f}")

        if score > 30:  # Threshold for considering it a match
            matches.append({
                'code_item': code_item,
                'score': score,
                'reasons': reasons
            })

    # Sort by score descending
    matches.sort(key=lambda x: x['score'], reverse=True)
    return matches

def analyze_alignment(spec_path: str, code_path: str):
    """Perform bidirectional alignment analysis"""

    # Load data
    with open(spec_path, 'r') as f:
        spec_items = json.load(f)

    with open(code_path, 'r') as f:
        code_items = json.load(f)

    alignment_matrix = []
    matched_code_indices = set()

    # Process each spec item
    for spec_item in spec_items:
        matches = find_matching_code_items(spec_item, code_items)

        if not matches:
            # Not implemented
            alignment_matrix.append({
                'name': spec_item['name'],
                'module': spec_item.get('module', 'unknown'),
                'category': spec_item.get('category', 'unknown'),
                'status': 'not_implemented',
                'source': 'spec',
                'expectedFiles': spec_item.get('expectedFiles', []),
                'actualFiles': [],
                'priority': spec_item.get('priority', 'unknown'),
                'notes': 'No matching implementation found in codebase'
            })
        else:
            best_match = matches[0]
            code_item = best_match['code_item']
            code_idx = code_items.index(code_item)
            matched_code_indices.add(code_idx)

            expected_files = spec_item.get('expectedFiles', [])
            actual_file = f"lib/{code_item['file']}"

            # Check if files align
            files_aligned = any(expected in actual_file or actual_file.endswith(expected.split('/')[-1])
                               for expected in expected_files)

            if files_aligned or best_match['score'] > 60:
                status = 'implemented'
                notes = f"Match confidence: {best_match['score']}%. Reasons: {', '.join(best_match['reasons'])}"
            else:
                status = 'misaligned'
                notes = f"Implementation found but file path mismatch. Match confidence: {best_match['score']}%. Reasons: {', '.join(best_match['reasons'])}"

            alignment_matrix.append({
                'name': spec_item['name'],
                'module': spec_item.get('module', 'unknown'),
                'category': spec_item.get('category', 'unknown'),
                'status': status,
                'source': 'spec',
                'expectedFiles': expected_files,
                'actualFiles': [actual_file],
                'priority': spec_item.get('priority', 'unknown'),
                'notes': notes,
                'matchScore': best_match['score']
            })

    # Process untracked code items (not in spec)
    for idx, code_item in enumerate(code_items):
        if idx not in matched_code_indices:
            alignment_matrix.append({
                'name': code_item.get('description', '') or ' / '.join(code_item.get('classNames', [])),
                'module': extract_module_from_path(code_item['file']),
                'category': code_item.get('category', 'unknown'),
                'status': 'untracked',
                'source': 'code',
                'expectedFiles': [],
                'actualFiles': [f"lib/{code_item['file']}"],
                'priority': 'unknown',
                'notes': f"Code exists but not documented in specification. Categories: {code_item.get('category', 'unknown')}"
            })

    return alignment_matrix

def generate_statistics(alignment_matrix: List[Dict]) -> Dict:
    """Generate statistics from alignment matrix"""

    stats = {
        'total_spec_items': sum(1 for item in alignment_matrix if item['source'] == 'spec'),
        'total_code_items': sum(1 for item in alignment_matrix if item['source'] == 'code'),
        'implemented': sum(1 for item in alignment_matrix if item['status'] == 'implemented'),
        'not_implemented': sum(1 for item in alignment_matrix if item['status'] == 'not_implemented'),
        'misaligned': sum(1 for item in alignment_matrix if item['status'] == 'misaligned'),
        'untracked': sum(1 for item in alignment_matrix if item['status'] == 'untracked'),
    }

    # Calculate percentages
    if stats['total_spec_items'] > 0:
        stats['implementation_percentage'] = round(
            (stats['implemented'] / stats['total_spec_items']) * 100, 1
        )
        stats['alignment_percentage'] = round(
            ((stats['implemented']) / stats['total_spec_items']) * 100, 1
        )

    # By module
    modules = {}
    for item in alignment_matrix:
        module = item['module']
        if module not in modules:
            modules[module] = {
                'total': 0,
                'implemented': 0,
                'not_implemented': 0,
                'misaligned': 0,
                'untracked': 0
            }

        modules[module]['total'] += 1
        modules[module][item['status']] += 1

    stats['by_module'] = modules

    # By priority
    priorities = {}
    for item in alignment_matrix:
        if item['source'] == 'spec':
            priority = item['priority']
            if priority not in priorities:
                priorities[priority] = {
                    'total': 0,
                    'implemented': 0,
                    'not_implemented': 0,
                    'misaligned': 0
                }

            priorities[priority]['total'] += 1
            if item['status'] in priorities[priority]:
                priorities[priority][item['status']] += 1

    stats['by_priority'] = priorities

    # By category
    categories = {}
    for item in alignment_matrix:
        category = item['category']
        if category not in categories:
            categories[category] = {
                'total': 0,
                'implemented': 0,
                'not_implemented': 0,
                'misaligned': 0,
                'untracked': 0
            }

        categories[category]['total'] += 1
        categories[category][item['status']] += 1

    stats['by_category'] = categories

    return stats

def generate_markdown_report(alignment_matrix: List[Dict], stats: Dict) -> str:
    """Generate human-readable markdown report"""

    md = []
    md.append("# Specification-Code Alignment Report")
    md.append("")
    md.append(f"**Generated:** {__import__('datetime').datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    md.append("")

    # Executive Summary
    md.append("## Executive Summary")
    md.append("")
    md.append(f"- **Total Specification Items:** {stats['total_spec_items']}")
    md.append(f"- **Total Code Items:** {stats['total_code_items']}")
    md.append(f"- **Implementation Coverage:** {stats.get('implementation_percentage', 0)}%")
    md.append(f"- **Alignment Score:** {stats.get('alignment_percentage', 0)}%")
    md.append("")

    # Status Breakdown
    md.append("## Status Breakdown")
    md.append("")
    md.append("| Status | Count | Percentage |")
    md.append("|--------|-------|------------|")

    total = stats['total_spec_items'] + stats['total_code_items']
    for status in ['implemented', 'not_implemented', 'misaligned', 'untracked']:
        count = stats[status]
        pct = round((count / total) * 100, 1) if total > 0 else 0
        md.append(f"| {status.replace('_', ' ').title()} | {count} | {pct}% |")
    md.append("")

    # Priority Coverage
    md.append("## Coverage by Priority")
    md.append("")
    md.append("| Priority | Total | Implemented | Not Implemented | Misaligned | Coverage % |")
    md.append("|----------|-------|-------------|-----------------|------------|------------|")

    for priority, data in sorted(stats['by_priority'].items()):
        total = data['total']
        impl = data['implemented']
        not_impl = data['not_implemented']
        mis = data['misaligned']
        coverage = round((impl / total) * 100, 1) if total > 0 else 0
        md.append(f"| {priority.title()} | {total} | {impl} | {not_impl} | {mis} | {coverage}% |")
    md.append("")

    # Module Breakdown
    md.append("## Module Breakdown")
    md.append("")
    md.append("| Module | Total | Implemented | Not Implemented | Misaligned | Untracked | Coverage % |")
    md.append("|--------|-------|-------------|-----------------|------------|-----------|------------|")

    for module, data in sorted(stats['by_module'].items()):
        total = data['total']
        impl = data['implemented']
        not_impl = data['not_implemented']
        mis = data['misaligned']
        untr = data['untracked']

        # Calculate coverage excluding untracked
        spec_items = impl + not_impl + mis
        coverage = round((impl / spec_items) * 100, 1) if spec_items > 0 else 0

        md.append(f"| {module} | {total} | {impl} | {not_impl} | {mis} | {untr} | {coverage}% |")
    md.append("")

    # Category Breakdown
    md.append("## Category Breakdown")
    md.append("")
    md.append("| Category | Total | Implemented | Not Implemented | Misaligned | Untracked |")
    md.append("|----------|-------|-------------|-----------------|------------|-----------|")

    for category, data in sorted(stats['by_category'].items()):
        total = data['total']
        impl = data['implemented']
        not_impl = data['not_implemented']
        mis = data['misaligned']
        untr = data['untracked']

        md.append(f"| {category} | {total} | {impl} | {not_impl} | {mis} | {untr} |")
    md.append("")

    # Top Missing Items
    md.append("## Top 10 Missing Core Items")
    md.append("")
    missing_core = [
        item for item in alignment_matrix
        if item['status'] == 'not_implemented' and item['priority'] == 'core'
    ]
    missing_core = sorted(missing_core, key=lambda x: x['module'])[:10]

    if missing_core:
        md.append("| Name | Module | Category | Expected Files |")
        md.append("|------|--------|----------|----------------|")
        for item in missing_core:
            files = ', '.join([f.split('/')[-1] for f in item['expectedFiles'][:2]])
            if len(item['expectedFiles']) > 2:
                files += '...'
            md.append(f"| {item['name']} | {item['module']} | {item['category']} | {files} |")
    else:
        md.append("*No missing core items!*")
    md.append("")

    # Top Misaligned Items
    md.append("## Top 10 Misaligned Items")
    md.append("")
    misaligned = [
        item for item in alignment_matrix
        if item['status'] == 'misaligned'
    ]
    misaligned = sorted(misaligned, key=lambda x: x.get('matchScore', 0), reverse=True)[:10]

    if misaligned:
        md.append("| Name | Module | Expected Files | Actual Files |")
        md.append("|------|--------|----------------|--------------|")
        for item in misaligned:
            exp_files = ', '.join([f.split('/')[-1] for f in item['expectedFiles'][:2]])
            act_files = ', '.join([f.split('/')[-1] for f in item['actualFiles'][:2]])
            md.append(f"| {item['name']} | {item['module']} | {exp_files} | {act_files} |")
    else:
        md.append("*No misaligned items!*")
    md.append("")

    # Top Untracked Items
    md.append("## Top 20 Untracked Code Items")
    md.append("")
    md.append("These are implemented features not documented in the specification:")
    md.append("")

    untracked = [
        item for item in alignment_matrix
        if item['status'] == 'untracked'
    ]
    untracked = sorted(untracked, key=lambda x: x['module'])[:20]

    if untracked:
        md.append("| Name | Module | File |")
        md.append("|------|--------|------|")
        for item in untracked:
            file_path = item['actualFiles'][0] if item['actualFiles'] else 'N/A'
            file_name = file_path.split('/')[-1]
            md.append(f"| {item['name'][:50]} | {item['module']} | {file_name} |")
    else:
        md.append("*No untracked items!*")
    md.append("")

    # Recommendations
    md.append("## Recommendations")
    md.append("")

    if stats['not_implemented'] > 0:
        md.append(f"1. **Implement Missing Core Features**: {len(missing_core)} core items are not yet implemented")

    if stats['misaligned'] > 0:
        md.append(f"2. **Resolve Misalignments**: {stats['misaligned']} items have file path or naming mismatches")

    if stats['untracked'] > 0:
        md.append(f"3. **Document Untracked Code**: {stats['untracked']} implemented features are not in the specification")

    coverage = stats.get('implementation_percentage', 0)
    if coverage < 50:
        md.append(f"4. **Priority: Implementation**: Coverage is {coverage}% - focus on implementing core features")
    elif coverage < 80:
        md.append(f"4. **Priority: Alignment**: Coverage is {coverage}% - focus on completing and aligning features")
    else:
        md.append(f"4. **Priority: Polish**: Coverage is {coverage}% - focus on testing and refinement")

    md.append("")
    md.append("---")
    md.append("*End of Report*")

    return '\n'.join(md)

def main():
    spec_path = 'docs/_from_specs.json'
    code_path = 'docs/_from_code.json'

    print("🔍 Analyzing specification and code inventories...")

    alignment_matrix = analyze_alignment(spec_path, code_path)
    stats = generate_statistics(alignment_matrix)

    print(f"✅ Analysis complete:")
    print(f"   - Total spec items: {stats['total_spec_items']}")
    print(f"   - Total code items: {stats['total_code_items']}")
    print(f"   - Implemented: {stats['implemented']}")
    print(f"   - Not implemented: {stats['not_implemented']}")
    print(f"   - Misaligned: {stats['misaligned']}")
    print(f"   - Untracked: {stats['untracked']}")
    print(f"   - Coverage: {stats.get('implementation_percentage', 0)}%")

    # Write alignment matrix
    with open('docs/_alignment_matrix.json', 'w') as f:
        json.dump(alignment_matrix, f, indent=2)
    print("\n📄 Generated: docs/_alignment_matrix.json")

    # Write markdown report
    report = generate_markdown_report(alignment_matrix, stats)
    with open('docs/_alignment_report.md', 'w') as f:
        f.write(report)
    print("📄 Generated: docs/_alignment_report.md")

    print("\n✨ Alignment analysis complete!")

if __name__ == '__main__':
    main()
