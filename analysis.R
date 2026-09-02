# ============================================================
# EV CHARGING INFRASTRUCTURE SITING & LOCATION ANALYTICS
# ============================================================
#
# Project Type:
# Business Analytics / Decision Support System
#
# Objective:
# Identify and rank areas that have high potential for
# future EV charging infrastructure.
#
# Study Area:
# [TO BE CONFIRMED]
#
# Programming Language:
# R
#
# Repository:
# ev-charging-infrastructure-siting
#
# ============================================================
# ANALYTICAL PRINCIPLE
# ============================================================
#
# This script is intentionally written as a complete,
# reproducible analytical record.
#
# Each stage documents:
#   1. What is being done
#   2. Why it is being done
#   3. What data is being used
#   4. What assumptions are being made
#   5. What the analysis shows
#   6. What decision follows from the result
#
# The final R Markdown report will be generated from this
# analytical workflow after the analysis is completed.
#
# ============================================================
# ============================================================
# 1. BUSINESS PROBLEM
# ============================================================
#
# EV adoption is increasing, creating a growing requirement
# for accessible charging infrastructure.
#
# However, installing charging stations without understanding
# demand and location characteristics can lead to:
#
# - Low utilization
# - Underused infrastructure
# - Poor return on investment
# - Long payback periods
# - Uneven charging infrastructure distribution
#
# Therefore, the central business question is:
#
# "Where should new EV charging infrastructure be installed
# so that it has strong demand potential, addresses
# infrastructure gaps, remains accessible, and provides
# reasonable financial viability?"
#
# ============================================================
# ============================================================
# 1. BUSINESS QUESTIONS
# ============================================================

# The analysis is designed to answer the following questions:
#
# Q1. Where are EVs currently concentrated?
#
# Q2. Which vehicle categories are most relevant for public
#     charging infrastructure?
#
# Q3. Which areas have high EV demand but insufficient
#     charging infrastructure?
#
# Q4. Where are existing charging stations concentrated?
#
# Q5. Which areas have good accessibility?
#
# Q6. Which areas have strong locality potential?
#
# Q7. What proportion of potential charging demand may come
#     from different EV categories?
#
# Q8. Which candidate locations have the highest suitability?
#
# Q9. What is the estimated revenue potential?
#
# Q10. What is the estimated payback period?
#
# Q11. Which locations should be prioritized for further
#      investigation?
# ============================================================
# ============================================================
rm(list = ls())

# ------------------------------------------------------------
# Required packages
# ------------------------------------------------------------

library(tidyverse)

# Data import
library(readxl)

# Geographic analysis
library(sf)

# Visualization
library(ggplot2)

# ============================================================
# 2. PACKAGES
# ============================================================

required_packages <- c(
  "tidyverse",
  "readxl",
  "janitor",
  "lubridate"
)

# Install missing packages automatically
installed_packages <- rownames(installed.packages())

for (pkg in required_packages) {
  
  if (!(pkg %in% installed_packages)) {
    install.packages(pkg)
  }
  
  library(
    pkg,
    character.only = TRUE
  )
}

# Additional packages will be added only when required.

# ============================================================
# 3. PROJECT PATHS
# ============================================================

project_root <- getwd()

raw_data_path <- file.path(
  project_root,
  "data",
  "raw"
)

processed_data_path <- file.path(
  project_root,
  "data",
  "processed"
)

output_figures_path <- file.path(
  project_root,
  "outputs",
  "figures"
)

output_tables_path <- file.path(
  project_root,
  "outputs",
  "tables"
)

output_maps_path <- file.path(
  project_root,
  "outputs",
  "maps"
)

# Create output directories if they don't already exist

dir.create(
  processed_data_path,
  recursive = TRUE,
  showWarnings = FALSE
)

dir.create(
  output_figures_path,
  recursive = TRUE,
  showWarnings = FALSE
)

dir.create(
  output_tables_path,
  recursive = TRUE,
  showWarnings = FALSE
)

dir.create(
  output_maps_path,
  recursive = TRUE,
  showWarnings = FALSE
)
# ============================================================
# 4. ANALYSIS METADATA
# ============================================================

analysis_start_time <- Sys.time()

cat("\n====================================================\n")
cat("EV CHARGING INFRASTRUCTURE SITING ANALYSIS\n")
cat("====================================================\n")

cat(
  "Analysis started:",
  format(analysis_start_time),
  "\n"
)

cat(
  "R version:",
  R.version.string,
  "\n"
)

cat(
  "Working directory:",
  getwd(),
  "\n"
)

cat("====================================================\n")
# ============================================================
# 5. DATA SOURCES
# ============================================================
#
# DATASET 1: EV REGISTRATION DATA
#
# Source:
# VAHAN / Ministry of Road Transport and Highways
#
# Purpose:
# To understand the geographic and categorical distribution
# of electric vehicles.
#
# Potential variables:
# - RTO
# - Vehicle category
# - Fuel type
# - Number of registrations
# - Registration year
#
# ------------------------------------------------------------
#
# DATASET 2: EXISTING CHARGING STATIONS
#
# Purpose:
# To understand the existing distribution of EV charging
# infrastructure and identify potential infrastructure gaps.
#
# Potential variables:
# - Station name
# - Latitude
# - Longitude
# - Charger type
# - Charging capacity
#
# ------------------------------------------------------------
#
# DATASET 3: GEOGRAPHIC / ACCESSIBILITY DATA
#
# Potential variables:
# - Roads
# - Major roads
# - Highways
# - Parking
# - Commercial areas
# - Activity centres
#
# ============================================================
# ============================================================
# 6. DATA INVENTORY
# ============================================================
#
# Purpose:
# Identify all datasets currently available to the project.
#
# We do NOT combine datasets at this stage.
#
# First we need to understand:
#   - file names
#   - file formats
#   - file sizes
#   - geographic coverage
#   - time coverage
#   - available variables
# ============================================================

raw_files <- list.files(
  raw_data_path,
  recursive = TRUE,
  full.names = TRUE
)

cat("\n================ DATA INVENTORY ================\n")

if (length(raw_files) == 0) {
  
  cat("No raw datasets found.\n")
  
} else {
  
  print(raw_files)
  
}

cat("=================================================\n")
# ============================================================
# 6.1 DATASET INVENTORY TABLE
# ============================================================

if (length(raw_files) > 0) {
  
  dataset_inventory <- data.frame(
    
    File = basename(raw_files),
    
    Path = raw_files,
    
    Extension = tools::file_ext(raw_files),
    
    Size_MB = round(
      file.info(raw_files)$size / 1024^2,
      3
    ),
    
    stringsAsFactors = FALSE
    
  )
  
  print(dataset_inventory)
  
}
write.csv(
  dataset_inventory,
  file.path(
    output_tables_path,
    "dataset_inventory.csv"
  ),
  row.names = FALSE
)

# ============================================================
# 6.1 DATASET INVENTORY TABLE
# ============================================================
#
# Create a structured inventory of every raw dataset.
#
# This table becomes part of the reproducibility record and
# allows us to document exactly which files were available
# when the analysis was performed.
# ============================================================

if (length(raw_files) > 0) {

  dataset_inventory <- data.frame(

    File = basename(raw_files),

    Path = raw_files,

    Extension = tools::file_ext(raw_files),

    Size_MB = round(
      file.info(raw_files)$size / 1024^2,
      3
    ),

    stringsAsFactors = FALSE

  )

  print(dataset_inventory)

  write.csv(
    dataset_inventory,
    file.path(
      output_tables_path,
      "dataset_inventory.csv"
    ),
    row.names = FALSE
  )

} else {

  cat(
    "\nNo raw datasets available. Dataset inventory was not created.\n"
  )

}


# ============================================================
# 6.1 DATASET INVENTORY TABLE
# ============================================================
#
# Create a structured inventory of every raw dataset.
#
# This table becomes part of the reproducibility record and
# allows us to document exactly which files were available
# when the analysis was performed.
# ============================================================

if (length(raw_files) > 0) {

  dataset_inventory <- data.frame(

    File = basename(raw_files),

    Path = raw_files,

    Extension = tools::file_ext(raw_files),

    Size_MB = round(
      file.info(raw_files)$size / 1024^2,
      3
    ),

    stringsAsFactors = FALSE

  )

  print(dataset_inventory)

  write.csv(
    dataset_inventory,
    file.path(
      output_tables_path,
      "dataset_inventory.csv"
    ),
    row.names = FALSE
  )

} else {

  cat(
    "\nNo raw datasets available. Dataset inventory was not created.\n"
  )

}
# ============================================================
# 7. IMPORT RAW DATA
# ============================================================
#
# The project currently contains:
#
# 1. VAHAN fuel-type data
# 2. VAHAN vehicle-category data
# 3. VAHAN vehicle-class data
# 4. Kolkata EV charging-station data
# 5. OpenStreetMap geographic data
#
# At this stage we import the tabular datasets.
#
# We will inspect their structure BEFORE attempting to
# combine them.
#
# ============================================================


# ============================================================
# 7.1 VAHAN FUEL TYPE DATA
# ============================================================

vahan_fuel <- read_csv(
  file.path(
    raw_data_path,
    "vahan",
    "vahan_fuel_type.csv"
  ),
  show_col_types = FALSE
)

cat("\n================ VAHAN FUEL TYPE ================\n")

cat(
  "Rows:",
  nrow(vahan_fuel),
  "\n"
)

cat(
  "Columns:",
  ncol(vahan_fuel),
  "\n"
)

print(names(vahan_fuel))

glimpse(vahan_fuel)


# ============================================================
# 7.2 VAHAN VEHICLE CATEGORY DATA
# ============================================================

vahan_category <- read_csv(
  file.path(
    raw_data_path,
    "vahan",
    "vahan_vehicle_category.csv"
  ),
  show_col_types = FALSE
)

cat("\n================ VAHAN VEHICLE CATEGORY ================\n")

cat(
  "Rows:",
  nrow(vahan_category),
  "\n"
)

cat(
  "Columns:",
  ncol(vahan_category),
  "\n"
)

print(names(vahan_category))

glimpse(vahan_category)


# ============================================================
# 7.3 VAHAN VEHICLE CLASS DATA
# ============================================================

vahan_class <- read_csv(
  file.path(
    raw_data_path,
    "vahan",
    "vahan_vehicle_class.csv"
  ),
  show_col_types = FALSE
)

cat("\n================ VAHAN VEHICLE CLASS ================\n")

cat(
  "Rows:",
  nrow(vahan_class),
  "\n"
)

cat(
  "Columns:",
  ncol(vahan_class),
  "\n"
)

print(names(vahan_class))

glimpse(vahan_class)


# ============================================================
# 7.4 KOLKATA CHARGING STATION DATA
# ============================================================

charging_stations <- read_csv(
  file.path(
    raw_data_path,
    "charging_stations",
    "kolkata_ev_charging_stations_master_with_verified_coordinates.csv"
  ),
  show_col_types = FALSE
)

cat("\n================ KOLKATA CHARGING STATIONS ================\n")

cat(
  "Rows:",
  nrow(charging_stations),
  "\n"
)

cat(
  "Columns:",
  ncol(charging_stations),
  "\n"
)

print(names(charging_stations))

glimpse(charging_stations)


# ============================================================
# 8. DATA STRUCTURE AUDIT
# ============================================================
#
# Before cleaning or combining datasets, we document:
#
# - Variable names
# - Variable types
# - Number of observations
# - Missing values
# - Duplicate observations
#
# This prevents incorrect assumptions about the datasets.
# ============================================================


# ------------------------------------------------------------
# 8.1 Missing-value summary function
# ------------------------------------------------------------

missing_value_summary <- function(
    data,
    dataset_name
) {
  
  data %>%
    
    summarise(
      across(
        everything(),
        ~ sum(is.na(.))
      )
    ) %>%
    
    pivot_longer(
      cols = everything(),
      names_to = "variable",
      values_to = "missing_count"
    ) %>%
    
    mutate(
      
      dataset = dataset_name,
      
      missing_percentage =
        round(
          100 * missing_count / nrow(data),
          2
        )
      
    ) %>%
    
    select(
      dataset,
      variable,
      missing_count,
      missing_percentage
    )
}


# ------------------------------------------------------------
# 8.2 Generate missing-value reports
# ------------------------------------------------------------

missing_fuel <- missing_value_summary(
  vahan_fuel,
  "VAHAN Fuel Type"
)

missing_category <- missing_value_summary(
  vahan_category,
  "VAHAN Vehicle Category"
)

missing_class <- missing_value_summary(
  vahan_class,
  "VAHAN Vehicle Class"
)

missing_charging <- missing_value_summary(
  charging_stations,
  "Kolkata Charging Stations"
)


# ------------------------------------------------------------
# 8.3 Combine reports
# ------------------------------------------------------------

missing_values <- bind_rows(
  
  missing_fuel,
  
  missing_category,
  
  missing_class,
  
  missing_charging
  
)


print(missing_values)


# ------------------------------------------------------------
# 8.4 Save missing-value audit
# ------------------------------------------------------------

write.csv(
  
  missing_values,
  
  file.path(
    output_tables_path,
    "missing_value_audit.csv"
  ),
  
  row.names = FALSE
  
)


# ============================================================
# 9. DUPLICATE RECORD AUDIT
# ============================================================
#
# Duplicate observations can artificially inflate:
#
# - EV registration counts
# - Charging station counts
#
# Therefore duplicates are checked before cleaning.
# ============================================================


duplicate_summary <- data.frame(
  
  Dataset = c(
    "VAHAN Fuel Type",
    "VAHAN Vehicle Category",
    "VAHAN Vehicle Class",
    "Kolkata Charging Stations"
  ),
  
  Duplicate_Rows = c(
    
    sum(duplicated(vahan_fuel)),
    
    sum(duplicated(vahan_category)),
    
    sum(duplicated(vahan_class)),
    
    sum(duplicated(charging_stations))
    
  )
  
)


print(duplicate_summary)


write.csv(
  
  duplicate_summary,
  
  file.path(
    output_tables_path,
    "duplicate_record_audit.csv"
  ),
  
  row.names = FALSE
  
)


# ============================================================
# 10. CHARGING-STATION DATA INSPECTION
# ============================================================
#
# The charging-station dataset is particularly important
# because it will later be converted into spatial features.
#
# First inspect the actual coordinate variables.
# ============================================================


cat(
  "\n================ CHARGING STATION VARIABLES ================\n"
)

print(
  names(charging_stations)
)


# ------------------------------------------------------------
# Look at the first records
# ------------------------------------------------------------

print(
  head(charging_stations)
)


# ------------------------------------------------------------
# Summary statistics
# ------------------------------------------------------------

summary(
  charging_stations
)


# ============================================================
# 11. VAHAN LOCATION INSPECTION
# ============================================================
#
# The next objective is to determine how geographic
# information is represented in the VAHAN datasets.
#
# We specifically need to identify:
#
# - RTO name/code
# - District
# - State
# - City
# - Registration count
# - Fuel type
# - Vehicle category
# - Vehicle class
# - Year/month, if available
#
# DO NOT join the datasets yet.
#
# ============================================================


cat(
  "\n================ VAHAN FUEL VARIABLES ================\n"
)

print(
  names(vahan_fuel)
)


cat(
  "\n================ VAHAN CATEGORY VARIABLES ================\n"
)

print(
  names(vahan_category)
)


cat(
  "\n================ VAHAN CLASS VARIABLES ================\n"
)

print(
  names(vahan_class)
)


# ============================================================
# 12. PROJECT CHECKPOINT
# ============================================================
#
# Completed:
#
# [x] Project directories established
# [x] Raw dataset inventory created
# [x] VAHAN fuel dataset imported
# [x] VAHAN vehicle-category dataset imported
# [x] VAHAN vehicle-class dataset imported
# [x] Kolkata charging-station dataset imported
# [x] Missing-value audit created
# [x] Duplicate-record audit created
# [x] Charging-station variables inspected
# [x] VAHAN variables inspected
#
# NOT YET COMPLETED:
#
# [ ] Data cleaning
# [ ] Variable standardisation
# [ ] EV demand calculation
# [ ] Charging-station spatial conversion
# [ ] Infrastructure-gap analysis
# [ ] Accessibility analysis
# [ ] Candidate-location generation
# [ ] Suitability scoring
# [ ] Financial analysis
#
# The next stage depends on the actual structure of the
# imported datasets.
#
# ============================================================
# ============================================================
# 13. DEFINE KOLKATA AS THE STUDY AREA
# ============================================================
#
# The project is explicitly city-based.
#
# Therefore, Kolkata is the fixed study area.
#
# We are NOT comparing Kolkata with other cities.
#
# The purpose of the analysis is to determine:
#
# "Where within Kolkata should additional EV charging
# infrastructure be considered?"
#
# ============================================================

study_city <- "Kolkata"

study_state <- "West Bengal"

cat("\n================ STUDY AREA ================\n")

cat(
  "City:",
  study_city,
  "\n"
)

cat(
  "State:",
  study_state,
  "\n"
)

cat("=============================================\n")


# ============================================================
# 14. IDENTIFY KOLKATA RECORDS IN VAHAN DATA
# ============================================================
#
# VAHAN records contain an office_name variable.
#
# We first inspect records containing "Kolkata" or "Calcutta".
#
# This allows us to determine how Kolkata is represented
# in the registration data.
#
# We do NOT assume that one particular RTO represents the
# entire city.
# ============================================================


kolkata_fuel_records <- vahan_fuel %>%
  
  filter(
    str_detect(
      str_to_lower(state_name),
      "west bengal"
    )
  ) %>%
  
  filter(
    str_detect(
      str_to_lower(office_name),
      "kolkata|calcutta"
    )
  )


kolkata_category_records <- vahan_category %>%
  
  filter(
    str_detect(
      str_to_lower(state_name),
      "west bengal"
    )
  ) %>%
  
  filter(
    str_detect(
      str_to_lower(office_name),
      "kolkata|calcutta"
    )
  )


# ============================================================
# 14.1 KOLKATA RTO/OFFICE LIST
# ============================================================

kolkata_fuel_offices <- kolkata_fuel_records %>%
  
  distinct(
    office_name,
    office_code
  ) %>%
  
  arrange(
    office_name
  )


kolkata_category_offices <- kolkata_category_records %>%
  
  distinct(
    office_name,
    office_code
  ) %>%
  
  arrange(
    office_name
  )


cat("\n================ KOLKATA VAHAN OFFICES ================\n")

print(
  kolkata_fuel_offices,
  n = Inf
)


cat("\n================ KOLKATA CATEGORY OFFICES ================\n")

print(
  kolkata_category_offices,
  n = Inf
)


# ============================================================
# 14.2 SAVE KOLKATA OFFICE INFORMATION
# ============================================================

write.csv(
  
  kolkata_fuel_offices,
  
  file.path(
    output_tables_path,
    "kolkata_vahan_fuel_offices.csv"
  ),
  
  row.names = FALSE
  
)

write.csv(
  
  kolkata_category_offices,
  
  file.path(
    output_tables_path,
    "kolkata_vahan_category_offices.csv"
  ),
  
  row.names = FALSE
  
)


# ============================================================
# PROJECT DECISION LOG
# ============================================================
#
# Decision:
#
# Kolkata is the fixed study area.
#
# Rationale:
#
# The project is a city-level EV charging infrastructure
# siting study. Therefore, the analysis focuses on spatial
# variation within Kolkata rather than comparing different
# cities.
#
# The VAHAN office structure will be inspected to determine
# how Kolkata's EV registration data can be represented.
#
# ============================================================

# ============================================================
# 15. FILTER KOLKATA EV REGISTRATION DATA
# ============================================================
#
# Study area:
#   Pvd Kolkata (WB1)
#
# We use the VAHAN office code rather than only the text
# "Kolkata" to make the filtering reproducible.
#
# ============================================================


# ============================================================
# 15.1 KOLKATA FUEL-TYPE DATA
# ============================================================

kolkata_fuel <- vahan_fuel %>%
  
  filter(
    office_code == "WB1"
  )


# ============================================================
# 15.2 KOLKATA VEHICLE-CATEGORY DATA
# ============================================================

kolkata_category <- vahan_category %>%
  
  filter(
    office_code == "WB1"
  )


# ============================================================
# 15.3 BASIC DATA CHECK
# ============================================================

cat("\n================ KOLKATA FUEL DATA ================\n")

cat(
  "Rows:",
  nrow(kolkata_fuel),
  "\n"
)

cat(
  "Date range:",
  min(kolkata_fuel$date),
  "to",
  max(kolkata_fuel$date),
  "\n"
)


cat("\n================ KOLKATA CATEGORY DATA ================\n")

cat(
  "Rows:",
  nrow(kolkata_category),
  "\n"
)

cat(
  "Date range:",
  min(kolkata_category$date),
  "to",
  max(kolkata_category$date),
  "\n"
)


# ============================================================
# 15.4 AVAILABLE FUEL TYPES
# ============================================================

kolkata_fuel_types <- kolkata_fuel %>%
  
  count(
    fuel_type,
    sort = TRUE
  )


cat("\n================ KOLKATA FUEL TYPES ================\n")

print(
  kolkata_fuel_types,
  n = Inf
)


# ============================================================
# 15.5 AVAILABLE VEHICLE CATEGORIES
# ============================================================

kolkata_vehicle_types <- kolkata_category %>%
  
  count(
    vehicle_type,
    sort = TRUE
  )


cat("\n================ KOLKATA VEHICLE TYPES ================\n")

print(
  kolkata_vehicle_types,
  n = Inf
)

# ============================================================
# 16. KOLKATA EV DEMAND BY VEHICLE CATEGORY
# ============================================================
#
# The previous section counted the number of records in each
# vehicle category.
#
# That is NOT the same as the number of EVs.
#
# The actual EV demand is represented by the
# `registrations` column.
#
# Therefore, we now aggregate registrations.
# ============================================================


# ============================================================
# 16.1 CHECK REGISTRATION VALUES
# ============================================================

cat("\n================ SAMPLE KOLKATA CATEGORY DATA ================\n")

print(
  kolkata_category %>%
    select(
      date,
      office_name,
      office_code,
      vehicle_type,
      registrations
    ) %>%
    head(20)
)


# ============================================================
# 16.2 TOTAL REGISTRATIONS BY VEHICLE CATEGORY
# ============================================================

kolkata_category_demand <- kolkata_category %>%
  
  group_by(
    vehicle_type
  ) %>%
  
  summarise(
    
    total_registrations = sum(
      registrations,
      na.rm = TRUE
    ),
    
    .groups = "drop"
    
  ) %>%
  
  arrange(
    desc(total_registrations)
  )


# ============================================================
# 16.3 DISPLAY RESULTS
# ============================================================

cat("\n================ KOLKATA VEHICLE DEMAND ================\n")

print(
  kolkata_category_demand,
  n = Inf
)


# ============================================================
# 16.4 SAVE RESULTS
# ============================================================

write.csv(
  
  kolkata_category_demand,
  
  file.path(
    output_tables_path,
    "kolkata_vehicle_category_demand.csv"
  ),
  
  row.names = FALSE
  
)
# ============================================================
# 17. IDENTIFY ELECTRIC VEHICLE REGISTRATIONS
# ============================================================
#
# The vehicle-category dataset tells us the type of vehicle.
#
# The fuel-type dataset tells us the fuel used.
#
# Therefore, the fuel-type dataset is used to identify
# electric vehicle registrations.
#
# ============================================================


# ============================================================
# 17.1 INSPECT FUEL TYPES
# ============================================================

kolkata_fuel_summary <- kolkata_fuel %>%
  
  group_by(
    fuel_type
  ) %>%
  
  summarise(
    
    total_registrations = sum(
      registrations,
      na.rm = TRUE
    ),
    
    .groups = "drop"
    
  ) %>%
  
  arrange(
    desc(total_registrations)
  )


cat("\n================ KOLKATA FUEL TYPE DEMAND ================\n")

print(
  kolkata_fuel_summary,
  n = Inf
)


# ============================================================
# 17.2 IDENTIFY ELECTRIC LABEL
# ============================================================
#
# We first inspect the actual labels instead of assuming
# how VAHAN represents electric vehicles.
#
# ============================================================

electric_fuel_labels <- kolkata_fuel %>%
  
  distinct(
    fuel_type
  ) %>%
  
  filter(
    str_detect(
      str_to_lower(fuel_type),
      "electric|battery|ev"
    )
  )


cat("\n================ POSSIBLE ELECTRIC FUEL LABELS ================\n")

print(
  electric_fuel_labels,
  n = Inf
)
# ============================================================
# 18. KOLKATA ELECTRIC VEHICLE DEMAND
# ============================================================
#
# Pure electric vehicles are identified using:
#
#   Electric(Bov)
#   Pure Ev
#
# Strong Hybrid Ev is kept separate because it represents
# hybrid vehicles rather than pure electric vehicles.
#
# ============================================================


# ============================================================
# 18.1 PURE EV REGISTRATIONS
# ============================================================

kolkata_ev_demand <- kolkata_fuel %>%
  
  filter(
    fuel_type %in% c(
      "Electric(Bov)",
      "Pure Ev"
    )
  ) %>%
  
  summarise(
    
    total_ev_registrations = sum(
      registrations,
      na.rm = TRUE
    )
    
  )


cat("\n================ KOLKATA EV DEMAND ================\n")

print(
  kolkata_ev_demand
)


# ============================================================
# 18.2 EV REGISTRATIONS BY FUEL LABEL
# ============================================================

kolkata_ev_by_fuel <- kolkata_fuel %>%
  
  filter(
    fuel_type %in% c(
      "Electric(Bov)",
      "Pure Ev"
    )
  ) %>%
  
  group_by(
    fuel_type
  ) %>%
  
  summarise(
    
    total_registrations = sum(
      registrations,
      na.rm = TRUE
    ),
    
    .groups = "drop"
    
  ) %>%
  
  arrange(
    desc(total_registrations)
  )


cat("\n================ KOLKATA EV BY FUEL LABEL ================\n")

print(
  kolkata_ev_by_fuel
)


# ============================================================
# 18.3 HYBRID VEHICLES — SEPARATE INDICATOR
# ============================================================
#
# We do not include hybrids in the pure-EV total.
#
# However, they are retained as an additional indicator
# because they are relevant to the broader transition toward
# electrified mobility.
#
# ============================================================

kolkata_hybrid_demand <- kolkata_fuel %>%
  
  filter(
    fuel_type == "Strong Hybrid Ev"
  ) %>%
  
  summarise(
    
    total_hybrid_registrations = sum(
      registrations,
      na.rm = TRUE
    )
    
  )


cat("\n================ KOLKATA HYBRID DEMAND ================\n")

print(
  kolkata_hybrid_demand
)


# ============================================================
# 18.4 SAVE EV RESULTS
# ============================================================

write.csv(
  
  kolkata_ev_demand,
  
  file.path(
    output_tables_path,
    "kolkata_ev_demand.csv"
  ),
  
  row.names = FALSE
  
)


write.csv(
  
  kolkata_ev_by_fuel,
  
  file.path(
    output_tables_path,
    "kolkata_ev_by_fuel.csv"
  ),
  
  row.names = FALSE
  
)


write.csv(
  
  kolkata_hybrid_demand,
  
  file.path(
    output_tables_path,
    "kolkata_hybrid_demand.csv"
  ),
  
  row.names = FALSE
  
)


# ============================================================
# 19. CHECK DATA STRUCTURE FOR EV CATEGORY ANALYSIS
# ============================================================
#
# We have established the total pure-EV registrations.
#
# Now we need to determine whether the fuel-type dataset and
# vehicle-category dataset can be connected using common
# fields.
#
# We will inspect the structure before performing any join.
#
# ============================================================


# ============================================================
# 19.1 FUEL DATA COLUMNS
# ============================================================

cat("\n================ FUEL DATA COLUMNS ================\n")

print(
  names(kolkata_fuel)
)


# ============================================================
# 19.2 VEHICLE CATEGORY DATA COLUMNS
# ============================================================

cat("\n================ CATEGORY DATA COLUMNS ================\n")

print(
  names(kolkata_category)
)


# ============================================================
# 19.3 FUEL DATA SAMPLE
# ============================================================

cat("\n================ FUEL DATA SAMPLE ================\n")

print(
  kolkata_fuel %>%
    head(10)
)


# ============================================================
# 19.4 CATEGORY DATA SAMPLE
# ============================================================

cat("\n================ CATEGORY DATA SAMPLE ================\n")

print(
  kolkata_category %>%
    head(10)
)


# ============================================================
# 19.5 COMMON COLUMNS
# ============================================================

common_columns <- intersect(
  names(kolkata_fuel),
  names(kolkata_category)
)


cat("\n================ COMMON COLUMNS ================\n")

print(
  common_columns
)
# ============================================================
# 20. INSPECT COMMON CATEGORY FIELD
# ============================================================
#
# Both datasets contain a `category` field.
#
# We will determine whether this field provides a valid
# common classification between the fuel and vehicle-category
# datasets.
#
# ============================================================


# ============================================================
# 20.1 CATEGORIES IN FUEL DATA
# ============================================================

fuel_categories <- kolkata_fuel %>%
  
  distinct(
    category
  ) %>%
  
  arrange(
    category
  )


cat("\n================ FUEL DATA CATEGORIES ================\n")

print(
  fuel_categories,
  n = Inf
)


# ============================================================
# 20.2 CATEGORIES IN VEHICLE DATA
# ============================================================

vehicle_categories <- kolkata_category %>%
  
  distinct(
    category
  ) %>%
  
  arrange(
    category
  )


cat("\n================ VEHICLE DATA CATEGORIES ================\n")

print(
  vehicle_categories,
  n = Inf
)


# ============================================================
# 20.3 COMMON CATEGORIES
# ============================================================

common_categories <- intersect(
  fuel_categories$category,
  vehicle_categories$category
)


cat("\n================ COMMON CATEGORIES ================\n")

print(
  common_categories
)


# ============================================================
# 20.4 NUMBER OF COMMON CATEGORIES
# ============================================================

cat(
  "\nNumber of common categories:",
  length(common_categories),
  "\n"
)

# ============================================================
# 21. CHECK OBSERVATION STRUCTURE
# ============================================================
#
# The fuel and vehicle-category datasets cannot be joined
# through the `category` column.
#
# We will therefore check whether both datasets contain the
# same date and RTO/office observations.
#
# This helps determine whether they represent two separate
# aggregations of the same registration activity.
#
# ============================================================


# ============================================================
# 21.1 FUEL DATA OBSERVATIONS
# ============================================================

fuel_observations <- kolkata_fuel %>%
  
  distinct(
    date,
    office_code
  )


cat("\n================ FUEL OBSERVATIONS ================\n")

print(
  fuel_observations,
  n = Inf
)


# ============================================================
# 21.2 VEHICLE CATEGORY OBSERVATIONS
# ============================================================

vehicle_observations <- kolkata_category %>%
  
  distinct(
    date,
    office_code
  )


cat("\n================ VEHICLE CATEGORY OBSERVATIONS ================\n")

print(
  vehicle_observations,
  n = Inf
)


# ============================================================
# 21.3 COMPARE OBSERVATION COUNTS
# ============================================================

cat(
  "\nNumber of fuel observations:",
  nrow(fuel_observations),
  "\n"
)

cat(
  "Number of vehicle-category observations:",
  nrow(vehicle_observations),
  "\n"
)


# ============================================================
# 21.4 OBSERVATIONS PRESENT IN BOTH DATASETS
# ============================================================

common_observations <- inner_join(
  
  fuel_observations,
  vehicle_observations,
  
  by = c(
    "date",
    "office_code"
  )
)


cat(
  "\nNumber of common date-office observations:",
  nrow(common_observations),
  "\n"
)


# ============================================================
# 21.5 CHECK WHETHER ALL OBSERVATIONS MATCH
# ============================================================

cat(
  "\nFuel observations represented in vehicle dataset:",
  nrow(common_observations) == nrow(fuel_observations),
  "\n"
)

cat(
  "Vehicle observations represented in fuel dataset:",
  nrow(common_observations) == nrow(vehicle_observations),
  "\n"
)

# ============================================================
# 22. EV REGISTRATION TREND
# ============================================================
#
# Purpose:
# Examine how pure-EV registrations have changed over time.
#
# This helps determine whether charging infrastructure demand
# is likely to be increasing.
#
# Pure EV labels:
#   Electric(Bov)
#   Pure Ev
#
# Hybrid vehicles are excluded.
#
# ============================================================


# ============================================================
# 22.1 PREPARE DATE VARIABLE
# ============================================================

kolkata_ev_trend <- kolkata_fuel %>%
  
  filter(
    fuel_type %in% c(
      "Electric(Bov)",
      "Pure Ev"
    )
  ) %>%
  
  mutate(
    date = as.Date(
      date,
      format = "%d-%m-%Y"
    )
  ) %>%
  
  group_by(
    date
  ) %>%
  
  summarise(
    
    ev_registrations = sum(
      registrations,
      na.rm = TRUE
    ),
    
    .groups = "drop"
    
  ) %>%
  
  arrange(
    date
  )


# ============================================================
# 22.2 DISPLAY EV TREND
# ============================================================

cat("\n================ KOLKATA EV REGISTRATION TREND ================\n")

print(
  kolkata_ev_trend,
  n = Inf
)


# ============================================================
# 22.3 SAVE EV TREND
# ============================================================

write.csv(
  
  kolkata_ev_trend,
  
  file.path(
    output_tables_path,
    "kolkata_ev_registration_trend.csv"
  ),
  
  row.names = FALSE
  
)


# ============================================================
# 22.4 VISUALIZE EV TREND
# ============================================================

ev_trend_plot <- ggplot(
  
  kolkata_ev_trend,
  
  aes(
    x = date,
    y = ev_registrations
  )
  
) +
  
  geom_line(
    linewidth = 1
  ) +
  
  geom_point(
    size = 2
  ) +
  
  labs(
    
    title = "Kolkata Pure-EV Registration Trend",
    
    subtitle = "Electric(Bov) and Pure Ev registrations",
    
    x = "Registration Date",
    
    y = "Pure-EV Registrations"
    
  ) +
  
  theme_minimal()


print(
  ev_trend_plot
)


# ============================================================
# 22.5 SAVE FIGURE
# ============================================================

ggsave(
  
  filename = file.path(
    output_figures_path,
    "kolkata_ev_registration_trend.png"
  ),
  
  plot = ev_trend_plot,
  
  width = 10,
  
  height = 6,
  
  dpi = 300
  
)

# ============================================================
# 23. ANNUAL PURE-EV REGISTRATION ANALYSIS
# ============================================================
#
# Purpose:
# Summarise pure-EV registrations by year.
#
# This provides a clearer view of long-term EV adoption
# compared with the monthly trend.
#
# ============================================================


# ============================================================
# 23.1 CALCULATE ANNUAL EV REGISTRATIONS
# ============================================================

kolkata_ev_annual <- kolkata_ev_trend %>%
  
  mutate(
    
    year = lubridate::year(date)
    
  ) %>%
  
  group_by(
    year
  ) %>%
  
  summarise(
    
    total_ev_registrations = sum(
      ev_registrations,
      na.rm = TRUE
    ),
    
    average_monthly_ev_registrations = mean(
      ev_registrations,
      na.rm = TRUE
    ),
    
    peak_monthly_ev_registrations = max(
      ev_registrations,
      na.rm = TRUE
    ),
    
    .groups = "drop"
    
  ) %>%
  
  arrange(
    year
  )


# ============================================================
# 23.2 DISPLAY ANNUAL RESULTS
# ============================================================

cat("\n================ ANNUAL KOLKATA EV DEMAND ================\n")

print(
  kolkata_ev_annual,
  n = Inf
)


# ============================================================
# 23.3 SAVE ANNUAL RESULTS
# ============================================================

write.csv(
  
  kolkata_ev_annual,
  
  file.path(
    output_tables_path,
    "kolkata_annual_ev_demand.csv"
  ),
  
  row.names = FALSE
  
)


# ============================================================
# 23.4 ANNUAL EV REGISTRATION PLOT
# ============================================================

annual_ev_plot <- ggplot(
  
  kolkata_ev_annual,
  
  aes(
    x = year,
    y = total_ev_registrations
  )
  
) +
  
  geom_col() +
  
  labs(
    
    title = "Annual Pure-EV Registrations in Kolkata",
    
    subtitle = "Based on available VAHAN fuel-type records",
    
    x = "Year",
    
    y = "Pure-EV Registrations"
    
  ) +
  
  scale_x_continuous(
    breaks = kolkata_ev_annual$year
  ) +
  
  theme_minimal()


print(
  annual_ev_plot
)


# ============================================================
# 23.5 SAVE ANNUAL FIGURE
# ============================================================

ggsave(
  
  filename = file.path(
    output_figures_path,
    "kolkata_annual_ev_demand.png"
  ),
  
  plot = annual_ev_plot,
  
  width = 10,
  
  height = 6,
  
  dpi = 300
  
)

# ============================================================
# 23.6 INTERPRETATION
# ============================================================
#
# The annual analysis shows a strong long-term increase in
# pure-EV registrations in Kolkata.
#
# Pure-EV registrations increased from 21 in 2019 to 1,384
# in 2023, indicating substantial growth in EV adoption.
#
# The average monthly registration level also increased
# considerably:
#
# 2019: approximately 2 EVs/month
# 2020: approximately 5 EVs/month
# 2021: approximately 16 EVs/month
# 2022: approximately 69 EVs/month
# 2023: approximately 115 EVs/month
#
# The 2024 figure requires careful interpretation because
# the available dataset contains observations only through
# May 2024.
#
# Therefore, the 1,178 registrations recorded in 2024 should
# NOT be directly compared with the full-year totals of
# previous years.
#
# Instead, the average monthly registration figure can be
# used as an early indicator of continued EV adoption.
#
# The results provide evidence that EV charging demand is
# likely to increase as the EV population grows.
#
# However, EV registrations alone cannot determine where
# charging infrastructure should be installed.
#
# The next stages therefore examine:
#
# 1. EV vehicle categories
# 2. Existing charging infrastructure
# 3. Infrastructure gaps
# 4. Geographic accessibility
# 5. Candidate locations
#
# ============================================================
# ============================================================
# ============================================================
# 23.7 ANNUAL EV REGISTRATION VISUALIZATION
# ============================================================

kolkata_ev_annual_plot_data <- kolkata_ev_annual %>%
  
  mutate(
    year_label = if_else(
      year == 2024,
      "2024*",
      as.character(year)
    )
  )


annual_ev_plot <- ggplot(
  kolkata_ev_annual_plot_data,
  aes(
    x = year_label,
    y = total_ev_registrations
  )
) +
  
  geom_col() +
  
  geom_text(
    aes(
      label = total_ev_registrations
    ),
    vjust = -0.4
  ) +
  
  labs(
    title = "Annual Pure-EV Registrations in Kolkata",
    subtitle = "2024 represents January–May observations only",
    x = "Year",
    y = "Pure-EV Registrations"
  ) +
  
  theme_minimal()


print(annual_ev_plot)


ggsave(
  filename = file.path(
    output_figures_path,
    "kolkata_annual_ev_registrations.png"
  ),
  plot = annual_ev_plot,
  width = 10,
  height = 6,
  dpi = 300
)
# ============================================================
# 24. KOLKATA VEHICLE CATEGORY ANALYSIS
# ============================================================
#
# Purpose:
# Understand the composition of vehicle registrations in
# Kolkata.
#
# This analysis is important because different vehicle
# categories have different charging requirements.
#
# IMPORTANT DATA LIMITATION:
#
# The VAHAN fuel dataset and vehicle-category dataset are
# separate aggregations.
#
# Therefore, we cannot directly identify the exact number
# of EVs within each vehicle category from these two datasets.
#
# We will therefore use the vehicle-category dataset to
# understand the broader vehicle structure, while the fuel
# dataset is used separately to measure pure-EV demand.
#
# ============================================================


# ============================================================
# 24.1 TOTAL REGISTRATIONS BY VEHICLE CATEGORY
# ============================================================

kolkata_vehicle_category_summary <- kolkata_category %>%
  
  group_by(
    vehicle_type
  ) %>%
  
  summarise(
    
    total_registrations = sum(
      registrations,
      na.rm = TRUE
    ),
    
    .groups = "drop"
    
  ) %>%
  
  arrange(
    desc(total_registrations)
  )


cat(
  "\n================ KOLKATA VEHICLE CATEGORY SUMMARY ================\n"
)

print(
  kolkata_vehicle_category_summary,
  n = Inf
)


# ============================================================
# 24.2 SHARE OF VEHICLE REGISTRATIONS
# ============================================================

kolkata_vehicle_category_summary <- 
  kolkata_vehicle_category_summary %>%
  
  mutate(
    
    registration_share = 
      total_registrations /
      sum(total_registrations) * 100
    
  )


cat(
  "\n================ VEHICLE CATEGORY SHARES ================\n"
)

print(
  kolkata_vehicle_category_summary,
  n = Inf
)


# ============================================================
# 24.3 SAVE RESULTS
# ============================================================

write.csv(
  
  kolkata_vehicle_category_summary,
  
  file.path(
    output_tables_path,
    "kolkata_vehicle_category_summary.csv"
  ),
  
  row.names = FALSE
  
)
# ============================================================
# 24.4 VEHICLE CATEGORY VISUALIZATION
# ============================================================

vehicle_category_plot <- ggplot(
  
  kolkata_vehicle_category_summary %>%
    slice_max(
      total_registrations,
      n = 10
    ),
  
  aes(
    x = reorder(
      vehicle_type,
      total_registrations
    ),
    y = total_registrations
  )
  
) +
  
  geom_col() +
  
  coord_flip() +
  
  labs(
    
    title = "Major Vehicle Categories in Kolkata",
    
    subtitle = "Based on total registrations in the available VAHAN data",
    
    x = "Vehicle Category",
    
    y = "Registrations"
    
  ) +
  
  theme_minimal()


print(
  vehicle_category_plot
)


ggsave(
  
  filename = file.path(
    output_figures_path,
    "kolkata_vehicle_category_distribution.png"
  ),
  
  plot = vehicle_category_plot,
  
  width = 10,
  
  height = 7,
  
  dpi = 300
  
)
# ============================================================
# 25. KOLKATA EXISTING CHARGING STATION INVENTORY
# ============================================================
#
# Purpose:
# Understand the existing EV charging infrastructure in
# Kolkata before identifying infrastructure gaps.
#
# The charging-station dataset contains manually compiled
# station information with geographic coordinates.
#
# This dataset will be used to:
#
# 1. Count existing charging stations
# 2. Examine station characteristics
# 3. Map existing stations
# 4. Identify spatial concentration
# 5. Identify potential infrastructure gaps
#
# ============================================================


# ============================================================
# 25.1 DEFINE CHARGING STATION FILE
# ============================================================

charging_station_file <- file.path(
  raw_data_path,
  "charging_stations",
  "kolkata_ev_charging_stations_master_with_verified_coordinates.csv"
)


# ============================================================
# 25.2 CHECK FILE EXISTS
# ============================================================

if (!file.exists(charging_station_file)) {
  
  stop(
    "Charging station dataset not found: ",
    charging_station_file
  )
  
}


# ============================================================
# 25.3 LOAD CHARGING STATION DATA
# ============================================================

kolkata_charging <- read_csv(
  
  charging_station_file,
  
  show_col_types = FALSE
  
)


# ============================================================
# 25.4 STANDARDISE COLUMN NAMES
# ============================================================

kolkata_charging <- kolkata_charging %>%
  
  janitor::clean_names()


# ============================================================
# 25.5 DISPLAY DATA STRUCTURE
# ============================================================

cat(
  "\n================ CHARGING STATION DATA STRUCTURE ================\n"
)

print(
  glimpse(kolkata_charging)
)


# ============================================================
# 25.6 DISPLAY COLUMN NAMES
# ============================================================

cat(
  "\n================ CHARGING STATION COLUMNS ================\n"
)

print(
  names(kolkata_charging)
)


# ============================================================
# 25.7 DISPLAY FIRST RECORDS
# ============================================================

cat(
  "\n================ CHARGING STATION SAMPLE ================\n"
)

print(
  kolkata_charging %>%
    head(10)
)

# ============================================================
# 26. CHARGING STATION DATA QUALITY & INVENTORY SUMMARY
# ============================================================
#
# Purpose:
# Before using the charging-station dataset for spatial
# analysis, we need to understand its completeness.
#
# We will examine:
#
# 1. Total number of station records
# 2. Missing coordinates
# 3. Duplicate station IDs
# 4. Charger types
# 5. Connector types
# 6. Operators
# 7. Geographic coverage
#
# This is important because the infrastructure-gap analysis
# depends on the quality and completeness of the station
# inventory.
#
# ============================================================


# ============================================================
# 26.1 TOTAL NUMBER OF STATIONS
# ============================================================

total_charging_stations <- nrow(
  kolkata_charging
)

cat(
  "\n================ TOTAL CHARGING STATIONS ================\n"
)

cat(
  "Total station records:",
  total_charging_stations,
  "\n"
)


# ============================================================
# 26.2 MISSING LATITUDE AND LONGITUDE
# ============================================================

coordinate_quality <- kolkata_charging %>%
  
  summarise(
    
    total_records = n(),
    
    missing_latitude = sum(
      is.na(latitude)
    ),
    
    missing_longitude = sum(
      is.na(longitude)
    ),
    
    complete_coordinates = sum(
      !is.na(latitude) &
        !is.na(longitude)
    )
    
  )


cat(
  "\n================ COORDINATE QUALITY ================\n"
)

print(
  coordinate_quality
)


# ============================================================
# 26.3 COORDINATE COMPLETENESS PERCENTAGE
# ============================================================

coordinate_quality <- coordinate_quality %>%
  
  mutate(
    
    coordinate_completeness_pct =
      complete_coordinates /
      total_records *
      100
    
  )


cat(
  "\nCoordinate completeness:",
  round(
    coordinate_quality$coordinate_completeness_pct,
    2
  ),
  "%\n"
)


# ============================================================
# 26.4 DUPLICATE STATION IDS
# ============================================================

duplicate_station_ids <- kolkata_charging %>%
  
  count(
    station_id,
    name = "records"
  ) %>%
  
  filter(
    records > 1
  )


cat(
  "\n================ DUPLICATE STATION IDS ================\n"
)

print(
  duplicate_station_ids
)


# ============================================================
# 26.5 CHARGER TYPE DISTRIBUTION
# ============================================================

charger_type_summary <- kolkata_charging %>%
  
  count(
    charger_type,
    sort = TRUE
  )


cat(
  "\n================ CHARGER TYPE DISTRIBUTION ================\n"
)

print(
  charger_type_summary,
  n = Inf
)


# ============================================================
# 26.6 CONNECTOR TYPE DISTRIBUTION
# ============================================================

connector_type_summary <- kolkata_charging %>%
  
  count(
    connector_type,
    sort = TRUE
  )


cat(
  "\n================ CONNECTOR TYPE DISTRIBUTION ================\n"
)

print(
  connector_type_summary,
  n = Inf
)


# ============================================================
# 26.7 OPERATOR DISTRIBUTION
# ============================================================

operator_summary <- kolkata_charging %>%
  
  count(
    operator,
    sort = TRUE
  )


cat(
  "\n================ CHARGING STATION OPERATORS ================\n"
)

print(
  operator_summary,
  n = Inf
)


# ============================================================
# 26.8 AREA DISTRIBUTION
# ============================================================

area_summary <- kolkata_charging %>%
  
  count(
    area,
    sort = TRUE
  )


cat(
  "\n================ CHARGING STATIONS BY AREA ================\n"
)

print(
  area_summary,
  n = Inf
)


# ============================================================
# 26.9 SAVE INVENTORY SUMMARIES
# ============================================================

write.csv(
  
  coordinate_quality,
  
  file.path(
    output_tables_path,
    "charging_station_coordinate_quality.csv"
  ),
  
  row.names = FALSE
  
)


write.csv(
  
  charger_type_summary,
  
  file.path(
    output_tables_path,
    "charging_station_charger_types.csv"
  ),
  
  row.names = FALSE
  
)


write.csv(
  
  connector_type_summary,
  
  file.path(
    output_tables_path,
    "charging_station_connector_types.csv"
  ),
  
  row.names = FALSE
  
)


write.csv(
  
  operator_summary,
  
  file.path(
    output_tables_path,
    "charging_station_operators.csv"
  ),
  
  row.names = FALSE
  
)


write.csv(
  
  area_summary,
  
  file.path(
    output_tables_path,
    "charging_station_area_distribution.csv"
  ),
  
  row.names = FALSE
  
)

# ============================================================
# DECISION LOG — SECTION 26
# ============================================================
#
# Decision:
# Charging-station inventory and spatial analysis will be
# treated as separate analytical components.
#
# Reason:
# The charging-station dataset contains 69 station records,
# but only 20 records have complete latitude and longitude.
#
# Therefore:
#
# - All 69 records are retained for infrastructure inventory
#   analysis.
#
# - Only records with valid coordinates will initially be used
#   for coordinate-based spatial analysis.
#
# - Missing coordinates must not be treated as geographic
#   absence.
#
# - Spatial infrastructure-gap conclusions will therefore be
#   subject to the coverage limitation of the coordinate data.
#
# This prevents the analysis from incorrectly interpreting
# missing geographic coordinates as missing charging stations.
#
# ============================================================
# ============================================================
# 27. CHARGING STATION GEOGRAPHIC DATA PREPARATION
# ============================================================
#
# Purpose:
# Prepare the Kolkata charging-station inventory for spatial
# analysis.
#
# The charging-station inventory contains:
#
#   Total station records = 69
#   Complete coordinates  = 20
#
# Therefore, this section does NOT assume that missing
# coordinates mean that a station does not exist.
#
# We create a separate spatial-analysis dataset containing
# only records with usable latitude and longitude.
#
# The complete 69-record dataset remains the master inventory.
#
# ============================================================


# ============================================================
# 27.1 CHECK LATITUDE AND LONGITUDE RANGES
# ============================================================
#
# Before converting the data into spatial objects, we check
# whether the available coordinates fall within plausible
# geographic ranges.
#
# Valid latitude:
#   -90 to +90
#
# Valid longitude:
#   -180 to +180
#
# This is a data-quality check.
# ============================================================

coordinate_range_check <- kolkata_charging %>%
  
  summarise(
    
    minimum_latitude = min(
      latitude,
      na.rm = TRUE
    ),
    
    maximum_latitude = max(
      latitude,
      na.rm = TRUE
    ),
    
    minimum_longitude = min(
      longitude,
      na.rm = TRUE
    ),
    
    maximum_longitude = max(
      longitude,
      na.rm = TRUE
    )
    
  )


cat(
  "\n================ COORDINATE RANGE CHECK ================\n"
)

print(
  coordinate_range_check
)


# ============================================================
# 27.2 IDENTIFY RECORDS WITH COMPLETE COORDINATES
# ============================================================
#
# A station is considered spatially usable when BOTH latitude
# and longitude are available.
#
# We do not attempt to infer missing coordinates at this stage.
# ============================================================

kolkata_charging_spatial <- kolkata_charging %>%
  
  filter(
    !is.na(latitude) &
      !is.na(longitude)
  )


cat(
  "\n================ SPATIALLY USABLE STATIONS ================\n"
)

cat(
  "Total station records:",
  nrow(kolkata_charging),
  "\n"
)

cat(
  "Stations with complete coordinates:",
  nrow(kolkata_charging_spatial),
  "\n"
)

cat(
  "Stations without complete coordinates:",
  nrow(kolkata_charging) -
    nrow(kolkata_charging_spatial),
  "\n"
)


# ============================================================
# 27.3 CALCULATE SPATIAL DATA COMPLETENESS
# ============================================================

spatial_data_completeness <- 
  nrow(kolkata_charging_spatial) /
  nrow(kolkata_charging) *
  100


cat(
  "Spatial coordinate completeness:",
  round(
    spatial_data_completeness,
    2
  ),
  "%\n"
)


# ============================================================
# 27.4 CHECK FOR DUPLICATE COORDINATES
# ============================================================
#
# Multiple stations may theoretically share the same
# coordinates.
#
# This does not automatically mean that the records are
# duplicates. Different operators or charging facilities can
# exist at the same location.
#
# Therefore, duplicate coordinates are flagged for inspection
# rather than automatically removed.
# ============================================================

duplicate_coordinates <- kolkata_charging_spatial %>%
  
  count(
    latitude,
    longitude,
    name = "station_count"
  ) %>%
  
  filter(
    station_count > 1
  ) %>%
  
  arrange(
    desc(station_count)
  )


cat(
  "\n================ DUPLICATE COORDINATES ================\n"
)

print(
  duplicate_coordinates,
  n = Inf
)


# ============================================================
# 27.5 CHECK STATION IDs IN SPATIAL DATA
# ============================================================
#
# Every spatially usable station should retain its original
# station ID.
#
# This allows the spatial dataset to be traced back to the
# master charging-station inventory.
# ============================================================

spatial_station_id_check <- kolkata_charging_spatial %>%
  
  summarise(
    
    total_spatial_records = n(),
    
    unique_station_ids = n_distinct(
      station_id
    ),
    
    missing_station_ids = sum(
      is.na(station_id) |
        station_id == ""
    )
    
  )


cat(
  "\n================ SPATIAL STATION ID CHECK ================\n"
)

print(
  spatial_station_id_check
)


# ============================================================
# 27.6 CREATE SF SPATIAL OBJECT
# ============================================================
#
# The coordinates are currently stored as ordinary numeric
# columns.
#
# We convert the dataset into an sf object so that spatial
# operations can be performed later.
#
# EPSG:4326 = WGS84 geographic coordinate system.
#
# This is appropriate for storing latitude/longitude data.
#
# IMPORTANT:
# Distance calculations should later use an appropriate
# projected or geodesic method rather than assuming that
# longitude/latitude values are planar distances.
# ============================================================

kolkata_charging_sf <- st_as_sf(
  
  kolkata_charging_spatial,
  
  coords = c(
    "longitude",
    "latitude"
  ),
  
  crs = 4326,
  
  remove = FALSE
  
)


cat(
  "\n================ SPATIAL OBJECT CREATED ================\n"
)

print(
  kolkata_charging_sf
)


# ============================================================
# 27.7 CHECK CRS
# ============================================================

cat(
  "\n================ SPATIAL CRS ================\n"
)

print(
  st_crs(
    kolkata_charging_sf
  )
)


# ============================================================
# 27.8 EXTRACT SPATIAL BOUNDING BOX
# ============================================================
#
# The bounding box provides the geographic extent of the
# coordinate-complete charging-station records.
#
# This is useful for checking whether the coordinates cover
# the expected Kolkata study area.
# ============================================================

charging_station_bbox <- st_bbox(
  kolkata_charging_sf
)


cat(
  "\n================ CHARGING STATION BOUNDING BOX ================\n"
)

print(
  charging_station_bbox
)


# ============================================================
# 27.9 SAVE SPATIAL DATASET
# ============================================================
#
# The spatial dataset is saved as a GeoPackage.
#
# GeoPackage is preferred over CSV for the spatial dataset
# because it preserves geometry.
# ============================================================

charging_spatial_file <- file.path(
  processed_data_path,
  "kolkata_charging_stations_spatial.gpkg"
)


st_write(
  
  kolkata_charging_sf,
  
  charging_spatial_file,
  
  delete_dsn = TRUE,
  
  quiet = TRUE
  
)


cat(
  "\nSpatial charging-station dataset saved to:\n",
  charging_spatial_file,
  "\n"
)


# ============================================================
# 27.10 SAVE SPATIAL DATA QUALITY SUMMARY
# ============================================================

spatial_data_quality_summary <- tibble(
  
  total_station_records =
    nrow(kolkata_charging),
  
  complete_coordinate_records =
    nrow(kolkata_charging_spatial),
  
  missing_coordinate_records =
    nrow(kolkata_charging) -
    nrow(kolkata_charging_spatial),
  
  coordinate_completeness_pct =
    spatial_data_completeness,
  
  unique_spatial_station_ids =
    spatial_station_id_check$unique_station_ids,
  
  missing_spatial_station_ids =
    spatial_station_id_check$missing_station_ids
  
)


write.csv(
  
  spatial_data_quality_summary,
  
  file.path(
    output_tables_path,
    "kolkata_charging_spatial_data_quality.csv"
  ),
  
  row.names = FALSE
  
)


# ============================================================
# 27.11 DECISION LOG
# ============================================================
#
# Decision:
# The 69-record charging-station inventory will remain the
# master infrastructure inventory.
#
# For coordinate-based spatial analysis, only records with
# complete latitude and longitude will initially be used.
#
# Reason:
# Only 20 of the 69 records currently contain complete
# coordinates.
#
# Therefore:
#
#   Master infrastructure inventory = 69 records
#
#   Spatially usable inventory      = 20 records
#
# Missing coordinates are NOT interpreted as absence of
# charging infrastructure.
#
# This distinction is critical for the later infrastructure
# gap analysis.
#
# ============================================================

# ============================================================
# 28. KOLKATA CHARGING STATION SPATIAL DISTRIBUTION
# ============================================================
#
# Purpose:
# Examine the geographic distribution of existing EV charging
# stations in Kolkata using the available verified coordinates.
#
# This analysis is an important step toward identifying
# potential infrastructure gaps.
#
# IMPORTANT DATA LIMITATION:
#
# The charging-station inventory contains 69 station records,
# but only 20 records have both latitude and longitude.
#
# Therefore:
#
# - All 69 records remain part of the station inventory.
# - Only stations with complete coordinates are used for
#   spatial mapping and coordinate-based analysis.
#
# We do NOT assume that the 49 stations without coordinates
# are absent from Kolkata.
#
# ============================================================


# ============================================================
# 28.1 IDENTIFY STATIONS WITH COMPLETE COORDINATES
# ============================================================
#
# A station is considered spatially usable only when both
# latitude and longitude are available.
#
# ============================================================

kolkata_charging_spatial <- kolkata_charging %>%
  
  filter(
    !is.na(latitude) &
      !is.na(longitude)
  )


cat(
  "\n================ SPATIALLY USABLE CHARGING STATIONS ================\n"
)

cat(
  "Stations with complete coordinates:",
  nrow(kolkata_charging_spatial),
  "\n"
)

cat(
  "Total charging station records:",
  nrow(kolkata_charging),
  "\n"
)


# ============================================================
# 28.2 CALCULATE SPATIAL COVERAGE
# ============================================================
#
# This measures what percentage of the station inventory can
# currently be represented spatially.
#
# ============================================================

charging_spatial_coverage <- kolkata_charging %>%
  
  summarise(
    
    total_station_records = n(),
    
    stations_with_coordinates = sum(
      !is.na(latitude) &
        !is.na(longitude)
    ),
    
    stations_without_coordinates = sum(
      is.na(latitude) |
        is.na(longitude)
    )
    
  ) %>%
  
  mutate(
    
    spatial_coverage_pct =
      stations_with_coordinates /
      total_station_records *
      100
    
  )


cat(
  "\n================ CHARGING STATION SPATIAL COVERAGE ================\n"
)

print(
  charging_spatial_coverage
)


# ============================================================
# 28.3 CHECK COORDINATE RANGE
# ============================================================
#
# Before creating the map, we check the minimum and maximum
# latitude and longitude values.
#
# This helps identify obviously invalid coordinates.
#
# ============================================================

coordinate_range <- kolkata_charging_spatial %>%
  
  summarise(
    
    minimum_latitude = min(
      latitude,
      na.rm = TRUE
    ),
    
    maximum_latitude = max(
      latitude,
      na.rm = TRUE
    ),
    
    minimum_longitude = min(
      longitude,
      na.rm = TRUE
    ),
    
    maximum_longitude = max(
      longitude,
      na.rm = TRUE
    )
    
  )


cat(
  "\n================ CHARGING STATION COORDINATE RANGE ================\n"
)

print(
  coordinate_range
)


# ============================================================
# 28.4 DISPLAY GEOCODED STATIONS
# ============================================================
#
# This table provides the stations that will actually appear
# in the spatial analysis.
#
# ============================================================

cat(
  "\n================ GEOCODED KOLKATA CHARGING STATIONS ================\n"
)

print(
  kolkata_charging_spatial %>%
    select(
      station_id,
      station_name,
      operator,
      charger_type,
      connector_type,
      area,
      latitude,
      longitude
    ),
  n = Inf
)


# ============================================================
# 28.5 SAVE SPATIAL STATION DATA
# ============================================================

write.csv(
  
  kolkata_charging_spatial,
  
  file.path(
    output_tables_path,
    "kolkata_charging_stations_spatial.csv"
  ),
  
  row.names = FALSE
  
)


# ============================================================
# 28.6 SAVE SPATIAL COVERAGE SUMMARY
# ============================================================

write.csv(
  
  charging_spatial_coverage,
  
  file.path(
    output_tables_path,
    "kolkata_charging_station_spatial_coverage.csv"
  ),
  
  row.names = FALSE
  
)


# ============================================================
# 28.7 VISUALIZE CHARGING STATION LOCATIONS
# ============================================================
#
# At this stage we use the coordinates directly.
#
# This is a point-distribution plot rather than a full
# geographic basemap.
#
# A geographic basemap can be introduced later if required.
#
# ============================================================

charging_station_spatial_plot <- ggplot(
  
  kolkata_charging_spatial,
  
  aes(
    x = longitude,
    y = latitude
  )
  
) +
  
  geom_point(
    size = 3,
    alpha = 0.8
  ) +
  
  labs(
    
    title = "Spatial Distribution of EV Charging Stations in Kolkata",
    
    subtitle = "Based on the 20 station records with complete coordinates",
    
    x = "Longitude",
    
    y = "Latitude"
    
  ) +
  
  theme_minimal()


print(
  charging_station_spatial_plot
)


# ============================================================
# 28.8 SAVE SPATIAL DISTRIBUTION FIGURE
# ============================================================

ggsave(
  
  filename = file.path(
    output_figures_path,
    "kolkata_charging_station_spatial_distribution.png"
  ),
  
  plot = charging_station_spatial_plot,
  
  width = 10,
  
  height = 7,
  
  dpi = 300
  
)


# ============================================================
# 28.9 CHARGING STATIONS BY AREA AMONG GEOCODED RECORDS
# ============================================================
#
# This provides an additional view of where the spatially
# usable charging stations are concentrated.
#
# ============================================================

spatial_area_summary <- kolkata_charging_spatial %>%
  
  count(
    area,
    sort = TRUE
  )


cat(
  "\n================ GEOCODED STATIONS BY AREA ================\n"
)

print(
  spatial_area_summary,
  n = Inf
)


# ============================================================
# 28.10 SAVE GEOCODED AREA SUMMARY
# ============================================================

write.csv(
  
  spatial_area_summary,
  
  file.path(
    output_tables_path,
    "kolkata_geocoded_charging_stations_by_area.csv"
  ),
  
  row.names = FALSE
  
)


# ============================================================
# 28.11 DECISION LOG
# ============================================================
#
# Decision:
# Use only charging-station records with complete latitude
# and longitude for spatial analysis.
#
# Rationale:
# 49 of the 69 charging-station records do not have complete
# coordinates. Including them in coordinate-based analysis
# would require assumptions about their locations.
#
# Therefore, the spatial analysis is based on 20 geocoded
# stations, while the complete 69-record inventory continues
# to be used for non-spatial station analysis.
#
# ============================================================
# ============================================================
# 29. KOLKATA CHARGING STATION SPATIAL CONCENTRATION
# ============================================================
#
# Purpose:
# Quantify the spatial concentration of the existing
# geocoded EV charging stations in Kolkata.
#
# Section 28 established that only 20 of the 69 charging
# station records have complete geographic coordinates.
#
# Therefore, this analysis uses only those 20 geocoded
# stations.
#
# The purpose is NOT to declare infrastructure gaps yet.
#
# Instead, we first establish:
#
# 1. How close charging stations are to one another
# 2. Whether stations are spatially concentrated
# 3. Whether some stations are relatively isolated
#
# These results will support the later infrastructure-gap
# analysis.
#
# IMPORTANT DATA LIMITATION:
#
# The analysis is based on 20 geocoded stations rather than
# the complete 69-record inventory.
#
# ============================================================


# ============================================================
# 29.1 CHECK REQUIRED PACKAGE
# ============================================================
#
# We use the sf package for geographic distance calculations.
#
# ============================================================

if (!requireNamespace("sf", quietly = TRUE)) {
  
  stop(
    "Package 'sf' is required for Section 29. Please install it using install.packages('sf')."
  )
  
}


# ============================================================
# 29.2 CONVERT CHARGING STATIONS TO SPATIAL OBJECT
# ============================================================
#
# Latitude and longitude are geographic coordinates.
#
# EPSG:4326 represents WGS84 latitude/longitude coordinates.
#
# ============================================================

kolkata_charging_sf <- sf::st_as_sf(
  
  kolkata_charging_spatial,
  
  coords = c(
    "longitude",
    "latitude"
  ),
  
  crs = 4326,
  
  remove = FALSE
  
)


# ============================================================
# 29.3 DISPLAY SPATIAL OBJECT
# ============================================================

cat(
  "\n================ KOLKATA CHARGING STATION SPATIAL OBJECT ================\n"
)

print(
  kolkata_charging_sf
)


# ============================================================
# 29.4 CALCULATE PAIRWISE DISTANCES
# ============================================================
#
# st_distance() calculates the geographic distance between
# all pairs of charging stations.
#
# Distances are converted to kilometres.
#
# ============================================================

charging_distance_matrix <- sf::st_distance(
  
  kolkata_charging_sf
  
)


charging_distance_matrix_km <- 
  units::set_units(
    charging_distance_matrix,
    "km"
  )


# ============================================================
# 29.5 IDENTIFY NEAREST CHARGING STATION
# ============================================================
#
# For each station, we identify the distance to its nearest
# OTHER charging station.
#
# The distance from a station to itself is zero, so it is
# excluded from the minimum calculation.
#
# ============================================================

nearest_station_distance <- sapply(
  
  seq_len(
    nrow(
      charging_distance_matrix_km
    )
  ),
  
  function(i) {
    
    distances <- as.numeric(
      charging_distance_matrix_km[i, ]
    )
    
    distances[i] <- NA
    
    min(
      distances,
      na.rm = TRUE
    )
    
  }
  
)


# ============================================================
# 29.6 CREATE NEAREST-STATION SUMMARY
# ============================================================

kolkata_nearest_station <- kolkata_charging_spatial %>%
  
  mutate(
    
    nearest_station_distance_km =
      nearest_station_distance
    
  ) %>%
  
  arrange(
    desc(
      nearest_station_distance_km
    )
  )


cat(
  "\n================ NEAREST CHARGING STATION DISTANCES ================\n"
)

print(
  kolkata_nearest_station %>%
    select(
      station_id,
      station_name,
      area,
      nearest_station_distance_km
    ),
  n = Inf
)


# ============================================================
# 29.7 SUMMARY OF SPATIAL CONCENTRATION
# ============================================================
#
# The average nearest-station distance provides a simple
# measure of how closely the geocoded charging stations are
# clustered.
#
# A large nearest-station distance indicates a relatively
# isolated station within the mapped inventory.
#
# ============================================================

charging_spatial_concentration <- 
  kolkata_nearest_station %>%
  
  summarise(
    
    number_of_geocoded_stations = n(),
    
    average_nearest_station_distance_km =
      mean(
        nearest_station_distance_km,
        na.rm = TRUE
      ),
    
    median_nearest_station_distance_km =
      median(
        nearest_station_distance_km,
        na.rm = TRUE
      ),
    
    minimum_nearest_station_distance_km =
      min(
        nearest_station_distance_km,
        na.rm = TRUE
      ),
    
    maximum_nearest_station_distance_km =
      max(
        nearest_station_distance_km,
        na.rm = TRUE
      )
    
  )


cat(
  "\n================ CHARGING STATION SPATIAL CONCENTRATION ================\n"
)

print(
  charging_spatial_concentration
)


# ============================================================
# 29.8 IDENTIFY RELATIVELY ISOLATED STATIONS
# ============================================================
#
# We identify stations whose nearest charging station is
# relatively far away.
#
# We use the upper quartile as a data-driven threshold rather
# than inventing an arbitrary distance threshold.
#
# IMPORTANT:
#
# This does NOT mean these stations are infrastructure gaps.
#
# It only means that, within the currently geocoded inventory,
# they are relatively spatially isolated.
#
# ============================================================

isolation_threshold <- quantile(
  
  kolkata_nearest_station$nearest_station_distance_km,
  
  probs = 0.75,
  
  na.rm = TRUE
  
)


kolkata_isolated_stations <- 
  kolkata_nearest_station %>%
  
  filter(
    
    nearest_station_distance_km >=
      isolation_threshold
    
  )


cat(
  "\n================ RELATIVELY ISOLATED CHARGING STATIONS ================\n"
)

cat(
  "Upper-quartile nearest-station distance:",
  round(
    isolation_threshold,
    2
  ),
  "km\n"
)

print(
  kolkata_isolated_stations %>%
    select(
      station_id,
      station_name,
      area,
      nearest_station_distance_km
    ),
  n = Inf
)


# ============================================================
# 29.9 SAVE NEAREST-STATION ANALYSIS
# ============================================================

write.csv(
  
  kolkata_nearest_station,
  
  file.path(
    output_tables_path,
    "kolkata_charging_station_nearest_distance.csv"
  ),
  
  row.names = FALSE
  
)


# ============================================================
# 29.10 SAVE SPATIAL CONCENTRATION SUMMARY
# ============================================================

write.csv(
  
  charging_spatial_concentration,
  
  file.path(
    output_tables_path,
    "kolkata_charging_spatial_concentration.csv"
  ),
  
  row.names = FALSE
  
)


# ============================================================
# 29.11 SAVE RELATIVELY ISOLATED STATIONS
# ============================================================

write.csv(
  
  kolkata_isolated_stations,
  
  file.path(
    output_tables_path,
    "kolkata_relatively_isolated_charging_stations.csv"
  ),
  
  row.names = FALSE
  
)


# ============================================================
# 29.12 VISUALIZE NEAREST-STATION DISTANCES
# ============================================================
#
# This chart shows the nearest charging-station distance for
# each geocoded station.
#
# Larger values indicate stations that are more spatially
# isolated within the mapped inventory.
#
# ============================================================

nearest_distance_plot <- ggplot(
  
  kolkata_nearest_station,
  
  aes(
    
    x = reorder(
      station_id,
      nearest_station_distance_km
    ),
    
    y = nearest_station_distance_km
    
  )
  
) +
  
  geom_col() +
  
  coord_flip() +
  
  labs(
    
    title = "Nearest Charging Station Distance in Kolkata",
    
    subtitle = "Based on the 20 geocoded charging-station records",
    
    x = "Charging Station",
    
    y = "Distance to Nearest Station (km)"
    
  ) +
  
  theme_minimal()


print(
  nearest_distance_plot
)


# ============================================================
# 29.13 SAVE FIGURE
# ============================================================

ggsave(
  
  filename = file.path(
    output_figures_path,
    "kolkata_charging_station_nearest_distance.png"
  ),
  
  plot = nearest_distance_plot,
  
  width = 10,
  
  height = 7,
  
  dpi = 300
  
)


# ============================================================
# 29.14 DECISION LOG
# ============================================================
#
# Decision:
# Use nearest-station distance as an initial measure of
# spatial concentration/isolation.
#
# Rationale:
# A simple station-location map shows where stations exist,
# but distance-based analysis provides a quantitative measure
# of spatial separation.
#
# The upper quartile is used to identify relatively isolated
# stations because it is derived from the observed data rather
# than from an arbitrary distance threshold.
#
# Limitation:
# Because only 20 of 69 charging-station records have complete
# coordinates, these results describe the spatial structure of
# the GEOCODED INVENTORY, not necessarily the complete
# charging infrastructure of Kolkata.
#
# Therefore, these results will be used as supporting evidence
# rather than as the sole basis for identifying infrastructure
# gaps.
#
# ============================================================
# ============================================================
# 30. KOLKATA CHARGING STATION SPATIAL MAP
# ============================================================
#
# Purpose:
# Visualize the geographic distribution of the charging
# stations for which verified/usable coordinates are available.
#
# This map provides a visual representation of the existing
# charging infrastructure in Kolkata.
#
# IMPORTANT DATA LIMITATION:
#
# The complete charging-station inventory contains 69 records.
#
# However, only 20 records have complete latitude and longitude
# coordinates.
#
# Therefore, this map represents the GEOCODED SUBSET of the
# charging-station inventory rather than all 69 records.
#
# The map should therefore NOT be interpreted as a complete
# map of every charging station in Kolkata.
#
# ============================================================


# ============================================================
# 30.1 CHECK SPATIAL DATA
# ============================================================

cat(
  "\n================ KOLKATA CHARGING STATION MAP DATA ================\n"
)


cat(
  "Number of geocoded charging stations:",
  nrow(kolkata_charging_sf),
  "\n"
)


# ============================================================
# 30.2 CREATE BASIC SPATIAL MAP
# ============================================================
#
# We use the longitude and latitude coordinates already
# converted into an sf spatial object in Section 29.
#
# No external basemap is used at this stage.
#
# This keeps the analysis reproducible and avoids dependence
# on an external map service.
#
# ============================================================

charging_station_map <- ggplot() +
  
  geom_sf(
    data = kolkata_charging_sf,
    size = 3,
    alpha = 0.8
  ) +
  
  labs(
    
    title = "Existing EV Charging Stations in Kolkata",
    
    subtitle = paste0(
      "Geocoded subset of charging-station inventory (n = ",
      nrow(kolkata_charging_sf),
      ")"
    ),
    
    x = "Longitude",
    
    y = "Latitude"
    
  ) +
  
  theme_minimal()


# ============================================================
# 30.3 DISPLAY MAP
# ============================================================

print(
  charging_station_map
)


# ============================================================
# 30.4 SAVE MAP
# ============================================================

ggsave(
  
  filename = file.path(
    output_figures_path,
    "kolkata_charging_station_spatial_map.png"
  ),
  
  plot = charging_station_map,
  
  width = 10,
  
  height = 7,
  
  dpi = 300
  
)


# ============================================================
# 30.5 CREATE MAP WITH STATION LABELS
# ============================================================
#
# A labelled version is useful for identifying individual
# stations and comparing their locations with the isolation
# results from Section 29.
#
# Station IDs are used instead of full station names to keep
# the visualization readable.
#
# ============================================================

charging_station_label_map <- ggplot() +
  
  geom_sf(
    data = kolkata_charging_sf,
    size = 3,
    alpha = 0.8
  ) +
  
  geom_text(
    
    data = kolkata_charging_sf,
    
    aes(
      x = longitude,
      y = latitude,
      label = station_id
    ),
    
    nudge_y = 0.003,
    
    size = 3
    
  ) +
  
  labs(
    
    title = "Geocoded EV Charging Stations in Kolkata",
    
    subtitle = "Station IDs shown for spatial identification",
    
    x = "Longitude",
    
    y = "Latitude"
    
  ) +
  
  theme_minimal()


# ============================================================
# 30.6 DISPLAY LABELLED MAP
# ============================================================

print(
  charging_station_label_map
)


# ============================================================
# 30.7 SAVE LABELLED MAP
# ============================================================

ggsave(
  
  filename = file.path(
    output_figures_path,
    "kolkata_charging_station_spatial_map_labelled.png"
  ),
  
  plot = charging_station_label_map,
  
  width = 12,
  
  height = 8,
  
  dpi = 300
  
)


# ============================================================
# 30.8 DECISION LOG
# ============================================================
#
# Decision:
#
# Use the 20 geocoded charging-station records to visualize
# the spatial distribution of the currently mapped charging
# infrastructure.
#
# Rationale:
#
# A spatial map makes it possible to visually examine whether
# charging stations appear concentrated in particular parts of
# Kolkata and whether some locations appear relatively isolated.
#
# The map complements the quantitative nearest-station analysis
# performed in Section 29.
#
# Limitation:
#
# Only 20 of the 69 charging-station records contain complete
# geographic coordinates.
#
# Therefore, absence of a station on this map does NOT prove
# that charging infrastructure is absent from that location.
#
# The map will therefore be used as supporting evidence in the
# later infrastructure-gap and site-selection analysis.
#
# ============================================================
# ============================================================
# 31. KOLKATA CHARGING INFRASTRUCTURE GAP ANALYSIS
# ============================================================
#
# Purpose:
#
# Identify areas that appear relatively underserved by the
# currently mapped EV charging infrastructure.
#
# This section combines:
#
#   1. Existing geocoded charging stations
#   2. Spatial distance between charging stations
#   3. Kolkata's observed EV registration demand
#
# The objective is NOT to claim that a location has absolutely
# no charging infrastructure.
#
# Instead, we identify areas that appear to have weaker
# accessibility to the currently mapped charging stations.
#
# ============================================================
#
# IMPORTANT DATA LIMITATION:
#
# The charging-station inventory contains 69 records.
#
# Only 20 records contain complete latitude and longitude
# coordinates and can therefore be used for spatial analysis.
#
# Consequently, this gap analysis represents gaps relative to
# the GEOCODED charging-station inventory.
#
# It does NOT prove that charging stations are absent from
# locations that do not appear in the spatial analysis.
#
# ============================================================


# ============================================================
# 31.1 CHECK REQUIRED SPATIAL OBJECT
# ============================================================
#
# Section 29 created `kolkata_charging_sf`.
#
# We verify that the object exists before continuing.
#
# ============================================================

if (!exists("kolkata_charging_sf")) {
  
  stop(
    "kolkata_charging_sf was not found. ",
    "Run Section 29 before Section 31."
  )
  
}


# ============================================================
# 31.2 DISPLAY NUMBER OF GEOCODED STATIONS
# ============================================================

cat(
  "\n================ GAP ANALYSIS INPUT ================\n"
)

cat(
  "Geocoded charging stations:",
  nrow(kolkata_charging_sf),
  "\n"
)


# ============================================================
# 31.3 CALCULATE PAIRWISE DISTANCES BETWEEN STATIONS
# ============================================================
#
# We calculate the distance between every pair of geocoded
# charging stations.
#
# This helps identify stations that are relatively isolated
# from the rest of the mapped charging network.
#
# We use the sf geometry rather than calculating distances
# manually from latitude and longitude.
#
# ============================================================

station_distance_matrix <- st_distance(
  kolkata_charging_sf
)


# ============================================================
# 31.4 CONVERT DISTANCES TO KILOMETRES
# ============================================================
#
# `st_distance()` returns distances using the spatial reference
# system of the sf object.
#
# We convert the resulting matrix to kilometres for easier
# interpretation.
#
# ============================================================

station_distance_km <- units::drop_units(
  station_distance_matrix
) / 1000


# ============================================================
# 31.5 FIND NEAREST OTHER CHARGING STATION
# ============================================================
#
# The diagonal of the distance matrix represents the distance
# from a station to itself, which is zero.
#
# Therefore, we replace the diagonal with NA before identifying
# the minimum distance.
#
# ============================================================

diag(
  station_distance_km
) <- NA


kolkata_charging_sf$nearest_station_distance_km <- apply(
  
  station_distance_km,
  
  1,
  
  min,
  
  na.rm = TRUE
  
)


# ============================================================
# 31.6 DISPLAY STATION ACCESSIBILITY
# ============================================================

station_accessibility <- kolkata_charging_sf %>%
  
  st_drop_geometry() %>%
  
  select(
    station_id,
    station_name,
    area,
    operator,
    charger_type,
    nearest_station_distance_km
  ) %>%
  
  arrange(
    desc(nearest_station_distance_km)
  )


cat(
  "\n================ STATION SPATIAL ACCESSIBILITY ================\n"
)

print(
  station_accessibility,
  n = Inf
)


# ============================================================
# 31.7 IDENTIFY RELATIVELY ISOLATED STATIONS
# ============================================================
#
# A station with a relatively large distance to its nearest
# neighbouring station may indicate an area where charging
# infrastructure is spatially dispersed.
#
# We use the median nearest-station distance as a descriptive
# threshold.
#
# This is a data-driven descriptive threshold rather than a
# regulatory or engineering standard.
#
# ============================================================

median_nearest_distance <- median(
  
  station_accessibility$nearest_station_distance_km,
  
  na.rm = TRUE
  
)


station_accessibility <- station_accessibility %>%
  
  mutate(
    
    relatively_isolated =
      nearest_station_distance_km >
      median_nearest_distance
    
  )


cat(
  "\nMedian nearest-station distance:",
  round(
    median_nearest_distance,
    2
  ),
  "km\n"
)


cat(
  "\n================ RELATIVELY ISOLATED STATIONS ================\n"
)

print(
  
  station_accessibility %>%
    filter(
      relatively_isolated
    ),
  
  n = Inf
  
)


# ============================================================
# 31.8 SUMMARY OF SPATIAL ACCESSIBILITY
# ============================================================

spatial_accessibility_summary <- station_accessibility %>%
  
  summarise(
    
    number_of_geocoded_stations = n(),
    
    minimum_nearest_station_distance_km =
      min(
        nearest_station_distance_km,
        na.rm = TRUE
      ),
    
    median_nearest_station_distance_km =
      median(
        nearest_station_distance_km,
        na.rm = TRUE
      ),
    
    maximum_nearest_station_distance_km =
      max(
        nearest_station_distance_km,
        na.rm = TRUE
      ),
    
    average_nearest_station_distance_km =
      mean(
        nearest_station_distance_km,
        na.rm = TRUE
      )
    
  )


cat(
  "\n================ SPATIAL ACCESSIBILITY SUMMARY ================\n"
)

print(
  spatial_accessibility_summary
)


# ============================================================
# 31.9 CREATE DESCRIPTIVE GAP INDICATOR
# ============================================================
#
# To support later site-selection analysis, we create a simple
# descriptive classification:
#
#   High accessibility
#   Lower accessibility
#
# based on the median nearest-station distance.
#
# IMPORTANT:
#
# This is NOT a final site-suitability score.
#
# It is only a descriptive indicator showing which existing
# stations are relatively isolated within the geocoded network.
#
# ============================================================

station_accessibility <- station_accessibility %>%
  
  mutate(
    
    accessibility_group = if_else(
      
      nearest_station_distance_km <=
        median_nearest_distance,
      
      "Relatively higher accessibility",
      
      "Relatively lower accessibility"
      
    )
    
  )


cat(
  "\n================ ACCESSIBILITY CLASSIFICATION ================\n"
)

print(
  station_accessibility,
  n = Inf
)


# ============================================================
# 31.10 COUNT ACCESSIBILITY GROUPS
# ============================================================

accessibility_group_summary <- station_accessibility %>%
  
  count(
    accessibility_group,
    sort = TRUE
  )


cat(
  "\n================ ACCESSIBILITY GROUP SUMMARY ================\n"
)

print(
  accessibility_group_summary,
  n = Inf
)


# ============================================================
# 31.11 VISUALIZE NEAREST-STATION DISTANCE
# ============================================================
#
# This plot shows the spatial accessibility of each geocoded
# station.
#
# Larger values indicate that a station is farther away from
# its nearest mapped neighbouring station.
#
# ============================================================

station_accessibility_plot <- ggplot(
  
  station_accessibility,
  
  aes(
    x = reorder(
      station_id,
      nearest_station_distance_km
    ),
    
    y = nearest_station_distance_km
  )
  
) +
  
  geom_col() +
  
  geom_hline(
    
    yintercept = median_nearest_distance,
    
    linetype = "dashed"
    
  ) +
  
  coord_flip() +
  
  labs(
    
    title = "Nearest-Station Accessibility in Kolkata",
    
    subtitle = paste0(
      "Dashed line = median nearest-station distance (",
      round(
        median_nearest_distance,
        2
      ),
      " km)"
    ),
    
    x = "Charging Station",
    
    y = "Distance to Nearest Mapped Station (km)"
    
  ) +
  
  theme_minimal()


print(
  station_accessibility_plot
)


# ============================================================
# 31.12 SAVE ACCESSIBILITY PLOT
# ============================================================

ggsave(
  
  filename = file.path(
    output_figures_path,
    "kolkata_station_accessibility.png"
  ),
  
  plot = station_accessibility_plot,
  
  width = 10,
  
  height = 7,
  
  dpi = 300
  
)


# ============================================================
# 31.13 SAVE ACCESSIBILITY RESULTS
# ============================================================

write.csv(
  
  station_accessibility,
  
  file.path(
    output_tables_path,
    "kolkata_station_accessibility.csv"
  ),
  
  row.names = FALSE
  
)


write.csv(
  
  spatial_accessibility_summary,
  
  file.path(
    output_tables_path,
    "kolkata_spatial_accessibility_summary.csv"
  ),
  
  row.names = FALSE
  
)


write.csv(
  
  accessibility_group_summary,
  
  file.path(
    output_tables_path,
    "kolkata_accessibility_group_summary.csv"
  ),
  
  row.names = FALSE
  
)


# ============================================================
# 31.14 DECISION LOG
# ============================================================
#
# Decision:
#
# Use the geocoded charging-station network to identify
# relatively lower-accessibility parts of the mapped network.
#
# Rationale:
#
# Existing infrastructure must be understood before proposing
# new charging locations.
#
# A station that is relatively far from its nearest mapped
# station provides evidence of spatial dispersion and can help
# identify areas that require further investigation.
#
# The median nearest-station distance is used as a descriptive
# threshold because it is derived from the observed dataset
# rather than imposed arbitrarily.
#
# Limitation:
#
# This analysis does NOT measure population-level accessibility,
# traffic demand, road-network travel time, EV density by
# neighbourhood, or charging utilisation.
#
# It also cannot establish that an area without a mapped station
# has no charging infrastructure because only 20 of the 69
# station records have complete coordinates.
#
# Therefore, the results are treated as screening evidence for
# subsequent candidate-site analysis rather than as final
# infrastructure-gap conclusions.
#
# ============================================================