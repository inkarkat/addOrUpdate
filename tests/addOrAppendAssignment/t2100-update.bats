#!/usr/bin/env bats

load temp

@test "update with nonexisting assignment appends at the end" {
    run -0 addOrAppendAssignment --lhs new --rhs add "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
new="add"
EOF
}

@test "update with assignee containing forward slash updates" {
    run -0 addOrAppendAssignment --lhs 'sing/e' --rhs 'whe\reever' "$FILE"
    assert_output - <<'EOF'
sing/e="wha\ever whe\reever"
foo="bar"
foo="hoo bar baz"
# SECTION
fox="hi there"
EOF
}
