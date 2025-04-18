#!/usr/bin/env bats

load temp

@test "append with one pre line" {
    PRELINE='# new header'
    run -0 addOrUpdateAssignment --pre-line "$PRELINE" --lhs new --rhs add "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$PRELINE
new=add
EOF
}

@test "append with three separate pre lines" {
    PRELINE1='# first header'
    PRELINE2=''
    PRELINE3='# third header'
    run -0 addOrUpdateAssignment --pre-line "$PRELINE1" --pre-line "$PRELINE2" --pre-line "$PRELINE3" --lhs new --rhs add "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$PRELINE1
$PRELINE2
$PRELINE3
new=add
EOF
}

@test "append with one multi-line pre line" {
    PRELINE="# first header

# third header"
    PRELINE1='# first header'
    PRELINE2=''
    PRELINE3='# third header'
    run -0 addOrUpdateAssignment --pre-line "$PRELINE" --lhs new --rhs add "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$PRELINE1
$PRELINE2
$PRELINE3
new=add
EOF
}

@test "empty pre line" {
    run -0 addOrUpdateAssignment --pre-line '' --lhs new --rhs add "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")

new=add
EOF
}

@test "single space pre line" {
    PRELINE=' '
    run -0 addOrUpdateAssignment --pre-line "$PRELINE" --lhs new --rhs add "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$PRELINE
new=add
EOF
}
