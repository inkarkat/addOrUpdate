#!/usr/bin/env bats

load different

@test "update with empty separator appends to existing value" {
    ASSIGNMENT_SEPARATOR= run -0 addOrAppendAssignment --lhs foo --rhs add "$FILE"
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
    ASSIGNMENT_SEPARATOR= run -99 addOrAppendAssignment --lhs foo --rhs a "$FILE"
    diff -y "$INPUT" "$FILE"
}

@test "update with nonexisting empty separator appends at the end" {
    ASSIGNMENT_SEPARATOR= run -0 addOrAppendAssignment --lhs new --rhs add "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
new="add"
EOF
}
