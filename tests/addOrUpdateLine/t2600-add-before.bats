#!/usr/bin/env bats

load temp

@test "update with nonexisting line inserts on the passed line" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --line "$UPDATE" --add-before 4 "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
foo=hoo bar baz
$UPDATE
# SECTION
foo=hi
EOF
}

@test "update with nonexisting line inserts on the passed ADDRESS" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --line "$UPDATE" --add-before '/^#/' "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
foo=hoo bar baz
$UPDATE
# SECTION
foo=hi
EOF
}

@test "update with nonexisting line inserts on the first match of ADDRESS only" {
    UPDATE='foo=new'
    run -0 addOrUpdateLine --line "$UPDATE" --add-before '/^foo=/' "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
$UPDATE
foo=bar
foo=hoo bar baz
# SECTION
foo=hi
EOF
}

@test "update with existing line on the passed line keeps contents and returns 1" {
    run -99 addOrUpdateLine --line "foo=bar" --add-before 2 "$FILE"
    assert_output - < "$INPUT"
}

@test "update with existing line one after the passed line appends early and ignores the existing later line" {
    run -0 addOrUpdateLine --line "foo=bar" --add-before 1 "$FILE"
    assert_output - <<'EOF'
foo=bar
sing/e=wha\ever
foo=bar
foo=hoo bar baz
# SECTION
foo=hi
EOF
}

@test "update with nonexisting line does not modify the buffer if before-ADDRESS does not match" {
    UPDATE='foo=new'
    run -99 addOrUpdateLine --line "$UPDATE" --add-before '/doesNotMatch/' "$FILE"
    assert_output - < "$FILE"
}
