#!/usr/bin/env bats

load temp

@test "recalls positive choice on yes" {
    REPLACEMENT='&oo'
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrUpdateLine --memoize-group containedOrUpdateLine --in-place --update-match "foo=b" --replacement "$REPLACEMENT" "$FILE"
    assert_output -p "does not yet contain '$REPLACEMENT'. Shall I update it?"

    cp -f "$INPUT" "$FILE"  # Restore original file.
    MEMOIZEDECISION_CHOICE=
    run -0 containedOrUpdateLine --memoize-group containedOrUpdateLine --in-place --update-match "foo=b" --replacement "$REPLACEMENT" "$FILE"
    assert_output -p "does not yet contain '$REPLACEMENT'. Will update it now."
}
