#!/usr/bin/env bats

load fixture

@test "update of sole block without contents" {
    run -0 updateBlock --marker 'final and empty' --block-text $'filled\nin' "${BATS_TEST_DIRNAME}/empty-block.txt"
    assert_output - <<'EOF'
first
# BEGIN final and empty
filled
in
# END final and empty
last
EOF
}
