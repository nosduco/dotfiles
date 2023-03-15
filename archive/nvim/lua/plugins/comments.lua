-- Setup commenter
require('mini.comment').setup({
  mappings = {
    comment = '<C-_>',
    comment_line = '<C-_>'
  }
})

-- Setup TODO comment helper
require('todo-comments').setup()
