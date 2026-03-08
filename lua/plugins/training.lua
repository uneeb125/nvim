return {
  "Weyaaron/nvim-training",
  pin = true, -- Recommended by the author to prevent breaking changes
  cmd = "Training", -- Lazy loads the plugin when you type :Training
  opts = {
    -- Configuration options go here
    enable_highlights = true,
    enable_counters = true,
    -- Audio feedback requires the 'sox' package on your OS. 
    -- Set to false if you don't have it or don't want sound.
    audio_feedback = true, 
  },
}
