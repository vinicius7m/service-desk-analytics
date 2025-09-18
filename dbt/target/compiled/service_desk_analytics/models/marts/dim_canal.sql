

SELECT
    row_number() OVER(ORDER BY canal) AS id_canal,
    canal
FROM (
    SELECT DISTINCT canal FROM `service-desk-analytics-472019`.`raw_intermediate`.`int_chamados`
) t