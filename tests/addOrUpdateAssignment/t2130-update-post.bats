#!/usr/bin/env bats

load temp

@test "update with nonexisting assignment skips post line and appends at the end" {
    POSTLINE='# new footer'
    run -0 addOrUpdateAssignment --post-update "$POSTLINE" --lhs new --rhs add "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
new=add
EOF
}

@test "update with one post line and assignment" {
    POSTLINE='# new footer'
    run -0 addOrUpdateAssignment --post-update "$POSTLINE" --lhs foo --rhs new "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=new
$POSTLINE
foo=hoo bar baz
# SECTION
fox=hi
EOF
}

@test "update with three separate post lines and assignment" {
    POSTLINE1='# first footer'
    POSTLINE2=''
    POSTLINE3='# third footer'
    run -0 addOrUpdateAssignment --post-update "$POSTLINE1" --post-update "$POSTLINE2" --post-update "$POSTLINE3" --lhs foo --rhs new "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=new
$POSTLINE1
$POSTLINE2
$POSTLINE3
foo=hoo bar baz
# SECTION
fox=hi
EOF
}

@test "update with one multi-line post line and assignment" {
    POSTLINE='# first footer

# third footer'
    POSTLINE1='# first footer'
    POSTLINE2=''
    POSTLINE3='# third footer'
    run -0 addOrUpdateAssignment --post-update "$POSTLINE" --lhs foo --rhs new "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=new
$POSTLINE1
$POSTLINE2
$POSTLINE3
foo=hoo bar baz
# SECTION
fox=hi
EOF
}

@test "update with empty post line and assignment" {
    run -0 addOrUpdateAssignment --post-update '' --lhs foo --rhs new "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=new

foo=hoo bar baz
# SECTION
fox=hi
EOF
}

@test "update with single space post line and assignment" {
    POSTLINE=' '
    run -0 addOrUpdateAssignment --post-update "$POSTLINE" --lhs foo --rhs new "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=new
$POSTLINE
foo=hoo bar baz
# SECTION
fox=hi
EOF
}
