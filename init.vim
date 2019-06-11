
" Sanity settings.
set backspace=indent,eol,start
set tabstop=2
set shiftwidth=2
set expandtab
let mapleader=","
" Plugins configuration
call plug#begin()

" Nerdtree and git extension
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
nnoremap <C-b> :NERDTreeTabsToggle<cr>
let NERDTreeIgnore = ['\.pyc$']

" Themes
Plug 'joshdick/onedark.vim'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'arcticicestudio/nord-vim'
" Language highlighting & stuff
" Plug 'sheerun/vim-polyglot'

" Javascript support
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
let g:jsx_ext_required = 0

" Less, Scss and stuff
Plug 'lunaru/vim-less'
Plug 'cakebaker/scss-syntax.vim'

" Auto closing brackets because sanity
Plug 'jiangmiao/auto-pairs'

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_theme = 'nord'
let g:airline_powerline_fonts = 1

" Fuzzy universal finder
Plug 'junegunn/fzf' 
Plug 'junegunn/fzf.vim'
nmap <C-p> :GFiles<CR>
nmap <Leader>F :Files<CR>
nmap <Leader>b :Buffers<CR>
nmap <Leader>h :History<CR>
nmap <Leader>t :BTags<CR>
nmap <Leader>T :Tags<CR>
nmap <Leader>l :BLines<CR>
nmap <Leader>L :Lines<CR>
nmap <Leader>' :Marks<CR>
nmap <Leader>a :Rg<Space>
nmap <Leader>H :Helptags!<CR>
nmap <Leader>C :Commands<CR>
nmap <Leader>: :History:<CR>
nmap <Leader>/ :History/<CR>
nmap <Leader>M :Maps<CR>
nmap <Leader>s :Filetypes<CR>


" auto-complete engine and prettier (uses VSCode modules !)
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': './install.sh'}
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
" autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)
" Prettier config
command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')


" End of plugin configuration
call plug#end()


" Color scheme
set termguicolors
set background=dark
colorscheme nord
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
 if filereadable(".vimrc")
     so .vimrc
 endif

