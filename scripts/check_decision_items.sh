#!/bin/bash

# Script to check unresolved decision items across all decision matrices
# Usage: ./scripts/check_decision_items.sh

echo "🔍 Checking Decision Matrices for Unresolved Items..."
echo ""

# Count total decision items
TOTAL_ITEMS=$(grep -r "❓\|❌.*Not Implemented\|⚠️.*Partial\|🔴 Missing" "docs/decision matrix/" | wc -l | tr -d ' ')

# Count by type
NEEDS_VERIFICATION=$(grep -r "❓" "docs/decision matrix/" | wc -l | tr -d ' ')
MISSING=$(grep -r "🔴 Missing\|❌.*Not Implemented" "docs/decision matrix/" | wc -l | tr -d ' ')
PARTIAL=$(grep -r "⚠️.*Partial" "docs/decision matrix/" | wc -l | tr -d ' ')

echo "📊 Summary:"
echo "   Total Items Needing Attention: $TOTAL_ITEMS"
echo "   Needs Verification (❓): $NEEDS_VERIFICATION"
echo "   Missing from Code (🔴): $MISSING"
echo "   Partially Implemented (⚠️): $PARTIAL"
echo ""

# List modules with most issues
echo "📋 Modules with Most Issues:"
grep -r "❓\|❌.*Not Implemented\|⚠️.*Partial\|🔴 Missing" "docs/decision matrix/" | \
  cut -d'/' -f3 | \
  sort | uniq -c | \
  sort -rn | head -10
echo ""

# List decision needed items
echo "🎯 Items Marked 'DECISION NEEDED':"
grep -r "DECISION NEEDED" "docs/decision matrix/" | wc -l | tr -d ' '
echo ""

echo "✅ Done! Review the output above to prioritize your work."
