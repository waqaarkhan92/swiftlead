#!/usr/bin/env python3
"""
Fix and test capability extraction patterns
"""

import re
from pathlib import Path

# Test the capability extraction pattern
test_content = """**Core Capabilities:**
- **Unified Message View:** Single interface displaying all SMS, WhatsApp, Facebook Messenger, Instagram Direct, and **Email (IMAP/SMTP)** messages in chronological order
- **Message Threading:** Automatic grouping of messages by contact, maintaining conversation history across all channels
- **Real-time Updates:** Live message delivery with push notifications and in-app badges (Note: Deferred until backend is wired. Current implementation uses pull-based approach with `_loadMessages()` which is acceptable for MVP.)
- **Internal Notes & @Mentions:**
  - Add private notes to conversations visible only to team members
  - @mention team members to notify them of important conversations
  - Notes include timestamps and author information"""

# Current pattern (not working)
pattern1 = r'^- \*\*(.+?)\*\*:?\s*(.+?)(?=\n- |\n\n|\Z)'
matches1 = re.findall(pattern1, test_content, re.MULTILINE | re.DOTALL)
print(f"Pattern 1 matches: {len(matches1)}")
for m in matches1:
    print(f"  - {m[0]}: {m[1][:50]}...")

# Better pattern
pattern2 = r'^- \*\*(.+?)\*\*:\s*(.+?)(?=\n- \*\*|\n\n|\Z)'
matches2 = re.findall(pattern2, test_content, re.MULTILINE | re.DOTALL)
print(f"\nPattern 2 matches: {len(matches2)}")
for m in matches2:
    print(f"  - {m[0]}: {m[1][:50]}...")

# Even better - handle nested bullets
pattern3 = r'^- \*\*(.+?)\*\*:\s*((?:[^\n]|\n(?!- \*\*))+?)(?=\n- \*\*|\n\n|\Z)'
matches3 = re.findall(pattern3, test_content, re.MULTILINE | re.DOTALL)
print(f"\nPattern 3 matches: {len(matches3)}")
for m in matches3:
    desc = m[1].strip()
    if len(desc) > 100:
        desc = desc[:97] + "..."
    print(f"  - {m[0]}: {desc}")

