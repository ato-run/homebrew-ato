# homebrew-ato

Homebrew tap for [ato](https://ato.run) — the meta-runtime CLI.

## Install (CLI only)

```bash
brew install ato-run/ato/ato-cli
```

## Want the Desktop bundle?

The Cask was removed in v0.4.88. The Desktop app, the CLI, and nacelle
are now distributed together through the shell installer, which avoids
the macOS quarantine warning that the `.dmg`-based Cask was triggering:

```bash
curl -fsSL https://ato.run/install.sh | sh
```

If you previously installed via the legacy Cask, clean it up first:

```bash
brew uninstall --cask ato 2>/dev/null || true
curl -fsSL https://ato.run/install.sh | sh
```

## What is ato?

`ato` runs any GitHub repo, registry package, or local script in isolation — no install needed.

```bash
ato run github.com/owner/repo
ato run pypi:markitdown -- --help
```

See [ato.run](https://ato.run) for docs.
