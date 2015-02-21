function! Extension()
  return expand('%:e')
endfunction

function! Basename()
  return expand('%:t:r')
endfunction

function! IsScalaFile()
  return Extension() == "scala"
endfunction

function! IsScalaTestFile()
  if !IsScalaFile()
    return 0
  endif

  for line in cage433utils#lines_in_current_buffer()
    if stridx(line, "scalatest.") >= 0
      return 1
    endif
  endfor
  return 0
endfunction

function! RunFile()
  if IsScalaTestFile() 
    let test_reporter_arg = " -P5 -R . -oHL " 
    let fullclassname = scalaimports#file#scala_package().".".Basename()
    let logbackfile="logback-vim.xml"
    exec "! clear; "
      \." $JAVA_HOME/bin/java"
      \." -classpath $CLASSPATH"
      \." -Xmx4000m"
      \." -Dlogback.configurationFile=" . logbackfile
      \." org.scalatest.tools.Runner " . test_reporter_arg
      \." -s " . fullclassname
  else
    echo "Is not test file"
  endif
endfunction

nnoremap <leader>k :exec ":call RunFile()"<CR>

