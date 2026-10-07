return 
{
    "navarasu/onedark.nvim",
    lazy     = false,
    priority = 1000,

    opts = {
      style = 'warm',
      transparent = true,
      code_style = {
        comments = "none",
      },
    },
    config = function(_, opts)
    require("onedark").setup(opts)
    require("onedark").load()
  end,
}
