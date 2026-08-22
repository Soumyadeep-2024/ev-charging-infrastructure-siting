# EV Charging Infrastructure Siting & Location Analytics

## CTY-12 — City

**Project Type:** Business Analytics / Decision Support System  
**Domain:** Electric Vehicle Infrastructure / Urban Mobility / Data Analytics  
**Primary Language:** R  
**Repository:** `ev-charging-infrastructure-siting`

---

# 1. Project Overview

The rapid adoption of Electric Vehicles (EVs) is creating an increasing need for accessible, reliable, and strategically distributed charging infrastructure.

However, the installation of EV charging stations is not simply a matter of placing chargers wherever EVs are present.

A suitable charging location needs to consider multiple dimensions:

- EV ownership and adoption
- Vehicle category
- Existing charging infrastructure
- Charging infrastructure gaps
- Traffic and accessibility
- Parking availability
- Residential and commercial activity
- Population and locality characteristics
- Potential charging demand
- Installation and operating costs
- Revenue potential
- Investment recovery period

This project aims to develop a **data-driven decision-support system for EV charging infrastructure siting**.

The system will analyse available EV, transportation, geographic, infrastructure, and socioeconomic data to identify and rank areas that have stronger potential for future EV charging infrastructure.

The project is therefore approached as a **Business Analytics problem**, rather than only as a machine-learning or programming problem.

The central business question is:

> **Where should new EV charging infrastructure be installed so that it has strong demand potential, addresses infrastructure gaps, remains accessible to users, and provides reasonable financial viability?**

---

# 2. Business Problem

The increasing number of EVs creates a growing requirement for charging infrastructure.

However, charging stations involve significant investment in:

- Land
- Electrical infrastructure
- Charging equipment
- Installation
- Maintenance
- Operations

If stations are installed in locations with insufficient demand, the result may be:

- Low utilization
- Poor return on investment
- Long payback periods
- Underused infrastructure
- Inefficient allocation of capital
- Poor user experience

On the other hand, concentrating all charging infrastructure in already-developed areas may create charging gaps in emerging EV-adoption regions.

Therefore, the problem is not simply:

> "Where are EVs located?"

It is:

> **"Which locations provide the strongest combination of EV demand, infrastructure need, accessibility, feasibility, and financial potential?"**

---

# 3. Core Business Objective

The primary objective of the project is to develop a data-driven framework that can:

1. Understand the geographic distribution of EVs.
2. Analyse the existing charging infrastructure.
3. Identify potential charging infrastructure gaps.
4. Estimate charging demand.
5. Identify and evaluate candidate locations.
6. Rank candidate locations using a suitability score.
7. Estimate potential financial performance.
8. Calculate an estimated payback period.
9. Provide analytical visualizations and maps.
10. Support decision-making for future EV charging infrastructure investment.

The output will be a **decision-support system**, not an automatic construction or investment decision.

---

# 4. Project Objectives

## 4.1 EV Demand Analysis

Analyse the distribution of EVs across the selected study area.

The analysis will investigate:

- Total EV registrations
- EV growth
- EV categories
- Geographic concentration
- RTO-level distribution
- EV adoption patterns
- Vehicle-type distribution

---

## 4.2 Charging Infrastructure Analysis

Analyse existing EV charging infrastructure.

The analysis will investigate:

- Existing charging station locations
- Station density
- Geographic distribution
- Charging capacity where available
- Charger/connector types where available
- Distance between stations
- Areas with relatively low infrastructure availability

---

## 4.3 Infrastructure Gap Analysis

Identify areas where:

- EV concentration is relatively high
- Existing charging infrastructure is relatively low
- Accessibility is suitable
- Potential charging demand is high

These areas may represent potential infrastructure gaps.

---

## 4.4 Accessibility Analysis

Evaluate whether potential charging locations are convenient for users.

Possible factors include:

- Road connectivity
- Major roads
- Highways
- Traffic
- Parking availability
- Commercial activity
- Nearby public facilities
- Accessibility to surrounding population

---

## 4.5 Location Suitability Analysis

Develop a location scoring framework that combines relevant factors to produce a comparable suitability score for candidate locations.

Potential factors include:

- EV demand potential
- Infrastructure gap
- Accessibility
- Parking
- Locality characteristics
- Commercial activity
- Financial feasibility

---

## 4.6 Financial Analysis

Estimate the potential economics of shortlisted locations.

Possible measures include:

- Charging sessions
- Energy consumed
- Charging revenue
- Operating costs
- Initial investment
- Annual net cash flow
- Payback period
- ROI where sufficient information is available

---

## 4.7 Final Recommendation

Rank candidate locations based on the analytical framework and provide a clear interpretation of why higher-ranked locations perform better.

---

# 5. Key Business Questions

The project will attempt to answer the following questions.

## EV Demand

- Where are EVs concentrated?
- Which vehicle categories are most common?
- How does EV distribution vary geographically?
- Which EV categories are most relevant to public charging infrastructure?
- Is EV adoption increasing in particular areas?

---

## Charging Infrastructure

- Where are existing charging stations located?
- Which areas have high charging-station density?
- Which areas have relatively low charging infrastructure?
- How far are users potentially located from existing stations?
- Are charging stations concentrated in particular parts of the city?

---

## Infrastructure Gap

- Which areas have high EV demand but comparatively low charging infrastructure?
- Which regions may be underserved?
- Where could additional charging infrastructure potentially provide greater value?

---

## Accessibility

- Which candidate locations are easily accessible?
- Which areas are close to major roads?
- Which areas have parking availability?
- Which areas have high surrounding activity?

---

## Demand

- Which factors are associated with charging demand?
- Does EV density influence charging demand?
- Does traffic influence potential utilization?
- Does commercial activity influence potential charging demand?
- Does proximity to existing stations affect location potential?

---

## Financial Viability

- Which locations have higher potential utilization?
- What is the estimated revenue?
- What are the estimated operating costs?
- What is the estimated annual net cash flow?
- How long might it take to recover the initial investment?

---

# 6. Project Thought Process

The project follows a structured Business Analytics approach.

The thought process is:

```text
Business Problem
        ↓
Understand EV Charging Requirements
        ↓
Identify Factors Affecting Demand
        ↓
Identify Required Data
        ↓
Collect Data
        ↓
Inspect Data
        ↓
Clean & Prepare Data
        ↓
Explore Data
        ↓
Understand EV Distribution
        ↓
Analyse Existing Charging Infrastructure
        ↓
Identify Infrastructure Gaps
        ↓
Analyse Accessibility
        ↓
Engineer Features
        ↓
Estimate Charging Demand
        ↓
Identify Candidate Locations
        ↓
Score Candidate Locations
        ↓
Estimate Revenue & Costs
        ↓
Calculate Payback Period
        ↓
Rank Locations
        ↓
Generate Maps & Visualizations
        ↓
Provide Recommendations