'use strict'
THREE = require 'three'

maths = require "usco-maths"
ObjectBase = require '../base'
optParse = require '../optParse'
THREE.Vector3 = maths.Vector3 #HACk !!

utils = require '../utils'

Vector3 = maths.Vector3
###*
* Construct a solid cuboid. with optional corner roundings
* Example code:
*     cube = new Cube({size:10, center: [0, 0, 0]})
###
class Cube extends ObjectBase
  ###*
  * Construct a solid cuboid. with optional corner roundings
  * @param {Array/Scalar} size : size of cube (default [1,1,1]), can be specified as scalar or as 3D vector
  * @param {Array/Scalar} center: center of cube (default [0,0,0])
  * @param {Array/Scalar} r: radius of corners
  * @param {Array/Scalar} $fn: corner resolution
  ###
  constructor:(options)->
    options = options or {}
    @defaults = { size:[1,1,1], center:[0,0,0], r:0, $fn:0}
    #options = utils.merge(options, @defaults)

    @frep = null #TODO: put function representation here : INDEPENDENT from any polygonal , voxel or other implementation
    
    size   = optParse.parseOptionAs3DVector(options, "size", @defaults["size"])
    center = optParse.parseCenter(options, "center", size.clone().divideScalar(2), @defaults["center"], Vector3)
    
    #do params validation
    throw new Error("Cube size should be non-negative") if size.x <0 or size.y <0 or size.z <0
    
    super(option)
    this.position = center
  
  generate:->
    @geometry = new THREE.CubeGeometry( size.x, size.y, size.z )
    #center offset like openscad
    @geometry.applyMatrix( new THREE.Matrix4().makeTranslation(size.x/2, size.y/2, size.z/2) )
  
  attributeChanged:(attrName, oldValue, newValue)->
    super(attrName, oldValue, newValue)
    console.log("cube's attribute changed", attrName, newValue, oldValue)
    @geometry = new THREE.CubeGeometry( this.w, this.d, this.h );
    @updateRenderables()
  
module.exports = Cube
