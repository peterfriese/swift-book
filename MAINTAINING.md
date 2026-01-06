# Maintaining the PDF Edition

Since this repository is a fork of [swiftlang/swift-book](https://github.com/swiftlang/swift-book), you will periodically want to pull in changes from the official book to your custom PDF edition.

## The Branch Strategy

*   `main`: Mirrors the official `upstream/main`. We **do not** commit custom changes here.
*   `pdf-edition`: Your custom branch with the PDF build infrastructure. This is the default branch.

## How to Sync Upstream

When the official book is updated, follow these steps to update your PDF edition:

### 1. Update `main`
First, bring your local `main` branch up to date with the upstream repository.

```bash
# Checkout main
git checkout main

# Fetch the latest from upstream
git fetch upstream

# Hard reset local main to match upstream/main EXACTLY
# (This discards any minimal local diffs if any, ensuring a clean mirror)
git reset --hard upstream/main

# Push the updated main to your fork
git push origin main --force
```

### 2. Merge into `pdf-edition`
Now, merge the updated content into your custom branch.

```bash
# Checkout your working branch
git checkout pdf-edition

# Merge changes from main
git merge main -m "chore: sync with upstream"
```

### 3. Resolve Conflicts (If Any)
If the upstream changes conflict with your build scripts (unlikely, as we mostly touched `bin/` and `.github/`), git will ask you to resolve them.
*   Edit the conflicting files.
*   `git add <file>`
*   `git commit`

### 4. Push and Build
Pushing the merge will trigger a new PDF build automatically.

```bash
git push origin pdf-edition
```

## Verify
Check the **Actions** tab in GitHub to see the new build running. Once complete, the updated `swift-book.pdf` will be attached to the release or artifact.
