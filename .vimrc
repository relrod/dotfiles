syntax on
set smartindent
set incsearch
set nocompatible
set bs=2
set mouse=a
set ruler
set guifont=inconsolata\ 12
set ts=3
set sw=3
set expandtab

colorscheme ir_black

autocmd FileType php let php_sql_query=1
autocmd FileType php let php_htmlInStrings=1
autocmd FileType php let php_noShortTags=1

au BufNewFile,BufRead *.mxml set filetype=mxml
au BufNewFile,BufRead *.as set filetype=actionscript

set makeprg=php\ -l\ %
set errorformat=%m\ in\ %f\ on\ line\ %l

" Perl stuff
autocmd FileType perl set makeprg=perl\ -c\ %\ $*
autocmd FileType perl set errorformat=%f:%l:%m
autocmd FileType perl set makeprg=perl\ -c\ %\ $*
autocmd FileType perl set errorformat=%f:%l:%m

" Python stuff
map <buffer> <S-e> :w<CR>:!/usr/bin/env python % <CR>
autocmd BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"

" Ruby stuff
autocmd FileType ruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby let g:rubycomplete_rails = 1
autocmd FileType ruby let g:rubycomplete_classes_in_global = 1

filetype plugin indent on
highlight Pmenu ctermbg=0 gui=bold
