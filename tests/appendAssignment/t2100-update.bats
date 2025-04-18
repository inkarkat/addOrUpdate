#!/usr/bin/env bats

load temp

@test "update with nonexisting assignment returns 1" {
    run -1 appendAssignment --lhs new --rhs add "$FILE"
    assert_output - < "$INPUT"
}

@test "update with assignee containing forward slash updates" {
    run -0 appendAssignment --lhs 'sing/e' --rhs 'whe\reever' "$FILE"
    assert_output - <<'EOF'
sing/e="wha\ever whe\reever"
foo="bar"
foo="hoo bar baz"
# SECTION
fox="hi there"
EOF
}
