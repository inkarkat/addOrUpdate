#!/usr/bin/env bats

load temp

@test "--yes directly updates without user query" {
    UPDATE='foo=new'
    run -0 containedOrAddOrUpdateLine --yes --in-place --line "$UPDATE" "$FILE"
    assert_output -p "$(basename "$FILE") does not yet contain 'foo=new'. Will update it now."
}
