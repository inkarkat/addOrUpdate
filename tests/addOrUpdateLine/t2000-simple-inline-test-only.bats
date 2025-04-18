#!/usr/bin/env bats

load temp

@test "update with nonexisting line appends at the end" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --line "$UPDATE" "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$UPDATE
EOF
}

@test "update with existing line keeps contents and returns 99" {
    run -99 addOrUpdateLine --line "foo=bar" "$FILE"
    assert_output - < "$INPUT"
}

@test "update with nonexisting line containing forward and backslash appends at the end" {
    UPDATE='/new\=\here/'
    run -0 addOrUpdateLine --line "$UPDATE" "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$UPDATE
EOF
}

@test "update with existing line containing forward and backslash keeps contents and returns 99" {
    run -99 addOrUpdateLine --line 'sing/e=wha\ever' "$FILE"
    assert_output - < "$INPUT"
}

@test "in-place update with nonexisting line appends at the end" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --in-place --line "$UPDATE" "$FILE"
    assert_output ''
    diff -y - --label expected "$FILE" <<EOF
$(cat "$INPUT")
$UPDATE
EOF
}

@test "in-place update with existing line keeps contents and returns 99" {
    run -99 addOrUpdateLine --in-place --line "foo=bar" "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}

@test "test-only update with nonexisting line succeeds" {
    UPDATE="foo=new"
    run -0 addOrUpdateLine --test-only --line "$UPDATE" "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}

@test "test-only update with existing line returns 99" {
    run -99 addOrUpdateLine --test-only --line "foo=bar" "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}
