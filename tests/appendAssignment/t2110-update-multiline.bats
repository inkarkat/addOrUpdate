#!/usr/bin/env bats

load temp

@test "update with nonexisting assignment returns 1" {
    run -1 appendAssignment --lhs new --rhs $'multi\nline' "$FILE"
    assert_output - < "$INPUT"
}

@test "update with value of multiple lines" {
    run -0 appendAssignment --lhs foo --rhs $'multi\nline' "$FILE"
    assert_output - <<'EOF'
sing/e="wha\ever"
foo="bar multi
line"
foo="hoo bar baz"
# SECTION
fox="hi there"
EOF
}
