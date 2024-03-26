library(data.table)

# Define grid boundaries and resolution
min_lat <- -49.5
max_lat <- 48.5
min_long <- -49.5
max_long <- 48.5
resolution <- 1

# Create a grid of spatial points
latitudes <- seq(min_lat, max_lat, by = resolution)
longitudes <- seq(min_long, max_long, by = resolution)
grid <- expand.grid(lat = latitudes, long = longitudes)

# Simulate elevation data with a simple model (e.g., sine and cosine waves)
grid$elevation <- with(grid, sin(pi * lat / 100) * cos(pi * long / 100) * 50 + 100)

# Influence Poisson lambda by elevation (assuming higher elevation has more counts)
# Normalize elevation to [0, 1] for modulation purposes
normalized_elevation <- (grid$elevation - min(grid$elevation)) / (max(grid$elevation) - min(grid$elevation))
grid$lambda <- 10 + 15 * normalized_elevation # Base lambda of 10, modulated by elevation

# Generate Poisson-distributed count data
set.seed(123) # For reproducibility
grid$count <- rpois(nrow(grid), lambda = grid$lambda)

# Convert to data.table
dt <- data.table(grid)

ras1 <- setValues(rasGauss, dt$count)
