#!/usr/bin/env bats

load temp
load subdir

@test "printing first affected existing and other files only prints the first file" {
    cp -f "$EXISTING" "$OTHER"
    run updateWithPatch --first --print-affected-files "$PATCH" <(renamePatchTarget "$OTHER" "$PATCH")
    [ $status -eq 0 ]
    [ "$output" = "existing.txt" ]
}

@test "printing first affected non-applicable, existing and other files only prints the first good file" {
    cp -f "$EXISTING" "$OTHER"
    run updateWithPatch --first --print-affected-files "$UNAPPLICABLE_PATCH" "$PATCH" <(renamePatchTarget "$OTHER" "$PATCH")
    [ $status -eq 0 ]
    [ "$output" = "existing.txt" ]
}
