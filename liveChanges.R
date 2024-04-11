####### Code used during demonstration #######

# 1. Exploring the results from the simulation

objectDiagram(results) # Presents a diagram of project's object dependencies
moduleDiagram(results) # Presents a diagram of modules' dependencies
completed(results) # Presents all the events that were run
results$lm

# 2. Assess Forecasts
results$forecasts
terra::plot(results$forecastedDifferences)

# 3.	Add a validation module to make it more PERFICT
# Just add the following module to the setupProject call and re-run it:

"tati-micheletti/evaluateLM@main"
# Now check the diagnostics
results$modDiagnostics

# 4. Demonstrate modularity by showing modules can be run stand alone
# Just remove the following modules from the setupProject() call and re-run it:
"tati-micheletti/temperature@main"
"tati-micheletti/speciesAbundTempLM@main"

# 5. Observe the integration tests located in the folder 
# integratingSpaDESmodules/SpaDES_Modules/speciesAbundance/tests 

# 6. Modifying an existing Module

############ 1. Create the function(s) and add to the module

modelAbundTime <- function(abundanceData){
  modAbund <- lm(formula = abundance ~ years, data = abundanceData)
  summary(modAbund)
  return(modAbund)
}

plotAbundance(abundanceData = sim$abund, yearsToPlot = start(sim):time(sim))

# Note that, alternatively, we could have directly added the block of code to the 
# event as below. But once more complexity is added, the code becomes long and 
# harder to follow.

  modAbund <- lm(formula = abundance ~ years, data = sim$abund)
  sim$modAbund <- summary(modAbund)

############ 2. Add the event to the module
abundanceThroughTime = {

  sim$modAbund <- modelAbundTime(abundanceData = sim$abund)
  
  # No need to schedule further events as this one happens at the end of the 
  # module's data
},

############ 3. Schedule the event in the init
lastYearOfData <- max(as.numeric(sim$abund[, years]))
sim <- scheduleEvent(sim, lastYearOfData, "speciesAbundance", "abundanceThroughTime")


### Try changing the module yourself!

# Add the function below to the EXISTING event named `plot`, plotting the data in the 
# first (2013) and the last (2022) years (scroll down to see the answer)

plotAbundance <- function(abundanceData, yearsToPlot){
  Sys.sleep(1.2) # To ensure we will see the results from the previous plot
  dataplot <- abundanceData[years %in% yearsToPlot,]
  abundData <- Copy(dataplot)
  abundData[, years := as.factor(years)]
  abundData[, averageYear := mean(abundance), by = "years"]
  pa <- ggplot(data = abundData, aes(x = abundance, group=years, color=years, fill = years)) +
    geom_histogram(binwidth=5) +
    facet_grid(years ~ .) +
    geom_vline(data = unique(abundData[, c("years", "averageYear")]),
               aes(xintercept = averageYear),
               linetype="dashed", color = "black") +
    theme(legend.position = "none")
  print(pa)
  return(pa)
}
























# ANSWER:



# This is how the even `plot` should look like once the function has been added:
plot = {
  # ! ----- EDIT BELOW ----- ! #
  # do stuff for this event
  terra::plot(sim$abundaRas, main = paste0(P(sim)$areaName, ": ", time(sim)))
  
  plotAbundance(abundanceData = sim$abund, 
                yearsToPlot = c(start(sim), time(sim))) # Here is the new function! 
  
  if (time(sim) == max(as.numeric(sim$abund[, years]))){
    saveAbundRasters(allAbundanceRasters = sim$allAbundaRas, 
                     savingName = P(sim)$areaName, 
                     savingFolder = Paths$output)
  }
  
  # schedule future event(s)
  if (time(sim) < max(as.numeric(sim$abund[, years])))
    sim <- scheduleEvent(sim, time(sim) + time(sim) + P(sim)$.plotInterval, 
                         "speciesAbundance", "plot")
  
  # ! ----- STOP EDITING ----- ! #
},




