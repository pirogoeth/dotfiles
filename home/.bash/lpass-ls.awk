BEGIN {
    section = ""
}

!match($0, /^    /) {
    # This is the password entry.
    split($0, pwnam, / \[/);
    if (!match(pwnam[1], /\/$/)) {
        print pwnam[1];
    }
}
