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
    run -5 addOrUpdateBlock --in-place --marker test --block-text $'new\nblock' "$IMMUTABLE_DIR_FILESPEC"
    assert_equal ${#lines[@]} 1
    assert_output -e '^sed:'
}

@test "creating a nonexisting file in a non-writable directory returns 5" {
    IMMUTABLE_NEW="${IMMUTABLE_DIRSPEC}/doesNotExist"
    run -5 addOrUpdateBlock --create-nonexisting --in-place --marker test --block-text $'new\nblock' "$IMMUTABLE_NEW"
    assert_equal ${#lines[@]} 1
    assert_output -e '/doesNotExist: Permission denied$'
}

@test "creating a nonexisting file in a nonexisting directory returns 5" {
    TARGET_DIR="${BATS_TMPDIR}/doesNotExist"
    assert_not_exists "$TARGET_DIR"
    NONEXISTING="${TARGET_DIR}/doesNotExistEither"
    run -5 addOrUpdateBlock --create-nonexisting --in-place --marker test --block-text $'new\nblock' "$NONEXISTING"
    assert_equal ${#lines[@]} 1
    assert_output -e '/doesNotExist/doesNotExistEither: No such file or directory$'
}
