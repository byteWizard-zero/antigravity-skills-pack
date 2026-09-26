---
name: meta-learner
description: Triggers ONLY when the user explicitly says "save this workflow", "create a skill", or "remember this process". Do not load for general coding or chat.
---

# Meta-Learner

## 🎯 Purpose
Extract workflows from the current conversation and generate Antigravity skill files globally to `~/.gemini/antigravity/skills/`.

## ⚙️ Rules & Token Limits
- **Check First:** Before creating a skill, scan `~/.gemini/antigravity/skills/`. If a similar skill exists, append the new workflow to it instead of making a new file.
- **Keep it Short:** Ensure generated `description` fields are under 100 characters. 
- **No Secrets:** Replace hardcoded API keys or passwords with `<PLACEHOLDER>`.
- **Handle Collisions:** If a folder name exists, append `-v2`.

## 🔄 Execution Steps
1. Abstract the user's specific workflow into a general, reusable template.
2. Create a new folder at `~/.gemini/antigravity/skills/[skill-name]`.
3. Create `SKILL.md` using the exact format below.

## 📝 Output Format
```yaml
---
name: [kebab-case-name]
description: [Strict, 1-sentence trigger condition]
---
# [Title]
## 🎯 Purpose
[1 sentence]
## 🔄 Workflow
1. [Step]