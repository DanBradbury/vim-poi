" Highlight points of intereset
let s:match_base = ':match poi '
au! VimEnter * execute(":autocmd InsertLeave * call <SID>MakeMatch()")
au! BufEnter * call <SID>MakeBuff()
highlight poi ctermbg=darkred guibg='#004f27' guifg='#ffcc00'

function! s:MakeBuff()
  if !exists('b:lines')
    let b:lines = []
  endif
endfunction

function! s:MakeMatch()
  let s:build_string = s:match_base
  let c = 0
  for i in b:lines
    let c += 1
    if c == 1
      let s:build_string = s:build_string.'/\%'.string(i).'l'
    else
      let s:build_string = s:build_string.'\%'.string(i).'l'
    endif
    if c == len(b:lines)
      let s:build_string = s:build_string.'/'
    else
      let s:build_string = s:build_string.'\|'
    endif
  endfor
  if c == 0
    let s:build_string = s:build_string.'//'
  endif
  execute s:build_string
endfunction

function! s:AddLine(...)
  if a:1 == 0
    let s:line_num = line('.')
  else
    let s:line_num = a:1
  endif
  let add = 1
  let dup_ind = 99
  let c = 0
  for i in b:lines
    if s:line_num == i
      let add = 0
      let dup_ind = c
    endif
    let c += 1
  endfor

  if add == 1
    let b:lines += [s:line_num]
  else
    if dup_ind != 99
      call remove(b:lines, dup_ind)
    endif
  endif
  call s:MakeMatch()
endfunction

function! s:AddRange(start, end)
  let start = a:start
  let end = a:end
  while start <= end
    call s:AddLine(eval(start))
    let start += 1
  endwhile
endfunction

function! s:ClearPoi()
  let b:lines = []
  call s:MakeMatch()
endfunction

com! -nargs=0 -range PoiLines :call <SID>AddRange(<line1>,<line2>)
com! -nargs=0 PoiLine :call <SID>AddLine(line('.'))
com! -nargs=0 PoiClear :call <SID>ClearPoi()

