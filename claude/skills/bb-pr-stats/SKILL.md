---
name: bb-pr-stats
description: GitHub PR stats (authored, reviewed, commented) for team members across 1/2/3 month windows.
allowed-tools: Bash(gh *), Bash(jq *), Bash(cat *), Bash(wc *), Bash(head *), Bash(tail *), Bash(cp *), Bash(mkdir *), Bash(date *), Write, Read
---

# BB PR Stats

Query GitHub PR statistics for BonkBot team members.
Shows PRs authored and PRs reviewed/commented across
1, 2, and 3 month windows.

## Usage

```
/bb-pr-stats [usernames...]
```

### Examples

```
/bb-pr-stats dulguun-bonkbot vsai poegva
/bb-pr-stats vsai
/bb-pr-stats --all
```

If no usernames are provided, default to:
`dulguun-bonkbot`, `vsai`, `poegva`

## Configuration

| Setting | Value |
|---------|-------|
| Repo | `BonkBotTeam/bonkbot` |
| Bot reviewers to exclude | `coderabbitai`, `chatgpt-codex-connector`, `github-actions` |
| Self-reviews | Excluded from review counts |
| Time windows | 1 month, 2 months, 3 months from today |

### vsai special handling

For user `vsai`, also compute a **filtered** merged count
that excludes:
- PRs targeting a branch matching `^release`
- PRs from branches starting with `script/`

This separates release/deploy PRs from feature work.

## Workflow

### Step 1: Compute Date Boundaries

Calculate three dates relative to today:
- 1 month ago
- 2 months ago
- 3 months ago

Use ISO 8601 format (YYYY-MM-DD).

### Step 2: Fetch All Merged PRs via GraphQL

Use `gh api graphql` to fetch ALL merged PRs in the
3-month window (the superset). Paginate with 100 per page.

**Important:** Do NOT use `gh pr list --author` or
`gh search prs --author/--reviewed-by` for this task.
These endpoints have known permission issues with certain
GitHub accounts and return incomplete data. Always use
GraphQL.

Query template for each page:

```graphql
{
  search(
    query: "repo:BonkBotTeam/bonkbot is:pr is:merged merged:>DATE"
    type: ISSUE
    first: 100
    after: CURSOR_OR_NULL
  ) {
    issueCount
    pageInfo { hasNextPage endCursor }
    nodes {
      ... on PullRequest {
        number
        title
        url
        author { login }
        mergedAt
        baseRefName
        headRefName
        reviews(first: 100) {
          nodes { author { login } state }
        }
        comments(first: 100) {
          nodes { author { login } }
        }
      }
    }
  }
}
```

Paginate until `hasNextPage` is false. Combine all nodes
into a single JSON array saved to `/tmp/gh_all_prs.json`.

### Step 3: Compute Aggregate Stats

Write a jq script to `/tmp/compute_pr_stats.jq` that:

1. Takes the target usernames as `$users` (semicolon-
   separated string, split in jq).
2. For each time window, computes:
   - **PRs merged**: count where `author.login` matches
   - **PRs reviewed or commented** (excluding self-review
     and bots): count of unique PRs where the user left a
     formal review OR issue comment on someone else's PR

Use this jq pattern to exclude self-reviews and bots:

```jq
def bot_users: [
  "coderabbitai",
  "chatgpt-codex-connector",
  "github-actions"
];
def is_bot: . as $u | bot_users | any(. == $u);
```

A user counts as "reviewed or commented" on a PR if:
- They appear in `reviews.nodes[].author.login` OR
  `comments.nodes[].author.login`
- AND they are NOT the PR author (no self-review)
- AND they are NOT a bot

### Step 4: Generate CSV

Generate a CSV file at `/tmp/bonkbot_pr_stats.csv` with
one row per (PR, user) pair where the user was involved
(authored, reviewed, or commented). Columns:

```
pr_number, pr_url, pr_title, merged_at, base_branch,
head_branch, user, is_author, reviewed, review_states,
commented
```

- `is_author`: "YES" if user authored the PR, else empty
- `reviewed`: "YES" if user left a formal review
  (excluding self-review), else empty
- `review_states`: semicolon-separated unique states
  (APPROVED, COMMENTED, CHANGES_REQUESTED), else empty
- `commented`: "YES" if user left an issue comment
  (excluding self), else empty

Also copy the CSV to the repo root: `bonkbot_pr_stats.csv`

### Step 5: Present Results

Display two tables:

**Table 1: PRs Merged**

| User | Last 1 Month | Last 2 Months | Last 3 Months |
|------|:---:|:---:|:---:|
| user1 | N | N | N |

For `vsai`, show two rows: total and
"excl release/script".

**Table 2: PRs Reviewed / Commented (excl self & bots)**

| User | Last 1 Month | Last 2 Months | Last 3 Months |
|------|:---:|:---:|:---:|
| user1 | N | N | N |

After the tables, note:
- The date boundaries used
- That the CSV is saved at `bonkbot_pr_stats.csv`
- Total PRs in the 3-month window

## Notes

- The GitHub search API (`gh search prs`) has known
  permission issues with some accounts. Always use the
  GraphQL API for reliable results.
- GraphQL search returns max 1000 results. If the repo
  exceeds that in 3 months, narrow the date ranges.
- Reviews include APPROVED, COMMENTED, and
  CHANGES_REQUESTED states.
- Issue comments (non-review) are tracked separately in
  the CSV but combined with reviews in the aggregate
  "reviewed or commented" count.
