if &compatible
  set nocompatible               " Be iMproved
endif

if has('vim_starting')
  set encoding=utf-8
  set t_Co=256 " Set the number of terminal colors
endif

set runtimepath^=~/.vim/bundle/dein.vim/

" Required:
call dein#begin(expand('~/.vim/bundle'))

" Dein options
let g:dein#enable_notification = 1
let g:dein#install_progress_type = "tabline"

" Let dein manage dein
" Required:
call dein#add('Shougo/dein.vim')

" Add or remove your Bundles here:
call dein#add('Shougo/neosnippet.vim')
call dein#add('Shougo/neosnippet-snippets')
call dein#add('Shougo/vimshell')
call dein#add('Shougo/unite.vim')
call dein#add('ctrlpvim/ctrlp.vim')
call dein#add('flazz/vim-colorschemes')
call dein#add('Shougo/vimproc.vim', {'build': 'make'})
call dein#add('altercation/vim-colors-solarized')
call dein#add('scrooloose/syntastic')
call dein#add('tpope/vim-vinegar')
call dein#add('fs111/pydoc.vim')
call dein#add('ekalinin/Dockerfile.vim')
call dein#add('spolu/dwm.vim')
call dein#add('vim-airline/vim-airline')
call dein#add('vim-airline/vim-airline-themes')
call dein#add('terryma/vim-multiple-cursors')
call dein#add('lepture/vim-jinja')
call dein#add('markcornick/vim-vagrant')
call dein#add('pearofducks/ansible-vim')
call dein#add('Shougo/echodoc.vim')
call dein#add('xolox/vim-misc')
call dein#add('xolox/vim-lua-ftplugin')
call dein#add('mtth/scratch.vim')
call dein#add('mileszs/ack.vim')

" Neovim-specific plugins
call dein#add('airblade/vim-gitgutter', {"if": has("nvim")})
call dein#add('Shougo/deoplete.nvim', {"if": has("nvim") && has("python3")})
call dein#add('zchee/deoplete-jedi', {"if": has("nvim") && has("python3")})
call dein#add('zchee/deoplete-go', {"if": has("nvim"), "build": "make"})
call dein#add('pirogoeth/deoplete-clang', {"if": has("nvim")})
call dein#add('carlitux/deoplete-ternjs', {"if": has("nvim")})
call dein#add('hkupty/nvimux', {"if": has("nvim")})

" Vim-original-specific plugins
call dein#add('davidhalter/jedi-vim', {"if": !has("nvim")})
call dein#add('ConradIrwin/vim-bracketed-paste', {"if": !has("nvim")})

" Flat plugins, not from a repository.
call dein#local(expand('~/.vim/bundle/noplaintext.vim'), {'type': 'raw', 'script_type': 'plugin'})

" Required:
call dein#end()

if dein#check_install()
  call dein#install()
endif

" Required:
scriptencoding utf-8
filetype plugin indent on

" Airline settings
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'wombat'
let g:airline_powerline_fonts = 0
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_symbols.space = "\ua0"

" General settings
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufEnter * set mouse=
autocmd FileType java setlocal omnifunc=javacomplete#Complete
syntax on

set expandtab tabstop=4 shiftwidth=4 softtabstop=4
set list
set listchars=tab:»-,trail:·,extends:»,precedes:«
set background=dark
set number
set laststatus=2
set fillchars+=stl:\ ,stlnc:\
set incsearch
set ignorecase
set smartcase
set hlsearch
set hidden

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
nmap <C-c> <Esc>
cnoremap <C-g> <C-c>

" tab-styling modes
nmap \t :set expandtab tabstop=4 shiftwidth=4 softtabstop=4<CR>
nmap \T :set expandtab tabstop=8 shiftwidth=8 softtabstop=4<CR>
nmap \TM :set noexpandtab tabstop=4 shiftwidth=4 softtabstop=4<CR>
nmap \m :set expandtab tabstop=8 shiftwidth=2 softtabstop=2<CR>
nmap \M :set noexpandtab tabstop=8 softtabstop=4 shiftwidth=4<CR>

" convert all line endings / switch file type
nmap d2u :update<CR>:e ++ff=dos<CR>:setlocal ff=unix<CR>:w<CR>
nmap u2d :update<CR>:e ++ff=unix<CR>:setlocal ff=dos<CR>:w<CR>

" block comment and uncomment
xmap <silent> mq :s/^/#/g<CR>:nohl<CR>
xmap <silent> muq :s/^#//g<CR>:nohl<CR>
" let g:commentchar = "#"
" xmap <silent> mq :execute "'<,'>s/^/".g:commentchar."/g<CR>:nohl<CR>"
" xmap <silent> muq :execute "'<,'>s/^".g:commentchar."//g<CR>:nohl<CR>"

" eat all free-standing whitespace on empty lines
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" clipboard & inline base64 string manipulation
vnoremap <silent> \db y:let @"=system('base64 -d', @")<CR>
vnoremap <silent> \eb y:let @"=system('base64 -e', @")<Bar>:let @"=substitute(strtrans(@"), '\^@', '', 'g')<CR>
vnoremap <silent> \idb y:let @"=system('base64 -d', @")<CR>gvP
vnoremap <silent> \ieb y:let @"=system('base64 -e', @")<Bar>:let @"=substitute(strtrans(@"), '\^@', '', 'g')<CR>gvP

" mappings for location pane
nnoremap <silent> \ol :lopen<CR>
nnoremap <silent> \cl :lclose<CR>

" CtrlP settings
let g:ctrlp_map = '<Leader>p'
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

" Syntastic bindings
nmap <silent> \S :SyntasticCheck<CR>
nmap <silent> \s :SyntasticToggleMode<CR>

" Syntastic settings
let g:syntastic_check_on_open = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1

" Pydoc settings
let g:pydoc_cmd = '/usr/local/bin/pydoc'
let g:pydoc_open_cmd = 'vsplit'

" Custom DWM mapping and settings
let g:dwm_map_keys = 0

nmap <silent> <C-i> :call DWM_New()<CR>
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

" Enable deoplete!
if has("nvim") && has("python3")
  " deoplete.nvim + completion settings -- do config before enabling
  let g:deoplete#enable_at_startup = 1
  let g:deoplete#omni#functions_lua = 'xolox#lua#completefunc'
  let g:deoplete#sources#go#gocode_binary = expand("~/.go/bin/gocode")
  let g:deoplete#sources#go#cgo = 1
  let g:deoplete#sources#go#cgo#libclang_path = '/usr/lib/llvm-3.8/lib/libclang.so.1'
  let g:deoplete#sources#clang#libclang_path = '/usr/lib/llvm-3.8/lib/libclang.so.1'
  let g:deoplete#sources#clang#clang_header = '/usr/lib/clang/3.8/include'
  let g:deoplete#sources#clang#std = {'c': 'c11', 'cpp': 'c++1z', 'objc': 'c11', 'objcpp': 'c++1z'}

  call deoplete#enable()
endif

" Set up ack.vim for ag, if available
if executable('ag')
  let g:ackprg = 'ag --nogroup --nocolor --column'
endif
" nmap <silent> <S-A> 

" Nvimux settings
let g:nvimux_prefix = '<C-b>'

" Lua filetype settings
let g:lua_check_syntax = 0
let g:lua_complete_omni = 1
let g:lua_complete_dynamic = 0
let g:lua_define_completion_mappings = 0

" Scratchpad settings
let g:scratch_autohide = 1
let g:scratch_persistent_file = expand('~/.vim/scratch')
