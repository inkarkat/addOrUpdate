#!/usr/bin/env bats

load temp

@test "asks again on confirm each" {
    UPDATE='disabled'
    export MEMOIZEDECISION_CHOICE=c
    run -0 containedOrAddOrUncommentLine --memoize-group containedOrAddOrUncommentLine --in-place --line "$UPDATE" "$FILE"
    assert_output -p "$(basename "$FILE") does not yet contain '$UPDATE'. Shall I update it?"

    cp -f "$INPUT" "$FILE"  # Restore original file.
    run -0 containedOrAddOrUncommentLine --memoize-group containedOrAddOrUncommentLine --in-place --line "$UPDATE" "$FILE"
    assert_output -p "$(basename "$FILE") does not yet contain '$UPDATE'. Shall I update it?"
}

@test "recalls positive choice on yes" {
    UPDATE='disabled'
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrAddOrUncommentLine --memoize-group containedOrAddOrUncommentLine --in-place --line "$UPDATE" "$FILE"
    assert_output -p "$(basename "$FILE") does not yet contain '$UPDATE'. Shall I update it?"

    cp -f "$INPUT" "$FILE"  # Restore original file.
    MEMOIZEDECISION_CHOICE=
    run -0 containedOrAddOrUncommentLine --memoize-group containedOrAddOrUncommentLine --in-place --line "$UPDATE" "$FILE"
    assert_output -p "$(basename "$FILE") does not yet contain '$UPDATE'. Will update it now."
}

@test "does not recall another file on yes" {
    UPDATE='disabled'
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrAddOrUncommentLine --memoize-group containedOrAddOrUncommentLine --in-place --line "$UPDATE" "$FILE"
    assert_output -p "$(basename "$FILE") does not yet contain '$UPDATE'. Shall I update it?"

    MEMOIZEDECISION_CHOICE=y
    run -0 containedOrAddOrUncommentLine --memoize-group containedOrAddOrUncommentLine --in-place --line "$UPDATE" "$FILE2"
    assert_output -p "$(basename "$FILE2") does not yet contain '$UPDATE'. Shall I update it?"
}

@test "recalls another file on any" {
    UPDATE='disabled'
    export MEMOIZEDECISION_CHOICE=a
    run -0 containedOrAddOrUncommentLine --memoize-group containedOrAddOrUncommentLine --in-place --line "$UPDATE" "$FILE"
    assert_output -p "$(basename "$FILE") does not yet contain '$UPDATE'. Shall I update it?"

    MEMOIZEDECISION_CHOICE=n
    run -0 containedOrAddOrUncommentLine --memoize-group containedOrAddOrUncommentLine --in-place --line "$UPDATE" "$FILE2"
    assert_output -p "$(basename "$FILE2") does not yet contain '$UPDATE'. Will update it now."
}
