#!/usr/bin/env bats

load temp

@test "update with value of multiple lines" {
    run -0 updateAssignment --lhs foo --rhs $'multi\nline' "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=multi
line
foo=hoo bar baz
# SECTION
fox=hi
EOF
}
