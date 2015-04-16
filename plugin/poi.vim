" Highlight points of intereset
let g:match_base=':match poi '
let g:lines=[]
au! VimEnter * execute(":autocmd InsertLeave * call <SID>MakeMatch()")
highlight poi ctermbg=darkred guibg='#004f27' guifg='#ffcc00'

function! s:MakeMatch()
  let g:build_string=g:match_base
  let c=0
  for i in g:lines
    let c+=1
    if c==1
      let g:build_string=g:build_string.'/\%'.string(i).'l'
    else
      let g:build_string=g:build_string.'\%'.string(i).'l'
    endif
    if c==len(g:lines)
      let g:build_string=g:build_string.'/'
    else
      let g:build_string=g:build_string.'\|'
    endif
  endfor
  if c==0
    let g:build_string=g:build_string.'//'
  endif
  if hlexists("poi")==1
    execute g:build_string
  endif
endfunction

function! s:AddLine(...)
  if a:1==0
    let g:line_num = line('.')
  else
    let g:line_num = a:1
  endif
  let add=1
  let dup_ind=99
  let c=0
  for i in g:lines
    if g:line_num == i
      let add=0
      let dup_ind=c
    endif
    let c+=1
  endfor

  if add==1
    let g:lines+=[g:line_num]
  else
    if dup_ind!=99
      call remove(g:lines, dup_ind)
    endif
  endif
  call s:MakeMatch()
endfunction

function! s:AddRange() range
  let start=a:firstline
  let end=a:lastline
  while start<=end
    call s:AddLine(eval(start))
    let start+=1
  endwhile
endfunction

vmap <Leader>h :call <SID>AddRange()<CR>
nmap <Leader>h :call <SID>AddLine(line('.'))<CR>

