---
name: broll-finder
description: "Find free, real B-roll video clip links from Pexels/Pixabay to illustrate a topic described from a YouTube video script."
---

# B-roll finder

## Trigger
The user describes something they're talking about or a moment/emotion/action in their video and asks for stock footage, B-roll, or clips to illustrate it.

## Steps

1. **Clarify the visual, not just the topic.** If the request is abstract (an emotion, a concept), translate it into a concrete visual search term before searching — e.g. "someone unsure how to get started" → try literal terms like "confused", "stressed", "overwhelmed" rather than the abstract phrasing itself. If the request is about a specific on-screen product/interface (e.g. "typing into a chatbot"), search the literal product/brand term first (e.g. "chatgpt") — this consistently surfaces real screen-capture footage, whereas generic terms like "ai chatbot" tend to surface robot-mascot/toy imagery instead.

2. **Search both Pexels and Pixabay** using Claude in Chrome browser automation:
   - Load browser tools if deferred: `ToolSearch` with `select:mcp__claude-in-chrome__tabs_context_mcp,mcp__claude-in-chrome__navigate,mcp__claude-in-chrome__computer,mcp__claude-in-chrome__read_page,mcp__claude-in-chrome__tabs_create_mcp,mcp__claude-in-chrome__tabs_close_mcp`
   - Navigate to `https://www.pexels.com/search/videos/<query>/` and `https://pixabay.com/videos/search/<query>/`
   - Take a screenshot to sanity-check the visual direction (avoid grabbing abstract/graphic results when the ask was for real footage of people/screens).
   - Use `read_page` with `filter: interactive` to extract real hrefs.

3. **Filter out sponsored/iStock links.** Both sites inject sponsored results styled like organic ones:
   - Pexels: real clip links look like `/video/{slug}-{id}/`; sponsored links are `pexels.com/r/{base64}/` redirecting to istockphoto.com — always discard these.
   - Pixabay: real clip links look like `/videos/{slug}-{id}/`; a "Sponsored Videos" labeled row up top links straight to istockphoto.com — always discard these.

4. **Try 2-3 query variations if the first pass misses the mark** (e.g. literal product name vs. generic term, action vs. emotion, "phone" vs "laptop" framing). Don't settle for the first search if the thumbnails clearly don't match what's needed.

5. **Present a shortlist** (typically 3-5 links total across both sites) as markdown links with a one-line description of what's actually in the shot, grouped by site. Note any caveats (e.g. "stock footage rarely shows real/current on-screen headlines — for exact article text, screen-recording your own scroll is more reliable").

6. **Never download without explicit permission.** Only search and link. If the user picks a clip, ask for confirmation before downloading anything (per standing safety rules on file downloads).

## Verification
Before presenting the shortlist, re-check each retained link is a native site URL (not a `pexels.com/r/...` or istockphoto.com redirect) and that the thumbnail/screenshot actually matches the described visual, not just the keyword.