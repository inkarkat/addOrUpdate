#!/usr/bin/env bats

load fixture

setup() {
    input="$(cat <<'EOF'
foo : "bar"
quux: "initial"
foo: "moo bar baz"
EOF
    )"
}

@test "update colon-space-separated assignments with nonexisting assignment appends at the end" {
    ASSIGNMENT_OPERATOR=': ' run -0 addOrAppendAssignment --lhs new --rhs add <<<"$input"
    assert_output - <<EOF
$input
new: "add"
EOF
}

@test "update colon-space-separated assignments updates existing one" {
    ASSIGNMENT_OPERATOR=': ' run -0 addOrAppendAssignment --lhs 'quux' --rhs 'changed' <<<"$input"
    assert_output - <<'EOF'
foo : "bar"
quux: "initial changed"
foo: "moo bar baz"
EOF
}

@test "update colon-space-separated assignments updates existing one and ignores other whitespace-colon-separated one" {
    ASSIGNMENT_OPERATOR=': ' run -0 addOrAppendAssignment --lhs 'foo' --rhs 'changed' <<<"$input"
    assert_output - <<'EOF'
foo : "bar"
quux: "initial"
foo: "moo bar baz changed"
EOF
}

@test "update colon-whitespace-pattern-separated assignments with nonexisting assignment appends at the end" {
    ASSIGNMENT_OPERATOR=' : ' ASSIGNMENT_OPERATOR_PATTERN='[[:space:]]\+:[[:space:]]\+' run -0 addOrAppendAssignment --lhs new --rhs add <<<"$input"
    assert_output - <<EOF
$input
new : "add"
EOF
}

@test "update colon-whitespace-pattern-separated assignments updates existing one" {
    ASSIGNMENT_OPERATOR=' : ' ASSIGNMENT_OPERATOR_PATTERN='[[:space:]]\+:[[:space:]]\+' run -0 addOrAppendAssignment --lhs 'foo' --rhs 'changed' <<<"$input"
    assert_output - <<'EOF'
foo : "bar changed"
quux: "initial"
foo: "moo bar baz"
EOF
}
