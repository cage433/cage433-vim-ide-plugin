function! IgnoreAllTests()
  exec "%s/ in {/ ignore {/|norm!``"
endfunction

function! PutBackAllTests()
  exec "%s/ ignore {/ in {/|norm!``"
endfunction

function! PutBackCurrentTest()
  norm! mZ
  if search("ignore {", "Wb")
    exec "s/ ignore {/ in {"
    norm! `Z
  else
    echoerr "No test found"
  endif
endfunction

function! FocusOnCurrentTest()
  call IgnoreAllTests()
  call PutBackCurrentTest()
endfunction

nnoremap <leader>ii :call FocusOnCurrentTest()<cr>
nnoremap <leader>iu :call PutBackAllTests()<cr>
