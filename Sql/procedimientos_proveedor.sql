/*
Proyecto FideStore
Creacion de Procedimientos
Autor: Jorge Damian Fernandez Delgado
Módulo: Proveedor

Procedimientos CRUD para la tabla PROVEEDOR.
*/


/*====================================================
PROCEDIMIENTO AgregarProveedor
====================================================*/

CREATE OR REPLACE PROCEDURE AgregarProveedor
(
    p_id_proveedor IN NUMBER,
    p_nombre_proveedor IN VARCHAR2,
    p_contacto IN VARCHAR2
)
AS
BEGIN
    INSERT INTO PROVEEDOR
    (
        id_proveedor,
        nombre_proveedor,
        contacto
    )
    VALUES
    (
        p_id_proveedor,
        p_nombre_proveedor,
        p_contacto
    );
END;
/

/*====================================================
PROCEDIMIENTO ConsultarProveedor
====================================================*/

CREATE OR REPLACE PROCEDURE ConsultarProveedor
(
    p_id_proveedor IN NUMBER,
    p_nombre_proveedor OUT VARCHAR2,
    p_contacto OUT VARCHAR2
)
AS
BEGIN
    SELECT
        nombre_proveedor,
        contacto
    INTO
        p_nombre_proveedor,
        p_contacto
    FROM PROVEEDOR
    WHERE id_proveedor = p_id_proveedor;
END;
/

/*====================================================
PROCEDIMIENTO ActualizarProveedor
====================================================*/

CREATE OR REPLACE PROCEDURE ActualizarProveedor
(
    p_id_proveedor IN NUMBER,
    p_nombre_proveedor IN VARCHAR2,
    p_contacto IN VARCHAR2
)
AS
BEGIN
    UPDATE PROVEEDOR
    SET
        nombre_proveedor = p_nombre_proveedor,
        contacto = p_contacto
    WHERE id_proveedor = p_id_proveedor;
END;
/

/*====================================================
PROCEDIMIENTO EliminarProveedor
====================================================*/

CREATE OR REPLACE PROCEDURE EliminarProveedor
(
    p_id_proveedor IN NUMBER
)
AS
BEGIN
    DELETE FROM PROVEEDOR
    WHERE id_proveedor = p_id_proveedor;
END;
/