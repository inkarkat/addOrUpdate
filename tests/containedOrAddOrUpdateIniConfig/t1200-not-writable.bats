#!/usr/bin/env bats

load fixture

@test "creating a nonexisting file in a nonexisting directory returns 5" {
    TARGET_DIR="${BATS_TMPDIR}/doesNotExist"
    [ ! -e "$TARGET_DIR" ]
    NONEXISTING="${TARGET_DIR}/doesNotExistEither"
    export MEMOIZEDECISION_CHOICE=y
    run -5 containedOrAddOrUpdateIniConfig --create-nonexisting --in-place --section default --key foo --value bar "$NONEXISTING"
    assert_output -e '/doesNotExist/doesNotExistEither: No such file or directory$'
}
