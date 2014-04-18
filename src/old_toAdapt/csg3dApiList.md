Booleans
- union
- subtract
- intersect
- inverse

Transforms
- transform ( matrix4x4 )

Modifiers
- expand -> expandedShell (optional at first)
- contract -> contractedShell (optional at first)

Utilities (core)
- canonicalize ( remove duplicates/close to duplicates of vertices)
- reTesselate (generate correctly triangulated mesh: has some issues)
- getBounds ( essentially the same as three.js boundingBox ?)
- mayOverlap : between two csg objects (utility)
- setShared : set a "shared" flag on polygons if they are shared by two or more items?
- fixTJunctions: tricky one : very good in theory (removing potential issues in shapes with t-junctions), very troublesome in practice
- sphereUtil : weird utility method, generates a "virtual sphere" (not a shape) for internal purposes

Utilities (extra)
- cutByPlane : very usefull
- sectionCut: ?? related to the above?
- color : practical works on a polygon level, but might be a bit weird when we have the "material" property
- lieFlat -> getTransformationToFlatLying: The docstring says it all : could be very practical :
  # Get the transformation that transforms this CSG such that it is lying on the z=0 plane, 
  # as flat as possible (i.e. the least z-height).
  # So that it is in an orientation suitable for CNC milling 
- projectToOrthoNormalBasis : essentially the inverse of "extrude" for 2d shapes : returns a 2d shape (projection/shadow
of the current 3d shape)


Connectors related (needs more thought)
- connectTo

Not implemented currently but needed
- solidFromSlices (VERY GOOD ONE , see openJScad)
- Hull3D (VERY IMPORTANT)
- Minkowsky sum


