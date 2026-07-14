/*
    Proyecto: FideStore
    Curso: Lenguajes de Base de Datos
    Archivo: objetos_complementarios_avance2.sql
    Descripcion:
    Objetos PL/SQL complementarios para completar funciones, vistas,
    cursores y paquetes requeridos en el Avance II.

    Nota:
    Este archivo debe ejecutarse despues de creacion_tablas.sql.
    Los objetos aqui creados son de apoyo general y no reemplazan
    los modulos desarrollados por cada integrante.
*/

/*====================================================
FUNCIONES COMPLEMENTARIAS
====================================================*/

CREATE OR REPLACE FUNCTION ContarTotalClientes
RETURN NUMBER
AS
    v_total NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_total
    FROM CLIENTE;

    RETURN v_total;
END;
/

CREATE OR REPLACE FUNCTION ContarTotalCategorias
RETURN NUMBER
AS
    v_total NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_total
    FROM CATEGORIA;

    RETURN v_total;
END;
/

CREATE OR REPLACE FUNCTION ContarTotalProductos
RETURN NUMBER
AS
    v_total NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_total
    FROM PRODUCTO;

    RETURN v_total;
END;
/

CREATE OR REPLACE FUNCTION ContarTotalPedidos
RETURN NUMBER
AS
    v_total NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_total
    FROM PEDIDO;

    RETURN v_total;
END;
/

CREATE OR REPLACE FUNCTION CalcularValorInventario
RETURN NUMBER
AS
    v_total NUMBER;
BEGIN
    SELECT NVL(SUM(p.precio * i.cantidad_disponible), 0)
    INTO v_total
    FROM PRODUCTO p
    INNER JOIN INVENTARIO i
        ON p.id_producto = i.id_producto;

    RETURN v_total;
END;
/

/*====================================================
VISTAS COMPLEMENTARIAS
====================================================*/

CREATE OR REPLACE VIEW VistaResumenGeneralFideStore AS
SELECT
    (SELECT COUNT(*) FROM CLIENTE) AS total_clientes,
    (SELECT COUNT(*) FROM CATEGORIA) AS total_categorias,
    (SELECT COUNT(*) FROM PRODUCTO) AS total_productos,
    (SELECT COUNT(*) FROM PROVEEDOR) AS total_proveedores,
    (SELECT COUNT(*) FROM PEDIDO) AS total_pedidos,
    (SELECT COUNT(*) FROM DETALLE_PEDIDO) AS total_detalles_pedido
FROM dual;

CREATE OR REPLACE VIEW VistaValorInventario AS
SELECT
    p.id_producto,
    p.nombre_producto,
    p.precio,
    NVL(i.cantidad_disponible, 0) AS cantidad_disponible,
    p.precio * NVL(i.cantidad_disponible, 0) AS valor_total_producto
FROM PRODUCTO p
LEFT JOIN INVENTARIO i
    ON p.id_producto = i.id_producto;

/*====================================================
PROCEDIMIENTOS CON CURSORES COMPLEMENTARIOS
====================================================*/

CREATE OR REPLACE PROCEDURE ReporteResumenGeneralCursor
AS
    CURSOR c_resumen IS
        SELECT
            total_clientes,
            total_categorias,
            total_productos,
            total_proveedores,
            total_pedidos,
            total_detalles_pedido
        FROM VistaResumenGeneralFideStore;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Resumen general de FideStore:');

    FOR fila IN c_resumen LOOP
        DBMS_OUTPUT.PUT_LINE('Total clientes: ' || fila.total_clientes);
        DBMS_OUTPUT.PUT_LINE('Total categorias: ' || fila.total_categorias);
        DBMS_OUTPUT.PUT_LINE('Total productos: ' || fila.total_productos);
        DBMS_OUTPUT.PUT_LINE('Total proveedores: ' || fila.total_proveedores);
        DBMS_OUTPUT.PUT_LINE('Total pedidos: ' || fila.total_pedidos);
        DBMS_OUTPUT.PUT_LINE('Total detalles de pedido: ' || fila.total_detalles_pedido);
    END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE ReporteValorInventarioCursor
AS
    CURSOR c_valor_inventario IS
        SELECT
            id_producto,
            nombre_producto,
            precio,
            cantidad_disponible,
            valor_total_producto
        FROM VistaValorInventario
        ORDER BY id_producto;

    v_total_general NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Reporte de valor de inventario:');

    FOR fila IN c_valor_inventario LOOP
        v_total_general := v_total_general + fila.valor_total_producto;

        DBMS_OUTPUT.PUT_LINE
        (
            'ID Producto: ' || fila.id_producto
            || ' | Producto: ' || fila.nombre_producto
            || ' | Precio: ' || fila.precio
            || ' | Cantidad: ' || fila.cantidad_disponible
            || ' | Valor: ' || fila.valor_total_producto
        );
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Valor total del inventario: ' || v_total_general);
END;
/

/*====================================================
PAQUETE PKG_UTIL_CLIENTES
====================================================*/

CREATE OR REPLACE PACKAGE PKG_UTIL_CLIENTES AS

    FUNCTION TotalClientes
    RETURN NUMBER;

    PROCEDURE MostrarTotalClientes;

END PKG_UTIL_CLIENTES;
/

CREATE OR REPLACE PACKAGE BODY PKG_UTIL_CLIENTES AS

    FUNCTION TotalClientes
    RETURN NUMBER
    AS
    BEGIN
        RETURN ContarTotalClientes;
    END TotalClientes;

    PROCEDURE MostrarTotalClientes
    AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Total de clientes registrados: ' || ContarTotalClientes);
    END MostrarTotalClientes;

END PKG_UTIL_CLIENTES;
/

/*====================================================
PAQUETE PKG_UTIL_CATEGORIAS
====================================================*/

CREATE OR REPLACE PACKAGE PKG_UTIL_CATEGORIAS AS

    FUNCTION TotalCategorias
    RETURN NUMBER;

    PROCEDURE MostrarTotalCategorias;

END PKG_UTIL_CATEGORIAS;
/

CREATE OR REPLACE PACKAGE BODY PKG_UTIL_CATEGORIAS AS

    FUNCTION TotalCategorias
    RETURN NUMBER
    AS
    BEGIN
        RETURN ContarTotalCategorias;
    END TotalCategorias;

    PROCEDURE MostrarTotalCategorias
    AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Total de categorias registradas: ' || ContarTotalCategorias);
    END MostrarTotalCategorias;

END PKG_UTIL_CATEGORIAS;
/

/*====================================================
PAQUETE PKG_UTIL_PRODUCTOS
====================================================*/

CREATE OR REPLACE PACKAGE PKG_UTIL_PRODUCTOS AS

    FUNCTION TotalProductos
    RETURN NUMBER;

    PROCEDURE MostrarTotalProductos;

END PKG_UTIL_PRODUCTOS;
/

CREATE OR REPLACE PACKAGE BODY PKG_UTIL_PRODUCTOS AS

    FUNCTION TotalProductos
    RETURN NUMBER
    AS
    BEGIN
        RETURN ContarTotalProductos;
    END TotalProductos;

    PROCEDURE MostrarTotalProductos
    AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Total de productos registrados: ' || ContarTotalProductos);
    END MostrarTotalProductos;

END PKG_UTIL_PRODUCTOS;
/

/*====================================================
PAQUETE PKG_UTIL_PEDIDOS
====================================================*/

CREATE OR REPLACE PACKAGE PKG_UTIL_PEDIDOS AS

    FUNCTION TotalPedidos
    RETURN NUMBER;

    PROCEDURE MostrarTotalPedidos;

END PKG_UTIL_PEDIDOS;
/

CREATE OR REPLACE PACKAGE BODY PKG_UTIL_PEDIDOS AS

    FUNCTION TotalPedidos
    RETURN NUMBER
    AS
    BEGIN
        RETURN ContarTotalPedidos;
    END TotalPedidos;

    PROCEDURE MostrarTotalPedidos
    AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Total de pedidos registrados: ' || ContarTotalPedidos);
    END MostrarTotalPedidos;

END PKG_UTIL_PEDIDOS;
/

/*====================================================
PAQUETE PKG_UTIL_INVENTARIO
====================================================*/

CREATE OR REPLACE PACKAGE PKG_UTIL_INVENTARIO AS

    FUNCTION ValorInventario
    RETURN NUMBER;

    PROCEDURE MostrarValorInventario;

END PKG_UTIL_INVENTARIO;
/

CREATE OR REPLACE PACKAGE BODY PKG_UTIL_INVENTARIO AS

    FUNCTION ValorInventario
    RETURN NUMBER
    AS
    BEGIN
        RETURN CalcularValorInventario;
    END ValorInventario;

    PROCEDURE MostrarValorInventario
    AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Valor total del inventario: ' || CalcularValorInventario);
    END MostrarValorInventario;

END PKG_UTIL_INVENTARIO;
/

/*====================================================
PAQUETE PKG_UTIL_REPORTES
====================================================*/

CREATE OR REPLACE PACKAGE PKG_UTIL_REPORTES AS

    PROCEDURE MostrarResumenGeneral;

    PROCEDURE MostrarValorInventario;

END PKG_UTIL_REPORTES;
/

CREATE OR REPLACE PACKAGE BODY PKG_UTIL_REPORTES AS

    PROCEDURE MostrarResumenGeneral
    AS
    BEGIN
        ReporteResumenGeneralCursor;
    END MostrarResumenGeneral;

    PROCEDURE MostrarValorInventario
    AS
    BEGIN
        ReporteValorInventarioCursor;
    END MostrarValorInventario;

END PKG_UTIL_REPORTES;
/

/*====================================================
PRUEBA RAPIDA DE OBJETOS COMPLEMENTARIOS
====================================================*/

SET SERVEROUTPUT ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Prueba de objetos complementarios:');

    PKG_UTIL_CLIENTES.MostrarTotalClientes;
    PKG_UTIL_CATEGORIAS.MostrarTotalCategorias;
    PKG_UTIL_PRODUCTOS.MostrarTotalProductos;
    PKG_UTIL_PEDIDOS.MostrarTotalPedidos;
    PKG_UTIL_INVENTARIO.MostrarValorInventario;

    PKG_UTIL_REPORTES.MostrarResumenGeneral;
    PKG_UTIL_REPORTES.MostrarValorInventario;
END;
/