#!/usr/bin/env bats

load temp

@test "processing standard input works" {
    CONTENTS="# useless
stuff"
    output="$(echo "$CONTENTS" | addOrUpdateWithSed $SED_UPDATE)"
    assert_output - <<'EOF'
updated
stuff
EOF
}

@test "nonexisting file and standard input works" {
    CONTENTS="# useless
stuff"
    output="$(echo "$CONTENTS" | addOrUpdateWithSed $SED_UPDATE -- "$NONE" -)"
    assert_output - <<'EOF'
updated
stuff
EOF
}

@test "update in first existing file skips nonexisting files" {
    run -0 addOrUpdateWithSed --in-place $SED_UPDATE -- "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    diff -y - --label expected "$FILE" <<'EOF'
updated
foo=bar
foo=hoo bar baz
# SECTION
foo=hi
EOF
    diff -y "$FILE2" "$MORE2"
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}

@test "all nonexisting files returns 4" {
    run -4 addOrUpdateWithSed --in-place $SED_UPDATE -- "$NONE" "$NONE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}
