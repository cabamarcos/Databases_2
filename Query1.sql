--We select only the active products 
With products_ AS(
    SELECT cif, name, version 
    FROM products 
    WHERE retired is NULL AND 
          launch is not NULL
),
--we select the attributes we need from specialty
products_specialty AS(
    SELECT COVERAGES.specialty, 
       COVERAGES.name, 
       COVERAGES.version, 
       COVERAGES.cif 
    FROM coverages
    JOIN products_ 
     ON (coverages.cif=products_.cif AND 
        coverages.version=products_.version AND 
        coverages.name=products_.name)
),  
selec_contracts AS(
    SELECT contracts.company,contracts.hospital 
    FROM contracts
     WHERE start_date< sysdate AND 
           end_date > sysdate AND rownum<5
),
subquery1 AS( 
    SELECT *
    FROM selec_contracts 
    JOIN products_specialty
    ON selec_contracts.company=products_specialty.cif 
),
subquery1_doctors AS( 
    SELECT adscriptions.doctor ,
           subquery1.specialty ,
           subquery1.hospital ,
           subquery1.name ,
           subquery1.version ,
           subquery1.cif
    FROM adscriptions 
    JOIN subquery1 
    ON (adscriptions.hospital= subquery1.hospital AND
        adscriptions.specialty=subquery1.specialty)
), 
--query used for counting_doctors 
doctors_selection AS( 
    SELECT subquery1_doctors.doctor,
           subquery1_doctors.name , 
           subquery1_doctors.cif, 
           subquery1_doctors.version 
    FROM subquery1_doctors 
),
--query used for counting_specialties
specialties_selection AS( 
    SELECT subquery1_doctors.specialty, 
           subquery1_doctors.name , 
           subquery1_doctors.cif, 
           subquery1_doctors.version 
    FROM subquery1_doctors 
),
--we count the number of doctors 
count_doctors AS ( 
    SELECT doctors_selection.name, 
    doctors_selection.version, 
    doctors_selection.cif ,
    count(*) count_doctors 
    FROM doctors_selection
    GROUP BY ( name,version,cif)
),
count_spec AS(
    SELECT specialties_selection.name, 
           specialties_selection.version, 
           specialties_selection.cif ,
           count(*) count_specialties
    FROM specialties_selection
    GROUP BY ( name,version,cif)
),
join_counts AS(
    SELECT count_specialties, 
           count_doctors,
           count_doctors.cif,
           count_doctors.version,
           count_doctors.name
    FROM count_spec
    JOIN count_doctors 
    ON (count_doctors.cif=count_spec.cif AND 
       count_doctors.version=count_spec.version AND 
       count_doctors.name=count_spec.name )
),
semifinal_result AS( 
    SELECT subquery1_doctors.doctor ,
           subquery1_doctors.specialty ,
           subquery1_doctors.hospital ,
           subquery1_doctors.name ,
           subquery1_doctors.version ,
           subquery1_doctors.cif,
           join_counts.count_specialties,
           join_counts.count_doctors
    FROM subquery1_doctors 
    JOIN join_counts
    ON (subquery1_doctors.cif=join_counts.cif AND 
       subquery1_doctors.version=join_counts.version AND 
      subquery1_doctors.name=join_counts.name )
),
--selecting the attributes we need from companies 
final_result AS( 
    SELECT semifinal_result.doctor ,
           semifinal_result.specialty ,
           semifinal_result.hospital ,
           semifinal_result.name ,
           semifinal_result.version ,
           semifinal_result.cif,
           semifinal_result.count_specialties,
           semifinal_result.count_doctors,
           companies.name company_name 
    FROM companies 
    JOIN semifinal_result 
    ON (companies.cif= semifinal_result.cif)
)
SELECT final_result.cif company_tax_id, 
       final_result.company_name, 
       final_result.name product_name,
       final_result.version product_version ,
       final_result.count_doctors, 
       final_result.count_specialties
       FROM final_result where rownum<5;
