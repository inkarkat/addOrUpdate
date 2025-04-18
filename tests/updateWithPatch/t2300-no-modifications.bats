#!/usr/bin/env bats

load temp

@test "patching a patched file fails with 99 and skipping error, and keeps the original intact" {
    cp -f "$RESULT" "$FILE"
    run -99 updateWithPatch "$PATCH"
    assert_output - <<'EOF'
Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored
EOF
    diff -y "$RESULT" "$FILE"
}
