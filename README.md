# vim-poi
> vim-poi (points of interest), makes it easy to highlight an important line or block of code (ideal for pair programming / visualizing complex code paths). Highlights are unique to the buffer and can be snapped to anywhere in the session using the `:PoiPreview` quickfix window.
![](http://i.imgur.com/lNgmGme.gif)

*High contrast colors have been selected for optimal viewing experience across all versions of vim.*

## Installation

### Pathogen
If you don't have an installation method yet, give [pathogen.vim](https://github.com/tpope/vim-pathogen) a shot and copy paste the following:

```
cd ~/.vim/bundle
git clone https://github.com/DanBradbury/vim-poi.git
```

## Usage
Add the following to your .vimrc to get started ([wiki article](https://github.com/DanBradbury/vim-poi/wiki/Command-Reference) for more details on each command)

```vim
nnoremap <Leader>p :PoiLine<CR>
nnoremap <Leader>p2 :PoiLine2<CR>
nnoremap <Leader>p3 :PoiLine3<CR>
nnoremap <Leader>p4 :PoiLine4<CR>
vnoremap <Leader>p :PoiLines<CR>
vnoremap <Leader>p2 :PoiLines2<CR>
vnoremap <Leader>p3 :PoiLines3<CR>
vnoremap <Leader>p4 :PoiLines4<CR>
nnoremap <Leader>pc :PoiClear<CR>
nnoremap <Leader>pd :PoiChange<CR>
vnoremap <Leader>pd :PoiRangeChange<CR>
```

## License

Copyright © Dan Bradbury.  Distributed under the same terms as Vim itself.
See `:help license`.
