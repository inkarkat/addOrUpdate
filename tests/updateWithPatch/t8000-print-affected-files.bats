#!/usr/bin/env bats

load temp
load subdir

@test "printing affected existing file keeps the original intact" {
    run updateWithPatch --print-affected-files "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "existing.txt" ]
    cmp "$EXISTING" "$FILE"
}

@test "printing affected other file" {
    cp -f "$EXISTING" "$OTHER"
    run updateWithPatch --print-affected-files <(renamePatchTarget "$OTHER" "$PATCH")
    [ $status -eq 0 ]
    [ "$output" = "other.txt" ]
}

@test "printing affected existing and other files" {
    cp -f "$EXISTING" "$OTHER"
    run updateWithPatch --print-affected-files "$PATCH" <(renamePatchTarget "$OTHER" "$PATCH")
    [ $status -eq 0 ]
    [ "$output" = "existing.txt
other.txt" ]
}

@test "printing affected existing, other, and subdir files" {
    cp -f "$EXISTING" "$OTHER"
    cp -f "$EXISTING" "$SUBDIR"
    run updateWithPatch -p0 --print-affected-files "$PATCH" <(renamePatchTarget "$OTHER" "$PATCH") <(subdirPatchTarget "$PATCH")
    [ $status -eq 0 ]
    [ "$output" = "existing.txt
other.txt
subdir/existing.txt" ]
}

@test "printing affected duplicate existing and other files only lists unique files" {
    cp -f "$EXISTING" "$OTHER"
    run updateWithPatch --print-affected-files <(renamePatchTarget "$OTHER" "$PATCH") "$PATCH" <(renamePatchTarget "$OTHER" "$PATCH")
    [ $status -eq 0 ]
    [ "$output" = "existing.txt
other.txt" ]
}

@test "printing reverse patch fails with 1 and does not print files" {
    run updateWithPatch --print-affected-files "$REVERTED_PATCH"
    [ $status -eq 1 ]
    [ "$output" = "" ]
}

@test "printing non-applicable patch fails with 1 and does not print files" {
    run updateWithPatch --print-affected-files "$UNAPPLICABLE_PATCH"
    [ $status -eq 1 ]
    [ "$output" = "" ]
}
