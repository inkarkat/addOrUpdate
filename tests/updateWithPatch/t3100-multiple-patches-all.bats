#!/usr/bin/env bats

load temp

@test "patching all with two alternatives prints both results and keeps the original intact" {
    run updateWithPatch --all "$PATCH" "$ALTERNATIVE_PATCH"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$RESULT")
$(cat "$ALTERNATIVE_RESULT")" ]
    cmp "$EXISTING" "$FILE"
}

@test "in-place patching all with two alternatives applies the first and fails because of the second" {
    run updateWithPatch --all --in-place "$PATCH" "$ALTERNATIVE_PATCH"
    [ $status -eq 4 ]
    [ "$output" = "1 out of 1 hunk FAILED" ]
    cmp "$FILE" "$RESULT"
}

@test "test-only patching all with two alternatives succeeds" {
    run updateWithPatch --all --test-only "$PATCH" "$ALTERNATIVE_PATCH"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    cmp "$EXISTING" "$FILE"
}

@test "patching all with two serial patches prints both results and keeps the original intact" {
    run updateWithPatch --all "$PATCH" "$SECOND_PATCH"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$RESULT")
prepended first line
first line
second line
third line
second-to-last line
last line
appended last line" ]
    cmp "$EXISTING" "$FILE"
}

@test "in-place patching all with two serial patches applies both" {
    run updateWithPatch --all --in-place "$PATCH" "$SECOND_PATCH"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ "$(cat "$FILE")" = "prepended first line
new first line
first line
augmented second line
third line
last line
appended last line" ]
}

@test "test-only patching all with two serial patches succeeds" {
    run updateWithPatch --all --test-only "$PATCH" "$SECOND_PATCH"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    cmp "$EXISTING" "$FILE"
}

@test "patching all with two swapped serial patches prints both results and keeps the original intact" {
    run updateWithPatch --all "$SECOND_PATCH" "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "prepended first line
first line
second line
third line
second-to-last line
last line
appended last line
$(cat "$RESULT")" ]
    cmp "$EXISTING" "$FILE"
}

@test "in-place patching all with two swapped serial patches applies both" {
    run updateWithPatch --all --in-place "$SECOND_PATCH" "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ "$(cat "$FILE")" = "prepended first line
new first line
first line
augmented second line
third line
last line
appended last line" ]
}

@test "test-only patching all with two swapped serial patches succeeds" {
    run updateWithPatch --all --test-only "$SECOND_PATCH" "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    cmp "$EXISTING" "$FILE"
}

@test "swapped in-place patching all with two alternatives applies the first and fails because of the second" {
    run updateWithPatch --all --in-place "$ALTERNATIVE_PATCH" "$PATCH"
    [ $status -eq 4 ]
    [ "$output" = "1 out of 1 hunk FAILED" ]
    cmp "$FILE" "$ALTERNATIVE_RESULT"
}

@test "patching all with good and non-applicable patch prints the good result, error, and original" {
    run updateWithPatch --all "$PATCH" "$UNAPPLICABLE_PATCH"
    [ $status -eq 4 ]
    [ "$output" = "$(cat "$RESULT")
1 out of 1 hunk FAILED
$(cat "$EXISTING")" ]
    cmp "$EXISTING" "$FILE"
}

@test "in-place patching all with good and non-applicable patch applies the good and fails because of the second" {
    run updateWithPatch --all --in-place "$PATCH" "$UNAPPLICABLE_PATCH"
    [ $status -eq 4 ]
    [ "$output" = "1 out of 1 hunk FAILED" ]
    cmp "$FILE" "$RESULT"
}

@test "test-only patching all with good and non-applicable patch succeeds and prints error" {
    run updateWithPatch --all --test-only "$PATCH" "$UNAPPLICABLE_PATCH"
    [ $status -eq 4 ]
    [ "$output" = "1 out of 1 hunk FAILED" ]
    cmp "$EXISTING" "$FILE"
}

@test "patching all with non-applicable and good patch prints the good result, error, and original" {
    run updateWithPatch --all "$UNAPPLICABLE_PATCH" "$PATCH"
    [ $status -eq 4 ]
    [ "$output" = "1 out of 1 hunk FAILED
$(cat "$EXISTING")
$(cat "$RESULT")" ]
    cmp "$EXISTING" "$FILE"
}

@test "in-place patching all with non-applicable and good patch applies the good and fails because of the first" {
    run updateWithPatch --all --in-place "$UNAPPLICABLE_PATCH" "$PATCH"
    [ $status -eq 4 ]
    [ "$output" = "1 out of 1 hunk FAILED" ]
    cmp "$FILE" "$RESULT"
}

@test "test-only patching all with non-applicable and good patch succeeds and prints error" {
    run updateWithPatch --all --test-only "$UNAPPLICABLE_PATCH" "$PATCH"
    [ $status -eq 4 ]
    [ "$output" = "1 out of 1 hunk FAILED" ]
    cmp "$EXISTING" "$FILE"
}
