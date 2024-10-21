" Set the colorscheme name
" colorscheme Yaru

" Vim color scheme


set background=dark

hi clear
if exists('syntax_on')
   syntax reset
endif

let g:colors_name = 'ubuntu'

" Define the color palette
hi Normal guifg=#ffffff guibg=#1f1f1f
hi Visual guifg=#ffffff guibg=#444444
hi NonText guifg=#666666 guibg=#1f1f1f
hi CursorLine guibg=#262626
hi CursorColumn guibg=#262626
hi LineNr guifg=#666666 guibg=#1f1f1f
hi StatusLine guifg=#ffffff guibg=#1f1f1f
hi TabLine guifg=#ffffff guibg=#1f1f1f

" Define syntax highlighting colors (adjust as needed)
hi Comment guifg=#666666
hi String guifg=#d46ff1
hi Number guifg=#f4a261
hi Keyword guifg=#4caf50
hi Function guifg=#2196f3
hi Identifier guifg=#ffffff
hi NonText guibg=NONE cterm=NONE
