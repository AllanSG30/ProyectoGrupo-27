/*
    Proyecto: FideStore
    Curso: Lenguajes de Base de Datos
    Integrante: Andrey Corrales
    Archivo: pruebas_andrey.sql
    Descripcion:
    Script de pruebas para validar los procedimientos, funciones, vistas,
    cursores y paquetes del modulo de clientes, direcciones y categorias.

    Importante:
    Este script debe ejecutarse despues de crear las tablas y despues de compilar
    los procedimientos, funciones, vistas, cursores y paquetes del modulo.
*/

SET SERVEROUTPUT ON;

/*====================================================
LIMPIEZA INICIAL DE DATOS DE PRUEBA
====================================================*/

BEGIN
    DELETE FROM DIRECCION
    WHERE id_direccion IN (9001, 9002)
       OR id_cliente IN (9001, 9002);

    DELETE FROM CLIENTE
    WHERE id_cliente IN (9001, 9002);

    DELETE FROM CATEGORIA
    WHERE id_categoria IN (9001, 9002);

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Limpieza inicial completada.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Aviso durante la limpieza inicial: ' || SQLERRM);
        ROLLBACK;
END;
/

/*====================================================
PRUEBAS CRUD DE CATEGORIA
====================================================*/

DECLARE
    v_nombre_categoria CATEGORIA.nombre_categoria%TYPE;
BEGIN
    AgregarCategoria
    (
        9001,
        'Categoria Prueba Andrey'
    );

    ConsultarCategoria
    (
        9001,
        v_nombre_categoria
    );

    DBMS_OUTPUT.PUT_LINE('Categoria agregada: ' || v_nombre_categoria);

    ActualizarCategoria
    (
        9001,
        'Categoria Prueba Andrey Actualizada'
    );

    ConsultarCategoria
    (
        9001,
        v_nombre_categoria
    );

    DBMS_OUTPUT.PUT_LINE('Categoria actualizada: ' || v_nombre_categoria);
END;
/

/*====================================================
PRUEBAS CRUD DE CLIENTE
====================================================*/

DECLARE
    v_nombre   CLIENTE.nombre%TYPE;
    v_correo   CLIENTE.correo%TYPE;
    v_telefono CLIENTE.telefono%TYPE;
BEGIN
    AgregarCliente
    (
        9001,
        'Cliente Prueba Andrey',
        'andrey.prueba@fidestore.cr',
        '8888-8888'
    );

    ConsultarCliente
    (
        9001,
        v_nombre,
        v_correo,
        v_telefono
    );

    DBMS_OUTPUT.PUT_LINE('Cliente agregado: ' || v_nombre);
    DBMS_OUTPUT.PUT_LINE('Correo: ' || v_correo);
    DBMS_OUTPUT.PUT_LINE('Telefono: ' || v_telefono);

    ActualizarCliente
    (
        9001,
        'Cliente Prueba Andrey Actualizado',
        'andrey.actualizado@fidestore.cr',
        '8999-9999'
    );

    ConsultarCliente
    (
        9001,
        v_nombre,
        v_correo,
        v_telefono
    );

    DBMS_OUTPUT.PUT_LINE('Cliente actualizado: ' || v_nombre);
    DBMS_OUTPUT.PUT_LINE('Correo actualizado: ' || v_correo);
    DBMS_OUTPUT.PUT_LINE('Telefono actualizado: ' || v_telefono);
END;
/

/*====================================================
PRUEBAS CRUD DE DIRECCION
====================================================*/

DECLARE
    v_id_cliente DIRECCION.id_cliente%TYPE;
    v_direccion  DIRECCION.direccion%TYPE;
BEGIN
    AgregarDireccion
    (
        9001,
        9001,
        'San Jose, Costa Rica'
    );

    ConsultarDireccion
    (
        9001,
        v_id_cliente,
        v_direccion
    );

    DBMS_OUTPUT.PUT_LINE('Direccion agregada para cliente: ' || v_id_cliente);
    DBMS_OUTPUT.PUT_LINE('Direccion: ' || v_direccion);

    ActualizarDireccion
    (
        9001,
        9001,
        'Cartago, Costa Rica'
    );

    ConsultarDireccion
    (
        9001,
        v_id_cliente,
        v_direccion
    );

    DBMS_OUTPUT.PUT_LINE('Direccion actualizada: ' || v_direccion);
END;
/

/*====================================================
PRUEBAS DE FUNCIONES
====================================================*/

DECLARE
    v_existe_cliente      NUMBER;
    v_existe_direccion    NUMBER;
    v_existe_categoria    NUMBER;
    v_correo_valido       NUMBER;
    v_nombre_cliente      VARCHAR2(100);
    v_correo_cliente      VARCHAR2(100);
    v_total_direcciones   NUMBER;
    v_total_productos_cat NUMBER;
BEGIN
    v_existe_cliente := ExisteCliente(9001);
    v_existe_direccion := ExisteDireccion(9001);
    v_existe_categoria := ExisteCategoria(9001);
    v_correo_valido := ValidarFormatoCorreo('andrey.actualizado@fidestore.cr');
    v_nombre_cliente := ObtenerNombreCliente(9001);
    v_correo_cliente := ObtenerCorreoCliente(9001);
    v_total_direcciones := ContarDireccionesCliente(9001);
    v_total_productos_cat := ContarProductosPorCategoria(9001);

    DBMS_OUTPUT.PUT_LINE('Existe cliente 9001: ' || v_existe_cliente);
    DBMS_OUTPUT.PUT_LINE('Existe direccion 9001: ' || v_existe_direccion);
    DBMS_OUTPUT.PUT_LINE('Existe categoria 9001: ' || v_existe_categoria);
    DBMS_OUTPUT.PUT_LINE('Correo valido: ' || v_correo_valido);
    DBMS_OUTPUT.PUT_LINE('Nombre obtenido por funcion: ' || v_nombre_cliente);
    DBMS_OUTPUT.PUT_LINE('Correo obtenido por funcion: ' || v_correo_cliente);
    DBMS_OUTPUT.PUT_LINE('Total de direcciones del cliente: ' || v_total_direcciones);
    DBMS_OUTPUT.PUT_LINE('Total de productos en categoria: ' || v_total_productos_cat);
END;
/

/*====================================================
PRUEBAS DE VISTAS
====================================================*/

DECLARE
    v_total_clientes      NUMBER;
    v_total_direcciones   NUMBER;
    v_total_categorias    NUMBER;
    v_direccion_cliente   VARCHAR2(250);
    v_productos_categoria NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_total_clientes
    FROM VistaClientes
    WHERE id_cliente = 9001;

    SELECT COUNT(*)
    INTO v_total_direcciones
    FROM VistaDirecciones
    WHERE id_direccion = 9001;

    SELECT COUNT(*)
    INTO v_total_categorias
    FROM VistaCategorias
    WHERE id_categoria = 9001;

    SELECT direccion
    INTO v_direccion_cliente
    FROM VistaClientesDirecciones
    WHERE id_cliente = 9001
      AND id_direccion = 9001;

    SELECT cantidad_productos
    INTO v_productos_categoria
    FROM VistaCategoriasCantidadProductos
    WHERE id_categoria = 9001;

    DBMS_OUTPUT.PUT_LINE('VistaClientes encontro registros: ' || v_total_clientes);
    DBMS_OUTPUT.PUT_LINE('VistaDirecciones encontro registros: ' || v_total_direcciones);
    DBMS_OUTPUT.PUT_LINE('VistaCategorias encontro registros: ' || v_total_categorias);
    DBMS_OUTPUT.PUT_LINE('Direccion obtenida desde vista: ' || v_direccion_cliente);
    DBMS_OUTPUT.PUT_LINE('Productos en categoria desde vista: ' || v_productos_categoria);
END;
/

/*====================================================
PRUEBAS DE CURSORES
====================================================*/

DECLARE
    v_total_clientes NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Prueba cursor: ListarClientesCursor ---');
    ListarClientesCursor;

    DBMS_OUTPUT.PUT_LINE('--- Prueba cursor: ListarDireccionesPorClienteCursor ---');
    ListarDireccionesPorClienteCursor(9001);

    DBMS_OUTPUT.PUT_LINE('--- Prueba cursor: ListarCategoriasCursor ---');
    ListarCategoriasCursor;

    DBMS_OUTPUT.PUT_LINE('--- Prueba cursor: ListarCategoriasConProductosCursor ---');
    ListarCategoriasConProductosCursor;

    DBMS_OUTPUT.PUT_LINE('--- Prueba cursor: ListarClientesSinDireccionCursor ---');
    ListarClientesSinDireccionCursor;

    DBMS_OUTPUT.PUT_LINE('--- Prueba cursor: ContarClientesConCursor ---');
    ContarClientesConCursor(v_total_clientes);
    DBMS_OUTPUT.PUT_LINE('Total de clientes contado con cursor: ' || v_total_clientes);

    DBMS_OUTPUT.PUT_LINE('--- Prueba cursor: ReporteClientesPedidosCursor ---');
    ReporteClientesPedidosCursor;
END;
/

/*====================================================
PRUEBAS DE PAQUETES
====================================================*/

DECLARE
    v_nombre             CLIENTE.nombre%TYPE;
    v_correo             CLIENTE.correo%TYPE;
    v_telefono           CLIENTE.telefono%TYPE;
    v_id_cliente         DIRECCION.id_cliente%TYPE;
    v_direccion          DIRECCION.direccion%TYPE;
    v_nombre_categoria   CATEGORIA.nombre_categoria%TYPE;
    v_existe             NUMBER;
    v_total              NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Prueba PKG_CLIENTE ---');

    PKG_CLIENTE.RegistrarCliente
    (
        9002,
        'Cliente Paquete Andrey',
        'paquete.andrey@fidestore.cr',
        '8777-7777'
    );

    PKG_CLIENTE.BuscarCliente
    (
        9002,
        v_nombre,
        v_correo,
        v_telefono
    );

    DBMS_OUTPUT.PUT_LINE('Cliente creado desde paquete: ' || v_nombre);

    PKG_CLIENTE.ModificarCliente
    (
        9002,
        'Cliente Paquete Andrey Actualizado',
        'paquete.actualizado@fidestore.cr',
        '8666-6666'
    );

    v_existe := PKG_CLIENTE.ClienteExiste(9002);
    DBMS_OUTPUT.PUT_LINE('Existe cliente 9002 desde paquete: ' || v_existe);
    DBMS_OUTPUT.PUT_LINE('Nombre desde paquete: ' || PKG_CLIENTE.NombreCliente(9002));
    DBMS_OUTPUT.PUT_LINE('Correo desde paquete: ' || PKG_CLIENTE.CorreoCliente(9002));

    DBMS_OUTPUT.PUT_LINE('--- Prueba PKG_DIRECCION ---');

    PKG_DIRECCION.RegistrarDireccion
    (
        9002,
        9002,
        'Heredia, Costa Rica'
    );

    PKG_DIRECCION.BuscarDireccion
    (
        9002,
        v_id_cliente,
        v_direccion
    );

    DBMS_OUTPUT.PUT_LINE('Direccion creada desde paquete: ' || v_direccion);

    PKG_DIRECCION.ModificarDireccion
    (
        9002,
        9002,
        'Alajuela, Costa Rica'
    );

    v_existe := PKG_DIRECCION.DireccionExiste(9002);
    v_total := PKG_DIRECCION.TotalDireccionesCliente(9002);

    DBMS_OUTPUT.PUT_LINE('Existe direccion 9002 desde paquete: ' || v_existe);
    DBMS_OUTPUT.PUT_LINE('Total de direcciones del cliente 9002: ' || v_total);

    DBMS_OUTPUT.PUT_LINE('--- Prueba PKG_CATEGORIA ---');

    PKG_CATEGORIA.RegistrarCategoria
    (
        9002,
        'Categoria Paquete Andrey'
    );

    PKG_CATEGORIA.BuscarCategoria
    (
        9002,
        v_nombre_categoria
    );

    DBMS_OUTPUT.PUT_LINE('Categoria creada desde paquete: ' || v_nombre_categoria);

    PKG_CATEGORIA.ModificarCategoria
    (
        9002,
        'Categoria Paquete Andrey Actualizada'
    );

    v_existe := PKG_CATEGORIA.CategoriaExiste(9002);
    v_total := PKG_CATEGORIA.TotalProductosCategoria(9002);

    DBMS_OUTPUT.PUT_LINE('Existe categoria 9002 desde paquete: ' || v_existe);
    DBMS_OUTPUT.PUT_LINE('Total productos categoria 9002: ' || v_total);

    DBMS_OUTPUT.PUT_LINE('--- Prueba PKG_REPORTES_CLIENTES ---');

    PKG_REPORTES_CLIENTES.MostrarClientes;
    PKG_REPORTES_CLIENTES.MostrarDireccionesCliente(9002);
    PKG_REPORTES_CLIENTES.MostrarCategorias;
    PKG_REPORTES_CLIENTES.MostrarCategoriasConProductos;
    PKG_REPORTES_CLIENTES.MostrarClientesSinDireccion;
    PKG_REPORTES_CLIENTES.MostrarResumenClientesPedidos;

    PKG_REPORTES_CLIENTES.ObtenerTotalClientes(v_total);
    DBMS_OUTPUT.PUT_LINE('Total de clientes desde paquete de reportes: ' || v_total);
END;
/

/*====================================================
CONFIRMACION DE PRUEBAS
====================================================*/

BEGIN
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Pruebas del modulo de Andrey ejecutadas correctamente.');
END;
/