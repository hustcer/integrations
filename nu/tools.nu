
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
export def 'yank version' [
  version: string,   # The version to yank, e.g. 0.102.0-1
  --force,           # Force yank the package without confirmation
] {
  let versions = $version | split row -
  let ver = $versions | first
  let rev = if ($versions | length) == 2 { $versions | get 1 | into int } else { 0 }
  if $rev >= 0 {
    fury-yank deb $'($ver)-($rev)' --force=$force
    fury-yank rpm $'($ver)-($rev)' --force=$force
    fury-yank alpine $'($ver)-r($rev)' --force=$force
    return
  }
  fury-yank deb $ver --force=$force
  fury-yank rpm $ver --force=$force
  fury-yank alpine $ver --force=$force
}

def fury-yank [
  type: string,     # The package type, e.g. deb & rpm
  version: string,  # The version to yank, e.g. 0.102.0-1
  --force,          # Force yank the package without confirmation
] {
  if not $force {
    fury yank $'($type):nushell' -v $version -a nushell
    return
  }
  fury yank $'($type):nushell' -v $version -a nushell --force
}
