reTesselateCoplanarPolygons = (sourcepolygons, destpolygons) ->
    # Retesselation function for a set of coplanar polygons. See the introduction at the top of
    # this file.
    EPS = 1e-5
    numpolygons = sourcepolygons.length
    if numpolygons > 0
      plane = sourcepolygons[0].plane
      shared = sourcepolygons[0].shared
      orthobasis = new OrthoNormalBasis(plane)
      polygonvertices2d = [] # array of array of Vector2D
      polygontopvertexindexes = [] # array of indexes of topmost vertex per polygon
      topy2polygonindexes = {}
      ycoordinatetopolygonindexes = {}
      xcoordinatebins = {}
      ycoordinatebins = {}
      
      # convert all polygon vertices to 2D
      # Make a list of all encountered y coordinates
      # And build a map of all polygons that have a vertex at a certain y coordinate:    
      ycoordinateBinningFactor = 1.0 / EPS * 10
      polygonindex = 0
  
      while polygonindex < numpolygons
        poly3d = sourcepolygons[polygonindex]
        vertices2d = []
        numvertices = poly3d.vertices.length
        minindex = -1
        if numvertices > 0
          miny = undefined
          maxy = undefined
          maxindex = undefined
          i = 0
  
          while i < numvertices
            pos2d = orthobasis.to2D(poly3d.vertices[i].pos)
            
            # perform binning of y coordinates: If we have multiple vertices very
            # close to each other, give them the same y coordinate:
            ycoordinatebin = Math.floor(pos2d.y * ycoordinateBinningFactor)
            newy = undefined
            if ycoordinatebin of ycoordinatebins
              newy = ycoordinatebins[ycoordinatebin]
            else if ycoordinatebin + 1 of ycoordinatebins
              newy = ycoordinatebins[ycoordinatebin + 1]
            else if ycoordinatebin - 1 of ycoordinatebins
              newy = ycoordinatebins[ycoordinatebin - 1]
            else
              newy = pos2d.y
              ycoordinatebins[ycoordinatebin] = pos2d.y
            pos2d = new Vector2D(pos2d.x, newy)
            vertices2d.push pos2d
            y = pos2d.y
            if (i is 0) or (y < miny)
              miny = y
              minindex = i
            if (i is 0) or (y > maxy)
              maxy = y
              maxindex = i
            ycoordinatetopolygonindexes[y] = {}  unless y of ycoordinatetopolygonindexes
            ycoordinatetopolygonindexes[y][polygonindex] = true
            i++
          if miny >= maxy
            
            # degenerate polygon, all vertices have same y coordinate. Just ignore it from now:
            vertices2d = []
          else
            topy2polygonindexes[miny] = []  unless miny of topy2polygonindexes
            topy2polygonindexes[miny].push polygonindex
        # if(numvertices > 0)
        # reverse the vertex order:
        vertices2d.reverse()
        minindex = numvertices - minindex - 1
        polygonvertices2d.push vertices2d
        polygontopvertexindexes.push minindex
        polygonindex++
      ycoordinates = []
      for ycoordinate of ycoordinatetopolygonindexes
        ycoordinates.push ycoordinate
      ycoordinates.sort (a, b) ->
        a - b
  
      
      # Now we will iterate over all y coordinates, from lowest to highest y coordinate
      # activepolygons: source polygons that are 'active', i.e. intersect with our y coordinate
      #   Is sorted so the polygons are in left to right order
      # Each element in activepolygons has these properties:
      #        polygonindex: the index of the source polygon (i.e. an index into the sourcepolygons and polygonvertices2d arrays)
      #        leftvertexindex: the index of the vertex at the left side of the polygon (lowest x) that is at or just above the current y coordinate
      #        rightvertexindex: dito at right hand side of polygon
      #        topleft, bottomleft: coordinates of the left side of the polygon crossing the current y coordinate  
      #        topright, bottomright: coordinates of the right hand side of the polygon crossing the current y coordinate  
      activepolygons = []
      prevoutpolygonrow = []
      yindex = 0
  
      while yindex < ycoordinates.length
        newoutpolygonrow = []
        ycoordinate_as_string = ycoordinates[yindex]
        ycoordinate = Number(ycoordinate_as_string)
        
        # update activepolygons for this y coordinate:
        # - Remove any polygons that end at this y coordinate
        # - update leftvertexindex and rightvertexindex (which point to the current vertex index 
        #   at the the left and right side of the polygon
        # Iterate over all polygons that have a corner at this y coordinate:
        polygonindexeswithcorner = ycoordinatetopolygonindexes[ycoordinate_as_string]
        activepolygonindex = 0
  
        while activepolygonindex < activepolygons.length
          activepolygon = activepolygons[activepolygonindex]
          polygonindex = activepolygon.polygonindex
          if polygonindexeswithcorner[polygonindex]
            
            # this active polygon has a corner at this y coordinate:
            vertices2d = polygonvertices2d[polygonindex]
            numvertices = vertices2d.length
            newleftvertexindex = activepolygon.leftvertexindex
            newrightvertexindex = activepolygon.rightvertexindex
            
            # See if we need to increase leftvertexindex or decrease rightvertexindex:
            loop
              nextleftvertexindex = newleftvertexindex + 1
              nextleftvertexindex = 0  if nextleftvertexindex >= numvertices
              break  unless vertices2d[nextleftvertexindex].y is ycoordinate
              newleftvertexindex = nextleftvertexindex
            nextrightvertexindex = newrightvertexindex - 1
            nextrightvertexindex = numvertices - 1  if nextrightvertexindex < 0
            newrightvertexindex = nextrightvertexindex  if vertices2d[nextrightvertexindex].y is ycoordinate
            if (newleftvertexindex isnt activepolygon.leftvertexindex) and (newleftvertexindex is newrightvertexindex)
              
              # We have increased leftvertexindex or decreased rightvertexindex, and now they point to the same vertex
              # This means that this is the bottom point of the polygon. We'll remove it:
              activepolygons.splice activepolygonindex, 1
              --activepolygonindex
            else
              activepolygon.leftvertexindex = newleftvertexindex
              activepolygon.rightvertexindex = newrightvertexindex
              activepolygon.topleft = vertices2d[newleftvertexindex]
              activepolygon.topright = vertices2d[newrightvertexindex]
              nextleftvertexindex = newleftvertexindex + 1
              nextleftvertexindex = 0  if nextleftvertexindex >= numvertices
              activepolygon.bottomleft = vertices2d[nextleftvertexindex]
              nextrightvertexindex = newrightvertexindex - 1
              nextrightvertexindex = numvertices - 1  if nextrightvertexindex < 0
              activepolygon.bottomright = vertices2d[nextrightvertexindex]
          ++activepolygonindex
        # if polygon has corner here
        # for activepolygonindex
        nextycoordinate = undefined
        if yindex >= ycoordinates.length - 1
          
          # last row, all polygons must be finished here:
          activepolygons = []
          nextycoordinate = null
        # yindex < ycoordinates.length-1
        else
          nextycoordinate = Number(ycoordinates[yindex + 1])
          middleycoordinate = 0.5 * (ycoordinate + nextycoordinate)
          
          # update activepolygons by adding any polygons that start here: 
          startingpolygonindexes = topy2polygonindexes[ycoordinate_as_string]
          for polygonindex_key of startingpolygonindexes
            polygonindex = startingpolygonindexes[polygonindex_key]
            vertices2d = polygonvertices2d[polygonindex]
            numvertices = vertices2d.length
            topvertexindex = polygontopvertexindexes[polygonindex]
            
            # the top of the polygon may be a horizontal line. In that case topvertexindex can point to any point on this line.
            # Find the left and right topmost vertices which have the current y coordinate:
            topleftvertexindex = topvertexindex
            loop
              i = topleftvertexindex + 1
              i = 0  if i >= numvertices
              break  unless vertices2d[i].y is ycoordinate
              break  if i is topvertexindex # should not happen, but just to prevent endless loops
              topleftvertexindex = i
            toprightvertexindex = topvertexindex
            loop
              i = toprightvertexindex - 1
              i = numvertices - 1  if i < 0
              break  unless vertices2d[i].y is ycoordinate
              break  if i is topleftvertexindex # should not happen, but just to prevent endless loops
              toprightvertexindex = i
            nextleftvertexindex = topleftvertexindex + 1
            nextleftvertexindex = 0  if nextleftvertexindex >= numvertices
            nextrightvertexindex = toprightvertexindex - 1
            nextrightvertexindex = numvertices - 1  if nextrightvertexindex < 0
            newactivepolygon =
              polygonindex: polygonindex
              leftvertexindex: topleftvertexindex
              rightvertexindex: toprightvertexindex
              topleft: vertices2d[topleftvertexindex]
              topright: vertices2d[toprightvertexindex]
              bottomleft: vertices2d[nextleftvertexindex]
              bottomright: vertices2d[nextrightvertexindex]
  
            insertSorted activepolygons, newactivepolygon, (el1, el2) ->
              x1 = interpolateBetween2DPointsForY(el1.topleft, el1.bottomleft, middleycoordinate)
              x2 = interpolateBetween2DPointsForY(el2.topleft, el2.bottomleft, middleycoordinate)
              return 1  if x1 > x2
              return -1  if x1 < x2
              0
  
        # for(var polygonindex in startingpolygonindexes)
        #  yindex < ycoordinates.length-1
        #if( (yindex == ycoordinates.length-1) || (nextycoordinate - ycoordinate > EPS) )
        if true
          
          # Now activepolygons is up to date
          # Build the output polygons for the next row in newoutpolygonrow:
          for activepolygon_key of activepolygons
            activepolygon = activepolygons[activepolygon_key]
            polygonindex = activepolygon.polygonindex
            vertices2d = polygonvertices2d[polygonindex]
            numvertices = vertices2d.length
            x = interpolateBetween2DPointsForY(activepolygon.topleft, activepolygon.bottomleft, ycoordinate)
            topleft = new Vector2D(x, ycoordinate)
            x = interpolateBetween2DPointsForY(activepolygon.topright, activepolygon.bottomright, ycoordinate)
            topright = new Vector2D(x, ycoordinate)
            x = interpolateBetween2DPointsForY(activepolygon.topleft, activepolygon.bottomleft, nextycoordinate)
            bottomleft = new Vector2D(x, nextycoordinate)
            x = interpolateBetween2DPointsForY(activepolygon.topright, activepolygon.bottomright, nextycoordinate)
            bottomright = new Vector2D(x, nextycoordinate)
            outpolygon =
              topleft: topleft
              topright: topright
              bottomleft: bottomleft
              bottomright: bottomright
              leftline: Line2D.fromPoints(topleft, bottomleft)
              rightline: Line2D.fromPoints(bottomright, topright)
  
            if newoutpolygonrow.length > 0
              prevoutpolygon = newoutpolygonrow[newoutpolygonrow.length - 1]
              d1 = outpolygon.topleft.distanceTo(prevoutpolygon.topright)
              d2 = outpolygon.bottomleft.distanceTo(prevoutpolygon.bottomright)
              if (d1 < EPS) and (d2 < EPS)
                
                # we can join this polygon with the one to the left:
                outpolygon.topleft = prevoutpolygon.topleft
                outpolygon.leftline = prevoutpolygon.leftline
                outpolygon.bottomleft = prevoutpolygon.bottomleft
                newoutpolygonrow.splice newoutpolygonrow.length - 1, 1
            newoutpolygonrow.push outpolygon
          # for(activepolygon in activepolygons)
          if yindex > 0
            
            # try to match the new polygons against the previous row:
            prevcontinuedindexes = {}
            matchedindexes = {}
            i = 0
  
            while i < newoutpolygonrow.length
              thispolygon = newoutpolygonrow[i]
              ii = 0
  
              while ii < prevoutpolygonrow.length
                unless matchedindexes[ii] # not already processed?
                  
                  # We have a match if the sidelines are equal or if the top coordinates
                  # are on the sidelines of the previous polygon
                  prevpolygon = prevoutpolygonrow[ii]
                  if prevpolygon.bottomleft.distanceTo(thispolygon.topleft) < EPS
                    if prevpolygon.bottomright.distanceTo(thispolygon.topright) < EPS
                      
                      # Yes, the top of this polygon matches the bottom of the previous:
                      matchedindexes[ii] = true
                      
                      # Now check if the joined polygon would remain convex:
                      d1 = thispolygon.leftline.direction().x - prevpolygon.leftline.direction().x
                      d2 = thispolygon.rightline.direction().x - prevpolygon.rightline.direction().x
                      leftlinecontinues = Math.abs(d1) < EPS
                      rightlinecontinues = Math.abs(d2) < EPS
                      leftlineisconvex = leftlinecontinues or (d1 >= 0)
                      rightlineisconvex = rightlinecontinues or (d2 >= 0)
                      if leftlineisconvex and rightlineisconvex
                        
                        # yes, both sides have convex corners:
                        # This polygon will continue the previous polygon
                        thispolygon.outpolygon = prevpolygon.outpolygon
                        thispolygon.leftlinecontinues = leftlinecontinues
                        thispolygon.rightlinecontinues = rightlinecontinues
                        prevcontinuedindexes[ii] = true
                      break
                ii++
              i++
            # if(!prevcontinuedindexes[ii])
            # for ii
            # for i
            ii = 0
  
            while ii < prevoutpolygonrow.length
              unless prevcontinuedindexes[ii]
                
                # polygon ends here
                # Finish the polygon with the last point(s):
                prevpolygon = prevoutpolygonrow[ii]
                prevpolygon.outpolygon.rightpoints.push prevpolygon.bottomright
                
                # polygon ends with a horizontal line:
                prevpolygon.outpolygon.leftpoints.push prevpolygon.bottomleft  if prevpolygon.bottomright.distanceTo(prevpolygon.bottomleft) > EPS
                
                # reverse the left half so we get a counterclockwise circle:
                prevpolygon.outpolygon.leftpoints.reverse()
                points2d = prevpolygon.outpolygon.rightpoints.concat(prevpolygon.outpolygon.leftpoints)
                vertices3d = []
                points2d.map (point2d) ->
                  point3d = orthobasis.to3D(point2d)
                  vertex3d = new Vertex(point3d)
                  vertices3d.push vertex3d
  
                polygon = new Polygon(vertices3d, shared, plane)
                destpolygons.push polygon
              ii++
          # if(yindex > 0)
          i = 0
  
          while i < newoutpolygonrow.length
            thispolygon = newoutpolygonrow[i]
            unless thispolygon.outpolygon
              
              # polygon starts here:
              thispolygon.outpolygon =
                leftpoints: []
                rightpoints: []
  
              thispolygon.outpolygon.leftpoints.push thispolygon.topleft
              
              # we have a horizontal line at the top:
              thispolygon.outpolygon.rightpoints.push thispolygon.topright  if thispolygon.topleft.distanceTo(thispolygon.topright) > EPS
            else
              
              # continuation of a previous row
              thispolygon.outpolygon.leftpoints.push thispolygon.topleft  unless thispolygon.leftlinecontinues
              thispolygon.outpolygon.rightpoints.push thispolygon.topright  unless thispolygon.rightlinecontinues
            i++
          prevoutpolygonrow = newoutpolygonrow
        yindex++
