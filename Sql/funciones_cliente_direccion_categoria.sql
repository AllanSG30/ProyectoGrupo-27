/*
    Proyecto: FideStore
    Curso: Lenguajes de Base de Datos
    Integrante: Andrey Corrales
    Archivo: funciones_cliente_direccion_categoria.sql
    Descripción:
    Funciones PL/SQL para validaciones y consultas relacionadas con clientes,
    direcciones y categorías.

    Tablas relacionadas:
    CLIENTE
    DIRECCION
    CATEGORIA
    PRODUCTO

    Nota:
    Estas funciones permiten reutilizar lógica de consulta y validación desde
    procedimientos almacenados, paquetes o desde la aplicación principal.
*/

/*====================================================
FUNCION ExisteCliente
====================================================*/

CREATE OR REPLACE FUNCTION ExisteCliente
(
    p_id_cliente IN CLIENTE.id_cliente%TYPE
)
RETURN NUMBER
AS
    v_total NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_total
    FROM CLIENTE
    WHERE id_cliente = p_id_cliente;

    IF v_total > 0 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END;
/

/*====================================================
FUNCION ExisteCategoria
====================================================*/

CREATE OR REPLACE FUNCTION ExisteCategoria
(
    p_id_categoria IN CATEGORIA.id_categoria%TYPE
)
RETURN NUMBER
AS
    v_total NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_total
    FROM CATEGORIA
    WHERE id_categoria = p_id_categoria;

    IF v_total > 0 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END;
/

/*====================================================
FUNCION ExisteDireccion
====================================================*/

CREATE OR REPLACE FUNCTION ExisteDireccion
(
    p_id_direccion IN DIRECCION.id_direccion%TYPE
)
RETURN NUMBER
AS
    v_total NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_total
    FROM DIRECCION
    WHERE id_direccion = p_id_direccion;

    IF v_total > 0 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END;
/

/*====================================================
FUNCION ValidarFormatoCorreo
====================================================*/

CREATE OR REPLACE FUNCTION ValidarFormatoCorreo
(
    p_correo IN CLIENTE.correo%TYPE
)
RETURN NUMBER
AS
    v_pos_arroba NUMBER;
    v_pos_punto  NUMBER;
BEGIN
    IF p_correo IS NULL THEN
        RETURN 0;
    END IF;

    v_pos_arroba := INSTR(TRIM(p_correo), '@');
    v_pos_punto := INSTR(TRIM(p_correo), '.', v_pos_arroba + 2);

    IF v_pos_arroba > 1
       AND v_pos_punto > v_pos_arroba + 1
       AND v_pos_punto < LENGTH(TRIM(p_correo))
       AND LENGTH(TRIM(p_correo)) >= 6 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END;
/

/*====================================================
FUNCION ObtenerNombreCliente
====================================================*/

CREATE OR REPLACE FUNCTION ObtenerNombreCliente
(
    p_id_cliente IN CLIENTE.id_cliente%TYPE
)
RETURN VARCHAR2
AS
    v_nombre CLIENTE.nombre%TYPE;
BEGIN
    SELECT nombre
    INTO v_nombre
    FROM CLIENTE
    WHERE id_cliente = p_id_cliente;

    RETURN v_nombre;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR
        (
            -20040,
            'No se encontró un cliente con el identificador indicado.'
        );
END;
/

/*====================================================
FUNCION ObtenerCorreoCliente
====================================================*/

CREATE OR REPLACE FUNCTION ObtenerCorreoCliente
(
    p_id_cliente IN CLIENTE.id_cliente%TYPE
)
RETURN VARCHAR2
AS
    v_correo CLIENTE.correo%TYPE;
BEGIN
    SELECT correo
    INTO v_correo
    FROM CLIENTE
    WHERE id_cliente = p_id_cliente;

    RETURN v_correo;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR
        (
            -20041,
            'No se encontró un correo para el cliente indicado.'
        );
END;
/

/*====================================================
FUNCION ContarDireccionesCliente
====================================================*/

CREATE OR REPLACE FUNCTION ContarDireccionesCliente
(
    p_id_cliente IN CLIENTE.id_cliente%TYPE
)
RETURN NUMBER
AS
    v_total NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_total
    FROM DIRECCION
    WHERE id_cliente = p_id_cliente;

    RETURN v_total;
END;
/

/*====================================================
FUNCION ContarProductosPorCategoria
====================================================*/

CREATE OR REPLACE FUNCTION ContarProductosPorCategoria
(
    p_id_categoria IN CATEGORIA.id_categoria%TYPE
)
RETURN NUMBER
AS
    v_total NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_total
    FROM PRODUCTO
    WHERE id_categoria = p_id_categoria;

    RETURN v_total;
END;
/