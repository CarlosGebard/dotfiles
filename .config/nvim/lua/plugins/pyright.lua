return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "basic",
                diagnosticMode = "openFilesOnly",

                reportAny = "none",
                reportExplicitAny = "none",

                reportUnknownVariableType = "none",
                reportUnknownMemberType = "none",
                reportUnknownArgumentType = "none",

                reportUnusedImport = "none",
                reportUnusedVariable = "none",

                reportMissingTypeStubs = "none",
              },
            },
          },
        },
      },
    },
  },
}
