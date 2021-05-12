#!/usr/bin/env bats

load temp
load subdir

@test "ifdef patch argument is passed through" {
    run updateWithPatch --ifdef PATCHED "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "#ifdef PATCHED
new first line
#endif
first line
#ifndef PATCHED
second line
#else
augmented second line
#endif
third line
#ifndef PATCHED
second-to-last line
#endif
last line" ]
}

@test "in-place -p0 argument is passed through" {
    run updateWithPatch --in-place -p1 <(subdirPatchTarget "$PATCH")
    [ $status -eq 0 ]
    [ "$output" = "" ]
    cmp "$FILE" "$RESULT"
}
