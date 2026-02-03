#!/usr/bin/env bats

load temp

@test "update with pattern skips all lines except one with a range and a pattern and updates that" {
    run -0 addOrUpdateLine --line "foo=new" --update-match "o=" --skip '1,$' --no-skip '4,$;/oo/' "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
foo=hoo bar baz
# SECTION
foo=new
EOF
}

@test "update with pattern skips all lines except one with two patterns and updates that" {
    run -0 addOrUpdateLine --line "foo=new" --update-match "o=" --skip '1,$' --no-skip '/oo/;/z/' "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
foo=new
# SECTION
foo=hi
EOF
}

@test "update with pattern skips all lines except one with three patterns and updates that" {
    run -0 addOrUpdateLine --line "foo=new" --update-match "o=" --skip '1,$' --no-skip '/a/;/oo/;/z/' "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
foo=new
# SECTION
foo=hi
EOF
}
