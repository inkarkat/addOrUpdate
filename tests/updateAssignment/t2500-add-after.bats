#!/usr/bin/env bats

load temp

@test "update with existing assignment after the passed line keeps contents and returns 99" {
    run -99 updateAssignment --lhs foo --rhs bar --add-after 3 "$FILE"
    assert_output - < "$INPUT"
}
