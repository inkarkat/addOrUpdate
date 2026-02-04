#!/usr/bin/env bats

load temp

@test "processing standard input with existing section works" {
    CONTENTS=$'[default]\nfoo=bar'
    run -0 addOrUpdateIniConfig --section default --key new --value add <<<"$CONTENTS"
    assert_output - <<EOF
$CONTENTS
new=add
EOF
}

@test "processing standard input without existing section works" {
    CONTENTS=$'[global]\nfoo=bar'
    run -0 addOrUpdateIniConfig --section default --key new --value add <<<"$CONTENTS"
    assert_output - <<EOF
$CONTENTS

[default]
new=add
EOF
}

@test "nonexisting file and standard input works" {
    CONTENTS=$'[global]\nfoo=bar'
    run -0 addOrUpdateIniConfig --section global --key new --value add "$NONE" - <<<"$CONTENTS"
    assert_output - <<EOF
$CONTENTS
new=add
EOF
}

@test "update in first existing file skips nonexisting files" {
    run -0 addOrUpdateIniConfig --in-place --section default --key foo --value add "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    diff -y - --label expected "$FILE" <<'EOF'
[global]
foo=none
bar=hey

[default]
sing/e=wha\ever
foo=add
foo=hoo bar baz

[spec/ial\one]
foo=hi

[last one]
foo=old
EOF
    diff -y "$FILE2" "$MORE2"
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}

@test "all nonexisting files returns 4" {
    run -4 addOrUpdateIniConfig --in-place --section default --key new --value add "$NONE" "$NONE2"
    assert_output ''
    assert_not_exists "$NONE"
    assert_not_exists "$NONE2"
}
