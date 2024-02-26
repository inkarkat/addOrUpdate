#!/usr/bin/env bats

load temp

@test "patching first with two alternatives succeeds" {
    run updateWithPatch --first --test-only "$PATCH" "$ALTERNATIVE_PATCH"
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "patching first with two no-mods returns 99" {
    run updateWithPatch --first --test-only "$REVERTED_PATCH" "$REVERTED_PATCH"
    [ $status -eq 99 ]
    [ "$output" = "Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored
Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored" ]
}

@test "patching first with two non-applicables returns 4" {
    run updateWithPatch --first --test-only "$UNAPPLICABLE_PATCH" "$UNAPPLICABLE_PATCH"
    [ $status -eq 4 ]
    [ "$output" = "1 out of 1 hunk FAILED
1 out of 1 hunk FAILED" ]
}

@test "patching first with success and no-mod succeeds" {
    run updateWithPatch --first --test-only "$PATCH" "$REVERTED_PATCH"
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "patching first with no-mod and success succeeds" {
    run updateWithPatch --first --test-only "$REVERTED_PATCH" "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored" ]
}

@test "patching first with success and non-applicable succeeds" {
    run updateWithPatch --first --test-only "$PATCH" "$UNAPPLICABLE_PATCH"
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "patching first with non-applicable and success succeeds" {
    run updateWithPatch --first --test-only "$UNAPPLICABLE_PATCH" "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "1 out of 1 hunk FAILED" ]
}

@test "patching first with no-mod and non-applicable returns 99" {
    run updateWithPatch --first --test-only "$REVERTED_PATCH" "$UNAPPLICABLE_PATCH"
    [ $status -eq 99 ]
    [ "$output" = "Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored
1 out of 1 hunk FAILED" ]
}

@test "patching first with non-applicable and no-mod returns 99" {
    run updateWithPatch --first --test-only "$UNAPPLICABLE_PATCH" "$REVERTED_PATCH"
    [ $status -eq 99 ]
    [ "$output" = "1 out of 1 hunk FAILED
Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored" ]
}

@test "patching first with success and no-mod and non-applicable succeeds" {
    run updateWithPatch --first --test-only "$PATCH" "$REVERTED_PATCH" "$UNAPPLICABLE_PATCH"
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "patching first with success and non-applicable and no-mod succeeds" {
    run updateWithPatch --first --test-only "$PATCH" "$UNAPPLICABLE_PATCH" "$REVERTED_PATCH"
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "patching first with no-mod and success and non-applicable succeeds" {
    run updateWithPatch --first --test-only "$REVERTED_PATCH" "$PATCH" "$UNAPPLICABLE_PATCH"
    [ $status -eq 0 ]
    [ "$output" = "Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored" ]
}

@test "patching first with no-mod and non-applicable and success succeeds" {
    run updateWithPatch --first --test-only "$REVERTED_PATCH" "$UNAPPLICABLE_PATCH" "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored
1 out of 1 hunk FAILED" ]
}

@test "patching first with non-applicable and success and no-mod succeeds" {
    run updateWithPatch --first --test-only "$UNAPPLICABLE_PATCH" "$PATCH" "$REVERTED_PATCH"
    [ $status -eq 0 ]
    [ "$output" = "1 out of 1 hunk FAILED" ]
}

@test "patching first with non-applicable and no-mod and success succeeds" {
    run updateWithPatch --first --test-only "$UNAPPLICABLE_PATCH" "$REVERTED_PATCH" "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "1 out of 1 hunk FAILED
Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored" ]
}
