/*
Proyecto FideStore
Creacion de Procedimientos
Autor: Allan Sarmiento Gonzalez
Modulo: Pedido / Detalle_Pedido

Procedimientos CRUD para las tablas PEDIDO y DETALLE_PEDIDO.
Sigue la misma convencion usada por Jorge en Producto/Proveedor/Inventario
(Oracle PL/SQL: NUMBER, VARCHAR2, CREATE OR REPLACE ... AS BEGIN...END; /).

*/

/*====================================================
SECUENCIAS PARA GENERAR ID AUTOMATICO
====================================================*/

CREATE SEQUENCE SEQ_PEDIDO
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE SEQUENCE SEQ_DETALLE_PEDIDO
    START WITH 1
    INCREMENT BY 1
    NOCACHE;


/*====================================================
PROCEDIMIENTO AgregarPedido
====================================================*/

CREATE OR REPLACE PROCEDURE AgregarPedido
(
    p_id_cliente IN NUMBER,
    p_estado IN VARCHAR2,
    p_id_pedido OUT NUMBER
)
AS
BEGIN
    p_id_pedido := SEQ_PEDIDO.NEXTVAL;

    INSERT INTO PEDIDO
    (
        id_pedido,
        id_cliente,
        fecha,
        estado
    )
    VALUES
    (
        p_id_pedido,
        p_id_cliente,
        SYSDATE,
        p_estado
    );
END;
/

/*====================================================
PROCEDIMIENTO ConsultarPedido
====================================================*/

CREATE OR REPLACE PROCEDURE ConsultarPedido
(
    p_id_pedido IN NUMBER,
    p_id_cliente OUT NUMBER,
    p_fecha OUT DATE,
    p_estado OUT VARCHAR2
)
AS
BEGIN
    SELECT
        id_cliente,
        fecha,
        estado
    INTO
        p_id_cliente,
        p_fecha,
        p_estado
    FROM PEDIDO
    WHERE id_pedido = p_id_pedido;
END;
/

/*====================================================
PROCEDIMIENTO ListarPedidosCliente
(devuelve varias filas: en Oracle esto requiere un
REF CURSOR de salida, ya que un procedimiento no
retorna un result set directamente como en MySQL)
====================================================*/

CREATE OR REPLACE PROCEDURE ListarPedidosCliente
(
    p_id_cliente IN NUMBER,
    p_cursor OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_cursor FOR
        SELECT id_pedido, fecha, estado
        FROM PEDIDO
        WHERE id_cliente = p_id_cliente
        ORDER BY fecha DESC;
END;
/

/*====================================================
PROCEDIMIENTO ActualizarEstadoPedido
====================================================*/

CREATE OR REPLACE PROCEDURE ActualizarEstadoPedido
(
    p_id_pedido IN NUMBER,
    p_estado IN VARCHAR2
)
AS
BEGIN
    UPDATE PEDIDO
    SET estado = p_estado
    WHERE id_pedido = p_id_pedido;
END;
/

/*====================================================
PROCEDIMIENTO EliminarPedido
====================================================*/

CREATE OR REPLACE PROCEDURE EliminarPedido
(
    p_id_pedido IN NUMBER
)
AS
BEGIN
    DELETE FROM DETALLE_PEDIDO WHERE id_pedido = p_id_pedido;
    DELETE FROM PEDIDO WHERE id_pedido = p_id_pedido;
END;
/


/*====================================================
PROCEDIMIENTO AgregarDetallePedido
Reutiliza la funcion ObtenerPrecioProducto que ya
programo Jorge, en lugar de duplicar esa logica.
====================================================*/

CREATE OR REPLACE PROCEDURE AgregarDetallePedido
(
    p_id_pedido IN NUMBER,
    p_id_producto IN NUMBER,
    p_cantidad IN NUMBER,
    p_id_detalle OUT NUMBER
)
AS
    v_precio NUMBER;
BEGIN
    v_precio := ObtenerPrecioProducto(p_id_producto);

    p_id_detalle := SEQ_DETALLE_PEDIDO.NEXTVAL;

    INSERT INTO DETALLE_PEDIDO
    (
        id_detalle,
        id_pedido,
        id_producto,
        cantidad,
        precio_unitario
    )
    VALUES
    (
        p_id_detalle,
        p_id_pedido,
        p_id_producto,
        p_cantidad,
        v_precio
    );
    -- La validacion de stock y el descuento de inventario
    -- los hacen los triggers de triggers_pedidos.sql
END;
/

/*====================================================
PROCEDIMIENTO ConsultarDetallePedido
====================================================*/

CREATE OR REPLACE PROCEDURE ConsultarDetallePedido
(
    p_id_detalle IN NUMBER,
    p_id_pedido OUT NUMBER,
    p_id_producto OUT NUMBER,
    p_cantidad OUT NUMBER,
    p_precio_unitario OUT NUMBER
)
AS
BEGIN
    SELECT
        id_pedido,
        id_producto,
        cantidad,
        precio_unitario
    INTO
        p_id_pedido,
        p_id_producto,
        p_cantidad,
        p_precio_unitario
    FROM DETALLE_PEDIDO
    WHERE id_detalle = p_id_detalle;
END;
/

/*====================================================
PROCEDIMIENTO ListarDetallePedido
====================================================*/

CREATE OR REPLACE PROCEDURE ListarDetallePedido
(
    p_id_pedido IN NUMBER,
    p_cursor OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_cursor FOR
        SELECT
            dp.id_detalle,
            dp.id_producto,
            pr.nombre_producto,
            dp.cantidad,
            dp.precio_unitario,
            (dp.cantidad * dp.precio_unitario) AS subtotal
        FROM DETALLE_PEDIDO dp
        INNER JOIN PRODUCTO pr ON pr.id_producto = dp.id_producto
        WHERE dp.id_pedido = p_id_pedido;
END;
/

/*====================================================
PROCEDIMIENTO ActualizarDetallePedido
====================================================*/

CREATE OR REPLACE PROCEDURE ActualizarDetallePedido
(
    p_id_detalle IN NUMBER,
    p_cantidad IN NUMBER
)
AS
BEGIN
    UPDATE DETALLE_PEDIDO
    SET cantidad = p_cantidad
    WHERE id_detalle = p_id_detalle;
END;
/

/*====================================================
PROCEDIMIENTO EliminarDetallePedido
====================================================*/

CREATE OR REPLACE PROCEDURE EliminarDetallePedido
(
    p_id_detalle IN NUMBER
)
AS
BEGIN
    DELETE FROM DETALLE_PEDIDO
    WHERE id_detalle = p_id_detalle;
END;
/
