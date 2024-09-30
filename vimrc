syntax on
set encoding=utf-8
set background=dark
set t_Co=256
let g:solarized_termtrans=1
colorscheme solarized
set autoindent
set sw=2
set ts=2
set expandtab
set number
set linebreak

set shell=bash

set guioptions-=m
set guioptions-=T
"For autocompletion
set wildmode=list:longest

set foldenable
set splitbelow
set splitright
set hlsearch

set nobackup
set nowritebackup
set noswapfile

set nocompatible
filetype plugin indent on

nmap ,ev :tabedit $MYVIMRC<cr>
nmap <space> :
imap ,e <esc>
vmap ,e <esc>

autocmd bufwritepost .vimrc source $MYVIMRC

imap ,<tab> <C-x><C-o>

"NERDTree options
nmap ,nt :NERDTreeToggle
:let NERDTreeQuitOnOpen = 0
:let NERDTreeShowBookmarks = 1 "automatically show Bookmarks
:let NERDTreeChDirMode = 2 "change vim directory when open directory in NERDTree

"html5 tags in .erb files
autocmd BufRead,BufNewFile *.erb set filetype=eruby.html

"Ruby tab to space convention
autocmd FileType ruby set tabstop=2|set shiftwidth=2|set expandtab

"Haskell
au BufEnter *.hs compiler ghc

let g:haddock_browser = "/usr/bin/google-chrome"
let g:ghc = "/usr/bin/ghc"
let g:haddock_docdir = "/usr/share/doc/ghc-doc/html/"

"move by visual lines (not logical ones)
noremap  k gk
noremap  j gj
noremap  0 g0
noremap  $ g$

"map leader key
let mapleader = "-"
let maplocalleader = "<"

"cycle through buffers with tab / shift-tab
noremap <Tab> :bnext<CR>
noremap <S-Tab> :bprevious<CR>

"make command-T ignore a number of unimportant files
set wildignore+=*.class,.git,.hg,.svn,target/**

"status line
set laststatus=2
set statusline=%F%m%r%h%w\ %{fugitive#statusline()}\ [%l,%c]\ [%L,%p%%]

""""
" ruby testing with -s
"
""""
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'))
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>n :call RenameFile()<cr>

" Run specs with '-s' via Gary Bernhardt
function! RunTests(filename)
  " Write the file and run tests for the given filename
  :w
  :silent !clear
  if match(a:filename, '\.feature$') != -1
    exec ":!script/features " . a:filename
  elseif match(a:filename, '_test\.rb$') != -1
    exec ":!ruby -Itest " . a:filename
  else
    if filereadable("script/test")
      exec ":!script/test " . a:filename
    elseif filereadable("Gemfile")
      exec ":!bundle exec rspec --color " . a:filename
    else
      exec ":!rspec --color " . a:filename
    end
  end
endfunction

function! SetTestFile()
  " Set the spec file that tests will be run for.
  let t:grb_test_file=@%
endfunction

function! RunTestFile(...)
  if a:0
    let command_suffix = a:1
  else
    let command_suffix = ""
  endif

  " Run the tests for the previously-marked file.
  let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_test.rb\)$') != -1
  if in_test_file
    call SetTestFile()
  elseif !exists("t:grb_test_file")
    return
  end
  call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
  let spec_line_number = line('.')
  call RunTestFile(":" . spec_line_number . " -b")
endfunction

" run test runner
map <leader>s :call RunTestFile()<cr>
map <leader>S :call RunNearestTest()<cr>

runtime macros/matchit.vim

" lookup paths (for gf, :find etc.)
autocmd FileType ruby setlocal path+=. " directory of current file + working directory
autocmd FileType ruby setlocal path+=lib/

" instant markdown: slow down
let g:instant_markdown_slow = 1

" single compile
nmap <F9> :SCCompile<cr>
nmap <F10> :SCCompileRun<cr>

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" javascript
let g:used_javascript_libs = 'underscore,jquery,chai,handlebars'

" whitespace
function! TrimWhiteSpace()
  %s/\s\+$//e
endfunction
autocmd BufWritePre * :call TrimWhiteSpace()

set backspace=2

let g:rainbow_active = 1
let g:rainbow_conf = {
\  'ctermfgs': ['blue', 'green', 'red', 'magenta']
\}

" nohlsearch
nmap <leader>h :nohlsearch<cr>

" add byebug
nmap <leader>bb O<C-R> require 'byebug'; byebug<esc>

" vim session shortcuts
map <leader>w :mksession! ~/.vim_session<cr>
map <leader>l :source ~/.vim_session <cr>

" code blocks in markdown
let g:markdown_fenced_languages = ['java', 'kotlin', 'javascript', 'sh']

" presenting
let g:presenting_figlets=0
