-- ============================================================================
-- UNIVERSIDAD DE ANTIOQUIA TECNICAS DE PROGRAMACIÓN Y LABORATORIO
-- ESTUDIANTE: CHRISTIAN CAMILO TORRES MEJÍA
-- PROFESOR: FRAY 
-- EVALUACION 4 - PARADIGMA DECLARATIVO / POSTGRESQL
-- Archivo base: DDL - Moneda - Secuencias.sql
--
-- EJECUTAR DESPUES DE DML - Monedas.sql.
-- Los registros originales especifican Id manualmente; por ello se sincroniza
-- la secuencia SERIAL para que las siguientes monedas o paises reciban un
-- identificador disponible. Este bloque puede ejecutarse varias veces.
-- ============================================================================

DO $$
DECLARE
    secuencia_moneda TEXT;
    secuencia_pais TEXT;
    max_id_moneda BIGINT;
    max_id_pais BIGINT;
BEGIN
    secuencia_moneda := pg_get_serial_sequence('public.moneda', 'id');
    secuencia_pais := pg_get_serial_sequence('public.pais', 'id');

    SELECT COALESCE(MAX(Id), 0)
      INTO max_id_moneda
      FROM Moneda;

    SELECT COALESCE(MAX(Id), 0)
      INTO max_id_pais
      FROM Pais;

    IF secuencia_moneda IS NOT NULL THEN
        PERFORM setval(
            secuencia_moneda::regclass,
            GREATEST(max_id_moneda, 1),
            max_id_moneda > 0
        );
    END IF;

    IF secuencia_pais IS NOT NULL THEN
        PERFORM setval(
            secuencia_pais::regclass,
            GREATEST(max_id_pais, 1),
            max_id_pais > 0
        );
    END IF;
END $$;

-- Consulta opcional para verificar los identificadores maximos cargados.
SELECT 'Moneda' AS Tabla, MAX(Id) AS IdMaximo FROM Moneda
UNION ALL
SELECT 'Pais' AS Tabla, MAX(Id) AS IdMaximo FROM Pais;
