{{ config(materialized='table', schema='marts') }}

SELECT
    row_number() OVER(ORDER BY canal) AS id_canal,
    canal
FROM (
    SELECT DISTINCT canal FROM {{ ref('int_chamados') }}
) t
