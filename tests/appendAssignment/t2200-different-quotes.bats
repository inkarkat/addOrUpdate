#!/usr/bin/env bats

load different

@test "update with single quotes appends to existing value" {
    ASSIGNMENT_QUOTE="'" run -0 appendAssignment --lhs foo --rhs add "$FILE"
    assert_output - <<'EOF'
foo="bar"
foo='bar add'
foo=/initial/value/
fox=
foy=\\
foz=existing,value
EOF
}

@test "update with nonexisting single quotes returns 1" {
    ASSIGNMENT_QUOTE="'" run -1 appendAssignment --lhs new --rhs add "$FILE"
    assert_output - < "$INPUT"
}

@test "update with forward slashes appends to existing value" {
    ASSIGNMENT_QUOTE=/ run -0 appendAssignment --lhs foo --rhs add "$FILE"
    assert_output - <<'EOF'
foo="bar"
foo='bar'
foo=/initial/value add/
fox=
foy=\\
foz=existing,value
EOF
}

@test "update with nonexisting forward slashes returns 1" {
    ASSIGNMENT_QUOTE=/ run -1 appendAssignment --lhs new --rhs add "$FILE"
    assert_output - < "$INPUT"
}

@test "update with backslashes appends to existing value" {
    ASSIGNMENT_QUOTE=\\ run -0 appendAssignment --lhs foy --rhs add "$FILE"
    assert_output - <<'EOF'
foo="bar"
foo='bar'
foo=/initial/value/
fox=
foy=\add\
foz=existing,value
EOF
}

@test "update with nonexisting backslashes returns 1" {
    ASSIGNMENT_QUOTE=\\ run -1 appendAssignment --lhs new --rhs add "$FILE"
    assert_output - < "$INPUT"
}

@test "update with empty quotes appends to existing value" {
    ASSIGNMENT_QUOTE='' run -0 appendAssignment --lhs foz --rhs add "$FILE"
    assert_output - <<'EOF'
foo="bar"
foo='bar'
foo=/initial/value/
fox=
foy=\\
foz=existing,value add
EOF
}

@test "update with nonexisting empty quotes returns 1" {
    ASSIGNMENT_QUOTE='' run -1 appendAssignment --lhs new --rhs add "$FILE"
    assert_output - < "$INPUT"
}
