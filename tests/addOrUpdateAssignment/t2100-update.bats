#!/usr/bin/env bats

load temp

@test "update with nonexisting assignment appends at the end" {
    run -0 addOrUpdateAssignment --lhs new --rhs add "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
new=add
EOF
}

@test "update with assignee containing forward slash updates" {
    run -0 addOrUpdateAssignment --lhs 'sing/e' --rhs 'whe\reever' "$FILE"
    assert_output - <<'EOF'
sing/e=whe\reever
foo=bar
foo=hoo bar baz
# SECTION
fox=hi
EOF
}
