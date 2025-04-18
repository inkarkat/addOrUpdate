#!/usr/bin/env bats

load temp

@test "update with updated line on the passed line updates that line" {
    run -0 updateLine --update-match "foo=b.*" --replacement '&&' --add-before 2 "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=barfoo=bar
foo=hoo bar baz
# SECTION
foo=hi
EOF
}

@test "update with existing line one after the passed line keeps contents and returns 1" {
    run -1 updateLine --update-match "foo=b.*" --replacement '&&' --add-before 1 "$FILE"
    assert_output - < "$INPUT"
}
