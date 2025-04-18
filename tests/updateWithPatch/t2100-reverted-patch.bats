#!/usr/bin/env bats

load temp

@test "reverse patch fails with 99 and skipping error, and keeps the original intact" {
    run -99 updateWithPatch "$REVERTED_PATCH"
    assert_output - <<'EOF'
Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored
EOF
    diff -y "$EXISTING" "$FILE"
}

@test "reversed patching prints the result and keeps the original intact" {
    run -0 updateWithPatch --reverse "$REVERTED_PATCH"
    assert_output - < "$RESULT"
    diff -y "$EXISTING" "$FILE"
}

@test "in-place reversed patching updates the file" {
    run -0 updateWithPatch --in-place --reverse "$REVERTED_PATCH"
    assert_output ''
    diff -y "$FILE" "$RESULT"
}
