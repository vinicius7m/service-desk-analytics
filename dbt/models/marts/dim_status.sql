{{ config(materialized='table', schema='marts') }}

SELECT
    row_number() OVER(ORDER BY status) AS id_status,
    status
FROM (
    SELECT DISTINCT status FROM {{ ref('int_chamados') }}
) t
