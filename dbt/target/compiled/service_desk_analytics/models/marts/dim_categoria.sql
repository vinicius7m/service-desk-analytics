

select
    row_number() over(order by categoria) as id_categoria,
    categoria
from (
    select distinct categoria from `service-desk-analytics-472019`.`raw_intermediate`.`int_chamados`
) t