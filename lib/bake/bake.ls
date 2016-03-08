require! {
  minimist
}


export class BakeError extends Error


export bake = (module, default-targets = <[]>) !->
  try
    argv = minimist process.argv.slice(2)
    targets = argv._
    targets = default-targets if targets.length == 0

    for target in targets
      target-f = module.exports[target]
      if target-f?
        console.error "#target:"
        target-f()
        console.error ""
      else
        throw new Error "no target named '#target'"

    return 0

  catch e
    console.error "#e"
    return 1

  return -1
