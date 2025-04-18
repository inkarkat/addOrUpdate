#!/usr/bin/env bats

load temp

@test "update with existing line one after the passed line skips early to do the update in the second file and ignores the existing later line" {
    run -0 addOrUpdateLine --in-place --line "foo=updated" --update-match "foo=b.*" --add-before 1 "$FILE" "$FILE2"
    diff -y "$FILE" "$INPUT"
    diff -y - --label expected "$FILE2" <<'EOF'
foo=updated
quux=initial
foo=moo bar baz
EOF
}
