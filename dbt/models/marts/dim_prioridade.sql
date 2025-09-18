{{ config(materialized='table', schema='marts') }}

SELECT
    row_number() OVER(ORDER BY prioridade) AS id_prioridade,
    prioridade
FROM (
    SELECT DISTINCT prioridade FROM {{ ref('int_chamados') }}
) t
