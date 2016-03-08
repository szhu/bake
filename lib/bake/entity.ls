require! {
  './fscommands': { rel-path, symlink-base }
}


export class RelSymlink
  (@src-dir, @dst-dir, @base) !->
    @rel-src-dir = rel-path @src-dir, @dst-dir
    @dst = @dst-dir + '/' + @base

  install: ->
    symlink-base @rel-src-dir, @dst-dir, @base

  uninstall: ->
    rm-f @dst
