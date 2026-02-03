#!/usr/bin/env bats

load temp

@test "update with nonexisting line appends after the passed line" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --line "$UPDATE" --add-after 3 "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
foo=hoo bar baz
$UPDATE
# SECTION
foo=hi
EOF
}

@test "update with nonexisting line appends after the passed ADDRESS" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --line "$UPDATE" --add-after '/^#/' "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
foo=hoo bar baz
# SECTION
$UPDATE
foo=hi
EOF
}

@test "update with nonexisting line appends after the first match of ADDRESS only" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --line "$UPDATE" --add-after '/^foo=/' "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
$UPDATE
foo=hoo bar baz
# SECTION
foo=hi
EOF
}

@test "update with existing line after the passed line appends early and ignores the existing later line" {
    run -0 addOrUpdateLine --line "foo=hoo bar baz" --add-after 1 "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=hoo bar baz
foo=bar
foo=hoo bar baz
# SECTION
foo=hi
EOF
}

@test "update with existing line before the passed line keeps contents and returns 99" {
    run -99 addOrUpdateLine --line "foo=bar" --add-after 3 "$FILE"
    assert_output - < "$INPUT"
}

@test "update with nonexisting line does not modify the buffer if after-ADDRESS does not match" {
    UPDATE='foo=new'
    run -1 addOrUpdateLine --line "$UPDATE" --add-after '/doesNotMatch/' "$FILE"
    assert_output - < "$FILE"
}

@test "update with nonexisting line appends after the first match of multiple ADDRESSes only" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --line "$UPDATE" --add-after '/^#/' --add-after '/^foo=/' "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
$UPDATE
foo=hoo bar baz
# SECTION
foo=hi
EOF
}

@test "update with nonexisting line appends after the first match of multiple ADDRESSes that target the same line only" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --line "$UPDATE" --add-after '/^#/' --add-after '/SECTION/' "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
foo=hoo bar baz
# SECTION
$UPDATE
foo=hi
EOF
}
