#!/usr/bin/env bats

load temp

@test "update with pattern matching full line uses LINE" {
    run -0 updateLine --update-match '^foo=h.*$' --line "ox=replaced" "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
ox=replaced
# SECTION
foo=hi
EOF
}

@test "update with pattern matching partial line uses LINE just for match" {
    run -0 updateLine --update-match 'oo=h[a-z]\+' --line "ox=replaced" "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
fox=replaced bar baz
# SECTION
foo=hi
EOF
}

@test "REPLACEMENT can refer to capture groups" {
    run -0 updateLine --update-match '\([a-z]\+\)=\(ho\+\) .* \([a-z]\+\)$' --replacement "\2=\1 \3 (&)" "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
hoo=foo baz (foo=hoo bar baz)
# SECTION
foo=hi
EOF
}

@test "REPLACEMENT with forward and backslashes" {
    run -0 updateLine --update-match '^foo=h.*$' --replacement '/new\\=\\\\here//' "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
/new\=\\here//
# SECTION
foo=hi
EOF
}

@test "empty LINE is not supported" {
    run -2 updateLine --update-match '^foo=h.*$' --line '' "$FILE"
    assert_line -n 0 'ERROR: No --line LINE or --replacement REPLACEMENT passed.'
}

@test "empty REPLACEMENT" {
    run -0 updateLine --update-match '^foo=h.*$' --replacement '' "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar

# SECTION
foo=hi
EOF
}

@test "update with line where REPLACEMENT updates the line to the original content indicates no change" {
    run -99 updateLine --line "foo=new" --update-match '^foo=h.*$' --replacement "foo=hoo bar baz" "$FILE"
    assert_output - < "$INPUT"
}
