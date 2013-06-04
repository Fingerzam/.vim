set nocompatible | filetype indent plugin on | syn on

fun! EnsureVamIsOnDisk(plugin_root_dir)
    " windows users may want to use http://mawercer.de/~marc/vam/index.php
    " to fetch VAM, VAM-known-repositories and the listed plugins
    " without having to install curl, 7-zip and git tools first
    " -> BUG [4] (git-less installation)
    let vam_autoload_dir = a:plugin_root_dir.'/vim-addon-manager/autoload'
    if isdirectory(vam_autoload_dir)
        return 1
    else
        if 1 == confirm("Clone VAM into ".a:plugin_root_dir."?","&Y\n&N")
            " I'm sorry having to add this reminder. Eventually it'll pay off.
            call confirm("Remind yourself that most plugins ship with ".
                        \"documentation (README*, doc/*.txt). It is your ".
                        \"first source of knowledge. If you can't find ".
                        \"the info you're looking for in reasonable ".
                        \"time ask maintainers to improve documentation")
            call mkdir(a:plugin_root_dir, 'p')
            execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '.
                        \       shellescape(a:plugin_root_dir, 1).'/vim-addon-manager'
            " VAM runs helptags automatically when you install or update 
            " plugins
            exec 'helptags '.fnameescape(a:plugin_root_dir.'/vim-addon-manager/doc')
        endif
        return isdirectory(vam_autoload_dir)
    endif
endfun

fun! SetupVAM()
    " Set advanced options like this:
    " let g:vim_addon_manager = {}
    " let g:vim_addon_manager.key = value
    "     Pipe all output into a buffer which gets written to disk
    " let g:vim_addon_manager.log_to_buf =1

    " Example: drop git sources unless git is in PATH. Same plugins can
    " be installed from www.vim.org. Lookup MergeSources to get more control
    " let g:vim_addon_manager.drop_git_sources = !executable('git')
    " let g:vim_addon_manager.debug_activation = 1

    " VAM install location:
    let c = get(g:, 'vim_addon_manager', {})
    let g:vim_addon_manager = c
    let c.plugin_root_dir = expand('$HOME/.vim/vim-addons')
    if !EnsureVamIsOnDisk(c.plugin_root_dir)
        echohl ErrorMsg | echomsg "No VAM found!" | echohl NONE
        return
    endif
    let &rtp.=(empty(&rtp)?'':',').c.plugin_root_dir.'/vim-addon-manager'

    " Tell VAM which plugins to fetch & load:
    let $VIMHOME = $HOME."/.vim/"
    source $VIMHOME/vim-addon-manager.vim
    " sample: call vam#ActivateAddons(['pluginA','pluginB', ...], {'auto_install' : 0})

    " Addons are put into plugin_root_dir/plugin-name directory
    " unless those directories exist. Then they are activated.
    " Activating means adding addon dirs to rtp and do some additional
    " magic

    " How to find addon names?
    " - look up source from pool
    " - (<c-x><c-p> complete plugin names):
    " You can use name rewritings to point to sources:
    "    ..ActivateAddons(["github:foo", .. => github://foo/vim-addon-foo
    "    ..ActivateAddons(["github:user/repo", .. => github://user/repo
    " Also see section "2.2. names of addons and addon sources" in VAM's documentation
endfun
call SetupVAM()
" experimental [E1]: load plugins lazily depending on filetype, See
" NOTES
" experimental [E2]: run after gui has been started (gvim) [3]
" option1:  au VimEnter * call SetupVAM()
" option2:  au GUIEnter * call SetupVAM()
" See BUGS sections below [*]
" Vim 7.0 users see BUGS section [3]

let mapleader = "å"
let maplocalleader = ","

if has('gui_running')
    set background=light
else
    set background=dark
endif
"language English

set shell=/bin/bash
set encoding=utf8 hidden sw=4 ts=4 et ai si
set backspace=indent,eol,start
set backup
set backupcopy&
set backupdir=.,~/tmp
set showmatch smarttab hlsearch incsearch history=1000
set undolevels=1000 wildignore=*.swp,*.bak,*.class,*~
set title noerrorbells undofile
set cursorline
set ttyfast
set laststatus=2
set showmode
set showcmd
set nonumber
set norelativenumber
set lazyredraw
set showbreak=→
set splitbelow
set splitright
set ttimeout
set notimeout
set fillchars+=diff:\ 
set virtualedit+=block
set foldlevelstart=0
set completeopt=longest,menuone,preview

nnoremap K <nop>
nnoremap <leader>s :%s//<left>

au VimResized * exe "normal! \<c-w>="

set shiftround
set clipboard=unnamed
set autowrite

set wildmenu
set wildmode=list:longest
set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.luac                           " Lua byte code
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.pyc                            " Python byte code
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store?                      " OSX bullshi
"set fillchars+=vert:\u2502

set backupskip=/tmp/*,/private/tmp/*

noremap <leader><space> :silent :noh<cr>:match none<cr>:2match none<cr>:3match none<cr>
nnoremap n nzzzv
nnoremap N Nzzzv

noremap H ^
noremap L $

noremap Y y$

" Fold
nnoremap <leader>z zMzvzz

set viminfo+=%

set list
set listchars=tab:▸\ ,extends:❯,precedes:❮,trail:.,nbsp:.
autocmd filetype html,xml,xhtml set listchars-=tab:>.

"magic search
nnoremap / /\v
vnoremap / \v

set ignorecase smartcase
set gdefault

nnoremap <space> :
"nicer j and k on long lines
nnoremap j gj
nnoremap k gk

map <C-h> <C-w>h
map <C-l> <C-w>l
map <C-j> <C-w>j
map <C-k> <C-w>k

"save file with root permissions
cmap w!! w !sudo tee % >/dev/null

set guioptions-=L
set guioptions-=R
set guioptions-=T
set guioptions-=m
set guioptions-=r
set guioptions-=l
set guioptions+=c

"set guifont=Menlo:h12

filetype on
filetype plugin indent on

syntax on
autocmd BufWritePost vimrc source %

colorscheme solarized

" syntastic

let g:syntastic_enable_signs = 1

set statusline=
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%{fugitive#statusline()}
set statusline+=%*
set statusline+=%=(%{&ff}/%Y)

imap <S-CR> o

" fugitive
nmap <leader>gc :Gcommit<cr>
nmap <leader>ga :Gcommit -a<cr>
nmap <leader>gp :Git push<cr>
nmap <leader>gl :Git pull<cr>
nmap <leader>gr :Git pull --rebase<cr>
nmap <leader>gs :Gstatus<cr>
nmap <leader>dd :Gdiff<cr>

nmap <leader>o :CommandT<cr>

nmap <leader><leader> <c-^>

" Settings for VimClojure
let vimclojure#DynamicHighlighting=1
let vimclojure#ParenRainbow=1
let vimclojure#FuzzyIndent = 1

" fix insert mode esc with powerline in console vim
if ! has('gui_running')
    set ttimeoutlen=10
    augroup FastEscape
        autocmd!
        au InsertEnter * set timeoutlen=0
        au InsertLeave * set timeoutlen=1000
    augroup END
endif
