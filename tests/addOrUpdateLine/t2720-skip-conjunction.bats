#!/usr/bin/env bats

load temp

@test "update with pattern skips lines with a range and a pattern and appends after them" {
    run -0 addOrUpdateLine --line "foo=new" --update-match "." --skip '1,4;/=/' "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
foo=hoo bar baz
foo=new
foo=hi
EOF
}

@test "update with pattern skips lines with a two patterns and appends after them" {
    run -0 addOrUpdateLine --line "foo=new" --update-match "." --skip '/[=#]/;/[aE]/' "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
foo=hoo bar baz
# SECTION
foo=new
EOF
}
