#!/usr/bin/env bats

load temp

@test "update with nonexisting assignment appends multi-line at the end" {
    UPDATE=$'new=multi\nline'
    run -0 addOrUpdateAssignment --lhs new --rhs $'multi\nline' "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$UPDATE
EOF
}

@test "update with value of multiple lines" {
    run -0 addOrUpdateAssignment --lhs foo --rhs $'multi\nline' "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=multi
line
foo=hoo bar baz
# SECTION
fox=hi
EOF
}
