#!/usr/bin/env bats

load temp

@test "update all updates all files" {
    addOrUpdateWithSed --all --in-place $SED_UPDATE -- "$FILE" "$FILE2" "$FILE3"
    diff -y - --label expected "$FILE" <<'EOF'
updated
foo=bar
foo=hoo bar baz
# SECTION
foo=hi
EOF
    diff -y - --label expected "$FILE2" <<'EOF'
updated
quux=initial
foo=moo bar baz
EOF
    diff -y - --label expected "$FILE3" <<'EOF'
updated
foo=bar
foo=no bar baz
EOF
}

@test "update all with match in second and third files" {
    addOrUpdateWithSed --all --in-place -e '/^\(quux\|zulu\)=/{ h; s/=.*/=updated/ }' -e '${ x; /^$/{ x; q99 }; x }' -- "$FILE" "$FILE2" "$FILE3"
    diff -y "$INPUT" "$FILE"
    diff -y - --label expected "$FILE2" <<'EOF'
foo=bar
quux=updated
foo=moo bar baz
EOF
    diff -y - --label expected "$FILE3" <<'EOF'
zulu=updated
foo=bar
foo=no bar baz
EOF
}

@test "update all with no modification in all files keeps contents and returns 99" {
    run -99 addOrUpdateWithSed --all --in-place $SED_NO_MOD -- "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y "$FILE3" "$MORE3"
}

