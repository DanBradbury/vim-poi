# poi.vim

vim-poi, points of interest, allows users to highlight lines through visual mode. Even when the user adds new code and exits from Insert mode
the highlights you previously created will be rerendered onto the page.

## Installation
I recommend installing [pathogen.vim](https://github.com/tpope/vim-pathogen) if you don't have a installation method yet, and
then run the following commands.

    cd ~/.vim/bundle
    git clone https://github.com/DanBradbury/vim-poi.git

## Usage
Here is an example of how to get set up with `vim-poi`. You can use your own custom mappings.

    vnoremap <Leader>h  :PoiLines<CR>
    nnoremap <Leader>h  :PoiLine<CR>
    nnoremap <Leader>hc :PoiClear<CR>

You can also customize the background and foreground colors by adding the following line to your `.vimrc` file.
    let g:poi_highlight_colors = ["my_custom_color_1", "my_custom_color_2"]
