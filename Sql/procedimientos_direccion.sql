/*
    Proyecto: FideStore
    Curso: Lenguajes de Base de Datos
    Integrante: Andrey Corrales
    Archivo: procedimientos_direccion.sql
    Descripción:
    Procedimientos almacenados para el mantenimiento CRUD de la tabla DIRECCION.

    Tabla relacionada:
    DIRECCION
    - id_direccion
    - id_cliente
    - direccion
*/

/*====================================================
PROCEDIMIENTO AgregarDireccion
====================================================*/

CREATE OR REPLACE PROCEDURE AgregarDireccion
(
    p_id_direccion IN DIRECCION.id_direccion%TYPE,
    p_id_cliente   IN DIRECCION.id_cliente%TYPE,
    p_direccion    IN DIRECCION.direccion%TYPE
)
AS
BEGIN
    INSERT INTO DIRECCION
    (
        id_direccion,
        id_cliente,
        direccion
    )
    VALUES
    (
        p_id_direccion,
        p_id_cliente,
        p_direccion
    );

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR
        (
            -20020,
            'Ya existe una dirección registrada con el mismo identificador.'
        );

    WHEN OTHERS THEN
        IF SQLCODE = -2291 THEN
            RAISE_APPLICATION_ERROR
            (
                -20021,
                'No se puede registrar la dirección porque el cliente indicado no existe.'
            );
        ELSE
            RAISE;
        END IF;
END;
/

/*====================================================
PROCEDIMIENTO ConsultarDireccion
====================================================*/

CREATE OR REPLACE PROCEDURE ConsultarDireccion
(
    p_id_direccion IN DIRECCION.id_direccion%TYPE,
    p_id_cliente   OUT DIRECCION.id_cliente%TYPE,
    p_direccion    OUT DIRECCION.direccion%TYPE
)
AS
BEGIN
    SELECT
        id_cliente,
        direccion
    INTO
        p_id_cliente,
        p_direccion
    FROM DIRECCION
    WHERE id_direccion = p_id_direccion;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR
        (
            -20022,
            'No se encontró una dirección con el identificador indicado.'
        );
END;
/

/*====================================================
PROCEDIMIENTO ActualizarDireccion
====================================================*/

CREATE OR REPLACE PROCEDURE ActualizarDireccion
(
    p_id_direccion IN DIRECCION.id_direccion%TYPE,
    p_id_cliente   IN DIRECCION.id_cliente%TYPE,
    p_direccion    IN DIRECCION.direccion%TYPE
)
AS
BEGIN
    UPDATE DIRECCION
    SET
        id_cliente = p_id_cliente,
        direccion = p_direccion
    WHERE id_direccion = p_id_direccion;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR
        (
            -20023,
            'No se actualizó ningún registro porque la dirección no existe.'
        );
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2291 THEN
            RAISE_APPLICATION_ERROR
            (
                -20024,
                'No se puede actualizar la dirección porque el cliente indicado no existe.'
            );
        ELSE
            RAISE;
        END IF;
END;
/

/*====================================================
PROCEDIMIENTO EliminarDireccion
====================================================*/

CREATE OR REPLACE PROCEDURE EliminarDireccion
(
    p_id_direccion IN DIRECCION.id_direccion%TYPE
)
AS
BEGIN
    DELETE FROM DIRECCION
    WHERE id_direccion = p_id_direccion;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR
        (
            -20025,
            'No se eliminó ningún registro porque la dirección no existe.'
        );
    END IF;
END;
/