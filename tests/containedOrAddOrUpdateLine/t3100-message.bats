#!/usr/bin/env bats

load temp

@test "message with single file" {
    UPDATE='foo=new'
    export MEMOIZEDECISION_CHOICE=y
    run containedOrAddOrUpdateLine --in-place --line "$UPDATE" "$FILE"
    assert_output -p "does not yet contain '$UPDATE'. Shall I update it?"
}

@test "message with multiple files" {
    UPDATE='foo=new'
    export MEMOIZEDECISION_CHOICE=y
    run containedOrAddOrUpdateLine --in-place --line "$UPDATE" "$FILE" "$FILE2" "$FILE3"
    assert_output -e "At least one of .* does not yet contain '$UPDATE'\\. Shall I update it\\?"
}

@test "--all message with single file" {
    UPDATE='foo=new'
    export MEMOIZEDECISION_CHOICE=y
    run containedOrAddOrUpdateLine --all --in-place --line "$UPDATE" "$FILE"
    assert_output -p "does not yet contain '$UPDATE'. Shall I update it?"
}

@test "--all message with multiple files" {
    UPDATE='foo=new'
    export MEMOIZEDECISION_CHOICE=y
    run containedOrAddOrUpdateLine --all --in-place --line "$UPDATE" "$FILE" "$FILE2" "$FILE3"
    assert_output -e "All of .* do not yet contain '$UPDATE'\\. Shall I update them\\?"
}

@test "message with replacement" {
    UPDATE='foo=new'
    REPLACEMENT='&oo'
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrAddOrUpdateLine --in-place --update-match "foo=b" --replacement "$REPLACEMENT" --line "$UPDATE" "$FILE"
    assert_output -p "does not yet contain '$UPDATE' / '$REPLACEMENT'. Shall I update it?"
    diff -y - --label expected "$FILE" <<EOF
sing/e=wha\\ever
foo=booar
foo=hoo bar baz
# SECTION
foo=hi
EOF
}
