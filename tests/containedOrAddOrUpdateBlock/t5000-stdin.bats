#!/usr/bin/env bats

load temp

@test "returns 99 and no output if implicit stdin already contains the block" {
    export MEMOIZEDECISION_CHOICE=n
    run -99 containedOrAddOrUpdateBlock --marker test --block-text "$TEXT" <<<"$BLOCK"
    assert_output -e ' already contains test; no update necessary\.$'
}

@test "returns 99 and no output if stdin as - already contains the block" {
    export MEMOIZEDECISION_CHOICE=n
    run -99 containedOrAddOrUpdateBlock --marker test --block-text "$TEXT" - <<<"$BLOCK"
    assert_output -e ' already contains test; no update necessary\.$'
}

@test "asks and returns 98 and no output if the update is declined by the user" {
    export MEMOIZEDECISION_CHOICE=n
    run -98 containedOrAddOrUpdateBlock --marker test --block-text new - <<<"$BLOCK"
    assert_output -p 'does not yet contain test. Shall I update it?'
}

@test "asks, appends, returns 0, and prints output if the update is accepted by the user" {
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrAddOrUpdateBlock --marker test --block-text new - <<<"$BLOCK"
    assert_line -n 0 -p 'does not yet contain test. Shall I update it?'
    IFS=$'\n'
    output="${lines[*]:1}" assert_output - <<'EOF'
# BEGIN test
new
# END test
EOF
}
