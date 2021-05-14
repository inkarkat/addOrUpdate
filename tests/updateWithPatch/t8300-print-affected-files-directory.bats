#!/usr/bin/env bats

load temp
load subdir

@test "printing affected existing file relative to changed directory includes that directory" {
    cp -f "$EXISTING" "$SUBDIR"
    run updateWithPatch --print-affected-files --directory subdir "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "${BATS_TMPDIR}/subdir/existing.txt" ]
}
