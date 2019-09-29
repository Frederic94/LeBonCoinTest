#!/bin/sh

ROOT="$SRCROOT/Meteo-Components"
SWIFTGEN="Pods/SwiftGen/bin/swiftgen"
INDIR="$ROOT/Resources"
OUTDIR="$ROOT/Generated"

# Use Swiftgen templates
"$SWIFTGEN" xcassets -t swift4 "$INDIR/Components.xcassets" -o "$OUTDIR"/Assets.swift --param publicAccess
