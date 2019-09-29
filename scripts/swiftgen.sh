#!/bin/sh

ROOT="$SRCROOT/Meteo/Generated"
SWIFTGEN="Pods/SwiftGen/bin/swiftgen"
INDIR="$ROOT/Inputs"
OUTDIR="$ROOT/Outputs"

# Use Swiftgen templates
"$SWIFTGEN" ib "$SRCROOT/Meteo" -t scenes-swift4 -o "$OUTDIR"/StoryboardScenes.swift
