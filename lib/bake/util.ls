{ basename, dirname } = require 'path'
{ HOME, PWD } = process.env


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


export basename, dirname, HOME, PWD


to-list = (x) ->
  if typeof x is 'string' then [x] else x


export should = (fn, ...args) ->
  -> fn(...args)


export rm = (dst) !->
  dst = to-list(dst)

  shell \rm, \--, ...dst


export rm-f = (dst) !->
  dst = to-list(dst)

  shell \rm, \-f, \--, ...dst


export mk-parent = (dst) !->
  { dirname } = require 'path'

  shell \mkdir, \-p, dirname(dst)


export symlink = (src, dst) !->
  shell.silent ->
    rm-f dst
    mk-parent dst
  shell \ln, \-sf, \--, src, dst


export symlink-base = (src-dir, dst-dir, base) !->
  num-slashes = (base.match(/\//g) || []).length
  src = ("../" * num-slashes) + "#src-dir/#base"
  dst = "#dst-dir/#base"

  symlink src, dst


export bake = (module, default-targets = []) ->
  minimist = require('minimist')
  argv = minimist process.argv.slice(2)
  targets = argv._
  targets = default-targets if targets.length == 0

  for target in targets
    module.exports[target]()
