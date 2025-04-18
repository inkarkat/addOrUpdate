#!/usr/bin/env bats

load temp

@test "update with nonmatching pattern appends at the end" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --line "$UPDATE" --update-match "foosball=never" "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$UPDATE
EOF
}

@test "update with literal-like pattern updates first matching line" {
    run -0 addOrUpdateLine --line "foo=new" --update-match "foo=h" "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
foo=new
# SECTION
foo=hi
EOF
}

@test "update with anchored pattern updates first matching line" {
    run -0 addOrUpdateLine --line "foo=new" --update-match "^fo\+=[ghi].*$" "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
foo=new
# SECTION
foo=hi
EOF
}

@test "update with pattern containing forward and backslash updates first matching line" {
    run -0 addOrUpdateLine --line 'foo=/e\' --update-match '^.*/.=.*\\.*' "$FILE"
    assert_output - <<'EOF'
foo=/e\
foo=bar
foo=hoo bar baz
# SECTION
foo=hi
EOF
}
