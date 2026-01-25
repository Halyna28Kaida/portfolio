
CREATE TABLE retail_store.retail_store_sales_clean AS (

WITH correct_price AS (
SELECT
	transaction_id,
	customer_id,
	category,
	item,
	CASE 
		WHEN price_per_unit IS NULL THEN total_spent / quantity
		ELSE price_per_unit
	END AS price_per_unit,
	quantity, 
	total_spent,
	payment_method,
	location,
	transaction_date,
	discount_applied
FROM (
SELECT 
	*
FROM retail_store.retail_store_sales
)t 
WHERE quantity IS NOT NULL AND total_spent IS NOT NULL
)
, correct_item AS (
SELECT 	
	transaction_id,
	customer_id,
	category,
	CASE
		WHEN item IS NULL AND category IN ('Beverages', 'Butchers', 'Furniture', 'Patisserie')
		THEN 'item_' || CAST(((price_per_unit - 5) / 1.5 + 1) AS VARCHAR) || '_' || UPPER(LEFT(category, 3))
		WHEN item IS NULL AND category IN ('Milk Products', 'Food')
		THEN 'item_' || CAST(((price_per_unit - 5) / 1.5 + 1) AS VARCHAR) || '_' || UPPER(LEFT(category, 4))
		WHEN item IS NULL AND category LIKE 'Electric%'
		THEN 'item_' || CAST(((price_per_unit - 5) / 1.5 + 1) AS VARCHAR) || '_' || 'EHE'
		WHEN item IS NULL AND category LIKE 'Computers%'
		THEN 'item_' || CAST(((price_per_unit - 5) / 1.5 + 1) AS VARCHAR) || '_' || 'CEA'
		ELSE item
	END AS item,
	price_per_unit,
	quantity, 
	total_spent,
	payment_method,
	location,
	transaction_date,
	CASE 
		WHEN discount_applied IS NULL THEN 'n/a'
		ELSE discount_applied
	END AS discount_applied
FROM correct_price )

SELECT
	*
FROM correct_item
order BY transaction_date 
)


