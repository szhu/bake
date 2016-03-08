#!/usr/bin/env lsc


require! {
  './util'
  'fs'
  'vm'
  'livescript': LiveScript
  'source-map-support'
}

# GLOBAL <<< require '../lib/bake'
#  [
#   basename
#   HOME
#   PWD
#   rm-f
#   symlink-base
# ]

export function run
  filename = "#{process.env.PWD}/Bakefile"
  # output-filename = "(generated js)"
  source = 'source-map-support.install()\n' + fs.read-file-sync filename

  source-js = LiveScript.compile(source, { filename, map: 'embedded'})
  console.log source-js.code




  

  contextPrototype = { require, sourceMapSupport }
  contextPrototype <<< util
  context = ^^contextPrototype
  context.module = { exports: {} }
  vm.runInNewContext source-js.code, context, { filename, +displayErrors }
  throw

  console.dir context.module.exports
  # context.DEFAULT()

  # bake Bakefile
