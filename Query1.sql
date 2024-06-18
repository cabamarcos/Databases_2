WITH subquery1 
AS
(SELECT products.cif, products.name, products.version, coverages.specialty FROM
(SELECT cif, name, version FROM products) products
RIGHT JOIN
(SELECT specialty, cif, name, version FROM coverages) coverages
ON
(products.cif=coverages.cif and products.name=coverages.name and products.version=coverages.version)),
subquery2
AS
(SELECT DISTINCT subquery1.cif, subquery1.name, subquery1.version, subquery1.specialty, contracts.hospital FROM
(SELECT company, hospital,start_date,end_date FROM contracts
WHERE (start_date < sysdate and end_date > sysdate)) contracts
JOIN
subquery1
ON
(subquery1.cif=contracts.company)),
subquery3
AS
(SELECT DISTINCT subquery2.cif, subquery2.name, subquery2.specialty, subquery2.hospital, subquery2.version, services.hospital,services.specialty 
FROM (SELECT specialty, hospital from services) services 
RIGHT JOIN 
subquery2 
ON 
(subquery2.specialty= services.specialty and subquery2.hospital= services.hospital ))
SELECT subquery3.hospital from subquery3 where rownum <5;

##query 2

WITH subquery1 
AS
(SELECT products.cif, products.name, products.version, coverages.specialty FROM
(SELECT cif, name, version FROM products) products
RIGHT JOIN
(SELECT specialty, cif, name, version FROM coverages) coverages
ON
(products.cif=coverages.cif and products.name=coverages.name and products.version=coverages.version)),
subquery2
AS
(SELECT DISTINCT subquery1.cif, subquery1.name, subquery1.version, subquery1.specialty, contracts.hospital FROM
(SELECT company, hospital,start_date,end_date FROM contracts
WHERE (start_date < sysdate and end_date > sysdate)) contracts
JOIN
subquery1
ON
(subquery1.cif=contracts.company)),
subquery3 as 
 (SELECT companies.name company_name, companies.cif company_cif, subquery2.name product_name ,subquery2.version, subquery2.specialty, subquery2.hospital FROM companies 
JOIN 
subquery2 
ON 
(subquery2.cif=companies.cif)),

SELECT hospital, LISTAGG(specialty, ‘;’) WITHIN GROUP (ORDER BY specialty)  AS SUB FROM subquery3
GROUP BY hospital;
GROUP BY hospital where rownum<5;
SELECT * FROM subquery3 where rownum<5;

— UP TO THERE WE HAVE THE SELECTION, WE ARE JUST MISSING THE CONCAT

WITH subquery4 as 
—SELECT * FROM services 
—JOIN subquery3 ON
— services.hospital= subquery3.hospital AND services.specialty != subquery2.specialty)
SELECT A.hospital AS hospital1, B.hospital AS hospital2
FROM subquery3 A, subquery3 B
WHERE 

—hacer join con cOMPANIES para sacar el name 
SELECT specialty,hospital,
   GROUP_CONCAT( specialty SEPARATOR '; ')
FROM subquery3
GROUP BY hospital;

SELECT GROUP_CONCAT(specialty SEPARATOR ';')
FROM    subquery3 where A.hospital= B.hospital 

SELECT hospital, LISTAGG(specialty, ‘;’) WITHIN GROUP (ORDER BY specialty)  AS SUB FROM subquery3
GROUP BY hospital;




—--------------------------------------------------------------borrador—--------------------------------------------
WITH subquery1 
AS
(SELECT products.cif, products.name, products.version, coverages.specialty FROM
(SELECT cif, name, version FROM products) products
RIGHT JOIN
(SELECT specialty, cif, name, version FROM coverages) coverages
ON
(products.cif=coverages.cif and products.name=coverages.name and products.version=coverages.version)),
subquery2
AS
(SELECT DISTINCT subquery1.cif, subquery1.name, subquery1.version, subquery1.specialty, contracts.hospital FROM
(SELECT company, hospital,start_date,end_date FROM contracts
WHERE (start_date < sysdate and end_date > sysdate)) contracts
JOIN
subquery1
ON
(subquery1.cif=contracts.company))
SELECT companies.name, companies.cif, subquery2.cif, subquery2.name,subquery2.version, subquery2.specialty, subquery2.hospital FROM companies 
JOIN 
subquery2 
ON 
(subquery2.cif=companies.cif);


CREATE table subquery4 as (SELECT specialty,hospital,
       GROUP_CONCAT(specialty, ',')
FROM subquery3
GROUP BY hospital);

SELECT [...], (SELECT COUNT(*) FROM mytable) AS count FROM myothertable

—----------------------------------------------------------------------------------------------------

WITH subquery1 
AS
(SELECT products.cif, products.name, products.version, coverages.specialty FROM
(SELECT cif, name, version FROM products) products
RIGHT JOIN
(SELECT specialty, cif, name, version FROM coverages) coverages
ON
(products.cif=coverages.cif and products.name=coverages.name and products.version=coverages.version)),
subquery2
AS
(SELECT DISTINCT subquery1.cif, subquery1.name, subquery1.version, subquery1.specialty, contracts.hospital FROM
(SELECT company, hospital,start_date,end_date FROM contracts
WHERE (start_date < sysdate and end_date > sysdate)) contracts
JOIN
subquery1
ON
(subquery1.cif=contracts.company))
desc subquery2;




create table subquery3 as SELECT companies.name company_name, companies.cif company_cif, subquery2.name product_name ,subquery2.version, subquery2.specialty, subquery2.hospital FROM companies 
JOIN 
subquery2 
ON 
(subquery2.cif=companies.cif);











—---tables approach—---

CREATE TABLE subquery1 as (SELECT products.cif, products.name, products.version, coverages.specialty FROM
(SELECT cif, name, version FROM products) products
RIGHT JOIN
(SELECT specialty, cif, name, version FROM coverages) coverages
ON
(products.cif=coverages.cif and products.name=coverages.name and products.version=coverages.version));

CREATE TABLE subquery2 as(SELECT DISTINCT subquery1.cif, subquery1.name, subquery1.version, subquery1.specialty, contracts.hospital FROM
(SELECT company, hospital,start_date,end_date FROM contracts
WHERE (start_date < sysdate and end_date > sysdate)) contracts
JOIN
subquery1
ON
(subquery1.cif=contracts.company))

ALTER TABLE subquery2
RENAME COLUMN hospital to hospital_sub2;

ALTER TABLE subquery2
RENAME COLUMN hospital to hospital_sub2;






