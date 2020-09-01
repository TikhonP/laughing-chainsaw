"=====================================================
" VIM базовые настройки
"=====================================================

echo ">^.^<"

packloadall  " Загрузка плагинов

let mapleader = "\<Space>"  " Leader клавиша - пробел

set nocompatible  " Включает работу стрелочек в режиме вставки
set backspace=indent,eol,start "Включает backspace в режиме вставки

"let no_buffers_menu = 1  " Отключает буффер меню

set mouse=a  " Включает мышку полностью
set mousemodel=popup  " Включает контекстное менб по правому нажатию мышки

set encoding=utf-8
set ls=2  " всегда показываем статусбар

set ruler  " Отображение колонок
set gcr=a:blinkon0 " Отключает мигание курсора
set cursorline  " Показывать линию курсора

set ttyfast  " Что-то с прокруткой
syntax on  " включить подсветку кода

tab sball  " Открывает новую вкладку для каждого буффера
set switchbuf=useopen  " Для того что выше
set incsearch  " инкреминтируемый поиск
set hlsearch  " подсветка результатов поиска
set nu  " показывать номера строк
set scrolloff=5  " 5 строк при скролле за раз

" Настройка табуляции
set tabstop=4  " 4 пробела
set shiftwidth=4
set smarttab
set expandtab  " Замена табов на пробелы
set smartindent  " Автоматические отступы

filetype plugin indent on  " Распознавание файлов для плагинов


"---------=== Навигация по проекту/коду ===-----------

cd /Users/tikhon/documents/projects  " Папка с проектами

" Открытие файла через find
set path+=**
set wildmenu


"-------------------=== Дизайн ===--------------------

set guifont=Menlo\ Regular:h14

set colorcolumn=80  " Устанвливаем границу в 80 символов

" Прячем панельки
set guioptions-=m  " Меню
set guioptions-=T  " Тулбар
set guioptions-=r  " Скроллбары справа
set guioptions-=L  " Скроллбары слева

if has("gui_running")
  set lines=50 columns=125
endif

" TOUCHBAR
if has("gui_running") 
    amenu icon=NSTouchBarSidebarTemplate TouchBar.nerdtree :NERDTreeToggle<CR>
    amenu icon=NSTouchBarGoBackTemplate TouchBar.back :bp<CR>
    amenu TouchBar.// gcl
    amenu icon=NSTouchBarBookmarksTemplate TouchBar.docs K<CR>
    amenu icon=NSTouchBarComposeTemplate TouchBar.neww :new<CR>
    amenu TouchBar.-flexspace2-   <Nop>
    amenu icon=NSTouchBarAddTemplate TouchBar.addtemplate :tabe<CR>
endif


"=====================================================
" Плагины
"=====================================================
"
" VIMPLUG
call plug#begin()

Plug 'lervag/vimtex'
let g:tex_flavor = 'latex'
let g:vimtex_view_method = 'skim'

Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

call plug#end()

" hzchirs/vim-material
colorscheme vim-material
" Проверяем включен ли darkmode
if has("gui_running") && exists('##OSAppearanceChanged')
    func! s:ChangeBackground()
        if (v:os_appearance)
            set background=dark
        else 
            set background=light
        endif
        redraw!
        redrawtabline
    endfunc

    augroup AutoDark
      autocmd OSAppearanceChanged * call s:ChangeBackground()
    augroup END
else
    set background=light
endif


" vim-airline/vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_theme='material'

" preservim/nerdtree
autocmd vimenter * NERDTree
autocmd vimenter * if !argc() | NERDTree | endif
let NERDTreeShowHidden=1
map <F3> :NERDTreeToggle<CR>
let NERDTreeIgnore=['\~$', '\.pyc$', '\.pyo$', '\.class$', 'pip-log\.txt$', '\.o$']


" majutsushi/tagbar
map <F4> :TagbarToggle<CR>
let g:tagbar_autofocus = 0 " автофокус на Tagbar при открытии
" Нужно поставить Universal Ctags для него

" python-mode/python-mode
" отключаем автокомплит по коду (у нас вместо него используется jedi-vim)
let g:pymode_rope = 0
let g:pymode_rope_completion = 0
let g:pymode_rope_complete_on_dot = 0
" документация
let g:pymode_doc = 0
let g:pymode_doc_key = 'K'
" провека кода после сохранения
let g:pymode_lint_write = 1
" поддержка virtualenv
let g:pymode_virtualenv = 1
" установка breakpoints
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_key = '<leader>b'
" подстветка синтаксиса
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all
" отключить autofold по коду
let g:pymode_folding = 0
" возможность запускать код
let g:pymode_run = 0

"Yggdroot/indentLine
let g:indentLine_enabled = 1

" prettier/vim-prettier
nmap <Leader>pr <Plug>(Prettier)
let g:prettier#exec_cmd_async = 1
let g:prettier#quickfix_enabled = 0
autocmd TextChanged,InsertLeave *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync

" tpope/vim-commentary
" mattn/emmet-vim
" davidhalter/jedi-vim
" alvan/vim-closetag
" wlangstroth/vim-racket


"=====================================================
" Пользовательские сочитания клавиш
"=====================================================

" автокомплит через <Ctrl+z>
inoremap <C-z> <C-x><C-o>


"=====================================================
" Поддержка языков
"=====================================================

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

" --- CSS ---
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
