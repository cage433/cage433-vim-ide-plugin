function! Extension(filename)
  return fnamemodify(a:filename, ':e')
endfunction

function! Basename(filename)
  return fnamemodify(a:filename, ':t:r')
endfunction

function! IsScalaFile(filename)
  return Extension(a:filename) == "scala"
endfunction

function! IsScalaTestFile(filename)
  if !IsScalaFile(a:filename)
    return 0
  endif

  for line in readfile(a:filename)
    if stridx(line, "scalatest.") >= 0
      return 1
    endif
  endfor
  return 0
endfunction

let g:show_test_exceptions = 0
function! ToggleTestExceptions()
  let g:show_test_exceptions = !g:show_test_exceptions
endfunction
noremap <leader>sx :call ToggleTestExceptions()<CR>

let g:verbose_gc = 0
function! ToggleVerboseGC()
  let g:verbose_gc = !g:verbose_gc
endfunction
noremap <leader>sg :call ToggleVerboseGC()<CR>

let s:package_regex='\v^package\s+(.*)$'
function! ScalaPackage(filename)
  let lines = readfile(a:filename)
  let package_line = cage433utils#find(
    \ lines,
    \ "_ =~ '".s:package_regex."'")
  if empty(package_line)
    throw "No package for file ". a:filename
  endif

  return matchlist(package_line[0], s:package_regex)[1]
endfunction

function! ReadClasspath()
  return readfile("maker-classpath.txt")[0]
endfunction

function! RunFile(filename)
  let g:last_file_run=a:filename
  if g:verbose_gc
    let verbose_gc_arg = " -verbose:gc "
  else
    let verbose_gc_arg = ""
  endif
  if IsScalaTestFile(a:filename) 
    if g:show_test_exceptions
      let test_reporter_arg = " -P -R . -oFHL " 
    else
      let test_reporter_arg = " -P -R . -oHL " 
    endif
    let fullclassname = ScalaPackage(a:filename).".".Basename(a:filename)
    let classpath = ReadClasspath()
    let logbackfile="logback-vim.xml"

    echom "! clear; "
      \." $JAVA_HOME/bin/java "
      \." -classpath \"" . classpath . "\""
      \." -Xmx8000m "
      \." -Dlogback.configurationFile=" . logbackfile
      \.verbose_gc_arg
      \." org.scalatest.tools.Runner " . test_reporter_arg
      \." -s " . fullclassname 
      \." 2>&1 | tee maker-test-output.txt"
    exec "! clear; "
      \." $JAVA_HOME/bin/java "
      \." -classpath \"" . classpath . "\""
      \." -Xmx8000m "
      \." -Dlogback.configurationFile=" . logbackfile
      \.verbose_gc_arg
      \." org.scalatest.tools.Runner " . test_reporter_arg
      \." -s " . fullclassname 
      \." 2>&1 | tee maker-test-output.txt"
  elseif IsScalaFile(a:filename)
    let fullclassname = ScalaPackage(a:filename).".".Basename(a:filename)
    let classpath = ReadClasspath()
    exec "! clear; "
      \." $JAVA_HOME/bin/java"
      \." -Dlogback.configurationFile=logback-vim.xml"
      \." -classpath \"" . classpath . "\""
      \." -Xmx8g "
      \.verbose_gc_arg
      \.fullclassname


  elseif Extension(a:filename) == "py"
    exec    "!clear; "
          \." python ". fnameescape(a:filename)
  elseif Extension(a:filename) == "rb"
    exec    "!clear; "
          \." ruby ". fnameescape(a:filename)
  elseif Extension(a:filename) == "jl"
    exec    "!clear; "
          \." julia ". fnameescape(a:filename)
  elseif Extension(a:filename) == "vim" 
    exec "source ". fnameescape(a:filename)
  elseif Extension(a:filename) == "sh"
    exec "!source ". fnameescape(a:filename)
  else
    echo "Is not test file"
  endif
endfunction

function! RunLastFile()
  call RunFile(g:last_file_run)
endfunction

nnoremap <leader>k :exe ":call RunFile('". expand("%") ."')"<CR>
nnoremap <leader>j :exe ":call RunLastFile()"<CR>

function! SaveWinline()
  let g:currentwinline = winline()
endfunction
" Stops the buffer jumping around when adding imports
function! RestoreWinline()
  while winline() > g:currentwinline
    exec "normal \<C-e>"
  endwhile
  while winline() < g:currentwinline
    exec "normal \<C-y>"
  endwhile
endfunction
