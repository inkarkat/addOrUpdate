#!/usr/bin/env bats

load temp

@test "--yes directly updates without user query" {
    run -0 containedOrUpdateWithPatch --yes --in-place "$PATCH"
    assert_output -p 'existing.txt does not yet contain diff.patch. Will apply it now.'
}
