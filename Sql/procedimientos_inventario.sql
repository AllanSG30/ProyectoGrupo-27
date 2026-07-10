/*
Proyecto FideStore
Creacion de Procedimientos
Autor: Jorge Damian Fernandez Delgado
Módulo: Inventario

Procedimientos CRUD para la tabla INVENTARIO.
*/


/*====================================================
PROCEDIMIENTO AgregarInventario
====================================================*/

CREATE OR REPLACE PROCEDURE AgregarInventario
(
    p_id_inventario IN NUMBER,
    p_id_producto IN NUMBER,
    p_cantidad_disponible IN NUMBER,
    p_fecha_actualizacion IN DATE
)
AS
BEGIN
    INSERT INTO INVENTARIO
    (
        id_inventario,
        id_producto,
        cantidad_disponible,
        fecha_actualizacion
    )
    VALUES
    (
        p_id_inventario,
        p_id_producto,
        p_cantidad_disponible,
        p_fecha_actualizacion
    );
END;
/

/*====================================================
PROCEDIMIENTO ConsultarInventario
====================================================*/

CREATE OR REPLACE PROCEDURE ConsultarInventario
(
    p_id_inventario IN NUMBER,
    p_id_producto OUT NUMBER,
    p_cantidad_disponible OUT NUMBER,
    p_fecha_actualizacion OUT DATE
)
AS
BEGIN
    SELECT
        id_producto,
        cantidad_disponible,
        fecha_actualizacion
    INTO
        p_id_producto,
        p_cantidad_disponible,
        p_fecha_actualizacion
    FROM INVENTARIO
    WHERE id_inventario = p_id_inventario;
END;
/

/*====================================================
PROCEDIMIENTO ActualizarInventario
====================================================*/

CREATE OR REPLACE PROCEDURE ActualizarInventario
(
    p_id_inventario IN NUMBER,
    p_cantidad_disponible IN NUMBER,
    p_fecha_actualizacion IN DATE
)
AS
BEGIN
    UPDATE INVENTARIO
    SET
        cantidad_disponible = p_cantidad_disponible,
        fecha_actualizacion = p_fecha_actualizacion
    WHERE id_inventario = p_id_inventario;
END;
/

/*====================================================
PROCEDIMIENTO EliminarInventario
====================================================*/

CREATE OR REPLACE PROCEDURE EliminarInventario
(
    p_id_inventario IN NUMBER
)
AS
BEGIN
    DELETE FROM INVENTARIO
    WHERE id_inventario = p_id_inventario;
END;
/