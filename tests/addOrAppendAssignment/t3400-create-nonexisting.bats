#!/usr/bin/env bats

load temp

@test "processing standard input with creation of nonexisting works" {
    CONTENTS="# useless"
    output="$(echo "$CONTENTS" | addOrAppendAssignment --create-nonexisting --lhs foo --rhs new)"
    assert_output - <<EOF
$CONTENTS
foo="new"
EOF
}

@test "update with nonexisting first file creates and appends there" {
    run -0 addOrAppendAssignment --create-nonexisting --in-place --lhs foo --rhs new "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    assert_exists "$NONE"
    assert_equal "$(<"$NONE")" 'foo="new"'
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    assert_not_exists "$NONE2"
}

@test "update with all nonexisting files creates and appends to the first one" {
    run -0 addOrAppendAssignment --create-nonexisting --in-place --lhs foo --rhs new "$NONE" "$NONE2"
    assert_output ''
    assert_exists "$NONE"
    assert_equal "$(<"$NONE")" 'foo="new"'
    assert_not_exists "$NONE2"
}

@test "update with nonexisting files and --all creates and appends each" {
    run -0 addOrAppendAssignment --create-nonexisting --all --in-place --lhs foo --rhs new "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    assert_exists "$NONE"
    assert_exists "$NONE2"
    assert_equal "$(<"$NONE")" 'foo="new"'
    assert_equal "$(<"$NONE2")" 'foo="new"'
    diff -y - --label expected "$FILE" <<'EOF'
sing/e="wha\ever"
foo="bar new"
foo="hoo bar baz"
# SECTION
fox="hi there"
EOF
    diff -y - --label expected "$FILE2" <<'EOF'
foo="bar new"
quux="initial value"
fox=
foy=""
EOF
}

@test "update with all nonexisting files and --all creates and appends to each" {
    run -0 addOrAppendAssignment --create-nonexisting --all --in-place --lhs new --rhs add "$NONE" "$NONE2"
    assert_output ''
    assert_exists "$NONE"
    assert_exists "$NONE2"
    assert_equal "$(<"$NONE")" 'new="add"'
    assert_equal "$(<"$NONE2")" 'new="add"'
}
