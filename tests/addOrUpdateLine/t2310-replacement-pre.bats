#!/usr/bin/env bats

load temp

@test "update with nonmatching pattern skips pre line and appends LINE not REPLACEMENT at the end" {
    PRELINE='# new header'
    UPDATE='foo=new'
    run -0 addOrUpdateLine --pre-update "$PRELINE" --line "$UPDATE" --update-match "foosball=never" --replacement "not=used" "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$UPDATE
EOF
}

@test "update with pattern matching full line uses pre line and REPLACEMENT" {
    PRELINE='# new header'
    run -0 addOrUpdateLine --pre-update "$PRELINE" --line "foo=new" --update-match '^foo=h.*$' --replacement "ox=replaced" "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
$PRELINE
ox=replaced
# SECTION
foo=hi
EOF
}
@test "update with pattern matching partial line uses pre line and REPLACEMENT just for match" {
    PRELINE='# new header'
    run -0 addOrUpdateLine --pre-update "$PRELINE" --line "foo=new" --update-match 'oo=h[a-z]\+' --replacement "ox=replaced" "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
$PRELINE
fox=replaced bar baz
# SECTION
foo=hi
EOF
}

@test "update with three separate pre lines and REPLACEMENT" {
    PRELINE1='# first header'
    PRELINE2=''
    PRELINE3='# third header'
    run -0 addOrUpdateLine --pre-update "$PRELINE1" --pre-update "$PRELINE2" --pre-update "$PRELINE3" --line "foo=new" --update-match '^foo=h.*$' --replacement "ox=replaced" "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
$PRELINE1
$PRELINE2
$PRELINE3
ox=replaced
# SECTION
foo=hi
EOF
}

@test "update with one multi-line pre line and REPLACEMENT" {
    PRELINE="# first header

# third header"
    PRELINE1='# first header'
    PRELINE2=''
    PRELINE3='# third header'
    run -0 addOrUpdateLine --pre-update "$PRELINE" --line "foo=new" --update-match '^foo=h.*$' --replacement "ox=replaced" "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
$PRELINE1
$PRELINE2
$PRELINE3
ox=replaced
# SECTION
foo=hi
EOF
}

@test "update with empty pre line and REPLACEMENT" {
    run -0 addOrUpdateLine --pre-update '' --line "foo=new" --update-match '^foo=h.*$' --replacement "ox=replaced" "$FILE"
    assert_output - <<'EOF'
sing/e=wha\ever
foo=bar

ox=replaced
# SECTION
foo=hi
EOF
}

@test "update with single space pre line and REPLACEMENT" {
    PRELINE=' '
    run -0 addOrUpdateLine --pre-update "$PRELINE" --line "foo=new" --update-match '^foo=h.*$' --replacement "ox=replaced" "$FILE"
    assert_output - <<EOF
sing/e=wha\\ever
foo=bar
$PRELINE
ox=replaced
# SECTION
foo=hi
EOF
}
