#!/usr/bin/env bats

load temp

@test "update with updated assignment on the passed line updates that line" {
    run -0 updateAssignment --lhs foo --rhs boo --add-before 2 "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=boo
foo=hoo bar baz
# SECTION
fox=hi
EOF
}

@test "update with existing assignment one after the passed line keeps contents and returns 1" {
    run -1 updateAssignment --lhs foo --rhs bar --add-before 1 "$FILE"
    assert_output - < "$INPUT"
}
