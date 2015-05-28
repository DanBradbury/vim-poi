" Highlight points of interest
let s:match_base = ':match poi1 '
let s:match_base2 = ':2match poi2 '
let s:match_base3 = ':3match poi3 '
au! VimEnter * execute ":autocmd InsertLeave * call <SID>LineMatch1()"
au! VimEnter * execute ":autocmd InsertLeave * call <SID>CleanupCrew()"
au! ColorScheme * call <SID>ExecuteHighlight()
au! BufEnter * call <SID>ExecuteHighlight()
au! BufWinEnter * call <SID>ExecuteHighlight()
au! CursorHold * call <SID>CleanupCrew()
au! CursorMoved * call <SID>CleanupCrew()
au! CursorMovedI * call <SID>CleanupCrew()

au! BufEnter * call <SID>MakeBuff()
let matches  = 0
while matches <= 2
  let matches += 1
  au! CursorHold * call <SID>LineMatch{matches}()
  au! CursorMoved * call <SID>LineMatch{matches}()
  au! CursorMovedI * call <SID>LineMatch{matches}()
endwhile

" for additional high contrasting colors refer to TABLE-1 in http://www.iscc.org/pdf/PC54_1724_001.pdf
" red / white
let g:poi_bg1 = 88
let g:poi_fg1 = 15
let g:g_poi_bg1 = "#870000"
let g:g_poi_fg1 = "#ffffff"
" yellow/purple
let g:poi_bg2 = 226
let g:poi_fg2 = 93
let g:g_poi_bg2 = "#ffff00"
let g:g_poi_fg2 = "#8700ff"
" organe/lightblue
let g:poi_bg3 = 208
let g:poi_fg3 = 17
let g:g_poi_bg3 = "#ff8700"
let g:g_poi_fg3 = "#00005f"

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
  let start = 1
  let end = 3
  while start <= end
    if !exists('b:poi_lines'.start)
      let b:poi_lines{start} = []
    endif
    let start += 1
  endwhile
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
  let dup_found = 0
  let dup_index = -1
  let dup_list = 0

  "check for dups across all lists
  let c = 0
  for i in b:poi_lines1
    if s:line_num == i["line_num"]
      let dup_found = 1
      let dup_index = c
      let dup_list = 1
    endif
    let c += 1
  endfor

  if dup_found == 0
    let c = 0
    for i in b:poi_lines2
      if s:line_num == i["line_num"]
        let dup_found = 1
        let dup_index = c
        let dup_list = 2
      endif
      let c += 1
    endfor
  endif

  if dup_found == 0
    let c = 0
    for i in b:poi_lines3
      if s:line_num == i["line_num"]
        let dup_found = 1
        let dup_index = c
        let dup_list = 3
      endif
      let c += 1
    endfor
  endif

  "check if we have found a duplicate across all lists
  if dup_found == 1
    if dup_index != -1
      "remove from the appropriate list
      if dup_list == 1
        call remove(b:poi_lines1, dup_index)
      elseif dup_list == 2
        call remove(b:poi_lines2, dup_index)
      elseif dup_list == 3
        call remove(b:poi_lines3, dup_index)
      endif
    endif
  else
    "just go ahead and add the the first list
    let line_content = escape(getline(s:line_num), '\/[]')
    let safe_string = substitute(line_content, '^\ *', '\1', '')
    call add(b:poi_lines1, {"line_num":s:line_num, "content":safe_string})
  endif
  call s:LineMatch1()
  call s:LineMatch2()
  call s:LineMatch3()
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

function! s:ChangeRange(start, end)
  let start = a:start
  let end = a:end

  while start <= end
    call s:ChangeHighlightType(eval(start))
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
  execute 'highlight poi1 ctermbg='.g:poi_bg1.' ctermfg='.g:poi_fg1.' guibg='g:g_poi_bg1.' guifg='.g:g_poi_fg1
  execute 'highlight poi2 ctermbg='.g:poi_bg2.' ctermfg='.g:poi_fg2.' guibg='g:g_poi_bg2.' guifg='.g:g_poi_fg2
  execute 'highlight poi3 ctermbg='.g:poi_bg3.' ctermfg='.g:poi_fg3.' guibg='g:g_poi_bg3.' guifg='.g:g_poi_fg3
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

function! s:CleanupCrew()
  for l in [b:poi_lines1, b:poi_lines2, b:poi_lines3]
    for i in l
      norm gg0
      execute('/\M'.i['content'])
      let cur_line = line('.')
      let @/ = ""
      let i["line_num"] = cur_line
    endfor
  endfor
  call s:LineMatch1()
  call s:LineMatch2()
  call s:LineMatch3()
endfunction

com! -nargs=0 -range PoiLines :call <SID>AddRange(<line1>,<line2>)
com! -nargs=0 PoiLine :call <SID>AddSingleLine(line('.'))
com! -nargs=0 PoiClear :call <SID>ClearPoi()
com! -nargs=0 PoiPreview :call <SID>CreateQuickfix()
vnoremap <Leader>hs "-y :PoiWord<CR>
com! -nargs=0 PoiWord :call <SID>EchoWord(line('.'))
com! -nargs=0 PoiHelp :call <SID>PoiHelpQuickFix()
com! -nargs=0 PoiChange :call <SID>ChangeHighlightType(line('.'))
com! -nargs=0 -range PoiRangeChange :call <SID>ChangeRange(<line1>,<line2>)

