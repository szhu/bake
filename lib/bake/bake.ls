require! {
  minimist
}


export class BakeError extends Error


camelize = ->
  it.replace /-[a-z]/ig, ->
    it.charAt(1).toUpperCase()

uncamelize = ->
  it.replace /[A-Z]/g, ->
    \- + it.toLowerCase()

export list-targets-for = (module) !->
  console.log "What would you like to bake today?"
  for k, v of module.exports
    console.log " #{uncamelize k}"

export bake = (module, default-targets = <[]>) !->
  try
    argv = minimist process.argv.slice(2)
    targets = argv._
    targets = default-targets if targets.length == 0

    for target-name in targets
      target-func = module.exports[camelize target-name]
      if target-func?
        console.error "#target-name:"
        target-func()
        console.error ""
      else
        throw new Error "no target named '#target-name'"

    return 0

  catch e
    console.error "#e"
    return 1

  return -1
