#!/usr/bin/env bats

load temp

@test "update with nonmatching accepted pattern appends at the end" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --line "$UPDATE" --accept-match "foosball=never" "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$UPDATE
EOF
}

@test "update with literal-like pattern keeps contents and returns 99" {
    run -99 addOrUpdateLine --line "foo=new" --accept-match "foo=h" "$FILE"
    assert_output - < "$INPUT"
}

@test "update with anchored pattern keeps contents and returns 99" {
    run -99 addOrUpdateLine --line "foo=new" --accept-match "^fo\+=[ghi].*$" "$FILE"
    assert_output - < "$INPUT"
}

@test "update with pattern containing forward and backslash keeps contents and returns 99" {
    run -99 addOrUpdateLine --line 'foo=/e\' --accept-match '^.*/.=.*\\.*' "$FILE"
    assert_output - < "$INPUT"
}
