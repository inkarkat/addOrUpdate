#!/usr/bin/env bats

load temp

@test "update with nonmatching pattern appends LINE not REPLACEMENT at the end" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --line "$UPDATE" --update-match "foosball=never" --replacement "not=used" "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$UPDATE
EOF
}

@test "update with pattern matching full line uses REPLACEMENT" {
    run -0 addOrUpdateLine --line "foo=new" --update-match '^foo=h.*$' --replacement "ox=replaced" "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
ox=replaced
# SECTION
foo=hi
EOF
}

@test "update with pattern matching partial line uses REPLACEMENT just for match" {
    run -0 addOrUpdateLine --line "foo=new" --update-match 'oo=h[a-z]\+' --replacement "ox=replaced" "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
fox=replaced bar baz
# SECTION
foo=hi
EOF
}

@test "REPLACEMENT can refer to capture groups" {
    run -0 addOrUpdateLine --line "foo=new" --update-match '\([a-z]\+\)=\(ho\+\) .* \([a-z]\+\)$' --replacement "\2=\1 \3 (&)" "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
hoo=foo baz (foo=hoo bar baz)
# SECTION
foo=hi
EOF
}

@test "REPLACEMENT with forward and backslashes" {
    run -0 addOrUpdateLine --line "foo=new" --update-match '^foo=h.*$' --replacement '/new\\=\\\\here//' "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
/new\=\\here//
# SECTION
foo=hi
EOF
}

@test "REPLACEMENT with newlines" {
    run -0 addOrUpdateLine --line "foo=new" --update-match '^foo=h.*$' --replacement $'the new\nis\nlonger' "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar
the new
is
longer
# SECTION
foo=hi
EOF
}

@test "empty REPLACEMENT" {
    run -0 addOrUpdateLine --line "foo=new" --update-match '^foo=h.*$' --replacement "" "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar

# SECTION
foo=hi
EOF
}

@test "update with line that is identical but REPLACEMENT would update the line does not modify the file" {
    run -99 addOrUpdateLine --line "foo=hoo bar baz" --update-match '^foo=h.*$' --replacement "ox=replaced" "$FILE"
    assert_output - < "$INPUT"
}

@test "update with line where REPLACEMENT updates the line to the original content indicates no change" {
    run -99 addOrUpdateLine --line "foo=new" --update-match '^foo=h.*$' --replacement "foo=hoo bar baz" "$FILE"
    assert_output - < "$INPUT"
}
