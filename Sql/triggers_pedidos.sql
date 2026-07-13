/*
Proyecto FideStore
Creacion de Triggers
Autor: Allan Sarmiento Gonzalez
Modulo: Pedido / Detalle_Pedido

Triggers para el flujo de venta: validan stock antes de vender,
descuentan inventario automaticamente y auditan cambios de estado.
*/

/*====================================================
TABLA AUDITORIA_PEDIDO
(tabla auxiliar nueva, necesaria para el trigger de
auditoria de estado. No choca con ninguna tabla de
Jorge ni de Andrey.)
====================================================*/

CREATE TABLE AUDITORIA_PEDIDO
(
    id_auditoria NUMBER PRIMARY KEY,
    id_pedido NUMBER NOT NULL,
    estado_anterior VARCHAR2(50),
    estado_nuevo VARCHAR2(50),
    fecha_cambio DATE DEFAULT SYSDATE,

    CONSTRAINT fk_auditoria_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES PEDIDO(id_pedido)
);

CREATE SEQUENCE SEQ_AUDITORIA_PEDIDO
    START WITH 1
    INCREMENT BY 1
    NOCACHE;


/*====================================================
TRIGGER TRG_VALIDAR_STOCK_PEDIDO
Antes de insertar una linea de detalle, verifica que
haya inventario suficiente. Si no lo hay, rechaza la
operacion (RAISE_APPLICATION_ERROR revierte el INSERT).
====================================================*/

CREATE OR REPLACE TRIGGER TRG_VALIDAR_STOCK_PEDIDO
BEFORE INSERT ON DETALLE_PEDIDO
FOR EACH ROW
DECLARE
    v_stock NUMBER;
BEGIN
    SELECT cantidad_disponible
    INTO v_stock
    FROM INVENTARIO
    WHERE id_producto = :NEW.id_producto;

    IF v_stock < :NEW.cantidad THEN
        RAISE_APPLICATION_ERROR
        (
            -20002,
            'Stock insuficiente para completar la venta.'
        );
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR
        (
            -20003,
            'El producto no tiene registro de inventario.'
        );
END;
/

/*====================================================
TRIGGER TRG_DESCONTAR_INVENTARIO_PEDIDO
Despues de insertar una linea de detalle (ya validada
por el trigger anterior), descuenta el inventario.
====================================================*/

CREATE OR REPLACE TRIGGER TRG_DESCONTAR_INVENTARIO_PEDIDO
AFTER INSERT ON DETALLE_PEDIDO
FOR EACH ROW
BEGIN
    UPDATE INVENTARIO
    SET
        cantidad_disponible = cantidad_disponible - :NEW.cantidad,
        fecha_actualizacion = SYSDATE
    WHERE id_producto = :NEW.id_producto;
END;
/

/*====================================================
TRIGGER TRG_AUDITORIA_ESTADO_PEDIDO
Registra en AUDITORIA_PEDIDO cada vez que cambia el
estado de un pedido (ej. PENDIENTE -> ENVIADO).
====================================================*/

CREATE OR REPLACE TRIGGER TRG_AUDITORIA_ESTADO_PEDIDO
AFTER UPDATE OF estado ON PEDIDO
FOR EACH ROW
WHEN (NEW.estado <> OLD.estado)
BEGIN
    INSERT INTO AUDITORIA_PEDIDO
    (
        id_auditoria,
        id_pedido,
        estado_anterior,
        estado_nuevo,
        fecha_cambio
    )
    VALUES
    (
        SEQ_AUDITORIA_PEDIDO.NEXTVAL,
        :NEW.id_pedido,
        :OLD.estado,
        :NEW.estado,
        SYSDATE
    );
END;
/
