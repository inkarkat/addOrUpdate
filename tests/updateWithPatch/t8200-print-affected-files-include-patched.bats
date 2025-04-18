#!/usr/bin/env bats

load temp

export MORE="${BATS_TMPDIR}/more.txt"

@test "printing reverse patch that includes already patched prints up-to-date file" {
    run -0 updateWithPatch --print-affected-files --include-already-patched "$REVERTED_PATCH"
    assert_output 'existing.txt'
}

@test "printing reverse patch that includes already patched with forward flag prints up-to-date file" {
    run -0 updateWithPatch --print-affected-files --include-already-patched --forward "$REVERTED_PATCH"
    assert_output 'existing.txt'
}

@test "printing existing and up-to-date files" {
    cp -f "$EXISTING" "$OTHER"
    cp -f "$EXISTING" "$MORE"
    run -0 updateWithPatch --print-affected-files --include-already-patched <(renamePatchTarget "$OTHER" "$PATCH") "$REVERTED_PATCH" <(renamePatchTarget "$MORE" "$PATCH")
    assert_output - <<'EOF'
existing.txt
more.txt
other.txt
EOF
}

@test "printing with reverse flag prints patched file" {
    cp -f "$RESULT" "$FILE"
    run -0 updateWithPatch --print-affected-files --include-already-patched --reverse "$REVERTED_PATCH"
    assert_output 'existing.txt'
}
