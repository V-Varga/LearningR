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


# Filtering data ----------------------------------------------------------

# Participants who are not physically active
nhanes_small %>%
  filter(phys_active == "No")
# Participants who are physically active
nhanes_small %>%
  filter(phys_active != "No")
# Participants who have BMI equal to 25
nhanes_small %>%
  filter(bmi == 25)
# Participants who have BMI equal to or more than 25
nhanes_small %>%
  filter(bmi >= 25)

# logical operators
TRUE & TRUE # TRUE
TRUE & FALSE # FALSE
FALSE & FALSE # FALSE
TRUE | TRUE # TRUE
TRUE | FALSE # TRUE
FALSE | FALSE # FALSE

# When BMI is 25 AND phys_active is No
nhanes_small %>%
  filter(bmi == 25 & phys_active == "No")
# which functions the same as:
nhanes_small %>%
  filter(
    bmi == 25,
    phys_active == "No"
  )
# When BMI is 25 OR phys_active is No
nhanes_small %>%
  filter(bmi == 25 | phys_active == "No")

# Arranging data by age in ascending order
nhanes_small %>%
  arrange(age)
# can reverse to get the descending
nhanes_small %>%
  arrange(desc(age))
# when used on character data, alphabetical
nhanes_small %>%
  arrange(education)
# Arranging data by education then age in ascending order
nhanes_small %>%
  arrange(education, age)

## Mutate data, mess with columns

# show age in months instead of years
nhanes_small %>%
  mutate(age = age * 12)
# create new column
nhanes_small %>%
  mutate(logged_bmi = log(bmi))
# multiple modifications
nhanes_small %>%
  mutate(
    age = age * 12,
    logged_bmi = log(bmi)
  )
# note that mutate() is sequential
nhanes_small %>%
  mutate(
    age_month = age * 12,
    logged_bmi = log(bmi),
    age_weeks = age_month * 4
  )

# using if statements
nhanes_small %>%
  mutate(old = if_else(age >= 30, "Yes", "No"))
# longer test
nhanes_small %>%
  mutate(
    age_month = age * 12,
    logged_bmi = log(bmi),
    age_weeks = age_month * 4,
    # if (age >= 30) == TRUE, then "old" else "young"
    old = if_else(
      age >= 30,
      "old",
      "young"
    )
  )

# saving a filtered dataset
nhanes_update <- nhanes_small %>%
  mutate(old = if_else(age >= 30, "Yes", "No"))

### Exercise

# 1. BMI between 20 and 40 with diabetes
nhanes_small %>%
  # Format should follow: variable >= number or character
  filter(bmi >= 20 & bmi <= 40 & diabetes == "Yes")

# Pipe the data into mutate function and:
nhanes_modified <- nhanes_small %>% # Specifying dataset
  mutate(
    # 2. Calculate mean arterial pressure
    mean_arterial_pressure = (((2 * bp_dia_ave) + bp_sys_ave) / 3),
    # 3. Create young_child variable using a condition
    young_child = if_else(age < 6, "Yes", "No")
  )

nhanes_modified


# Calculating summary stats -----------------------------------------------

# calculate max BMI
nhanes_small %>%
  summarise(max_bmi = max(bmi))

# exclude NAs
nhanes_small %>%
  summarise(max_bmi = max(bmi, na.rm = TRUE))

# adding another summary stat
nhanes_small %>%
  summarise(
    max_bmi = max(bmi, na.rm = TRUE),
    min_bmi = min(bmi, na.rm = TRUE)
  )

### Exercise

# 1. Calculate the mean of bp_sys_ave and age.
nhanes_small %>%
  summarise(
    mean_bp_sys = mean(bp_sys_ave),
    mean_age = bp_sys_ave
  )

# 2. Calculate the max and min of bp_dia_ave.
nhanes_small %>%
  summarise(
    max_bp_dia = bp_dia_ave,
    min_bp_dia = bp_dia_ave
  )


# Summary stats by group --------------------------------------------------

# Mean age & BMI btwn those w/ & w/o diabetes
nhanes_small %>%
  group_by(diabetes) %>%
  summarise(
    mean_age = mean(age, na.rm = TRUE),
    mean_bmi = mean(bmi, na.rm = TRUE)
  )
# remove rows w/missing values in diabetes
nhanes_small %>%
  # Recall ! means "NOT", so !is.na means "is not missing"
  filter(!is.na(diabetes)) %>%
  group_by(diabetes) %>%
  summarise(
    mean_age = mean(age, na.rm = TRUE),
    mean_bmi = mean(bmi, na.rm = TRUE)
  )
# adding more columns
nhanes_small %>%
  filter(!is.na(diabetes)) %>%
  group_by(diabetes, phys_active) %>%
  summarise(
    mean_age = mean(age, na.rm = TRUE),
    mean_bmi = mean(bmi, na.rm = TRUE)
  )
# Since we don’t need the dataset grouped anymore, it’s good practice to end the grouping with ungroup().
nhanes_small %>%
  filter(!is.na(diabetes)) %>%
  group_by(diabetes, phys_active) %>%
  summarise(
    mean_age = mean(age, na.rm = TRUE),
    mean_bmi = mean(bmi, na.rm = TRUE)
  ) %>%
  ungroup()

### Exercise

# 1. What is the mean, max, and min differences in age between active and inactive persons with or without diabetes?
nhanes_small %>%
  filter(!is.na(diabetes)) %>%
  group_by(diabetes, phys_active) %>%
  summarise(
    mean_age = mean(age, na.rm = TRUE),
    max_age = max(age, na.rm = TRUE),
    min_age = min(age, na.rm = TRUE)
  ) %>%
    ungroup()

# 2. What is the mean, max, and min differences in systolic BP and diastolic BP between active and inactive persons with or without diabetes?
nhanes_small %>%
  filter(!is.na(diabetes)) %>%
  group_by(diabetes, phys_active) %>%
  summarise(
    mean_bp_sys = mean(bp_sys_ave, na.rm = TRUE),
    max_bp_sys = max(bp_sys_ave, na.rm = TRUE),
    min_bp_sys = min(bp_sys_ave, na.rm = TRUE),
    mean_bp_dia = mean(bp_dia_ave, na.rm = TRUE),
    max_bp_dia = max(bp_dia_ave, na.rm = TRUE),
    min_bp_dia = min(bp_dia_ave, na.rm = TRUE),
  ) %>%
    ungroup()


# Saving datasets as files ------------------------------------------------

# save files as csv
readr::write_csv(
  nhanes_small,
  here::here("data/nhanes_small.csv")
)
# We use the here() function to tell R to go to the project root (where the .Rproj file is found) and then use that file path


# Practicing dplyr functions ----------------------------------------------

# Practice using dplyr by using the NHANES dataset and wrangling the data into a summary output. Don’t create any intermediate objects by only using the pipe operator to link each task below with the next one.

NHANES %>%
  # 1. Rename all columns to use snakecase.
  rename_with(nhanes_small, snakecase::to_snake_case) %>%
  # 2. Select the columns gender, age and BMI.
  select(gender, age, bmi) %>%
  # 3. Exclude "NAs" from all of the selected columns.
  filter(!is.na(gender) & !is.na(age) & !is.na(bmi)) %>%
  # 4. Rename gender to sex.
  rename(sex = gender) %>%
  # 5.  Create a new column called age_class, where anyone under 50 years old is labeled "under 50" and those 50 years and older are labeled "over 50".
  age_class() <- if_else(age < 50, "under 50", "over 50") %>%
  # 6. Group the data according to sex and age_class.
  group_by(sex, age_class) %>%
  # 7. Calculate the mean and median BMI according to the grouping to determine the difference in BMI between age classes and sex.
  summarise(
    mean_bmi = mean(bmi, na.rm = TRUE),
    median_bmi = median(bmi, na.rm = TRUE)
  ) %>%
    ungroup()
