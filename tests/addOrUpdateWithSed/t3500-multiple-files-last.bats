#!/usr/bin/env bats

load temp

@test "update in first file skips last file program and following files" {
    addOrUpdateWithSed --in-place --last-file $'$a\\\nnew=got added' --last-file '$q' $SED_UPDATE -- "$FILE" "$FILE2" "$FILE3"
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

@test "update with no modification runs last file program on the last file" {
    run -0 addOrUpdateWithSed --in-place --last-file $'$a\\\nnew=got added' --last-file '$q' $SED_NO_MOD -- "$FILE" "$FILE2" "$FILE3"
    diff -y "$FILE" "$INPUT"
    diff -y "$FILE2" "$MORE2"
    diff -y - --label expected "$FILE3" <<'EOF'
zulu=here
foo=bar
foo=no bar baz
new=got added
EOF
}

@test "update all with no modification runs last file program on all files" {
    run -0 addOrUpdateWithSed --all --in-place --last-file $'$a\\\nnew=got added' --last-file '$q' $SED_NO_MOD -- "$FILE" "$FILE2" "$FILE3"
    diff -y - --label expected "$FILE" <<'EOF'
sing/e=wha\ever
foo=bar
foo=hoo bar baz
# SECTION
foo=hi
new=got added
EOF
    diff -y - --label expected "$FILE2" <<'EOF'
foo=bar
quux=initial
foo=moo bar baz
new=got added
EOF
    diff -y - --label expected "$FILE3" <<'EOF'
zulu=here
foo=bar
foo=no bar baz
new=got added
EOF
}
