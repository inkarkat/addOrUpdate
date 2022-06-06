#!/usr/bin/env bats

load different

@test "update with single quotes appends to existing value" {
    ASSIGNMENT_QUOTE="'" run addOrAppendAssignment --lhs foo --rhs add "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "foo=\"bar\"
foo='bar add'
foo=/initial value/
fox=
foy=\\\\
foz=existing value" ]
}

@test "update with nonexisting single quotes appends at the end" {
    ASSIGNMENT_QUOTE="'" run addOrAppendAssignment --lhs new --rhs add "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$INPUT")
new='add'" ]
}

@test "update with forward slashes appends to existing value" {
    ASSIGNMENT_QUOTE=/ run addOrAppendAssignment --lhs foo --rhs add "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "foo=\"bar\"
foo='bar'
foo=/initial value add/
fox=
foy=\\\\
foz=existing value" ]
}

@test "update with nonexisting forward slashes appends at the end" {
    ASSIGNMENT_QUOTE=/ run addOrAppendAssignment --lhs new --rhs add "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$INPUT")
new=/add/" ]
}

@test "update with backslashes appends to existing value" {
    ASSIGNMENT_QUOTE=\\ run addOrAppendAssignment --lhs foy --rhs add "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "foo=\"bar\"
foo='bar'
foo=/initial value/
fox=
foy=\\add\\
foz=existing value" ]
}

@test "update with nonexisting backslashes appends at the end" {
    ASSIGNMENT_QUOTE=\\ run addOrAppendAssignment --lhs new --rhs add "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$INPUT")
new=\\add\\" ]
}

@test "update with empty quotes appends to existing value" {
    ASSIGNMENT_QUOTE= run addOrAppendAssignment --lhs foz --rhs add "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "foo=\"bar\"
foo='bar'
foo=/initial value/
fox=
foy=\\\\
foz=existing value add" ]
}

@test "update with nonexisting empty quotes appends at the end" {
    ASSIGNMENT_QUOTE= run addOrAppendAssignment --lhs new --rhs add "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$INPUT")
new=add" ]
}
