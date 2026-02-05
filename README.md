# E-Commerce Data Transformation with dbt & Snowflake

This project is a technical implementation of **Data Transformation** using **dbt Core** and **Snowflake** for an e-commerce dataset. It covers the entire lifecycle of data engineering: data cleaning (staging), building dimensional models (marts), and enforcing data quality (testing).

## Architecture & Lineage
The data flows through three distinct layers to ensure modularity and reliability:
1.  **Raw Layer**: Source data loaded directly into Snowflake.
2.  **Staging Layer**: Performs basic cleaning, type casting, and standardized renaming of columns to ensure consistency across the project (Materialized as Views).
3.  **Marts Layer**: Business-ready tables designed for analytics, consisting of `dim_customers`, `dim_products`, and `fact_sales` (Materialized as Tables).

## Tech Stack
* **Database**: Snowflake
* **Transformation Tool**: dbt Core (v1.11.2)
* **Language**: SQL
* **Validation**: dbt Generic Tests

## Getting Started

### Prerequisites
* Python 3.x
* Virtual Environment (venv)
* Snowflake Account with appropriate warehouse and database permissions

### Installation & Execution
1. Clone this repository to your local machine.
2. Activate your virtual environment and install the required dbt dependencies.
3. Execute the following command to build the entire model lineage:
    ```bash
    dbt run
    ```
4. Run automated data quality checks:
    ```bash
    dbt test
    ```

## Data Validation
Automated quality gates implemented in `models/schema.yml`:
* **Unique & Not Null**: Applied to `order_item_id_glob` (Primary Key), `customer_id`, and `product_id`.
* **Accepted Values**: Validates that `order_status` only contains official statuses.
* **Relationship Tests**: Enforces referential integrity between Fact and Dimension tables.

## 📊 Key Models & Logic
* **dim_customers**: Cleans and deduplicates customer records from the raw source.
* **dim_products**: Standardizes product categories and measures.
* **fact_sales**: The core transaction table joining orders, items, and payments. It handles one-to-many relationships by aggregating payment values to the item level to prevent revenue double-counting.

---
*This project was completed as part of the Technical Test for Triputra Agro Persada.*