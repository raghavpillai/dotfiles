---
name: code-review
description: Comprehensive code review with high signal, low noise. Flags only critical issues (bugs, security, performance, breaking changes). Skips style, nits, and minor improvements. Outputs a structured report.
allowed-tools: Read, Glob, Grep, Bash
---

# Code Review

High-precision code review that flags critical issues only. Generates a structured report with findings.

## Core Principle: High Signal, Low Noise

**Only flag these:**
- **Bugs**: Logic errors, crashes, incorrect behavior, unhandled edge cases
- **Security**: SQL injection, XSS, auth bypass, credential leaks, input validation gaps
- **Performance**: N+1 queries, inefficient algorithms, memory leaks, missing indexes
- **Breaking changes**: API incompatibilities, data migration issues
- **Critical architectural violations**: Layer separation breaks, major pattern deviations

**Never flag these:**
- Style preferences, formatting, naming conventions
- Minor improvements, optimizations, or refactoring suggestions
- Nits, typos, comments about comments
- Positive feedback
- Anything that doesn't materially affect correctness, security, or performance

## Workflow

### 1. Get the Diff
```bash
# Compare against main/master
git diff main...HEAD

# Or specific commits
git diff <base-commit>..<head-commit>

# Or staged changes
git diff --cached
```

### 2. Gather System Context
**Never review in isolation.** Understand the larger system:
- `Read`: Check files that interact with changes (callers, implementations, tests)
- `Grep`: Find similar patterns, conventions, how problems are solved elsewhere
- `Glob`: Locate integration points (schemas, APIs, service interfaces)

### 3. Identify Critical Issues Only
Scan for **high-severity problems**:

- **Bugs**: Null derefs, unhandled errors, logic errors, edge case failures
- **Security**: Injection vulnerabilities, auth bypass, credential exposure, missing validation
- **Performance**: N+1 queries, inefficient algorithms, memory/resource leaks
- **Breaking changes**: API incompatibilities, migration issues
- **Architecture**: Layer violations, tight coupling

**Skip everything else.**

### 4. Generate Report

Output a structured report with findings:

```
## Code Review Report

### Summary
[1-2 sentence overview of changes and critical findings]

### Critical Issues

#### [file:line] category: title
Description of the issue and its impact.

#### [file:line] category: title
Description of the issue and its impact.

### Recommendations
[Optional: high-level suggestions if architectural changes needed]
```

## Finding Format

**Pattern:** `[file:line] category: issue`

Categories: `bug`, `security`, `performance`, `breaking`, `architecture`

**Examples:**
- `[src/user.ts:42] bug: Null pointer if user.profile is undefined`
- `[src/db.ts:89] security: SQL injection via string concatenation`
- `[src/order.ts:234] performance: N+1 query in loop`
- `[src/api.ts:15] breaking: Response structure changed`

Keep descriptions concise. State the issue and impact, not lengthy explanations.

## Critical Patterns to Check

### Bugs
- **Null/nil dereferences**: Missing null checks causing crashes
- **Unhandled errors**: Errors silently ignored
- **Resource leaks**: Unclosed connections, file handles, memory
- **Race conditions**: Concurrent access without synchronization

### Security
- **SQL injection**: String concatenation in queries
- **XSS**: Unescaped user input in HTML
- **Auth bypass**: Missing auth checks on protected routes
- **Authorization gaps**: Missing permission validation
- **Credential exposure**: Secrets in code

### Performance
- **N+1 queries**: Database queries in loops
- **Missing indexes**: Queries on unindexed columns
- **Inefficient algorithms**: O(n²) where O(n log n) possible
- **Memory issues**: Loading full datasets when streaming appropriate

### Architecture
- **Layer violations**: Business logic in presentation, DB calls in handlers
- **Tight coupling**: Hard dependencies that should be abstracted

**Context matters:** Check project's CLAUDE.md for project-specific patterns before flagging architectural issues.
