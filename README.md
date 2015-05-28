# vim-poi

vim-poi (points of interest), makes it easy to highlight "important" lines of code (ideal for pair programming or visualizing complex code paths). Highlights are unique to the buffer and can be accessed anywhere in the session using the `:PoiPreview` quickfix window.

![](http://i.imgur.com/lNgmGme.gif)
*High contrast colors have been selected for optimal viewing experience across all versions.*

## Installation

### Pathogen
If you don't have an installation method yet, give [pathogen.vim](https://github.com/tpope/vim-pathogen) a shot and copy paste the following:

```
cd ~/.vim/bundle
git clone https://github.com/DanBradbury/vim-poi.git
```

## Usage
Add the following to your .vimrc to get started (all commands have an associated gif)

```vim
" Highlight line(s)
vnoremap <Leader>p  :PoiLines<CR>
nnoremap <Leader>p  :PoiLine<CR>
" Remove all highlights from current buffer
nnoremap <Leader>pc :PoiClear<CR>
" Change highlight color
nnoremap <Leader>pd :PoiChange <CR>
vnoremap <Leader>pd :PoiRangeChange<CR>
" Open a quickfix menu to preview all highlights across all buffers
nnoremap <Leader>pp :PoiPreview<CR>
nnoremap <Leader>ph :PoiHelp<CR>
```

### :PoiLine
> Highlight individual line when in normal mode

![](http://i.imgur.com/7gU1bG5.gif)

### :PoiLines
> Highlight visual selection

![](http://i.imgur.com/xruRsJD.gif)

### :PoiChange
> Change the highlight color of the current line

![](http://i.imgur.com/WUPJw1z.gif)

### :PoiRangeChange
> Change the highlight color of the current visual selection

![](http://i.imgur.com/MjSsjkf.gif)

### :PoiClear
> Clear the current highlights in the current buffer

![](http://i.imgur.com/9nD3J9v.gif)

### :PoiPreview
> Open a quickfix window with all the highlights made in the current session

![](http://i.imgur.com/KWygHsl.gif)

### :PoiHelp
> Open a quickfix window showing how the plugins commands are ran

## License

Copyright © Dan Bradbury.  Distributed under the same terms as Vim itself.
See `:help license`.
