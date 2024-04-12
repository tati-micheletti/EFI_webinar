# 1. Exploring the results from the simulation -- Forecasts

SpaDES.core::objectDiagram(results)
SpaDES.core::moduleDiagram(results)
SpaDES.core::completed(results)
results$abundTempLM
terra::plot(rast(results$forecasts))
terra::plot(results$forecastedDifferences, col = c("#49006A", "#7A0177", "#AE017E", 
                                                   "#DD3497", "#F768A1", "#FA9FB5", 
                                                   "#FCC5C0", "#FDE0DD", "#FFF7F3"))

# 3.	Add a validation module to make it more PERFICT

"tati-micheletti/evaluateLM@main"

# Now check the diagnostics and plots
results$modDiagnostics
grid::grid.raster(png::readPNG(results$modDiagnostics$qqPlot))
grid::grid.raster(png::readPNG(results$modDiagnostics$residualsVsFitted))

# 4. Demonstrate modularity by showing modules can be run stand alone
# Just remove the following modules from the setupProject() call and re-run it:

"tati-micheletti/temperature@main"
"tati-micheletti/speciesAbundTempLM@main"

# 5. Observe the integration tests located in the folder 
# integratingSpaDESmodules/SpaDES_Modules/speciesAbundance/tests 

# 6. Modifying an existing Module

############ 6.1. Create the function(s) and add to the module

modelAbundTime <- function(abundanceData){
  modAbund <- lm(formula = abundance ~ years, data = abundanceData)
  summary(modAbund)
  return(modAbund)
}

############ 6.2. Add the event to the module

abundanceThroughTime = {

  sim$modAbund <- modelAbundTime(abundanceData = sim$abund)
  
  # No need to schedule further events as this one happens at the end of the 
  # module's data
}

############ 6.3. Schedule the event in the init

sim <- scheduleEvent(sim, end(sim), "speciesAbundance", "abundanceThroughTime")

############ 6.4. Declare it as a createdOutput

createsOutput(objectName = "modAbund", objectClass = "lm", 
              desc = paste0("A fitted model (of the `lm` class) of abundance through time"))

