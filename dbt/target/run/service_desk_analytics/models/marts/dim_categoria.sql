
  
    

    create or replace table `service-desk-analytics-472019`.`raw_marts`.`dim_categoria`
      
    
    

    OPTIONS()
    as (
      

select
    row_number() over(order by categoria) as id_categoria,
    categoria
from (
    select distinct categoria from `service-desk-analytics-472019`.`raw_intermediate`.`int_chamados`
) t
    );
  