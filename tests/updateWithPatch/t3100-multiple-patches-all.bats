#!/usr/bin/env bats

load temp

@test "patching all with two alternatives prints both results and keeps the original intact" {
    run -0 updateWithPatch --all "$PATCH" "$ALTERNATIVE_PATCH"
    assert_output - <<EOF
$(cat "$RESULT")
$(cat "$ALTERNATIVE_RESULT")
EOF
    diff -y "$EXISTING" "$FILE"
}

@test "in-place patching all with two alternatives applies the first and fails because of the second" {
    run -4 updateWithPatch --all --in-place "$PATCH" "$ALTERNATIVE_PATCH"
    assert_output '1 out of 1 hunk FAILED'
    diff -y "$FILE" "$RESULT"
}

@test "test-only patching all with two alternatives succeeds" {
    run -0 updateWithPatch --all --test-only "$PATCH" "$ALTERNATIVE_PATCH"
    assert_output ''
    diff -y "$EXISTING" "$FILE"
}

@test "patching all with two serial patches prints both results and keeps the original intact" {
    run -0 updateWithPatch --all "$PATCH" "$SECOND_PATCH"
    assert_output - <<EOF
$(cat "$RESULT")
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

@test "in-place patching all with two serial patches applies both" {
    run -0 updateWithPatch --all --in-place "$PATCH" "$SECOND_PATCH"
    assert_output ''
    diff -y - --label expected "$FILE" <<'EOF'
prepended first line
new first line
first line
augmented second line
third line
last line
appended last line
EOF
}

@test "test-only patching all with two serial patches succeeds" {
    run -0 updateWithPatch --all --test-only "$PATCH" "$SECOND_PATCH"
    assert_output ''
    diff -y "$EXISTING" "$FILE"
}

@test "patching all with two swapped serial patches prints both results and keeps the original intact" {
    run -0 updateWithPatch --all "$SECOND_PATCH" "$PATCH"
    assert_output - <<EOF
prepended first line
first line
second line
third line
second-to-last line
last line
appended last line
$(cat "$RESULT")
EOF
    diff -y "$EXISTING" "$FILE"
}

@test "in-place patching all with two swapped serial patches applies both" {
    run -0 updateWithPatch --all --in-place "$SECOND_PATCH" "$PATCH"
    assert_output ''
    diff -y - --label expected "$FILE" <<'EOF'
prepended first line
new first line
first line
augmented second line
third line
last line
appended last line
EOF
}

@test "test-only patching all with two swapped serial patches succeeds" {
    run -0 updateWithPatch --all --test-only "$SECOND_PATCH" "$PATCH"
    assert_output ''
    diff -y "$EXISTING" "$FILE"
}

@test "swapped in-place patching all with two alternatives applies the first and fails because of the second" {
    run -4 updateWithPatch --all --in-place "$ALTERNATIVE_PATCH" "$PATCH"
    assert_output '1 out of 1 hunk FAILED'
    diff -y "$FILE" "$ALTERNATIVE_RESULT"
}

@test "patching all with good and non-applicable patch prints the good result, error, and original" {
    run -4 updateWithPatch --all "$PATCH" "$UNAPPLICABLE_PATCH"
    assert_output - <<EOF
$(cat "$RESULT")
1 out of 1 hunk FAILED
$(cat "$EXISTING")
EOF
    diff -y "$EXISTING" "$FILE"
}

@test "in-place patching all with good and non-applicable patch applies the good and fails because of the second" {
    run -4 updateWithPatch --all --in-place "$PATCH" "$UNAPPLICABLE_PATCH"
    assert_output '1 out of 1 hunk FAILED'
    diff -y "$FILE" "$RESULT"
}

@test "test-only patching all with good and non-applicable patch succeeds and prints error" {
    run -4 updateWithPatch --all --test-only "$PATCH" "$UNAPPLICABLE_PATCH"
    assert_output '1 out of 1 hunk FAILED'
    diff -y "$EXISTING" "$FILE"
}

@test "patching all with non-applicable and good patch prints the good result, error, and original" {
    run -4 updateWithPatch --all "$UNAPPLICABLE_PATCH" "$PATCH"
    assert_output - <<EOF
1 out of 1 hunk FAILED
$(cat "$EXISTING")
$(cat "$RESULT")
EOF
    diff -y "$EXISTING" "$FILE"
}

@test "in-place patching all with non-applicable and good patch applies the good and fails because of the first" {
    run -4 updateWithPatch --all --in-place "$UNAPPLICABLE_PATCH" "$PATCH"
    assert_output '1 out of 1 hunk FAILED'
    diff -y "$FILE" "$RESULT"
}

@test "test-only patching all with non-applicable and good patch succeeds and prints error" {
    run -4 updateWithPatch --all --test-only "$UNAPPLICABLE_PATCH" "$PATCH"
    assert_output '1 out of 1 hunk FAILED'
    diff -y "$EXISTING" "$FILE"
}
