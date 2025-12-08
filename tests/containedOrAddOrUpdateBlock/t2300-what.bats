#!/usr/bin/env bats

load temp

@test "asks with custom block name" {
    WHAT='my secret sauce'
    export MEMOIZEDECISION_CHOICE=n
    run -98 containedOrAddOrUpdateBlock --what "$WHAT" --marker test --block-text new "$FILE2"
    assert_output -p "does not yet contain $WHAT. Shall I update it?"
}

@test "asks with default unnamed block" {
    export MEMOIZEDECISION_CHOICE=n
    run -98 containedOrAddOrUpdateBlock --begin-marker '# BEGIN test' --end-marker '# END test' --block-text new "$FILE2"
    assert_output -p 'does not yet contain the block. Shall I update it?'
}
