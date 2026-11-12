# My AI Skills

One central home for every skill I use across my AI tools — Claude, ChatGPT, Gemini, and anything else. Each skill is written once here and synced out to whichever tool needs it.

## Repo layout

```
my_ai_skills/
├── skills/                      # One folder per skill
│   ├── broll-finder/
│   └── youtube-metadata-optimizer/
│       ├── SKILL.md             # The skill itself (required)
│       ├── references/          # Optional: longer docs the skill points to
│       ├── scripts/             # Optional: helper code the skill runs
│       └── assets/              # Optional: templates, images, examples
├── templates/
│   └── skill-template/          # Copy this to start a new skill
├── scripts/
│   └── package_skills.sh        # Zips skills for uploading to apps
└── README.md
```

## Skill format

Every skill uses the open **Agent Skills** format: a folder with a `SKILL.md` file that starts with YAML frontmatter.

```markdown
---
name: my-skill-name
description: What the skill does and when to use it.
---

# Instructions go here
```

Rules that keep skills portable:

- The folder name matches the `name` field, in lowercase-with-hyphens.
- The `description` says **when** to use the skill, since that's what tools read to decide whether to load it.
- Keep `SKILL.md` focused. Put long reference material in `references/` and link to it.
- If a skill depends on tools specific to one app (for example, Claude in Chrome), say so in the skill and describe a fallback.

## Skills

| Skill | What it does |
|---|---|
| [youtube-metadata-optimizer](skills/youtube-metadata-optimizer/SKILL.md) | Researches competitor videos and current YouTube SEO guidance, then writes 3 ranked titles, a description, and tags for a Simple Tech video. |
| [broll-finder](skills/broll-finder/SKILL.md) | Finds free, real B-roll clip links from Pexels and Pixabay to illustrate a topic from a video script. |

## Using a skill in each tool

### Claude (claude.ai and the desktop app)

1. Run `./scripts/package_skills.sh` to build a zip for each skill in `dist/`.
2. In Claude, go to the Skills settings and upload the zip.

### Claude Code

Copy or symlink the skill folder into your skills directory:

```bash
ln -s "$(pwd)/skills/youtube-metadata-optimizer" ~/.claude/skills/youtube-metadata-optimizer
```

A symlink means `git pull` updates the skill automatically.

### Other tools that support SKILL.md

Many coding agents and harnesses now read the same `SKILL.md` format. Point them at the skill folder, or copy it into their skills directory, following that tool's docs.

### ChatGPT, Gemini, and tools without skill support

Paste the body of `SKILL.md` (everything below the frontmatter) into the tool's custom instructions, such as a Custom GPT, a ChatGPT Project, or a Gemini Gem. Upload any files from `references/` or `assets/` as knowledge files.

## Adding a new skill

1. Copy `templates/skill-template/` to `skills/<new-skill-name>/`.
2. Fill in `SKILL.md`.
3. Add a row to the Skills table above.
4. Commit and push.
