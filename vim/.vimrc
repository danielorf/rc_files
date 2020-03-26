let PLUGIN_DIR = "~/.vim/plugged"
let PLUGIN_CONFIG_LOCATION = "~/.vim/.plugin_config.vim"

" auto-install vim-plug and plugins
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin()
Plug 'scrooloose/nerdtree',
Plug 'racer-rust/vim-racer'
" Complete install following this: apt install build-essential cmake vim python3-dev
" apt install build-essential cmake vim python3-dev
" cd ~/.vim/plugged/youcompleteme
" python3 install.py --all
Plug 'valloric/youcompleteme'
call plug#end()

if !empty(globpath(PLUGIN_DIR, '*'))
  execute 'source' PLUGIN_CONFIG_LOCATION
endif

set hidden
let g:racer_cmd = "/home/dorf/.cargo/bin/racer"
let g:racer_experimental_completer = 1
let g:racer_insert_paren = 1

