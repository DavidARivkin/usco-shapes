'use strict'
Cube = require("../src/3d/Cube")
maths = require "usco-maths"

describe "cuboid", ->
  
  it 'creates a 3d cuboid, default settings', ->
    cube = new Cube()
    expect(cube.geometry.vertices.length).toEqual(8)
    expect(cube.geometry.vertices[1]).toEqual(new maths.Vector3(1,1,0))
    expect(cube.geometry.vertices[6]).toEqual(new maths.Vector3(0,0,0))

  it 'creates a 3d cuboid, object as arguments', ->
    cube = new Cube({size:100})
    expect(cube.position).toEqual(new maths.Vector3(50,50,50))
  
  it 'creates a 3d cuboid, center as boolean:true', ->
    cube = new Cube({size:100,center:true})
    expect(cube.geometry.vertices[0]).toEqual(new maths.Vector3(-50,-50,-50))
  ### 
  it 'creates a 3d cuboid, center as boolean:false', ->
    cube = new Cube({size:100,center:false})
    expect(cube.geometry.vertices[0]).toEqual(new maths.Vector3(100,100,100))
 
  it 'creates a 3d cuboid, center as vector', ->
    cube = new Cube({size:100,center:[100,100,100]})
    expect(cube.polygons[0].vertices[0].pos).toEqual(new maths.Vector3(50,50,50))
  
  it 'creates a 3d cuboid, size as vector', ->
    cube = new Cube({size:[100,5,50]})
    expect(cube.polygons[0].vertices[2].pos).toEqual(new maths.Vector3(0,5,50))
  ###  
  ###
  it 'creates a 3d cuboid, optional corner rounding , with rounding radius parameter, default rounding resolution', ->
    cube = new Cube({size:100,r:10})
    console.log cube
    expect(cube.polygons[0].vertices[2].pos).toEqual(new maths.Vector3(0,5,50))
   
  it 'creates a 3d cuboid, optional corner rounding , with all rounding parameters', ->
    cube = new Cube({size:100,r:10,$fn:3})
    console.log cube
    expect(cube.polygons[0].vertices[2].pos).toEqual(new maths.Vector3(0,5,50))
  ###  
