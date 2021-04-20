#!/usr/bin/env bats

@test "update of block with custom begin and end markers" {
    run updateBlock --begin-marker '// From here' --end-marker '// To there' --block-text $'# test BEGIN\nUpdated stuff' "${BATS_TEST_DIRNAME}/different-marker.txt"
    [ $status -eq 0 ]
    [ "$output" = "// From here
# test BEGIN
Updated stuff
// To there
here again.
# END test" ]
}
