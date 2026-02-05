#!/usr/bin/env bats

load temp

@test "update in first file skips following files" {
    UPDATE='foo=new'
    updateLine --in-place --update-match "foo=bar" --replacement '&&' "$FILE" "$FILE2" "$FILE3"
    diff -y - --label expected "$FILE" <<'EOF'
sing/e=wha\ever
foo=barfoo=bar
foo=hoo bar baz
# SECTION
foo=hi
EOF
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}

@test "update with match in second file skips previous and following files" {
    updateLine --in-place --update-match "quux=" --replacement '&&' "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y - --label expected "$FILE2" <<'EOF'
foo=bar
quux=quux=initial
foo=moo bar baz
EOF
    diff -y "$FILE3" "$MORE3"
}

@test "update with existing line in all files keeps contents and returns 99" {
    run -99 updateLine --in-place --update-match "foo=b.*" --replacement 'foo=bar' "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}

@test "update with existing line in first file returns 99" {
    UPDATE='foo=hoo bar baz'
    run -99 updateLine --in-place --update-match "foo=h.*" --replacement "$UPDATE" "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}

@test "update with nonexisting line returns 1" {
    UPDATE='foo=new'
    run -1 updateLine --in-place --update-match "foosball=never" --replacement '&&' "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}
