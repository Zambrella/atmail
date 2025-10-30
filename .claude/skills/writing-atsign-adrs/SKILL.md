---
name: writing-atsign-adrs
description: Use when making architectural decisions for atPlatform/atProtocol projects (database schema, API design, technology choices, naming conventions, tooling standards) - creates ADR using Atsign's standard format before implementation
---

# Writing Atsign Architecture Decision Records

## Overview

Architecture Decision Records (ADRs) at Atsign document **why** you made architectural choices using a specific format aligned with the atProtocol organization standards. Write ADRs **before implementing**, not after.

**Core principle:** ADR writing is a decision-making tool first, documentation second. Writing forces you to think through alternatives and trade-offs in a structured, professional format.

## When to Use

**Create an ADR when making decisions about:**
- atProtocol key naming conventions and patterns
- Database schema design for atSign-based applications
- API design and atServer communication patterns
- Technology selection (frameworks, libraries, SDK dependencies)
- Cross-cutting patterns (authentication, enrollment, key management)
- Platform-wide tooling standards (formatters, linters, build tools)
- Package versioning and dependency management
- atRecord metadata and structure decisions

**When NOT to use:**
- Implementation details within established patterns
- Code organization that doesn't affect external interfaces
- UI-only choices that don't affect architecture
- Decisions already covered by existing ADRs

## Red Flags - Write an ADR

If you think any of these thoughts, **STOP and write an ADR:**

- "Should I use X or Y for this atKey structure?"
- "This naming convention will affect multiple apps"
- "Future developers will wonder why we chose this approach"
- "There are multiple valid approaches for this atProtocol pattern"
- "This affects how apps interact with atServer"
- "This decision impacts the entire organization/ecosystem"

## Timing: BEFORE Implementation

**The rule:** Write the ADR before you write the code.

**Process:**
1. Identify the decision point
2. Write the ADR (exploring options and trade-offs)
3. Get feedback/approval if needed
4. Implement the chosen approach
5. Commit ADR with implementation (or separately)

**Why before, not after:**
- Writing clarifies your thinking - might reveal better approach
- Forces you to consider alternatives, not just rationalize what you built
- ADR captures genuine uncertainty, not post-hoc justification
- Prevents "I'll document it later" (which becomes never)

## Atsign ADR Template Structure

```markdown
# Title

<!-- This template is inspired by
https://github.com/GoogleCloudPlatform/emblem/tree/main/docs/decisions -->

* **Status:** Draft / Approved / Rejected / Superseded
* **Last Updated:** YYYY-MM-DD
* **Objective:** Single sentence summary

## Context & Problem Statement

[Explain the context and the problem you're trying to solve.
What's the current situation? What challenges exist?
What triggered the need for this decision?]

## Goals

[List the specific goals this decision aims to achieve]

### Non-goals

[What are you explicitly NOT trying to solve with this decision?
This helps scope the ADR appropriately]

## Other considerations <!-- optional -->

[Any other important context, constraints, or considerations
that inform the decision]

## Considered Options <!-- optional -->

* ### Option 1

[Description of option 1]
[Pros and cons]
[Why chosen or not chosen]

* ### Option 2

[Description of option 2]
[Pros and cons]
[Why chosen or not chosen]

## Proposal Summary

[Brief summary of what you're proposing]

## Proposal in Detail

[Detailed explanation of the proposal. Be specific about:
- Exact implementation approach
- Technical details
- How it addresses the goals
- Examples if relevant]

### Expected Consequences <!-- optional -->

[What will happen as a result of this decision?
- Code changes required
- Migration path
- Impact on existing systems
- Breaking changes]
```

## File Naming Convention

**Format:** `YYYY-MM-description-with-dashes.md`

**Examples:**
- `2024-07-apkam-key-conventions.md`
- `2025-04-default-line-length-80.md`
- `2024-09-format-and-lint-tooling.md`

**Important:**
- Use date format: YYYY-MM (year and month)
- Use descriptive kebab-case for the description
- No sequential numbers (unlike traditional ADRs)
- Place in `decisions/` directory at repository root

## Section Guidance

### Status
- **Draft:** Still being discussed, not yet approved
- **Approved:** Accepted and should be followed
- **Rejected:** Considered but not adopted
- **Superseded:** Replaced by a newer ADR (link to it)

### Context & Problem Statement
Be specific and concrete. What's broken? What new requirement emerged?

**Good:** "Right now, we have no clear guidelines on how to name APKAM keys for the user. If the keys are not named consistently, it will be difficult for users and apps to understand which keys are available and how to use them."

**Bad:** "We need better key naming."

### Goals vs Non-goals
Goals are what you're trying to achieve. Non-goals prevent scope creep.

**Example:**
- Goal: "Create a consistent naming convention for APKAM keys"
- Non-goal: "Specifying the key conventions as defaults in our documentation"

### Considered Options
Show you actually explored alternatives. Each option should include:
- What it is
- Why you might choose it
- Why you did or didn't choose it

Use nested headers (###) for each option.

### Proposal Summary vs Detail
- **Summary:** 2-3 sentences, high-level
- **Detail:** Technical specifics, implementation approach, examples

### Expected Consequences
Be honest about impacts:
- What code needs to change?
- What's the migration path?
- What breaks?
- What apps/packages are affected?

## Common Mistakes

### ❌ Writing ADR after implementation
**Why bad:** Becomes rationalization of what you built, not genuine exploration of options.

**Fix:** Write ADR when you realize you have a decision to make, before you start coding.

### ❌ "Too simple to document"
**Thought:** "This is obvious, I don't need an ADR"

**Reality:** If it affects multiple projects or the ecosystem, document it. Organizational decisions need organizational memory.

**Fix:** Even simple decisions like "change line length to 80" get ADRs at Atsign.

### ❌ Vague or generic language
**Bad:** "We need better tooling for consistency"

**Good:** "Members of the team use various formatters outside of Dart which results in problematic code reviews containing lots of quote changes, white space changes, etc."

### ❌ Skipping the "Considered Options" section
**Why bad:** Doesn't show you actually explored alternatives.

**Fix:** List at least 2 options. If there truly are no alternatives, question whether you need an ADR.

### ❌ Not updating Status field
**Why bad:** Team doesn't know if ADR is approved and should be followed.

**Fix:** Start with "Draft", move to "Approved" after review, or "Rejected" if declined.

### ❌ Missing Expected Consequences
**Why bad:** Team doesn't understand the impact/effort required.

**Fix:** Be specific about what needs to change, even if it's "no breaking changes expected."

## Concrete Example

**Good ADR excerpt (from 2024-07-apkam-key-conventions.md):**

```markdown
## Considered Options

* ### Remove the -k flag as a mandatory flag in at_activate enroll

Come up with default key name for APKAM keys. The user will still be able
to see which keys are for what using the `at_activate list` command

Such as:
* `@soccer0_{enrollment_id}_key.atKeys`
* `@soccer0_{hashed_namespace}_key.atKeys`

* ### Create a naming convention for APKAM keys in the documentation

Create a naming convention for APKAM keys in the documentation.

Right now the default is `@soccer0_key.atKeys`. Which is the same as
the manager key. However we are completely riding on the fact that
the user will get the prompt to NOT overwrite the key.

Leaving these decisions up to the user is not ideal. When a more
advanced user wishes to use a specific key name, they can use the `-k` flag.
```

**Bad ADR excerpt:**
```markdown
## Proposal

We're going to use better key names.

### Consequences

Things will be better.
```

## Workflow Integration

### With existing ADRs in organization:
1. Check `decisions/` directory at https://github.com/atsign-foundation/at_protocol/tree/trunk/decisions
2. Review existing ADRs for similar decisions
3. If decision already exists - follow it
4. If decision partially covered - reference it and explain how yours differs
5. If superseding an older ADR - mark the old one as "Superseded"

### Creating new ADR:
1. Copy template to `decisions/YYYY-MM-your-decision.md`
2. Fill in all required sections
3. Start with Status: Draft
4. Share for feedback
5. Update to Status: Approved when ready
6. Commit with implementation (or separately if needed)

### File location:
- Place ADRs in `decisions/` directory at repository root
- If working in a package/app, consider where the ADR should live:
  - Organization-wide decisions: `at_protocol/decisions/`
  - Project-specific decisions: `your-project/decisions/`

## Rationalization Table

| Excuse | Reality |
|--------|---------|
| "Too simple to document" | Organizational decisions need organizational memory. |
| "I'll document after implementing" | Becomes rationalization, not decision record. |
| "This only affects my project" | atProtocol patterns often spread across ecosystem. |
| "Takes too much time" | 30 min now saves hours of confusion later. |
| "I already decided" | Then writing is quick. Do it before coding. |
| "ADR is bureaucratic overhead" | ADR prevents ecosystem fragmentation. |

**All of these mean: Stop. Write the ADR before coding.**

## Professional Tone

Atsign ADRs use professional, technical language:
- Use "we" and "our" for organizational perspective
- Be direct and specific about problems
- Show reasoning, not just conclusions
- Reference technical details (commands, file names, code examples)
- Link to related resources when helpful

**Example of professional tone:**
> "Members of the team use various markup / code styles / formatters outside of Dart which results in some problematic code reviews containing lots of quote changes, white space changes, etc."

Not: "Formatting is a mess and causing problems."

## The Bottom Line

**Architecture Decision Records at Atsign use a specific format and conventions.**

Write them **before implementation** - they're decision-making tools, not post-hoc documentation.

Follow the template structure exactly. Use professional, specific language.

Name files `YYYY-MM-description.md` and place in `decisions/` directory.

30 minutes writing an ADR prevents ecosystem fragmentation and hours of "why did we do it this way?" later.
