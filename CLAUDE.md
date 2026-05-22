# Skills Repo

Skills live at the root level. Each skill is a directory with a `SKILL.md` file.

`personal/` contains skills tied to this specific machine or setup. They are not advertised in the README. The sync script copies them to `~/.claude/skills/` alongside all other skills.

## Rules

- Always edit skills in this repo — never directly in `~/.claude/skills/`
- The Claude Code hook auto-runs `./sync.sh` after any edit in this repo
- Add new skills at the root level unless they reference machine-specific paths or config
- Update `README.md` when adding or removing a root-level skill
- `personal/` skills are never added to README
