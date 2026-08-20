return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-mini/mini.icons",
  },
  ---@module "render-markdown"
  ---@type render.md.UserConfig
  opts = {
    enabled = true,
    render_modes = { "n", "c", "t" },
    preset = "lazy",
  },
}
