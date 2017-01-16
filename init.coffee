add_line_markers = (marker) ->
  editor = atom.workspace.getActiveTextEditor()
  range = editor.getSelectedBufferRange()
  editor.moveToBeginningOfLine()
  s = range.start.row
  e = range.end.row
  if e > s && range.end.column == 0
    e = e - 1
    editor.moveUp()
  editor.transact ->
    for i in [s..e]
      do (i) ->
        editor.moveToBeginningOfLine()
        editor.insertText(marker + ": ")
        if i < e
          editor.moveUp()

remove_line_markers = () ->
  editor = atom.workspace.getActiveTextEditor()
  range = editor.getSelectedBufferRange()
  editor.moveToBeginningOfLine()
  s = range.start.row
  e = range.end.row
  if e > s && range.end.column == 0
    e = e - 1
    editor.moveUp()
  editor.transact ->
    for i in [s..e]
      do (i) ->
        editor.moveToBeginningOfLine()
        editor.selectRight(6)
        editor.backspace()
        if i < e
          editor.moveUp()

toggle_line_marker = () ->
  editor = atom.workspace.getActiveTextEditor()
  editor.moveToBeginningOfLine()
  editor.selectRight(1)
  char = editor.getSelectedText()
  switch char
    when "  " then editor.insertText("+ ")
    when " " then editor.insertText("+")
    when "+" then editor.insertText("-")
    when "-" then editor.insertText(" ")
  editor.moveToBeginningOfLine()

atom.commands.add 'atom-text-editor',
  'custom:insert-review-tag': ->
    editor = atom.workspace.getActiveTextEditor()
    selectedText = editor.getSelectedText()
    editor?.insertText("@<>{#{selectedText}}")
    editor?.moveLeft(selectedText.length + 3)
  'custom:insert-review-content-tag': ->
    editor = atom.workspace.getActiveTextEditor()
    editor?.moveToBeginningOfLine()
    editor?.insertText("//{\n\n//}\n")
    editor?.moveUp(3)
    editor?.moveRight(2)
  'custom:add-review-line-markers': ->
    add_line_markers("    ")
  'custom:add-review-line-markers-plus': ->
    add_line_markers("+   ")
  'custom:add-review-line-markers-minus': ->
    add_line_markers("-   ")
  'custom:remove-review-line-markers': ->
    remove_line_markers()
  'custom:toggle-review-line-marker': ->
    toggle_line_marker()
