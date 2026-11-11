def log-status [message: string] {
  print -e $message
}

def valid-name [name: string] {
  $name == '00 Math Conversations with LLMs' or $name =~ '^(\d{2,} )?\d{2}-\d{2} .+$'
}

def unnumbered-name [name: string] {
  if $name == '00 Math Conversations with LLMs' { return $name }
  $name | str replace -r '^\d{2,} ' ''
}

def name-date [name: string] {
  unnumbered-name $name | str substring 0..4
}

def is-powerpoint-lock-file [file: string] {
  $file | path basename | str starts-with '~$'
}

def export-pdf [file: string, output: string] {
  log-status $"Exporting: ($file)"
  let result = (^osascript
    -e 'on run argv'
    -e 'set sourceFile to (POSIX file (item 1 of argv)) as alias'
    -e 'set pdfPath to (POSIX file (item 2 of argv)) as text'
    -e 'tell application "Microsoft PowerPoint"'
    -e 'open sourceFile'
    -e 'save active presentation in pdfPath as save as PDF'
    -e 'close active presentation saving no'
    -e 'end tell'
    -e 'end run'
    ($file | path expand) ($output | path expand) | complete)
  if $result.exit_code != 0 {
    log-status $"Export failed: ($file)"
    return false
  }
  if not ($output | path exists) {
    log-status $"Export produced no PDF: ($file)"
    return false
  }
  if (ls $output | get 0.size) == 0 {
    log-status $"Export produced no PDF: ($file)"
    return false
  }
  true
}

def trim-pdf [file: string] {
  let ink = (^gs -q -o - -sDEVICE=inkcov $file | complete)
  if $ink.exit_code != 0 {
    log-status $"Could not measure ink: ($file)"
    return false
  }
  let rows = ($ink.stdout
    | lines
    | parse --regex '^\s*(?<c>\S+)\s+(?<m>\S+)\s+(?<y>\S+)\s+(?<k>\S+)\s+CMYK\s+OK\s*$')
  if ($rows | is-empty) {
    log-status $"Could not measure ink: ($file)"
    return false
  }
  let count = (^qpdf --show-npages $file | complete)
  let pages_text = ($count.stdout | str trim)
  if $count.exit_code != 0 or $pages_text !~ '^\d+$' {
    log-status $"Could not count pages: ($file)"
    return false
  }
  let pages = ($pages_text | into int)
  if ($rows | length) != $pages {
    log-status $"Could not measure every page: ($file)"
    return false
  }
  let empty = ($rows
    | reverse
    | take while { |row|
        [$row.c $row.m $row.y $row.k] | all { |ink| ($ink | into float) < 0.0005 }
      }
    | length)
  let keep = ($pages - $empty)
  if $keep < 1 {
    log-status $"No nonempty pages: ($file)"
    return false
  }

  if $empty == 0 { return true }
  log-status $"Removing ($empty) trailing pages: ($file)"
  let temp = (^mktemp ($env.PWD | path join '.pdf-trim.XXXXXXXX.pdf') | complete)
  if $temp.exit_code != 0 {
    log-status $"Could not create temporary PDF: ($file)"
    return false
  }
  let trimmed = ($temp.stdout | str trim)
  let result = (^qpdf --warning-exit-0 --empty --pages $file $"1-($keep)" -- $trimmed | complete)
  if $result.exit_code != 0 {
    rm -f $trimmed
    log-status $"Trim failed: ($file)"
    return false
  }
  let check = (^qpdf --check $trimmed | complete)
  if $check.exit_code != 0 {
    rm -f $trimmed
    log-status $"Trim failed: ($file)"
    return false
  }
  let move = (^mv -f -- $trimmed $file | complete)
  if $move.exit_code != 0 {
    rm -f $trimmed
    log-status $"Trim failed: ($file)"
    return false
  }
  log-status $"Saved: ($file)"
  true
}

def collect-name [source: string, reserved: list<string>] {
  let filename = ($source | path basename)
  let old_name = ($source | path parse | get stem)
  mut name = (unnumbered-name $old_name)
  loop {
    if (valid-name $name) {
      if $name not-in $reserved { return $name }
      log-status $"Name already used: ($name).pptx"
    }
    let answer = (try {
      input $"MM-DD Topic for ($filename): "
    } catch { null })
    if $answer == null or ($answer | str trim | is-empty) {
      error make { msg: $"No name provided: ($filename)" }
    }
    $name = (unnumbered-name ($answer | str trim | str replace -r '\.pptx$' ''))
  }
}

def process-pptx [source: string, name: string] {
  let old_name = ($source | path parse | get stem)
  mut file = $source
  if $name != $old_name {
    let renamed = $"pptx/($name).pptx"
    let move = (^mv -- $file $renamed | complete)
    if $move.exit_code != 0 {
      log-status $"Rename failed: ($file)"
      return 'error'
    }
    $file = $renamed
    log-status $"Renamed: ($file)"
  }
  let output = $"($name).pdf"
  if ($output | path exists) { return 'skip' }
  if (export-pdf $file $output) and (trim-pdf $output) { return 'ok' }
  rm -f $output
  'error'
}

def main [] {
  if not ('pptx' | path exists) { mkdir pptx }
  mut failures = 0
  mut skipped = 0
  for file in (glob --no-dir './*.pptx') {
    if (is-powerpoint-lock-file $file) { continue }
    let target = ('pptx' | path join ($file | path basename))
    if ($target | path exists) {
      log-status $"Cannot move, already exists: ($target)"
      $failures += 1
      continue
    }
    let move = (^mv -- $file $target | complete)
    if $move.exit_code == 0 {
      log-status $"Moved: ($target)"
    } else {
      log-status $"Move failed: ($file)"
      $failures += 1
    }
  }
  # Gather every name before renaming presentations or starting PowerPoint.
  mut plans = []
  mut reserved = []
  for file in (glob --no-dir 'pptx/*.pptx' | sort) {
    if (is-powerpoint-lock-file $file) { continue }
    let name = (collect-name $file $reserved)
    $reserved = ($reserved | append $name)
    $plans = ($plans | append { source: $file, name: $name })
  }

  mut next = 1
  mut numbered = []
  let pdfs = (glob --no-dir './*.pdf')
  mut matched_pdfs = []
  for plan in ($plans | sort-by name) {
    mut name = $plan.name
    if $name != '00 Math Conversations with LLMs' {
      let prefix = ($next | into string | fill -a right -c '0' -w 2)
      $name = $"($prefix) ($name)"
      $next += 1
    }
    let matches = ($pdfs | where { |pdf|
      let stem = ($pdf | path parse | get stem)
      if $plan.name == '00 Math Conversations with LLMs' {
        $stem == $plan.name
      } else {
        (valid-name $stem) and ((name-date $stem) == (name-date $plan.name))
      }
    })
    if ($matches | length) > 1 {
      error make { msg: $"Multiple PDFs match date for: ($name)" }
    }
    let pdf = ($matches | get -o 0)
    if $pdf != null {
      if $pdf in $matched_pdfs {
        error make { msg: $"Multiple presentations match PDF: ($pdf)" }
      }
      $matched_pdfs = ($matched_pdfs | append $pdf)
    }
    $numbered = ($numbered | append { source: $plan.source, name: $name, pdf: $pdf })
  }
  # Check all destinations before making any naming changes.
  for plan in $numbered {
    let target = $"pptx/($plan.name).pptx"
    if ($target | path exists) and (($target | path expand) != ($plan.source | path expand)) {
      error make { msg: $"Cannot rename, already exists: ($target)" }
    }
  }
  for plan in $numbered {
    if $plan.pdf != null {
      let target = $"($plan.name).pdf"
      if ($plan.pdf | path expand) != ($target | path expand) {
        if ($target | path exists) {
          error make { msg: $"Cannot rename, already exists: ($target)" }
        }
        mv $plan.pdf $target
        log-status $"Renamed: ($target)"
      }
    }
  }
  for plan in $numbered {
    let result = (process-pptx $plan.source $plan.name)
    if $result == 'skip' { $skipped += 1 } else if $result == 'error' { $failures += 1 }
  }
  if $skipped > 0 { log-status $"Skipping ($skipped) existing pdfs" }
  if $failures > 0 { exit 1 }
}
