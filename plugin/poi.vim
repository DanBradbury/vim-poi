" Highlight points of interest
let s:match_base = ':match poi1 '
let s:match_base2 = ':2match poi2 '
let s:match_base3 = ':3match poi3 '
au! VimEnter * execute ":autocmd InsertLeave * call <SID>LineMatch1()"
" ALL HIGHLIGHTING RELATED CODE
" will need to be ripped out to support different presets
au! ColorScheme * call <SID>ExecuteHighlight()
au! BufEnter * call <SID>ExecuteHighlight()
au! BufWinEnter * call <SID>ExecuteHighlight()

au! BufEnter * call <SID>MakeBuff()
au! CursorHold * call <SID>LineMatch1()
au! CursorMoved * call <SID>LineMatch1()
au! CursorMovedI * call <SID>LineMatch1()

au! CursorHold * call <SID>LineMatch2()
au! CursorMoved * call <SID>LineMatch2()
au! CursorMovedI * call <SID>LineMatch2()

au! CursorHold * call <SID>LineMatch3()
au! CursorMoved * call <SID>LineMatch3()
au! CursorMovedI * call <SID>LineMatch3()

"for additional high contrasting colors refer to TABLE-1 in http://www.iscc.org/pdf/PC54_1724_001.pdf
let g:contrast_poi = [ ['white', 'black'], [226,129], [214,20], [196,227] ]
let g:current_poi = 0
" red / lightyellow
let g:poi_bg1 = 196
let g:poi_fg1 = 227
" yellow/purple
let g:poi_bg2 = 226
let g:poi_fg2 = 129
" organe/lightblue
let g:poi_bg3 = 214
let g:poi_fg3 = 20

let s:g_bg = '#fce122'
let s:g_fg = '#18453b'

" { 'line': num, 'bufnum': num, 'content': text }
let g:pois = []

if exists('g:poi_colors')
  if len(g:poi_colors) == 2
    let g:poi_bg1 = g:poi_colors[0]
    let g:poi_fg1 = g:poi_colors[1]
  elseif len(g:poi_colors) == 1
    let g:poi_bg1 = g:poi_colors[0]
  elseif len(g:poi_colors) == 4
    let g:poi_bg1 = g:poi_colors[0]
    let g:poi_fg1 = g:poi_colors[1]
    let s:g_bg = g:poi_colors[2]
    let s:g_fg = g:poi_colors[3]
  else
    echo "You've provided an invalid g:poi_highlight_colors"
  endif
endif

function! s:MakeBuff()
  if !exists('b:poi_lines1')
    let b:poi_lines1 = []
  endif
  "DRY this shit up!
  if !exists('b:poi_lines2')
    let b:poi_lines2 = []
  endif

  if !exists('b:poi_lines3')
    let b:poi_lines3 = []
  endif
endfunction

function! s:LineMatch1()
  if exists('b:poi_lines1')
    let s:build_string = s:match_base
    let c = 0
    for i in b:poi_lines1
      let c += 1
      if c == 1
        let s:build_string = s:build_string.'/\%'.string(i["line_num"]).'l\&\M'.i["content"]
      else
        let s:build_string = s:build_string.'\%'.string(i["line_num"]).'l\&\M'.i["content"]
      endif
      if c == len(b:poi_lines1)
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

function! s:LineMatch2()
  if exists('b:poi_lines2')
    let s:build_string = s:match_base2
    let c = 0
    for i in b:poi_lines2
      let c += 1
      if c == 1
        let s:build_string = s:build_string.'/\%'.string(i["line_num"]).'l\&\M'.i["content"]
      else
        let s:build_string = s:build_string.'\%'.string(i["line_num"]).'l\&\M'.i["content"]
      endif
      if c == len(b:poi_lines2)
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

function! s:LineMatch3()
  if exists('b:poi_lines3')
    let s:build_string = s:match_base3
    let c = 0
    for i in b:poi_lines3
      let c += 1
      if c == 1
        let s:build_string = s:build_string.'/\%'.string(i["line_num"]).'l\&\M'.i["content"]
      else
        let s:build_string = s:build_string.'\%'.string(i["line_num"]).'l\&\M'.i["content"]
      endif
      if c == len(b:poi_lines3)
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

  for i in b:poi_lines1
    if s:line_num == i["line_num"]
      let add = 0
      let dup_ind = c
    endif
    let c += 1
  endfor

  if add == 1
    let line_content = escape(getline(s:line_num), '\/[]')
    let safe_string = substitute(line_content, '^\ *', '\1', '')
    call add(b:poi_lines1, {"line_num":s:line_num, "content":safe_string})
  else
    if dup_ind != 99
      call remove(b:poi_lines1, dup_ind)
    endif
  endif
  call s:LineMatch1()
endfunction

function! s:AddSelection(num, text)
  call s:AddToList(a:num, bufnr(''), a:text)
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
    call add(pois_copy, { 'line': a:line, 'bufnum': a:bufnum, 'content': a:content })
  endif
  let g:pois = pois_copy
endfunction

function! s:ClearPoi()
  call s:CleanQuickfix(bufnr(''))
  let b:poi_lines1 = []
  let b:poi_lines2 = []
  let b:poi_lines3 = []
  call s:LineMatch1()
  call s:LineMatch2()
  call s:LineMatch3()
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
    call setqflist([{ 'text': "NOTHING TO SEE HERE..NO POINTS OF INTEREST HAVE BEEN HIGHLIGHTED!" }])
  else
    call setqflist([{ 'text': "CREATED POINTS OF INTEREST" }], 'a')
    for i in g:pois
      call setqflist([{ 'bufnr': i['bufnum'], 'lnum': i['line'], 'text': i['content'] }], 'a')
    endfor
  endif
  copen
endfunction

function! s:EchoWord(current_line)
  let g:bs = @-
  "call modified addline (with content, line_num)
  "addLine(g:bs,a:current_line)
  norm gv
endfunction

function! s:PoiHelpQuickFix()
  let help_commands = []
  let s:readme = globpath(&runtimepath, '*/vim-poi/README.md')
  let s:file_name = split(s:readme, "/")[-1]

  for line in readfile(s:readme, '', 33)
    if line =~ 'nnoremap' || line =~ 'vnoremap'
      call add(help_commands, { 'file_name': s:file_name, 'command': line })
    endif
  endfor

  call setqflist([])
  for i in help_commands
    call setqflist([{ 'filename': i['file_name'], 'text': i['command'] }], 'a')
  endfor
  copen
endfunction

function! s:ExecuteHighlight()
  "TODO: update entire gui section
  execute 'highlight poi3 ctermbg='.g:poi_bg3.' ctermfg='.g:poi_fg3.' guibg='s:g_bg.' guifg='.s:g_fg
  execute 'highlight poi1 ctermbg='.g:poi_bg1.' ctermfg='.g:poi_fg1.' guibg='s:g_bg.' guifg='.s:g_fg
  execute 'highlight poi2 ctermbg='.g:poi_bg2.' ctermfg='.g:poi_fg2.' guibg='s:g_bg.' guifg='.s:g_fg
  "will require an additional highlight group
endfunction

function! s:ChangeDefaultHighlight()
  let g:current_poi += 1
  if g:current_poi == len(g:contrast_poi)
    let g:current_poi = 0
  endif
  let g:poi_bg1 = g:contrast_poi[g:current_poi][0]
  let g:poi_fg1 = g:contrast_poi[g:current_poi][1]
  call <SID>ExecuteHighlight()
endfunction

function! s:ChangeHighlightType(num)
  let add = 0
  "check if the highlight exists in the first group
  let c = 0
  for i in b:poi_lines1
    if a:num == i["line_num"]
      call add(b:poi_lines2, i)
      call remove(b:poi_lines1, c)
      let add = 1
      call <SID>LineMatch2()
    endif
    let c += 1
  endfor

  "do the same for the second group
  if add == 0
    let c = 0
    for i in b:poi_lines2
      if a:num == i["line_num"]
        call add(b:poi_lines3, i)
        call remove(b:poi_lines2, c)
        let add = 1
        call <SID>LineMatch3()
      endif
      let c += 1
    endfor
  endif

  "and finally with the third group
  if add == 0
    let c = 0
    for i in b:poi_lines3
      if a:num == i["line_num"]
        call add(b:poi_lines1, i)
        call remove(b:poi_lines3, c)
        let add = 1
        call <SID>LineMatch1()
      endif
      let c += 1
    endfor
  endif
endfunction

com! -nargs=0 -range PoiLines :call <SID>AddRange(<line1>,<line2>)
com! -nargs=0 PoiLine :call <SID>AddSingleLine(line('.'))
com! -nargs=0 PoiClear :call <SID>ClearPoi()
com! -nargs=0 PoiPreview :call <SID>CreateQuickfix()
vnoremap <Leader>hs "-y :PoiWord<CR>
com! -nargs=0 PoiWord :call <SID>EchoWord(line('.'))
com! -nargs=0 PoiHelp :call <SID>PoiHelpQuickFix()
"new undocumented commands
"TODO: add documentation + remove comments
"com! -nargs=0 PoiChange :call <SID>ChangeDefaultHighlight()
com! -nargs=0 PoiChange :call <SID>ChangeHighlightType(line('.'))
"will need a command for adding a range..

