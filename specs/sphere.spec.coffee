'use strict'
Sphere = require("../src/3d/Sphere")
maths = require "usco-maths"

describe "Sphere shape", ->  

  it 'creates a sphere, with size set by radius', ->
    sphere = new Sphere({r:50})
    expect(sphere.polygons[0].vertices[0].pos).toEqual(new maths.Vector3(50,0,0))
  
  it 'creates a sphere, with size set by diameter', ->
    sphere = new Sphere({d:100})
    expect(sphere.polygons[0].vertices[0].pos).toEqual(new maths.Vector3(50,0,0))
  
  it 'creates a sphere, with settable resolution', ->
    sphere = new Sphere({d:25,$fn:15})
    expect(sphere.polygons.length).toEqual(120)
  
  it 'creates a sphere, with center as boolean', ->
    sphere = new Sphere({d:25, center:true})
    expect(sphere.polygons[0].vertices[0].pos).toEqual(new maths.Vector3(12.5,0,0))
  
  it 'creates a sphere, with center as vector', ->
    sphere = new Sphere({d:25, center:[100,100,100]})
    expect(sphere.polygons[0].vertices[0].pos).toEqual(new maths.Vector3(112.5,100,100))

