if has('vim_starting')
  set nocompatible               " Be iMproved

  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" Add or remove your Bundles here:
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'Shougo/vimproc.vim', {
                        \ 'build' : {
                        \       'linux' : 'make',
                        \       'unix'  : 'gmake',
                        \ },
                        \ }
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'mbadran/headlights'
NeoBundle 'tpope/vim-vinegar'
NeoBundle 'fs111/pydoc.vim'
NeoBundle 'davidhalter/jedi-vim'
NeoBundle 'ervandew/supertab'
NeoBundle 'ekalinin/Dockerfile.vim'
NeoBundle 'spolu/dwm.vim'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'terryma/vim-multiple-cursors'
NeoBundle 'lepture/vim-jinja'
NeoBundle 'markcornick/vim-vagrant'

" Flat plugins, not from a repository.
NeoBundle 'noplaintext.vim', {
            \   'name' : 'noplaintext',
            \   'type' : 'raw',
            \   'script_type' : 'plugin'
            \ }

" You can specify revision/branch/tag.
NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }

" Required:
call neobundle#end()

" Required:
scriptencoding utf-8
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
" End NeoBundle Scripts-------------------------

let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ }

" General settings
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufEnter * set mouse=
syntax on
set encoding=utf-8
set expandtab tabstop=4 shiftwidth=4 softtabstop=4
set list
set listchars=tab:»-,trail:·,extends:»,precedes:«
set background=dark
set number
set encoding=utf8
set laststatus=2
set fillchars+=stl:\ ,stlnc:\
set incsearch
set ignorecase
set smartcase
set hlsearch
set t_Co=256 " Set the number of terminal colors

" Code folding settings
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=1

" Magical key bindings!
map <Leader>cdc :cd %:p:h<CR>
nmap \c :shell<CR>
nmap \l :setlocal number!<CR>
nmap \o :setlocal paste!<CR>:setlocal paste?<CR>
nmap \w :setlocal wrap!<CR>:setlocal wrap?<CR>
nmap \lB :setlocal background=light<CR>
nmap \dB :setlocal background=dark<CR>
nmap \A :w !sudo tee % &>/dev/null<CR>
nmap j gj
nmap k gk
nmap \q :nohlsearch<CR>
nmap <C-n> :bnext<CR>
nmap <C-p> :bprev<CR>
nmap \t :set expandtab tabstop=4 shiftwidth=4 softtabstop=4<CR>
nmap \T :set expandtab tabstop=8 shiftwidth=8 softtabstop=4<CR>
nmap \m :set expandtab tabstop=8 shiftwidth=2 softtabstop=2<CR>
nmap \M :set noexpandtab tabstop=8 softtabstop=4 shiftwidth=4<CR>
nmap d2u :update<CR>:e ++ff=dos<CR>:setlocal ff=unix<CR>:w<CR>
nmap u2d :update<CR>:e ++ff=unix<CR>:setlocal ff=dos<CR>:w<CR>
xmap <silent> mq :s/^/#/g<CR>:nohl<CR>
xmap <silent> muq :s/^#//g<CR>:nohl<CR>
cnoremap <C-g> <C-c>
nnoremap <C-a> ^
nnoremap <C-e> g_
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
vnoremap <silent> \db y:let @"=system('base64 -d', @")<CR>
vnoremap <silent> \eb y:let @"=system('base64 -e', @")<Bar>:let @"=substitute(strtrans(@"), '\^@', '', 'g')<CR>
vnoremap <silent> \idb y:let @"=system('base64 -d', @")<CR>gvP
vnoremap <silent> \ieb y:let @"=system('base64 -e', @")<Bar>:let @"=substitute(strtrans(@"), '\^@', '', 'g')<CR>gvP

" CtrlP settings
let g:ctrlp_map = '<Leader>t'
let g:ctrlp_match_window_bottom = 0
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_custom_ignore = '\v\~$|\.(o|swp|pyc|wav|mp3|ogg|blend)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])|__init__\.py'
let g:ctrlp_working_path_mode = 0
let g:ctrlp_dotfiles = 0
let g:ctrlp_switch_buffer = -1

" CtrlP open bindings
nmap <silent> ; :CtrlPBuffer<CR>
nnoremap <silent> <S-F> :CtrlP<CR>
nnoremap <silent> <S-M> :CtrlPMixed<CR>

" Pydoc settings
let g:pydoc_cmd = '/usr/local/bin/pydoc'
let g:pydoc_open_cmd = 'vsplit'

" Jedi settings
let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = "2"

" Syntastic bindings
nmap \S :SyntasticCheck<CR>
nmap \s :SyntasticToggleMode<CR>

" Custom DWM mapping and settings
let g:dwm_map_keys = 0

nmap <silent> <C-n> :call DWM_New()<CR>
nmap <silent> <C-w> :exec DWM_Close()<CR>
nmap <silent> <C-Space> :call DWM_Focus()<CR>
nmap <silent> <C-j> :call DWM_Rotate(0)<CR>
nmap <silent> <C-k> :call DWM_Rotate(1)<CR>
nmap <silent> <C-h> :call DWM_ShrinkMaster()<CR>
nmap <silent> <C-l> :call DWM_GrowMaster()<CR>

" vim-multiple-cursors mapping
let g:multi_cursor_use_default_mapping = 0
let g:multi_cursor_next_key = '<C-m>'
let g:multi_cursor_prev_key = '<S-P>'
let g:multi_cursor_skip_key = '<S-S>'
let g:multi_cursor_quit_key = '<Esc>'

" Open a unite file buffer instead of netrw
nnoremap <silent> - :Unite file buffer<CR>
