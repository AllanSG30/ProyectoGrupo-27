/*
    Proyecto: FideStore
    Curso: Lenguajes de Base de Datos
    Integrante: Andrey Corrales
    Archivo: procedimientos_categoria.sql
    Descripción:
    Procedimientos almacenados para el mantenimiento CRUD de la tabla CATEGORIA.

    Tabla relacionada:
    CATEGORIA
    - id_categoria
    - nombre_categoria
*/

/*====================================================
PROCEDIMIENTO AgregarCategoria
====================================================*/

CREATE OR REPLACE PROCEDURE AgregarCategoria
(
    p_id_categoria     IN CATEGORIA.id_categoria%TYPE,
    p_nombre_categoria IN CATEGORIA.nombre_categoria%TYPE
)
AS
BEGIN
    INSERT INTO CATEGORIA
    (
        id_categoria,
        nombre_categoria
    )
    VALUES
    (
        p_id_categoria,
        p_nombre_categoria
    );

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR
        (
            -20030,
            'Ya existe una categoría registrada con el mismo identificador.'
        );
END;
/

/*====================================================
PROCEDIMIENTO ConsultarCategoria
====================================================*/

CREATE OR REPLACE PROCEDURE ConsultarCategoria
(
    p_id_categoria     IN CATEGORIA.id_categoria%TYPE,
    p_nombre_categoria OUT CATEGORIA.nombre_categoria%TYPE
)
AS
BEGIN
    SELECT
        nombre_categoria
    INTO
        p_nombre_categoria
    FROM CATEGORIA
    WHERE id_categoria = p_id_categoria;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR
        (
            -20031,
            'No se encontró una categoría con el identificador indicado.'
        );
END;
/

/*====================================================
PROCEDIMIENTO ActualizarCategoria
====================================================*/

CREATE OR REPLACE PROCEDURE ActualizarCategoria
(
    p_id_categoria     IN CATEGORIA.id_categoria%TYPE,
    p_nombre_categoria IN CATEGORIA.nombre_categoria%TYPE
)
AS
BEGIN
    UPDATE CATEGORIA
    SET
        nombre_categoria = p_nombre_categoria
    WHERE id_categoria = p_id_categoria;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR
        (
            -20032,
            'No se actualizó ningún registro porque la categoría no existe.'
        );
    END IF;
END;
/

/*====================================================
PROCEDIMIENTO EliminarCategoria
====================================================*/

CREATE OR REPLACE PROCEDURE EliminarCategoria
(
    p_id_categoria IN CATEGORIA.id_categoria%TYPE
)
AS
BEGIN
    DELETE FROM CATEGORIA
    WHERE id_categoria = p_id_categoria;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR
        (
            -20033,
            'No se eliminó ningún registro porque la categoría no existe.'
        );
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2292 THEN
            RAISE_APPLICATION_ERROR
            (
                -20034,
                'No se puede eliminar la categoría porque tiene productos relacionados.'
            );
        ELSE
            RAISE;
        END IF;
END;
/