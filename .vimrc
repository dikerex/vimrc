"
"   ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗ ██████╗
"   ██║   ██║██║████╗ ████║██╔══██╗██╔════╝██╔════╝
"   ██║   ██║██║██╔████╔██║██████╔╝██║     ██║  ███╗
"   ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║     ██║   ██║
"    ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗╚██████╔╝
"     ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝
"
"   Customizable VimRC Generator: https://vimrc.org
"   Configuration Generated on: January 25, 2018
" ---------------------------------------------------
set nocompatible
" Variables                      {{{
" --> define os specific variables
let g:is_gui     = has('gui_running')
let g:is_mac     = has('mac') || has('macunix') || has('gui_macvim')
let g:is_nix     = has('unix') && !has('macunix') && !has("win32unix")
let g:is_macvim  = g:is_mac && g:is_gui && has('gui_macvim')
let g:is_ubuntu  = g:is_nix && system("uname -a") =~ "Ubuntu"
let g:is_windows = has('win16') || has('win32') || has('win64')

" --> define other relevant variables
let g:is_posix   = 1 " enable better bash syntax highlighting

" }}}

" Plugin Manager                 {{{
" --> auto-install a plugin manager for VIM, if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" --> define helper function to conditionally require plugins
"     used as:
"       Plug 'benekastah/neomake', Cond(has('nvim'), { 'on': 'Neomake' })
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

" --> define function to install a plugin from a Gist URL
function! PlugFromGist(id, name)
  Plug 'https://gist.github.com/'.id.'.git',
    \ { 'as': name, 'do': 'mkdir -p plugin; cp -f *.vim plugin/' }
endfunction

" }}}

" --> Personalize: allows customizations via a local configuration
if filereadable(expand("~/.vimrc.pre")) | source ~/.vimrc.pre | endif
call plug#begin(expand("~/.vim/bundle"))
" Line Numbers                   {{{
" --> enable line numbers with maximum 4 gutter columns
set number
set numberwidth=4

" --> provide toggle key for displaying relative line numbers (RLN)
nnoremap <leader>trn :set relativenumber!<cr>

" --> use absolute line numbers everywhere
augroup relative_line_numbers
  au!
  autocmd FocusLost,BufLeave,InsertEnter   * if &number | :setl norelativenumber | endif
  autocmd FocusGained,BufEnter,InsertLeave * if &number | :setl relativenumber   | endif
augroup end

" }}}

" Editor                         {{{
" --> allow cursor 1 char beyond end of current line
set virtualedit=onemore

" --> allow backspace to work over everything in Insert mode
set backspace=indent,eol,start

" --> try different EOL formats when reading buffers
set fileformats="unix,dos,mac"

" --> set basic formatting options for editing text
set formatoptions-=t            " do not format just about any type of text, esp. source code
set formatoptions+=n            " recognize numbered lists when formatting
set formatoptions+=1            " don't break a line after a one-letter word

" --> use soft tabs (with spaces) over hard tabs
set tabstop=2                   " a tab is two spaces
set softtabstop=2               " when <BS>, pretend tab is removed, even if spaces
set expandtab                   " expand tabs, by default
set nojoinspaces                " prevents two spaces after punctuation on join

" --> disable wrapping of long lines and set line width to 80 characters
set nowrap                      " don't wrap lines
set linebreak                   " break long lines at words, when wrap is on
set whichwrap=b,s,h,l,<,>,[,]   " allow <BS> & cursor keys to move to prev/next line
set showbreak=↪                 " string to put at the starting of wrapped lines
set textwidth=80                " wrap after this many characters in a line

" --> display any whitespace in the buffer
set list                        " show invisible characters like spaces
                                " enabled later via autocmd on certain filetypes
set listchars=tab:▸\ ,trail:·,extends:❯,precedes:❮,nbsp:·

" --> provide movement around surroundings of text object
Plug 'tpope/vim-surround'

" --> provide fast jumps to any specific location - try ,,w
Plug 'Lokaltog/vim-easymotion'

" --> allow creation of our own text objects, and add some useful ones
Plug 'kana/vim-textobj-user'
Plug 'austintaylor/vim-indentobject'      " indentations: i
Plug 'coderifous/textobj-word-column.vim' " vertical columns by word boundary: c
Plug 'kana/vim-textobj-fold'              " foldings: z

" }}}

" Python                         {{{
" --> provide Python integration environment for VIM
Plug 'klen/python-mode'

" --> enable auto completion for python
augroup omni_complete
  if exists('+omnifunc')
    autocmd filetype python setlocal omnifunc=pythoncomplete#Complete
  end
augroup end

" --> set whitespace settings for Python related files
augroup setup_whitespace
  au filetype python   setl ts=4 sw=4 sts=4 tw=80 et
augroup end

" --> warns when text width exceeds predefined width in Python files
augroup exceeded_text_width
  au filetype python match ErrorMsg '\%>80v.\+'
augroup end

" --> run current file (if script) when <F5> is pressed
augroup jobs_and_tasks
  au BufRead,BufEnter *.py if executable(expand("%:p")) &&
        \ ( &makeprg == "make" ) | setl makeprg=%:p | endif
augroup end

" }}}

" Colorschemes                   {{{
" --> provide more colorschemes for the editor
Plug 'ciaranm/inkpot'
Plug 'DAddYE/soda.vim'
Plug 'Pychimp/vim-luna'
Plug 'fugalh/desert.vim'
Plug 'nanotech/jellybeans.vim'
Plug 'jnurmine/Zenburn'
Plug 'minofare/VIM-Railscasts-Color-Theme'
Plug 'flazz/vim-colorschemes'
" Plug 'wombat256.vim'
" Plug 'cstrahan/grb256'
" Plug 'chriskempson/base16-vim'
" Plug 'chriskempson/vim-tomorrow-theme'
" Plug 'daylerees/colour-schemes', { 'rtp': 'vim-themes/' }

" }}}

" Basic Keymappings              {{{
" --> define various `leader` keys
let mapleader      = ","     " change mapleader key from / to ,
let g:mapleader    = ","     " some plugins may require this variable to be set
let maplocalleader = "\\"    " used inside filetype settings

" --> map ; to :
" `;` key repeats latest movement command. Although useful, mapping this key to
" `:` is a real optimization for almost all Vim commands, since we save on
" pressing `Shift` key each time that slows almost all commands we use.
nnoremap ; :

" --> swap implementations of ` and ' jump to markers
nnoremap ' `
nnoremap ` '

" --> swap implementations of 0 and ^
nnoremap 0 ^
nnoremap ^ 0

" }}}

" Sessions                       {{{
" --> restore history, registers, etc. when a file is loaded
if has('viminfo')
  " ': Remember upto 500 files for which marks are remembered.
  " %: Save and restore the buffer list.
  " :: Remember upto 100 items in command-line history.
  " /: Remember upto 20  items in the search pattern history.
  " <: Remember upto 200 lines for each register.
  " f: Store file marks ('0 to '9 and 'A to 'Z)
  " Further, reading:  :h viminfo
  set viminfo='500,:100,@100,/20,f1,%,<200
endif

" --> restore editor's window's size, if possible
if has('mksession')
  set sessionoptions+=resize
endif

" --> remember a long history of commands and searches performed
set history=1000

" --> restore cursor position on opening a file
augroup restore_cursor
  au!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$")
                        \ | exe "normal! g`\"" | endif
augroup end

" " --> automatically, save and restore editor sessions
" " NOTE: vim-misc is required for vim-session
" Plug 'xolox/vim-misc'
" Plug 'xolox/vim-session'
" let g:session_autoload = 'yes'
" let g:session_autosave = 'yes'
" let g:session_default_to_last = 1
" " let g:session_default_overwrite = 1
" " let g:session_command_aliases = 1

" " --> provide mapping to save a session with a particular name
" function! SaveSessionWithPrompt()
"   " guess name from current session, if any
"   let name = xolox#session#find_current_session()
"   let is_tab_scoped = xolox#session#is_tab_scoped()

"   " ask user for a session name, otherwise
"   if empty(name)
"     let default_name = ''
"     if g:session_default_name
"       let default_name = g:session_default_name
"     endif

"     call inputsave()
"     let name = input('save session? by what name? ', default_name)
"     call inputrestore()
"   endif

"   " use the default session name, otherwise
"   if empty(name) && g:session_default_name
"     let name = g:session_default_name
"   endif

"   " save the given session
"   if xolox#session#is_tab_scoped()
"     call xolox#session#save_tab_cmd(name, '!', 'SaveTabSession')
"   else
"     call xolox#session#save_cmd(name, '!', 'SaveSession')
"   endif

" endfunction
" nnoremap <leader>QA :call SaveSessionWithPrompt()<CR>:qall<CR>

" }}}

" Code Folding                   {{{
" --> enabled code folding based on indentation by default
set nofoldenable       " do not enable folding, by default
set foldcolumn=0       " add a fold column to the left of line-numbers
set foldlevel=0        " folds with a higher level will be closed
set foldlevelstart=10  " start out with everything open
set foldmethod=indent  " create folds based on indentation
set foldnestmax=7      " deepest fold is 7 levels
set foldminlines=1     " do not fold single lines, fold everything else

" --> toggle fold on the current fold using <SPACE> key
nnoremap <Space> za
vnoremap <Space> za

" --> auto-unfold folds when specific commands are triggered
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo

" --> display informative text on code-foldings
function! MyFoldText()
  let line = getline(v:foldstart)

  let nucolwidth = &fdc + &number * &numberwidth
  let windowwidth = winwidth(0) - nucolwidth - 3
  let foldedlinecount = v:foldend - v:foldstart

  " expand tabs into spaces
  let onetab = strpart('          ', 0, &tabstop)
  let line = substitute(line, '\t', onetab, 'g')

  let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
  let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - 4
  return line . ' ' . repeat("-",fillcharcount) . ' ' . foldedlinecount . ' '
endfunction
set foldtext=MyFoldText()

" --> allow folding code/text to a specific level
nmap <leader>f0 :set foldlevel=0<CR>
nmap <leader>f1 :set foldlevel=1<CR>
nmap <leader>f2 :set foldlevel=2<CR>
nmap <leader>f3 :set foldlevel=3<CR>
nmap <leader>f4 :set foldlevel=4<CR>
nmap <leader>f5 :set foldlevel=5<CR>
nmap <leader>f6 :set foldlevel=6<CR>
nmap <leader>f7 :set foldlevel=7<CR>
nmap <leader>f8 :set foldlevel=8<CR>
nmap <leader>f9 :set foldlevel=9<CR>

" --> take care not to screw up existing folds when inserting text
" read more: http://vim.wikia.com/wiki/Keep_folds_closed_while_inserting_text
augroup FixFoldInsert
  au!
  autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod |
        \ setlocal foldmethod=manual | endif
  autocmd InsertLeave,WinLeave * if exists('w:last_fdm') |
        \ let &l:foldmethod=w:last_fdm |
        \ unlet w:last_fdm | endif
augroup end

" for use by other sections
augroup create_folds | au! | augroup end

" }}}

" Diff                           {{{
" --> ignore whitespace in diff mode (focus on code changes only)
if has("diff") | set diffopt+=iwhite | endif

" --> view unsaved changes in the current buffer as a diff
if has("diff")
  function! DiffWithSaved()
    let filetype=&ft
    diffthis
    vnew | r # | normal! 1Gdd
    diffthis
    exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
  endfunction
  nnoremap <leader>ds :call DiffWithSaved()<CR>
endif

" }}}

" Undo And Repeat                {{{
" --> persist undo/redo history even after closing a file
if has('persistent_undo')
  set undofile                  " have a long persisting undo data
  set undolevels=1000           " Maximum number of changes that can be undone
  set undoreload=10000          " Maximum number lines to save for undo on a buffer reload
  set undodir=~/.vim/tmp/undo,/tmp
endif

" --> provide mapping to traverse undo/redo history as a graphical tree
Plug 'sjl/gundo.vim'
nnoremap <leader>tgu :GundoToggle<CR>

" --> repeat operator <.> works with plugins and with visual selection
"     - supports plugins: commentary, surround, abolish, unimpaired
"     - read: http://stackoverflow.com/a/8064607/127816
Plug 'tpope/vim-repeat'
vnoremap . :normal .<CR>

" --> bring the cursor back when repeat command is finished
nmap . .`[

" }}}

" Basic Colors                   {{{
" --> enable TrueColor support
if &term =~# '^screen'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" --> provide some beautiful colorschemes for the editor
Plug 'dracula/vim'
Plug 'morhetz/gruvbox'
Plug 'trevordmiller/nova-vim'
Plug '29decibel/codeschool-vim-theme'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'altercation/vim-colors-solarized'

" }}}

" Mouse                          {{{
" --> enable mouse for all modes if supported by terminal
if has('mouse')
  set mouse=a
  set mousehide        " hide mouse pointer when typing
endif

" }}}

" Code Completion                {{{
" --> enable code completion for buffers
set completeopt+=menu,longest     " select first item, follow typing in autocomplete
set complete=.,w,b,u,t            " do lots of scanning on tab completion,  FIXME?
set pumheight=6                   " Keep a small completion window

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2
  set concealcursor=i
endif

" --> show extra information about completion selection in preview window
set completeopt+=preview

" -> provide syntax based auto completion by default
augroup omni_complete
  au!
  if exists('+omnifunc')
    autocmd filetype * if &omnifunc == '' | setlocal omnifunc=syntaxcomplete#Complete | endif
  end
augroup end

" -!-> disable the neosnippet preview candidate window
" When enabled, there can be too much visual noise especially when splits are used.
" set completeopt-=preview

" -!-> enable YouCompleteMe plugin
" Plugin 'Valloric/YouCompleteMe'
" " enable completion from tags
" let g:ycm_collect_identifiers_from_tags_files = 1
" " enable completion for keywords in current language
" let g:ycm_seed_identifiers_with_syntax = 0

" if has('lua')
"   Plugin 'Shougo/neocomplete.vim'
"   let g:neocomplete#enable_at_startup = 1                 " enable at startup
"   let g:neocomplete#enable_ignore_case = 1                " ignore case when completing
"   let g:neocomplete#sources#syntax#min_keyword_length = 4 " use a minimum syntax keyword length
"   let g:neocomplete#force_overwrite_completefunc = 1
"   " do not complete automatically on files matching this pattern
"   " let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
"   " let g:neocomplete#keyword_patterns['default'] = '\h\w*'
"   inoremap <expr><C-g>     neocomplete#undo_completion()
"   inoremap <expr><C-l>     neocomplete#complete_common_string()

"   " <CR>: close popup and save indent.
"   inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
"   function! s:my_cr_function()
"     return neocomplete#smart_close_popup() . "\<CR>"
"     " For no inserting <CR> key.
"     "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
"   endfunction

"   " <TAB>: completion.
"   inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

"   " <C-h>, <BS>: close popup and delete backword char.
"   inoremap <expr><C-h>  neocomplete#smart_close_popup()."\<C-h>"
"   inoremap <expr><BS>   neocomplete#smart_close_popup()."\<C-h>"
"   inoremap <expr><C-y>  neocomplete#close_popup()
"   inoremap <expr><C-e>  neocomplete#cancel_popup()
" else
"   Plugin 'Shougo/neocomplcache.vim'
"   let g:neocomplcache_enable_at_startup  = 1               " enable at startup
"   let g:neocomplcache_enable_ignore_case = 1               " ignore case when completing
"   let g:neocomplcache_min_syntax_length  = 4               " use a minimum syntax keyword length
"   " do not complete automatically on files matching this pattern
"   " let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
"   " if !exists('g:neocomplcache_keyword_patterns')
"     " let g:neocomplcache_keyword_patterns = {}
"   " endif
"   " let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
"   inoremap <expr><C-g>     neocomplcache#undo_completion()
"   inoremap <expr><C-l>     neocomplcache#complete_common_string()

"   " <CR>: close popup and save indent.
"   inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
"   function! s:my_cr_function()
"     return neocomplcache#smart_close_popup() . "\<CR>"
"     " For no inserting <CR> key.
"     "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
"   endfunction

"   " <TAB>: completion.
"   inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

"   " <C-h>, <BS>: close popup and delete backword char.
"   inoremap <expr><C-h>  neocomplcache#smart_close_popup()."\<C-h>"
"   inoremap <expr><BS>   neocomplcache#smart_close_popup()."\<C-h>"
"   inoremap <expr><C-y>  neocomplcache#close_popup()
"   inoremap <expr><C-e>  neocomplcache#cancel_popup()
" endif

" }}}

" Sane Defaults                  {{{
" --> watch for file & directory changes, but don't auto-write files
set autoread                      " watch for file changes
set noautochdir                   " do not auto change the working directory
set noautowrite                   " do not auto write file when moving away from it
set nofsync                       " allows OS to decide when to flush to disk

" --> scroll text automatically when cursor is near edges
set scrolloff=7                 " keep lines off edges of the screen when scrolling
set sidescroll=1                " brings characters in view when side scrolling
set sidescrolloff=15            " start side-scrolling when n chars are left
" set scrolljump=5                " lines to scroll when cursor leaves screen

" --> advice VIM to work with UTF-8 encodings by default
scriptencoding utf-8
set encoding=utf-8 nobomb " BOM often causes trouble
set termencoding=utf-8
set fileencodings=utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1

" --> disables file backups via VIM (use versioning, instead!)
set nobackup                      " do not keep backup files - it's 70's style cluttering
set nowritebackup                 " do not make a write backup
set noswapfile                    " do not write annoying intermediate swap files
set directory=~/.vim/tmp/swaps,/tmp    " store swap files in one of these directories (in case swapfile is ever turned on)

" --> disable annoying VIM error bells :P
set noerrorbells                  " don't beep
set visualbell t_vb=              " don't beep, remove visual bell char

" --> set timeout on key combinations, e.g. mappings & key codes
set timeout                     " timeout on :mappings and key codes
set timeoutlen=600              " timeout duration should be sufficient to type the mapping
set ttimeoutlen=50              " timeout duration should be small for keycodes
                                " try pressing 'O' in normal mode in terminal editor

" --> dont update display when executing macros, etc.
set lazyredraw

" --> always show line numbers
set number

" --> (security) reject modelines altogether
set nomodeline

" --> (security) do not allow per-directory vim configurations
set noexrc
set secure

" --> (security) use a stronger encryption method
if exists("&cryptmethod") | set cryptmethod=blowfish | endif

" --> enable '%' key to match much more than braces.
runtime macros/matchit.vim

" }}}

" Cursor                         {{{
" --> highlight cursor line, but do not highlight cursor column
set cursorline
set cursorcolumn

" --> highlight columns at 80, 100 and 120 character limits
if has('syntax') | set colorcolumn=80,100,120 | endif

" --> provide toggle key for highlighting of cursor column
"   - useful for manual indentation of text
nnoremap <leader>tcc :set cursorcolumn!<CR>

" --> use a non-blinking line cursor in insert mode
Plug 'jszakmeister/vim-togglecursor'
if g:is_gui
  let &guicursor = substitute(&guicursor, 'n-v-c:', '&blinkon0-', '')
endif

" --> enable use of multiple cursors for quick editing
Plug 'terryma/vim-multiple-cursors'
let g:multi_cursor_use_default_mapping = 0
let g:multi_cursor_next_key='<F3>'
let g:multi_cursor_prev_key=''
let g:multi_cursor_skip_key=''
let g:multi_cursor_quit_key='<Esc>'

" }}}

" Terminal                       {{{
" --> integrate with the user's login shell
" NOTE: DO NOT ENABLE INTERACTIVE SHELL OR TERMINAL VIM WILL SUSPEND ITSELF.
  " NOTE: place environment variables in ~/.zshenv so that VIM can read them.
if !g:is_windows
  if !empty('$SHELL')
    set shell=$SHELL\ -l
  elseif executable('zsh')
    set shell=zsh\ -l
  elseif executable('bash')
    set shell=bash\ -l
  else
    set shell=/bin/sh
  endif
endif
Plug 'Shougo/vimshell.vim'

" --> use faster tty (terminal) & sets it title as per the file
set title
set ttyfast

" --> set appropriate terminal colors for the terminal
if &t_Co > 2 && &t_Co < 16
  set t_Co =16
elseif &t_Co > 16
  set t_Co =256
endif

" --> provide function to run shell commands and capture their output in buffer
Plug 'sjl/clam.vim'

" }}}

" Vim/Shell                      {{{
" --> detect correct file types for various shell files
augroup detect_filetypes
  au BufNewFile,BufRead *vimrc,*.vim setl ft=vim
  au BufNewFile,BufRead *zshrc,*zprofile,*zlogout,*zlogin,*zshenv,*.zsh-theme setl ft=sh
augroup end

" --> set whitespace settings for Vim and Shell files
augroup setup_whitespace
  au filetype sh  setl ts=2 sw=2 sts=2 tw=72 et
  au filetype vim setl ts=2 sw=2 sts=2 tw=72 et
augroup end

" --> dictate how to create folds for vim and shell files
augroup create_folds
  au filetype sh  setl fdm=marker fmr={{{,}}} fdls=0 fdl=0
  au filetype vim setl fdm=marker fmr={{{,}}} fdls=0 fdl=0
augroup end

" --> provide additional help for vim files via <gK> mapping
function! AdditionalHelpForVim()
  let g:investigate_use_url_for_vim = 1
  call investigate#Investigate()
  let g:investigate_use_url_for_vim = 0
endfunction
augroup documentor_vim | au!
  au filetype vim silent! nmap <silent> gK :call AdditionalHelpForVim()<CR>
augroup end

" --> run Shell files when <F5> is pressed
augroup jobs_and_tasks
  au filetype sh  setl makeprg=chmod\ +x\ %:p\ &&\ %:p
augroup end

" --> provide mappings to edit and source vim config on fly
" edit the vimrc file
nmap <leader>e. :vs<CR>:e $MYVIMRC<CR>
" source the current file
nmap <leader>bs :source %<CR>:set foldenable<CR>:e!<CR>
" source a visual range
vmap <leader>bs y:@"<CR>:echo 'Sourced the selected range.'<CR>

" --> provide mapping to open URL for plugin on current line
"     FIXME: this can be improved using a function.
"            - specifically, use `gx` for all the niceties it provides
augroup vim_plugin_browser
  au!
  au filetype vim noremap <buffer> <F6>
        \ :normal ^f'ahttps://github.com/<Esc>:normal ^f'lgxu<CR>
augroup end

" --> provide mappings to navigate HELP in an easier manner
"     try pressing: <K> on any keyword to bring help,
"     and then press <q> to quit it right away ;)
augroup help_window
  au!
  au filetype help nnoremap <buffer><cr> <c-]>
  au filetype help nnoremap <buffer><bs> <c-T>
  au filetype help nnoremap <buffer>q    :q<CR>
augroup end

" }}}

" Programming                    {{{
" --> do not break keywords on '.', '-' or '#'
set iskeyword-=.
set iskeyword-=#
set iskeyword-=-

" --> enable syntax highting of code in a sane manner
set synmaxcol=800
" syntax highlight on, when terminal has colors
if g:is_gui || &t_Co > 2 | syntax on | endif

" --> blink matching parenthesis for a brief duration
set showmatch
set matchtime=2    " show matching parenthesis for 0.2 seconds

" --> auto-indent text by default and when writing code
set autoindent     " always set autoindenting on
set shiftwidth=2   " number of spaces to use for autoindenting
set copyindent     " copy the previous indentation on autoindenting
set shiftround     " use multiple of 'sw' when indenting with '<' and '>'
set smarttab       " insert tabs on start of line acc to 'sw' not 'ts'

" --> auto-format comments, & insert comment markers where required
set formatoptions+=cro
set formatoptions+=q
if v:version > 730
  silent! set formatoptions+=j " remove comment markers when joining lines
endif

" --> add various plugins to help with writing code
Plug 'tpope/vim-endwise'      " add block-level end statements on auto
Plug 'kana/vim-smartinput'    " add/remove punctuation pairs when typing
Plug 'tpope/vim-commentary'   " add/remove comments for various langs
Plug 'AndrewRadev/switch.vim' " switch b/w alternate forms of code segments
Plug 'tsaleh/vim-align'       " align code segments quicker
nnoremap - :Switch<cr>

" --> add support for code tags and searching/discovering them
set tags+=./tags,tags;/         " find and load tags file up until root
nnoremap <silent> <leader>j :tnext<cr>zt
nnoremap <silent> <leader>J :tprev<cr>zt
nnoremap <silent> <leader>k :pop<cr>zt

" --> map <C-\> to view tag definition for current word in a vertical split
map <C-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" --> allow using multiple syntax/file types in a single file
Plug 'vim-scripts/SyntaxRange'

" --> provide projections based project-wide configurations
"     NOTE: specially, useful if using Ruby group of VIM config
Plug 'tpope/vim-projectionist'

" needed by other sections
augroup setup_whitespace | au! | augroup end
augroup exceeded_text_width | au! | augroup end

" }}}

" Code Linting And Async Tasks   {{{
" --> " used by other sections
augroup jobs_and_tasks | au! | augroup end

" --> start builds, test suites and linting in the background (async)
Plug 'neomake/neomake'
let g:neomake_open_list = 2
autocmd! BufWritePost * Neomake
Plug 'tpope/vim-dispatch'
nnoremap <F5> <silent> :Dispatch!<CR>

" --> auto format code whenever it is written
Plug 'Chiel92/vim-autoformat'
noremap <F4> :Autoformat<CR>
" Customize: enable auto formatting on all buffers when you write:
" augroup auto_format
"   au!
"   au BufWrite * :Autoformat
" augroup END

" }}}

" Indentation Guides             {{{
" --> enable indentation guides via Plugin
Plug 'nathanaelkane/vim-indent-guides'
let g:indent_guides_guide_size  = 1
let g:indent_guides_start_level = 2

" --> provide a toggle key for displaying indentation guides
nmap <silent> <Leader>tig <Plug>IndentGuidesToggle

" }}}

" C/C++                          {{{
" --> enable auto completion for C
augroup omni_complete
  if exists('+omnifunc')
    autocmd filetype c setlocal omnifunc=ccomplete#Complete
  end
augroup end

" --> run current file (if script) when <F5> is pressed
augroup jobs_and_tasks
  au BufRead,BufEnter *.c,*.cpp if executable(expand("%:p")) &&
        \ ( &makeprg == "make" ) | setl makeprg=%:p | endif
augroup end

" }}}

" Marks                          {{{
" --> provide toggle key to display all avialable location marks in gutter
Plug 'xsunsmile/showmarks'
let g:showmarks_enable = 0
map <silent> <leader>tsm :ShowMarksToggle<CR>
"
" following mappings are available, as well:
"   <leader>mt : Toggles ShowMarks on and off.
"   <leader>mh : Hides an individual mark.
"   <leader>ma : Hides all marks in the current buffer.
"   <leader>mm : Places the next available mark.

" }}}

" Spell                          {{{
" --> disable spell check by default
if has('spell') | set nospell | endif

" --> use default word list provided by the OS
if has('spell')
  set dictionary=/usr/share/dict/words
  set spellfile=~/.vim/spell/public.utf-8.add,~/.vim/spell/private.utf-8.add
endif

" --> manually added words are sent to `private` dictionary
if has('spell') | nnoremap zG 2zg | endif

" }}}

" Clipboard                      {{{
" --> provide mapping to turn on a dedicate mode for pasting clipboard
set pastetoggle=<F2>

" --> provide mapping to paste code, format it and select it for further operations
function! PasteWithPasteMode(keys)
  if &paste
    execute("normal " . a:keys)
  else
    " Enable paste mode and paste the text, then disable paste mode.
    set paste
    execute("normal " . a:keys)
    set nopaste
  endif
endfunction
nnoremap <silent> <leader>p :call PasteWithPasteMode('p')<CR>`[v`]=`[v`]
nnoremap <silent> <leader>P :call PasteWithPasteMode('P')<CR>`[v`]=`[v`]

" --> share clipboard between VIM and OS
if g:is_nix && has('unnamedplus')
  set clipboard=unnamedplus,unnamed
else
  set clipboard+=unnamed
endif

" --> store and cycle through previous clipboard entries
Plug 'maxbrunsfeld/vim-yankstack'
let g:yankstack_map_keys = 0           " we will remap keys

" --> provide mapping to cycle through previous pastes
nmap <leader>pc <Plug>yankstack_substitute_older_paste

" --> provide mapping to view all clipboard entries
nnoremap <leader>tys :Yanks<CR>

" --> provide mapping to reselect text that was just selected (or pasted)
nnoremap <leader>gv `[v`]

" --> replace text when pasting in visual mode
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" }}}

" Status Line                    {{{
" --> define whether to enable tabline? (default: true)
let g:enable_tabline = 1

set cmdheight=2                 " use a status bar that is 2 rows high
set laststatus=2                " tell VIM to always put a status line in

" --> report number of lines changed by a command whenever possible
set report=0

" --> abbreviate messages provided by VIM (no 'hit enter') :)
set shortmess+=filmnrxoOtT

" --> do not show vim mode anywhere else (statusline will do that for you)
set noshowmode

" --> show ruler and other relevant information in statusline
if has('cmdline_info')
  set ruler                     " Show the ruler
  set showcmd                   " show (partial) command in the last line of the screen
  set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
endif

" --> use/fallback to a simple statusline when Airline is disabled
if has('statusline') && !exists('g:loaded_airline')
  set stl=\ \ \[_%{mode()}_]\ \ \ [%Y/%{&ff}]\ %F\ %m%r\
        \ %=[%{g:ui_type}]\ %-17.(%l,%c%V%)\ %p\%\%\ \ \ %LL\ TOTAL
endif

" --> provides a beautiful status line for VIM via Airline
Plug 'bling/vim-airline'
let g:airline_inactive_collapse = 1

" --> set a default status line theme
if !exists('g:airline_theme') | let g:airline_theme = 'gruvbox' | endif
if !is_gui | let g:airline_theme = 'dark' | endif

" --> provide an optional tabline for tabs
if g:enable_tabline && exists('g:loaded_airline')
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#show_buffers = 0
  let g:airline#extensions#tabline#tab_min_count = 2
  let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
  let g:airline#extensions#tabline#show_tab_type = 0
  let g:airline#extensions#tabline#show_close_button = 1
  let g:airline#extensions#tabline#left_sep = ''
  let g:airline#extensions#tabline#left_alt_sep = ''
  let g:airline#extensions#tabline#right_sep = ''
  let g:airline#extensions#tabline#right_alt_sep = ''
  let g:airline#extensions#tabline#excludes = ['*NERD*', '*Tagbar*', 'ControlP']
endif

" auto commands
augroup startup_screen
  au User Startified AirlineRefresh
augroup end

" }}}

" Git                            {{{
" --> run git commands from within the editor
Plug 'tpope/vim-fugitive'

" --> display git diff for current buffer in gutter
Plug 'airblade/vim-gitgutter'
let g:gitgutter_enabled = 1      " enable gitgutter by default
let g:gitgutter_signs = 0        " but do not display signs by default
let g:gitgutter_diff_args = '-w' " ignore whitespace
let g:gitgutter_escape_grep = 1  " use the raw grep command
let g:gitgutter_realtime = 0     " let vim be snappier - don't lag.
let g:gitgutter_eager = 0        " do not lag
let g:gitgutter_map_keys = 0     " we will remap mappings
nmap ]h <Plug>GitGutterNextHunk<Plug>GitGutterPreviewHunk
nmap [h <Plug>GitGutterPrevHunk<Plug>GitGutterPreviewHunk
nmap <leader>hs  <Plug>GitGutterStageHunk
nmap <leader>hr  <Plug>GitGutterRevertHunk
nmap <leader>tgg :GitGutterSignsToggle<CR>

" --> manage Github Gists within the editor
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'
let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_post_private = 0
let g:gist_get_multiplefile = 1
let g:gist_show_privates = 1
let g:github_user = $GITHUB_USER
let g:github_token = $GITHUB_TOKEN
let g:snips_author = "$NAME <$EMAIL>"

" --> provide repository viewer similar to `gitk`
Plug 'gregsexton/gitv'

" --> highlight conflict markers & provide mapping to jump to them
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
nmap <silent> <leader>co /^\(<\\|=\\|>\)\{7\}\([^=].\+\)\?$<CR>

" --> enable spell check and formatting options for Git commit buffers
augroup git_files
  au!
  autocmd BufRead,BufNewFile GHI_* set ft=gitcommit
  autocmd FileType gitcommit setlocal spell textwidth=72
augroup end

" }}}

" Filetype Detection             {{{
" --> detect correct file types for common extensions
Plug 'sheerun/vim-polyglot'
augroup detect_filetypes | au! | end

" }}}

" Markdown/TextMarkups           {{{
" --> enable runtimes for markdown and textile formats
Plug 'tpope/vim-markdown'
Plug 'timcharper/textile.vim'

" --> prefer Github flavored Markdown syntax
Plug 'jtratner/vim-flavored-markdown'

" --> detect correct file types for various markup file extensions
augroup detect_filetypes
  au BufNewFile,BufRead *.yml,*.yaml setl ft=yaml
  au BufNewFile,BufRead *.md,*.mdown,*.markdown setl ft=ghmarkdown
augroup end

" --> highlight YAML front matter as comments
augroup yaml_front_matter
  au!
  au filetype ghmarkdown,textile syntax region frontmatter start=/\%^---$/ end=/^---$/
  au filetype ghmarkdown,textile highlight link frontmatter Comment
augroup end

" --> enable auto completion for markdown
augroup omni_complete
  if exists('+omnifunc')
    autocmd filetype ghmarkdown setlocal omnifunc=htmlcomplete#CompleteTags
  end
augroup end

" --> set whitespace settings for markup files
augroup setup_whitespace
  au filetype rst        setl ts=4 sw=4 sts=4 tw=74 et
  au filetype yaml       setl ts=2 sw=2 sts=2 tw=72 et
  au filetype ghmarkdown setl ts=4 sw=4 sts=4 tw=72 et
  au filetype textile    setl ts=4 sw=4 sts=4 tw=72 et
  au filetype ghmarkdown,textile,text,rst setl nolist
augroup end

" --> dictate how to create folds for markup files
augroup create_folds
  au filetype yaml setl fdm=marker fmr={{{,}}} fdls=0 fdl=0
augroup end

" --> turn on spell checking and automatic wrap for text markup files
augroup text_files
  au!
  au filetype ghmarkdown             setl formatoptions+=w
  au filetype ghmarkdown,textile,rst setl formatoptions+=qat
  au filetype ghmarkdown,textile,rst setl formatoptions-=cro
  au filetype ghmarkdown,textile,rst setl wrap wrapmargin=2
augroup end

" --> warns when text width exceeds predefined width in RST files
augroup exceeded_text_width
  au filetype rst match ErrorMsg '\%>74v.\+'
augroup end

" --> open HTML converted markups files when <F5> is pressed
augroup jobs_and_tasks
  au filetype rst setl makeprg=rst2html.py\ %\ /tmp/%:r.html\ &&\ open\ /tmp/%:r.html
  au filetype ghmarkdown setl makeprg=rdiscount\ %\ >\ /tmp/%:r.html\ &&\ open\ /tmp/%:r.html
augroup end

" }}}

" Search                         {{{
" --> provide smart search and search as we type
set ignorecase                  " makes searches ignore case
set smartcase                   " if pattern has uppercase, be case-sensitive
set wrapscan                    " search continues after the end of file
set magic                       " use magic mode when searching/replacing
set gdefault                    " search/replace globally (on a line) by default
set incsearch                   " show search matches as you type
if g:is_gui || &t_Co > 2 | set hlsearch | endif
Plug 'vim-scripts/IndexedSearch'
nmap <silent> <leader><cr> :nohlsearch<CR>

" --> search word under cursor using <*> or <#> keys in normal/visual mode
Plug 'nelstrom/vim-visual-star-search'

" --> provide smart replace that affects multiple variants of a word
"     - supports converting to and from snake_case, camelCase, etc.
Plug 'tpope/vim-abolish'

" --> prefer `pt` or `ag` over `ack` for searching
if executable('pt')
  Plug 'rking/pt.vim'
  let g:ptprg='pt --vimgrep -S'
  set grepprg=pt\ --vimgrep\ -S
  nnoremap <leader>a :Pt <Space>
elseif executable('ag')
  Plug 'rking/ag.vim'
  let g:agprg='ag --vimgrep -S'
  set grepprg=ag\ --vimgrep\ -S
  nnoremap <leader>a :Ag <Space>
elseif executable('ack')
  Plug 'mileszs/ack.vim'
  nnoremap <leader>a :Ack --smart-case<Space>
endif

" --> provide mapping to jump to lines with word under cursor
"     FIXME: when quitting from this command via <Esc>, it takes us to the first
"            match, instead of keeping the cursor in place.
nmap <Leader>fs [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

" --> provide mapping to replace word under cursor
nmap <leader>fr :%s#\<<C-r>=expand("<cword>")<CR>\>#

" }}}

" Code Documentation             {{{
" --> provide documentation for code/files via <K> key
Plug 'Keithbsmiley/investigate.vim'
map K :call investigate#Investigate()<CR><CR>

" --> avoid accidental hits of <F1> while aiming for <Esc>
noremap  <F1> :echom "Use ". &keywordprg ." OR press 'K' to get help."<CR><Esc>
noremap! <F1> <Esc>:echom "Use ". &keywordprg ." OR press 'K' to get help."<CR><Esc>a

" --> use 3rd party applications for viewing documentation if available
let g:investigate_use_dash=1
" NOTE: This does not work at the moment, as 'open' encodes the URL wrongly.
" map docs for the following languages to http://devdocs.io
" for fs in [ 'c', 'cpp', 'css', 'django', 'go', 'haskell', 'html',
"           \ 'javascript', 'php', 'python', 'ruby', 'rails' ]
"   execute( 'let g:investigate_url_for_'.fs.'="http://devdocs.io/#q='.fs.' ^s"')
" endfor
" let g:investigate_url_for_coffee = 'http://devdocs.io/#q=coffeescript ^s'

" }}}

" File Navigation                {{{
" --> provide <Tab> key completion for paths just like Bash
set wildmenu
set wildmode=list:longest,full      " show a list when pressing tab, then longest common part and then full name.
set wildignore+=*/.hg/*,*/.svn/*    " stuff to ignore when tab completing
set wildignore+=*vim/backups*       " ...
set wildignore+=*/smarty/*          " ...
set wildignore+=*/node_modules/*    " ...
set wildignore+=*/.sass-cache/*     " ...
set wildignore+=*/tmp/*,tmp/**      " ...
set wildignore+=*/out/**,log/**     " ... phew!!
" file suffixes that can be safely ignored for file name completion
set suffixes+=.swo,.d,.info,.aux,.log,.dvi,.pdf,.bin,.bbl,.blg,.DS_Store,.class,.so
set suffixes+=.brf,.cb,.dmg,.exe,.ind,.idx,.ilg,.inx,.out,.toc,.pyc,.pyd,.dll,.zip
set suffixes+=.gem,.pdf,.avi,.mkv,.psd

" --> provide a fuzzy finder for files, buffers, tags, etc.
Plug 'kien/ctrlp.vim'
" notes:
"   - when CtrlP window is open:
"   : f5 will clear the CtrlP cache (useful if you add new files during the session)
"   : <C-f> & <C-b> will cycle between CtrlP modes
"   : Press <c-d> to switch to filename only search instead of full path.
"   : Press <c-r> to switch to regexp mode.
"   : Use <c-j>, <c-k> or the arrow keys to navigate the result list.
"   : Use <c-t> or <c-v>, <c-x> to open the selected entry in a new tab or in a new split.
"   : Use <c-n>, <c-p> to select the next/previous string in the prompt's history.
"   : Use <c-y> to create a new file and its parent directories.
"   : Use <c-z> to mark/unmark multiple files and <c-o> to open them.
"
" Set no max file limit
let g:ctrlp_max_files = 0
" Ignore files matching the following patterns
let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$'
" Store cache in this directory
let g:ctrlp_cache_dir = expand("~/.vim") . "/tmp/cache/ctrlp"
" Use pt/ag in CtrlP for listing files. Lightning fast and respects .gitignore
if executable("ag") | let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""' | endif
if executable("pt") | let g:ctrlp_user_command = 'pt %s -l --nocolor -g ""' | endif
map <C-b> :CtrlPBuffer<CR>
map <C-o> :CtrlP %:p:h<CR>
nnoremap <leader>. :CtrlPTag<cr>

" --> provide a feature-rich file explorer in a sidebar
let g:netrw_silent = 1
let g:netrw_quiet  = 1
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
let NERDTreeWinPos = "left"        " nerdtree should appear on left
let NERDTreeWinSize = 25           " nerdtree window must be 25 char wide
let NERDTreeStatusLine = -1        " do not use the default status line
let NERDTreeDirArrows          = 1 " display fancy arrows instead of ASCII
let NERDTreeMinimalUI          = 0 " I don't like the minimal UI, nerdtree!
let NERDTreeShowFiles          = 1 " show files as well as dirs
let NERDTreeShowHidden         = 1 " show hidden files, too.
let NERDTreeShowBookmarks      = 1 " oh, and obvously, the bookmarks, too.
let NERDTreeCaseSensitiveSort  = 1 " sorting of files should be case sensitive
let NERDTreeRespectWildIgnore  = 1 " ignore files ignored by `wildignore`
let NERDTreeChDirMode          = 2 " change CWD when tree root is changed
let NERDTreeMouseMode          = 2 " use single click to fold/unfold dirs
let NERDTreeQuitOnOpen         = 0 " do not quit on opening a file from tree
let NERDTreeAutoDeleteBuffer   = 1 " delete buffer when deleting the file
let NERDTreeHighlightCursorline= 1 " highlight the current line in tree
let NERDTreeBookmarksFile      = expand("~/.vim") . "/tmp/bookmarks"
let g:nerdtree_tabs_open_on_gui_startup=0
let g:nerdtree_tabs_open_on_console_startup=0
" Sort NERDTree to show files in a certain order
let NERDTreeSortOrder = [ '\/$', '\.rb$', '\.php$', '\.py$',
      \ '\.js$', '\.json$', '\.css$', '\.less$', '\.sass$', '\.scss$',
      \ '\.yml$', '\.yaml$', '\.sh$', '\..*sh$', '\.vim$',
      \ '*', '.*file$', '\.example$', 'license', 'LICENSE', 'readme', 'README',
      \ '\.md$', '\.markdown$', '\.rdoc$', '\.txt$', '\.text$', '\.textile$',
      \ '\.log$', '\.info$' ]
" Don't display these kinds of files
let NERDTreeIgnore = [ '\.pyc$', '\.pyo$', '\.py\$class$', '\.obj$', '\.o$',
      \ '\.so$', '\.egg$', '^\.git$', '^\.hg$', '^\.svn$', '^\.DS_Store',
      \ '\.png$', '\.jpg$', '\.jpeg$', '\.bmp$', '\.svg$', '\.gif$',
      \ '\.zip$', '\.gz$', '\.lock$', '\.swp$', '\.bak$', '\~$' ]
" mappings
nmap <leader>ntf <leader>nto<C-w>p:NERDTreeFind<CR>
nmap <leader>ntc :NERDTreeClose<CR>
nmap <leader>nto :NERDTreeFocus<CR>:vertical resize 25<CR>

" }}}

" Buffers And Windows            {{{
" --> prefer to hide buffers instead of closing them
set hidden

" --> provide sensible split editing behaviour
set splitbelow              " puts new split windows to the bottom of the current
set splitright              " puts new vsplit windows to the right of the current
set equalalways             " split windows are always of eqal size
set switchbuf=useopen,split " use existing buffer or else split current window
set winheight=7             " squash splits or windows to a separator when minimized
set winwidth=30             " squash splits or windows to a separator when minimized
set winminheight=3          " squash splits or windows to a status bar only when minimized
set winminwidth=12          " squash splits or windows to a separator when minimized

" --> resize splits when the window is resized
augroup resize_splits
  au!
  au VimResized * :wincmd =
augroup end

" --> do not open more than 15 tabs (one tab/file) from CLI
set tabpagemax=15

" --> provide mapping and command to toggle QuickFix window using '<leader>qf'
function! QFixToggle(forced)
  if exists("g:qfix_win") && a:forced == 0
    cclose
    unlet g:qfix_win
  else
    copen 10
    let g:qfix_win = bufnr("$")
  endif
endfunction
command! -bang -nargs=? QFix call QFixToggle(<bang>0)
nmap <silent> <leader>qf :QFix<CR>

" --> provide mappings to resize splits/windows quickly
map <C-W><C-=> <C-W>=
map <C-W><C-M> <C-W>999+<C-W>999>

" --> provide mappings for easier split navigation
map <C-H> <C-W>h
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-L> <C-W>l

" --> provide mappings to navigate to a window and maximize it
map <C-W><C-H> <C-W>h<C-W><bar>
map <C-W><C-J> <C-W>j<C-W>_
map <C-W><C-K> <C-W>k<C-W>_
map <C-W><C-L> <C-W>l<C-W><bar>
map <C-W><C-T> <C-W>T

" --> provide mapping to switch/rotate window layouts
map <C-W><space> <C-W>t<C-W>J<C-W>t<C-W>H

" --> provide mappings to jump to a specific buffer
nnoremap <leader>el :buffers<CR>:buffer<Space>
nnoremap <leader>e3 :e#

" --> provide mapping to split, load the current buffer and switch to it
nnoremap <leader>wh <C-w>s
nnoremap <leader>wv <C-w>v<C-w>l

" --> provide mapping to split, load the previous buffer and switch to it
nnoremap <leader>ph :execute 'rightbelow split' bufname('#')<cr>
nnoremap <leader>pv :execute 'leftabove vsplit' bufname('#')<cr>

" --> speed up scrolling of the viewport slightly
nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>

" }}}

" Snippets                       {{{
" --> provide snippet extensions when editing code
Plug 'Shougo/neosnippet'
Plug 'honza/vim-snippets'
Plug 'Shougo/neosnippet-snippets'
" enable snipmate compatibility for neosnippet
let g:neosnippet#enable_snipmate_compatibility = 1
" tell NeoSnippet about other snippets
let g:neosnippet#snippets_directory = [
      \ expand('~/.vim') . '/bundle/vim-snippets/snippets',
      \ expand('~/.vim') . '/data/snippets' ]

" --> provide mapping to edit snippets for current file type
noremap <leader>nse :NeoSnippetEdit -vertical -split -direction=belowright<CR>

" --> allow <Tab> key to jump between snippet placeholders
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)"
      \ : pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)"
      \ : "\<TAB>"

" }}}

" Miscelleneous                  {{{
" --> provide syntax highlighting and filetype detection for CSV files
Plug 'vim-scripts/csv.vim'

" --> detect correct file types for various file extensions
augroup detect_filetypes
  " elixir
  au BufNewFile,BufRead *.ex,*.exs setl ft=elixir
  au BufNewFile,BufRead *.html.eex setl ft=html
augroup end

" --> enable auto completion for various file types
augroup omni_complete
  if exists('+omnifunc')
    autocmd filetype xml setlocal omnifunc=xmlcomplete#CompleteTags
    autocmd filetype java setlocal omnifunc=javacomplete#Complete
    autocmd filetype haskell setlocal omnifunc=necoghc#omnifunc
  end
augroup end

" --> set whitespace settings for various file types
augroup setup_whitespace
  au filetype make  setl noet " make uses real tabs
augroup end

" --> dictate how to create folds for various file types
augroup create_folds
  au filetype conf setl fdm=marker fmr={{{,}}} fdls=0 fdl=0
augroup end

" }}}

call plug#end()
colorscheme monokai
let g:airline_theme='nova'
" --> Personalize: allows customizations via a local configuration
if filereadable(expand("~/.vimrc.local")) | source ~/.vimrc.local | endif
