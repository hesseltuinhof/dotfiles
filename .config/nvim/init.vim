" >> Plugins Management <<

" install vimplug if not installed
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

" load plugins
call plug#begin('~/.local/share/nvim/plugged')
Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
Plug 'tpope/vim-fugitive'
Plug 'w0rp/ale'
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'preservim/nerdtree'

" language specific
Plug 'lervag/vimtex'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'zchee/deoplete-jedi'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" themes
Plug 'freeo/vim-kalisi'
Plug 'gkapfham/vim-vitamin-onec'
Plug 'dracula/vim', { 'as': 'dracula' }

call plug#end()

" >> Theme <<

" set colorscheme -> chriskempson.github.io/base16
set termguicolors
colorscheme dracula

" >> Basic Settings <<

" minimal working config
set number relativenumber       " Show hybrid line numbers
set linebreak                   " Break lines at word (requires Wrap lines)
set showbreak=+++               " Wrap-broken line prefix
set textwidth=120               " Line wrap (number of cols)
set showmatch                   " Highlight matching brace
set visualbell                  " Use visual bell (no beeping)

set hlsearch                    " Highlight all search results
set smartcase                   " Enable smart-case search
set ignorecase                  " Always case-insensitive
set incsearch                   " Searches for strings incrementally

set autoindent                  " Auto-indent new lines
"set smartindent                " Enable smart-indent

set expandtab                   " Use spaces instead of tabs
set tabstop=4                   " Ensure files with tabs look the same
set shiftwidth=4                " Number of auto-indent spaces
set softtabstop=-1              " Number of spaces per <Tab> (use value of sw)
set smarttab                    " Enable smart-tabs (<Tab> will always use sw)

set ruler                       " Show row and column ruler information

set undolevels=1000             " Number of undo levels
set backspace=indent,eol,start  " Backspace behaviour

set mouse=a                     " Allow to set pointer pos with mouse

" additional config
set noshowmode                  " Hide insert status
set autowriteall                " Save files when opening new files
filetype plugin indent on       " Enable filetype detection and load its settings
syntax on                       " Enable syntax highlighting

let g:python3_host_prog = expand('$HOME/.pyenv/versions/neovim/bin/python')

" various file formats
autocmd FileType go setlocal noet ts=4 sw=4
autocmd FileType sh setlocal et ts=2 sw=2 tw=100

" toggle number modes (normal mode = relative, other modes = absolute)
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" >> Keymaps <<
let mapleader = "\<Space>"      " Set leader key

nnoremap ; :

nmap <leader>j :bnext<CR>
nmap <leader>k :bprevious<CR>

vmap <leader>y "+y

nmap <leader>b :ALEFix<CR>

nmap <leader>n :NERDTreeToggle<CR>
nmap <leader>m :NERDTreeFind<CR>

" disable highlighting search results
nnoremap <silent> <leader>/ :nohlsearch<CR><C-L>


" >> Plugin Settings <<

""" julia-vim

" disable Latex-to-Unicode tab completion in cmd-line mode
let g:latex_to_unicode_cmd_mapping = 0

""" deoplete
let g:deoplete#enable_at_startup=1

call deoplete#custom#option({
    \ 'max_list': 30,
    \})
" tab-completion
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" completion for tex
call deoplete#custom#var('omni', 'input_patterns', {
    \ 'tex': g:vimtex#re#deoplete
    \})

set completeopt-=preview

""" vimtex
let g:tex_flavor = 'latex'
let g:vimtex_compiler_progname= 'nvr'
let g:vimtex_view_method = 'zathura'
let g:vimtex_latexmk_options = '-verbose -file-line-error -interaction=nonstopmode -synctex=1 -pvc'
let g:vimtex_mappings_enabled = 0
let g:vimtex_fold_enabled = 0
let g:vimtex_fold_env = 0
let g:vimtex_indent_enabled = 1
let g:vimtex_quickfix_latexlog = {'fix_paths':0}

nmap <leader>l :VimtexCompile<CR>
nmap <leader>v :VimtexView<CR>

""" vim-go
call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })

""" lightline
let g:lightline = {
    \ 'colorscheme': 'default',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'filename', 'modified', 'readonly'  ] ],
    \   'right': [ [ 'linter_errors', 'linter_warnings', 'linter_ok', 'linter_infos', 'linter_warnings' ],
    \              [ 'lineinfo' ],
    \              [ 'percent' ],
    \              [ 'fileformat', 'fileencoding', 'filetype'  ],]
    \ },
    \ 'component': {
    \   'readonly': '%{&readonly?"":""}',
    \},
    \ 'component_function': {
    \   'gitbranch': 'FugitiveHead'
    \ },
    \ 'component_expand': {
    \   'linter_checking': 'lightline#ale#checking',
    \   'linter_infos': 'lightline#ale#infos',
    \   'linter_warnings': 'lightline#ale#warnings',
    \   'linter_errors': 'lightline#ale#errors',
    \   'linter_ok': 'lightline#ale#ok',
    \ },
    \ 'component_type': {
    \   'readonly': 'error',
    \   'linter_infos': 'right',
    \   'linter_checking': 'right',
    \   'linter_warnings': 'warning',
    \   'linter_errors': 'error',
    \ },
    \ }

""" ale

" specify fixers
" TODO: Think about putting language specific stuff to ftplugin/python.vim e.g.
" see also: https://codeinthehole.com/tips/using-black-and-isort-with-vim/
let g:ale_fixers = {
    \ '*': ['remove_trailing_lines', 'trim_whitespace'],
    \ 'python': ['isort', 'yapf']
    \ }
" only run fixers on keymap
let b:ale_fix_on_save = 0
"
" specify linters
let g:ale_linters = {
    \ 'python': ['flake8', 'mypy'],
    \ 'go': ['gofmt', 'golint', 'go vet'],
    \ 'sh': ['shellcheck'],
    \ }
let g:ale_pattern_options = {
\   '.*\.tex$': {'ale_enabled': 0},
\   '.*\.cls$': {'ale_enabled': 0},
\}

" only run specified linters
let g:ale_linters_explicit = 1


" keymaps
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" other options
let g:ale_lint_on_text_changed = 'always'
let g:ale_lint_on_enter = 1

""" lightline-ale (requires Font Awesome)
let g:lightline#ale#indicator_checking = "\uf110 " " 
let g:lightline#ale#indicator_infos = "\uf129 " " 
let g:lightline#ale#indicator_warnings = "\uf071  " " 
let g:lightline#ale#indicator_errors = "\uf05e " " 
let g:lightline#ale#indicator_ok = "\uf00c " " 
