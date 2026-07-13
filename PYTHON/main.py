"""
Menu basico para probar FideStore desde consola.

Requiere que ya existan datos previos cargados por los otros modulos:
- Un cliente 
- Un producto con inventario (tablas PRODUCTO/INVENTARIO)

Antes de correr este menu, cargar en este orden:
    1. Sql/creacion_tablas.sql            
    2. Sql/procedimientos_producto.sql    
    3. Sql/procedimientos_proveedor.sql   
    4. Sql/funciones_producto_inventario.sql 
    5. Sql/vistas_producto_inventario.sql 
    6. Sql/triggers_inventario.sql        
    7. Sql/procedimientos_pedidos.sql     
    8. Sql/triggers_pedidos.sql           
    9. Sql/cursores_pedidos.sql           
   10. procedimientos de Cliente/Direccion/Categoria 
"""

from pedidos import (
    pedido_crear,
    pedido_consultar,
    pedidos_listar_cliente,
    pedido_actualizar_estado,
    detalle_agregar,
    detalle_listar,
    pedido_total,
    pedido_verificar_stock,
    resumen_pedidos_cliente,
)


def menu():
    print("=== FideStore - Prueba de Pedidos ===")
    print("1. Crear pedido")
    print("2. Agregar producto a un pedido")
    print("3. Ver detalle y total de un pedido")
    print("4. Cambiar estado de un pedido")
    print("5. Ver pedidos de un cliente + resumen de gasto")
    print("0. Salir")


def main():
    id_pedido_actual = None

    while True:
        menu()
        opcion = input("Elija una opcion: ").strip()

        if opcion == "1":
            id_cliente = int(input("ID del cliente: "))
            id_pedido_actual = pedido_crear(id_cliente)
            print(f"Pedido creado con id {id_pedido_actual}")

        elif opcion == "2":
            if id_pedido_actual is None:
                print("Primero cree un pedido (opcion 1).")
                continue
            id_producto = int(input("ID del producto: "))
            cantidad = int(input("Cantidad: "))
            try:
                id_detalle = detalle_agregar(id_pedido_actual, id_producto, cantidad)
                print(f"Linea agregada (id_detalle={id_detalle})")
            except Exception as error:
                # Aqui llega, por ejemplo, el error ORA-20002 del trigger
                # de validacion de stock si no hay suficiente inventario.
                print(f"No se pudo agregar la linea: {error}")

        elif opcion == "3":
            id_pedido = int(input("ID del pedido a consultar: "))
            print(pedido_consultar(id_pedido))
            print("Detalle:")
            for fila in detalle_listar(id_pedido):
                print("  ", fila)
            print("Stock suficiente para todo el pedido:",
                  pedido_verificar_stock(id_pedido))
            print("Total del pedido:", pedido_total(id_pedido))

        elif opcion == "4":
            id_pedido = int(input("ID del pedido: "))
            nuevo_estado = input(
                "Nuevo estado (PENDIENTE/PROCESADO/ENVIADO/ENTREGADO/CANCELADO): "
            ).strip().upper()
            pedido_actualizar_estado(id_pedido, nuevo_estado)
            print("Estado actualizado.")

        elif opcion == "5":
            id_cliente = int(input("ID del cliente: "))
            print("Pedidos del cliente:")
            for fila in pedidos_listar_cliente(id_cliente):
                print("  ", fila)
            print("Resumen:", resumen_pedidos_cliente(id_cliente))

        elif opcion == "0":
            print("Saliendo...")
            break

        else:
            print("Opcion invalida.")


if __name__ == "__main__":
    main()
