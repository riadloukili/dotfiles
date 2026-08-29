return {
  "3rd/image.nvim",
  build = false, -- don't build the rock
  opts = {
    backend = "kitty",
    processor = "magick_cli",
    hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
  },
}
