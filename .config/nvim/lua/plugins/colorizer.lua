return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = true,
      term_colors = true,
      no_italic = true,
      custom_highlights = function(colors)
        return {
          Comment = { fg = "#7f849c" }, -- Un gris suave para los comentarios
          Function = { fg = "#89b4fa" }, -- Azul para las funciones
          Keyword = { fg = "#cdd6f4" }, -- El color que quieras para 'return', 'if', etc.
          String = { fg = "#a6e3a1" }, -- Verde para los textos entre comillas
          Identifier = { fg = "#f38ba8" }, -- Color para tus variables
        }
      end,
      integrations = {
        telescope = {
          enabled = true,
          style = "nvchad",
        },
      },
    },
  },
}
