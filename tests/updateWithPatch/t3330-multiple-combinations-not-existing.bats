#!/usr/bin/env bats

load temp

@test "patching with success and non-existing file returns 1" {
    run -1 updateWithPatch --test-only "$PATCH" doesNotExist.patch
    assert_output "patch: **** Can't open patch file doesNotExist.patch : No such file or directory"
}

@test "patching with non-existing and success returns 1" {
    run -1 updateWithPatch --test-only doesNotExist.patch "$PATCH"
    assert_output "patch: **** Can't open patch file doesNotExist.patch : No such file or directory"
}

@test "patching with non-existing and non-applicable returns 1" {
    run -1 updateWithPatch --test-only doesNotExist.patch "$UNAPPLICABLE_PATCH"
    assert_output - <<'EOF'
patch: **** Can't open patch file doesNotExist.patch : No such file or directory
1 out of 1 hunk FAILED
EOF
}

@test "patching with non-applicable and non-existing returns 1" {
    run -1 updateWithPatch --test-only "$UNAPPLICABLE_PATCH" doesNotExist.patch
    assert_output - <<'EOF'
1 out of 1 hunk FAILED
patch: **** Can't open patch file doesNotExist.patch : No such file or directory
EOF
}

@test "patching with no-mod and non-existing returns 1" {
    run -1 updateWithPatch --test-only "$REVERTED_PATCH" doesNotExist.patch
    assert_output - <<'EOF'
Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored
patch: **** Can't open patch file doesNotExist.patch : No such file or directory
EOF
}

@test "patching with non-existing and no-mod returns 1" {
    run -1 updateWithPatch --test-only doesNotExist.patch "$REVERTED_PATCH"
    assert_output - <<'EOF'
patch: **** Can't open patch file doesNotExist.patch : No such file or directory
Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored
EOF
}
