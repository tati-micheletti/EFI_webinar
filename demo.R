# Available at: https://tinyurl.com/webinarEFI
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

install.packages("data.table")
if(!require("devtools")){
  install.packages("devtools")
} # You might be prompted to reinstall packages from source. Please allow it.  

devtools::install_github("PredictiveEcology/Require", ref = "3b239d6d4d18fe39dfa40a730df5094e74c086f8", upgrade = FALSE)
devtools::install_github("PredictiveEcology/SpaDES.project", ref = "e32abe20d89f97d03996b4335655ad000dbab89b", upgrade = FALSE)
Require::Require("SpaDES.core")

# Please Restart your session
wd <- reproducible::checkPath("~/SpaDES_demo", create = TRUE)

setwd(wd)
runName <- "integratedDefault"
out <- SpaDES.project::setupProject(
  runName = runName,
  paths = list(projectPath = "integratingSpaDESmodules",
               modulePath = file.path(dirname(wd), "SpaDES_Modules"),
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
