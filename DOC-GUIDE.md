# 📝 Beginner Data Engineer Documentation & Presentation Guide

This guide is for documenting and presenting your group’s **dimensional modeling exercise**.  
Follow the structure below, fill in your team’s work, and use it as both internal documentation and a final presentation outline.  

---

## 1. Project Overview

- **Dataset Used:**
  *The dataset used was the chinook datset that contains:
  It’s modeled after a digital media store like iTunes or Spotify and contains data about:
      - Artists and Albums
      - Tracks (songs) and their Genres & Media types
      - Customers, Invoices, and Invoice Line Items
      - Employees who support customers*
- **Goal of the Exercise:**
  *The goal of this dataset is to transform the dataset into a dimensional model, and answer business questions*
- **Team Setup:**
  *While our team agreed to work individually, Ezi took on most of the workload and made a significant contribution to our project*
- **Environment Setup:**
  *Docker containers on a shared VM + local laptops.*

---

## 2. Architecture & Workflow

- **Pipeline Flow:**  
  raw → clean → mart → Metabase  

- **Tools Used:**  
  - Ingestion: `dlt`  
  - Modeling: `dbt`  
  - Visualization: `Metabase`  

- **Medallion Architecture Application:**  
  - **Bronze (Raw):** 
    Purpose: To ingest and permanently store source data in its original, unaltered state. This layer serves as a historical archive and a reliable source for disaster recovery.

    Key Activities:

    Data is loaded from all sources (APIs, databases, files) with no transformations.

    We preserve the original schema, column names, and data types.

    Data is typically appended, creating a complete, auditable history of every record we've ever received.

    State of the Data: Raw and exactly as it came from the source.

  - **Silver (Clean):** 
  Purpose: To provide a reliable, queryable "single source of truth" for major business entities.

  Key Activities:

  Cleaning: We handle missing values, deduplicate records, and fix data quality issues.

  Conforming: We standardize data types, apply consistent naming conventions, and ensure conformity across different sources.

  Enriching: We join tables from different sources to create a more complete view.

  State of the Data: Validated, cleaned, and organized by business concepts, but not yet aggregated for specific reports. This layer is often used by data analysts and scientists for exploration.

  - **Gold (Mart):**
  Purpose: To provide aggregated, performance-optimized data for specific business use cases.

  Key Activities:

  We apply final business logic and perform aggregations (SUM, AVG, COUNT).

  We build our star schemas (fact and dimension tables) in this layer.

  We often create specific data marts for different departments.

  State of the Data: Aggregated, modeled, and ready for consumption by BI tools like Tableau or Power BI. This is our definitive source for reporting.

---

## 3. Modeling Process

- **Source Structure (Normalized):**  
The data from our source operational systems is highly normalized, primarily adhering to Third Normal Form (3NF). This structure is optimized for transactional applications (OLTP) by minimizing data redundancy and ensuring data integrity.

In practice, this means information is split across many distinct tables linked by keys. For example, a single sales event has its data spread across separate tables for orders, customers, products, and stores.

- **Star Schema Design:**  
  - Fact Tables: fct_sales_grp4.sql 
  - Dimension Tables: dim_customer_grp4, dim_date_grp4, dim_employee_grp4, dim_track_grp4

- **Challenges / Tradeoffs:**  
  il.invoice_id from fact table cannot read in use use case

---

## 4. Collaboration & Setup

- **Task Splitting:**
 *(How the team divided ingestion, modeling, BI dashboards, documentation.)*
- We collaborated via Slack to discuss the final workflow. From ingestion through modeling, Ezi finalized the process.
- In terms of visualization in the Metabase it was done by Annie and Lizette
- In terms of documentation it was done by Bianca, Ezi, and Nella
- **Best Practices Learned:**
- Using Git for documenting assumptions
- Building our own pipeline (edited) 

---

## 5. Business Questions & Insights

- **Business Questions Explored:**
  1. *How do our most loyal customers, defined by their purchase frequency, contribute to overall revenue compared to infrequent, one-time buyers?*
  2. *Who are the most profitable artists, and which of their specific albums contribute the most to their total sales revenue?*
       SELECT
          dt.artist_name,
          dt.album_title,
          SUM(fs.line_amount) AS total_revenue
        FROM {{ ref('fct_sales_grp4') }} fs
        JOIN {{ ref('dim_track_grp4') }} dt ON fs.track_key = dt.track_key
        GROUP BY dt.artist_name, dt.album_title
        ORDER BY total_revenue DESC
  3. *Which cities are our most underrated markets (i.e., those with a high average sale amount per customer but a low total number of customers)*
      SELECT
        dc.city,
        dc.country,
        COUNT(DISTINCT dc.customer_key) AS number_of_customers,
        AVG(fs.invoice_total) AS average_sale_per_invoice
        FROM {{ ref('fct_sales_grp4') }} fs
        JOIN {{ ref('dim_customer_grp4') }} dc ON fs.customer_key = dc.customer_key
        GROUP BY dc.city, dc.country
        HAVING number_of_customers < 5
        ORDER BY average_sale_per_invoice DESC
  4. *How has the revenue for different media types (e.g., MPEG audio file vs. AAC audio file) changed over the past few years?*
        SELECT
        dt.media_type_name,
        dd.year,
        SUM(fs.line_amount) AS total_revenue
        FROM {{ ref('fct_sales_grp4') }} fs
        JOIN {{ ref('dim_track_grp4') }} dt ON fs.track_key = dt.track_key
        JOIN {{ ref('dim_date_grp4') }} dd ON fs.date_key = dd.date_key
        GROUP BY dt.media_type_name, dd.year
        ORDER BY dd.year, total_revenue DESC
  5. *What is the revenue difference between tracks that are included on curated playlists versus those that are not?*
      SELECT
      dt.is_on_playlist,
      SUM(fs.line_amount) AS total_revenue,
      COUNT(DISTINCT fs.track_key) AS number_of_tracks
      FROM {{ ref('fct_sales_grp4') }} fs
      JOIN {{ ref('dim_track_grp4') }} dt ON fs.track_key = dt.track_key
      GROUP BY dt.is_on_playlist
  6. *Which sales representatives are responsible for managing the customers who have the highest lifetime spending?*
      SELECT
      de.full_name AS employee_name,
      de.title,
      COUNT(DISTINCT fs.customer_key) AS number_of_customers_managed,
      SUM(fs.line_amount) AS total_revenue_from_customers
      FROM {{ ref('fct_sales_grp4') }} fs
      JOIN {{ ref('dim_employee_grp4') }} de ON fs.employee_key = de.employee_key
      GROUP BY de.full_name, de.title
      ORDER BY total_revenue_from_customers DESC
- **Dashboards / Queries:**
  *(Add screenshots, SQL snippets, or summaries of dashboards created in Metabase.)*
- **Key Insights:**
  - *(Highlight 1–2 interesting findings. Example: “Rock was the top genre in North America, while Latin genres dominated in South America.”)*
---
---

## 6. Key Learnings

- **Technical Learnings:**
  - Data Cleaning
  - SQL joins
  - schema designing
  - Building data pipeline
  - Visualization in a remote setup
- **Team Learnings:**
  - Collaboration in shared environments
  - Importance of documentation 

---

## 7. Future Improvements

- **Next Steps with More Time:**
  *Testing & Validation: Implement tests, data quality checks*
- **Generalization:**
  *Domain Transfer: The same workflow can be used for finance, healthcare, or retail datasets by adjusting the schema and transformations.*

