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
    IMMUTABLE='/etc/hosts'
    [ -e "$IMMUTABLE" -a ! -w "$IMMUTABLE" ]
    run addOrUpdateLine --in-place --line "foo=new" "$IMMUTABLE"
    [ $status -eq 5 ]
    [ "${#lines[@]}" -eq 1 ]
    [[ "$output" =~ ^sed: ]]
}

@test "creating a nonexisting file in a non-writable directory returns 5" {
    IMMUTABLE_NEW="${IMMUTABLE_DIRSPEC}/doesNotExist"
    [ ! -e "$IMMUTABLE_NEW" ]
    run addOrUpdateLine --create-nonexisting --in-place --line "foo=new" "$IMMUTABLE_NEW"
    [ $status -eq 5 ]
    [ "${#lines[@]}" -eq 1 ]
    [[ "$output" =~ /doesNotExist:\ Permission\ denied$ ]]
}

@test "creating a nonexisting file in a nonexisting directory returns 5" {
    TARGET_DIR="${BATS_TMPDIR}/doesNotExist"
    [ ! -e "$TARGET_DIR" ]
    NONEXISTING="${TARGET_DIR}/doesNotExistEither"
    run addOrUpdateLine --create-nonexisting --in-place --line "foo=new" "$NONEXISTING"
    [ $status -eq 5 ]
    [ "${#lines[@]}" -eq 1 ]
    [[ "$output" =~ /doesNotExist/doesNotExistEither:\ No\ such\ file\ or\ directory$ ]]
}
