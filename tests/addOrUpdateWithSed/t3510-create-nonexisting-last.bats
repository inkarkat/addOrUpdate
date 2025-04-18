#!/usr/bin/env bats

load temp

@test "update with nonexisting first file creates and uses that as last" {
    run -0 addOrUpdateWithSed --create-nonexisting --in-place --last-file $'$a\\\nnew=got added' --last-file '$q' $SED_UPDATE -- "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    assert_exists "$NONE"
    diff -y - --label expected "$NONE" <<'EOF'

new=got added
EOF
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    assert_not_exists "$NONE2"
}

@test "update with all nonexisting files creates and inserts as last in the first one" {
    run -0 addOrUpdateWithSed --create-nonexisting --last-file $'$a\\\nnew=got added' --last-file '$q' --in-place $SED_UPDATE -- "$NONE" "$NONE2"
    assert_output ''
    assert_exists "$NONE"
    diff -y - --label expected "$NONE" <<'EOF'

new=got added
EOF
    assert_not_exists "$NONE2"
}

@test "update with nonexisting files and --all creates and inserts as last in each" {
    run -0 addOrUpdateWithSed --create-nonexisting --all --in-place --last-file $'$a\\\nnew=got added' --last-file '$q' $SED_UPDATE -- "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    assert_exists "$NONE"
    assert_exists "$NONE2"
    diff -y - --label expected "$NONE" <<'EOF'

new=got added
EOF
    diff -y - --label expected "$NONE2" <<'EOF'

new=got added
EOF
    diff -y - --label expected "$FILE" <<'EOF'
updated
foo=bar
foo=hoo bar baz
# SECTION
foo=hi
new=got added
EOF
    diff -y - --label expected "$FILE2" <<'EOF'
updated
quux=initial
foo=moo bar baz
new=got added
EOF
}

@test "update with all nonexisting files and --all creates and inserts as last in each" {
    run -0 addOrUpdateWithSed --create-nonexisting --all --in-place --last-file $'$a\\\nnew=got added' --last-file '$q' $SED_UPDATE -- "$NONE" "$NONE2"
    assert_output ''
    assert_exists "$NONE"
    assert_exists "$NONE2"
    diff -y - --label expected "$NONE" <<'EOF'

new=got added
EOF
    diff -y - --label expected "$NONE2" <<'EOF'

new=got added
EOF
}
