#!/usr/bin/env bats

load temp

@test "update with nonexisting multi-line block from file returns error" {
    run -6 addOrUpdateBlock --marker test --block-file "doesNotExist.txt" "$FILE"
    assert_output -e 'doesNotExist.txt: No such file or directory$'
}
