# Available at: https://tinyurl.com/webinarEFI

# Before Starting:

# 1. Install/Update R: >= 4.3.1

# 2. Make sure you have the support for the spatial package 'terra'. Depending on 
# your system, you will need to install GDAL libraries and Rcpp before running the 
# script, in other cases, 'terra' will take care of it.
# Please see details for installing these here: https://rspatial.github.io/terra/

# 3. Setting the project's directory. A folder named integratingSpaDESmodules will be created in it with all project elements
setwd("~") # here please set the home folder where the demo should live. Alternatively , provide the full path to the project folder in PART II, 
           # as `projectPath = "C:/Path/To/Folder/integratingSpaDESModules"`

# /!\ IMPORTANT /!\  Please Make sure the current file is saved.

# 4. Run the code:

##################### PART I: Install the installers

getOrUpdatePkg <- function(p, minVer = "0") {
  if (!isFALSE(try(packageVersion(p) < minVer, silent = TRUE) )) {
    repo <- c("predictiveecology.r-universe.dev", getOption("repos"))
    install.packages(p, repos = repo)
  }
}

getOrUpdatePkg("remotes")
getOrUpdatePkg("Require", "1.0.1")
getOrUpdatePkg("SpaDES.project", "0.1.1.9019")



##################### PART II: Download the modules and install the needed packages

Setup <- SpaDES.project::setupProject(
  
  paths = list(projectPath = "integratingSpaDESmodules"),
  
  modules = c("tati-micheletti/speciesAbundance@main",
              "tati-micheletti/temperature@main",
              "tati-micheletti/speciesAbundTempLM@main"),
  
  times = list(start = 2013,
               end = 2032),
  
  Restart = TRUE # The second time you run it, make sure to set to FALSE if RStudio attemps to open the project again
)


##################### PART III: Run SpaDES

results <- do.call(SpaDES.core::simInitAndSpades, Setup)
