#!/usr/bin/env bats

load temp

@test "processing standard input with creation of nonexisting works" {
    CONTENTS='# useless'
    UPDATE='foo=new'
    output="$(echo "$CONTENTS" | addOrUpdateLine --create-nonexisting --line "$UPDATE")"
    assert_output - <<EOF
$CONTENTS
$UPDATE
EOF
}

@test "update with nonexisting first file creates and appends there" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --create-nonexisting --in-place --line "$UPDATE" --update-match "foo=bar" "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    assert_exists "$NONE"
    assert_equal "$(<"$NONE")" "foo=new"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    assert_not_exists "$NONE2"
}

@test "update with all nonexisting files creates and appends to the first one" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --create-nonexisting --in-place --line "$UPDATE" --update-match "foo=bar" "$NONE" "$NONE2"
    assert_output ''
    assert_exists "$NONE"
    assert_equal "$(<"$NONE")" "foo=new"
    assert_not_exists "$NONE2"
}

@test "update nonexisting file with pre line" {
    PRELINE='# new header'
    UPDATE='foo=new'
    run -0 addOrUpdateLine --create-nonexisting --in-place --pre-line "$PRELINE" --line "$UPDATE" "$NONE"
    diff -y - --label expected "$NONE" <<EOF
$PRELINE
$UPDATE
EOF
}

@test "update nonexisting file with post line" {
    POSTLINE='# new footer'
    UPDATE='foo=new'
    run -0 addOrUpdateLine --create-nonexisting --in-place --post-line "$POSTLINE" --line "$UPDATE" "$NONE"
    diff -y - --label expected "$NONE" <<EOF
$UPDATE
$POSTLINE
EOF
}

@test "update nonexisting file with pre and post lines" {
    PRELINE1='# new header'
    PRELINE2='more

stuff'
    UPDATE='foo=new'
    POSTLINE1='more

stuff'
    POSTLINE2='# new footer'
    run -0 addOrUpdateLine --create-nonexisting --in-place --pre-line "$PRELINE1" --post-line "$POSTLINE1" --pre-line "$PRELINE2" --post-line "$POSTLINE2" --line "$UPDATE" "$NONE"
    assert_output ''
    assert_exists "$NONE"
    diff -y - --label expected "$NONE" <<EOF
$PRELINE1
$PRELINE2
$UPDATE
$POSTLINE1
$POSTLINE2
EOF
}

@test "update with nonexisting files and --all creates and appends each" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --create-nonexisting --all --in-place --line "$UPDATE" --update-match "foo=bar" "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    assert_exists "$NONE"
    assert_exists "$NONE2"
    assert_equal "$(<"$NONE")" "foo=new"
    assert_equal "$(<"$NONE2")" "foo=new"
    diff -y - --label expected "$FILE" <<EOF
sing/e=wha\\ever
$UPDATE
foo=hoo bar baz
# SECTION
foo=hi
EOF
    diff -y - --label expected "$FILE2" <<EOF
$UPDATE
quux=initial
foo=moo bar baz
EOF
}

@test "update with all nonexisting files and --all creates and appends to each" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --create-nonexisting --all --in-place --line "$UPDATE" --update-match "foo=bar" "$NONE" "$NONE2"
    assert_output ''
    assert_exists "$NONE"
    assert_exists "$NONE2"
    assert_equal "$(<"$NONE")" "foo=new"
    assert_equal "$(<"$NONE2")" "foo=new"
}
