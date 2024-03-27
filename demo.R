# Before Starting:

# 1. Install/Update R: 4.3.2

# 2. Make sure R development tools are installed:
#   Windows: install Rtools as administrator. (https://cran.r-project.org/bin/windows/Rtools/rtools43/rtools.html)
#   macOS: install Xcode commandline tools from the terminal: xcode-select --install.
#   Debian/Ubuntu Linux: ensure r-base-dev is installed.  
# You can confirm you have it installed correctly by running
Sys.which("make")
# If it shows a “non-empty” path, it should be installed correctly

# 3. Run the code:

wd <- "~/SpaDES_Projects_demo"
lib <- file.path(wd, "library")
dir.create(wd)
dir.create(lib)
setwd(wd)
.libPaths(lib)
.libPaths()

install.packages("devtools", lib = lib) # You might be prompted to reinstall packages from source. Please allow it.  

devtools::install_github("PredictiveEcology/Require", ref = "3b239d6d4d18fe39dfa40a730df5094e74c086f8", lib = lib)
devtools::install_github("PredictiveEcology/reproducible", ref = "40033e6ddea151cbd31021ad73013393d71e1f06", lib = lib)
devtools::install_github("PredictiveEcology/SpaDES.core", ref = "a36dac8ecfc29173294b1bf76fbc63fa1d60e122", lib = lib)
devtools::install_github("PredictiveEcology/SpaDES.project", ref = "e32abe20d89f97d03996b4335655ad000dbab89b", lib = lib)

# Please Restart your session
wd <- "~/SpaDES_Projects_demo"
runName <- "integratedDefault"
out <- SpaDES.project::setupProject(
  runName = runName,
  paths = list(projectPath = "integratingSpaDESmodules_demo",
               outputPath = file.path("outputs", runName)),
  modules = c("tati-micheletti/speciesAbundance@main",
              "tati-micheletti/temperature@main",
              "tati-micheletti/speciesAbundTempLM@main"),
  times = list(start = 2013,
               end = 2032),
  loadOrder = c("speciesAbundance",
                "temperature",
                "speciesAbundTempLM"),
  updateRprofile = FALSE)

snippsim <- do.call(SpaDES.core::simInitAndSpades, out)
