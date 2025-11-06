#!/bin/bash

# Fix Cursor Performance Issues After Upgrade
# This script clears corrupted workspace cache that causes Cursor to hang

CURSOR_STORAGE="$HOME/Library/Application Support/Cursor/User/workspaceStorage"

# Allow WORKSPACE_STORAGE to be passed as environment variable
if [ -n "$WORKSPACE_STORAGE" ] && [ -d "$WORKSPACE_STORAGE" ]; then
    # Use provided workspace storage
    echo "🔍 Cursor Performance Fix Script"
    echo "=================================="
    echo ""
    echo "📍 Using provided workspace storage: $(basename "$WORKSPACE_STORAGE")"
else
    WORKSPACE_STORAGE=""
    
    echo "🔍 Cursor Performance Fix Script"
    echo "=================================="
    echo ""
    
    # Auto-detect current workspace folder
    if [ -n "$PWD" ]; then
        CURRENT_WORKSPACE="$PWD"
        echo "📍 Current workspace: $CURRENT_WORKSPACE"
        
        # Find workspace storage folder by checking workspace.json files
        if [ -d "$CURSOR_STORAGE" ]; then
            for ws_dir in "$CURSOR_STORAGE"/*; do
                if [ -f "$ws_dir/workspace.json" ]; then
                    if grep -q "$CURRENT_WORKSPACE" "$ws_dir/workspace.json" 2>/dev/null; then
                        WORKSPACE_STORAGE="$ws_dir"
                        echo "✅ Found workspace storage: $(basename "$WORKSPACE_STORAGE")"
                        break
                    fi
                fi
            done
        fi
    fi
    
    # If not found, try to find the most recently modified folder
    if [ -z "$WORKSPACE_STORAGE" ] && [ -d "$CURSOR_STORAGE" ]; then
        WORKSPACE_STORAGE=$(ls -td "$CURSOR_STORAGE"/*/ 2>/dev/null | head -1 | sed 's|/$||')
        if [ -n "$WORKSPACE_STORAGE" ]; then
            echo "⚠️  Using most recent workspace storage: $(basename "$WORKSPACE_STORAGE")"
        fi
    fi
fi

# Check if Cursor is running
CURSOR_RUNNING=false
if pgrep -f "Cursor" > /dev/null; then
    CURSOR_RUNNING=true
    echo ""
    echo "⚠️  Cursor is currently running."
    echo ""
    echo "If Cursor is stuck/hanging, you can force-kill it now."
    echo "If Cursor is working normally, please close it first for best results."
    echo ""
    read -p "Force-kill Cursor now? (y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🛑 Force-killing Cursor processes..."
        pkill -9 -f "Cursor" 2>/dev/null
        sleep 2
        if pgrep -f "Cursor" > /dev/null; then
            echo "❌ Some Cursor processes are still running. Please close Cursor manually."
            exit 1
        else
            echo "✅ Cursor processes terminated."
            CURSOR_RUNNING=false
        fi
    else
        echo "⚠️  Continuing with Cursor running. Some operations may fail."
    fi
fi

if [ "$CURSOR_RUNNING" = true ]; then
    echo ""
    read -p "Press Enter to continue anyway, or Ctrl+C to cancel..."
fi

echo ""
echo "🧹 Clearing corrupted workspace cache..."

if [ -z "$WORKSPACE_STORAGE" ] || [ ! -d "$WORKSPACE_STORAGE" ]; then
    echo "⚠️  Workspace storage folder not found."
    echo "   This might be a new workspace or the folder path couldn't be detected."
    echo ""
    echo "   You can manually specify the workspace storage folder by running:"
    echo "   WORKSPACE_STORAGE=\"<path>\" $0"
    echo ""
    read -p "Continue with clearing global cache anyway? (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Aborted."
        exit 1
    fi
else
    # Backup the workspace storage (just in case)
    WS_NAME=$(basename "$WORKSPACE_STORAGE")
    BACKUP_DIR="$CURSOR_STORAGE/${WS_NAME}.backup.$(date +%Y%m%d_%H%M%S)"
    
    echo "📦 Creating backup at: $BACKUP_DIR"
    if cp -r "$WORKSPACE_STORAGE" "$BACKUP_DIR" 2>/dev/null; then
        echo "✅ Backup created successfully"
    else
        echo "⚠️  Could not create backup (this is okay if Cursor is still running)"
    fi
    
    echo ""
    echo "🗑️  Removing corrupted cache files..."
    
    # Remove the corrupted state database and retrieval cache
    FILES_CLEARED=0
    
    if [ -f "$WORKSPACE_STORAGE/state.vscdb" ]; then
        rm -f "$WORKSPACE_STORAGE/state.vscdb" && FILES_CLEARED=$((FILES_CLEARED + 1))
        echo "   Removed state.vscdb"
    fi
    
    if [ -f "$WORKSPACE_STORAGE/state.vscdb.backup" ]; then
        rm -f "$WORKSPACE_STORAGE/state.vscdb.backup" && FILES_CLEARED=$((FILES_CLEARED + 1))
        echo "   Removed state.vscdb.backup"
    fi
    
    if [ -d "$WORKSPACE_STORAGE/anysphere.cursor-retrieval" ]; then
        rm -rf "$WORKSPACE_STORAGE/anysphere.cursor-retrieval" && FILES_CLEARED=$((FILES_CLEARED + 1))
        echo "   Removed anysphere.cursor-retrieval directory"
    fi
    
    if [ $FILES_CLEARED -gt 0 ]; then
        echo "✅ Cleared $FILES_CLEARED cache item(s) from workspace storage"
    else
        echo "⚠️  No cache files found to clear in workspace storage"
    fi
fi

echo ""
echo "🧹 Clearing corrupted GLOBAL storage (CRITICAL - this is causing 100% CPU)..."
echo "   This is the main issue: corrupted databases taking up 11GB+"

# Clear the corrupted global storage which is causing the high CPU usage
GLOBAL_STORAGE="$HOME/Library/Application Support/Cursor/User/globalStorage"
GLOBAL_CLEARED=0
SPACE_FREED=0

if [ -d "$GLOBAL_STORAGE" ]; then
    # Check size before clearing
    if [ -f "$GLOBAL_STORAGE/state.vscdb" ]; then
        DB_SIZE=$(du -h "$GLOBAL_STORAGE/state.vscdb" 2>/dev/null | cut -f1)
        echo "   Found corrupted state.vscdb ($DB_SIZE)"
        if rm -f "$GLOBAL_STORAGE/state.vscdb" 2>/dev/null; then
            GLOBAL_CLEARED=$((GLOBAL_CLEARED + 1))
            echo "   ✅ Removed state.vscdb"
        fi
    fi
    
    if [ -f "$GLOBAL_STORAGE/state.vscdb.backup" ]; then
        DB_SIZE=$(du -h "$GLOBAL_STORAGE/state.vscdb.backup" 2>/dev/null | cut -f1)
        echo "   Found corrupted state.vscdb.backup ($DB_SIZE)"
        if rm -f "$GLOBAL_STORAGE/state.vscdb.backup" 2>/dev/null; then
            GLOBAL_CLEARED=$((GLOBAL_CLEARED + 1))
            echo "   ✅ Removed state.vscdb.backup"
        fi
    fi
    
    if [ -d "$GLOBAL_STORAGE/anysphere.cursor-retrieval" ]; then
        RET_SIZE=$(du -h "$GLOBAL_STORAGE/anysphere.cursor-retrieval" 2>/dev/null | cut -f1)
        echo "   Found corrupted anysphere.cursor-retrieval ($RET_SIZE)"
        if rm -rf "$GLOBAL_STORAGE/anysphere.cursor-retrieval" 2>/dev/null; then
            GLOBAL_CLEARED=$((GLOBAL_CLEARED + 1))
            echo "   ✅ Removed anysphere.cursor-retrieval directory"
        fi
    fi
    
    if [ $GLOBAL_CLEARED -gt 0 ]; then
        echo "✅ Cleared $GLOBAL_CLEARED corrupted global storage item(s)"
        echo "   This should free up ~11GB and fix the 100% CPU issue!"
    else
        echo "ℹ️  No corrupted global storage files found (may have been cleared already)"
    fi
else
    echo "⚠️  Global storage directory not found"
fi

echo ""
echo "🧹 Clearing ALL workspace storage corrupted files..."
echo "   (Clearing all workspaces, not just current one)"

# Clear corrupted files from ALL workspace storages
ALL_WORKSPACES_CLEARED=0
if [ -d "$CURSOR_STORAGE" ]; then
    for ws_dir in "$CURSOR_STORAGE"/*; do
        if [ -d "$ws_dir" ]; then
            WS_CLEARED=0
            if [ -f "$ws_dir/state.vscdb" ]; then
                rm -f "$ws_dir/state.vscdb" 2>/dev/null && WS_CLEARED=$((WS_CLEARED + 1))
            fi
            if [ -f "$ws_dir/state.vscdb.backup" ]; then
                rm -f "$ws_dir/state.vscdb.backup" 2>/dev/null && WS_CLEARED=$((WS_CLEARED + 1))
            fi
            if [ -d "$ws_dir/anysphere.cursor-retrieval" ]; then
                rm -rf "$ws_dir/anysphere.cursor-retrieval" 2>/dev/null && WS_CLEARED=$((WS_CLEARED + 1))
            fi
            if [ $WS_CLEARED -gt 0 ]; then
                ALL_WORKSPACES_CLEARED=$((ALL_WORKSPACES_CLEARED + WS_CLEARED))
            fi
        fi
    done
    if [ $ALL_WORKSPACES_CLEARED -gt 0 ]; then
        echo "✅ Cleared $ALL_WORKSPACES_CLEARED corrupted file(s) from all workspace storages"
    else
        echo "ℹ️  No corrupted workspace storage files found"
    fi
fi

echo ""
echo "🧹 Clearing Cursor search index cache..."

# Clear the search index which might also be corrupted
CACHED_DATA="$HOME/Library/Application Support/Cursor/CachedData"
INDEX_CLEARED=0

if [ -d "$CACHED_DATA" ]; then
    # Use find to safely clear index files
    while IFS= read -r file; do
        if [ -f "$file" ]; then
            rm -f "$file" && INDEX_CLEARED=$((INDEX_CLEARED + 1))
        fi
    done < <(find "$CACHED_DATA" -name "index*" -type f 2>/dev/null)
    
    # Also try glob patterns
    shopt -s nullglob
    for index_file in "$CACHED_DATA"/*/chrome/js/index* "$CACHED_DATA"/*/chrome/wasm/index*; do
        if [ -f "$index_file" ]; then
            rm -f "$index_file" 2>/dev/null && INDEX_CLEARED=$((INDEX_CLEARED + 1))
        fi
    done
    shopt -u nullglob
    
    if [ $INDEX_CLEARED -gt 0 ]; then
        echo "✅ Cleared $INDEX_CLEARED search index file(s)"
    else
        echo "ℹ️  No search index files found to clear"
    fi
else
    echo "⚠️  CachedData directory not found"
fi

echo ""
echo "✅ Done! You can now reopen Cursor."
echo ""
echo "📝 Note: Cursor will rebuild its index when you reopen, which may take a minute."
echo "   This is normal and should only happen once."

