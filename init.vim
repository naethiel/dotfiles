" Vim plugins
" -----------------------------------------

let g:plugin_path = '~/.config/nvim/plugged'

call plug#begin()

" Themes
" -----------------------------------------

Plug 'rakr/vim-one'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'levelone/tequila-sunrise.vim'
Plug 'danilo-augusto/vim-afterglow'
Plug 'tyrannicaltoucan/vim-deep-space'
Plug 'nanotech/jellybeans.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'shawncplus/skittles_berry'
Plug 'dsolstad/vim-wombat256i'
Plug 'sjl/badwolf'
Plug 'relastle/bluewery.vim'
Plug 'mhartington/oceanic-next'
Plug 'ayu-theme/ayu-vim'
Plug 'arcticicestudio/nord-vim'
let ayucolor="mirage" " AYU subtheme

" Tmux
" -----------------------------------------

if executable('tmux')
  Plug 'christoomey/vim-tmux-navigator'
endif

" FZF fuzzy finder
" -----------------------------------------

Plug 'junegunn/fzf' 
Plug 'junegunn/fzf.vim'

" File management
" -----------------------------------------

" File manager
Plug 'scrooloose/nerdtree'
" File manager behaves properly with vim tabs
Plug 'jistr/vim-nerdtree-tabs'
" Git file status integration in file manager
Plug 'Xuyuanp/nerdtree-git-plugin' 

" Syntax highlighting
" -----------------------------------------

" Syntax highlighting for pretty much everything
Plug 'sheerun/vim-polyglot'
" Proper highlight of JSX
Plug 'maxmellon/vim-jsx-pretty'

" Editing
" -----------------------------------------

" Surrounding selection
Plug 'tpope/vim-surround'

" Comment lines easily
Plug 'tpope/vim-commentary'

" Move blocks of code with ALT+j/k
Plug 'matze/vim-move'

" Auto parenthesis/brackets pairs
Plug 'jiangmiao/auto-pairs'

" Multiple select like in Sublime
Plug 'terryma/vim-multiple-cursors'

" Status bar
" -----------------------------------------

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Git
" -----------------------------------------

" Have git edits line-by-line in along line numbers
Plug 'airblade/vim-gitgutter'

" Javascript
" -----------------------------------------

" Specific language support
Plug 'pangloss/vim-javascript', {'for': ['javascript', 'javascript.jsx']}
" Autocomplete and linting
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}

" End of plugin configuration
call plug#end()

" Shortcut for checking if a plugin is loaded
function! s:has_plugin(plugin)
  let lookup = 'g:plugs["' . a:plugin . '"]'
  return exists(lookup)
endfunction

" General config
" -----------------------------------------

" Theme
colorscheme one
set background=dark
highlight Normal guibg=None
highlight NonText guibg=None

" Set , as leader key
let mapleader=","

" Enable term 24bit color
if (has("termguicolors"))
  set termguicolors
endif

" Make it obvious where 80 characters is
set textwidth=80

" With :set hidden, opening a new file when the current buffer has unsaved
" changes causes files to be hidden instead of closed
set hidden

" Lazyredraw attempts to solve Vim lag by reducing the amount of
" processing required. When enabled, any action that is not typed
" will not cause the screen to redraw
set lazyredraw

" Don't display the current mode (Insert, Visual, Replace)
" in the status line. This info is already shown in the
" Airline status bar.
set noshowmode

" Stop vim trying to syntax highlight long lines, typically found in minified
" files. This greatly reduces lag yet is still wide enough for large displays
set synmaxcol=500

" Highlight current line
set cursorline

" Indent using two spaces.
set softtabstop=2
set tabstop=2
set shiftwidth=2

" Smoother scrolling when moving horizontally
set sidescroll=1

" Use spaces, not tabs
set expandtab

" Don't wrap lines
set nowrap

" Keep the cursor in the same place when switching buffers
set nostartofline

" Show col and line position in the statusbar
set ruler

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Ignore case of searches
set ignorecase

" If a pattern contains an uppercase letter
" it is case sensitive, otherwise, it is not
set smartcase

" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed

" Enable mouse with tmux
set mouse=a

" Auto save changes before switching buffer
set autowrite

" Always show sign column for git icons
set signcolumn=yes

" Respect modeline in files
set modeline
set modelines=4

" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure

" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,nbsp:_
set list

" Show the current mode
set title

" Line numbers
set number

" Path and file extensions to look for when using `gf`
set suffixesadd+=.css,index.css,.js,.jsx,.scss
set path+=.,src

" Start scrolling before cursor gets to the edge
set scrolloff=3
set sidescrolloff=15
set sidescroll=1

" Visual feedback while search/replacing
set inccommand=nosplit

" Key mapping
" -----------------------------------------

" Clear search (highlight)
nnoremap <C-l> :nohlsearch<CR>

" Go fuck yourself Ex mode.
map Q <Nop>

" switching between panes
nnoremap <silent>g<Right> <C-w>l
nnoremap <silent>g<Left> <C-w>h
nnoremap <silent>g<Up> <C-w>k
nnoremap <silent>g<Down> <C-w>j
nnoremap <silent>gl <C-w>l
nnoremap <silent>gh <C-w>h
nnoremap <silent>gk <C-w>k
nnoremap <silent>gj <C-w>j

" Plugin config
" -----------------------------------------

" CoC config
if s:has_plugin('coc.nvim')
  call coc#add_extension('coc-json', 'coc-tsserver', 'coc-css', 'coc-html', 'coc-yaml', 'coc-prettier')
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

  " Use `leader+d` to navigate diagnostics
  nmap <silent> <leader>d <Plug>(coc-diagnostic-next)

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
  "
  " Prettier config
  command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')
endif

" Nerdtree and git extension
if s:has_plugin("nerdtree") 
  nnoremap <C-b> :NERDTreeTabsToggle<CR>
  nnoremap <silent> <Leader>v :NERDTreeTabsToggle<CR>

  let NERDTreeMinimalUI = 1
  let NERDTreeDirArrows = 1
endif

if s:has_plugin('nerdtree-git-plugin')
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
endif

" Seamless tmux/terminal integration
if s:has_plugin('vim-tmux-navigator')
  nnoremap <silent> <C-Left>  :TmuxNavigateLeft<CR>
  nnoremap <silent> <C-Down>  :TmuxNavigateDown<CR>
  nnoremap <silent> <C-Up>    :TmuxNavigateUp<CR>
  nnoremap <silent> <C-Right> :TmuxNavigateRight<CR>
endif

" Fuzzy finder
if s:has_plugin('fzf')
  let g:fzf_height = '40%'
  let g:fzf_commits_log_options = '--color --graph --pretty=format:"%C(yellow)%h%Creset -%C(auto)%d%Creset %s %C(bold blue)(%cr) %Cred<%an>%Creset" --abbrev-commit'


  nmap <Leader>f :GFiles<CR>
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


  let g:fzf_colors =
        \ { 'fg':      ['fg', 'Normal'],
        \ 'bg':      ['bg', 'Normal'],
        \ 'hl':      ['fg', 'Boolean'],
        \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
        \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
        \ 'hl+':     ['fg', 'Statement'],
        \ 'info':    ['fg', 'PreProc'],
        \ 'border':  ['fg', 'Ignore'],
        \ 'prompt':  ['fg', 'Conditional'],
        \ 'pointer': ['fg', 'Exception'],
        \ 'marker':  ['fg', 'Keyword'],
        \ 'spinner': ['fg', 'Label'],
        \ 'header':  ['fg', 'Comment'] }
endif

if s:has_plugin('vim-airline')
  let g:airline_theme = 'bubblegum'
  let g:airline_powerline_fonts = 1
endif

if s:has_plugin('vim-jsx-pretty')
  let g:jsx_ext_required = 0
  let g:javascript_plugin_jsdoc = 1
endif
