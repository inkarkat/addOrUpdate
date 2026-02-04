#!/usr/bin/env bats

load temp

@test "update with nonexisting assignment inserts on the passed line" {
    run -0 addOrUpdateAssignment --lhs new --rhs add --add-before 4 "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
foo=hoo bar baz
new=add
# SECTION
fox=hi
EOF
}

@test "update with nonexisting assignment inserts on the passed ADDRESS" {
    run -0 addOrUpdateAssignment --lhs new --rhs add --add-before '/^#/' "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
foo=hoo bar baz
new=add
# SECTION
fox=hi
EOF
}

@test "update with nonexisting assignment inserts on the first match of ADDRESS only" {
    run -0 addOrUpdateAssignment --lhs new --rhs add --add-before '/^foo=/' "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
new=add
foo=bar
foo=hoo bar baz
# SECTION
fox=hi
EOF
}

@test "update with existing assignment on the passed line keeps contents and returns 99" {
    run -99 addOrUpdateAssignment --lhs foo --rhs bar --add-before 2 "$FILE"
    assert_output - < "$INPUT"
}

@test "update with existing assignment one after the passed line adds the existing one again" {
    run -0 addOrUpdateAssignment --lhs foo --rhs bar --add-before 1 "$FILE"
    assert_output - <<'EOF'
foo=bar
sing/e=wha\ever
foo=bar
foo=hoo bar baz
# SECTION
fox=hi
EOF
}
