ignore = {
    '.luacheckrc',
    '614', -- Trailing whitespace in a comment.
    '631', -- Line is too long.
}
stds.CPK = {
    globals = { 'CPK', 'CPK_VERBOSE' }
}
stds.CIV = {
    globals = { 'Locale', 'include', 'StateName' }
}
std = 'min+CPK+CIV'