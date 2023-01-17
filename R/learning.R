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

# Select one column by its name, without quotes
select(NHANES, Age)
# Select two or more columns by name, without quotes
select(NHANES, Age, Weight, BMI)
# To *exclude* a column, use minus (-)
select(NHANES, -HeadCirc)
# All columns starting with letters "BP" (blood pressure)
select(NHANES, starts_with("BP"))
# All columns ending in letters "Day"
select(NHANES, ends_with("Day"))
# All columns containing letters "Age"
select(NHANES, contains("Age"))

# Save the selected columns as a new data frame
# Recall the style guide for naming objects
nhanes_small <- select(
  NHANES, Age, Gender, BMI, Diabetes,
  PhysActive, BPSysAve, BPDiaAve, Education
)

# View the new data frame
nhanes_small

# Rename all columns to snake case
nhanes_small <- rename_with(nhanes_small, snakecase::to_snake_case)

# Have a look at the data frame
nhanes_small

# rename "gender" to sex for accuracy
nhanes_small <- rename(nhanes_small, sex = gender)
nhanes_small


# Chaining with pipe ------------------------------------------------------

# These two ways are the same
colnames(nhanes_small)
nhanes_small %>%
  colnames()

nhanes_small %>%
  select(phys_active) %>%
  rename(physically_active = phys_active)
