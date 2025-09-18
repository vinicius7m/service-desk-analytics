{{ config(materialized='table', schema='marts') }}

select
    row_number() over(order by categoria) as id_categoria,
    categoria
from (
    select distinct categoria from {{ ref('int_chamados') }}
) t
