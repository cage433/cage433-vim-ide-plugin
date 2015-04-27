function! ToggleSourceAndTestFile()
  let otherfile = TestOrSourceFile()
  if (CreateSourceDirectory(otherfile))
    if filereadable(otherfile) || input("Create file ".otherfile."? [y/N] ") == 'y'
      exec ":vi " . otherfile
    endif
  endif
endfunction

function! TestOrSourceFile()
  if stridx(expand("%"), "Tests.scala") == -1 && stridx(expand("%"), "Test.scala") == -1
    " Then this is not a test file - corresponding test could
    " end in 'Tests.scala' or 'Test.scala'. If either exists then return that
    " one
    let testDir = substitute(expand("%:r"), "src\/", "tests/", "")
    let testFile1 = testDir . "Test.scala" 
    let testFile2 = testDir . "Tests.scala" 
    if filereadable(testFile1)
      return testFile1
    else
      return testFile2
    endif
  else 
    " This must be a test file - remove Test(s) from its name
    let otherfile = substitute(expand("%"), "tests\/", "src/", "")
    let otherfile =  substitute(otherfile, "Tests\\.", ".", "")
    return substitute(otherfile, "Test\\.", ".", "")
  endif
endfunction

function! CreateSourceDirectory(sourceFile)
  let dir = fnamemodify(a:sourceFile, ":h")
  if !isdirectory(dir) && input("Make directory ".dir."? [y/N] ") == 'y'
    execute ':silent !mkdir -p '.dir
  endif
  return isdirectory(dir)
endfunction

noremap <silent><leader>tt :call ToggleSourceAndTestFile()<CR>
