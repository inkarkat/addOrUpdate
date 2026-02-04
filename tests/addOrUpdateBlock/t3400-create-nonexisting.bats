#!/usr/bin/env bats

load temp

@test "processing standard input with creation of nonexisting works" {
    run -0 addOrUpdateBlock --create-nonexisting --marker test --block-text "$TEXT" <<<"$CONTENTS"
    assert_output - <<EOF
$CONTENTS
$BLOCK
EOF
}

@test "update with nonexisting first file creates and appends there" {
    run -0 addOrUpdateBlock --create-nonexisting --in-place --marker test --block-text "$TEXT" "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    assert_exists "$NONE"
    diff -y - --label expected "$NONE" <<<"$BLOCK"
    diff -y "$FILE" "$FRESH"
    diff -y "$FILE2" "$EXISTING"
    assert_not_exists "$NONE2"
}

@test "update with all nonexisting files creates and appends to the first one" {
    run -0 addOrUpdateBlock --create-nonexisting --in-place --marker test --block-text "$TEXT" "$NONE" "$NONE2"
    assert_output ''
    assert_exists "$NONE"
    diff -y - --label expected "$NONE" <<<"$BLOCK"
    assert_not_exists "$NONE2"
}

@test "update nonexisting file with pre line" {
    PRELINE="# new header"
    run -0 addOrUpdateBlock --create-nonexisting --in-place --pre-line "$PRELINE" --marker test --block-text "$TEXT" "$NONE"
    assert_output ''
    assert_exists "$NONE"
    diff -y - --label expected "$NONE" <<EOF
$PRELINE
$BLOCK
EOF
}

@test "update nonexisting file with post line" {
    POSTLINE="# new footer"
    run -0 addOrUpdateBlock --create-nonexisting --in-place --post-line "$POSTLINE" --marker test --block-text "$TEXT" "$NONE"
    assert_output ''
    assert_exists "$NONE"
    diff -y - --label expected "$NONE" <<EOF
$BLOCK
$POSTLINE
EOF
}

@test "update nonexisting file with pre and post lines" {
    PRELINE1="# new header"
    PRELINE2="more

stuff"
    UPDATE="foo=new"
    POSTLINE1="more

stuff"
    POSTLINE2="# new footer"
    run -0 addOrUpdateBlock --create-nonexisting --in-place --pre-line "$PRELINE1" --post-line "$POSTLINE1" --pre-line "$PRELINE2" --post-line "$POSTLINE2" --marker test --block-text "$TEXT" "$NONE"
    assert_output ''
    assert_exists "$NONE"
    diff -y - --label expected "$NONE" <<EOF
$PRELINE1
$PRELINE2
$BLOCK
$POSTLINE1
$POSTLINE2
EOF
}

@test "update with nonexisting files and --all creates and appends each" {
    run -0 addOrUpdateBlock --create-nonexisting --all --in-place --marker test --block-text "$TEXT" "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    assert_exists "$NONE"
    assert_exists "$NONE2"
    diff -y - --label expected "$NONE" <<<"$BLOCK"
    diff -y - --label expected "$FILE" <<EOF
$(cat "$FRESH")
$BLOCK
EOF
    diff -y - --label expected "$NONE2" <<<"$BLOCK"
    diff -y - --label expected "$FILE2" <<EOF
first line
second line
third line
# BEGIN test
$TEXT
# END test
# BEGIN subsequent
Single line
# END subsequent

middle line

# BEGIN test
Testing again
Somehoe
# END test

# BEGIN final and empty
# END final and empty
last line
EOF
}

@test "update with all nonexisting files and --all creates and appends to each" {
    run -0 addOrUpdateBlock --create-nonexisting --all --in-place --marker test --block-text "$TEXT" "$NONE" "$NONE2"
    assert_output ''
    assert_exists "$NONE"
    assert_exists "$NONE2"
    diff -y - --label expected "$NONE" <<<"$BLOCK"
    diff -y - --label expected "$NONE2" <<<"$BLOCK"
}
