/*
Proyecto FideStore
Creacion de Tablas
Autor: Jorge Damian Fernandez Delgado

Descripción:
Creación de todas las tablas del modelo relacional de FideStore.
Este script únicamente crea la estructura de la base de datos.
CATEGORIA
CLIENTE
PROVEEDOR
PRODUCTO
DIRECCION
INVENTARIO
PEDIDO
PRODUCTO_PROVEEDOR
DETALLE_PEDIDO

Script: 00_creacion_tablas.sql
/*


/*====================================================
TABLA CATEGORIA
====================================================*/

CREATE TABLE CATEGORIA
(
    id_categoria NUMBER PRIMARY KEY,
    nombre_categoria VARCHAR2(100) NOT NULL
);

/*====================================================
TABLA CLIENTE
====================================================*/

CREATE TABLE CLIENTE
(
    id_cliente NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    correo VARCHAR2(100) NOT NULL,
    telefono VARCHAR2(20)
);

/*====================================================
TABLA PROVEEDOR
====================================================*/

CREATE TABLE PROVEEDOR
(
    id_proveedor NUMBER PRIMARY KEY,
    nombre_proveedor VARCHAR2(100) NOT NULL,
    contacto VARCHAR2(100)
);

/*====================================================
TABLA PRODUCTO
====================================================*/

CREATE TABLE PRODUCTO
(
    id_producto NUMBER PRIMARY KEY,
    id_categoria NUMBER NOT NULL,
    nombre_producto VARCHAR2(150) NOT NULL,
    precio NUMBER(10,2) NOT NULL
        CHECK (precio >= 0),

    CONSTRAINT fk_producto_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES CATEGORIA(id_categoria)
);

/*====================================================
TABLA DIRECCION
====================================================*/


CREATE TABLE DIRECCION
(
    id_direccion NUMBER PRIMARY KEY,
    id_cliente NUMBER NOT NULL,
    direccion VARCHAR2(250) NOT NULL,

    CONSTRAINT fk_direccion_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES CLIENTE(id_cliente)
);

/*====================================================
TABLA INVENTARIO
====================================================*/

CREATE TABLE INVENTARIO
(
    id_inventario NUMBER PRIMARY KEY,
    id_producto NUMBER NOT NULL,
    cantidad_disponible NUMBER NOT NULL
        CHECK (cantidad_disponible >= 0),
    fecha_actualizacion DATE NOT NULL,

    CONSTRAINT fk_inventario_producto
        FOREIGN KEY (id_producto)
        REFERENCES PRODUCTO(id_producto)
);

/*====================================================
TABLA PEDIDO
====================================================*/

CREATE TABLE PEDIDO
(
    id_pedido NUMBER PRIMARY KEY,
    id_cliente NUMBER NOT NULL,
    fecha DATE NOT NULL,
    estado VARCHAR2(50) NOT NULL,

    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES CLIENTE(id_cliente)
);


/*====================================================
TABLA PRODUCTO_PROVEEDOR
====================================================*/

CREATE TABLE PRODUCTO_PROVEEDOR
(
    id_producto NUMBER NOT NULL,
    id_proveedor NUMBER NOT NULL,

    CONSTRAINT pk_producto_proveedor
        PRIMARY KEY (id_producto, id_proveedor),

    CONSTRAINT fk_pp_producto
        FOREIGN KEY (id_producto)
        REFERENCES PRODUCTO(id_producto),

    CONSTRAINT fk_pp_proveedor
        FOREIGN KEY (id_proveedor)
        REFERENCES PROVEEDOR(id_proveedor)
);


/*====================================================
TABLA DETALLE_PEDIDO
====================================================*/

CREATE TABLE DETALLE_PEDIDO
(
    id_detalle NUMBER PRIMARY KEY,
    id_pedido NUMBER NOT NULL,
    id_producto NUMBER NOT NULL,
    cantidad NUMBER NOT NULL
        CHECK (cantidad > 0),
    precio_unitario NUMBER(10,2) NOT NULL
        CHECK (precio_unitario >= 0),

    CONSTRAINT fk_detalle_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES PEDIDO(id_pedido),

    CONSTRAINT fk_detalle_producto
        FOREIGN KEY (id_producto)
        REFERENCES PRODUCTO(id_producto)
);

