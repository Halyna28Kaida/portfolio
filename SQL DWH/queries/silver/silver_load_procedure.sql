/*
	This procedure was created to store data from bronze leyer to silver.
	Data were cleaned from duplicates and unwanted spaces, standardized and normalized.
*/


CREATE OR REPLACE PROCEDURE silver.load_silver()
LANGUAGE plpgsql
AS $$
BEGIN

--insert data into table silver.crm_cust_info
	TRUNCATE TABLE silver.crm_cust_info;
	INSERT INTO silver.crm_cust_info (
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname, 
		cst_marital_status,
		cst_gndr,
		cst_create_date
	)
	SELECT 
		cst_id, 
		cst_key, 
		TRIM(cst_firstname) AS cst_firstname, 
		TRIM(cst_lastname) AS cst_lastname, 
		CASE UPPER(TRIM(cst_marital_status))
			WHEN 'M' THEN 'Married'
			WHEN 'S' THEN 'Single'
			ELSE 'n/a'
		END AS cst_marital_status, 
		CASE UPPER(TRIM(cst_gndr))
			WHEN 'M' THEN 'Male'
			WHEN 'F' THEN 'Female'
			ELSE 'n/a'
		END AS cst_gndr, 
		CASE
			WHEN cst_create_date > NOW() THEN NULL
			ELSE cst_create_date
		END AS cst_create_date
	FROM (
	SELECT
		*,
		ROW_NUMBER(*) OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_id
	FROM bronze.crm_cust_info
	)
	WHERE cst_id IS NOT NULL AND flag_id = 1;
	
--insert data into table silver.crm_prd_info	
	TRUNCATE TABLE silver.crm_prd_info;
	INSERT INTO silver.crm_prd_info(
		prd_id,
		cat_id,
		prd_key, 
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt
	)
	SELECT 
		prd_id, 
		REPLACE(LEFT(prd_key, 5), '-', '_') as cat_id,
		SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key, 
		prd_nm,
		prd_cost,	
		CASE UPPER(TRIM(prd_line))
			WHEN 'M' THEN 'Mountain'
			WHEN 'R' THEN 'Road'
			WHEN 'T' THEN 'Tour'
			ELSE 'Others'
		END AS prd_line,
		prd_start_dt,
		CASE
			WHEN prd_start_dt > prd_end_dt  
			THEN LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) - 1 
			ELSE prd_end_dt
		END AS prd_end_dt
	FROM bronze.crm_prd_info;

--insert data into table silver.crm_sales_details	
	TRUNCATE TABLE silver.crm_sales_details;
	INSERT INTO silver.crm_sales_details(
		sls_ord_num, 
		sls_prd_key, 
		sls_cust_id, 
		sls_order_dt, 
		sls_ship_dt, 
		sls_due_dt, 
		sls_sales, 
		sls_quantity, 
		sls_price)
	SELECT
		sls_ord_num, 
		sls_prd_key, 
		sls_cust_id, 
		CASE
			WHEN LENGTH(sls_order_dt) != 8 THEN NULL
			ELSE CAST(sls_order_dt AS DATE)
		END AS sls_order_dt, 
		sls_ship_dt, 
		sls_due_dt, 
		CASE
			WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
				 THEN ABS(sls_price) * sls_quantity
			ELSE sls_sales
		END AS sls_sales, 
		sls_quantity, 
		CASE
			WHEN sls_price IS NULL OR sls_price <= 0  
				 THEN ABS(sls_sales) / NULLIF(sls_quantity, 0)
			ELSE ABS(sls_price)
		END AS sls_price
	FROM bronze.crm_sales_details;

--insert data into table silver.erp_cust_az12	
	TRUNCATE TABLE silver.erp_cust_az12;
	INSERT INTO silver.erp_cust_az12 (
		cid, 
		bdate, 
		gen)
	SELECT 
		CASE
			WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
			ELSE cid
		END AS cid, 
		CASE 
			WHEN bdate > NOW() THEN NULL
			ELSE bdate
		END AS bdate, 
		CASE
			WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
			WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
			ELSE 'n/a'
		END AS gen
	FROM bronze.erp_cust_az12;

--insert data into table silver.erp_loc_a101	
	TRUNCATE TABLE silver.erp_loc_a101;
	INSERT INTO silver.erp_loc_a101 (
		cid, 
		cntry)
	SELECT
		REPLACE(cid, '-', '') AS cid, 
		CASE
			WHEN TRIM(cntry) = 'DE' THEN 'Germany'
			WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
			WHEN TRIM(cntry) = '' OR TRIM(cntry) IS NULL THEN 'n/a'
			ELSE TRIM(cntry)
		END AS cntry
	FROM bronze.erp_loc_a101;

--insert data into table silver.erp_px_cat_g1v2	
	TRUNCATE TABLE silver.erp_px_cat_g1v2;
	INSERT INTO silver.erp_px_cat_g1v2(
		id, 
		cat, 
		subcat, 
		maintenance)
	SELECT 
		id, 
		cat, 
		subcat, 
		maintenance
	FROM bronze.erp_px_cat_g1v2;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'An error occurred';
END;
$$;
