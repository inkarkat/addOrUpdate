#!/usr/bin/env bats

load temp

@test "update in all existing files skips nonexisting files" {
    run -0 addOrUpdateWithSed --all --in-place $SED_UPDATE -- "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    diff -y - --label expected "$FILE" <<'EOF'
updated
foo=bar
foo=hoo bar baz
# SECTION
foo=hi
EOF
    diff -y - --label expected "$FILE2" <<'EOF'
updated
quux=initial
foo=moo bar baz
EOF
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}

@test "all nonexisting all files returns 4" {
    run -4 addOrUpdateWithSed --all --in-place $SED_UPDATE -- "$NONE" "$NONE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}
