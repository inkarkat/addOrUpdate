#!/usr/bin/env bats

load temp

@test "test-only reverse patch fails with 99 and skipping error, and keeps the original intact" {
    run -99 updateWithPatch --test-only "$REVERTED_PATCH"
    assert_output - <<'EOF'
Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored
EOF
    diff -y "$EXISTING" "$FILE"
}

@test "test-only non-applicable patch fails with 4 and skipping error, and keeps the original intact" {
    run -4 updateWithPatch --test-only "$UNAPPLICABLE_PATCH"
    assert_output '1 out of 1 hunk FAILED'
    diff -y "$EXISTING" "$FILE"
}

@test "test-only patching does not print a result and keeps the original intact" {
    run -0 updateWithPatch --test-only "$PATCH"
    assert_output ''
    diff -y "$EXISTING" "$FILE"
}
