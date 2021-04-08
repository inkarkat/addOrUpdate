#!/usr/bin/env bats

load temp

@test "update with pattern matching full line uses pre line and REPLACEMENT" {
    PRELINE="# new header"
    run updateLine --pre-update "$PRELINE" --update-match '^foo=h.*$' --replacement "ox=replaced" "$FILE"

    [ $status -eq 0 ]
    [ "$output" = "sing/e=wha\\ever
foo=bar
$PRELINE
ox=replaced
# SECTION
foo=hi" ]
}
@test "update with pattern matching partial line uses pre line and REPLACEMENT just for match" {
    PRELINE="# new header"
    run updateLine --pre-update "$PRELINE" --update-match 'oo=h[a-z]\+' --replacement "ox=replaced" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "sing/e=wha\\ever
foo=bar
$PRELINE
fox=replaced bar baz
# SECTION
foo=hi" ]
}

@test "update with three separate pre lines and REPLACEMENT" {
    PRELINE1="# first header"
    PRELINE2=''
    PRELINE3="# third header"
    run updateLine --pre-update "$PRELINE1" --pre-update "$PRELINE2" --pre-update "$PRELINE3" --update-match '^foo=h.*$' --replacement "ox=replaced" "$FILE"

    [ $status -eq 0 ]
    [ "$output" = "sing/e=wha\\ever
foo=bar
$PRELINE1
$PRELINE2
$PRELINE3
ox=replaced
# SECTION
foo=hi" ]
}

@test "update with one multi-line pre line and REPLACEMENT" {
    PRELINE="# first header

# third header"
    PRELINE1="# first header"
    PRELINE2=''
    PRELINE3="# third header"
    run updateLine --pre-update "$PRELINE" --update-match '^foo=h.*$' --replacement "ox=replaced" "$FILE"

    [ $status -eq 0 ]
    [ "$output" = "sing/e=wha\\ever
foo=bar
$PRELINE1
$PRELINE2
$PRELINE3
ox=replaced
# SECTION
foo=hi" ]
}

@test "update with empty pre line and REPLACEMENT" {
    run updateLine --pre-update '' --update-match '^foo=h.*$' --replacement "ox=replaced" "$FILE"

    [ $status -eq 0 ]
    [ "$output" = "sing/e=wha\\ever
foo=bar

ox=replaced
# SECTION
foo=hi" ]
}

@test "update with single space pre line and REPLACEMENT" {
    PRELINE=" "
    run updateLine --pre-update "$PRELINE" --update-match '^foo=h.*$' --replacement "ox=replaced" "$FILE"

    [ $status -eq 0 ]
    [ "$output" = "sing/e=wha\\ever
foo=bar
$PRELINE
ox=replaced
# SECTION
foo=hi" ]
}
