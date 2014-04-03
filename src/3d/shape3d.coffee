
class Shape3d
  constructor:()->
    @__meta = {} #holds object meta data ("reflexion", links between code and visual etc
    @__frep = null #TODO: put function representation here : INDEPENDENT from any polygonal , voxel or other implementation
    #this holds all the history of operations for the given shape
    @operations = []
    #of the CODE of the object : this would bind the code base representation to the object instance itself
    @generate()
    
  ###
  * Method to update exisiting shape 3d
  ###
  update(params)->
    throw new Exception("Not implemented")
  
  ###
  * method that holds the basic/full generation algorithm for this shape
  ###
  generate:->
    throw new Exception("Not implemented")
  
  ###
  * method to handle "inteligently" attribute changes
  * overriding this is advised
  ###
  attributeChanged:(attrName, oldValue, newValue)->
    throw new Exception("Not implemented")
    @[attrName] = newValue
    #@properties[attrName][2] = newValue
  
    operation = new AttributeChange(this, attrName, oldValue,newValue)
    event = new CustomEvent('newOperation',{detail: {msg: operation}})
    document.dispatchEvent(event)

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
