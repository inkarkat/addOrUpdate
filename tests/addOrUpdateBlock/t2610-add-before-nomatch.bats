#!/usr/bin/env bats

load temp

@test "update with nonexisting block does not insert at all if passed ADDRESS is not reached" {
    run -0 addOrUpdateBlock --marker test --block-text "$TEXT" --add-before 9999 "$FILE"
    assert_output - <<'EOF'
foo=bar
foo=hoo bar baz
# SECTION
foo=hi
EOF
}

@test "update with nonexisting block does not insert at all if passed ADDRESS does not match" {
    run -0 addOrUpdateBlock --marker test --block-text "$TEXT" --add-before '/^notFoundAnyWhere/' "$FILE"
    assert_output - <<'EOF'
foo=bar
foo=hoo bar baz
# SECTION
foo=hi
EOF
}
