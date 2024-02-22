#!/usr/bin/env bats

load different

@test "update with empty separator appends to existing value" {
    ASSIGNMENT_SEPARATOR= run appendAssignment --lhs foo --rhs add "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "foo=\"baradd\"
foo='bar'
foo=/initial/value/
fox=
foy=\\\\
foz=existing,value" ]
}

@test "update with empty separator matches inside existing value" {
    ASSIGNMENT_SEPARATOR= run appendAssignment --lhs foo --rhs a "$FILE"
    [ $status -eq 99 ]
    cmp "$INPUT" "$FILE"
}

@test "update with nonexisting empty separator returns 1" {
    ASSIGNMENT_SEPARATOR= run appendAssignment --lhs new --rhs add "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}
