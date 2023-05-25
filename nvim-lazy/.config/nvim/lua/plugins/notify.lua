return {
  {
    "folke/noice.nvim",
    opts = {
      notify = {
        enabled = false,
      },
    },
  },

  -- Better `vim.notify()`
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 1000,
    },
    init = function()
      vim.notify = function(msg, ...)
        local banned_messages = { "No information available" }
        for _, banned in ipairs(banned_messages) do
          if msg == banned then
            return
          end
        end
        return require("notify")(msg, ...)
      end
    end,
  },
}
