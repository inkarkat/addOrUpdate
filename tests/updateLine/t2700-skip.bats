#!/usr/bin/env bats

load temp

@test "update with pattern skips the passed line and appends after it" {
    run -0 updateLine --line "foo=new" --update-match "foo=.*" --skip 2 "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
foo=new
# SECTION
foo=hi
EOF
}

@test "update with pattern skips all passed lines and appends after them" {
    run -0 updateLine --line "foo=new" --update-match "foo=.*" --skip 2 --skip 3 "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
foo=hoo bar baz
# SECTION
foo=new
EOF
}

@test "update with pattern skips the passed address range and appends after it" {
    run -0 updateLine --line "foo=new" --update-match "foo=.*" --skip 2,3 "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
foo=hoo bar baz
# SECTION
foo=new
EOF
}

@test "update with pattern skips the passed address ranges and appends after them" {
    run -0 updateLine --line "foo=new" --update-match "." --skip 1,2 --skip '/^foo=/' "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
foo=hoo bar baz
foo=new SECTION
foo=hi
EOF
}

@test "update with pattern skips the last line and does not append anything" {
    run -99 updateLine --line "foo=new" --update-match "foo=h[ij]" --skip \$ "$FILE"
    assert_output - < "$FILE"
}
