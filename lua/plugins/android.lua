return {
    "ariedov/android-nvim",
    config = function()
      -- OPTIONAL: specify android sdk directory
      vim.g.android_sdk = "~/Android/Sdk"
      require('android-nvim').setup()
    end
}
