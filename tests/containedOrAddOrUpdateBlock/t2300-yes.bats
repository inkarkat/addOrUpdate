#!/usr/bin/env bats

load temp

@test "--yes directly updates without user query" {
    run -0 containedOrAddOrUpdateBlock --yes --in-place --marker test --block-text "$TEXT" "$FILE"
    assert_output -p "$(basename "$FILE") does not yet contain test. Will update it now."
}
