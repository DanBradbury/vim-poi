# vim-poi

vim-poi, points of interest, makes it easy to highlight important lines/sections of code. The highlights persist throughout the session and can be accessed & reviewed anywhere with the `:PoiPreview` view. More information on specific commands can be found at the bottom of this file.

![](http://i.imgur.com/iDCpsc5.png)

## Installation

### Pathogen
If you don't have an installation method yet, I'd give [pathogen.vim](https://github.com/tpope/vim-pathogen) a shot

Run the following commands.

```
cd ~/.vim/bundle
git clone https://github.com/DanBradbury/vim-poi.git
```

## Usage
Add the following to your .vimrc to get started

```vim
" Highlight line(s)
vnoremap <Leader>h  :PoiLines<CR>
nnoremap <Leader>h  :PoiLine<CR>
" Remove all highlights from current buffer
nnoremap <Leader>hc :PoiClear<CR>
" Open a quickfix menu to preview all highlights across all buffers
nnoremap <Leader>hp :PoiPreview<CR>
nnoremap <Leader>ph :PoiHelp<CR>

" Use custom colors (gui*_colors are not required)
let g:poi_colors = [ 'ctermbg_color', 'ctermfg_color', 'guibg_color', 'guifg_color' ]
```

## Available Commands
#### :PoiLine
> Highlight individual line when in normal mode

![](http://i.imgur.com/7gU1bG5.gif)

#### :PoiLines
> Highlight visual selection

![](http://i.imgur.com/xruRsJD.gif)

#### :PoiClear
> Clear the current highlights in the current buffer

![](http://i.imgur.com/9nD3J9v.gif)

#### :PoiPreview
> Open a quickfix window with all the highlights made in the current session

![](http://i.imgur.com/KWygHsl.gif)

### :PoiHelp
> Open a quickfix window showing how the plugins commands are ran
