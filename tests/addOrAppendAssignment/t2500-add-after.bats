#!/usr/bin/env bats

load temp

@test "update with nonexisting assignment appends after the passed line" {
    run -0 addOrAppendAssignment --lhs new --rhs add --add-after 3 "$FILE"
    assert_output - <<'EOF'
sing/e="wha\ever"
foo="bar"
foo="hoo bar baz"
new="add"
# SECTION
fox="hi there"
EOF
}

@test "update with nonexisting assignment appends after the passed ADDRESS" {
    run -0 addOrAppendAssignment --lhs new --rhs add --add-after '/^#/' "$FILE"
    assert_output - <<'EOF'
sing/e="wha\ever"
foo="bar"
foo="hoo bar baz"
# SECTION
new="add"
fox="hi there"
EOF
}

@test "update with nonexisting assignment appends after the first match of ADDRESS only" {
    run -0 addOrAppendAssignment --lhs new --rhs add --add-after '/^foo=/' "$FILE"
    assert_output - <<'EOF'
sing/e="wha\ever"
foo="bar"
new="add"
foo="hoo bar baz"
# SECTION
fox="hi there"
EOF
}

@test "update with existing assignment after the passed line keeps contents and returns 99" {
    run -99 addOrAppendAssignment --lhs foo --rhs bar --add-after 3 "$FILE"
    assert_output - < "$INPUT"
}
