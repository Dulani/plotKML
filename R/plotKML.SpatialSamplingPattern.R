# Purpose        : Generic methods to plot sampling designs
# Maintainer     : Tomislav Hengl (tom.hengl@wur.nl); 
# Contributions  : ;
# Dev Status     : Alpha
# Note           : it is largely based on the spcosa classes;


setMethod("plotKML", "SpatialSamplingPattern", function(
  obj,
  folder.name = normalizeFilename(deparse(substitute(obj, env=parent.frame()))),
  file.name = paste(normalizeFilename(deparse(substitute(obj, env=parent.frame()))), ".kml", sep=""),
  kmz = TRUE,
  ID = names(obj@sp.domain)[1],
  ...
){
 
  # open the KML file for writing:
  kml_open(folder.name = folder.name, file.name = file.name)
  
  # add a description for the whole folder:
  kml.out <- get("kml.out", envir=plotKML.fileIO)
  description_txt <- sprintf('<description><![CDATA[%s]]></description>', obj@method)
  parseXMLAndAdd(description_txt, parent=kml.out[["Document"]])  
  assign('kml.out', kml.out, envir=plotKML.fileIO)  

  # plot strata and points:
  kml_layer.SpatialPolygons(obj = obj@sp.domain, colour = ID)
  kml_layer.SpatialPoints(obj = obj@pattern, ...)

  # close the file:
  kml_close(file.name = file.name)
  if (kmz == TRUE){
      kml_compress(file.name = file.name)
  }
  # open KML file in the default browser:
  kml_View(file.name)
})

# end of script;