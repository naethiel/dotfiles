
" Sanity settings.
set backspace=indent,eol,start
set tabstop=2
set shiftwidth=2
set expandtab

" Plugins configuration
call plug#begin()

" Nerdtree and git extension
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
nnoremap <C-f> :NERDTreeTabsToggle<cr>
let NERDTreeIgnore = ['\.pyc$']

" Themes
" Plug 'joshdick/onedark.vim'
Plug 'drewtempelmeyer/palenight.vim'
" Language highlighting & stuff
" Plug 'sheerun/vim-polyglot'

" Javascript support
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
let g:jsx_ext_required = 0

" Linting
Plug 'w0rp/ale'
let g:ale_linters = {
\   'javascript': ['eslint', 'prettier'],
\   'react': ['eslint'],
\   'scss': ['prettier'],
\   'less': ['prettier']
\}

let g:ale_fixers = {
\    'javascript': ['eslint', 'prettier'],
\    'react': ['eslint'],
\    'scss': ['prettier'],
\    'less': ['prettier']
\}
let g:ale_fix_on_save = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 1

" Less, Scss and stuff
Plug 'lunaru/vim-less'
Plug 'cakebaker/scss-syntax.vim'

" Auto closing brackets because sanity
Plug 'jiangmiao/auto-pairs'

" Markdown extension
" Plug 'godlygeek/tabular'
" Plug 'plasticboy/vim-markdown'
" let g:vim_markdown_folding_disabled = 1
" nnoremap <C-t> :TableFormat<cr>


" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_theme = 'bubblegum'
let g:airline_powerline_fonts = 1




" End of plugin configuration
call plug#end()


" Color scheme
set termguicolors
set background=dark
color palenight
highlight Normal guibg=None
highlight NonText guibg=None
nnoremap <C-l> :nohlsearch<cr>

" Comfort
set cursorline                     " highlight the cursor line
" set cursorcolumn                   " highlight the cursor column
set number                         " line numbers
set ruler                          " always show cursor
set scrolloff=3                    " start scrolling three lines before horizontal border of window
set sidescrolloff=3                " start scrolling three columns before vertical border of window
" set list lcs=trail:.,tab:»\ ,eol:¶ " display whitespace chars
set hidden                         " only hide buffers when switch to a new file, so the undo history is still here

" Speed a little bit of things
set lazyredraw                     " vim can become awfully slow at times when redrawing screens with cursor lines or columns
set ttyfast

nnoremap <F8> :set  number! list!<cr>
nnoremap <F9> :set cursorline! cursorcolumn!<cr>
nnoremap <F10> :set wrap! <cr>

" If there is a .vimrc file in the local directory when opening, load it too.
" if filereadable(".vimrc")
"     so .vimrc
" endif

