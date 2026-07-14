/*
    Proyecto: FideStore
    Curso: Lenguajes de Base de Datos
    Integrante: Andrey Corrales
    Archivo: vistas_cliente_direccion_categoria.sql
    Descripción:
    Vistas para consultar información relacionada con clientes, direcciones
    y categorías dentro del sistema FideStore.

    Tablas relacionadas:
    CLIENTE
    DIRECCION
    CATEGORIA
    PRODUCTO
    PEDIDO
*/

/*====================================================
VISTA VistaClientes
====================================================*/

CREATE OR REPLACE VIEW VistaClientes AS
SELECT
    id_cliente,
    nombre,
    correo,
    telefono
FROM CLIENTE;


/*====================================================
VISTA VistaDirecciones
====================================================*/

CREATE OR REPLACE VIEW VistaDirecciones AS
SELECT
    id_direccion,
    id_cliente,
    direccion
FROM DIRECCION;


/*====================================================
VISTA VistaClientesDirecciones
====================================================*/

CREATE OR REPLACE VIEW VistaClientesDirecciones AS
SELECT
    c.id_cliente,
    c.nombre,
    c.correo,
    c.telefono,
    d.id_direccion,
    d.direccion
FROM CLIENTE c
LEFT JOIN DIRECCION d
    ON c.id_cliente = d.id_cliente;


/*====================================================
VISTA VistaCategorias
====================================================*/

CREATE OR REPLACE VIEW VistaCategorias AS
SELECT
    id_categoria,
    nombre_categoria
FROM CATEGORIA;


/*====================================================
VISTA VistaCategoriasCantidadProductos
====================================================*/

CREATE OR REPLACE VIEW VistaCategoriasCantidadProductos AS
SELECT
    c.id_categoria,
    c.nombre_categoria,
    COUNT(p.id_producto) AS cantidad_productos
FROM CATEGORIA c
LEFT JOIN PRODUCTO p
    ON c.id_categoria = p.id_categoria
GROUP BY
    c.id_categoria,
    c.nombre_categoria;


/*====================================================
VISTA VistaClientesPedidosResumen
====================================================*/

CREATE OR REPLACE VIEW VistaClientesPedidosResumen AS
SELECT
    c.id_cliente,
    c.nombre,
    c.correo,
    COUNT(p.id_pedido) AS cantidad_pedidos,
    MAX(p.fecha) AS fecha_ultimo_pedido
FROM CLIENTE c
LEFT JOIN PEDIDO p
    ON c.id_cliente = p.id_cliente
GROUP BY
    c.id_cliente,
    c.nombre,
    c.correo;