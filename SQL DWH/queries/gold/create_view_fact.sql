DROP VIEW IF EXISTS gold.fact_sales; 
CREATE VIEW gold.fact_sales AS
(SELECT 
	sd.sls_ord_num AS order_number,
	dp.product_key AS produkt_key,
	dc.customer_key AS customer_key,
	sd.sls_quantity AS quantity,
	sd.sls_price AS price,
	sd.sls_sales AS sales,
	sd.sls_order_dt AS order_date,
	sd.sls_ship_dt AS ship_date,
	sd.sls_due_dt AS due_date
FROM silver.crm_sales_details AS sd
LEFT JOIN gold.dim_customer AS dc
ON sd.sls_cust_id = dc.customer_id
LEFT JOIN gold.dim_product AS dp
ON sd.sls_prd_key = dp.product_number);
