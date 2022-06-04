#!/usr/bin/env bats

@test "updating not-writable existing file returns 5" {
    IMMUTABLE='/etc/hosts'
    [ -e "$IMMUTABLE" -a ! -w "$IMMUTABLE" ]
    run addOrAppendAssignment --in-place --lhs foo --rhs new "$IMMUTABLE"
    [ $status -eq 5 ]
    [ "${#lines[@]}" -eq 1 ]
    [[ "$output" =~ ^sed: ]]
}

@test "creating a nonexisting file in a non-writable directory returns 5" {
    IMMUTABLE_DIR='/etc'
    [ -d "$IMMUTABLE_DIR" -a ! -w "$IMMUTABLE_DIR" ]
    IMMUTABLE="${IMMUTABLE_DIR}/doesNotExist"
    [ ! -e "$IMMUTABLE" ]
    run addOrAppendAssignment --create-nonexisting --in-place --lhs foo --rhs new "$IMMUTABLE"
    [ $status -eq 5 ]
    [ "${#lines[@]}" -eq 1 ]
    [[ "$output" =~ /etc/doesNotExist:\ Permission\ denied$ ]]
}

@test "creating a nonexisting file in a nonexisting directory returns 5" {
    TARGET_DIR="${BATS_TMPDIR}/doesNotExist"
    [ ! -e "$TARGET_DIR" ]
    NONEXISTING="${TARGET_DIR}/doesNotExistEither"
    run addOrAppendAssignment --create-nonexisting --in-place --lhs foo --rhs new "$NONEXISTING"
    [ $status -eq 5 ]
    [ "${#lines[@]}" -eq 1 ]
    [[ "$output" =~ /doesNotExist/doesNotExistEither:\ No\ such\ file\ or\ directory$ ]]
}
