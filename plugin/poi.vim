" Highlight points of interest
let s:match_base1  = ':match poi1 '
au! ColorScheme * call <SID>ExecuteHighlight()
au! BufEnter * call <SID>ExecuteHighlight()
au! BufWinEnter * call <SID>ExecuteHighlight()

" HIGHLIGHT COLOR INFORMATION
" for additional high contrasting colors refer to TABLE-1 in http://www.iscc.org/pdf/PC54_1724_001.pdf
" xterm 256 color chart: http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html
" helpful contrast comparison tool: http://leaverou.github.io/contrast-ratio
" red / white
let g:poi_bg1 = 88
let g:poi_fg1 = 15
let g:g_poi_bg1 = "#870000"
let g:g_poi_fg1 = "#ffffff"

let g:pois = []

au! BufEnter * call <SID>MakeBuff()

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

function! s:ExecuteHighlight()
  execute 'highlight poi1 ctermbg='.g:poi_bg1.' ctermfg='.g:poi_fg1.' guibg='g:g_poi_bg1.' guifg='.g:g_poi_fg1
endfunction

function! s:LineMatch(group)
  if exists("b:poi_lines".a:group)
    let s:build_string = s:match_base{a:group}
    let c = 0
    for i in b:poi_lines{a:group}
      let c += 1
      if c == 1
        let s:build_string = s:build_string.'/\%'.string(i["line_num"]).'l\&\M'.i["content"]
      else
        let s:build_string = s:build_string.'\%'.string(i["line_num"]).'l\&\M'.i["content"]
      endif
      if c == len(b:poi_lines{a:group})
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


" Poi Line

function! s:AddLine(...)
  if a:1 == 0
    let s:line_num = line('.')
  else
    let s:line_num = a:1
  endif
  let dup_found = 0
  let dup_index = -1
  " will prove usefull when implementing with multiple lists
  let dup_list = 0

  " check for dups across all lists
  let c = 0
  for i in b:poi_lines1
    if s:line_num == i["line_num"]
      let dup_found = 1
      let dup_index = c
      let dup_list = 1
    endif
    let c += 1
  endfor

  " check if we have found a duplicate across all lists
  if dup_found == 1
    if dup_index != -1
      " remove from the appropriate list
      call remove(b:poi_lines1, dup_index)
    endif
  else
    " just go ahead and add the the first list
    let line_content = escape(getline(s:line_num), '\/[]')
    let safe_string = substitute(line_content, '^\ *', '\1', '')
    call add(b:poi_lines1, {"line_num":s:line_num, "content":safe_string})
  endif
  call s:LineMatch(1)
endfunction

" Adds the line(s) selection to the global pois var (checks for dups)
function! s:AddToList(line, bufnum, content)
  let dup_found = 0
  let pois_copy = []

  " check if the element already exists
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
  " all that bs for this..
  let g:pois = pois_copy
endfunction

function! s:AddSingleLine(num)
  call s:AddToList(a:num, bufnr(''), getline(a:num))
  call s:AddLine(a:num)
endfunction

com! -nargs=0 PoiLine :call <SID>AddSingleLine(line('.'))

