#!/usr/bin/env bats

load temp

@test "update first line succeeds" {
    UPDATE='foo=new'
    run -0 addOrUpdateWithSed $SED_UPDATE -- "$FILE"
    assert_output - <<'EOF'
updated
foo=bar
foo=hoo bar baz
# SECTION
foo=hi
EOF
}

@test "update with error returns 1" {
    run -1 addOrUpdateWithSed $SED_ERROR -- "$FILE"
    assert_output - < "$INPUT"
}

@test "update with no modification returns 99" {
    run -99 addOrUpdateWithSed $SED_NO_MOD -- "$FILE"
    assert_output - < "$INPUT"
}

@test "in-place update of first line succeeds" {
    UPDATE='foo=new'
    run -0 addOrUpdateWithSed --in-place $SED_UPDATE -- "$FILE"
    assert_output ''
    diff -y - --label expected "$FILE" <<'EOF'
updated
foo=bar
foo=hoo bar baz
# SECTION
foo=hi
EOF
}

@test "in-place update with error returns 1" {
    run -1 addOrUpdateWithSed --in-place $SED_ERROR -- "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}

@test "in-place update with no modification returns 99" {
    run -99 addOrUpdateWithSed --in-place $SED_NO_MOD -- "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}

@test "test-only update with update of first line succeeds" {
    run -0 addOrUpdateWithSed --test-only $SED_UPDATE -- "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}

@test "test-only update with error returns 1" {
    run -1 addOrUpdateWithSed --test-only $SED_ERROR -- "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}

@test "test-only update with no modification returns 99" {
    run -99 addOrUpdateWithSed --test-only $SED_NO_MOD -- "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}
