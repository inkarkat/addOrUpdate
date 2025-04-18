#!/usr/bin/env bats

load temp

@test "update with nonmatching accepted pattern appends at the end" {
    run -0 addOrUpdateAssignment --lhs new --rhs add --accept-match "foosball=never" "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
new=add
EOF
}

@test "update with literal-like pattern keeps contents and returns 99" {
    run -99 addOrUpdateAssignment --lhs foo --rhs new --accept-match "foo=b" "$FILE"
    assert_output - < "$INPUT"
}

@test "update with anchored pattern keeps contents and returns 99" {
    run -99 addOrUpdateAssignment --lhs foo --rhs new --accept-match "^fo\+=[abc].*$" "$FILE"
    assert_output - < "$INPUT"
}

@test "update with pattern containing forward and backslash keeps contents and returns 99" {
    run -99 addOrUpdateAssignment --lhs foo --rhs '/e\' --accept-match "^.*/.=.*\\.*" "$FILE"
    assert_output - < "$INPUT"
}
