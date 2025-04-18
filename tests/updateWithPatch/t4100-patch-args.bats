#!/usr/bin/env bats

load temp
load subdir

@test "ifdef patch argument is passed through" {
    run -0 updateWithPatch --ifdef PATCHED "$PATCH"
    assert_output - <<'EOF'
#ifdef PATCHED
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
last line
EOF
}

@test "in-place -p0 argument is passed through" {
    run -0 updateWithPatch --in-place -p1 <(subdirPatchTarget "$PATCH")
    assert_output ''
    diff -y "$FILE" "$RESULT"
}
