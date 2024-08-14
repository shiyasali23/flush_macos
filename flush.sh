#!/bin/bash
echo "Starting comprehensive Mac cleanup and optimization for developer environment..."

# Clear system and user caches
echo "Clearing system and user caches..."
sudo rm -rf ~/Library/Caches/*
sudo rm -rf ~/Library/Logs/*
sudo rm -rf /Library/Caches/*
sudo rm -rf /System/Library/Caches/*

# Flush DNS cache
echo "Flushing DNS cache..."
sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder

# Clear Chrome cache
echo "Clearing Chrome cache..."
rm -rf ~/Library/Caches/Google/Chrome/*

# Clear PyCharm CE cache
echo "Clearing PyCharm CE cache..."
rm -rf ~/Library/Caches/PyCharmCE*/*

# Clear temporary files
echo "Clearing temporary files..."
sudo rm -rf /private/var/tmp/*
sudo rm -rf /private/tmp/*

# Free up inactive memory
echo "Freeing up inactive memory..."
sudo purge

# Optimize Spotlight indexing
echo "Optimizing Spotlight indexing..."
sudo mdutil -E /

# Clear font caches
echo "Clearing font caches..."
sudo atsutil databases -remove

# Clear Quick Look cache
echo "Clearing Quick Look cache..."
qlmanage -r cache

# Optimize Homebrew
echo "Optimizing Homebrew..."
brew update
brew upgrade
brew cleanup
brew doctor

# Clear pip cache
echo "Clearing pip cache..."
pip cache purge

# Clean up Python virtual environments
echo "Cleaning up Python virtual environments..."
find ~/ -type d -name "venv" -o -name ".venv" -o -name "myenv" | while read -r dir; do
    echo "Cleaning $dir"
    rm -rf "$dir/lib/python*/site-packages/tensorflow"
    rm -rf "$dir/lib/python*/site-packages/torch"
done

# Clean up large Git objects
echo "Cleaning up large Git objects..."
find ~/ -name ".git" -type d | while read -r dir; do
    cd "$(dirname "$dir")"
    git gc --aggressive --prune=now
done

# Remove incomplete Hugging Face downloads
echo "Removing incomplete Hugging Face downloads..."
rm -rf ~/.cache/huggingface/hub/models--EleutherAI--gpt-neo-2.7B/blobs/*.incomplete

# Rebuild Launch Services database
echo "Rebuilding Launch Services database..."
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Remove old Xcode files
echo "Removing old Xcode files..."
sudo rm -rf ~/Library/Developer/Xcode/DerivedData/*
sudo rm -rf ~/Library/Developer/Xcode/Archives/*
sudo rm -rf ~/Library/Developer/Xcode/iOS\ DeviceSupport/*

# Clear unused Docker images and containers
echo "Cleaning up unused Docker images and containers..."
docker system prune -af

# Remove Node.js and npm cache
echo "Clearing Node.js and npm cache..."
npm cache clean --force

# Disable unnecessary startup programs
echo "Disabling unnecessary startup programs..."
osascript -e 'tell application "System Events" to delete every login item'

# Clean up Launch Agents and Daemons
echo "Cleaning up Launch Agents and Daemons..."
sudo find /Library/LaunchAgents /Library/LaunchDaemons ~/Library/LaunchAgents ~/Library/LaunchDaemons -name "*.plist" -exec sudo rm {} \;

# Verify and repair disk permissions (macOS High Sierra and earlier)
echo "Verifying and repairing disk permissions (if applicable)..."
if [[ $(sw_vers -productVersion | awk -F '.' '{print $2}') -le 12 ]]; then
    sudo diskutil repairPermissions /
fi

# Reindexing Spotlight
echo "Reindexing Spotlight..."
sudo mdutil -i on /
sudo mdutil -E /

# Update macOS
echo "Checking for macOS updates..."
softwareupdate --list

echo "Mac cleanup and optimization completed!"
