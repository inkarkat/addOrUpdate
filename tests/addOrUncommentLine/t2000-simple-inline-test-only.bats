#!/usr/bin/env bats

load fixture
load temp

@test "update with nonexisting line appends at the end" {
    UPDATE="new"
    run -0 addOrUncommentLine --line "$UPDATE" "$FILE"
    assert_output - <<EOF
$(cat "$INPUT")
$UPDATE
EOF
}

@test "update with existing line keeps contents and returns 99" {
    run -99 addOrUncommentLine --line "some data" "$FILE"
    assert_output - < "$INPUT"
}

@test "update with commented-out line uncomments" {
    run -0 addOrUncommentLine --line "disabled" "$FILE"
    assert_output - <<'EOF'
# line
line
disabled
# SECTION
some data
last
# last
EOF
}

@test "update with both commented-out and existing line uncomments the first comment" {
    run -0 addOrUncommentLine --line "line" "$FILE"
    assert_output - <<'EOF'
line
line
# disabled
# SECTION
some data
last
# last
EOF
}

@test "update with both existing and commented-out line keeps the first existing" {
    run -99 addOrUncommentLine --line "last" "$FILE"
    assert_output - <<'EOF'
# line
line
# disabled
# SECTION
some data
last
# last
EOF
}

@test "in-place update with nonexisting line appends at the end" {
    UPDATE="new"
    run -0 addOrUncommentLine --in-place --line "$UPDATE" "$FILE"
    diff -y - --label expected "$FILE" <<EOF
$(cat "$INPUT")
$UPDATE
EOF
}

@test "in-place update with existing line keeps contents and returns 99" {
    run -99 addOrUncommentLine --in-place --line "some data" "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}

@test "in-place update with commented-out line uncomments" {
    run -0 addOrUncommentLine --in-place --line "disabled" "$FILE"
    assert_output ''
    diff -y - --label expected "$FILE" <<'EOF'
# line
line
disabled
# SECTION
some data
last
# last
EOF
}

@test "test-only update with nonexisting line succeeds" {
    UPDATE="new"
    run -0 addOrUncommentLine --test-only --line "$UPDATE" "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}

@test "test-only update with existing line returns 99" {
    run -99 addOrUncommentLine --test-only --line "some data" "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}

@test "test-only update with commented-out line succeeds" {
    run -0 addOrUncommentLine --test-only --line "disabled" "$FILE"
    assert_output ''
    diff -y "$FILE" "$INPUT"
}
