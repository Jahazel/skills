#!/bin/bash
SKILLS_REPO="$HOME/Code/skills"
SKILLS_DIR="$HOME/.claude/skills"

# Sync root-level skill directories
for dir in "$SKILLS_REPO"/*/; do
  dirname=$(basename "$dir")
  if [ "$dirname" != "personal" ]; then
    rsync -a "$dir" "$SKILLS_DIR/$dirname/"
  fi
done

# Sync personal skills to root of ~/.claude/skills/ (flattened)
if [ -d "$SKILLS_REPO/personal" ]; then
  for dir in "$SKILLS_REPO/personal/"/*/; do
    dirname=$(basename "$dir")
    rsync -a "$dir" "$SKILLS_DIR/$dirname/"
  done
fi

echo "Skills synced to $SKILLS_DIR"
