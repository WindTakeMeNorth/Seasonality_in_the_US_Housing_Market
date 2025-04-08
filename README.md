# Seasonality in the U.S. Housing Market  
**Author:** Yihan Hu  
**Supervisor:** Dr. Cemil Selcuk  
**University:** University College London  
**Year:** 2024  

---

## Overview

This study investigates the seasonal dynamics of the U.S. housing market using econometric time-series decomposition and cross-sectional geographical comparison. Each year, both prices and turnover rates rise significantly during the second and third quarters (April–September) and fall during the first and fourth quarters (October–March). These synchronized patterns defy traditional price-demand theory, which predicts an inverse relationship between price and volume.

The project:
- Validates the existence of seasonality using unadjusted monthly housing market data.
- Applies seasonal decomposition techniques to isolate trend, seasonal, and irregular components.
- Implements formal statistical testing procedures to evaluate the significance of seasonal effects.
- Provides theoretical interpretations for the "in-phase" movement of prices and transaction volumes.

The findings offer practical implications for market participants and policymakers and provide new insights into the interaction of behavioral, institutional, and macroeconomic factors that shape real estate cycles.

---

## Objectives

- Empirically verify the presence of seasonality in U.S. housing prices and turnover.
- Identify and interpret regional heterogeneity in seasonal behavior.
- Analyze the joint movement of price and volume during seasonal cycles.
- Link observed patterns to factors such as school calendars, climate, elections, and cultural preferences.

---

## Data Sources

**Federal Housing Finance Agency (FHFA):**
- Monthly house price index (purchase-only, not seasonally adjusted)

**U.S. Census Bureau:**
- Number of new single-family houses sold and for sale (monthly, from 1963; regional data from 1973)
- Median and average sale prices
- Sales by construction stage
- Sale prices by region and type of financing

*Note:* Turnover rate is computed as the monthly ratio of houses sold to those listed for sale.

---

## Methodology

### 1. Seasonal Decomposition  
- X-13ARIMA-SEATS: Extracts deterministic seasonal components
- STL decomposition: Used for robustness checks

### 2. Formal Statistical Tests  
- F-Test: Tests for equality of monthly means under ANOVA framework
- Kruskal–Wallis Test: Non-parametric version of the F-test
- Moving Seasonality Test: Two-way ANOVA applied to detect seasonality shifts
- Chow Test: Tests for structural breaks across seasonal regimes

### 3. Cross-Sectional Analysis  
- Regional comparison of seasonal amplitude
- Conditioning on climate zones, electoral periods, and academic calendars

---

## Economic Interpretations

Several theoretical explanations account for the observed in-phase patterns of price and volume:

- **Search Frictions:**  
  Housing search models (Wheaton, 1990) show that matching becomes more efficient in high-liquidity periods.

- **Information Asymmetry:**  
  Sellers time listings strategically during periods of high demand to maximize price outcomes (Hendel & Nevo, 2013).

- **Behavioral Anchoring:**  
  Buyers rely on seasonal price norms as reference points, amplifying price rigidity (Genesove & Mayer, 2001).

These are compounded by macroeconomic uncertainty, cultural norms, school-year transitions, and political cycles.

---

## Tools & Environment

- **Languages:** R  
- **Packages:** `seasonal`, `forecast`, `car`, `zoo`, `ggplot2`, `dplyr`  
- **Software:** EViews (X-13ARIMA-SEATS), RStudio

---

## Key Results

- Strong seasonal cycles detected in prices and transaction volumes  
- Statistically significant seasonality confirmed via multiple formal tests  
- Structural breaks observed in seasonal regimes  
- Results suggest interplay of institutional constraints and behavioral patterns behind synchronized cycles

---

## Contact

**Email:** yihan.hu.22@ucl.ac.uk  
**Location:** London, UK
