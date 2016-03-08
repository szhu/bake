export should = (fn, ...args) ->
  -> fn(...args)
