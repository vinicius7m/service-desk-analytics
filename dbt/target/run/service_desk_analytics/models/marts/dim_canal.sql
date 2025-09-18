
  
    

    create or replace table `service-desk-analytics-472019`.`raw_marts`.`dim_canal`
      
    
    

    OPTIONS()
    as (
      

SELECT
    row_number() OVER(ORDER BY canal) AS id_canal,
    canal
FROM (
    SELECT DISTINCT canal FROM `service-desk-analytics-472019`.`raw_intermediate`.`int_chamados`
) t
    );
  