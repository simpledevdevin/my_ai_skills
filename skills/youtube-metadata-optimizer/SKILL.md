---
name: youtube-metadata-optimizer
description: "Generates optimized YouTube titles, descriptions, and tags for the Simple Tech channel (AI, Data Engineering, Data Science, Technology). Researches successful competitor videos on the same topic on YouTube plus current YouTube SEO/CTR best practices, then produces 3 ranked title options for A/B testing, one formatted description (hook, summary, resources, GitHub code link, hashtags), and a comma-separated tag list under YouTube's 500-character limit. Use this any time the user is prepping a video for upload and wants help with titles, video descriptions, tags, or YouTube SEO/CTR/impressions/views optimization — even if they just hand over a topic or rough draft and don't explicitly ask for \"the skill\" or say \"YouTube metadata.\""
---

# YouTube Metadata Optimizer

Generates optimized titles, a description, and tags for a video on the Simple Tech channel, grounded in real research rather than generic guesses.

## Why research first

Titles and tags that "sound good" in the abstract often don't match what's actually working right now in this specific niche. Two things drift over time: what competing creators in AI/data/tech are doing, and what YouTube's current best practices are. Skipping straight to writing produces generic output; researching first produces output that's actually competitive.

## Channel context

- **Channel**: Simple Tech — AI, Data Engineering, Data Science, and Technology content
- **Audience/voice**: beginner-friendly, no jargon, "no headache" explanations. Titles and descriptions should read as approachable, not intimidating — explain or avoid unexplained jargon.
- **Code repo**: https://github.com/simpledevdevin/youtube

## Step 1: Get the video brief

If the user hasn't already given you a topic/summary of the video, ask for one. You need enough to research and write meaningfully — at minimum, what the video covers and its main takeaway.

Only ask follow-up clarifying questions if something would actually change the output strategy, for example:
- The core hook/angle is genuinely ambiguous (e.g., is this a tutorial, a reaction/opinion piece, a comparison?)
- It's part of a series and there's a naming convention to match
- There's a specific keyword they're trying to rank for
- The GitHub file/notebook for this video isn't clear yet

Don't ask about things you can reasonably infer from the brief or the channel context above — keep the interview short and get to research quickly.

## Step 2: Research competitor videos

**Use the web-search MCP server first.** Its two tools, `search_youtube` and `get_video_details` (they appear as `mcp__web-search__search_youtube` and `mcp__web-search__get_video_details`; load them with `ToolSearch` if they are deferred), pull real data from the YouTube Data API: views, likes, comments, channel subscribers, upload date, `views_per_day`, `views_to_subscribers_ratio`, duration, each video's own tags, and full descriptions. This is more reliable than reading YouTube pages, and unlike a logged-in browser it isn't skewed by personalization.

The web-search procedure:

1. Call `search_youtube` once with a focused query for the video's main topic (`order: "relevance"`, `max_results: 15`, `published_within_days: 730`). YouTube allows only 100 searches a day across everything that uses this server (including the Video Pipeline board), so make at most one more search, and only if the first results are mostly off-topic or thin (for example `order: "viewCount"` or a reworded query). Expect some off-topic results, especially when sorting by views, and ignore them.
2. Judge success by real signals, not raw views: `views_to_subscribers_ratio` (above 1 means the video beat its channel's size), `views_per_day`, and recency. A big channel's view count alone isn't evidence.
3. Call `get_video_details` once with the 3-5 strongest relevant videos to read their full descriptions and tags. It doesn't use any of the daily searches.
4. If a call fails (quota exceeded, connector missing, or errors after one retry), say so and move to Fallback 1. Don't keep retrying.

**Fallback 1: Chrome.** Use it only if the web-search tools are missing from the session or fail after one retry, or to spot-check a specific video. The `mcp__claude-in-chrome__*` tools load YouTube as a real logged-in browser, which shows view counts, upload dates and full descriptions, but the logged-in session adds personalization bias. Plain `WebFetch` on a youtube.com watch page frequently returns HTTP 429 or a stripped page, so don't use it for this. The Chrome procedure:

1. Load the browser tools in ONE `ToolSearch` call: `select:mcp__claude-in-chrome__tabs_context_mcp,mcp__claude-in-chrome__navigate,mcp__claude-in-chrome__get_page_text,mcp__claude-in-chrome__read_page,mcp__claude-in-chrome__tabs_create_mcp,mcp__claude-in-chrome__tabs_close_mcp`
2. Call `tabs_context_mcp` first, then open a NEW tab — never hijack a tab the user is working in.
3. Navigate to a YouTube search URL for the topic, e.g. `https://www.youtube.com/results?search_query=<topic>&sp=CAMSAhAB` (the `sp` parameter sorts by view count; drop it for relevance order). Use `get_page_text` to read the result list with view counts and ages attached.
4. Open the most relevant/highest-performing watch pages and `get_page_text` each one for the full title and description. Click "...more" if the description is collapsed.
5. Close the tabs you opened when finished.

**Fallback 2:** Use `WebSearch` + `WebFetch` ONLY if both web-search and Chrome are genuinely unavailable — the tools are absent from the session entirely, or calls fail with connection errors after a couple of attempts. A blocked site or a pending site-approval prompt is not unavailability: wait for the approval rather than silently falling back.

**If you do end up on the fallback path, say so explicitly in the final output** — state that view counts could not be verified and that the title patterns come from search-result titles only. Never present pattern-matched titles as if they were grounded in performance data.

What to gather, either way:

- 10-15 videos similar to the one being planned, favoring ones that look successful (high views relative to channel size, recent, from creators in a similar niche — AI/data/tech education)
- Actual title phrasing and description structure/opening lines
- Tags: the web-search tools return each video's real tags when the creator set them, so use those to find recurring tags. On the Chrome or WebSearch fallback, YouTube doesn't show tags to viewers, so infer likely target keywords from repeated phrases across titles and descriptions instead
- Patterns: common title structures (numbers, brackets/parentheses, questions, "How to X", curiosity gaps, before/after framing), how top videos open their descriptions, typical description length and structure
- Where the gap is: if every competitor uses the same framing, that saturation is itself a finding — an angle nobody is using may outperform matching the pack

## Step 3: Research current best practices

Search for current YouTube title/description/tag/CTR best practices. Good sources include VidIQ's blog, TubeBuddy's blog, Social Blade's blog, Backlinko, and similar YouTube-growth-focused publishers — plus any recent news about YouTube algorithm changes. Note anything that seems to have shifted recently, since this kind of guidance goes stale.

`WebSearch` and `WebFetch` are fine for this step — these are ordinary blog articles and they fetch reliably.

## Step 4: Draft the output

Synthesize Steps 2 and 3 into the three deliverables below. Every title, the description structure, and the tag mix should be traceable back to something observed in research — not generic SEO platitudes.

### Title options

Produce exactly 3 titles for A/B testing, ranked 1 (strongest) to 3. The three must vary in **style and strategy** — don't give three versions of the same approach. Pull from different angles observed in research, for example: a curiosity-gap/open-loop title, a clear benefit- or keyword-forward title, a comparison/listicle/number-driven title, or a story/before-after framing. For each title, give a one-line reason it's ranked where it is (what it trades off against the others), and where possible cite the competitor evidence behind it (e.g. "the three highest-view videos on this topic all lead with the question form").

Keep titles in the 50-70 character range with the primary keyword in the first 50 characters, and state each title's character count.

### Description

Use this exact structure:

```
[Hook — 1-2 sentences that grab attention and mirror the angle of the #1 title]

[Content summary — a few sentences on what the viewer will learn/see, written for a beginner-friendly audience]

📚 Resources
- [any links/resources the user provided or that are relevant]

💻 Code
[GitHub link — see "GitHub links" below]

[3-6 relevant hashtags]
```

Base the hook style and summary framing on the patterns you found in Step 2, not a generic template. Front-load the primary keyword — only the first ~150 characters show above "Show more."

### Tags

A single comma-separated line, no `#` symbols. Aim for **8-12 focused tags** — current guidance is that filling the full 500-character budget doesn't help and can dilute relevance; a shorter, tightly-relevant list outperforms a maxed-out one. Lead with the exact-match primary keyword, then mix broad category tags (e.g. AI, data engineering, python) with specific long-tail tags informed by the recurring phrases you found in Step 2. Count the characters of the final comma-separated string (including commas and spaces) and confirm it's under YouTube's 500-character limit — state the character count when you present the result, but treat 500 as a hard ceiling, not a target.

Use **3-5 hashtags** in the description (not more — YouTube ignores *all* hashtags on a video if you exceed 15, and beyond 3-5 you're past the point of benefit anyway). The first 3 hashtags in the description become clickable links above the title, so put the most important ones first.

## GitHub links

Default to a **permalink** (pinned to a commit SHA), not a branch URL like `blob/main/...` — that way the code shown always matches what's in the video, even after the repo changes later.

- If the user gives you a permalink already (a URL containing a long commit hash instead of `main`), use it as-is.
- If the user gives you a branch URL (`blob/main/...`) or just a file path, **ask them for the permalink** rather than trying to derive it yourself — web_fetch can't reach the GitHub API to look up commit SHAs unless that exact URL already appeared in a search result, so automatic lookup isn't reliable. Getting a permalink is quick on their end: on the file's GitHub page, press `y` (or use the "..." menu → "Copy permalink").
- If no code/file applies to this video, drop the "💻 Code" section rather than leaving a placeholder.

## Presenting results

Show all three deliverables together, clearly labeled. Then:

- Say which research path was used (web-search, Chrome, or the WebSearch fallback), how many videos were analyzed, and how many YouTube searches were used.
- List the 3-5 competitor videos that most shaped the result, each with its link, views, and views-to-subscribers ratio, and one line on what it showed.
- Briefly flag anything you inferred or assumed (e.g., "assumed this is a standalone video, not part of a series") so the user can correct it easily, and flag any research step that degraded to a fallback path.