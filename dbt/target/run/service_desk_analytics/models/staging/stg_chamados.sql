

  create or replace view `service-desk-analytics-472019`.`raw_staging`.`stg_chamados`
  OPTIONS()
  as 

WITH raw_data AS (
    SELECT * FROM `service-desk-analytics-472019`.`raw`.`chamados`
),

cleaned AS (
    SELECT
        -- IDs e Datas (validação básica)
        id_chamado,
        CAST(data_abertura AS TIMESTAMP) AS data_abertura,
        CAST(data_fechamento AS TIMESTAMP) AS data_fechamento,
        
        -- Categorias (padronização)
        UPPER(TRIM(categoria)) AS categoria,
        INITCAP(TRIM(canal)) AS canal,
        
        -- Prioridade (tratamento de nulos e padronização)
        CASE 
            WHEN prioridade IS NULL THEN 'NÃO_INFORMADA'
            ELSE INITCAP(TRIM(prioridade))
        END AS prioridade,
        
        -- Status (validação)
        CASE 
            WHEN status IN ('Aberto', 'Em andamento', 'Fechado') THEN status
            ELSE 'STATUS_DESCONHECIDO'
        END AS status,
        
        -- Métricas numéricas (tratamento de outliers)
        CAST(tempo_espera AS NUMERIC) AS tempo_espera_minutos,
        CAST(tempo_resolucao AS NUMERIC) AS tempo_resolucao_horas,
        
        -- CSAT (valores válidos 1-5, nulos tratados)
        CASE 
            WHEN csat BETWEEN 1 AND 5 THEN csat
            ELSE NULL
        END AS csat_score,
        
        -- Flags booleanas (garantir consistência)
        CAST(sla_atingido AS BOOLEAN) AS is_sla_atingido,
        CAST(first_contact_resolution AS BOOLEAN) AS is_first_contact,
        
        -- Metadados para qualidade
        CURRENT_TIMESTAMP() AS dbt_loaded_at

    FROM raw_data
)

SELECT * FROM cleaned;

