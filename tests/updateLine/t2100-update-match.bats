#!/usr/bin/env bats

load temp

@test "update with nonmatching pattern returns 1" {
    run -1 updateLine --update-match "foosball=never" --line new "$FILE"
    assert_output - < "$INPUT"
}

@test "update with literal-like pattern updates first matching line" {
    run -0 updateLine --update-match "foo=h.*" --line "foo=new" "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
foo=new
# SECTION
foo=hi
EOF
}

@test "update with anchored pattern updates first matching line" {
    run -0 updateLine --update-match "^fo\+=[ghi].*$" --line "foo=new" "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
foo=new
# SECTION
foo=hi
EOF
}

@test "update with pattern containing forward and backslash updates first matching line" {
    run -0 updateLine --update-match '^.*/.=.*\\.*' --replacement 'foo=/e\\' "$FILE"
    assert_output - <<'EOF'
foo=/e\
foo=bar
foo=hoo bar baz
# SECTION
foo=hi
EOF
}
