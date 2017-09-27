filetype off
execute pathogen#infect()
execute pathogen#helptags()
filetype plugin indent on

if has("gui_running")
  if has("gui_gtk2")
    set guifont=Inconsolata\ 12
  elseif has("gui_macvim")
    set guifont=Menlo\ Regular:h14
  elseif has("gui_win32")
    "set guifont=Bitstream_Vera_Sans_Mono:h9:cANSI:qDRAFT
    set guifont=Consolas:h9:cANSI
  endif
endif

set background=dark
colorscheme morning

syntax on

set number
