# vim-poi

vim-poi, points of interest, makes it easy to highlight important lines/sections of code. The highlights persist throughout the session and can be reviewed in the `:PoiPreview` quickfix window.

![](http://i.imgur.com/iDCpsc5.png)

*High contrast colors have been selected for optimal viewing experience across versions.*

## Installation

### Pathogen
If you don't have an installation method yet, I'd give [pathogen.vim](https://github.com/tpope/vim-pathogen) a shot

Run the following commands.

```
cd ~/.vim/bundle
git clone https://github.com/DanBradbury/vim-poi.git
```

## Usage
Add the following to your .vimrc to get started (all commands have an associated gif)

```vim
" Highlight line(s)
vnoremap <Leader>h  :PoiLines<CR>
nnoremap <Leader>h  :PoiLine<CR>
" Remove all highlights from current buffer
nnoremap <Leader>hc :PoiClear<CR>
" Change highlight color
nnoremap <Leader>hh :PoiChange <CR>
" Open a quickfix menu to preview all highlights across all buffers
nnoremap <Leader>hp :PoiPreview<CR>
nnoremap <Leader>ph :PoiHelp<CR>
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
