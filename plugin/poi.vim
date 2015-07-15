" Highlight points of interest
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

" will be necessary when implementing the preview functionality (for now its not used)
let g:pois = []

au! BufEnter * call <SID>MakeBuff()

function! s:ExecuteHighlight()
  execute 'highlight poi1 ctermbg='.g:poi_bg1.' ctermfg='.g:poi_fg1.' guibg='g:g_poi_bg1.' guifg='.g:g_poi_fg1
endfunction

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

" general helper methods
function! s:AddToList(match_id, line_num, content)
  let dup_found = 0
  let dup_index = -1
  let c = 0
  let match_removal = -1

  for i in b:poi_lines1
    if i["line_num"] == a:line_num
      let dup_found = 1
      let dup_index = c
      let match_removal = i["match_id"]
    endif
    let c += 1
  endfor

  if dup_found == 1
    if dup_index != -1
      call remove(b:poi_lines1, dup_index)
      call matchdelete(match_removal)
      return -1
    endif
  else
    call add(b:poi_lines1, {"line_num": a:line_num, "content": a:content, "match_id": a:match_id})
    return 1
  endif
endfunction

" return the match_id to be used by matchdelete or -1000 if no dup is found
function! s:CheckList(line_num, content)
  let dup_found = 0
  let match_id = 0

  for i in b:poi_lines1
    if i["line_num"] == a:line_num
      let dup_found = 1
      let match_id = i["match_id"]
    endif
  endfor

  if dup_found == 1
    return match_id
  else
    return -1000
  endif
endfunction

" Poi Line
function! s:AddMatch(line, content)
  let value = eval(s:CheckList(a:line, a:content))
  if value != -1000
    call s:AddToList(value, a:line, a:content)
  else
    let content = substitute(a:content, '\', '\\%d92', "g")
    let content = substitute(content, '[', '\\%d91', "g")
    let content = substitute(content, ']', '\\%d93', "g")
    let content = substitute(content, '*', '\\%d42', "")
    let content = substitute(content, ')', '\\%d41', "")
    let temp = eval(matchadd("poi1", '\%'.a:line.'l'.content))
    call s:AddToList(temp, a:line, a:content)
  endif
endfunction

function! s:AddSingleLine(num)
  call s:AddMatch(a:num, getline(a:num))
endfunction

" Poi Lines
function! s:AddRange(start, end)
  let start = a:start
  let end = a:end
  "call s:AddToList(start, bufnr(''), getline(start))

  while start <= end
    call s:AddSingleLine(eval(start))
    let start += 1
  endwhile
endfunction

" Poi Clear
function! s:ClearPoi()
  for i in b:poi_lines1
    call matchdelete(i["match_id"])
  endfor
endfunction

com! -nargs=0 PoiLine :call <SID>AddSingleLine(line('.'))
com! -nargs=0 -range PoiLines :call <SID>AddRange(<line1>,<line2>)
com! -nargs=0 PoiClear :call <SID>ClearPoi()

