DROP VIEW IF EXISTS gold.dim_product;
CREATE VIEW gold.dim_product AS 
(SELECT 	
	ROW_NUMBER() OVER(ORDER BY pi.prd_start_dt, pi.prd_id) AS product_key,
	pi.prd_id AS product_id,  
	pi.prd_key AS product_number,
	pi.prd_line AS product_line,
	pi.prd_nm AS product_name, 
	pi.prd_cost AS product_cost, 
	pi.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS subcategory,
	pc.maintenance AS maintenance,
	pi.prd_start_dt AS start_date
FROM silver.crm_prd_info AS pi
LEFT JOIN silver.erp_px_cat_g1v2 AS pc
ON pi.cat_id = pc.id);

DROP VIEW IF EXISTS gold.dim_product;
CREATE VIEW gold.dim_customer AS
(SELECT 
	ROW_NUMBER() OVER(ORDER BY ci.cst_create_date, ci.cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	ci.cst_marital_status AS marital_status,
	CASE
		WHEN ci.cst_gndr = 'n/a' THEN ca.gen
		ELSE ci.cst_gndr
	END AS gender,
	ca.bdate AS birthdate,
	la.cntry AS country,
	ci.cst_create_date AS create_date
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 AS la
ON ci.cst_key = la.cid);
