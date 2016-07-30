export class ShellError extends Error


export shell = (...cmd-args) !->
  { filter } = require 'prelude-ls'
  { spawn-sync } = require 'child_process'
  [cmd, ...args] = cmd-args

  args = (args |> filter (?))
  console.log "+ cd #{shell.custom-wd} &&" if shell.custom-wd?
  console.log "+ " + shellquote-args cmd-args unless shell.is-silent
  { status } = spawn-sync cmd, args, stdio: [0 1 2], cwd: shell.custom-wd
  if status != 0
    throw new ShellError "status: #status"


shell.silent = (f) ->
  shell.is-silent = true
  f()
  shell.is-silent = false


shell.with-wd = (wd, f) ->
  shell.custom-wd = wd
  f()
  shell.custom-wd = undefined


# Try to return the shortest quoted representation of the arg.
export shellquote-arg = (arg) !->
  throw new TypeError console.dir arg if typeof arg isnt 'string'
  escape-it = (it) -> \\ + it

  { homedir } = require 'os'
  home-subs =
    * ["#{homedir()}/", "~/"]
    * ["#{homedir()}", "~"]
    * ["", ""]

  for [home-prefix, home-sub] in home-subs
    if (arg.substring(0, home-prefix.length) == home-prefix)
      arg := arg.substring(home-prefix.length)
      break

  if \' in arg
    return home-sub + \" + arg.replace(/[`$\\]/g, escape-it) + \"
  else if /[^A-Za-z0-9.\-_\/]/g.test arg
    return home-sub + \' + arg + \'
  else
    return home-sub + arg


export shellquote-args = (args) ->
  { map, join } = require 'prelude-ls'

  args |> map shellquote-arg |> join ' '
