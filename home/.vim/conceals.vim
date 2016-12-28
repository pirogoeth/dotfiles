" -*- coding: utf-8 -*-
"
" conceals.vim - conceal settings for various languages
"
function! s:contains(l, m)
  let idx = index(a:l, a:m) != -1
  if idx < 0
    return 0
  else
    return 1
  endif
endfunction

function! g:LoadConcealRules()
  if s:contains(['python', 'ruby'], &filetype)
    syntax keyword multiLambda lambda conceal cchar=λ
    syntax keyword multiNot    not    conceal cchar=¬
  endif
endfunction
