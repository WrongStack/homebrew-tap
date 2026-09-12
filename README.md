# wrongstack/homebrew-tap

Homebrew tap for [WrongTop](https://github.com/wrongstack/wrongtop) —
a cross-platform terminal system monitor.

## Install

```bash
brew install --cask wrongstack/tap/wrongtop
```

Homebrew taps this repository automatically on first install; to tap it
explicitly:

```bash
brew tap wrongstack/tap https://github.com/wrongstack/homebrew-tap
```

## How this tap is updated

Every `v*` tag on wrongstack/wrongtop runs the goreleaser release
workflow (`.github/workflows/release.yml`), which regenerates
`Casks/wrongtop.rb` — version, sha256 digests and download URLs — and
commits it here. The file is **generated**: do not edit it by hand; any
manual change is overwritten on the next release.

Until goreleaser's `homebrew_casks.skip_upload` is flipped to `false`
in wrongtop's `.goreleaser.yaml`, the checked-in cask is a bootstrap
pinned to the latest tagged release and updates here stay manual.

The macOS release binaries are unsigned and un-notarized; the cask
drops the quarantine attribute on install (a `postflight` xattr hook),
mirroring the goreleaser hook, so Gatekeeper does not block launches.

## Release engineering: turning on automatic cask pushes

One-time checklist for wrongstack/wrongtop maintainers:

1. **Token** — create a fine-grained personal access token:
   - Repository access: **only** `wrongstack/homebrew-tap`
   - Permissions: **Contents: Read and write**
   - Classic alternative: `repo` scope (grants far more access;
     fine-grained is strongly preferred)
   - The workflow's default `GITHUB_TOKEN` cannot be used for this: it
     is scoped to wrongstack/wrongtop only, and goreleaser pushes to a
     different repository.

2. **Secret** — set it on wrongstack/wrongtop (requires repo admin):

   ```bash
   gh secret set HOMEBREW_TAP_TOKEN --repo WrongStack/wrongtop
   ```

3. **Flip** — in wrongtop's `.goreleaser.yaml`, set
   `homebrew_casks.skip_upload: false` (or delete the line; `false` is
   the default), commit to main, and cut the next `v*` tag.

4. **Validate** — the release run's goreleaser step now commits the
   regenerated cask here; verify end to end:

   ```bash
   brew update && brew install --cask wrongstack/tap/wrongtop
   wrongtop version
   ```

If the token is missing or lacks write access once `skip_upload` is
false, the release workflow fails on the homebrew step — flip only
after step 2 is confirmed.
