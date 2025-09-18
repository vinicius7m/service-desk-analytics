
  
    

    create or replace table `service-desk-analytics-472019`.`raw_marts`.`dim_prioridade`
      
    
    

    OPTIONS()
    as (
      

SELECT
    row_number() OVER(ORDER BY prioridade) AS id_prioridade,
    prioridade
FROM (
    SELECT DISTINCT prioridade FROM `service-desk-analytics-472019`.`raw_intermediate`.`int_chamados`
) t
    );
  