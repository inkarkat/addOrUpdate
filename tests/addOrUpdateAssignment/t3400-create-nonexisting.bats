#!/usr/bin/env bats

load temp

@test "processing standard input with creation of nonexisting works" {
    CONTENTS='# useless'
    output="$(echo "$CONTENTS" | addOrUpdateAssignment --create-nonexisting --lhs foo --rhs new)"
    assert_output - <<EOF
$CONTENTS
foo=new
EOF
}

@test "update with nonexisting first file creates and appends there" {
    run -0 addOrUpdateAssignment --create-nonexisting --in-place --lhs foo --rhs new "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    assert_exists "$NONE"
    assert_equal "$(<"$NONE")" "foo=new"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    assert_not_exists "$NONE2"
}

@test "update with all nonexisting files creates and appends to the first one" {
    run -0 addOrUpdateAssignment --create-nonexisting --in-place --lhs foo --rhs new "$NONE" "$NONE2"
    assert_output ''
    assert_exists "$NONE"
    assert_equal "$(<"$NONE")" "foo=new"
    assert_not_exists "$NONE2"
}

@test "update nonexisting file with pre line" {
    PRELINE='# new header'
    run -0 addOrUpdateAssignment --create-nonexisting --in-place --pre-line "$PRELINE" --lhs new --rhs add "$NONE"
    diff -y - --label expected "$NONE" <<EOF
$PRELINE
new=add
EOF
}

@test "update nonexisting file with post line" {
    POSTLINE='# new footer'
    run -0 addOrUpdateAssignment --create-nonexisting --in-place --post-line "$POSTLINE" --lhs new --rhs add "$NONE"
    diff -y - --label expected "$NONE" <<EOF
new=add
$POSTLINE
EOF
}

@test "update nonexisting file with pre and post lines" {
    PRELINE1='# new header'
    PRELINE2='more

stuff'
    POSTLINE1='more

stuff'
    POSTLINE2='# new footer'
    run -0 addOrUpdateAssignment --create-nonexisting --in-place --pre-line "$PRELINE1" --post-line "$POSTLINE1" --pre-line "$PRELINE2" --post-line "$POSTLINE2" --lhs foo --rhs new "$NONE"
    assert_output ''
    assert_exists "$NONE"
    diff -y - --label expected "$NONE" <<EOF
$PRELINE1
$PRELINE2
foo=new
$POSTLINE1
$POSTLINE2
EOF
}

@test "update with nonexisting files and --all creates and appends each" {
    run -0 addOrUpdateAssignment --create-nonexisting --all --in-place --lhs foo --rhs new "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    assert_exists "$NONE"
    assert_exists "$NONE2"
    assert_equal "$(<"$NONE")" "foo=new"
    assert_equal "$(<"$NONE2")" "foo=new"
    diff -y - --label expected "$FILE" <<'EOF'
sing/e=wha\ever
foo=new
foo=hoo bar baz
# SECTION
fox=hi
EOF
    diff -y - --label expected "$FILE2" <<'EOF'
foo=new
quux=initial
foo=moo bar baz
EOF
}

@test "update with all nonexisting files and --all creates and appends to each" {
    run -0 addOrUpdateAssignment --create-nonexisting --all --in-place --lhs new --rhs add "$NONE" "$NONE2"
    assert_output ''
    assert_exists "$NONE"
    assert_exists "$NONE2"
    assert_equal "$(<"$NONE")" "new=add"
    assert_equal "$(<"$NONE2")" "new=add"
}
