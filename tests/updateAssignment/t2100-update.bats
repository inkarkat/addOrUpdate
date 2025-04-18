#!/usr/bin/env bats

load temp

@test "update with nonexisting assignment returns 1" {
    run -1 updateAssignment --lhs new --rhs add "$FILE"
    assert_output - < "$INPUT"
}

@test "update with assignee containing forward slash updates" {
    run -0 updateAssignment --lhs 'sing/e' --rhs 'whe\reever' "$FILE"
    assert_output - <<'EOF'
sing/e=whe\reever
foo=bar
foo=hoo bar baz
# SECTION
fox=hi
EOF
}
