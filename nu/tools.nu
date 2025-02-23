
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

# Yank the specified version of Nushell packages
export def 'yank version' [version: string] {
  let versions = $version | split row -
  let ver = $versions | first
  let rev = if ($versions | length) == 2 { $versions | get 1 | into int } else { 0 }
  if $rev > 0 {
    fury yank deb:nushell -v $'($ver)-($rev)' -a nushell
    fury yank rpm:nushell -v $'($ver)-($rev)' -a nushell
    fury yank alpine:nushell -v $'($ver)-r($rev)' -a nushell
    return
  }
  fury yank deb:nushell -v $ver -a nushell
  fury yank rpm:nushell -v $ver -a nushell
  fury yank alpine:nushell -v $ver -a nushell
}
