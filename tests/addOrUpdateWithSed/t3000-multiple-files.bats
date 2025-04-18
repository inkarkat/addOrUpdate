#!/usr/bin/env bats

load temp

@test "update in first file skips following files" {
    addOrUpdateWithSed --in-place $SED_UPDATE -- "$FILE" "$FILE2" "$FILE3"
    diff -y - --label expected "$FILE" <<'EOF'
updated
foo=bar
foo=hoo bar baz
# SECTION
foo=hi
EOF
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}

@test "update in second file skips previous and following files" {
    addOrUpdateWithSed --in-place -e '/^\(quux\|zulu\)=/{ h; s/=.*/=updated/ }' -e '${ x; /^$/{ x; q99 }; x }' -- "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y - --label expected "$FILE2" <<'EOF'
foo=bar
quux=updated
foo=moo bar baz
EOF
    diff -y "$FILE3" "$MORE3"
}

@test "alternative update in second file skips previous and following files" {
    addOrUpdateWithSed --in-place -e 's/^quux=.*/quux=updated/; T end; h' -e ':end' -e '${ x; /^$/{ x; q99 }; x }' -- "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y - --label expected "$FILE2" <<'EOF'
foo=bar
quux=updated
foo=moo bar baz
EOF
    diff -y "$FILE3" "$MORE3"
}

@test "update with no modification in all files keeps contents and returns 99" {
    run -99 addOrUpdateWithSed --in-place $SED_NO_MOD -- "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}
