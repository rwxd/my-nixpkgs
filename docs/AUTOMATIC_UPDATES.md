# Automatic Package Updates

This document explains the automatic update mechanism implemented for this repository.

## Overview

This repository now has an automated update system that:
- Checks for new releases of packages daily
- Automatically updates package definitions
- Tests the updates by building them
- Creates pull requests for review

## Components

### 1. GitHub Actions Workflow: `update-packages.yml`

Located at `.github/workflows/update-packages.yml`, this workflow:

- **Schedule**: Runs daily at 00:00 UTC
- **Manual Trigger**: Can be triggered manually from the GitHub Actions UI
- **Per-Package Jobs**: Each package is checked independently using a matrix strategy
- **Process**:
  1. Checks GitHub releases for the package's upstream repository
  2. Compares the latest release version with the current version in `package.nix`
  3. If an update is available:
     - Downloads the new source archive
     - Calculates the new hash using `nix-prefetch-url`
     - Updates `package.nix` with new version, rev, and hash
     - Builds the package to verify it works
     - Creates a pull request with the changes

### 2. CI Workflow: `ci.yml`

Located at `.github/workflows/ci.yml`, this workflow:

- **Triggers**: Runs on pull requests and pushes to main branch
- **Actions**:
  - Checks the flake validity
  - Builds all packages to ensure they work
  - Displays package metadata

This ensures that all updates (both automatic and manual) are verified before merging.

### 3. Manual Update Script: `scripts/update-package.sh`

A convenience script for updating packages locally:

```bash
./scripts/update-package.sh <package-name>
```

**Features**:
- Interactive prompts
- Fetches latest release from GitHub
- Calculates hash automatically
- Tests the build
- Shows the diff of changes

**Requirements**:
- Nix with flakes enabled
- GitHub CLI (`gh`) installed and authenticated

## How It Works

### Automatic Updates via GitHub Actions

1. **Daily Check**: At 00:00 UTC, the workflow starts
2. **For Each Package**:
   ```
   notify-me → Check rwxd/notify-me releases
   vmrss → Check rwxd/vmrss releases
   best-of → Check rwxd/best-of releases
   pdnsgrep → Check akquinet/pdnsgrep releases
   dnsbl-exporter → Check Luzilla/dnsbl_exporter releases
   ```
3. **Version Comparison**: Current version (from `package.nix`) vs. latest release tag
4. **If Update Available**:
   - Download source: `https://github.com/owner/repo/archive/refs/tags/vX.Y.Z.tar.gz`
   - Calculate hash: `nix-prefetch-url --unpack <url>`
   - Update `package.nix`:
     - `version = "X.Y.Z"`
     - `rev = "vX.Y.Z"`
     - `sha256 = "sha256-..."`
   - Build: `nix build '.#package-name'`
   - Create PR with title: `chore: update package-name to X.Y.Z`

### Pull Request Format

Automated PRs include:
- **Title**: `chore: update <package> to <version>`
- **Body**:
  - Package name and version change
  - Link to upstream repository
  - Link to release notes
  - Automatic labels: `automated`, `dependencies`
- **Branch**: `update/<package>-<version>`
- **Auto-delete**: Branch is deleted after merge

## Configuration

### Adding New Packages to Auto-Update

To add a new package to automatic updates, edit `.github/workflows/update-packages.yml`:

```yaml
strategy:
  matrix:
    package:
      - name: new-package
        owner: github-username
        repo: repository-name
```

### Customizing Update Schedule

To change the schedule, edit the `cron` expression in `update-packages.yml`:

```yaml
on:
  schedule:
    - cron: '0 0 * * *'  # Daily at 00:00 UTC
```

Common schedules:
- Daily: `'0 0 * * *'`
- Weekly (Monday): `'0 0 * * 1'`
- Twice daily: `'0 0,12 * * *'`

### Manual Triggering

You can manually trigger updates:

1. Go to the [Actions tab](../../actions/workflows/update-packages.yml)
2. Click "Run workflow"
3. Select the branch (usually `main`)
4. Click "Run workflow"

## Package Requirements

For automatic updates to work, packages must:

1. Use `fetchFromGitHub` in their `package.nix`
2. Have `owner` and `repo` fields
3. Have a `version` field
4. Have a `rev` field (typically `v${version}`)
5. Have a `sha256` field
6. Have releases on GitHub

## Comparison with nixpkgs-update

This implementation is inspired by [nixpkgs-update](https://github.com/nix-community/nixpkgs-update) but adapted for a custom flake repository:

**Differences**:
- nixpkgs-update is designed for the main nixpkgs repository with thousands of packages
- This implementation is tailored for a small set of custom packages
- Uses GitHub Actions instead of a dedicated bot infrastructure
- Simpler implementation focused on `fetchFromGitHub` sources
- Creates PRs directly instead of maintaining a separate update repository

**Similarities**:
- Automatic version detection
- Hash calculation
- Build verification
- Pull request creation

## Maintenance

### Monitoring

- Check [Actions tab](../../actions) for workflow runs
- Failed workflows will show which packages failed to update
- Pull requests are created automatically for review

### Troubleshooting

**Update workflow fails**:
- Check if the package has new releases on GitHub
- Verify the package still builds with `nix build '.#package-name'`
- Check workflow logs for specific errors

**Build fails after update**:
- The PR build will fail, preventing merge
- Investigate if the new version has breaking changes
- May need manual intervention to fix dependencies or patches

**No PR created**:
- Check if there's actually a new release
- Verify the package owner/repo in the workflow is correct
- Check if a PR already exists for that version

## Future Enhancements

Possible improvements:
- Add support for other source fetchers (not just `fetchFromGitHub`)
- Automatic merge of PRs after successful CI
- Notifications for failed updates
- Support for pre-releases/beta versions
- Changelogs in PR descriptions
