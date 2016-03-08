export class ShellError extends Error


export shell = (cmd, ...args) !->
  { filter } = require 'prelude-ls'
  { spawn-sync } = require 'child_process'

  args = (args |> filter (?))
  console.log shellquote-args [ cmd ] ++ args unless shell.is-silent
  { status } = spawn-sync cmd, args, stdio: [0 1 2]
  if status != 0
    throw new ShellError "status: #status"

shell.silent = (f) ->
  shell.is-silent = true
  f()
  shell.is-silent = false


shellquote-arg = (arg) !->
  throw new TypeError console.dir arg if typeof arg isnt 'string'
  escape-it = (it) -> \\ + it

  if \' in arg
    return \" + arg.replace(/\\/g, escape-it).replace(/[$\']/g, escape-it) + \"
  else if /[^A-Za-z0-9.\-_\/]/g.test arg
    return \' + arg + \'
  else
    return arg


export shellquote-args = (args) ->
  { map, join } = require 'prelude-ls'

  args |> map shellquote-arg |> join ' '