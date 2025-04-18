#!/usr/bin/env bats

load temp
load subdir

@test "printing affected existing file relative to changed directory includes that directory" {
    cp -f "$EXISTING" "$SUBDIR"
    run -0 updateWithPatch --print-affected-files --directory subdir "$PATCH"
    assert_output "${BATS_TMPDIR}/subdir/existing.txt"
}
