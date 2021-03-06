" based on http://github.com/jferris/config_files/blob/master/vimrc

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup
set nowritebackup
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" See https://github.com/nelstrom/vim-textobj-rubyblock/blob/master/README.md
:runtime macros/matchit.vim
set nocompatible
if has("autocmd")
  filetype indent plugin on
endif

" Color scheme
set t_Co=256 " Set 256 colors
if !has("gui_running")
  autocmd VimEnter * GuiColorScheme sunburst
else
  colorscheme sunburst
endif

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
  set hlsearch
endif

" Show a vertical line/guard at column 80
if exists('+colorcolumn')
  set colorcolumn=80
endif

set guifont=Bitstream\ Vera\ Sans\ Mono:h14
set list listchars=eol:¬,tab:»·,trail:·

" Switch wrap off for everything
set nowrap

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Set File type to 'text' for files ending in .txt
  autocmd BufNewFile,BufRead *.txt setfiletype text
  autocmd BufRead,BufNewFile *.thrift setfiletype thrift

  " Enable soft-wrapping for text files
  autocmd FileType text,markdown,html,xhtml,eruby setlocal wrap linebreak nolist

  " Set filetype to html for EJS files
  au BufNewFile,BufRead *.ejs setfiletype html

  " For Haml
  au! BufRead,BufNewFile *.haml         setfiletype haml

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Automatically load .vimrc source when saved
  autocmd BufWritePost .vimrc source $MYVIMRC

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab

" Always display the status line
set laststatus=2

" \ is the leader character
let mapleader = "\\"


" Leader shortcuts for Rails commands
" map <Leader>m :Rmodel 
" map <Leader>c :Rcontroller 
" map <Leader>v :Rview 
" map <Leader>u :Runittest 
" map <Leader>f :Rfunctionaltest 
" map <Leader>tm :RTmodel 
" map <Leader>tc :RTcontroller 
" map <Leader>tv :RTview 
" map <Leader>tu :RTunittest 
" map <Leader>tf :RTfunctionaltest 
map <Leader>sm :RSmodel 
map <Leader>sc :RScontroller 
map <Leader>sv :RSview 
map <Leader>su :RSunittest 
map <Leader>sf :RSfunctionaltest 

" Edit routes
command! Rroutes :e config/routes.rb
command! Rschema :e db/schema.rb

" Hide search highlighting
map <Leader>h :set invhls <CR>

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>e
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
map <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+P
cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

" Duplicate a selection
" Visual mode: D
vmap D y'>p

" Press Shift+P while in visual mode to replace the selection without
" overwriting the default register
vmap P p :call setreg('"', getreg('0')) <CR>

" No Help, please
nmap <F1> <Esc>

" Press ^F from insert mode to insert the current file name
imap <C-F> <C-R>=expand("%")<CR>

" Maps autocomplete to tab
" imap <Tab> <C-N>

" Adds a global snippet for ^L to insert a hash rocket
imap <C-L> <Space>=><Space>

" Local config
if filereadable(".vimrc.local")
  source .vimrc.local
endif

" Use Ack instead of Grep when available
if executable("ack")
  set grepprg=ack\ -H\ --nogroup\ --nocolor\ --ignore-dir=tmp\ --ignore-dir=coverage
endif

" Numbers
set number
set numberwidth=5

" Snippets are activated by Shift+Tab
let g:snippetsEmu_key = "<S-Tab>"

" Tab completion options
" (only complete to the longest unambiguous match, and show a menu)
set completeopt=longest,menu
set wildmode=list:longest,list:full
set complete=.,t

" case only matters with mixed case expressions
set ignorecase
set smartcase

" Tags
let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"
set tags=./tags;

" Reload your vimrc with F2
map <F2> :source $MYVIMRC<CR>:echoe "Vimrc Reloaded!!!"<CR>

" Set a custom status line to include the current Git branch
set statusline=%<\ %n:%f\ %y\ %{fugitive#statusline()}\ %m%r%=%-35.(line:\ %l\ of\ %L,\ col:\ %c%V\ (%P)%)

" GLobally ignore files and directories
set wildignore+=**/log/**,*.orig,*.swp,*.rbc,*.pyc

" This will allow you to sudo from within vim to save a file that you dont
" have write permissions on
command! W w !sudo tee % > /dev/null

" CTRL-X will split the window then put your cursor in the buffer you split
" from
map <C-X> :sp<CR><C-W><C-W><CR>

" CTRL-F will run Ack for global search
map <C-F> :Ack<Space>

" With the tComment plugin, CMD-/ will comment in visual mode
vmap <D-/> gc
nmap <D-/> Vgc<ESC>

" In insert mode o will create a new line below the cursor and put your cursor
" in edit mode in that buffer
imap <C-Return> <Esc>o

" CTRL-O will create a new line below your cursor and not be in insert mode
map <C-O> o<Esc>

" CTRL-A will create a new line above your cursor and not be in insert mode
map <C-A> O<Esc>

" Will trim all whitespace off the end of each line
command! Respace %s/\(\s\+\)\(\n\)/\2/

" CTRL-H will convert an erb file to Haml
function! Html2Haml()
  let fileext = expand("%:e")
  if fileext == "erb"
    let filename = expand("%:r")
    let current_file = filename . "." . fileext
    let tmp_file = tempname()
    let new_file = filename . ".haml"
    execute "!html2haml " . current_file . " " . tmp_file
    exec "silent split " . tmp_file
    exec "silent normal GVggy"
    exec "silent bunload"
    exec "silent normal GVggp"
    exec "silent Gmove " . new_file
    exec "silent edit!"
  endif
endfunction

map <silent> <C-H> :call Html2Haml()<CR>

unmap <Leader>te

" set clipboard=unnamed
