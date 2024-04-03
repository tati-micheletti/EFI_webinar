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
# 3. Setting the project's directory. A folder named integratingSpaDESmodules will be created in it with all project elements
setwd("~") # here please set the home folder where the demo should live. 

# /!\ IMPORTANT /!\  Please Make sure the current file is saved in the folder specified above
message(paste0("Please Make sure the current file is saved in the folder specified above (",getwd(),")"))

# 4. Run the code:
getOrUpdatePkg <- function(p, minVer = "0") {
  if (!isFALSE(try(packageVersion(p) < minVer, silent = TRUE) )) {
    repo <- c("predictiveecology.r-universe.dev", getOption("repos"))
    install.packages(p, repos = repo)
  }
}

getOrUpdatePkg("remotes")
remotes::install_github("PredictiveEcology/Require", ref = "a2c60495228e3a73fa513435290e84854ca51907", upgrade = FALSE)
getOrUpdatePkg("SpaDES.project", "0.0.8.9040")


# /!\ IMPORTANT /!\  The first time you run the code below, the RStudio session will be restarted and the project file will be loaded.
#                    The libraries will also be installed in a specific folder in the project directory to avoid package incompatibilities.  
#                    This helps the project to be stand-alone and respect specific user's configurations.
#                    Once the project has reopened, please re-run the current script
out <- SpaDES.project::setupProject(
  paths = list(projectPath = "integratingSpaDESmodules",
               modulePath = "SpaDES_Modules",
               outputPath = "outputs"),
  modules = c("tati-micheletti/speciesAbundance@main",
              "tati-micheletti/temperature@main",
              "tati-micheletti/speciesAbundTempLM@main"),
  times = list(start = 2013,
               end = 2032),
  Restart = TRUE
)

snippsim <- do.call(SpaDES.core::simInitAndSpades, out)

