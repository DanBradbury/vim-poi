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

### Vundle
If you're using [vundle](https://github.com/gmarik/Vundle.vim.git) add the following line to your `.vimrc` file.
```vim
Plugin 'DanBradbury/vim-poi'
```

and then run...

```vim
:PluginInstall
```

to install it.

## Usage
Here is an example of how to get set up with `vim-poi` with your `.vimrc` file. You can use your own custom mappings.

```vim
vnoremap <Leader>h  :PoiLines<CR>
nnoremap <Leader>h  :PoiLine<CR>
nnoremap <Leader>hc :PoiClear<CR>
nnoremap <Leader>hp :PoiPreview<CR>

" Use custom colors (gui*_colors are not required)
let g:poi_colors = [ 'ctermbg_color', 'ctermfg_color', 'guibg_color', 'guifg_color' ]
```

