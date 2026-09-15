#!/usr/bin/env bash
# Builds the Flutter web app and publishes ONLY the build output to the
# `gh-pages` branch. The branch is replaced on every deploy with a single
# commit, so it never contains source code or accumulated old builds.
#
# Usage:  ./scripts/deploy_gh_pages.sh
# Site:   https://<owner>.github.io/<repo>/
set -euo pipefail

BRANCH="gh-pages"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

REMOTE_URL="$(git remote get-url origin)"
# Repo name from the remote, e.g. .../sankul-demo.git -> sankul-demo
REPO_NAME="$(basename "$REMOTE_URL" .git)"
SOURCE_SHA="$(git rev-parse --short HEAD)"

echo "▸ Building web app for /$REPO_NAME/ …"
# --no-web-resources-cdn bundles CanvasKit so the site doesn't depend on
# Google's CDN at runtime.
flutter build web --release --no-web-resources-cdn --base-href "/$REPO_NAME/"

STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT
cp -R build/web/. "$STAGE/"
# Serve files as-is (no Jekyll processing on GitHub Pages).
touch "$STAGE/.nojekyll"

cd "$STAGE"
git init -q -b "$BRANCH"
git add -A
git commit -q -m "Deploy $SOURCE_SHA to GitHub Pages${DEPLOY_NOTE:+

$DEPLOY_NOTE}"

echo "▸ Publishing to $BRANCH …"
git push --force "$REMOTE_URL" "$BRANCH:$BRANCH"

OWNER="$(basename "$(dirname "$REMOTE_URL")" | tr '[:upper:]' '[:lower:]')"
echo "✓ Deployed. Live at https://$OWNER.github.io/$REPO_NAME/ (allow ~1 min)"
