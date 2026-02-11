---
name: git-commit
description: The user's workflow to commit and push files properly
license: Complete terms in LICENSE.txt
---

The user has requested a git commit. You should NOT manually `git commit`, use this workflow.

First, use git status. Commits should be grouped into relevant groups of files that make sense to commit together. For each group:
- `git add <files>`: add this group of files
- `gencommit`: automatically generates a message and runs `git commit -m <generated_message>`

Then after all groups are committed, run `git push`.
