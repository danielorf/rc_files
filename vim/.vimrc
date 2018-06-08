filetype plugin indent on  

" Using pathogen vim pugin manager:  https://github.com/tpope/vim-pathogen
execute pathogen#infect()

" Syntax highlighting on by default:  https://stackoverflow.com/questions/11272501/enable-vim-syntax-highlighting-by-default
syntax on

" Enable NERDTree at vim startup ane move cusror to main window:  
" https://stackoverflow.com/questions/1447334/how-do-you-add-nerdtree-to-your-vimrc
autocmd vimenter * NERDTree
autocmd VimEnter * wincmd p

" Auto-closes NERDTree when closing other tab:  https://github.com/scrooloose/nerdtree/issues/21
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Line numbers on by default
set number

"Auto convert tab to 2 spaces for yaml files
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2
