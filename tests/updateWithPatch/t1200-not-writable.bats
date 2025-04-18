#!/usr/bin/env bats

load temp

@test "patching not-writable existing file returns 4" {
    chmod -w -- "$FILE"
    assert_not_file_permission -w "$FILE"
    run -4 updateWithPatch --in-place "$PATCH"
    assert_output - <<'EOF'
File existing.txt is read-only; refusing to patch
1 out of 1 hunk ignored
EOF
}
