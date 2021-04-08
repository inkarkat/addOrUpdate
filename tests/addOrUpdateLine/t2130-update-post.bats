#!/usr/bin/env bats

load temp

@test "update with nonmatching pattern skips post line and appends at the end" {
    POSTLINE="# new footer"
    UPDATE='foo=not here'
    run addOrUpdateLine --post-update "$POSTLINE" --line "$UPDATE" --update-match "foosball=never" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$INPUT")
$UPDATE" ]
}

@test "update with one post line and line" {
    POSTLINE="# new footer"
    UPDATE='foo=not here'
    run addOrUpdateLine --post-update "$POSTLINE" --line "$UPDATE" --update-match "foo=h" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "sing/e=wha\\ever
foo=bar
$UPDATE
$POSTLINE
# SECTION
foo=hi" ]
}

@test "identical update skips post line" {
    POSTLINE="# new footer"
    run addOrUpdateLine --line 'foo=new' --post-update "$POSTLINE" --update-match '^foo=b.*' --replacement 'foo=bar' "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with three separate post lines and line" {
    POSTLINE1="# first footer"
    POSTLINE2=''
    POSTLINE3="# third footer"
    UPDATE='foo=not here'
    run addOrUpdateLine --post-update "$POSTLINE1" --post-update "$POSTLINE2" --post-update "$POSTLINE3" --line "$UPDATE" --update-match "foo=h" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "sing/e=wha\\ever
foo=bar
$UPDATE
$POSTLINE1
$POSTLINE2
$POSTLINE3
# SECTION
foo=hi" ]
}

@test "update with one multi-line post line and line" {
    POSTLINE="# first footer

# third footer"
    POSTLINE1="# first footer"
    POSTLINE2=''
    POSTLINE3="# third footer"
    UPDATE='foo=not here'
    run addOrUpdateLine --post-update "$POSTLINE" --line "$UPDATE" --update-match "foo=h" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "sing/e=wha\\ever
foo=bar
$UPDATE
$POSTLINE1
$POSTLINE2
$POSTLINE3
# SECTION
foo=hi" ]
}

@test "update with empty post line and line" {
    UPDATE='foo=not here'
    run addOrUpdateLine --post-update '' --line "$UPDATE" --update-match "foo=h" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "sing/e=wha\\ever
foo=bar
$UPDATE

# SECTION
foo=hi" ]
}

@test "update with single space post line and line" {
    POSTLINE=" "
    UPDATE='foo=not here'
    run addOrUpdateLine --post-update "$POSTLINE" --line "$UPDATE" --update-match "foo=h" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "sing/e=wha\\ever
foo=bar
$UPDATE
$POSTLINE
# SECTION
foo=hi" ]
}
