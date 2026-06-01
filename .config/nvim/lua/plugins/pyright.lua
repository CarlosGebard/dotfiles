return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        basedpyright = function()
          return true -- Bloquea por completo el inicio del LSP
        end,
        pyright = function()
          return true -- Por si las dudas, bloquea también el pyright común
        end,
      },
    },
  },
}
