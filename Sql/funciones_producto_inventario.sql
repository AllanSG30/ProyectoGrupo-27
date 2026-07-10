/*
Proyecto FideStore
Creacion de Funciones
Autor: Jorge Damian Fernandez Delgado
Módulo: Producto e Inventario

Funciones para consulta de información del catálogo.
*/


/*====================================================
FUNCION ObtenerPrecioProducto
====================================================*/

CREATE OR REPLACE FUNCTION ObtenerPrecioProducto
(
    p_id_producto IN NUMBER
)
RETURN NUMBER
AS
    v_precio NUMBER;
BEGIN

    SELECT precio
    INTO v_precio
    FROM PRODUCTO
    WHERE id_producto = p_id_producto;

    RETURN v_precio;

END;
/

/*====================================================
FUNCION ObtenerStockProducto
====================================================*/

CREATE OR REPLACE FUNCTION ObtenerStockProducto
(
    p_id_producto IN NUMBER
)
RETURN NUMBER
AS
    v_stock NUMBER;
BEGIN

    SELECT cantidad_disponible
    INTO v_stock
    FROM INVENTARIO
    WHERE id_producto = p_id_producto;

    RETURN v_stock;

END;
/

/*====================================================
FUNCION ObtenerDisponibilidadProducto
====================================================*/

CREATE OR REPLACE FUNCTION ObtenerDisponibilidadProducto
(
    p_id_producto IN NUMBER
)
RETURN VARCHAR2
AS
    v_stock NUMBER;
BEGIN

    SELECT cantidad_disponible
    INTO v_stock
    FROM INVENTARIO
    WHERE id_producto = p_id_producto;

    IF v_stock > 0 THEN
        RETURN 'DISPONIBLE';
    ELSE
        RETURN 'AGOTADO';
    END IF;

END;
/
