#!/usr/bin/env bats

load temp

@test "update with nonexisting block inserts on the passed line" {
    run -0 addOrUpdateBlock --marker test --block-text "$TEXT" --add-before 3 "$FILE"
    assert_output - <<EOF
foo=bar
foo=hoo bar baz
$BLOCK
# SECTION
foo=hi
EOF
}

@test "update with nonexisting block inserts on the passed ADDRESS" {
    run -0 addOrUpdateBlock --marker test --block-text "$TEXT" --add-before '/^#/' "$FILE"
    assert_output - <<EOF
foo=bar
foo=hoo bar baz
$BLOCK
# SECTION
foo=hi
EOF
}

@test "update with nonexisting block inserts on the first match of ADDRESS only" {
    run -0 addOrUpdateBlock --marker new --block-text "$TEXT" --add-before '/^#/' "$FILE2"
    assert_output - <<'EOF'
first line
second line
third line
# BEGIN new
single-line
# END new
# BEGIN test
The original comment
is this one.
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

@test "update with nonexisting block inserts on the first empty line only" {
    run -0 addOrUpdateBlock --marker new --block-text "$TEXT" --add-before '/^$/' "$FILE2"
    assert_output - <<'EOF'
first line
second line
third line
# BEGIN test
The original comment
is this one.
# END test
# BEGIN subsequent
Single line
# END subsequent
# BEGIN new
single-line
# END new

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

@test "update with existing marker and different block before empty line" {
    run -0 addOrUpdateBlock --marker subsequent --block-text "$TEXT" --add-before '/^$/' "$FILE2"
    assert_output - <<EOF
first line
second line
third line
# BEGIN test
The original comment
is this one.
# END test
# BEGIN subsequent
$TEXT
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

@test "update with existing block before an empty line keeps contents and returns 99" {
    run -99 addOrUpdateBlock --marker subsequent --block-text "Single line" --add-before '/^$/' "$FILE2"
    assert_output - < "$EXISTING"
}

@test "update with existing marker and same multi-line block after the passed line keeps contents and returns 99" {
    run -99 addOrUpdateBlock --marker test --block-text $'The original comment\nis this one.' --add-before 12 "$FILE2"
    assert_output - < "$EXISTING"
}
