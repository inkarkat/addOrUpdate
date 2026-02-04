#!/usr/bin/env bats

load temp

@test "processing standard input with creation of nonexisting works" {
    CONTENTS=$'[default]\nfoo=bar'
    run -0 addOrUpdateIniConfig --create-nonexisting --section default --key foo --value new <<<"$CONTENTS"
    assert_output - <<EOF
[default]
foo=new
EOF
}

@test "update with nonexisting first file creates and appends there" {
    run -0 addOrUpdateIniConfig --create-nonexisting --in-place --section default --key foo --value new "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    assert_exists "$NONE"
    diff -y - --label expected "$NONE" <<EOF

[default]
foo=new
EOF
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    assert_not_exists "$NONE2"
}

@test "update with all nonexisting files creates and appends to the first one" {
    run -0 addOrUpdateIniConfig --create-nonexisting --in-place --section default --key foo --value new "$NONE" "$NONE2"
    assert_output ''
    assert_exists "$NONE"
    diff -y - --label expected "$NONE" <<EOF

[default]
foo=new
EOF
    assert_not_exists "$NONE2"
}

@test "update nonexisting file with pre line" {
    PRELINE='# new header'
    run -0 addOrUpdateIniConfig --create-nonexisting --in-place --pre-line "$PRELINE" --section default --key new --value add "$NONE"
    diff -y - --label expected "$NONE" <<EOF

[default]
$PRELINE
new=add
EOF
}

@test "update nonexisting file with post line" {
    POSTLINE='# new footer'
    run -0 addOrUpdateIniConfig --create-nonexisting --in-place --post-line "$POSTLINE" --section default --key new --value add "$NONE"
    diff -y - --label expected "$NONE" <<EOF

[default]
new=add
$POSTLINE
EOF
}

@test "update with nonexisting files and --all creates and appends each" {
    run -0 addOrUpdateIniConfig --create-nonexisting --all --in-place --section default --key foo --value new "$NONE" "$FILE" "$NONE2" "$FILE2"
    assert_output ''
    assert_exists "$NONE"
    assert_exists "$NONE2"
    diff -y - --label expected "$NONE" <<EOF

[default]
foo=new
EOF
    diff -y - --label expected "$NONE2" <<EOF

[default]
foo=new
EOF
    diff -y - --label expected "$FILE" <<'EOF'
[global]
foo=none
bar=hey

[default]
sing/e=wha\ever
foo=new
foo=hoo bar baz

[spec/ial\one]
foo=hi

[last one]
foo=old
EOF
    diff -y - --label expected "$FILE2" <<'EOF'
[global]

[default]
foo=new
quux=initial
foo=moo bar baz
EOF
}

@test "update with all nonexisting files and --all creates and appends to each" {
    run -0 addOrUpdateIniConfig --create-nonexisting --all --in-place --section default --key new --value add "$NONE" "$NONE2"
    assert_output ''
    assert_exists "$NONE"
    assert_exists "$NONE2"
    diff -y - --label expected "$NONE" <<EOF

[default]
new=add
EOF
    diff -y - --label expected "$NONE2" <<EOF

[default]
new=add
EOF
}
