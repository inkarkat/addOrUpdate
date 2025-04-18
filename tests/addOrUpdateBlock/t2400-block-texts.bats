#!/usr/bin/env bats

load temp

@test "update with nonexisting marker and multiple blocks appends the joined block" {
    run -0 addOrUpdateBlock --marker test --block-text "Leading line" --block-text $'several\nlines\nin\nthe\n\nmiddle\n\n' --block-text "Trailing line" "$FILE"
    assert_output - <<EOF
$(cat "$FRESH")
# BEGIN test
Leading line
several
lines
in
the

middle


Trailing line
# END test
EOF
}
