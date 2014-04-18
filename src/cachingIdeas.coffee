class Foo
  @cache = {}
  constructor:(options)->
    options = options or {}
    @bar = options.bar or 43
    @baz = Math.random()
    cacheOverride = options.cacheOverride or false
  
    if not cacheOverride
      if not Foo.cache[@bar]
        Foo.cache[@bar] = @
      return Foo.cache[@bar]
  
  

  f = new Foo()
  console.log( f,f.baz, Foo.cache)
  f2 = new Foo()
  console.log(f2,f2.baz, Foo.cache)
  f3 = new Foo({bar:11})
  console.log(f3,f3.baz, Foo.cache)
  f4 = new Foo({bar:11})
  console.log(f4,f4.baz, Foo.cache)
  f5 = new Foo()
  console.log(f5,f5.baz, Foo.cache)
  f6 = new Foo({cacheOverride:true})
  console.log(f6,f6.baz, Foo.cache)

    
    
    
