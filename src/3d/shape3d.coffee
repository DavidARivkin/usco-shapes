
class Shape3d
  
  constructor:()->
    @frep = null #TODO: put function representation here : INDEPENDENT from any polygonal , voxel or other implementation
    @codeLocation = null #TODO : this should hold the name of the module (real or virtual) and the start/end line location
    #of the CODE of the object : this would bind the code base representation to the object instance itself
  ###
  * Method to update exisiting shape 3d
  ###
  update(params)->
    throw new Exception("Not implemented")

  #------boolean operations------#
  ###
  * apply a boolean union operation: current objects become a fusion between itself
  * and passed in objects
  * @param {object, array} objects:  one ore more objects to fuse this object with.
  * @return {Object} the current object instance to allow operation chaining
  ###
  union:(objects)=>
  
  ###* 
  * apply a boolean subtraction operation:  current object gets "carved" out by 
  the passed in objects
  * @param {object, array} objects:  one ore more objects to carve from this object
  * @return {Object} the current object instance to allow operation chaining
  ###
  subtract:(objects)=>

  ###* 
  * apply a boolean intersection operation : current object becomes the "common"
  volume of the current object and the passed in objects
  * @param {object, array} objects:  one ore more objects to intersect from this object
  * @return {Object} the current object instance to allow operation chaining
  ###
  intersect:(objects)=>
    
  ###* 
  * inverses the volume of the current object: any filled parts become empty and vice versa
  * @return {Object} the current object instance to allow operation chaining
  ###
  inverse:()=>


  

module.exports = Shape3d
