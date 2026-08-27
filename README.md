# Marketplace Liquidity & Dynamic Surge Dispatch Analysis

[![DuckDB](https://img.shields.io/badge/DuckDB-0.9+-FFF000.svg?logo=duckdb)](https://duckdb.org/)
[![Python](https://img.shields.io/badge/Python-3.10+-3776AB.svg?logo=python)](https://www.python.org/)
[![Tableau](https://img.shields.io/badge/Tableau-Public-E97627.svg?logo=tableau)](https://public.tableau.com/views/MarketplaceLiquidityDynamicSurgeDispatchAnalysis/Dashboard1)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An end-to-end two-sided marketplace analytics engine evaluating spatial supply-demand equilibrium, dispatch latency percentiles, driver utilization, and surge multiplier price elasticity across 40,000 ride requests.

---

## 1. Executive Dashboard (Tableau Public)

**Interactive Operations Cockpit:** [View Tableau Public Dashboard](https://public.tableau.com/views/MarketplaceLiquidityDynamicSurgeDispatchAnalysis/Dashboard1)

---

## 2. Business Problem & Objectives

In on-demand mobility and quick-commerce platforms, matching two-sided network liquidity in real time is critical to maximizing gross bookings while minimizing wait times. High localized demand spikes create severe spatial imbalances where surge pricing can either incentivize driver positioning or trigger demand destruction (deadweight loss).

This project investigates:
* **Liquidity Matching:** Pinpointing geographic zones with high unfulfilled demand and quantifying root causes (Supply Deficit vs. Surge Price Drop-off vs. Driver Dispatch Timeout).
* **Dispatch Latency & SLA Breaches:** Benchmarking pickup wait time distributions (p50, p90, p95) across vehicle fleets (Sedan, Hatchback, Auto/Bike) during peak vs. off-peak commute hours.
* **Surge Multiplier Elasticity:** Modeling the inflection point where marginal price increases lead to rider cancellation cliffs rather than incremental revenue.

---

## 3. Data Architecture & Relational Schema

The data warehouse is built in **DuckDB** using a star schema simulating 40,000 events across 5 urban operating clusters over a 30-day operating window:
```
dim_riders (rider_id, signup_date, rider_tier)
│
├──< fact_ride_requests (request_id, pickup_zone, surge_multiplier, trip_status, trip_fare, eta)
│
dim_drivers (driver_id, onboarding_date, vehicle_type, driver_rating)

```
### Table Definitions
* `dim_riders`: Rider profile metadata, tier distribution (`Standard`, `Frequent`, `VIP`), and lifecycle acquisition dates.
* `dim_drivers`: Active supply fleet details, vehicle categorization (`Sedan`, `Hatchback`, `Auto/Bike`), and driver performance ratings.
* `fact_ride_requests`: Granular demand pings, geospatial pickup clusters, dynamic surge multipliers, dispatch pickup ETAs, trip completion status, and unfulfilled attribution reasons.

---

## 4. Key Analytical Insights

* **Surge Elasticity Cliff (>= 1.8x):** Rider price elasticity is stable up to 1.5x surge (0.0% drop-off), but triggers an immediate **25.0% cancellation cliff at >= 1.8x surge**, causing demand destruction.
* **Peak Hour Deficit:** Marketplace fulfillment drops from **96.4% off-peak to 80.2% during peak commute hours** (08:00–10:00 and 17:00–20:00).
* **Geospatial Concentration:** `Zone_Downtown_HQ` and `Zone_Airport_Hub` account for **68.4% of all unfulfilled trips**, driven primarily by driver positioning deficits (`No_Driver_Found`).
* **Dispatch SLA Resilience:** Completed trips maintain stable median pickup times (p50 = 6.0 min, p95 = 9.8 min), confirming physical routing efficiency remains robust once matched.

---

## 5. Strategic Recommendations

1. **Surge Multiplier Capping:** Cap algorithmic surge multipliers at **1.65x** across commercial corridors to maximize revenue yield without crossing the rider drop-off elasticity threshold.
2. **Forward-Looking Driver Positioning Incentives:** Implement $3.50 per-trip staging incentives for drivers entering high-deficit clusters (`Zone_Downtown_HQ`, `Zone_Airport_Hub`) 30 minutes ahead of peak demand windows.
3. **Multi-Tier Dispatch Fallback:** Automatically expand match dispatching to Auto/Bike fleets when 4-wheel vehicle wait times exceed 8.0 minutes to safeguard p95 pickup SLAs.

---

## 6. Repository Structure

```
marketplace-liquidity-dispatch-engine/
│
├── README.md                                    <- Full project overview, architecture, and findings
├── EXECUTIVE_MEMO.md                            <- 1-page strategy memorandum for COO/VP Operations
├── requirements.txt                             <- Python dependencies
├── marketplace_analytics_pipeline.ipynb         <- End-to-end DuckDB ETL and Python elasticity model
│
└── sql/
├── 01_zone_liquidity_attribution.sql        <- Unfulfilled demand attribution & match rates
└── 02_dispatch_latency_percentiles.sql      <- SLA breach rates and p50/p90/p95 window queries

```
---

## 7. Setup & Reproduction Instructions

1. **Clone the Repository:**
   
   git clone [https://github.com/lahari-g72/marketplace-liquidity-dispatch-engine.git](https://github.com/lahari-g72/marketplace-liquidity-dispatch-engine.git)
   cd marketplace-liquidity-dispatch-engine

 2. **Install dependencies:**

pip install -r requirements.txt

 3. **Run the Analysis Pipeline:**

jupyter notebook marketplace_analytics_pipeline.ipynb
