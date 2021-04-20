#!/usr/bin/env bats

@test "update of block with repeated begin updates from the second begin only" {
    run updateBlock --marker repeated --block-text "UPDATE" "${BATS_TEST_DIRNAME}/repeated-begin.txt"
    [ $status -eq 0 ]
    [ "$output" = "one
two
# BEGIN repeated
hello
# BEGIN repeated
UPDATE
# END repeated
last" ]
}

@test "update of block with repeasted end updates to the first end only" {
    run updateBlock --marker repeated --block-text "UPDATE" "${BATS_TEST_DIRNAME}/repeated-end.txt"
    [ $status -eq 0 ]
    [ "$output" = "one
two
# BEGIN repeated
UPDATE
# END repeated
good morning
# END repeated
last" ]
}
