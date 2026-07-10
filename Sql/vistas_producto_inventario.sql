/*
Proyecto FideStore
Creacion de Vistas
Autor: Jorge Damian Fernandez Delgado
Módulo: Producto e Inventario

Vistas para consulta de información del catálogo e inventario.
*/


/*====================================================
VISTA VistaProductos
====================================================*/

CREATE OR REPLACE VIEW VistaProductos AS
SELECT
    id_producto,
    id_categoria,
    nombre_producto,
    precio
FROM PRODUCTO;


/*====================================================
VISTA VistaInventario
====================================================*/

CREATE OR REPLACE VIEW VistaInventario AS
SELECT
    id_inventario,
    id_producto,
    cantidad_disponible,
    fecha_actualizacion
FROM INVENTARIO;


/*====================================================
VISTA VistaProductosInventario
====================================================*/

CREATE OR REPLACE VIEW VistaProductosInventario AS
SELECT
    p.id_producto,
    p.nombre_producto,
    p.precio,
    i.cantidad_disponible,
    i.fecha_actualizacion
FROM PRODUCTO p
INNER JOIN INVENTARIO i
    ON p.id_producto = i.id_producto;