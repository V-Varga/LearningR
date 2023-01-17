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


# Fixing variable names ---------------------------------------------------

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


### Exercise

# 1. Copy and paste the code below into the script file. Replace the ___ in the select() function, with the columns bp_sys_ave, and education.

nhanes_small %>%
  select(bp_sys_ave, education)

# 2. Copy and paste the code below and fill out the blanks. Rename the bp_ variables so they don’t end in _ave, so they look like bp_sys and bp_dia. Tip: Recall that renaming is in the form new = old.

nhanes_small %>%
  rename(
    bp_sys = bp_sys_ave,
    bp_dia = bp_dia_ave
  )

# 3. Re-write this piece of code using the “pipe” operator:

select(nhanes_small, bmi, contains("age"))

nhanes_small %>%
  select(bmi, contains("age"))

# 4. Read through (in your head) the code below. How intuitive is it to read? Now, re-write this code so that you don’t need to create the temporary blood_pressure object by using the pipe, then re-read the revised version. Which do you feel is easier to “read”?

blood_pressure <- select(nhanes_small, starts_with("bp_"))
rename(blood_pressure, bp_systolic = bp_sys_ave)

nhanes_small %>%
  select(starts_with("bp_")) %>%
  rename(bp_systolic = bp_sys_ave)
