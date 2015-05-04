" Highlight points of intereset
let s:match_base = ':match poi '
au! VimEnter * execute ":autocmd InsertLeave * call <SID>MakeMatch()"
au! ColorScheme * execute 'highlight poi ctermbg='.s:c_bg.' ctermfg='.s:c_fg.' guibg='s:g_bg.' guifg='.s:g_fg
au! BufEnter * execute 'highlight poi ctermbg='.s:c_bg.' ctermfg='.s:c_fg.' guibg='s:g_bg.' guifg='.s:g_fg
au! BufWinEnter * execute 'highlight poi ctermbg='.s:c_bg.' ctermfg='.s:c_fg.' guibg='s:g_bg.' guifg='.s:g_fg
au! BufEnter * call <SID>MakeBuff()
au! CursorHold * call <SID>MakeMatch()
au! CursorMoved * call <SID>MakeMatch()
au! CursorMovedI * call <SID>MakeMatch()

let s:c_bg = 'red'
let s:c_fg = 'white'
let s:g_bg = '#fce122'
let s:g_fg = '#18453b'

" {'line':num, 'bufnum':num, 'content':text}
let g:pois = []

if exists('g:poi_colors')
  if len(g:poi_colors) == 2
    let s:c_bg = g:poi_colors[0]
    let s:c_fg = g:poi_colors[1]
  elseif len(g:poi_colors) == 1
    let s:c_bg = g:poi_colors[0]
  elseif len(g:poi_colors) == 4
    let s:c_bg = g:poi_colors[0]
    let s:c_fg = g:poi_colors[1]
    let s:g_bg = g:poi_colors[2]
    let s:g_fg = g:poi_colors[3]
  else
    echo "You've provided an invalid g:poi_higlight_colors"
  endif
endif

execute 'highlight poi ctermbg='.s:c_bg.' ctermfg='.s:c_fg.' guibg='s:g_bg.' guifg='.s:g_fg

function! s:MakeBuff()
  if !exists('b:lines')
    let b:lines = []
  endif
endfunction

function! s:MakeMatch()
  if exists('b:lines')
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
  endif
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

function! s:AddSingleLine(num)
  call s:AddToList(a:num, bufnr(''), getline(a:num))
  call s:AddLine(a:num)
endfunction

function! s:AddRange(start, end)
  let start = a:start
  let end = a:end
  call s:AddToList(start, bufnr(''), getline(start))
  while start <= end
    call s:AddLine(eval(start))
    let start += 1
  endwhile
endfunction

function! s:AddToList(line, bufnum, content)
  let dup_found = 0
  let pois_copy = []
  "check if the element already exists
  for l in g:pois
    if l['line'] == a:line && l['bufnum'] == a:bufnum
      let dup_found = 1
    else
      call add(pois_copy, l)
    endif
  endfor
  if dup_found == 0
    call add(pois_copy, {'line':a:line, 'bufnum':a:bufnum, 'content':a:content})
  endif
  let g:pois = pois_copy
endfunction

function! s:ClearPoi()
  call s:CleanQuickfix(bufnr(''))
  let b:lines = []
  call s:MakeMatch()
endfunction

function! s:CleanQuickfix(bufnum)
  let new = []
  for i in g:pois 
    if i['bufnum'] != a:bufnum
      call add(new, i)
    endif
  endfor
  let g:pois = new
endfunction

function! s:CreateQuickfix()
  call setqflist([])
  if len(g:pois) == 0
    call setqflist([{'text':"NOTHING TO SEE HERE..NO POINTS OF INTEREST HAVE BEEN HIGHLIGHTED!"}])
  else
    call setqflist([{'text':"CREATED POINTS OF INTEREST"}], 'a')
    for i in g:pois
      call setqflist([{'bufnr': i['bufnum'], 'lnum': i['line'], 'text': i['content']}], 'a')
    endfor
  endif
  copen
endfunction


com! -nargs=0 -range PoiLines :call <SID>AddRange(<line1>,<line2>)
com! -nargs=0 PoiLine :call <SID>AddSingleLine(line('.'))
com! -nargs=0 PoiClear :call <SID>ClearPoi()
com! -nargs=0 PoiPreview :call <SID>CreateQuickfix()

