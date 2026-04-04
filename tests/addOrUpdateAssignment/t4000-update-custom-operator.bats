#!/usr/bin/env bats

load fixture

setup() {
    input="$(cat <<'EOF'
foo : bar
quux: initial
foo: moo bar baz
EOF
    )"
}

@test "update colon-space-separated assignments with nonexisting assignment appends at the end" {
    ASSIGNMENT_OPERATOR=': ' run -0 addOrUpdateAssignment --lhs new --rhs add <<<"$input"
    assert_output - <<EOF
$input
new: add
EOF
}

@test "update colon-space-separated assignments updates existing one" {
    ASSIGNMENT_OPERATOR=': ' run -0 addOrUpdateAssignment --lhs 'quux' --rhs 'changed' <<<"$input"
    assert_output - <<'EOF'
foo : bar
quux: changed
foo: moo bar baz
EOF
}

@test "update colon-space-separated assignments updates existing one and ignores other whitespace-colon-separated one" {
    ASSIGNMENT_OPERATOR=': ' run -0 addOrUpdateAssignment --lhs 'foo' --rhs 'changed' <<<"$input"
    assert_output - <<'EOF'
foo : bar
quux: initial
foo: changed
EOF
}

@test "update colon-whitespace-pattern-separated assignments with nonexisting assignment appends at the end" {
    ASSIGNMENT_OPERATOR=' : ' ASSIGNMENT_OPERATOR_PATTERN='[[:space:]]\+:' run -0 addOrUpdateAssignment --lhs new --rhs add <<<"$input"
    assert_output - <<EOF
$input
new : add
EOF
}

@test "update colon-whitespace-pattern-separated assignments updates existing one" {
    ASSIGNMENT_OPERATOR=' : ' ASSIGNMENT_OPERATOR_PATTERN='[[:space:]]\+:' run -0 addOrUpdateAssignment --lhs 'foo' --rhs 'changed' <<<"$input"
    assert_output - <<'EOF'
foo : changed
quux: initial
foo: moo bar baz
EOF
}
