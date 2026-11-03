#!/usr/bin/env bash
# Wraps a locally built macOS editor binary in a signed Godot.app, the same way
# the "Create macOS app bundle" step in .github/workflows/macos_builds.yml does.
#
# Usage (from the repository root):
#   misc/scripts/make_macos_app.sh [binary] [output_dir]
#
#   binary      Editor binary to bundle. Default: newest bin/godot.macos.editor*.
#   output_dir  Where Godot.app and Godot.macos.editor.app.zip go. Default: bin/
#
# Signing:
#   By default the app is ad-hoc signed, exactly like the CI artifact.
#   Set CODESIGN_IDENTITY to sign with a real certificate instead, e.g.
#   CODESIGN_IDENTITY="Developer ID Application: Your Name (TEAMID)" misc/scripts/make_macos_app.sh

set -euo pipefail

cd "$(dirname "$0")/../.."

BIN="${1:-}"
OUT_DIR="${2:-bin}"
IDENTITY="${CODESIGN_IDENTITY:--}"

if [[ -z "$BIN" ]]; then
	BIN="$(ls -t bin/godot.macos.editor* 2>/dev/null | grep -v '\.zip$' | head -n 1 || true)"
fi
if [[ -z "$BIN" || ! -f "$BIN" ]]; then
	echo "Error: no editor binary found. Build one first: scons platform=macos target=editor" >&2
	exit 1
fi

# Pick the Info.plist that matches the binary's architectures.
ARCHS="$(lipo -archs "$BIN")"
case "$ARCHS" in
	*x86_64*arm64* | *arm64*x86_64*) PLIST="Info.plist" ;;
	arm64) PLIST="Info_arm64.plist" ;;
	x86_64) PLIST="Info_x86_64.plist" ;;
	*)
		echo "Error: unexpected architectures in $BIN: $ARCHS" >&2
		exit 1
		;;
esac

APP="$OUT_DIR/Godot.app"
ZIP="$OUT_DIR/Godot.macos.editor.app.zip"

echo "Bundling $BIN ($ARCHS) -> $APP"
rm -rf "$APP" "$ZIP"
mkdir -p "$OUT_DIR"
cp -R misc/dist/macos_tools.app "$APP"

# Keep only the plist for this architecture; the extra variants break codesign.
if [[ "$PLIST" != "Info.plist" ]]; then
	mv "$APP/Contents/$PLIST" "$APP/Contents/Info.plist"
fi
rm -f "$APP/Contents/Info_arm64.plist" "$APP/Contents/Info_x86_64.plist"

mkdir -p "$APP/Contents/MacOS"
cp "$BIN" "$APP/Contents/MacOS/Godot"
chmod +x "$APP/Contents/MacOS/Godot"

TIMESTAMP="--timestamp"
if [[ "$IDENTITY" == "-" ]]; then
	TIMESTAMP="--timestamp=none" # Ad-hoc signatures can't be timestamped offline anyway.
fi
codesign --force $TIMESTAMP --options=runtime \
	--entitlements misc/dist/macos/editor.entitlements \
	-s "$IDENTITY" "$APP"
codesign --verify --deep --strict "$APP"

ditto -c -k --keepParent "$APP" "$ZIP"

echo "Done:"
echo "  App: $APP"
echo "  Zip: $ZIP"
echo "Install with: cp -R \"$APP\" /Applications/"
