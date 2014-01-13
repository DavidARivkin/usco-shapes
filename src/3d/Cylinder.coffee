'use strict'
THREE = require 'three'

ObjectBase = require '../base'
Constants = require '../constants'
utils = require '../utils'
optParse = require '../optParse'
maths = require 'usco-maths'

THREE.Vector3 = maths.Vector3 #HACk !!


###* 
* Construct a solid Cylinder
* @param {float} r1: radius of base of cylinder (default 1), must be a scalar: alternative: d1 (see below)
* @param {float} d1: diameter of base of cylinder (default 0.5), must be a scalar: alternative: r1 (see above)
* @param {float} r2: radius of top of cylinder (default 1), must be a scalar: alternative: d2 (see below)
* @param {float} d2: diameter of top cylinder (default 0.5), must be a scalar: alternative: r2 (see above)

* @param {object} center: center of cylinder (default [0,0,0]) can be either a boolean , an array of booleans or an array of coordinates
* @param {object} o: (orientation): vector towards wich the cylinder should be facing (up vector)
* @param {int} $fn: (resolution) determines the number of polygons per 360 degree revolution (default 12)
* TODO: keep these ?
* start: start point of cylinder (default [0, -1, 0])
* end: end point of cylinder (default [0, 1, 0])

* Example usage:
*  cylinder = new Cylinder({
*   start: [0, -1, 0],
*    end: [0, 1, 0],
*    radius: 1,
*  $fn: 16,
*  center: true
*     });
###
class Cylinder extends ObjectBase
  constructor:(options)->
    options = options or {}
    if ("r" of options or "r1" of options) then hasRadius = true
    defaults = {h:1,center:[0,0,0],r:1,d:2,$fn:Constants.defaultResolution3D,rounded:false}
    options = utils.merge(defaults, options)
    
    radiusTop = options.r
    radiusBottom = options.r
    height = options.h 
    heightSegments = 2
    $fn = options.$fn
    
    geometry = new THREE.CylinderGeometry(radiusTop, radiusBottom, height, $fn, heightSegments)
    geometry.applyMatrix( new THREE.Matrix4().makeRotationAxis( new THREE.Vector3(0,1,0),90) )

    super(geometry)
  
module.exports = Cylinder
