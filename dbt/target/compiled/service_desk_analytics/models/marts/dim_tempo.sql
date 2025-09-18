

WITH dates AS (
    SELECT *
    FROM unnest(generate_date_array('2020-01-01', current_date(), interval 1 day)) AS data
)

SELECT
    row_number() OVER(ORDER BY data) AS id_tempo,
    data,
    EXTRACT(year FROM data) AS ano,
    EXTRACT(quarter FROM data) AS trimestre,
    EXTRACT(month FROM data) AS mes,
    format_date('%Y-%m', data) AS ano_mes,
    EXTRACT(day FROM data) AS dia,
    EXTRACT(dayofweek FROM data) AS dia_semana,
    CASE EXTRACT(dayofweek FROM data)
        WHEN 1 THEN 'Domingo'
        WHEN 2 THEN 'Segunda'
        WHEN 3 THEN 'Terça'
        WHEN 4 THEN 'Quarta'
        WHEN 5 THEN 'Quinta'
        WHEN 6 THEN 'Sexta'
        WHEN 7 THEN 'Sábado'
    END AS nome_dia_semana
FROM dates