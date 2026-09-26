# Instructions for AI Coding Agents

> **Audience:** This document is explicitly written for AI coding assistants (Google Antigravity, Claude Code, Cursor, Devin, GitHub Copilot) navigating, installing, or executing workflows from this repository.

---

## 🎯 Purpose of this Repository
This repository contains a curated suite of **32 Antigravity skills**, **7 enterprise plugins**, and **global agent guidelines (`AGENTS.md`)**. 

When connected to an agent, these assets transform general-purpose LLM behavior into a specialized pair-programming engine capable of:
1. Writing production-grade, 60fps GSAP animations.
2. Generating high-end, anti-generic agency designs (no AI template tropes).
3. Eliminating over-engineering and unwanted boilerplate using the Ponytail doctrine.
4. Adhering to strict Vercel, Next.js, and React architecture standards.

---

## 🛠️ Automated Installation (Agent Actions)

If the user asks you to **install**, **load**, or **import** these skills into their environment:

### Global Installation (Applies to all user projects)
- **Windows (PowerShell):**
  ```powershell
  powershell -ExecutionPolicy Bypass -File .\install.ps1 -Scope Global
  ```
- **macOS / Linux:**
  ```bash
  bash ./install.sh
  ```

*What the installer does automatically:*
- Copies all skills to `~/.gemini/config/skills/`.
- Copies all plugins to `~/.gemini/config/plugins/`.
- Updates `~/.gemini/config/config.json` to register and enable all 7 plugins.
- Installs or merges `AGENTS.md` into the user's global config.

### Per-Project / Workspace Installation
If the user wants these skills applied **only to their current repository**:
- **Windows (PowerShell):**
  ```powershell
  powershell -ExecutionPolicy Bypass -File .\install.ps1 -Scope Workspace -WorkspacePath "C:\path\to\target\repo"
  ```
- The installer places the skills into `.agents/skills/` and creates a workspace `AGENTS.md` at the project root.

---

## 🧠 Skill Architecture & Progressive Disclosure

Antigravity uses **Progressive Disclosure** for token efficiency:
- Each skill folder in `skills/<skill-name>/` contains a **`SKILL.md`** file with YAML metadata (`name`, `description`).
- Only skill names and trigger descriptions are initially presented to the agent.
- **Agent Rule:** When a user request matches a skill's domain, you MUST inspect and read the full `SKILL.md` before generating code.

### Domain Routing Matrix

| When the user wants: | Primary Skills / Plugins to inspect: |
| :--- | :--- |
| **Complex animation, scroll triggers, timelines** | `skills/gsap-core`, `skills/gsap-scrolltrigger`, `skills/gsap-timeline`, `skills/gsap-react` |
| **Landing page, website redesign, bespoke UI** | `skills/impeccable`, `skills/soft-skill`, `skills/taste-skill`, `plugins/ui-ux-pro-max-plugin` |
| **Minimalist or brutalist aesthetic** | `skills/minimalist-skill`, `skills/brutalist-skill` |
| **Simplicity, refactoring, removing AI fluff** | `plugins/ponytail` (Follow YAGNI, standard library first) |
| **React / Next.js architecture & performance** | `skills/react-best-practices`, `skills/composition-patterns`, `skills/react-view-transitions` |
| **Visual assets, brand identities, design comps** | `skills/brandkit`, `skills/imagegen-frontend-web`, `skills/image-to-code-skill` |
| **Vercel deployment or cloud cost optimization** | `skills/deploy-to-vercel`, `skills/vercel-optimize`, `skills/vercel-cli-with-tokens` |
| **"Save this workflow" or "Create a skill"** | `skills/global-meta-learner` |

---

## 📜 Agent Rules (`AGENTS.md`)
Always respect instructions in `AGENTS.md`:
1. **TinyFish Preference:** Use TinyFish tools for browser automation, web fetching, and searches whenever available.
2. **GSAP Standard:** Never hand-roll clunky CSS keyframe animations for complex motion when GSAP is available; always adhere to the GSAP skill set.
3. **No Code Placeholders:** Never emit `// ... remaining code stays here`. Emit full, unabridged implementations (governed by `output-skill`).
