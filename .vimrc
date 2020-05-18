set nocompatible              " be iMproved, required
filetype off                  " required

execute pathogen#infect()

"=====================================================
" Vundle settings
"=====================================================
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'		" let Vundle manage Vundle, required

"---------=== Code/project navigation ===-------------
Plugin 'scrooloose/nerdtree' 	    	" Project and file navigation
Plugin 'majutsushi/tagbar'          	" Class/module browser

"------------------=== Other ===----------------------
Plugin 'bling/vim-airline'   	    	" Lean & mean status/tabline for vim
Plugin 'vim-airline/vim-airline-themes'
Plugin 'fisadev/FixedTaskList.vim'  	" Pending tasks list
Plugin 'rosenfeld/conque-term'      	" Consoles as buffers
Plugin 'tpope/vim-surround'	   	" Parentheses, brackets, quotes, XML tags, and more
Plugin 'zeekay/vim-beautify'

"--------------=== Snippets support ===---------------
Plugin 'garbas/vim-snipmate'		" Snippets manager
Plugin 'MarcWeber/vim-addon-mw-utils'	" dependencies #1
Plugin 'tomtom/tlib_vim'		" dependencies #2
Plugin 'honza/vim-snippets'		" snippets repo

"---------------=== Languages support ===-------------
" --- Python ---
"Plugin 'klen/python-mode'	        " Python mode (docs, refactor, lints, highlighting, run and ipdb and more)
Plugin 'davidhalter/jedi-vim' 		" Jedi-vim autocomplete plugin
"Bundle 'lepture/vim-jinja'		" Jinja support for vim
Plugin 'mitsuhiko/vim-python-combined'  " Combined Python 2/3 for Vim

call vundle#end()            		" required
filetype on
filetype plugin on
filetype plugin indent on

"=====================================================
" General settings
"=====================================================
set backspace=indent,eol,start
aunmenu Help.
aunmenu Window.
let no_buffers_menu=1
set mousemodel=popup

set ruler
set completeopt-=preview
set gcr=a:blinkon0
if has("gui_running")
  set cursorline
endif
set ttyfast

" �������� ��������� ����
syntax on
if has("gui_running")
" GUI? ������������ ���� � ������ ����
  set lines=50 columns=125
  colorscheme molokai
" ���������������� ��� ������, ���� ������, ����� NERDTree/TagBar ������������� ������������ ��� ������� vim
" autocmd vimenter * TagbarToggle
" autocmd vimenter * NERDTree
" autocmd vimenter * if !argc() | NERDTree | endif

" �� ���� vim?
if has("mac")
  set guifont=Consolas:h13
  set fuoptions=maxvert,maxhorz
else
" ��������� GUI
  set guifont=Ubuntu\ Mono\ derivative\ Powerline\ 10
endif
else
" ��������?
  colorscheme myterm
endif

tab sball
set switchbuf=useopen

" ��������� ������� � �������
set visualbell t_vb= 
set novisualbell       

set enc=utf-8	     " utf-8 �� ������� � ������
set ls=2             " ������ ���������� ���������
set incsearch	     " ���������������� �����
set hlsearch	     " ��������� ����������� ������
set nu	             " ���������� ������ �����
set scrolloff=5	     " 5 ����� ��� ������� �� ���

" ��������� ������ � ����-�����
"set nobackup 	     " no backup files
"set nowritebackup    " only in case you don't want a backup file while editing
"set noswapfile 	     " no swap files

" ������ ��������
"set guioptions-=m   " ����
set guioptions-=T    " ������
"set guioptions-=r   "  ����������

" ��������� �� Tab
set smarttab
set tabstop=8

"  ��� �������� �� ������� � 80 �������� � Ruby/Python/js/C/C++ ������������ �� ������ ���� �����
augroup vimrc_autocmds
    autocmd!
    autocmd FileType ruby,python,javascript,c,cpp highlight Excess ctermbg=DarkGrey guibg=Black
    autocmd FileType ruby,python,javascript,c,cpp match Excess /\%80v.*/
    autocmd FileType ruby,python,javascript,c,cpp set nowrap
augroup END

" ��������� ������� � ����������� SnipMate
let g:snippets_dir = "~/.vim/vim-snippets/snippets"

" ��������� Vim-Airline
set laststatus=2
let g:airline_theme='badwolf'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

" TagBar ���������
map <F4> :TagbarToggle<CR>
let g:tagbar_autofocus = 0 " ��������� �� Tagbar ��� ��������

" NerdTree ���������
" �������� NERDTree �� F3
map <F3> :NERDTreeToggle<CR>
"������������� ����� � ������������
let NERDTreeIgnore=['\~$', '\.pyc$', '\.pyo$', '\.class$', 'pip-log\.txt$', '\.o$']  
"let NERDTreeMapOpenInTab='<ENTER>'


" TaskList ���������
map <F2> :TaskList<CR> 	   " ���������� ������ ������ �� F2

" ������ ���������
map <C-q> :bd<CR> 	   " CTRL+Q - ������� ������� ������

map <F5> :!pyformat -i @%<CR>

"=====================================================
" Python-mode settings
"=====================================================
" ��������� ����������� �� ���� (� ��� ������ ���� ������������ jedi-vim)
"let g:pymode_rope = 0
"let g:pymode_rope_completion = 0
"let g:pymode_rope_complete_on_dot = 0

" ������������
"let g:pymode_doc = 0
"let g:pymode_doc_key = 'K'
" �������� ����
"let g:pymode_lint = 1
"let g:pymode_lint_checker = "pyflakes,pep8"
"let g:pymode_lint_ignore="E501,W601,C0110"
" ������� ���� ����� ����������
"let g:pymode_lint_write = 1

" ��������� virtualenv
"let g:pymode_virtualenv = 1

" ��������� breakpoints
"let g:pymode_breakpoint = 1
"let g:pymode_breakpoint_key = '<leader>b'

" ���������� ����������
"let g:pymode_syntax = 1
"let g:pymode_syntax_all = 1
"let g:pymode_syntax_indent_errors = g:pymode_syntax_all
"let g:pymode_syntax_space_errors = g:pymode_syntax_all

" ��������� autofold �� ����
"let g:pymode_folding = 0

" ����������� ��������� ���
"let g:pymode_run = 0


" Disable choose first function/method at autocomplete
let g:jedi#popup_select_first = 0

"=====================================================
" User hotkeys
"=====================================================
" ConqueTerm
" ������ �������������� �� F5
nnoremap <F5> :ConqueTermSplit ipython<CR>
" � debug-mode �� <F6>
nnoremap <F6> :exe "ConqueTermSplit ipython " . expand("%")<CR>
let g:ConqueTerm_StartMessages = 0
let g:ConqueTerm_CloseOnEnd = 0
" �������� ���� � ������������ � PEP8 ����� <leader>8
autocmd FileType python map <buffer> <leader>8 :PymodeLint<CR>

" ����������� ����� <Ctrl+Space>
inoremap <C-space> <C-x><C-o>

" ������������ ����� ������������
nnoremap <leader>Th :set ft=htmljinja<CR>
nnoremap <leader>Tp :set ft=python<CR>
nnoremap <leader>Tj :set ft=javascript<CR>
nnoremap <leader>Tc :set ft=css<CR>
nnoremap <leader>Td :set ft=django<CR>



"=====================================================
" Languages support
"=====================================================
" --- Python ---
"autocmd FileType python set completeopt-=preview " ����������������, � ������, ���� �� ����, ����� jedi-vim ��������� ������������ �� ������/������
autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8
\ formatoptions+=croq softtabstop=4 smartindent
\ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
autocmd FileType pyrex setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4 smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with

" --- JavaScript ---
let javascript_enable_domhtmlcss=1
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd BufNewFile,BufRead *.json setlocal ft=javascript

" --- HTML ---
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags

" --- template language support (SGML / XML too) ---
autocmd FileType html,xhtml,xml,htmldjango,htmljinja,eruby,mako setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
autocmd bufnewfile,bufread *.rhtml setlocal ft=eruby
autocmd BufNewFile,BufRead *.mako setlocal ft=mako
autocmd BufNewFile,BufRead *.tmpl setlocal ft=htmljinja
autocmd BufNewFile,BufRead *.py_tmpl setlocal ft=python
let html_no_rendering=1
let g:closetag_default_xml=1
let g:sparkupNextMapping='<c-l>'
autocmd FileType html,htmldjango,htmljinja,eruby,mako let b:closetag_html_style=1
autocmd FileType html,xhtml,xml,htmldjango,htmljinja,eruby,mako source ~/.vim/scripts/closetag.vim

" --- CSS ---
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType css setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4

