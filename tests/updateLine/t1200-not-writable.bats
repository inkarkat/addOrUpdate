#!/usr/bin/env bats

@test "updating not-writable existing file returns 5" {
    IMMUTABLE='/etc/hosts'
    [ -e "$IMMUTABLE" -a ! -w "$IMMUTABLE" ]
    run updateLine --in-place --update-match root --replacement '&&' "$IMMUTABLE"
    [ $status -eq 5 ]
    [ "${#lines[@]}" -eq 1 ]
    [[ "$output" =~ ^sed: ]]
}

