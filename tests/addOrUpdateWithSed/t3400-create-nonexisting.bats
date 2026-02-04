#!/usr/bin/env bats

load temp

@test "processing standard input with creation of nonexisting works" {
    CONTENTS='# useless
stuff'
    run -0 addOrUpdateWithSed --create-nonexisting $SED_UPDATE <<<"$CONTENTS"
    assert_output - <<'EOF'
updated
stuff
EOF
}

@test "update with nonexisting first file creates and inserts there" {
    run -0 addOrUpdateWithSed --create-nonexisting --in-place $SED_UPDATE -- "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    assert_exists "$NONE"
    assert_equal "$(<"$NONE")" "updated"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    assert_not_exists "$NONE2"
}

@test "update with all nonexisting files creates and inserts in the first one" {
    run -0 addOrUpdateWithSed --create-nonexisting --in-place $SED_UPDATE -- "$NONE" "$NONE2"
    assert_output ''
    assert_exists "$NONE"
    assert_equal "$(<"$NONE")" "updated"
    assert_not_exists "$NONE2"
}

@test "update with nonexisting files and --all creates and inserts in each" {
    run -0 addOrUpdateWithSed --create-nonexisting --all --in-place $SED_UPDATE -- "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    assert_exists "$NONE"
    assert_exists "$NONE2"
    assert_equal "$(<"$NONE")" "updated"
    assert_equal "$(<"$NONE2")" "updated"
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
}

@test "update with all nonexisting files and --all creates and inserts in each" {
    run -0 addOrUpdateWithSed --create-nonexisting --all --in-place $SED_UPDATE -- "$NONE" "$NONE2"
    assert_output ''
    assert_exists "$NONE"
    assert_exists "$NONE2"
    assert_equal "$(<"$NONE")" "updated"
    assert_equal "$(<"$NONE2")" "updated"
}
