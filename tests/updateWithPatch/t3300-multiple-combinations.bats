#!/usr/bin/env bats

load temp

@test "patching with two alternatives succeeds" {
    run updateWithPatch --test-only "$PATCH" "$ALTERNATIVE_PATCH"
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "patching with two no-mods returns 1" {
    run updateWithPatch --test-only "$REVERTED_PATCH" "$REVERTED_PATCH"
    [ $status -eq 1 ]
    [ "$output" = "Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored
Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored" ]
}

@test "patching with two non-applicables returns 4" {
    run updateWithPatch --test-only "$UNAPPLICABLE_PATCH" "$UNAPPLICABLE_PATCH"
    [ $status -eq 4 ]
    [ "$output" = "1 out of 1 hunk FAILED
1 out of 1 hunk FAILED" ]
}

@test "patching with success and no-mod succeeds" {
    run updateWithPatch --test-only "$PATCH" "$REVERTED_PATCH"
    [ $status -eq 0 ]
    [ "$output" = "Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored" ]
}

@test "patching with no-mod and success succeeds" {
    run updateWithPatch --test-only "$REVERTED_PATCH" "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored" ]
}

@test "patching with success and non-applicable succeeds" {
    run updateWithPatch --test-only "$PATCH" "$UNAPPLICABLE_PATCH"
    [ $status -eq 0 ]
    [ "$output" = "1 out of 1 hunk FAILED" ]
}

@test "patching with non-applicable and success succeeds" {
    run updateWithPatch --test-only "$UNAPPLICABLE_PATCH" "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "1 out of 1 hunk FAILED" ]
}

@test "patching with no-mod and non-applicable returns 1" {
    run updateWithPatch --test-only "$REVERTED_PATCH" "$UNAPPLICABLE_PATCH"
    [ $status -eq 1 ]
    [ "$output" = "Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored
1 out of 1 hunk FAILED" ]
}

@test "patching with non-applicable and no-mod returns 1" {
    run updateWithPatch --test-only "$UNAPPLICABLE_PATCH" "$REVERTED_PATCH"
    [ $status -eq 1 ]
    [ "$output" = "1 out of 1 hunk FAILED
Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored" ]
}

@test "patching with success and no-mod and non-applicable succeeds" {
    run updateWithPatch --test-only "$PATCH" "$REVERTED_PATCH" "$UNAPPLICABLE_PATCH"
    [ $status -eq 0 ]
    [ "$output" = "Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored
1 out of 1 hunk FAILED" ]
}

@test "patching with success and non-applicable and no-mod succeeds" {
    run updateWithPatch --test-only "$PATCH" "$UNAPPLICABLE_PATCH" "$REVERTED_PATCH"
    [ $status -eq 0 ]
    [ "$output" = "1 out of 1 hunk FAILED
Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored" ]
}

@test "patching with no-mod and success and non-applicable succeeds" {
    run updateWithPatch --test-only "$REVERTED_PATCH" "$PATCH" "$UNAPPLICABLE_PATCH"
    [ $status -eq 0 ]
    [ "$output" = "Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored
1 out of 1 hunk FAILED" ]
}

@test "patching with no-mod and non-applicable and success succeeds" {
    run updateWithPatch --test-only "$REVERTED_PATCH" "$UNAPPLICABLE_PATCH" "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored
1 out of 1 hunk FAILED" ]
}

@test "patching with non-applicable and success and no-mod succeeds" {
    run updateWithPatch --test-only "$UNAPPLICABLE_PATCH" "$PATCH" "$REVERTED_PATCH"
    [ $status -eq 0 ]
    [ "$output" = "1 out of 1 hunk FAILED
Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored" ]
}

@test "patching with non-applicable and no-mod and success succeeds" {
    run updateWithPatch --test-only "$UNAPPLICABLE_PATCH" "$REVERTED_PATCH" "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "1 out of 1 hunk FAILED
Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored" ]
}
