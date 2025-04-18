#!/usr/bin/env bats

load temp

@test "update in first file skips following files" {
    updateBlock --in-place --marker test --block-text "$TEXT" "$FILE3" "$FILE2" "$FILE4"
    diff -y - --label expected "$FILE3" <<'EOF'
# BEGIN test
single-line
# END test
EOF
    diff -y "$FILE2" "$EXISTING"
    diff -y "$FILE4" "$LAST"
}

@test "update with match in second file skips previous and following files" {
    updateBlock --in-place --marker subsequent --block-text "$TEXT" "$FILE3" "$FILE4" "$FILE2"
    diff -y "$FILE3" "$ANOTHER"
    diff -y - --label expected "$FILE4" <<'EOF'
one
# BEGIN test
Final testing
# END test
middle
# BEGIN subsequent
single-line
# END subsequent
end
EOF
    diff -y "$FILE2" "$EXISTING"
}

@test "update with existing block in all files keeps contents and returns 99" {
    run -99 updateBlock --in-place --marker subsequent --block-text "Single line" "$FILE2" "$FILE4"
    diff -y "$FILE2" "$EXISTING"
    diff -y "$FILE4" "$LAST"
}

@test "update with existing block in first two files returns 1" {
    run -1 updateBlock --in-place --marker subsequent --block-text "Single line" "$FILE2" "$FILE4" "$FILE3"
    diff -y "$FILE2" "$EXISTING"
    diff -y "$FILE3" "$ANOTHER"
    diff -y "$FILE4" "$LAST"
}

@test "update with nonexisting block appends at the end of the last file only" {
    run -1 updateBlock --in-place --marker 'totally new' --block-text "$TEXT" "$FILE2" "$FILE3" "$FILE4"
    diff -y "$FILE2" "$EXISTING"
    diff -y "$FILE3" "$ANOTHER"
    diff -y "$FILE4" "$LAST"
}
