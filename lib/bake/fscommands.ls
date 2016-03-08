require! {
  './shell': { shell }
}

to-list = (x) ->
  if typeof x is 'string' then [x] else x


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


export rel-path = (src, dst) !->
  { take-while, zip } = require 'prelude-ls'
  src-parts = src.split(\/)
  dst-parts = dst.split(\/)
  common = zip src-parts, dst-parts |> (take-while ([l, r]) -> l == r) |> (.length)

  return '../' * (dst-parts.length - common) + src-parts[common to].join('/')


  # SRC-DIR = basename PWD
  # DST-DIR = "#HOME/Library/Application Support/LyX-2.1"
  # REL-SRC-DIR = "../../../.local/opt/important-things/#SRC-DIR"
