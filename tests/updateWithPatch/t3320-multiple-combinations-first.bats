#!/usr/bin/env bats

load temp

@test "patching first with two alternatives succeeds" {
    run -0 updateWithPatch --first --test-only "$PATCH" "$ALTERNATIVE_PATCH"
    assert_output ''
}

@test "patching first with two no-mods returns 99" {
    run -99 updateWithPatch --first --test-only "$REVERTED_PATCH" "$REVERTED_PATCH"
    assert_output - <<'EOF'
Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored
Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored
EOF
}

@test "patching first with two non-applicables returns 4" {
    run -4 updateWithPatch --first --test-only "$UNAPPLICABLE_PATCH" "$UNAPPLICABLE_PATCH"
    assert_output - <<'EOF'
1 out of 1 hunk FAILED
1 out of 1 hunk FAILED
EOF
}

@test "patching first with success and no-mod succeeds" {
    run -0 updateWithPatch --first --test-only "$PATCH" "$REVERTED_PATCH"
    assert_output ''
}

@test "patching first with no-mod and success succeeds" {
    run -0 updateWithPatch --first --test-only "$REVERTED_PATCH" "$PATCH"
    assert_output - <<'EOF'
Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored
EOF
}

@test "patching first with success and non-applicable succeeds" {
    run -0 updateWithPatch --first --test-only "$PATCH" "$UNAPPLICABLE_PATCH"
    assert_output ''
}

@test "patching first with non-applicable and success succeeds" {
    run -0 updateWithPatch --first --test-only "$UNAPPLICABLE_PATCH" "$PATCH"
    assert_output '1 out of 1 hunk FAILED'
}

@test "patching first with no-mod and non-applicable returns 99" {
    run -99 updateWithPatch --first --test-only "$REVERTED_PATCH" "$UNAPPLICABLE_PATCH"
    assert_output - <<'EOF'
Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored
1 out of 1 hunk FAILED
EOF
}

@test "patching first with non-applicable and no-mod returns 99" {
    run -99 updateWithPatch --first --test-only "$UNAPPLICABLE_PATCH" "$REVERTED_PATCH"
    assert_output - <<'EOF'
1 out of 1 hunk FAILED
Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored
EOF
}

@test "patching first with success and no-mod and non-applicable succeeds" {
    run -0 updateWithPatch --first --test-only "$PATCH" "$REVERTED_PATCH" "$UNAPPLICABLE_PATCH"
    assert_output ''
}

@test "patching first with success and non-applicable and no-mod succeeds" {
    run -0 updateWithPatch --first --test-only "$PATCH" "$UNAPPLICABLE_PATCH" "$REVERTED_PATCH"
    assert_output ''
}

@test "patching first with no-mod and success and non-applicable succeeds" {
    run -0 updateWithPatch --first --test-only "$REVERTED_PATCH" "$PATCH" "$UNAPPLICABLE_PATCH"
    assert_output - <<'EOF'
Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored
EOF
}

@test "patching first with no-mod and non-applicable and success succeeds" {
    run -0 updateWithPatch --first --test-only "$REVERTED_PATCH" "$UNAPPLICABLE_PATCH" "$PATCH"
    assert_output - <<'EOF'
Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored
1 out of 1 hunk FAILED
EOF
}

@test "patching first with non-applicable and success and no-mod succeeds" {
    run -0 updateWithPatch --first --test-only "$UNAPPLICABLE_PATCH" "$PATCH" "$REVERTED_PATCH"
    assert_output '1 out of 1 hunk FAILED'
}

@test "patching first with non-applicable and no-mod and success succeeds" {
    run -0 updateWithPatch --first --test-only "$UNAPPLICABLE_PATCH" "$REVERTED_PATCH" "$PATCH"
    assert_output - <<'EOF'
1 out of 1 hunk FAILED
Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored
EOF
}
