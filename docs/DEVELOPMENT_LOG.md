# Development Log

This document records the chronological development of the project,
including ideas, decisions, assumptions, experiments, failures,
changes in methodology, data discoveries and implementation decisions.

---

# 2026-08-09 — Project Direction

## Initial Idea

The project will focus on EV charging infrastructure siting.

The objective is to identify and rank areas within a selected city
where new EV charging infrastructure may have high potential.

## Initial Factors Identified

- EV ownership
- Existing charging stations
- Traffic
- Population
- Income
- Locality characteristics
- Environmental indicators
- EV range
- Charging frequency
- Charging expenditure
- Station revenue
- Station maintenance cost
- Infrastructure investment
- Payback period

## Initial Output

A location leaderboard will rank candidate areas based on
a composite suitability score.

---

# 2026-08-09 — Change in Thinking

Initially, the project considered directly measuring
"social awareness" toward EV adoption.

### Problem Identified

A reliable locality-level measure of social awareness
may not be publicly available.

### Decision

Replace "social awareness" with measurable indicators
such as:

- EV adoption
- EV growth
- economic characteristics
- environmental conditions
- population characteristics

These will contribute to an "EV Adoption Potential"
or "Sustainability Context" measure.

### Reason

This makes the methodology more objective and reproducible.

---

# 2026-08-09 — Charging Revenue Data

## Initial Requirement

Actual daily charging-station sales were considered
as an input.

## Data Availability Concern

Public station-level transaction data may not be available
for every charging station.

## Decision

If actual transaction data cannot be obtained,
charging demand and revenue will be estimated using
observable variables.

Estimated values will be explicitly labelled as modelled
rather than actual.

---

# Future Entry Template

## Date

YYYY-MM-DD

## What happened?

Describe the development.

## Previous approach

What were we doing before?

## New approach

What changed?

## Reason for change

Why was the change necessary?

## Evidence / Data

What information caused the change?

## Decision

What did we decide?

## Impact

Which parts of the project are affected?

- Data
- Methodology
- Scoring
- Financial model
- Code
- Dashboard

## Next Action

What needs to happen next?
