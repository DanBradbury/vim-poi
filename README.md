# vim-poi

vim-poi, points of interest, allows you to highlight lines when in visual mode.

![](http://i.imgur.com/kqbHMjA.gif)

## Installation

### Pathogen
I recommend installing [pathogen.vim](https://github.com/tpope/vim-pathogen) if you don't have a installation method yet, and
then run the following commands.

```
cd ~/.vim/bundle
git clone https://github.com/DanBradbury/vim-poi.git
```

## Usage
Add the following to your .vimrc to get started

```vim
"Highlight line(s)
vnoremap <Leader>h  :PoiLines<CR>
nnoremap <Leader>h  :PoiLine<CR>
"Remove all highlights from current buffer
nnoremap <Leader>hc :PoiClear<CR>
"Open a quickfix menu to preview all highlights across all buffers
nnoremap <Leader>hp :PoiPreview<CR>

" Use custom colors (gui*_colors are not required)
let g:poi_colors = [ 'ctermbg_color', 'ctermfg_color', 'guibg_color', 'guifg_color' ]
```

