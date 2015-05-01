" Highlight points of intereset
let s:match_base = ':match poi '
au! VimEnter * execute ":autocmd InsertLeave * call <SID>MakeMatch()"
au! ColorScheme * execute 'highlight poi ctermbg='.s:c_bg.' ctermfg='.s:c_fg.' guibg='s:g_bg.' guifg='.s:g_fg
au! BufEnter * call <SID>MakeBuff()
au! CursorHold * call <SID>MakeMatch()
au! CursorMoved * call <SID>MakeMatch()
au! CursorMovedI * call <SID>MakeMatch()

"let b:original = []
let g:changes = []

"au! InsertEnter * call <SID>SaveOriginal()
"au! InsertLeave * call <SID>SaveChanges()
au! CursorMoved * call <SID>CheckContents()

let s:c_bg = 'red'
let s:c_fg = 'white'
let s:g_bg = '#fce122'
let s:g_fg = '#18453b'

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

function! s:CheckContents()
  if exists('b:original')
    let cur_buf = getline(1,'$')
    if cur_buf==b:original
      echo "nothing has changed"
    else
      echo "something has changed?"
      let num = 0
      let mismatched_line = 0
      if len(cur_buf) > len(b:original)
        for line in b:original
          if line != cur_buf[num]
            if mismatched_line == 0
              let mismatched_line = num+1
            endif
          endif
          let num += 1
        endfor
      endif
      "echo mismatched_line
      echo b:original[mismatched_line-2]
    endif
  endif
endfunction

function! s:SaveOriginal()
  let g:original = getline(1, '$')
endfunction

function! s:SaveChanges()
  let g:changes = getline(1, '$')
  let g:no_matches = -1
  let first_not_found = -1
  let line_num = 0
  let change_diff = len(g:changes)-len(g:original)
  "if changes lines > original lines
  " check to see where the additional lines are
  for line in g:original
    echo line
    "if line != g:changes[line_num]
      ""let first_not_found = 1
      ""necessary to increment by 1 for the actual line number
      "let g:no_matches = line_num + 1
    "endif
    "let line_num = line_num + 1
  endfor
  " check against highlighted lines stored for the current buffer
  " update as needed
  "elsif changes < original
  " find where lines have been removed
  " update highlighted lines accordings
  " ( we are storing the the 'orinal' buffers highlight locations )
  " update as needed

  "get difference
  "for line in g:original
    "if line == g:changes[line_num]
      ""echo g:changes[line_num]
      ""echo 'exact match found'
      "let exact_match = 1
    "else
      "let exact_match = -1
    "endif

    "let line_num += 1
    "let found_index = index(g:changes, line)
    ""not found
    "if found_index == -1 && first_not_found == -1 && exact_match == -1
      "let first_not_found = line_num
    "endif

    "if first_not_found == -1 && exact_match == -1
      "let first_not_found = line_num
    "endif
  "endfor
  "echo first_not_found
endfunction

function! s:MakeBuff()
  if !exists('b:lines')
    let b:lines = []
  endif
  if !exists('b:original')
    let b:original = getline(1, '$')
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

