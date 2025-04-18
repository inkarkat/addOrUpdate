#!/usr/bin/env bats

load fixture

@test "update of block with custom begin and end markers" {
    run -0 addOrUpdateBlock --begin-marker '// From here' --end-marker '// To there' --block-text $'# test BEGIN\nUpdated stuff' "${BATS_TEST_DIRNAME}/different-marker.txt"
    assert_output - <<'EOF'
// From here
# test BEGIN
Updated stuff
// To there
here again.
# END test
EOF
}
