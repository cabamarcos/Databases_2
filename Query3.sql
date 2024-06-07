WITH cover AS (SELECT cif, name AS product_name, specialty, version, TO_NUMBER(waiting_period) AS waiting_period 
				FROM coverages),
min_spec AS (SELECT specialty, 'min' AS type, MIN(waiting_period) AS waiting_period 
				FROM cover
				GROUP BY specialty),
max_spec AS (SELECT specialty, 'max' AS type, MAX(waiting_period) AS waiting_period 
				FROM cover
				GROUP BY specialty), 
max_min AS (SELECT * FROM min_spec UNION (SELECT * FROM max_spec)),
cover_1 AS (SELECT specialty, type, waiting_period, product_name, cif, version 
				FROM (SELECT specialty, type, waiting_period, product_name, cif, version 
						FROM cover JOIN (SELECT specialty AS spe, type, waiting_period AS wp
											FROM max_min) ON (cover.specialty = spe AND waiting_period = wp))),
cover_2 AS (SELECT specialty, type, waiting_period, product_name, cif, version, launch 
				FROM cover_1 JOIN (SELECT cif AS cif_prod, name AS name_prod, version AS version_prod, launch 
									FROM products)
					ON (cover_1.cif = cif_prod AND cover_1.product_name = name_prod AND cover_1.version = version_prod)),
pr AS (SELECT specialty, type, MIN(launch) AS launch 
				FROM cover_2 
				GROUP BY specialty, type),
cover_prod AS (SELECT specialty, type, waiting_period, product_name, cif, version, launch 
				FROM cover_2 JOIN (SELECT specialty AS specialty_prod, type AS type_prod, launch AS launch_prod 
									FROM pr)
					ON (specialty = specialty_prod AND type = type_prod AND launch = launch_prod)),
x AS (SELECT specialty, type, waiting_period, MAX(cif) AS cif, MAX(product_name) AS product_name, MAX(version) AS version 
				FROM cover_prod 
				GROUP BY specialty, type, waiting_period),
y AS (SELECT specialty, type, waiting_period, name AS company_name, x.cif, product_name, version 
			FROM (x JOIN companies ON x.cif = companies.cif) 
			ORDER BY specialty ASC)
SELECT specialty, type, waiting_period, cif, product_name, version FROM x;


INSERT INTO coverages (cif, name, version, specialty, waiting_period)
VALUES ('63679992F', 'P?liza Abetos', 1.02, 'Alergolog?a', 5);
 
DELETE FROM coverages WHERE cif='63679992F' AND name='P?liza Abetos'
AND version=1.02 AND specialty='Alergolog?a' AND waiting_period=5;


