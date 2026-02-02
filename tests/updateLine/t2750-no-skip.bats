#!/usr/bin/env bats

load temp

@test "update with pattern skips all lines except one and appends after that" {
    run -0 updateLine --line "foo=new" --update-match "^.*o=.*$" --skip '1,$' --no-skip '/z/' "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
foo=new
# SECTION
foo=hi
EOF
}

@test "update with pattern skips matching lines except one and appends after that" {
    run -0 updateLine --line "foo=new" --update-match "^.*o=.*$" --skip '/^foo=/' --no-skip '/z/' "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
foo=new
# SECTION
foo=hi
EOF
}
