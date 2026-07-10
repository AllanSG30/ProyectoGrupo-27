/*
Proyecto FideStore
Creacion de Triggers
Autor: Jorge Damian Fernandez Delgado
Módulo: Producto e Inventario

Triggers para el control del inventario.
*/


/*====================================================
TRIGGER TRG_ACTUALIZAR_FECHA_INVENTARIO
====================================================*/

CREATE OR REPLACE TRIGGER TRG_ACTUALIZAR_FECHA_INVENTARIO
BEFORE UPDATE ON INVENTARIO
FOR EACH ROW
BEGIN

    :NEW.fecha_actualizacion := SYSDATE;

END;
/

/*====================================================
TRIGGER TRG_VALIDAR_STOCK
====================================================*/

CREATE OR REPLACE TRIGGER TRG_VALIDAR_STOCK
BEFORE INSERT OR UPDATE ON INVENTARIO
FOR EACH ROW
BEGIN

    IF :NEW.cantidad_disponible < 0 THEN
        RAISE_APPLICATION_ERROR
        (
            -20001,
            'La cantidad disponible no puede ser negativa.'
        );
    END IF;

END;
/

/*====================================================
TRIGGER TRG_STOCK_BAJO
====================================================*/

CREATE OR REPLACE TRIGGER TRG_STOCK_BAJO
AFTER INSERT OR UPDATE ON INVENTARIO
FOR EACH ROW
BEGIN

    IF :NEW.cantidad_disponible <= 5 THEN
        DBMS_OUTPUT.PUT_LINE
        (
            'Advertencia: El producto '
            || :NEW.id_producto
            || ' tiene un inventario bajo.'
        );
    END IF;

END;
/