#!/usr/bin/env bats

load temp

@test "non-applicable patch returns 4" {
    run -4 updateWithPatch "$UNAPPLICABLE_PATCH"
    assert_output - <<EOF
1 out of 1 hunk FAILED
$(cat "$EXISTING")
EOF
}

@test "non-applicable in-place patch returns 4" {
    run -4 updateWithPatch --in-place "$UNAPPLICABLE_PATCH"
    assert_output '1 out of 1 hunk FAILED'
}
