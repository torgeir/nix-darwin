{ config, lib, pkgs, ... }:

{
  home.file = { ".vimrc".source = ./config/vimrc; };

  programs.neovim = {

    enable = true;

    # alias vim=nvim
    vimAlias = true;

    extraConfig = (builtins.readFile ./config/vimrc);

    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/vim-plugin-names
    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim

      editorconfig-vim

      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects

      vim-nix
      vim-surround
      vim-commentary

      {
        plugin = lightline-vim;
        config = ''
          source ${./config/lightline.vim}
          let g:lightline = {'colorscheme': 't'}
        '';
      }

      {
        plugin = nerdtree;
        config = ''
          nnoremap <leader>fl :NERDTreeToggle<cr>
          nnoremap <leader>fL :NERDTreeFind<cr>
          let NERDTreeShowHidden=1
        '';
      }
      {
        plugin = fzf-vim;
        config = ''
          " let $FZF_DEFAULT_COMMAND = "fd --type f --hidden -E '.git'"
          nnoremap <leader>t  :FZF<cr>
          nnoremap <leader>sp :Rg<cr>
          nnoremap <leader>,  :Buffers<cr>
          nnoremap <leader>bb :Buffers<cr>
          nnoremap <leader>bd :bd<cr>
          nnoremap <leader>ss :BLines<cr>
          nnoremap <leader>bB :Windows<cr>
          nnoremap <leader>ff :Files<cr>
          nnoremap <leader>ht :Colors<cr>
          nnoremap <leader>hh :Helptags<cr>
          nnoremap <leader>gg :Changes<cr>
          nnoremap <leader>gl :Commits<cr>
          nnoremap <leader>oT :terminal<cr>

          nnoremap <leader>hrr :source ~/.config/nvim/init.lua<cr>
        '';
      }
    ];
  };
}
