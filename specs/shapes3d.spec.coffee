'use strict'

#Shapes3d = require("../src/3d/geometry3d")
Cube   = require("../src/3d/Cube")
Sphere = require("../src/3d/Sphere")

describe "basic 3d shape classes", ->
  
  it 'can substract shapes from each other', ->
    cube = new Cube({size:10})
    sphere = new Sphere({r:20})

    cube.subtract(sphere)
    console.log("bla")
