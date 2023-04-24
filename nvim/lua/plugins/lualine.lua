return {
  'nvim-lualine/lualine.nvim',
  config = {
    options = {
      icons_enabled = false,
      theme = 'auto',
      component_separators = '|',
      section_separators = '',
    },
    tabline = {
      lualine_a = {'buffers'},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {'tabs'}
    }
  }
}
