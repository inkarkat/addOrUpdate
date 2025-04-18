#!/usr/bin/env bats

load different

@test "update with empty separator appends to existing value" {
    ASSIGNMENT_SEPARATOR= run -0 appendAssignment --lhs foo --rhs add "$FILE"
    assert_output - <<'EOF'
foo="baradd"
foo='bar'
foo=/initial/value/
fox=
foy=\\
foz=existing,value
EOF
}

@test "update with empty separator matches inside existing value" {
    ASSIGNMENT_SEPARATOR= run -99 appendAssignment --lhs foo --rhs a "$FILE"
    diff -y "$INPUT" "$FILE"
}

@test "update with nonexisting empty separator returns 1" {
    ASSIGNMENT_SEPARATOR= run -1 appendAssignment --lhs new --rhs add "$FILE"
    assert_output - < "$INPUT"
}
