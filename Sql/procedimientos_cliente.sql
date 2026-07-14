/*
    Proyecto: FideStore
    Curso: Lenguajes de Base de Datos
    Integrante: Andrey Corrales
    Archivo: procedimientos_cliente.sql
    Descripción:
    Procedimientos almacenados para el mantenimiento CRUD de la tabla CLIENTE.

    Tabla relacionada:
    CLIENTE
    - id_cliente
    - nombre
    - correo
    - telefono
*/

/*====================================================
PROCEDIMIENTO AgregarCliente
====================================================*/

CREATE OR REPLACE PROCEDURE AgregarCliente
(
    p_id_cliente IN CLIENTE.id_cliente%TYPE,
    p_nombre     IN CLIENTE.nombre%TYPE,
    p_correo     IN CLIENTE.correo%TYPE,
    p_telefono   IN CLIENTE.telefono%TYPE
)
AS
BEGIN
    INSERT INTO CLIENTE
    (
        id_cliente,
        nombre,
        correo,
        telefono
    )
    VALUES
    (
        p_id_cliente,
        p_nombre,
        p_correo,
        p_telefono
    );

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR
        (
            -20010,
            'Ya existe un cliente registrado con el mismo identificador.'
        );
END;
/

/*====================================================
PROCEDIMIENTO ConsultarCliente
====================================================*/

CREATE OR REPLACE PROCEDURE ConsultarCliente
(
    p_id_cliente IN CLIENTE.id_cliente%TYPE,
    p_nombre     OUT CLIENTE.nombre%TYPE,
    p_correo     OUT CLIENTE.correo%TYPE,
    p_telefono   OUT CLIENTE.telefono%TYPE
)
AS
BEGIN
    SELECT
        nombre,
        correo,
        telefono
    INTO
        p_nombre,
        p_correo,
        p_telefono
    FROM CLIENTE
    WHERE id_cliente = p_id_cliente;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR
        (
            -20011,
            'No se encontró un cliente con el identificador indicado.'
        );
END;
/

/*====================================================
PROCEDIMIENTO ActualizarCliente
====================================================*/

CREATE OR REPLACE PROCEDURE ActualizarCliente
(
    p_id_cliente IN CLIENTE.id_cliente%TYPE,
    p_nombre     IN CLIENTE.nombre%TYPE,
    p_correo     IN CLIENTE.correo%TYPE,
    p_telefono   IN CLIENTE.telefono%TYPE
)
AS
BEGIN
    UPDATE CLIENTE
    SET
        nombre = p_nombre,
        correo = p_correo,
        telefono = p_telefono
    WHERE id_cliente = p_id_cliente;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR
        (
            -20012,
            'No se actualizó ningún registro porque el cliente no existe.'
        );
    END IF;
END;
/

/*====================================================
PROCEDIMIENTO EliminarCliente
====================================================*/

CREATE OR REPLACE PROCEDURE EliminarCliente
(
    p_id_cliente IN CLIENTE.id_cliente%TYPE
)
AS
BEGIN
    DELETE FROM CLIENTE
    WHERE id_cliente = p_id_cliente;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR
        (
            -20013,
            'No se eliminó ningún registro porque el cliente no existe.'
        );
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2292 THEN
            RAISE_APPLICATION_ERROR
            (
                -20014,
                'No se puede eliminar el cliente porque tiene información relacionada.'
            );
        ELSE
            RAISE;
        END IF;
END;
/