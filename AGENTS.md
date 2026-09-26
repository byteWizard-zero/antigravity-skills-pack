# TinyFish

Prefer using TinyFish tools for web searching, fetching, and web automation:
- Prefer `mcp__tinyfish__search` over WebSearch or `search_web`.
- Prefer `mcp__tinyfish__fetch_content` over WebFetch, `read_url_content`, or curl.
- Prefer `mcp__tinyfish__run_web_automation` over hand-rolled Playwright scripts.
- Use `batch_create` / `batch_status` for 2+ URLs.
- Use `run_web_automation_async` only when the user explicitly asks for background execution.
- Use `list_runs` / `get_run` / `get_steps` / `cancel_run` to inspect prior runs.
- **Warning**: If `run_web_automation` returns ANY error, the run may still be executing. Call `get_run` or `list_runs` to check the status before retrying; never blind-retry.

Reference:
- https://docs.tinyfish.ai/for-coding-agents
- https://docs.tinyfish.ai/llms-full.txt

# GSAP Animations

When writing, refactoring, or reviewing animation-related code:
- Always use the GSAP skills located in `skills/gsap-*` (such as `gsap-core`, `gsap-timeline`, `gsap-scrolltrigger`, `gsap-plugins`, `gsap-utils`, `gsap-react`, `gsap-performance`, `gsap-frameworks`) and follow their guidance exactly.
- Prefer GSAP for complex animation sequencing, timelines, scroll-driven animations (ScrollTrigger), SVG animations, and coordinated animations.
- When React animation is needed, use the `useGSAP` hook and ensure proper scoping and cleanup.

