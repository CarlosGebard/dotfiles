return {
  "ellisonleao/glow.nvim",
  config = true,
  opts = {
    style = "dark", -- o "light"
    width = 120, -- Ancho máximo de la envoltura de texto
    glow_path = "glow", -- Ruta al ejecutable de glow

    -- Cambiar el modo de ventana a 'split' o 'vsplit' en lugar de 'floating'
    -- Si tu versión no soporta 'split', puedes estirar el 'floating' al 100%
    width_ratio = 0.95, -- Toma casi el 100% del ancho
    height_ratio = 0.95, -- Toma casi el 100% del alto
  },
}
