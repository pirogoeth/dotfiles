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
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
" End NeoBundle Scripts-------------------------

let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ }

let g:dwm_map_keys = 0

" General settings
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufEnter * set mouse=
filetype plugin on
syntax on
set expandtab tabstop=4 shiftwidth=4 softtabstop=4
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
nmap \o :set paste!<CR>
nmap \A :w !sudo tee % &>/dev/null<CR>
nmap j gj
nmap k gk
nmap \q :nohlsearch<CR>
nmap <C-e> :e#<CR>
nmap <C-n> :bnext<CR>
nmap <C-p> :bprev<CR>
nmap \t :set expandtab tabstop=4 shiftwidth=4 softtabstop=4<CR>
nmap \T :set expandtab tabstop=8 shiftwidth=8 softtabstop=4<CR>
nmap \m :set expandtab tabstop=8 shiftwidth=2 softtabstop=2<CR>
nmap \M :set noexpandtab tabstop=8 softtabstop=4 shiftwidth=4<CR>
nmap \w :setlocal wrap!<CR>:setlocal wrap?<CR>
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-d> <Delete>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>
cnoremap <M-d> <S-right><Delete>
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>
cnoremap <Esc>d <S-right><Delete>
cnoremap <C-g> <C-c>
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

let g:ctrlp_map = '<Leader>t'
let g:ctrlp_match_window_bottom = 0
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_custom_ignore = '\v\~$|\.(o|swp|pyc|wav|mp3|ogg|blend)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])|__init__\.py'
let g:ctrlp_working_path_mode = 0
let g:ctrlp_dotfiles = 0
let g:ctrlp_switch_buffer = -1
let g:pydoc_cmd = '/usr/local/bin/pydoc'
let g:pydoc_open_cmd = 'vsplit'

" Syntastic bindings
nmap \S :SyntasticCheck<CR>
nmap \s :SyntasticToggleMode<CR>

" Custom DWM mapping
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

" CtrlP open bindings
nmap <silent> ; :CtrlPBuffer<CR>
nnoremap <silent> <S-F> :CtrlP<CR>
nnoremap <silent> <S-M> :CtrlPMixed<CR>