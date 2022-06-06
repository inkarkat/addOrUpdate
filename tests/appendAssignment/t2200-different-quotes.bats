#!/usr/bin/env bats

load different

@test "update with single quotes appends to existing value" {
    ASSIGNMENT_QUOTE="'" run appendAssignment --lhs foo --rhs add "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "foo=\"bar\"
foo='bar add'
foo=/initial/value/
fox=
foy=\\\\
foz=existing,value" ]
}

@test "update with nonexisting single quotes returns 1" {
    ASSIGNMENT_QUOTE="'" run appendAssignment --lhs new --rhs add "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with forward slashes appends to existing value" {
    ASSIGNMENT_QUOTE=/ run appendAssignment --lhs foo --rhs add "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "foo=\"bar\"
foo='bar'
foo=/initial/value add/
fox=
foy=\\\\
foz=existing,value" ]
}

@test "update with nonexisting forward slashes returns 1" {
    ASSIGNMENT_QUOTE=/ run appendAssignment --lhs new --rhs add "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with backslashes appends to existing value" {
    ASSIGNMENT_QUOTE=\\ run appendAssignment --lhs foy --rhs add "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "foo=\"bar\"
foo='bar'
foo=/initial/value/
fox=
foy=\\add\\
foz=existing,value" ]
}

@test "update with nonexisting backslashes returns 1" {
    ASSIGNMENT_QUOTE=\\ run appendAssignment --lhs new --rhs add "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with empty quotes appends to existing value" {
    ASSIGNMENT_QUOTE= run appendAssignment --lhs foz --rhs add "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "foo=\"bar\"
foo='bar'
foo=/initial/value/
fox=
foy=\\\\
foz=existing,value add" ]
}

@test "update with nonexisting empty quotes returns 1" {
    ASSIGNMENT_QUOTE= run appendAssignment --lhs new --rhs add "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}
