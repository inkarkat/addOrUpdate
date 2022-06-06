#!/usr/bin/env bats

load different

@test "update with comma separator appends to existing single value" {
    ASSIGNMENT_SEPARATOR=, run appendAssignment --lhs foo --rhs add "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "foo=\"bar,add\"
foo='bar'
foo=/initial/value/
fox=
foy=\\\\
foz=existing,value" ]
}

@test "update with comma separator appends to existing values" {
    ASSIGNMENT_QUOTE= ASSIGNMENT_SEPARATOR=, run appendAssignment --lhs foz --rhs add "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "foo=\"bar\"
foo='bar'
foo=/initial/value/
fox=
foy=\\\\
foz=existing,value,add" ]
}

@test "update with forward slash quotes and same separator appends to existing values" {
    ASSIGNMENT_QUOTE=/ ASSIGNMENT_SEPARATOR=/ run appendAssignment --lhs foo --rhs add "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "foo=\"bar\"
foo='bar'
foo=/initial/value/add/
fox=
foy=\\\\
foz=existing,value" ]
}

@test "update with backslash separator appends to existing single value" {
    ASSIGNMENT_SEPARATOR=\\ run appendAssignment --lhs foo --rhs add "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "foo=\"bar\\add\"
foo='bar'
foo=/initial/value/
fox=
foy=\\\\
foz=existing,value" ]
}

@test "update with backslash quotes and same separator appends thrice to existing empty value" {
    ASSIGNMENT_QUOTE=\\ ASSIGNMENT_SEPARATOR=\\ appendAssignment --in-place --lhs foy --rhs one "$FILE"
    ASSIGNMENT_QUOTE=\\ ASSIGNMENT_SEPARATOR=\\ appendAssignment --in-place --lhs foy --rhs 'and two' "$FILE"
    ASSIGNMENT_QUOTE=\\ ASSIGNMENT_SEPARATOR=\\ appendAssignment --in-place --lhs foy --rhs three "$FILE"
    [ "$(cat "$FILE")" = "foo=\"bar\"
foo='bar'
foo=/initial/value/
fox=
foy=\\one\\and two\\three\\
foz=existing,value" ]
}
