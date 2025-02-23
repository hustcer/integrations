
# List all available packages for Nushell
export def 'pkg list' [] {
  print $'(char nl)Available packages for Nushell@Gemfury:(char nl)'
  $env.config.table.mode = 'light'
  (fury list deb) ++ (fury list rpm) ++ (fury list alpine) | print
  print -n (char nl)
}

# Parse the fury list output to a table
export def 'fury list' [
  type: string,   # The package type, e.g. deb & rpm
] {
  fury versions $'($type):nushell' -a nushell
      | lines
      | skip 3
      | str join "\n"
      | detect columns
}
