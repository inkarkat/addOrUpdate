#!/usr/bin/env bats

load temp
load subdir

@test "printing affected existing file keeps the original intact" {
    run -0 updateWithPatch --print-affected-files "$PATCH"
    assert_output 'existing.txt'
    diff -y "$EXISTING" "$FILE"
}

@test "printing affected other file" {
    cp -f "$EXISTING" "$OTHER"
    run -0 updateWithPatch --print-affected-files <(renamePatchTarget "$OTHER" "$PATCH")
    assert_output 'other.txt'
}

@test "printing affected existing and other files" {
    cp -f "$EXISTING" "$OTHER"
    run -0 updateWithPatch --print-affected-files "$PATCH" <(renamePatchTarget "$OTHER" "$PATCH")
    assert_output - <<'EOF'
existing.txt
other.txt
EOF
}

@test "printing affected existing, other, and subdir files" {
    cp -f "$EXISTING" "$OTHER"
    cp -f "$EXISTING" "$SUBDIR"
    run -0 updateWithPatch -p0 --print-affected-files "$PATCH" <(renamePatchTarget "$OTHER" "$PATCH") <(subdirPatchTarget "$PATCH")
    assert_output - <<'EOF'
existing.txt
other.txt
subdir/existing.txt
EOF
}

@test "printing affected duplicate existing and other files only lists unique files" {
    cp -f "$EXISTING" "$OTHER"
    run -0 updateWithPatch --print-affected-files <(renamePatchTarget "$OTHER" "$PATCH") "$PATCH" <(renamePatchTarget "$OTHER" "$PATCH")
    assert_output - <<'EOF'
existing.txt
other.txt
EOF
}

@test "printing reverse patch fails with 1 and does not print files" {
    run -1 updateWithPatch --print-affected-files "$REVERTED_PATCH"
    assert_output ''
}

@test "printing non-applicable patch fails with 1 and does not print files" {
    run -1 updateWithPatch --print-affected-files "$UNAPPLICABLE_PATCH"
    assert_output ''
}
