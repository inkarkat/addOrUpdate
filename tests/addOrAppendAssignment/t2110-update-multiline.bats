#!/usr/bin/env bats

load temp

@test "update with nonexisting assignment appends multi-line at the end" {
    run -0 addOrAppendAssignment --lhs new --rhs $'multi\nline' "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
new="multi
line"
EOF
}

@test "update with value of multiple lines" {
    run -0 addOrAppendAssignment --lhs foo --rhs $'multi\nline' "$FILE"
    assert_output - <<'EOF'
sing/e="wha\ever"
foo="bar multi
line"
foo="hoo bar baz"
# SECTION
fox="hi there"
EOF
}
