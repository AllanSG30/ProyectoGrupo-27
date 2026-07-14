/*
Proyecto FideStore
Creacion de Procedimientos con Cursores
Autor: Allan Sarmiento Gonzalez
Modulo: Pedido / Detalle_Pedido

Procedimientos que usan cursores explicitos (DECLARE CURSOR / OPEN /
FETCH / CLOSE, o su forma abreviada FOR..IN..LOOP) para recorrer
filas de Pedido y Detalle_Pedido.
*/

/*====================================================
PROCEDIMIENTO CalcularTotalPedido
Recorre linea por linea el detalle de un pedido y
acumula el total (cursor explicito clasico).
====================================================*/

CREATE OR REPLACE PROCEDURE CalcularTotalPedido
(
    p_id_pedido IN NUMBER,
    p_total OUT NUMBER
)
AS
    CURSOR c_detalle IS
        SELECT cantidad, precio_unitario
        FROM DETALLE_PEDIDO
        WHERE id_pedido = p_id_pedido;

    v_cantidad NUMBER;
    v_precio NUMBER;
BEGIN
    p_total := 0;

    OPEN c_detalle;
    LOOP
        FETCH c_detalle INTO v_cantidad, v_precio;
        EXIT WHEN c_detalle%NOTFOUND;

        p_total := p_total + (v_cantidad * v_precio);
    END LOOP;
    CLOSE c_detalle;
END;
/

/*====================================================
PROCEDIMIENTO ContarLineasPedido
Cuenta cuantas lineas de producto tiene un pedido
(cursor FOR..IN..LOOP, forma abreviada del cursor
explicito: Oracle abre y cierra el cursor solo).
====================================================*/

CREATE OR REPLACE PROCEDURE ContarLineasPedido
(
    p_id_pedido IN NUMBER,
    p_cantidad_lineas OUT NUMBER
)
AS
    CURSOR c_detalle IS
        SELECT id_detalle
        FROM DETALLE_PEDIDO
        WHERE id_pedido = p_id_pedido;
BEGIN
    p_cantidad_lineas := 0;

    FOR fila IN c_detalle LOOP
        p_cantidad_lineas := p_cantidad_lineas + 1;
    END LOOP;
END;
/

/*====================================================
PROCEDIMIENTO VerificarStockPedido
Recorre cada linea del pedido y usa la funcion
ObtenerStockProducto (de Jorge) para revisar si hay
existencias suficientes antes de confirmar la venta.
====================================================*/

CREATE OR REPLACE PROCEDURE VerificarStockPedido
(
    p_id_pedido IN NUMBER,
    p_todo_ok OUT NUMBER  -- 1 = hay stock para todas las lineas, 0 = falta stock
)
AS
    CURSOR c_detalle IS
        SELECT id_producto, cantidad
        FROM DETALLE_PEDIDO
        WHERE id_pedido = p_id_pedido;

    v_stock NUMBER;
BEGIN
    p_todo_ok := 1;

    FOR fila IN c_detalle LOOP
        v_stock := ObtenerStockProducto(fila.id_producto);

        IF v_stock < fila.cantidad THEN
            p_todo_ok := 0;
        END IF;
    END LOOP;
END;
/

/*====================================================
PROCEDIMIENTO ReporteDetallePedido
Recorre el detalle de un pedido e imprime un reporte
linea por linea (mismo estilo DBMS_OUTPUT que usa
Jorge en TRG_STOCK_BAJO).
====================================================*/

CREATE OR REPLACE PROCEDURE ReporteDetallePedido
(
    p_id_pedido IN NUMBER
)
AS
    CURSOR c_detalle IS
        SELECT pr.nombre_producto, dp.cantidad, dp.precio_unitario
        FROM DETALLE_PEDIDO dp
        INNER JOIN PRODUCTO pr ON pr.id_producto = dp.id_producto
        WHERE dp.id_pedido = p_id_pedido;
BEGIN
    FOR fila IN c_detalle LOOP
        DBMS_OUTPUT.PUT_LINE
        (
            fila.nombre_producto
            || ' - Cant: ' || fila.cantidad
            || ' - Subtotal: ' || (fila.cantidad * fila.precio_unitario)
        );
    END LOOP;
END;
/

/*====================================================
PROCEDIMIENTO ResumenPedidosCliente
Recorre todos los pedidos de un cliente y, apoyandose
en CalcularTotalPedido, acumula cuantos pedidos ha
hecho y cuanto ha gastado en total.
====================================================*/

CREATE OR REPLACE PROCEDURE ResumenPedidosCliente
(
    p_id_cliente IN NUMBER,
    p_total_pedidos OUT NUMBER,
    p_total_gastado OUT NUMBER
)
AS
    CURSOR c_pedidos IS
        SELECT id_pedido
        FROM PEDIDO
        WHERE id_cliente = p_id_cliente;

    v_total_linea NUMBER;
BEGIN
    p_total_pedidos := 0;
    p_total_gastado := 0;

    FOR fila IN c_pedidos LOOP
        p_total_pedidos := p_total_pedidos + 1;

        CalcularTotalPedido(fila.id_pedido, v_total_linea);
        p_total_gastado := p_total_gastado + v_total_linea;
    END LOOP;
END;
/
