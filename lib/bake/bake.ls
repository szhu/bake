export bake = (module, default-targets = []) ->
  minimist = require('minimist')
  argv = minimist process.argv.slice(2)
  targets = argv._
  targets = default-targets if targets.length == 0

  for target in targets
    module.exports[target]()
