#!/usr/bin/env bats

load fixture

@test "update of block with repeated begin updates from the second begin only" {
    run -0 updateBlock --marker repeated --block-text "UPDATE" "${BATS_TEST_DIRNAME}/repeated-begin.txt"
    assert_output - <<'EOF'
one
two
# BEGIN repeated
hello
# BEGIN repeated
UPDATE
# END repeated
last
EOF
}

@test "update of block with repeasted end updates to the first end only" {
    run -0 updateBlock --marker repeated --block-text "UPDATE" "${BATS_TEST_DIRNAME}/repeated-end.txt"
    assert_output - <<'EOF'
one
two
# BEGIN repeated
UPDATE
# END repeated
good morning
# END repeated
last
EOF
}
