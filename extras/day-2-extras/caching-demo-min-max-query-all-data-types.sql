// Demo showing all data types with a MIN/MAX query.

USE ROLE TRAINING_ROLE;
USE WAREHOUSE INSTRUCTOR1_WH;
USE DATABASE INSTRUCTOR1_DB;
USE SCHEMA PUBLIC;

CREATE OR REPLACE TABLE LINEITEM_WTAX AS (SELECT * FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."LINEITEM");

ALTER TABLE LINEITEM_WTAX ADD COLUMN L_EXTENDEDPRICE_TAX FLOAT AS (L_EXTENDEDPRICE::FLOAT * 0.015);

SELECT * FROM LINEITEM_WTAX LIMIT 100; 

ALTER SESSION SET USE_CACHED_RESULT = FALSE;

SET whName = TO_VARCHAR(SELECT CURRENT_WAREHOUSE());
ALTER WAREHOUSE IDENTIFIER($whName) SUSPEND;

// Number(38,0)
// This will not start the WH and does a metadata only query
SELECT
  MIN(L_ORDERKEY),
  MAX(L_ORDERKEY),
  COUNT(*)
FROM LINEITEM_WTAX;

// Date
// This will not start the WH and does a metadata only query
SELECT
  MIN(L_SHIPDATE),
  MAX(L_SHIPDATE),
  COUNT(*)
FROM LINEITEM_WTAX;

// Number(12,2)
// This query will use the WH and uses a generator 
SELECT
  MIN(L_EXTENDEDPRICE),
  MAX(L_EXTENDEDPRICE),
  COUNT(*)
FROM LINEITEM_WTAX;

// FLOAT
// This query will use the WH and will perform a table scan
SELECT
  MIN(L_EXTENDEDPRICE_TAX),
  MAX(L_EXTENDEDPRICE_TAX),
  COUNT(*)
FROM LINEITEM_WTAX;

// Varchar
// This query will use the WH and will perform a table scan
SELECT
  MIN(L_SHIPMODE),
  MAX(L_SHIPMODE),
  COUNT(*)
FROM LINEITEM_WTAX;

