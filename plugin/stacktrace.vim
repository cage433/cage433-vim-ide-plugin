let s:stack_trace_file = "maker-test-output.txt"
let s:test_output_file_time = 0


function! BasenameAndLineNo(linetext)
  let matches = filter(
        \matchlist(a:linetext, '(\([A-Za-z0-9]\+.scala\):\(.*\))'),
        \'v:val != ""')
  let file_basename = get(matches, 1)
  let lineno = get(matches, 2)
  return [file_basename, lineno]
endfunction

function! HaveBufferOpen(bufname)
  return bufexists(bufnr(a:bufname))
endfunction

function! OpenBufferInSplitWindow(bufname, use_lower)
  call SplitScreenIfNecessary()

  if a:use_lower
    exe "normal \<c-w>j"
  else
    exe "normal \<c-w>k"
  endif

  if HaveBufferOpen(a:bufname)
    exe "buffer ".a:bufname
  else
    exe "vi **/".a:bufname
  endif

endfunction

function! OpenStackTraceInLowerWindow()
  let new_buffer = 0
  if HaveBufferOpen(s:stack_trace_file) && s:test_output_file_time != getftime(s:stack_trace_file) 
    exe "bw ".s:stack_trace_file
    let s:test_output_file_time = getftime(s:stack_trace_file)
    let new_buffer = 1
  endif
  call OpenBufferInSplitWindow(s:stack_trace_file, 1)
  return new_buffer
endfunction


function! OpenErrorAtLine()
  let [file_basename, lineno] = BasenameAndLineNo(getline("."))
  call OpenBufferInSplitWindow(file_basename, 0)
  exe "normal ".lineno."G"
  exe "normal z."
endfunction

function! MoveToLineInStackTrace(forward)
  echo "stack file "s:stack_trace_file
  let new_buffer = OpenStackTraceInLowerWindow()
  if ! new_buffer
    if a:forward
      exe "normal j0"
    else
      exe "normal k$"
    endif
  endif
  exe "redraw!"

  if search("at com.freetrm", a:forward ? "W" : "Wb")
    call OpenErrorAtLine()
  else
    echoerr "No more freetrm lines"
  endif
  exe "redraw!"
endfunction


nnoremap <leader>sn :silent :call MoveToLineInStackTrace(1)<cr>
nnoremap <leader>sp :silent :call MoveToLineInStackTrace(0)<cr>
nnoremap <leader>ss :silent :call OpenErrorAtLine()<cr>

"call OpenStackTraceInLowerWindow()
"exe "normal j0"
"let nextline = search("at com.freetrm", "e")
"if nextline
  "echo "line is now ".nextline
  "let s:stack_trace_line_no = nextline
  "let [file_basename, lineno] = BasenameAndLineNo(getline("."))
  "echo "file basename "file_basename
  "call OpenBufferInSplitWindow(file_basename, 0)
  "exe "normal ".lineno."G"
  "exe "normal z."
"else
  "echoerr "No more freetrm lines"
"endif



"redir END
"let output = copy(@")

"if empty(output)
  "echoerr "no output"
"else
  "new
 "setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
  "put! =output
  "exe "normal \<c-j>"
"endif
