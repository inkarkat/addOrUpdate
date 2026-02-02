#!/usr/bin/env bats

load temp

@test "update with pattern skips the last line and does not append anything" {
    run -99 addOrUpdateLine --line "foo=new" --skip \$ "$FILE"
    assert_output - < "$FILE"
}

@test "update with pattern does not append because the add-after pattern is inside the passed skip address range" {
    run -99 addOrUpdateLine --line "new=added" --add-after '/#/' --skip 3,4 "$FILE"
    assert_output - < "$FILE"
}

@test "update with pattern appends after the second alternative because the first is inside the skip address range" {
    run -0 addOrUpdateLine --line "new=added" --add-after '/#\|foo=hi/' --skip 3,4 "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
foo=hoo bar baz
# SECTION
foo=hi
new=added
EOF
}
