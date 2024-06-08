WITH coverages_selection AS(
    SELECT
    coverages.specialty specialty,
    coverages.cif cif,
    coverages.name name,
    coverages.version version
    FROM coverages),
subquery2 AS(
    SELECT DISTINCT
    coverages.cif company_tax_id,
    coverages.name product_name,
    coverages.version product_version,
    coverages.specialty,
    contracts.hospital
    FROM(
        SELECT
        company,
        hospital,
        start_date,
        end_date
    FROM contracts
    WHERE (start_date < sysdate and end_date > sysdate)) contracts
    JOIN coverages ON (coverages.cif=contracts.company)),
subquery3 AS (
    SELECT
        companies.name company_name,
        subquery2.product_name ,
        subquery2.product_version,
        subquery2.specialty,
        subquery2.hospital
    FROM companies
    JOIN subquery2 ON (subquery2.company_tax_id=companies.cif)),
subquery4 AS (
    SELECT
        subquery3.product_name ,
        subquery3.product_version,
        services.specialty,
        services.hospital,
        subquery3.company_name
    FROM subquery3
    JOIN services on subquery3.specialty=services.specialty and subquery3.hospital=services.hospital),
subquery5 AS (
    SELECT
        subquery3.product_name ,
        subquery3.product_version,
        subquery3.specialty,
        subquery3.hospital,
        subquery3.company_name
    FROM subquery3
    MINUS
    SELECT
        subquery4.product_name ,
        subquery4.product_version,
        subquery4.specialty,
        subquery4.hospital,
        subquery4.company_name
    FROM subquery4 )
SELECT
    hospital,
    LISTAGG(specialty, ';') WITHIN GROUP(ORDER BY specialty) AS SUB
    FROM subquery5
GROUP BY subquery5.product_name ,
        subquery5.product_version,
        subquery5.specialty,
        subquery5.hospital,
        subquery5.company_name;



WITH coverages_selection AS(
    SELECT
    coverages.specialty specialty,
    coverages.cif cif,
    coverages.name name,
    coverages.version version
    FROM coverages),
subquery2 AS(
    SELECT DISTINCT
    coverages.cif company_tax_id,
    coverages.name product_name,
    coverages.version product_version,
    coverages.specialty,
    contracts.hospital
    FROM(
        SELECT
        company,
        hospital,
        start_date,
        end_date
    FROM contracts
    WHERE (start_date < sysdate and end_date > sysdate)) contracts
    JOIN coverages ON (coverages.cif=contracts.company)),
subquery3 AS (
    SELECT
        companies.name company_name,
        subquery2.product_name ,
        subquery2.product_version,
        subquery2.specialty,
        subquery2.hospital
    FROM companies
    JOIN subquery2 ON (subquery2.company_tax_id=companies.cif)),
subquery4 AS (
    SELECT
        subquery3.product_name ,
        subquery3.product_version,
        services.specialty,
        services.hospital,
        subquery3.company_name
    FROM subquery3
    JOIN services on subquery3.specialty=services.specialty and subquery3.hospital=services.hospital),
subquery5 AS (
    SELECT
        subquery3.product_name ,
        subquery3.product_version,
        subquery3.specialty,
        subquery3.hospital,
        subquery3.company_name
    FROM subquery3
    MINUS
    SELECT
        subquery4.product_name ,
        subquery4.product_version,
        subquery4.specialty,
        subquery4.hospital,
        subquery4.company_name
    FROM subquery4 )
SELECT
    hospital,
    LISTAGG(specialty, ';') WITHIN GROUP(ORDER BY specialty) AS SUB
    FROM subquery5
GROUP BY subquery5.product_name ,
        subquery5.product_version,
        subquery5.specialty,
        subquery5.hospital,
        subquery5.company_name;








 
WITH active_products AS (SELECT cif as company, name as product, version FROM products WHERE (launch < sysdate and retired is not null)),
active_coverages AS (
SELECT active_products.company, active_products.product, active.version, coverages.specialty FROM
(active_products JOIN coverages
on
active_products.company= coverages.cif and active_products.product=coverages.name and active_products.version=coverages.version)),
active_services AS(
SELECT contracts.company, services.specialty FROM
(contracts join services
on
contracts.hospital=services.hospital),
subquery1 AS(
SELECT company, specialty from (select company, specialty from active_coverages MINUS select company, specialty from active_services)),
subquery2 AS(
select subquery1.company as company_tax_id, subquery1.product, subquery1.version, subquery1.specialty, companies.name as company_name
FROM subquery1 JOIN companies
on subquey1.company=companies.cif),
subquery3 AS(
SELECT company_tax_id, LISTAGG(specialty, ';') WITHIN GROUP(ORDER BY specialty) AS specialty
FROM subquery2
GROUP BY company_tax_id),
final_query AS(
SELECT company_tax_id, company_name, product, version, specialty FROM (subquery2 JOIN subquery3 on subquery2.company_tax_id=subquery3=company_tax_id))
SELECT company_tax_id, company_name, product, version, specialty from final_query;
