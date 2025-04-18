#!/usr/bin/env bats

load fixture

setup()
{
    IMMUTABLE_DIRSPEC="${BATS_TMPDIR}/immutable"
    IMMUTABLE_DIR_FILESPEC="${IMMUTABLE_DIRSPEC}/file"
    mkdir --parents -- "$IMMUTABLE_DIRSPEC"
    echo contents > "$IMMUTABLE_DIR_FILESPEC"
    chmod 500 -- "$IMMUTABLE_DIRSPEC"
    [ -d "$IMMUTABLE_DIRSPEC" -a ! -w "$IMMUTABLE_DIRSPEC" ]
}

@test "updating existing file in not-writable dir returns 5" {
    ls -l "$IMMUTABLE_DIR_FILESPEC"
    run -5 updateLine --in-place --update-match root --replacement '&&' "$IMMUTABLE_DIR_FILESPEC"
    assert_equal ${#lines[@]} 1
    assert_output -e '^sed:'
}

