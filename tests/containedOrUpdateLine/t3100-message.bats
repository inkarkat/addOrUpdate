#!/usr/bin/env bats

load temp

@test "message with replacement" {
    REPLACEMENT='&oo'
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrUpdateLine --in-place --update-match "foo=b" --replacement "$REPLACEMENT" "$FILE"
    assert_output -p "does not yet contain '$REPLACEMENT'. Shall I update it?"
    diff -y - --label expected "$FILE" <<'EOF'
sing/e=wha\ever
foo=booar
foo=hoo bar baz
# SECTION
foo=hi
EOF
}
