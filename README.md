# NYC-Taxi-Data-Analysis
End-to-end NYC Yellow Taxi data analysis project using Python, SQL, and Power BI. Includes data cleaning, exploratory data analysis, feature engineering, and business insights from millions of taxi trip records.
# 🚖 NYC Taxi Data Analysis & Power BI Dashboard (Q1 2026)

## 📊 Project Overview

This project presents an end-to-end **Data Analytics pipeline** analyzing **New York City Yellow Taxi data (Jan–Mar 2026)** using **Python, SQL, and Power BI**.

The goal was to transform raw large-scale trip data into actionable business insights by performing:

* Data cleaning & preprocessing
* Feature engineering
* SQL-based analysis (30+ queries)
* Interactive dashboard development

---

## 🛠️ Tech Stack

* **Python** → Pandas, NumPy (Data Cleaning & Feature Engineering)
* **SQL (MySQL)** → Data Storage, Query Optimization, Analytics
* **Power BI** → Dashboard & Data Visualization
* **Dataset Format** → Parquet → CSV → MySQL

---

## 📂 Data Processing Pipeline

### 1️⃣ Data Ingestion

* Loaded **3 months of parquet files**
* Combined dataset size: **10M+ records**

### 2️⃣ Data Cleaning

* Removed:

  * Negative / zero fare & distance
  * Invalid passenger counts
  * Incorrect total amounts
* Outlier handling:

  * Distance capped at **100 miles**
  * Tip capped at **$100**
  * Trip duration filtered (**1–180 mins**)

### 3️⃣ Feature Engineering

Created new features:

* Trip Duration (minutes)
* Pickup Hour, Day, Month
* Average Speed
* Speed Category (Slow, Normal, Fast, Highway)
* Trip Type (Short vs Long)
* Tip Percentage

---

## 🗄️ SQL Implementation

* Imported cleaned data into **MySQL**
* Created optimized table with indexing:

  * `idx_datetime`
  * `idx_payment`
  * `idx_location`

### 🔥 SQL Analysis (30+ Queries)

Key analyses include:

* Total Revenue Calculation
* Monthly & Daily Revenue Trends
* Peak Hours & Demand Analysis
* Payment Method Insights
* Trip Duration & Distance Analysis
* Location-Based Revenue
* Window Functions (RANK, LAG, DENSE_RANK)
* Contribution % Analysis

---

## 📈 Key Performance Indicators (KPIs)

| Metric               | Value           |
| -------------------- | --------------- |
| **Total Revenue**    | $222.77 Million |
| **Total Trips**      | 7.66 Million    |
| **Average Distance** | 3.42 Miles      |
| **Average Fare**     | $19.54          |
| **Average Duration** | 17.24 Minutes   |
| **Average Tip %**    | 18.50%          |

---

## 📊 Dashboard Insights

### 💳 Payment Behavior

* **87.46% trips via Credit Card**
* Cash usage only **11.43%**
* Indicates strong **cashless adoption**

📌 *Insight:*
Digital payments dominate both in usage and revenue contribution.

---

### 💰 Revenue Analysis

* Credit Card generates **maximum revenue**
* High usage + higher average fare

📌 *Insight:*
Payment method significantly impacts revenue patterns.

---

### 🚕 Trip Distribution

* Majority trips within **0–5 miles**
* Data is **right-skewed**

📌 *Insight:*
NYC taxis are primarily used for **short urban commutes**

---

### 🛣️ Long vs Short Trips

* Long trips → higher revenue per ride
* Short trips → high volume

📌 *Insight:*
Clear **Volume vs Value trade-off**

---

### ⚡ Speed & Revenue

* Highway-speed trips generate highest revenue

📌 *Insight:*
Faster trips often indicate **long-distance premium rides**

---

### 👥 Passenger Trends

* Single passenger trips dominate (~6.4M)
* Higher passenger counts show anomalies/spikes

📌 *Insight:*
Possible **group travel or data irregularities**

---

### 📍 Location Insights

* Identified top **pickup locations by revenue**

📌 *Use Case:*

* Driver allocation
* Surge pricing
* Demand forecasting

---

### 🔗 Correlation Analysis

* Strong positive correlation:

  * Distance ↔ Fare ↔ Total Amount (~0.97)

📌 *Insight:*
Pricing is **distance-driven**
---

## 📊 Power BI Dashboard Features

### Visuals Included:

* KPI Cards
* Revenue Trend (Line Chart)
* Payment Distribution (Donut Chart)
* Trips by Hour (Bar Chart)
* Distance Distribution (Histogram)
* Scatter Plot (Distance vs Fare)
* Location-based Analysis

---

## 🎛️ Interactive Filters (Slicers)

* Pickup Month (Jan–Mar 2026)
* Payment Type
* Passenger Count
* Pickup Hour

---
