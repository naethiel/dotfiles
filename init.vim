set tabstop=2
set shiftwidth=2
set expandtab
let mapleader=","
" Plugins configuration
call plug#begin()

" Nerdtree and git extension
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
" nerdtree with git :o 
Plug 'Xuyuanp/nerdtree-git-plugin' 
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }
nnoremap <C-b> :NERDTreeTabsToggle<cr>

" Themes
Plug 'rakr/vim-one'
Plug 'morhetz/gruvbox'
let g:gruvbox_contrast_dark = 'medium'

" Javascript support
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
let g:jsx_ext_required = 0
let g:javascript_plugin_jsdoc = 1

" Surrounding selection
Plug 'tpope/vim-surround'

" Comment lines easily
Plug 'tpope/vim-commentary'

" Easy motion
Plug 'easymotion/vim-easymotion/'

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Git gutter
Plug 'airblade/vim-gitgutter'

" Fuzzy universal finder
Plug 'junegunn/fzf' 
Plug 'junegunn/fzf.vim'
nmap <C-f> :GFiles<CR>
nmap <Leader>F :Files<CR>
nmap <Leader>b :Buffers<CR>
nmap <Leader>h :History<CR>
nmap <Leader>l :BLines<CR>
nmap <Leader>a :Rg<Space>
nmap <Leader>H :Helptags!<CR>
nmap <Leader>C :Commands<CR>
nmap <Leader>: :History:<CR>
nmap <Leader>/ :History/<CR>
nmap <Leader>M :Maps<CR>


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
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif
" colorscheme one
colorscheme one
set background=dark
let g:airline_theme = 'one'
let g:airline_powerline_fonts = 1
" highlight Normal guibg=None
" highlight NonText guibg=None
nnoremap <C-l> :nohlsearch<cr>

" Comfort
set cursorline                     " highlight the cursor line
set number                         " line numbers
set ruler                          " always show cursor
set scrolloff=5                    " start scrolling three lines before horizontal border of window
set sidescrolloff=5                " start scrolling three columns before vertical border of window
set hidden                         " only hide buffers when switch to a new file, so the undo history is still here

" Speed a little bit of things
set lazyredraw                     " vim can become awfully slow at times when redrawing screens with cursor lines or columns
set ttyfast

" If there is a .vimrc file in the local directory when opening, load it too.
 if filereadable(".vimrc")
     so .vimrc
 endif

