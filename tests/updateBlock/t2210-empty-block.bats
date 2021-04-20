#!/usr/bin/env bats

@test "update of sole block without contents" {
    run updateBlock --marker 'final and empty' --block-text $'filled\nin' "${BATS_TEST_DIRNAME}/empty-block.txt"
    [ $status -eq 0 ]
    [ "$output" = "first
# BEGIN final and empty
filled
in
# END final and empty
last" ]
}
