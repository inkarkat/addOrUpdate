#!/usr/bin/env bats

load temp

@test "patching first with two alternatives prints the first result and keeps the original intact" {
    run updateWithPatch --first "$PATCH" "$ALTERNATIVE_PATCH"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$RESULT")" ]
    cmp "$EXISTING" "$FILE"
}

@test "in-place patching first with two alternatives applies the first and does not try the second" {
    run updateWithPatch --first --in-place "$PATCH" "$ALTERNATIVE_PATCH"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    cmp "$FILE" "$RESULT"
}

@test "test-only patching first with two alternatives succeeds" {
    run updateWithPatch --first --test-only "$PATCH" "$ALTERNATIVE_PATCH"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    cmp "$EXISTING" "$FILE"
}

@test "patching first with two serial patches prints the first result and keeps the original intact" {
    run updateWithPatch --first "$PATCH" "$SECOND_PATCH"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$RESULT")" ]
    cmp "$EXISTING" "$FILE"
}

@test "in-place patching first with two serial patches applies the first" {
    run updateWithPatch --first --in-place "$PATCH" "$SECOND_PATCH"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    cmp "$FILE" "$RESULT"
}

@test "test-only patching first with two serial patches succeeds" {
    run updateWithPatch --first --test-only "$PATCH" "$SECOND_PATCH"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    cmp "$EXISTING" "$FILE"
}

@test "patching first with two swapped serial patches prints the first result and keeps the original intact" {
    run updateWithPatch --first "$SECOND_PATCH" "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "prepended first line
first line
second line
third line
second-to-last line
last line
appended last line" ]
    cmp "$EXISTING" "$FILE"
}

@test "in-place patching first with two swapped serial patches applies the first" {
    run updateWithPatch --first --in-place "$SECOND_PATCH" "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ "$(cat "$FILE")" = "prepended first line
$(cat "$EXISTING")
appended last line" ]
}

@test "test-only patching first with two swapped serial patches succeeds" {
    run updateWithPatch --first --test-only "$SECOND_PATCH" "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    cmp "$EXISTING" "$FILE"
}

@test "swapped in-place patching first with two alternatives applies the first and does not try the second" {
    run updateWithPatch --first --in-place "$ALTERNATIVE_PATCH" "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    cmp "$FILE" "$ALTERNATIVE_RESULT"
}

@test "patching first with good and non-applicable patch prints the good result" {
    run updateWithPatch --first "$PATCH" "$UNAPPLICABLE_PATCH"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$RESULT")" ]
    cmp "$EXISTING" "$FILE"
}

@test "in-place patching first with good and non-applicable patch applies the good and does not try the second" {
    run updateWithPatch --first --in-place "$PATCH" "$UNAPPLICABLE_PATCH"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    cmp "$FILE" "$RESULT"
}

@test "test-only patching first with good and non-applicable patch succeeds" {
    run updateWithPatch --first --test-only "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    cmp "$EXISTING" "$FILE"
}

@test "patching first with non-applicable and good patch prints the good result, error, and original" {
    run updateWithPatch --first "$UNAPPLICABLE_PATCH" "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "1 out of 1 hunk FAILED
$(cat "$EXISTING")
$(cat "$RESULT")" ]
    cmp "$EXISTING" "$FILE"
}

@test "in-place patching first with non-applicable and good patch applies the good and fails the first" {
    run updateWithPatch --first --in-place "$UNAPPLICABLE_PATCH" "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "1 out of 1 hunk FAILED" ]
    cmp "$FILE" "$RESULT"
}

@test "test-only patching first with non-applicable and good patch succeeds and prints error" {
    run updateWithPatch --first --test-only "$UNAPPLICABLE_PATCH" "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "1 out of 1 hunk FAILED" ]
    cmp "$EXISTING" "$FILE"
}
