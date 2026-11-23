-- ============================================================================
-- UNIVERSIDAD DE ANTIOQUIA - TECNICAS DE PROGRAMACIÓN Y LABORATORIO
-- ESTUDIANTE: CHRISTIAN CAMILO TORRES MEJÍA
-- PROFESOR: FRAY 
-- EVALUACION 4 - PARADIGMA DECLARATIVO / POSTGRESQL
-- Archivo base: DDL - Moneda.sql
--
--
-- ORDEN DE EJECUCION EN pgAdmin:
-- 1. Si la base Monedas NO existe, conectese a postgres y ejecute
--    UNICAMENTE la sentencia CREATE DATABASE que aparece abajo, por separado.
--    CREATE DATABASE no puede ejecutarse dentro de una transaccion ni junto
--    con el resto del archivo. Si Monedas ya existe, omita esa sentencia.
-- 2. Cambie la conexion de pgAdmin a la base Monedas.
-- 3. Ejecute el resto de este archivo desde la seccion PASO 2.
-- 4. Si Monedas ya existe, omita CREATE DATABASE y ejecute el resto conectado
--    a Monedas. No elimine la base de datos para volver a comenzar.
--
-- Se agrega un indice unico sobre Sigla para validar la existencia de monedas
-- mediante su codigo y evitar registros duplicados.
-- ============================================================================

-- PASO 1: ejecutar por separado y solo si la base de datos no existe.
CREATE DATABASE Monedas;

-- ============================================================================
-- PASO 2: ejecutar conectado a la base de datos Monedas.
-- ============================================================================

-- Crear tabla MONEDA
CREATE TABLE IF NOT EXISTS Moneda(
    Id SERIAL PRIMARY KEY,
    Moneda VARCHAR(100) NOT NULL,
    Sigla VARCHAR(5) NOT NULL,
    Simbolo VARCHAR(5) NULL,
    Emisor VARCHAR(100) NULL,
    Imagen BYTEA NULL
);

-- Indice unico original, ordenado por nombre de moneda.
CREATE UNIQUE INDEX IF NOT EXISTS ixMoneda
    ON Moneda(Moneda);

-- Indice unico adicional para validar la existencia por sigla.
CREATE UNIQUE INDEX IF NOT EXISTS ixMoneda_Sigla
    ON Moneda(Sigla);

-- Crear tabla CAMBIOMONEDA
CREATE TABLE IF NOT EXISTS CambioMoneda(
    IdMoneda INTEGER NOT NULL,
    CONSTRAINT fkCambioMoneda_IdMoneda
        FOREIGN KEY (IdMoneda) REFERENCES Moneda(Id),
    Fecha DATE NOT NULL,
    Cambio FLOAT NOT NULL
);

-- Indice unico original: una sola cotizacion por moneda y fecha.
-- Este indice permite usar ON CONFLICT (IdMoneda, Fecha) DO UPDATE.
CREATE UNIQUE INDEX IF NOT EXISTS ixCambioMoneda
    ON CambioMoneda(IdMoneda, Fecha);

-- Crear tabla PAIS
CREATE TABLE IF NOT EXISTS Pais(
    Id SERIAL PRIMARY KEY,
    Pais VARCHAR(50) NOT NULL,
    CodigoAlfa2 VARCHAR(5) NOT NULL,
    CodigoAlfa3 VARCHAR(5) NOT NULL,
    IdMoneda INTEGER NOT NULL,
    CONSTRAINT fkPais_IdMoneda
        FOREIGN KEY (IdMoneda) REFERENCES Moneda(Id),
    Mapa BYTEA NULL,
    Bandera BYTEA NULL
);

-- Indice unico original de PAIS.
CREATE UNIQUE INDEX IF NOT EXISTS ixPais_Pais
    ON Pais(Pais);

-- FIN DEL DDL. La carga de informacion se realiza desde DML - Monedas.sql.

-- ============================================================================
-- PASO 3: ejecutar la consulta SQL sirve para listar las tablas que existen en el esquema
-- public de la base de datos a la que estás conectado.
-- ============================================================================


SELECT table_name
   FROM information_schema.tables
   WHERE table_schema = 'public'
   ORDER BY table_name;

-- ============================================================================
-- PASO 4: verificar los registros
-- ============================================================================


   SELECT
    (SELECT COUNT(*) FROM Moneda) AS total_monedas,
    (SELECT COUNT(*) FROM Pais) AS total_paises,
    (SELECT COUNT(*) FROM CambioMoneda) AS total_cambios;

-- ============================================================================
-- PASO 5: abrir el archivo DML - monedas.sql, seleccionar todo el script y ejecutarlo F5
-- ============================================================================


-- ============================================================================
-- PASO 6: en el query DML - monedas.sql, ejecutar y verificar los registros
-- ============================================================================
--NOTA IMPORTANTE: este script se ejecuta en la última línea de DML - monedas.sql

SELECT
   (SELECT COUNT(*) FROM Moneda) AS total_monedas,
   (SELECT COUNT(*) FROM Pais) AS total_paises,
   (SELECT COUNT(*) FROM CambioMoneda) AS total_cambios;

-- ============================================================================
-- PASO 7: ejecutar las secuencias - abrir el archivo DDL-moneda-secuencias.sql y ejecutar todo el script Ctrl A y luego F5
-- ============================================================================
   
