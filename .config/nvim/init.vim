let mapleader =","

if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'vim-airline/vim-airline-themes'
Plug 'lilydjwg/colorizer'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/goyo.vim'
Plug 'bling/vim-airline'
Plug 'vifm/vifm.vim'
Plug 'Valloric/YouCompleteMe'
call plug#end()

let g:loaded_youcompleteme = 1

set bg=dark
set go+=a
set mouse+=a
set nohlsearch
set clipboard+=unnamedplus

filetype plugin on

set nocompatible
syntax on
set encoding=utf-8
set number relativenumber

set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab

set wildmode=longest,list,full

autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

map <leader>f :Goyo \| set linebreak<CR>

map <leader>p :setlocal spell! spelllang=en_us<CR>

set splitbelow splitright

map <leader>n :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l


autocmd BufRead,BufNewFile /tmp/neomutt* let g:goyo_width=80
autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo

autocmd BufWritePre * %s/\s\+$//e

autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd

autocmd BufWritePost *Xresources,*Xdefaults !xrdb %

inoremap <c-k> <up>
inoremap <c-j> <down>
inoremap <c-h> <left>
inoremap <c-l> <right>

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme="minimalist"

set noshowmode

" Open corresponding .pdf/.html or preview
	map <leader>o :!opout <c-r>%<CR><CR>

" Navigating with guides
	inoremap <leader><leader> <Esc>/<++><Enter>"_c4l
	vnoremap <leader><leader> <Esc>/<++><Enter>"_c4l
	map <leader><leader> <Esc>/<++><Enter>"_c4l

" Compile document, be it groff/LaTeX/markdown/etc.
	map <leader>c :w! \| !compiler <c-r>%<CR>

" Ensure files are read as what I want:
    autocmd BufRead,BufNewFile *.tex set filetype=tex

autocmd FileType tex inoremap ,it \textit{}<++><Esc>T{i
autocmd FileType tex inoremap ,bxf \textbf{}<++><Esc>T{i
autocmd FileType tex inoremap ,bfp (\textbf{})<++><Esc>T{i
autocmd FileType tex inoremap ,chap \chapter{}<Enter><Enter><++><Esc>2kf}i
autocmd FileType tex inoremap ,sec \section{}<Enter><Enter><++><Esc>2kf}i
autocmd FileType tex inoremap ,subsec \subsection{}<Enter><Enter><++><Esc>2kf}i
autocmd FileType tex inoremap ,lst \begin{lstlisting}<Enter><Enter>\end{lstlisting}<Esc>kA

autocmd! User GoyoEnter nested set eventignore=FocusGained
autocmd! User GoyoLeave nested set eventignore=
