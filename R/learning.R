# Here's an example of a conflict.
# R basics ----------------------------------------------------------------

# printing to the console
10

# assigning variables
weight_kilos <- 100
weight_kilos
weight_kilos <- 10
weight_kilos

# using dataframes
colnames(airquality)
str(airquality) # str means structure
summary(airquality)

# styling practice
2 + 2 # Ctrl+Shift+A


# Loading packages & data --------------------------------------------------------

library(tidyverse)
library(NHANES)

# Briefly glimpse contents of dataset
glimpse(NHANES)
