" syntax highlighting on by default
syntax on

" Line numbers on by default
set number

" nerdtree enabled at vim startup and cursor on left panel
autocmd vimenter * NERDTree
autocmd vimenter * wincmd p
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let NERDTreeShowHidden=1
let NERDTreeDirArrows=1
