#!/usr/bin/env bats

load temp

@test "patching first with two alternatives prints the first result and keeps the original intact" {
    run -0 updateWithPatch --first "$PATCH" "$ALTERNATIVE_PATCH"
    assert_output - < "$RESULT"
    diff -y "$EXISTING" "$FILE"
}

@test "in-place patching first with two alternatives applies the first and does not try the second" {
    run -0 updateWithPatch --first --in-place "$PATCH" "$ALTERNATIVE_PATCH"
    assert_output ''
    diff -y "$FILE" "$RESULT"
}

@test "test-only patching first with two alternatives succeeds" {
    run -0 updateWithPatch --first --test-only "$PATCH" "$ALTERNATIVE_PATCH"
    assert_output ''
    diff -y "$EXISTING" "$FILE"
}

@test "patching first with two serial patches prints the first result and keeps the original intact" {
    run -0 updateWithPatch --first "$PATCH" "$SECOND_PATCH"
    assert_output - < "$RESULT"
    diff -y "$EXISTING" "$FILE"
}

@test "in-place patching first with two serial patches applies the first" {
    run -0 updateWithPatch --first --in-place "$PATCH" "$SECOND_PATCH"
    assert_output ''
    diff -y "$FILE" "$RESULT"
}

@test "test-only patching first with two serial patches succeeds" {
    run -0 updateWithPatch --first --test-only "$PATCH" "$SECOND_PATCH"
    assert_output ''
    diff -y "$EXISTING" "$FILE"
}

@test "patching first with two swapped serial patches prints the first result and keeps the original intact" {
    run -0 updateWithPatch --first "$SECOND_PATCH" "$PATCH"
    assert_output - <<'EOF'
prepended first line
first line
second line
third line
second-to-last line
last line
appended last line
EOF
    diff -y "$EXISTING" "$FILE"
}

@test "in-place patching first with two swapped serial patches applies the first" {
    run -0 updateWithPatch --first --in-place "$SECOND_PATCH" "$PATCH"
    assert_output ''
    diff -y - --label expected "$FILE" <<EOF
prepended first line
$(cat "$EXISTING")
appended last line
EOF
}

@test "test-only patching first with two swapped serial patches succeeds" {
    run -0 updateWithPatch --first --test-only "$SECOND_PATCH" "$PATCH"
    assert_output ''
    diff -y "$EXISTING" "$FILE"
}

@test "swapped in-place patching first with two alternatives applies the first and does not try the second" {
    run -0 updateWithPatch --first --in-place "$ALTERNATIVE_PATCH" "$PATCH"
    assert_output ''
    diff -y "$FILE" "$ALTERNATIVE_RESULT"
}

@test "patching first with good and non-applicable patch prints the good result" {
    run -0 updateWithPatch --first "$PATCH" "$UNAPPLICABLE_PATCH"
    assert_output - < "$RESULT"
    diff -y "$EXISTING" "$FILE"
}

@test "in-place patching first with good and non-applicable patch applies the good and does not try the second" {
    run -0 updateWithPatch --first --in-place "$PATCH" "$UNAPPLICABLE_PATCH"
    assert_output ''
    diff -y "$FILE" "$RESULT"
}

@test "test-only patching first with good and non-applicable patch succeeds" {
    run -0 updateWithPatch --first --test-only "$PATCH"
    assert_output ''
    diff -y "$EXISTING" "$FILE"
}

@test "patching first with non-applicable and good patch prints the good result, error, and original" {
    run -0 updateWithPatch --first "$UNAPPLICABLE_PATCH" "$PATCH"
    assert_output - <<EOF
1 out of 1 hunk FAILED
$(cat "$EXISTING")
$(cat "$RESULT")
EOF
    diff -y "$EXISTING" "$FILE"
}

@test "in-place patching first with non-applicable and good patch applies the good and fails the first" {
    run -0 updateWithPatch --first --in-place "$UNAPPLICABLE_PATCH" "$PATCH"
    assert_output '1 out of 1 hunk FAILED'
    diff -y "$FILE" "$RESULT"
}

@test "test-only patching first with non-applicable and good patch succeeds and prints error" {
    run -0 updateWithPatch --first --test-only "$UNAPPLICABLE_PATCH" "$PATCH"
    assert_output '1 out of 1 hunk FAILED'
    diff -y "$EXISTING" "$FILE"
}
