" -*- coding: utf-8 -*-
"
" conceals.vim - conceal settings for various languages
"
function! s:contains(l, m)
  let idx = index(a:l, a:m)
  if idx < 0
    return 0
  else
    return 1
  endif
endfunction

function! g:LoadConcealRules()
  let s:conceal_rules_active = 0

  " [[[[[[[[==== BEGIN CONCEAL RULES

  if s:contains(['python', 'ruby'], &filetype)
    syntax keyword    niceKeyword     lambda    conceal cchar=λ
    syntax keyword    niceOperator    not       conceal cchar=¬
    syntax keyword    niceOperator    in        conceal cchar=∈
    syntax match      niceOperator    /not in/  conceal cchar=∉

    let s:conceal_rules_active = 1
  endif

  if s:contains(['ruby'], &filetype)
    syntax match      niceStatement   /|| [[{][\]}]/        conceal cchar=?
    syntax match      niceStatement   /|| \(false\|true\)/  conceal cchar=?
    syntax match      niceStatement   /PP\.pp/              conceal cchar=@

    let s:conceal_rules_active = 1
  endif

  " ]]]]]]]]==== END CONCEAL RULES

  if s:conceal_rules_active == 1
    hi link niceKeyword   Keyword
    hi link niceOperator  Operator
    hi link niceStatement Statement
  endif

  hi! link Conceal Operator
  hi! link Conceal Statement
  hi! link Conceal Keyword
endfunction
