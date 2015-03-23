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

  for line in cage433utils#lines_in_current_buffer()
    if stridx(line, "scalatest.") >= 0
      return 1
    endif
  endfor
  return 0
endfunction

let g:show_test_exceptions=0
function! ToggleTestExceptions()
  let g:show_test_exceptions = !g:show_test_exceptions
endfunction
noremap <leader>sx :call ToggleTestExceptions()<CR>

function! RunFile(filename)
  let g:last_file_run=a:filename
  if IsScalaTestFile(a:filename) 
    if g:show_test_exceptions
      let test_reporter_arg = " -P5 -R . -oFHL " 
    else
      let test_reporter_arg = " -P5 -R . -oHL " 
    endif
    let fullclassname = scalaimports#file#scala_package().".".Basename(a:filename)
    let logbackfile="logback-vim.xml"
    exec "! clear; "
      \." $JAVA_HOME/bin/java"
      \." -classpath $CLASSPATH"
      \." -Xmx4000m"
      \." -Dlogback.configurationFile=" . logbackfile
      \." org.scalatest.tools.Runner " . test_reporter_arg
      \." -s " . fullclassname
  elseif IsScalaFile(a:filename)
    let fullclassname = scalaimports#file#scala_package().".".Basename(a:filename)
    exec "! clear; "
      \." $JAVA_HOME/bin/java"
      \." -classpath $CLASSPATH"
      \." -Xmx4000m "
      \.fullclassname

  elseif Extension(a:filename) == "py"
    exec    "!clear; "
          \." python ". fnameescape(a:filename)
  elseif Extension(a:filename) == "vim"
    exec "source ". fnameescape(a:filename)
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
