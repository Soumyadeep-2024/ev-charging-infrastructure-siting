# ============================================================
# EV CHARGING INFRASTRUCTURE SITING & LOCATION ANALYTICS
# ============================================================
#
# Project: CTY-12 — City
# Domain: Electric Vehicle Infrastructure / Urban Mobility
# Project Type: Business Analytics / Decision Support System
#
# Primary Language: R
#
# ------------------------------------------------------------
# PROJECT OBJECTIVE
# ------------------------------------------------------------
#
# This project aims to develop a data-driven decision-support
# framework for identifying and ranking suitable locations
# for future EV charging infrastructure.
#
# The analysis considers:
#
# 1. EV demand
# 2. EV vehicle categories
# 3. Existing charging infrastructure
# 4. Infrastructure gaps
# 5. Accessibility
# 6. Parking availability
# 7. Population and locality characteristics
# 8. Commercial activity
# 9. Estimated charging demand
# 10. Financial feasibility
#
# The final objective is not simply to identify where EVs exist.
# It is to determine where charging infrastructure has the
# strongest combination of:
#
# - Demand potential
# - Infrastructure need
# - Accessibility
# - Locality potential
# - Financial viability
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
# 2. RESEARCH QUESTIONS
# ============================================================
#
# The analysis will attempt to answer the following questions:
#
# EV DEMAND
# - Where are EVs concentrated?
# - Which EV categories are most common?
# - How does EV distribution vary geographically?
#
# INFRASTRUCTURE
# - Where are existing charging stations located?
# - Which areas have relatively low charging infrastructure?
# - Where are potential infrastructure gaps?
#
# ACCESSIBILITY
# - Which areas are easily accessible?
# - Which areas are close to major roads?
# - Where is parking available?
#
# LOCATION SUITABILITY
# - Which areas combine high demand with infrastructure gaps?
# - Which locations have strong accessibility?
# - Which locations have favourable locality characteristics?
#
# FINANCIAL FEASIBILITY
# - What is the estimated charging demand?
# - What is the estimated revenue?
# - What is the estimated operating cost?
# - What is the estimated payback period?
#
# ============================================================
# ============================================================
# 3. SETUP & PACKAGES
# ============================================================

# Clear objects from the current R environment.
# This helps ensure that results do not depend on variables
# left over from previous runs.

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

# Additional packages will be added only when required.
# ============================================================
# 4. PROJECT DIRECTORIES
# ============================================================

raw_vahan_path <- "data/raw/vahan/"
raw_rto_path <- "data/raw/rto/"
raw_charging_path <- "data/raw/charging_stations/"

processed_path <- "data/processed/"

figures_path <- "outputs/figures/"
tables_path <- "outputs/tables/"
maps_path <- "outputs/maps/"
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
# Project Progress: City Selection Methodology

## Why City Selection Was Reconsidered

Initially, the project planned to select a city first and then identify
suitable locations for EV charging stations within that city.

During the initial data-source investigation, it became clear that
selecting a city without first comparing its EV demand and existing
charging infrastructure could introduce selection bias.

Therefore, the project methodology has been revised.

Instead of assuming a city, multiple candidate cities will first be
compared using available data. The city showing the greatest evidence of
unmet EV charging infrastructure demand will then be selected for the
detailed site-selection analysis.

---

## Stage 1: City-Level Viability Analysis

The first stage will answer:

> Which city requires additional EV charging infrastructure the most?

The comparison will consider the following factors:

### EV Demand

- Total number of registered EVs
- Electric two-wheelers
- Electric three-wheelers
- E-rickshaws
- Electric cars
- Other relevant EV categories

### EV Intensity

To make cities comparable, EV numbers will also be normalized using:

- EVs per 1,000 population
- EVs per square kilometre
- E-rickshaws per 1,000 population

### Existing Charging Infrastructure

The analysis will examine:

- Number of existing charging stations
- Number of charging points, where available
- Charging station density
- Geographic distribution of charging infrastructure

### Infrastructure Gap

The following indicators will be explored:

```text
EVs per charging station

E-rickshaws per charging station

Charging stations per 1,000 EVs