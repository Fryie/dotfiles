call pathogen#infect()
call pathogen#helptags()

syntax on
colorscheme github
set guifont=Inconsolata\ 14
set smartindent
set autoindent
set sw=2
set ts=2
set expandtab
set number
set linebreak

set shell=zsh

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

"cycle through buffers with tab / shift-tab
noremap <Tab> :bnext<CR>
noremap <S-Tab> :bprevious<CR>

"make command-T ignore a number of unimportant files
set wildignore+=*.class,.git,.hg,.svn,target/**

"command-T flush shortcut
noremap <Leader>f :CommandTFlush<CR> 

"nexus files
autocmd BufRead,BufNewFile *.nex set syntax=nexus|set nowrap
autocmd BufRead,BufNewFile *.nex.* set syntax=nexus|set nowrap

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
