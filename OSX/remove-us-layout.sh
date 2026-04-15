#!/bin/bash

# Script to remove the default US keyboard layout from macOS
# Use this after installing "U.S. German Umlauts" keyboard layout

PLIST_FILE="$HOME/Library/Preferences/com.apple.HIToolbox.plist"

echo "=============================================="
echo "  Remove Default US Keyboard Layout - macOS"
echo "=============================================="
echo ""
echo "This script will remove the default 'U.S.' keyboard layout"
echo "and set 'U.S. German Umlauts' as your only keyboard layout."
echo ""
echo "IMPORTANT:"
echo "  - Make sure you have already added 'U.S. German Umlauts'"
echo "    via System Settings before running this script."
echo "  - You will need to restart your Mac after running this script."
echo ""

read -p "Do you want to proceed? (y/N): " confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

echo ""

# Check if German Umlauts is available (in AppleSelectedInputSources or AppleInputSourceHistory)
german_umlauts_name=""
german_umlauts_id=""

# Check AppleSelectedInputSources first
name=$(/usr/libexec/PlistBuddy -c "Print :AppleSelectedInputSources:0:KeyboardLayout\ Name" "$PLIST_FILE" 2>/dev/null)
if [[ "$name" == *"German Umlauts"* ]]; then
    german_umlauts_name="$name"
    german_umlauts_id=$(/usr/libexec/PlistBuddy -c "Print :AppleSelectedInputSources:0:KeyboardLayout\ ID" "$PLIST_FILE" 2>/dev/null)
fi

# If not found, check AppleInputSourceHistory
if [ -z "$german_umlauts_name" ]; then
    hist_count=$(/usr/libexec/PlistBuddy -c "Print :AppleInputSourceHistory" "$PLIST_FILE" 2>/dev/null | grep -c "KeyboardLayout Name")
    for ((i=0; i<hist_count; i++)); do
        name=$(/usr/libexec/PlistBuddy -c "Print :AppleInputSourceHistory:$i:KeyboardLayout\ Name" "$PLIST_FILE" 2>/dev/null)
        if [[ "$name" == *"German Umlauts"* ]]; then
            german_umlauts_name="$name"
            german_umlauts_id=$(/usr/libexec/PlistBuddy -c "Print :AppleInputSourceHistory:$i:KeyboardLayout\ ID" "$PLIST_FILE" 2>/dev/null)
            break
        fi
    done
fi

echo "Checking for U.S. German Umlauts layout..."

if [ -z "$german_umlauts_name" ]; then
    echo ""
    echo "Error: 'U.S. German Umlauts' layout not found!"
    echo "Please add it via System Settings -> Keyboard -> Input Sources first."
    exit 1
fi

echo "Found: $german_umlauts_name (ID: $german_umlauts_id)"

echo ""
echo "Current AppleEnabledInputSources:"
echo "---------------------------------"
/usr/libexec/PlistBuddy -c "Print :AppleEnabledInputSources" "$PLIST_FILE" 2>/dev/null

echo ""
read -p "Replace with only '$german_umlauts_name'? (y/N): " confirm2

if [[ ! "$confirm2" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

# Create backup
cp "$PLIST_FILE" "$PLIST_FILE.backup"
echo ""
echo "Backup created: $PLIST_FILE.backup"

# Delete the entire AppleEnabledInputSources array and recreate it clean
echo "Removing all existing input sources..."
/usr/libexec/PlistBuddy -c "Delete :AppleEnabledInputSources" "$PLIST_FILE" 2>/dev/null

echo "Adding '$german_umlauts_name' as the only keyboard layout..."
/usr/libexec/PlistBuddy -c "Add :AppleEnabledInputSources array" "$PLIST_FILE"
/usr/libexec/PlistBuddy -c "Add :AppleEnabledInputSources:0 dict" "$PLIST_FILE"
/usr/libexec/PlistBuddy -c "Add :AppleEnabledInputSources:0:InputSourceKind string 'Keyboard Layout'" "$PLIST_FILE"
/usr/libexec/PlistBuddy -c "Add :AppleEnabledInputSources:0:KeyboardLayout\ Name string '$german_umlauts_name'" "$PLIST_FILE"
/usr/libexec/PlistBuddy -c "Add :AppleEnabledInputSources:0:KeyboardLayout\ ID integer $german_umlauts_id" "$PLIST_FILE"

# Also add Character Palette (emoji picker) back
/usr/libexec/PlistBuddy -c "Add :AppleEnabledInputSources:1 dict" "$PLIST_FILE"
/usr/libexec/PlistBuddy -c "Add :AppleEnabledInputSources:1:InputSourceKind string 'Non Keyboard Input Method'" "$PLIST_FILE"
/usr/libexec/PlistBuddy -c "Add :AppleEnabledInputSources:1:Bundle\ ID string 'com.apple.CharacterPaletteIM'" "$PLIST_FILE"

echo ""
echo "Updated AppleEnabledInputSources:"
echo "---------------------------------"
/usr/libexec/PlistBuddy -c "Print :AppleEnabledInputSources" "$PLIST_FILE" 2>/dev/null

echo ""
echo "Done! Please restart your Mac for changes to take effect."
