"""
Capa de acceso a datos para Pedido y Detalle_Pedido.

IMPORTANTE: ninguna funcion de este archivo escribe una consulta SQL
directa. Todo se resuelve llamando a los procedimientos almacenados
de procedimientos_pedidos.sql mediante cursor.callproc().

"""

import oracledb
from conexion import obtener_conexion


# ---------------------------------------------------------------------
# PEDIDO
# ---------------------------------------------------------------------
def pedido_crear(id_cliente, estado="PENDIENTE"):
    """Crea un pedido y retorna el id generado por la secuencia SEQ_PEDIDO."""
    conexion = obtener_conexion()
    cursor = conexion.cursor()
    id_pedido_var = cursor.var(oracledb.NUMBER)

    cursor.callproc("AgregarPedido", [id_cliente, estado, id_pedido_var])
    conexion.commit()

    id_pedido = int(id_pedido_var.getvalue())
    cursor.close()
    conexion.close()
    return id_pedido


def pedido_consultar(id_pedido):
    conexion = obtener_conexion()
    cursor = conexion.cursor()

    v_id_cliente = cursor.var(oracledb.NUMBER)
    v_fecha = cursor.var(oracledb.DATETIME)
    v_estado = cursor.var(str)

    cursor.callproc("ConsultarPedido", [id_pedido, v_id_cliente, v_fecha, v_estado])

    resultado = {
        "id_pedido": id_pedido,
        "id_cliente": v_id_cliente.getvalue(),
        "fecha": v_fecha.getvalue(),
        "estado": v_estado.getvalue(),
    }
    cursor.close()
    conexion.close()
    return resultado


def pedidos_listar_cliente(id_cliente):
    conexion = obtener_conexion()
    cursor = conexion.cursor()
    ref_cursor = conexion.cursor()  # este cursor se usa como el REF CURSOR de salida

    cursor.callproc("ListarPedidosCliente", [id_cliente, ref_cursor])
    filas = ref_cursor.fetchall()

    cursor.close()
    ref_cursor.close()
    conexion.close()
    return filas


def pedido_actualizar_estado(id_pedido, estado):
    """El cambio queda registrado automaticamente por TRG_AUDITORIA_ESTADO_PEDIDO."""
    conexion = obtener_conexion()
    cursor = conexion.cursor()
    cursor.callproc("ActualizarEstadoPedido", [id_pedido, estado])
    conexion.commit()
    cursor.close()
    conexion.close()


def pedido_eliminar(id_pedido):
    conexion = obtener_conexion()
    cursor = conexion.cursor()
    cursor.callproc("EliminarPedido", [id_pedido])
    conexion.commit()
    cursor.close()
    conexion.close()


# ---------------------------------------------------------------------
# DETALLE_PEDIDO
# ---------------------------------------------------------------------
def detalle_agregar(id_pedido, id_producto, cantidad):
    """
    Agrega una linea de producto a un pedido.
    TRG_VALIDAR_STOCK_PEDIDO puede rechazar el INSERT si no hay stock
    (lanza ORA-20002); TRG_DESCONTAR_INVENTARIO_PEDIDO descuenta el
    inventario automaticamente si la insercion sí se realiza.
    """
    conexion = obtener_conexion()
    cursor = conexion.cursor()
    id_detalle_var = cursor.var(oracledb.NUMBER)

    try:
        cursor.callproc(
            "AgregarDetallePedido",
            [id_pedido, id_producto, cantidad, id_detalle_var],
        )
        conexion.commit()
        return int(id_detalle_var.getvalue())
    except oracledb.DatabaseError as error:
        conexion.rollback()
        raise error
    finally:
        cursor.close()
        conexion.close()


def detalle_listar(id_pedido):
    conexion = obtener_conexion()
    cursor = conexion.cursor()
    ref_cursor = conexion.cursor()  # este cursor se usa como el REF CURSOR de salida

    cursor.callproc("ListarDetallePedido", [id_pedido, ref_cursor])
    filas = ref_cursor.fetchall()

    cursor.close()
    ref_cursor.close()
    conexion.close()
    return filas


def detalle_actualizar(id_detalle, cantidad):
    conexion = obtener_conexion()
    cursor = conexion.cursor()
    cursor.callproc("ActualizarDetallePedido", [id_detalle, cantidad])
    conexion.commit()
    cursor.close()
    conexion.close()


def detalle_eliminar(id_detalle):
    conexion = obtener_conexion()
    cursor = conexion.cursor()
    cursor.callproc("EliminarDetallePedido", [id_detalle])
    conexion.commit()
    cursor.close()
    conexion.close()


# ---------------------------------------------------------------------
# REPORTES CON CURSOR (cursores_pedidos.sql)
# ---------------------------------------------------------------------
def pedido_total(id_pedido):
    conexion = obtener_conexion()
    cursor = conexion.cursor()
    total_var = cursor.var(oracledb.NUMBER)

    cursor.callproc("CalcularTotalPedido", [id_pedido, total_var])

    total = total_var.getvalue()
    cursor.close()
    conexion.close()
    return total


def pedido_verificar_stock(id_pedido):
    """Retorna True si hay stock suficiente para todas las lineas del pedido."""
    conexion = obtener_conexion()
    cursor = conexion.cursor()
    ok_var = cursor.var(oracledb.NUMBER)

    cursor.callproc("VerificarStockPedido", [id_pedido, ok_var])

    resultado = ok_var.getvalue() == 1
    cursor.close()
    conexion.close()
    return resultado


def resumen_pedidos_cliente(id_cliente):
    conexion = obtener_conexion()
    cursor = conexion.cursor()
    total_pedidos_var = cursor.var(oracledb.NUMBER)
    total_gastado_var = cursor.var(oracledb.NUMBER)

    cursor.callproc(
        "ResumenPedidosCliente",
        [id_cliente, total_pedidos_var, total_gastado_var],
    )

    resultado = {
        "total_pedidos": total_pedidos_var.getvalue(),
        "total_gastado": total_gastado_var.getvalue(),
    }
    cursor.close()
    conexion.close()
    return resultado
