#!/usr/bin/env bats

load temp

@test "update appends to existing value" {
    run -0 addOrAppendAssignment --lhs foo --rhs added "$FILE"
    assert_output - <<'EOF'
sing/e="wha\ever"
foo="bar added"
foo="hoo bar baz"
# SECTION
fox="hi there"
EOF
}

@test "update inserts to empty quoted value" {
    run -0 addOrAppendAssignment --lhs foy --rhs added "$FILE2"
    assert_output - <<'EOF'
foo="bar"
quux="initial value"
fox=
foy="added"
EOF
}

@test "update inserts to empty unquoted value" {
    run -0 addOrAppendAssignment --lhs fox --rhs added "$FILE2"
    assert_output - <<'EOF'
foo="bar"
quux="initial value"
fox="added"
foy=""
EOF
}
