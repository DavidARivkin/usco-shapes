'use strict'
Sphere = require("../src/3d/Cylinder")
maths = require "usco-maths"

describe "Cylinder shape", ->    

  it 'creates a Cylinder, with top and bottom radius set by radius parameter, default height', ->
    cylinder = new Cylinder({r:25,$fn:5})
    expect(cylinder.polygons[14].vertices[1].pos).toEqual(new maths.Vector3(25,6.123031769111886e-15,1))

  it 'creates a Cylinder, with top and bottom radius set by radius parameter, specified height', ->
    cylinder = new Cylinder({r:25, h:10,$fn:5})
    expect(cylinder.polygons[14].vertices[0].pos).toEqual(new maths.Vector3(0,0,10))
  
  it 'creates a Cylinder, with top and bottom radius set by diameter parameter', ->
    cylinder = new Cylinder({d:100,$fn:3})
    expect(cylinder.polygons[3].vertices[2].pos).toEqual(new maths.Vector3(-25.00000000000002,43.30127018922192,0))
  
  it 'creates a Cylinder, with with settable resolution', ->
    cylinder = new Cylinder({d:25,$fn:15})
    expect(cylinder.polygons.length).toEqual(45)
  
  it 'creates a Cylinder, with center as boolean', ->
    cylinder = new Cylinder({d:25, center:true, $fn:5})
    expect(cylinder.polygons[0].vertices[1].pos).toEqual(new maths.Vector3(12.5,0,-0.5))
  
  it 'creates a Cylinder, with center as vector', ->
    cylinder = new Cylinder({d:25, center:[100,100,100], $fn:5})
    expect(cylinder.polygons[0].vertices[0].pos).toEqual(new maths.Vector3(100,100,99.5))
    
  it 'creates a Cylinder, with with optional end rounding', ->
    cylinder = new Cylinder({d:25, center:[100,100,100], $fn:5})
    expect(cylinder.polygons[0].vertices[0].pos).toEqual(new maths.Vector3(100,100,99.5))
