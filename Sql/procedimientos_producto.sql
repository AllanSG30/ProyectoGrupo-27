/*
Proyecto FideStore
Creacion de Procedimientos
Autor: Jorge Damian Fernandez Delgado
Módulo: Producto

Procedimientos CRUD para la tabla PRODUCTO.
*/


/*====================================================
PROCEDIMIENTO AgregarProducto
====================================================*/

CREATE OR REPLACE PROCEDURE AgregarProducto
(
    p_id_producto IN NUMBER,
    p_id_categoria IN NUMBER,
    p_nombre_producto IN VARCHAR2,
    p_precio IN NUMBER
)
AS
BEGIN
    INSERT INTO PRODUCTO
    (
        id_producto,
        id_categoria,
        nombre_producto,
        precio
    )
    VALUES
    (
        p_id_producto,
        p_id_categoria,
        p_nombre_producto,
        p_precio
    );
END;
/

/*====================================================
PROCEDIMIENTO ConsultarProducto
====================================================*/

CREATE OR REPLACE PROCEDURE ConsultarProducto
(
    p_id_producto IN NUMBER,
    p_id_categoria OUT NUMBER,
    p_nombre_producto OUT VARCHAR2,
    p_precio OUT NUMBER
)
AS
BEGIN
    SELECT
        id_categoria,
        nombre_producto,
        precio
    INTO
        p_id_categoria,
        p_nombre_producto,
        p_precio
    FROM PRODUCTO
    WHERE id_producto = p_id_producto;
END;
/

/*====================================================
PROCEDIMIENTO ActualizarProducto
====================================================*/

CREATE OR REPLACE PROCEDURE ActualizarProducto
(
    p_id_producto IN NUMBER,
    p_id_categoria IN NUMBER,
    p_nombre_producto IN VARCHAR2,
    p_precio IN NUMBER
)
AS
BEGIN
    UPDATE PRODUCTO
    SET
        id_categoria = p_id_categoria,
        nombre_producto = p_nombre_producto,
        precio = p_precio
    WHERE id_producto = p_id_producto;
END;
/

/*====================================================
PROCEDIMIENTO EliminarProducto
====================================================*/

CREATE OR REPLACE PROCEDURE EliminarProducto
(
    p_id_producto IN NUMBER
)
AS
BEGIN
    DELETE FROM PRODUCTO
    WHERE id_producto = p_id_producto;
END;
/