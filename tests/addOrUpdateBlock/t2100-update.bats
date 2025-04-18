#!/usr/bin/env bats

load temp

@test "update with nonexisting marker and single-line block appends the block" {
    run -0 addOrUpdateBlock --marker test --block-text "$TEXT" "$FILE"
    assert_output - <<EOF
$(cat "$FRESH")
# BEGIN test
$TEXT
# END test
EOF
}

@test "update with nonexisting marker and multi-line block appends the block" {
    run -0 addOrUpdateBlock --marker test --block-text $'across\nmultiple\nlines' "$FILE"
    assert_output - <<EOF
$(cat "$FRESH")
# BEGIN test
across
multiple
lines
# END test
EOF
}

@test "update with existing marker and same single-line block keeps contents and returns 99" {
    run -99 addOrUpdateBlock --marker subsequent --block-text "Single line" "$FILE2"
    assert_output - < "$EXISTING"
}

@test "update with existing marker and different single-line block updates the block" {
    run -0 addOrUpdateBlock --marker subsequent --block-text "Changed line" "$FILE2"
    assert_output - <<'EOF'
first line
second line
third line
# BEGIN test
The original comment
is this one.
# END test
# BEGIN subsequent
Changed line
# END subsequent

middle line

# BEGIN test
Testing again
Somehoe
# END test

# BEGIN final and empty
# END final and empty
last line
EOF
}

@test "update with existing marker and same multi-line block keeps contents and returns 99" {
    run -99 addOrUpdateBlock --marker test --block-text $'The original comment\nis this one.' "$FILE2"
    assert_output - < "$EXISTING"
}

@test "update with existing marker and different multi-line block updates the block" {
    run -0 addOrUpdateBlock --marker test --block-text $'across\nmultiple\nlines' "$FILE2"
    assert_output - <<'EOF'
first line
second line
third line
# BEGIN test
across
multiple
lines
# END test
# BEGIN subsequent
Single line
# END subsequent

middle line

# BEGIN test
Testing again
Somehoe
# END test

# BEGIN final and empty
# END final and empty
last line
EOF
}
