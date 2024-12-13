#!/usr/bin/env bats

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
    run updateAssignment --in-place --lhs foo --rhs new "$IMMUTABLE_DIR_FILESPEC"
    [ $status -eq 5 ]
    [ "${#lines[@]}" -eq 1 ]
    [[ "$output" =~ ^sed: ]]
}

