

SELECT
    row_number() OVER(ORDER BY status) AS id_status,
    status
FROM (
    SELECT DISTINCT status FROM `service-desk-analytics-472019`.`raw_intermediate`.`int_chamados`
) t