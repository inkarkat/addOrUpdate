#!/usr/bin/env bats

load different

@test "update with empty separator appends to existing value" {
    ASSIGNMENT_SEPARATOR= run addOrAppendAssignment --lhs foo --rhs add "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "foo=\"baradd\"
foo='bar'
foo=/initial/value/
fox=
foy=\\\\
foz=existing,value" ]
}

@test "update with empty separator matches inside existing value" {
    ASSIGNMENT_SEPARATOR= run addOrAppendAssignment --lhs foo --rhs a "$FILE"
    [ $status -eq 1 ]
    cmp "$INPUT" "$FILE"
}

@test "update with nonexisting empty separator appends at the end" {
    ASSIGNMENT_SEPARATOR= run addOrAppendAssignment --lhs new --rhs add "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$INPUT")
new=\"add\"" ]
}
