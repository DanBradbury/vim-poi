" Highlight points of interest
au! ColorScheme * call <SID>ExecuteHighlight()
au! BufEnter * call <SID>ExecuteHighlight()
au! BufWinEnter * call <SID>ExecuteHighlight()

" HIGHLIGHT COLOR INFORMATION
" for additional high contrasting colors refer to TABLE-1 in http://www.iscc.org/pdf/PC54_1724_001.pdf
" xterm 256 color chart: http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html
" helpful contrast comparison tool: http://leaverou.github.io/contrast-ratio
" red / white
let g:poi_color_count = 3
let g:poi_bg1 = 88
let g:poi_fg1 = 15
let g:g_poi_bg1 = "#870000"
let g:g_poi_fg1 = "#ffffff"
" yellow / purple
let g:poi_bg2 = 226
let g:poi_fg2 = 93
let g:g_poi_bg2 = "#ffff00"
let g:g_poi_fg2 = "#8700ff"
" orange / lightblue
let g:poi_bg3 = 208
let g:poi_fg3 = 17
let g:g_poi_bg3 = "#ff8700"
let g:g_poi_fg3 = "#00005f"

" will be necessary when implementing the preview functionality (for now its not used)
let g:pois = []

au! BufEnter * call <SID>MakeBuff()

function! s:ExecuteHighlight()
  "Deperately looking for any way to DRY this up..(figured it would be just like MakeBuff)
  execute 'highlight poi1 ctermbg='.g:poi_bg1.' ctermfg='.g:poi_fg1.' guibg='g:g_poi_bg1.' guifg='.g:g_poi_fg1
  execute 'highlight poi2 ctermbg='.g:poi_bg2.' ctermfg='.g:poi_fg2.' guibg='g:g_poi_bg2.' guifg='.g:g_poi_fg2
  execute 'highlight poi3 ctermbg='.g:poi_bg3.' ctermfg='.g:poi_fg3.' guibg='g:g_poi_bg3.' guifg='.g:g_poi_fg3
endfunction

function! s:MakeBuff()
  let start = 1
  while start <= g:poi_color_count
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
    call add(b:poi_lines1, {"line_num": a:line_num, "content": a:content, "match_id": a:match_id, "group": 1})
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

" PoiChange
function! s:ChangeHighlightType(num)
  let content = getline(a:num)
  let add = 0
  let c = 0

  for i in b:poi_lines1
    if a:num == i["line_num"]
      call matchdelete(i["match_id"])
      "should be refactored into a cleanup method
      let content = substitute(i["content"], '\', '\\%d92', "g")
      let content = substitute(content, '[', '\\%d91', "g")
      let content = substitute(content, ']', '\\%d93', "g")
      let content = substitute(content, '*', '\\%d42', "")
      let content = substitute(content, ')', '\\%d41', "")

      if i["group"] == g:poi_color_count
        let i["group"] = 1
      else
        let i["group"] += 1
      endif

      let new_match_id = eval(matchadd("poi".i["group"], '\%'.a:num.'l'.content))
      let i["match_id"] = new_match_id
      let add = 1
    endif
    let c += 1
  endfor
endfunction

" PoiRangeChange
function! s:ChangeRange(start, end)
  let start = a:start
  let end = a:end

  while start <= end
    call s:ChangeHighlightType(eval(start))
    let start += 1
  endwhile
endfunction

com! -nargs=0 PoiLine :call <SID>AddSingleLine(line('.'))
com! -nargs=0 -range PoiLines :call <SID>AddRange(<line1>,<line2>)
com! -nargs=0 PoiClear :call <SID>ClearPoi()
com! -nargs=0 PoiChange :call <SID>ChangeHighlightType(line('.'))
com! -nargs=0 -range PoiRangeChange :call <SID>ChangeRange(<line1>,<line2>)

