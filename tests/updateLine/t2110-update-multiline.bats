#!/usr/bin/env bats

load temp

@test "update with literal-like pattern updates first matching line with multi-line replacement" {
    run -0 updateLine --replacement 'foo=multi\nline' --update-match "foo=h.*" "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
foo=multi
line
# SECTION
foo=hi
EOF
}

@test "update with literal-like pattern updates first matching line with multiple lines" {
    run -0 updateLine --line $'foo=multi\nline' --update-match "foo=h.*" "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
foo=multi
line
# SECTION
foo=hi
EOF
}
