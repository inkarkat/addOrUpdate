#!/usr/bin/env bats

load temp

@test "update with nonmatching pattern skips pre line and appends at the end" {
    PRELINE='# new header'
    run -0 addOrUpdateAssignment --pre-update "$PRELINE" --lhs new --rhs add "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
new=add
EOF
}

@test "update with one pre line and assignment" {
    PRELINE='# new header'
    run -0 addOrUpdateAssignment --pre-update "$PRELINE" --lhs foo --rhs new "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
$PRELINE
foo=new
foo=hoo bar baz
# SECTION
fox=hi
EOF
}

@test "update with three separate pre lines and assignment" {
    PRELINE1='# first header'
    PRELINE2=''
    PRELINE3='# third header'
    run -0 addOrUpdateAssignment --pre-update "$PRELINE1" --pre-update "$PRELINE2" --pre-update "$PRELINE3" --lhs foo --rhs new "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
$PRELINE1
$PRELINE2
$PRELINE3
foo=new
foo=hoo bar baz
# SECTION
fox=hi
EOF
}

@test "update with one multi-line pre line and assignment" {
    PRELINE="# first header

# third header"
    PRELINE1='# first header'
    PRELINE2=''
    PRELINE3='# third header'
    run -0 addOrUpdateAssignment --pre-update "$PRELINE" --lhs foo --rhs new "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
$PRELINE1
$PRELINE2
$PRELINE3
foo=new
foo=hoo bar baz
# SECTION
fox=hi
EOF
}

@test "update with empty pre line and assignment" {
    run -0 addOrUpdateAssignment --pre-update '' --lhs foo --rhs new "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever

foo=new
foo=hoo bar baz
# SECTION
fox=hi
EOF
}

@test "update with single space pre line and assignment" {
    PRELINE=' '
    run -0 addOrUpdateAssignment --pre-update "$PRELINE" --lhs foo --rhs new "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
$PRELINE
foo=new
foo=hoo bar baz
# SECTION
fox=hi
EOF
}
