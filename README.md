# EV Charging Infrastructure Siting & Location Analytics

## Theme Information

- **Theme ID:** CTY-12
- **Category:** City
- **Theme:** EV Charging Infrastructure Siting
- **Project Type:** Business Analytics / Decision Support System
- **Status:** Project Development

---

## 1. Project Overview

This project aims to develop a data-driven decision-support system for identifying and ranking suitable locations for new Electric Vehicle (EV) charging stations within a selected city.

The system will combine EV ownership, existing charging infrastructure, accessibility, locality characteristics, environmental indicators, EV usage patterns, and estimated station economics to determine which areas have the highest potential for future EV charging infrastructure.

The system will not directly recommend or guarantee that a charging station should be constructed at a particular location. Instead, it will provide a comparative ranking of candidate locations based on measurable factors and analytical scores.

---

## 2. Problem Statement

The increasing adoption of electric vehicles creates a growing requirement for accessible and strategically located charging infrastructure.

However, selecting locations for new charging stations requires consideration of multiple factors, including:

- Existing EV ownership
- EV adoption potential
- Traffic and accessibility
- Existing charging infrastructure
- Population and locality characteristics
- Economic activity
- Environmental conditions
- Charging demand
- Operating costs
- Expected revenue
- Payback period

The objective of this project is to integrate these factors into a Business Analytics framework that can help infrastructure planners compare potential locations objectively.

---

## 3. Project Objectives

The project aims to:

1. Analyse the existing distribution of EVs within the selected city.
2. Map existing EV charging stations.
3. Identify areas with potential gaps in charging infrastructure.
4. Analyse traffic, accessibility and surrounding locality characteristics.
5. Estimate potential EV charging demand.
6. Compare potential demand between electric 2-wheelers and 4-wheelers.
7. Estimate potential charging revenue and operating economics.
8. Calculate an estimated station payback period.
9. Develop a location suitability scoring model.
10. Generate a ranked leaderboard of candidate locations.
11. Present the results through an interactive analytical dashboard.

---

## 4. Key Business Questions

The system will attempt to answer questions such as:

- Where is EV ownership currently concentrated?
- Which areas have high EV demand but relatively low charging infrastructure?
- Which locations have better accessibility and traffic potential?
- Which localities have higher potential for future EV adoption?
- How does existing competition affect the suitability of a new charging station?
- What is the estimated charging demand of a candidate area?
- What proportion of demand may come from 2-wheelers versus 4-wheelers?
- What is the estimated revenue potential of a candidate location?
- How long could the initial infrastructure investment take to recover under the model assumptions?
- Which candidate locations receive the highest overall analytical score?

---

## 5. Data Sources

The project will combine data from multiple sources.

### EV Registration Data
Potential source:
- VAHAN / Ministry of Road Transport and Highways

Possible variables:
- EV registrations
- Vehicle type
- Fuel type
- Regional/RTO-level adoption

### Existing Charging Stations
Potential sources:
- Open Charge Map
- Government open-data sources

Possible variables:
- Latitude
- Longitude
- Station/operator
- Charger information
- Connector type
- Charging capacity

### Geographic and Locality Data
Potential source:
- OpenStreetMap

Possible variables:
- Roads
- Highways
- Intersections
- Residential areas
- Commercial areas
- Parking facilities
- Hospitals
- Universities
- Shopping areas
- Other points of interest

### Population and Socioeconomic Data
Potential sources:
- Census of India
- MOSPI
- Other official government datasets

Possible variables:
- Population
- Households
- Population density
- Employment indicators
- Consumption/economic indicators

### Environmental Data
Potential sources:
- Central Pollution Control Board
- Government open-data platforms

Possible variables:
- AQI
- PM2.5
- PM10
- NO2
- SO2
- Other available environmental indicators

### EV Specifications
Potential sources:
- Manufacturer specifications
- Open datasets

Possible variables:
- Vehicle type
- Battery capacity
- Claimed range
- Energy efficiency

---

## 6. Analytical Framework

The project will follow the following workflow:

Data Collection
        ↓
Data Cleaning & Integration
        ↓
Geospatial Analysis
        ↓
EV Demand Analysis
        ↓
Infrastructure Gap Analysis
        ↓
Accessibility Analysis
        ↓
Location Suitability Scoring
        ↓
Revenue Estimation
        ↓
Payback Analysis
        ↓
Location Ranking
        ↓
Interactive Dashboard

---

## 7. Key Analytical Factors

### A. EV Demand Potential

Factors may include:

- EV registrations
- EV growth
- Population density
- Vehicle density
- Estimated EV adoption
- Travel demand
- EV type distribution

### B. Infrastructure Gap

Factors may include:

- Number of existing charging stations
- Distance to existing stations
- Charger density
- Charging capacity
- Existing station concentration

### C. Accessibility

Factors may include:

- Traffic
- Road connectivity
- Major road proximity
- Highway proximity
- Parking availability
- Nearby commercial activity

### D. Locality Potential

Factors may include:

- Population
- Economic activity
- Residential density
- Commercial density
- Offices
- Shopping centres
- Hospitals
- Universities

### E. Environmental / Sustainability Context

Factors may include:

- AQI
- PM2.5
- PM10
- Existing environmental initiatives
- Public transport accessibility
- EV adoption

### F. Financial Viability

Factors may include:

- Estimated charging sessions
- Average energy consumed
- Charging tariff
- Estimated revenue
- Electricity cost
- Maintenance cost
- Infrastructure cost
- Land/lease cost
- Estimated payback period

---

## 8. Location Suitability Score

A composite score will be developed to compare candidate locations.

The score may combine:

- EV Demand Potential
- Accessibility
- Infrastructure Gap
- Locality Potential
- Environmental/Sustainability Factors
- Financial Viability

The final weights will be determined after data availability and exploratory analysis rather than being arbitrarily fixed at the beginning of the project.

---

## 9. Financial Analysis

For candidate locations, the project will estimate:

### Revenue

Estimated charging sessions
×
Average energy consumed per session
×
Charging tariff

### Operating Profit

Estimated revenue
−
Estimated operating costs

### Payback Period

Initial investment
÷
Estimated annual net cash flow

All financial values derived from assumptions will be clearly labelled as **estimated/modelled values**, rather than actual station-level financial transactions.

---

## 10. 2-Wheeler vs 4-Wheeler Analysis

The project will separately analyse:

- Electric 2-wheelers
- Electric 4-wheelers

Potential differences in:

- Battery capacity
- Charging requirement
- Charging frequency
- Charging duration
- Energy consumption
- Average charging revenue

This will help estimate the type of charging demand expected at different locations.

---

## 11. Business Analytics Components

### Descriptive Analytics

Analyse:

- Existing EV distribution
- Charging station distribution
- EV growth
- Traffic/accessibility
- Locality characteristics

### Diagnostic Analytics

Analyse:

- Why certain areas have higher EV demand
- Why infrastructure gaps exist
- Relationship between EV ownership and charging infrastructure
- Factors associated with location suitability

### Predictive Analytics

Potential extensions:

- EV adoption forecasting
- Charging demand forecasting
- Future infrastructure requirement estimation

### Prescriptive Analytics

The system will provide:

- Candidate-location rankings
- Suitability scores
- Financial viability comparisons
- Historical/modelled scenario comparisons

The system will function as a decision-support tool rather than directly making investment or construction decisions.

---

## 12. Expected Output

The final system is expected to provide:

- Interactive city map
- Existing charging station map
- EV ownership analysis
- Infrastructure gap map
- Candidate-location analysis
- Location suitability score
- 2W vs 4W demand analysis
- Estimated revenue
- Estimated payback period
- Location leaderboard
- Interactive dashboard

---

## 13. Technology Stack

### Programming
- Python

### Data Analysis
- Pandas
- NumPy
- SciPy
- Scikit-learn

### Visualization
- Matplotlib
- Plotly

### Geospatial Analysis
- GeoPandas
- OSMnx
- Folium / Plotly Maps

### Data Collection
- APIs
- Open Government Data
- OpenStreetMap
- Public datasets

### Dashboard
- Streamlit

### Development
- Google Colab
- Jupyter Notebook
- Git
- GitHub

---

## 14. Repository Structure

```text
ev-charging-infrastructure-siting/
│
├── README.md
├── proposal.Rmd
├── requirements.txt
├── .gitignore
│
├── data/
│   ├── raw/
│   ├── processed/
│   ├── geographic/
│   └── external/
│
├── notebooks/
│   ├── 01_data_collection.ipynb
│   ├── 02_data_preprocessing.ipynb
│   ├── 03_exploratory_analysis.ipynb
│   ├── 04_geospatial_analysis.ipynb
│   ├── 05_ev_demand_analysis.ipynb
│   ├── 06_infrastructure_gap_analysis.ipynb
│   ├── 07_location_scoring.ipynb
│   ├── 08_financial_analysis.ipynb
│   └── 09_dashboard.ipynb
│
├── src/
│   ├── data_collection.py
│   ├── preprocessing.py
│   ├── geospatial.py
│   ├── demand.py
│   ├── scoring.py
│   ├── financial.py
│   └── visualization.py
│
├── dashboard/
│   └── app.py
│
├── reports/
│
├── assets/
│
└── tests/
