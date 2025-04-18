#!/usr/bin/env bats

load temp

@test "update all in first file also updates or appends in following files" {
    updateBlock --all --in-place --marker test --block-text "$TEXT" "$FILE3" "$FILE2" "$FILE4"
    diff -y - --label expected "$FILE3" <<'EOF'
# BEGIN test
single-line
# END test
EOF
    diff -y - --label expected "$FILE2" <<'EOF'
first line
second line
third line
# BEGIN test
single-line
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
    diff -y - --label expected "$FILE4" <<'EOF'
one
# BEGIN test
single-line
# END test
middle
# BEGIN subsequent
Single line
# END subsequent
end
EOF
}

@test "update all with match in second file keeps previous and following files" {
    updateBlock --all --in-place --marker 'final and empty' --block-text "$TEXT" "$FILE3" "$FILE2" "$FILE4"
    diff -y "$FILE3" "$ANOTHER"
    diff -y - --label expected "$FILE2" <<'EOF'
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

middle line

# BEGIN test
Testing again
Somehoe
# END test

# BEGIN final and empty
single-line
# END final and empty
last line
EOF
    diff -y "$FILE4" "$LAST"
}

@test "update all with existing block in all files keeps contents and returns 99" {
    run -99 updateBlock --all --in-place --marker subsequent --block-text "Single line" "$FILE2" "$FILE4"
    diff -y "$FILE2" "$EXISTING"
    diff -y "$FILE4" "$LAST"
}

@test "update all with existing block in first two files returns 1" {
    run -1 updateBlock --all --in-place --marker subsequent --block-text "Single line" "$FILE2" "$FILE4" "$FILE3"
    diff -y "$FILE2" "$EXISTING"
    diff -y "$FILE3" "$ANOTHER"
    diff -y "$FILE4" "$LAST"
}

@test "update all with existing block in two files returns 99" {
    run -99 updateBlock --all --in-place --marker subsequent --block-text "Single line" "$FILE" "$FILE2" "$FILE3" "$FILE4"
    diff -y "$FILE" "$FRESH"
    diff -y "$FILE2" "$EXISTING"
    diff -y "$FILE3" "$ANOTHER"
    diff -y "$FILE4" "$LAST"
}

@test "update all with nonexisting block returns 1" {
    run -1 updateBlock --all --in-place --marker 'totally new' --block-text "$TEXT" "$FILE2" "$FILE3" "$FILE4"
    diff -y "$FILE" "$FRESH"
    diff -y "$FILE2" "$EXISTING"
    diff -y "$FILE3" "$ANOTHER"
    diff -y "$FILE4" "$LAST"
}
