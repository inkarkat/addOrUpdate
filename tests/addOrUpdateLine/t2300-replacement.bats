#!/usr/bin/env bats

load temp

@test "update with nonmatching pattern appends LINE not REPLACEMENT at the end" {
    UPDATE="foo=new"
    run addOrUpdateLine --line "$UPDATE" --update-match "foosball=never" --replacement "not=used" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$INPUT")
$UPDATE" ]
}

@test "update with pattern matching full line uses REPLACEMENT" {
    run addOrUpdateLine --line "foo=new" --update-match '^foo=h.*$' --replacement "ox=replaced" "$FILE"

    [ $status -eq 0 ]
    [ "$output" = 'sing/e=wha\ever
foo=bar
ox=replaced
# SECTION
foo=hi' ]
}

@test "update with pattern matching partial line uses REPLACEMENT just for match" {
    run addOrUpdateLine --line "foo=new" --update-match 'oo=h[a-z]\+' --replacement "ox=replaced" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = 'sing/e=wha\ever
foo=bar
fox=replaced bar baz
# SECTION
foo=hi' ]
}

@test "REPLACEMENT can refer to capture groups" {
    run addOrUpdateLine --line "foo=new" --update-match '\([a-z]\+\)=\(ho\+\) .* \([a-z]\+\)$' --replacement "\2=\1 \3 (&)" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = 'sing/e=wha\ever
foo=bar
hoo=foo baz (foo=hoo bar baz)
# SECTION
foo=hi' ]
}

@test "REPLACEMENT with forward and backslashes" {
    run addOrUpdateLine --line "foo=new" --update-match '^foo=h.*$' --replacement '/new\\=\\\\here//' "$FILE"
    [ $status -eq 0 ]
    [ "$output" = 'sing/e=wha\ever
foo=bar
/new\=\\here//
# SECTION
foo=hi' ]
}

@test "REPLACEMENT with newlines" {
    run addOrUpdateLine --line "foo=new" --update-match '^foo=h.*$' --replacement $'the new\nis\nlonger' "$FILE"
    [ $status -eq 0 ]
    [ "$output" = 'sing/e=wha\ever
foo=bar
the new
is
longer
# SECTION
foo=hi' ]
}

@test "empty REPLACEMENT" {
    run addOrUpdateLine --line "foo=new" --update-match '^foo=h.*$' --replacement "" "$FILE"

    [ $status -eq 0 ]
    [ "$output" = 'sing/e=wha\ever
foo=bar

# SECTION
foo=hi' ]
}

@test "update with line that is identical but REPLACEMENT would update the line does not modify the file" {
    run addOrUpdateLine --line "foo=hoo bar baz" --update-match '^foo=h.*$' --replacement "ox=replaced" "$FILE"

    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with line where REPLACEMENT updates the line to the original content indicates no change" {
    run addOrUpdateLine --line "foo=new" --update-match '^foo=h.*$' --replacement "foo=hoo bar baz" "$FILE"

    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}
