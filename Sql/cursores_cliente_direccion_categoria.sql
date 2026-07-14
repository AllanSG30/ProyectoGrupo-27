/*
    Proyecto: FideStore
    Curso: Lenguajes de Base de Datos
    Integrante: Andrey Corrales
    Archivo: cursores_cliente_direccion_categoria.sql
    Descripción:
    Procedimientos con cursores explícitos para recorrer información de clientes,
    direcciones y categorías dentro del sistema FideStore.

    Tablas relacionadas:
    CLIENTE
    DIRECCION
    CATEGORIA
    PRODUCTO
    PEDIDO

    Nota:
    Estos procedimientos utilizan cursores explícitos para recorrer registros
    y mostrar información mediante DBMS_OUTPUT.
*/

SET SERVEROUTPUT ON;

/*====================================================
PROCEDIMIENTO ListarClientesCursor
====================================================*/

CREATE OR REPLACE PROCEDURE ListarClientesCursor
AS
    CURSOR c_clientes IS
        SELECT
            id_cliente,
            nombre,
            correo,
            telefono
        FROM CLIENTE
        ORDER BY id_cliente;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Listado de clientes registrados:');

    FOR fila IN c_clientes LOOP
        DBMS_OUTPUT.PUT_LINE
        (
            'ID: ' || fila.id_cliente
            || ' | Nombre: ' || fila.nombre
            || ' | Correo: ' || fila.correo
            || ' | Telefono: ' || NVL(fila.telefono, 'No registrado')
        );
    END LOOP;
END;
/

/*====================================================
PROCEDIMIENTO ListarDireccionesPorClienteCursor
====================================================*/

CREATE OR REPLACE PROCEDURE ListarDireccionesPorClienteCursor
(
    p_id_cliente IN CLIENTE.id_cliente%TYPE
)
AS
    CURSOR c_direcciones IS
        SELECT
            id_direccion,
            direccion
        FROM DIRECCION
        WHERE id_cliente = p_id_cliente
        ORDER BY id_direccion;

    v_total NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Direcciones registradas para el cliente: ' || p_id_cliente);

    FOR fila IN c_direcciones LOOP
        v_total := v_total + 1;

        DBMS_OUTPUT.PUT_LINE
        (
            'ID Direccion: ' || fila.id_direccion
            || ' | Direccion: ' || fila.direccion
        );
    END LOOP;

    IF v_total = 0 THEN
        DBMS_OUTPUT.PUT_LINE('El cliente no tiene direcciones registradas.');
    END IF;
END;
/

/*====================================================
PROCEDIMIENTO ListarCategoriasCursor
====================================================*/

CREATE OR REPLACE PROCEDURE ListarCategoriasCursor
AS
    CURSOR c_categorias IS
        SELECT
            id_categoria,
            nombre_categoria
        FROM CATEGORIA
        ORDER BY id_categoria;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Listado de categorias registradas:');

    FOR fila IN c_categorias LOOP
        DBMS_OUTPUT.PUT_LINE
        (
            'ID: ' || fila.id_categoria
            || ' | Categoria: ' || fila.nombre_categoria
        );
    END LOOP;
END;
/

/*====================================================
PROCEDIMIENTO ListarCategoriasConProductosCursor
====================================================*/

CREATE OR REPLACE PROCEDURE ListarCategoriasConProductosCursor
AS
    CURSOR c_categorias_productos IS
        SELECT
            c.id_categoria,
            c.nombre_categoria,
            COUNT(p.id_producto) AS cantidad_productos
        FROM CATEGORIA c
        LEFT JOIN PRODUCTO p
            ON c.id_categoria = p.id_categoria
        GROUP BY
            c.id_categoria,
            c.nombre_categoria
        ORDER BY
            c.id_categoria;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Categorias y cantidad de productos asociados:');

    FOR fila IN c_categorias_productos LOOP
        DBMS_OUTPUT.PUT_LINE
        (
            'ID: ' || fila.id_categoria
            || ' | Categoria: ' || fila.nombre_categoria
            || ' | Productos asociados: ' || fila.cantidad_productos
        );
    END LOOP;
END;
/

/*====================================================
PROCEDIMIENTO ListarClientesSinDireccionCursor
====================================================*/

CREATE OR REPLACE PROCEDURE ListarClientesSinDireccionCursor
AS
    CURSOR c_clientes_sin_direccion IS
        SELECT
            c.id_cliente,
            c.nombre,
            c.correo
        FROM CLIENTE c
        LEFT JOIN DIRECCION d
            ON c.id_cliente = d.id_cliente
        WHERE d.id_direccion IS NULL
        ORDER BY c.id_cliente;

    v_total NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Clientes sin direccion registrada:');

    FOR fila IN c_clientes_sin_direccion LOOP
        v_total := v_total + 1;

        DBMS_OUTPUT.PUT_LINE
        (
            'ID: ' || fila.id_cliente
            || ' | Nombre: ' || fila.nombre
            || ' | Correo: ' || fila.correo
        );
    END LOOP;

    IF v_total = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Todos los clientes tienen al menos una direccion registrada.');
    END IF;
END;
/

/*====================================================
PROCEDIMIENTO ContarClientesConCursor
====================================================*/

CREATE OR REPLACE PROCEDURE ContarClientesConCursor
(
    p_total_clientes OUT NUMBER
)
AS
    CURSOR c_clientes IS
        SELECT id_cliente
        FROM CLIENTE;

BEGIN
    p_total_clientes := 0;

    FOR fila IN c_clientes LOOP
        p_total_clientes := p_total_clientes + 1;
    END LOOP;
END;
/

/*====================================================
PROCEDIMIENTO ReporteClientesPedidosCursor
====================================================*/

CREATE OR REPLACE PROCEDURE ReporteClientesPedidosCursor
AS
    CURSOR c_clientes_pedidos IS
        SELECT
            c.id_cliente,
            c.nombre,
            COUNT(p.id_pedido) AS cantidad_pedidos
        FROM CLIENTE c
        LEFT JOIN PEDIDO p
            ON c.id_cliente = p.id_cliente
        GROUP BY
            c.id_cliente,
            c.nombre
        ORDER BY
            c.id_cliente;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Reporte de clientes y cantidad de pedidos:');

    FOR fila IN c_clientes_pedidos LOOP
        DBMS_OUTPUT.PUT_LINE
        (
            'ID Cliente: ' || fila.id_cliente
            || ' | Nombre: ' || fila.nombre
            || ' | Cantidad de pedidos: ' || fila.cantidad_pedidos
        );
    END LOOP;
END;
/