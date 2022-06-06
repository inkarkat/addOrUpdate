#!/usr/bin/env bats

load different

@test "update with single quotes appends to existing value" {
    ASSIGNMENT_QUOTE="'" run addOrAppendAssignment --lhs foo --rhs add "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "foo=\"bar\"
foo='bar add'
foo=/initial value/
fox=
foy=\\\\" ]
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
foy=\\\\" ]
}

@test "update with nonexisting forward slashes appends at the end" {
    ASSIGNMENT_QUOTE=/ run addOrAppendAssignment --lhs new --rhs add "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$INPUT")
new=/add/" ]
}
