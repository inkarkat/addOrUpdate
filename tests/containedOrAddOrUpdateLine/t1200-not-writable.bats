#!/usr/bin/env bats

load fixture

@test "creating a nonexisting file in a nonexisting directory returns 5" {
    TARGET_DIR="${BATS_TMPDIR}/doesNotExist"
    assert_not_exists "$TARGET_DIR"
    NONEXISTING="${TARGET_DIR}/doesNotExistEither"
    export MEMOIZEDECISION_CHOICE=y
    run -5 containedOrAddOrUpdateLine --create-nonexisting --in-place --line "foo=new" "$NONEXISTING"
    assert_output -e '/doesNotExist/doesNotExistEither: No such file or directory$'
}
