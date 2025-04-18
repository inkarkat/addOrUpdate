#!/usr/bin/env bats

load different

@test "update with single quotes appends to existing value" {
    ASSIGNMENT_QUOTE="'" run -0 addOrAppendAssignment --lhs foo --rhs add "$FILE"
    assert_output - <<'EOF'
foo="bar"
foo='bar add'
foo=/initial/value/
fox=
foy=\\
foz=existing,value
EOF
}

@test "update with nonexisting single quotes appends at the end" {
    ASSIGNMENT_QUOTE="'" run -0 addOrAppendAssignment --lhs new --rhs add "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
new='add'
EOF
}

@test "update with forward slashes appends to existing value" {
    ASSIGNMENT_QUOTE=/ run -0 addOrAppendAssignment --lhs foo --rhs add "$FILE"
    assert_output - <<'EOF'
foo="bar"
foo='bar'
foo=/initial/value add/
fox=
foy=\\
foz=existing,value
EOF
}

@test "update with nonexisting forward slashes appends at the end" {
    ASSIGNMENT_QUOTE=/ run -0 addOrAppendAssignment --lhs new --rhs add "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
new=/add/
EOF
}

@test "update with backslashes appends to existing value" {
    ASSIGNMENT_QUOTE=\\ run -0 addOrAppendAssignment --lhs foy --rhs add "$FILE"
    assert_output - <<'EOF'
foo="bar"
foo='bar'
foo=/initial/value/
fox=
foy=\add\
foz=existing,value
EOF
}

@test "update with nonexisting backslashes appends at the end" {
    ASSIGNMENT_QUOTE=\\ run -0 addOrAppendAssignment --lhs new --rhs add "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
new=\\add\\
EOF
}

@test "update with empty quotes appends to existing value" {
    ASSIGNMENT_QUOTE= run -0 addOrAppendAssignment --lhs foz --rhs add "$FILE"
    assert_output - <<'EOF'
foo="bar"
foo='bar'
foo=/initial/value/
fox=
foy=\\
foz=existing,value add
EOF
}

@test "update with nonexisting empty quotes appends at the end" {
    ASSIGNMENT_QUOTE= run -0 addOrAppendAssignment --lhs new --rhs add "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
new=add
EOF
}
