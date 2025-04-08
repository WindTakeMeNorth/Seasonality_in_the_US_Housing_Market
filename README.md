🏡 Seasonality in the U.S. Housing Market
Author: Yihan Hu
Supervisor: Dr. Cemil Selcuk
University: University College London
Year: 2024

🔍 Overview
This study investigates the seasonal dynamics of the U.S. housing market using econometric time-series decomposition and cross-sectional geographical comparison. Each year, both prices and turnover rates rise significantly during the second and third quarters (April–September) and fall during the first and fourth quarters (October–March). These synchronized patterns defy traditional price-demand theory, which predicts an inverse relationship between price and volume.

The project:

Validates the existence of seasonality using unadjusted monthly housing market data.

Applies seasonal decomposition techniques to isolate trend, seasonal, and irregular components.

Implements formal statistical testing procedures to evaluate the statistical significance of seasonal effects.

Provides theoretical interpretations for the "in-phase" movement of prices and transaction volumes.

The findings offer practical implications for market participants and policymakers and provide new insights into the interaction of behavioral, institutional, and macroeconomic factors that shape real estate cycles.

🎯 Objectives
Empirically verify the presence of seasonality in U.S. housing prices and turnover.

Identify and interpret regional heterogeneity in seasonal behavior.

Theoretically analyze the joint movement of price and volume during seasonal cycles.

Link observed patterns to factors such as school calendars, climate, elections, and cultural preferences.

📂 Data Sources
Federal Housing Finance Agency (FHFA)

Monthly house price index (purchase-only, not seasonally adjusted)

U.S. Census Bureau

Number of new single-family houses sold and for sale (monthly, from 1963; regional data from 1973)

Median and average sale prices

Sales by construction stage

Sale prices by region and type of financing

Note: Turnover rate is computed as the monthly ratio of houses sold to those listed for sale.

🧠 Methodology
1. Seasonal Decomposition
X-13ARIMA-SEATS: Extracts deterministic seasonal factors from raw time series

STL decomposition: Applied for robustness check across disaggregated series

2. Formal Tests for Seasonality
F-Test: Tests equality of monthly means under ANOVA framework

Kruskal–Wallis Test: Non-parametric alternative to the F-test

Moving Seasonality Test: Evaluates seasonal stability using a two-way ANOVA

Chow Test: Detects structural breaks between seasonal regimes

3. Cross-Sectional Analysis
Inter-regional comparison of seasonal amplitudes using normalized indices

Evaluation of market cyclicality conditional on climate zones, school calendars, and electoral cycles

🧾 Economic Interpretations
The observed “in-phase” movement of prices and volume is explained using several theoretical channels:

Search Frictions

Search-theoretic models (Wheaton, 1990) show faster matching in high-liquidity periods, amplifying turnover.

Information Asymmetry

Sellers time listings to periods of heightened buyer competition (Hendel & Nevo, 2013), shifting the price-volume frontier.

Behavioral Anchoring

Buyers use seasonal price expectations as reference points (Genesove & Mayer, 2001), reinforcing cyclical valuation norms.

These effects interact with macro-level uncertainty, electoral cycles (Klok & Bond, 2024), school-year preferences (Fack & Grenet, 2010), and climate seasonality (Valadkhani et al., 2016).

🧰 Tools & Environment
Statistical Languages: R

Packages Used: seasonal, forecast, zoo, stats, car, ggplot2, dplyr

Software: EViews (for X-13ARIMA-SEATS backend), RStudio

📌 Key Results
Strong seasonal signals confirmed across all variables (prices, volume, turnover)

Statistically significant differences in seasonal patterns across U.S. regions

Confirmed presence of countercyclical structural breaks via Chow Tests

Evidence supports the hypothesis that synchronized seasonal cycles reflect institutional and behavioral dynamics, not classical equilibrium pricing

📫 Contact
Email: yihan.hu.22@ucl.ac.uk
Location: London, United Kingdom
