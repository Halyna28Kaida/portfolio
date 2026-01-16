/*
	This load procedure was created to store data from CSV-files  to bronze leyer with raw data.
*/


--insert data into bronze layer
CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
BEGIN
	--insert data into table bronze.crm_cust_info
	RAISE NOTICE  '----------------------------------------';
	DECLARE start_time TIMESTAMP; end_time TIMESTAMP;
	BEGIN
		start_time := NOW();
		TRUNCATE TABLE bronze.crm_cust_info;
		EXECUTE $sql$
			COPY bronze.crm_cust_info
			FROM 'E:\Portfolio\SQL DWH\datasets\source_crm\cust_info.csv'
			DELIMITER ','
			CSV HEADER;
		$sql$;
		
	--insert data into table bronze.crm_prd_info
		TRUNCATE TABLE bronze.crm_prd_info;
		EXECUTE $sql$
			COPY bronze.crm_prd_info
			FROM 'E:\Portfolio\SQL DWH\datasets\source_crm\prd_info.csv'
			DELIMITER ','
			CSV HEADER;
		$sql$;
		-- insert data into table bronze.crm_sales_details
		TRUNCATE TABLE bronze.crm_sales_details;
		EXECUTE $sql$
			COPY bronze.crm_sales_details
			FROM 'E:\Portfolio\SQL DWH\datasets\source_crm\sales_details.csv'
			DELIMITER ','
			CSV HEADER;
		$sql$;
		-- insert data into table bronze.erp_cust_az12
		TRUNCATE TABLE bronze.erp_cust_az12;
		EXECUTE $sql$
			COPY bronze.erp_cust_az12
			FROM 'E:\Portfolio\SQL DWH\datasets\source_erp\CUST_AZ12.csv'
			DELIMITER ','
			CSV HEADER;
		$sql$;
		--insert data into table bronze.erp_loc_a101
		TRUNCATE TABLE bronze.erp_loc_a101;
		EXECUTE $sql$
			COPY bronze.erp_loc_a101
			FROM 'E:\Portfolio\SQL DWH\datasets\source_erp\LOC_A101.csv'
			DELIMITER ','
			CSV HEADER;
		$sql$;
		--insert data into table bronze.erp_px_cat_g1v2
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		EXECUTE $sql$
			COPY bronze.erp_px_cat_g1v2
			FROM 'E:\Portfolio\SQL DWH\datasets\source_erp\PX_CAT_G1V2.csv'
			DELIMITER ','
			CSV HEADER;
		$sql$;
		end_time := NOW();
		RAISE NOTICE 'The time duration is: %', age(end_time, start_time);
	END;
	EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'An error occurred';
END;
$$;

CALL bronze.load_bronze()