/*
    Proyecto: FideStore
    Curso: Lenguajes de Base de Datos
    Integrante: Andrey Corrales
    Archivo: paquetes_cliente_direccion_categoria.sql
    Descripción:
    Paquetes PL/SQL para agrupar procedimientos y funciones relacionados con
    clientes, direcciones, categorías y reportes básicos del módulo.

    Tablas relacionadas:
    CLIENTE
    DIRECCION
    CATEGORIA
    PRODUCTO
    PEDIDO

    Nota:
    Estos paquetes reutilizan procedimientos y funciones creados previamente.
    Por eso, antes de ejecutar este archivo deben ejecutarse los scripts de:
    - procedimientos_cliente.sql
    - procedimientos_direccion.sql
    - procedimientos_categoria.sql
    - funciones_cliente_direccion_categoria.sql
    - cursores_cliente_direccion_categoria.sql
*/

/*====================================================
PAQUETE PKG_CLIENTE
====================================================*/

CREATE OR REPLACE PACKAGE PKG_CLIENTE AS

    PROCEDURE RegistrarCliente
    (
        p_id_cliente IN CLIENTE.id_cliente%TYPE,
        p_nombre     IN CLIENTE.nombre%TYPE,
        p_correo     IN CLIENTE.correo%TYPE,
        p_telefono   IN CLIENTE.telefono%TYPE
    );

    PROCEDURE BuscarCliente
    (
        p_id_cliente IN CLIENTE.id_cliente%TYPE,
        p_nombre     OUT CLIENTE.nombre%TYPE,
        p_correo     OUT CLIENTE.correo%TYPE,
        p_telefono   OUT CLIENTE.telefono%TYPE
    );

    PROCEDURE ModificarCliente
    (
        p_id_cliente IN CLIENTE.id_cliente%TYPE,
        p_nombre     IN CLIENTE.nombre%TYPE,
        p_correo     IN CLIENTE.correo%TYPE,
        p_telefono   IN CLIENTE.telefono%TYPE
    );

    PROCEDURE BorrarCliente
    (
        p_id_cliente IN CLIENTE.id_cliente%TYPE
    );

    FUNCTION ClienteExiste
    (
        p_id_cliente IN CLIENTE.id_cliente%TYPE
    )
    RETURN NUMBER;

    FUNCTION NombreCliente
    (
        p_id_cliente IN CLIENTE.id_cliente%TYPE
    )
    RETURN VARCHAR2;

    FUNCTION CorreoCliente
    (
        p_id_cliente IN CLIENTE.id_cliente%TYPE
    )
    RETURN VARCHAR2;

END PKG_CLIENTE;
/

CREATE OR REPLACE PACKAGE BODY PKG_CLIENTE AS

    PROCEDURE RegistrarCliente
    (
        p_id_cliente IN CLIENTE.id_cliente%TYPE,
        p_nombre     IN CLIENTE.nombre%TYPE,
        p_correo     IN CLIENTE.correo%TYPE,
        p_telefono   IN CLIENTE.telefono%TYPE
    )
    AS
    BEGIN
        IF ValidarFormatoCorreo(p_correo) = 0 THEN
            RAISE_APPLICATION_ERROR
            (
                -20100,
                'El correo del cliente no tiene un formato válido.'
            );
        END IF;

        AgregarCliente
        (
            p_id_cliente,
            p_nombre,
            p_correo,
            p_telefono
        );
    END RegistrarCliente;

    PROCEDURE BuscarCliente
    (
        p_id_cliente IN CLIENTE.id_cliente%TYPE,
        p_nombre     OUT CLIENTE.nombre%TYPE,
        p_correo     OUT CLIENTE.correo%TYPE,
        p_telefono   OUT CLIENTE.telefono%TYPE
    )
    AS
    BEGIN
        ConsultarCliente
        (
            p_id_cliente,
            p_nombre,
            p_correo,
            p_telefono
        );
    END BuscarCliente;

    PROCEDURE ModificarCliente
    (
        p_id_cliente IN CLIENTE.id_cliente%TYPE,
        p_nombre     IN CLIENTE.nombre%TYPE,
        p_correo     IN CLIENTE.correo%TYPE,
        p_telefono   IN CLIENTE.telefono%TYPE
    )
    AS
    BEGIN
        IF ValidarFormatoCorreo(p_correo) = 0 THEN
            RAISE_APPLICATION_ERROR
            (
                -20101,
                'El correo actualizado del cliente no tiene un formato válido.'
            );
        END IF;

        ActualizarCliente
        (
            p_id_cliente,
            p_nombre,
            p_correo,
            p_telefono
        );
    END ModificarCliente;

    PROCEDURE BorrarCliente
    (
        p_id_cliente IN CLIENTE.id_cliente%TYPE
    )
    AS
    BEGIN
        EliminarCliente(p_id_cliente);
    END BorrarCliente;

    FUNCTION ClienteExiste
    (
        p_id_cliente IN CLIENTE.id_cliente%TYPE
    )
    RETURN NUMBER
    AS
    BEGIN
        RETURN ExisteCliente(p_id_cliente);
    END ClienteExiste;

    FUNCTION NombreCliente
    (
        p_id_cliente IN CLIENTE.id_cliente%TYPE
    )
    RETURN VARCHAR2
    AS
    BEGIN
        RETURN ObtenerNombreCliente(p_id_cliente);
    END NombreCliente;

    FUNCTION CorreoCliente
    (
        p_id_cliente IN CLIENTE.id_cliente%TYPE
    )
    RETURN VARCHAR2
    AS
    BEGIN
        RETURN ObtenerCorreoCliente(p_id_cliente);
    END CorreoCliente;

END PKG_CLIENTE;
/

/*====================================================
PAQUETE PKG_DIRECCION
====================================================*/

CREATE OR REPLACE PACKAGE PKG_DIRECCION AS

    PROCEDURE RegistrarDireccion
    (
        p_id_direccion IN DIRECCION.id_direccion%TYPE,
        p_id_cliente   IN DIRECCION.id_cliente%TYPE,
        p_direccion    IN DIRECCION.direccion%TYPE
    );

    PROCEDURE BuscarDireccion
    (
        p_id_direccion IN DIRECCION.id_direccion%TYPE,
        p_id_cliente   OUT DIRECCION.id_cliente%TYPE,
        p_direccion    OUT DIRECCION.direccion%TYPE
    );

    PROCEDURE ModificarDireccion
    (
        p_id_direccion IN DIRECCION.id_direccion%TYPE,
        p_id_cliente   IN DIRECCION.id_cliente%TYPE,
        p_direccion    IN DIRECCION.direccion%TYPE
    );

    PROCEDURE BorrarDireccion
    (
        p_id_direccion IN DIRECCION.id_direccion%TYPE
    );

    FUNCTION DireccionExiste
    (
        p_id_direccion IN DIRECCION.id_direccion%TYPE
    )
    RETURN NUMBER;

    FUNCTION TotalDireccionesCliente
    (
        p_id_cliente IN CLIENTE.id_cliente%TYPE
    )
    RETURN NUMBER;

END PKG_DIRECCION;
/

CREATE OR REPLACE PACKAGE BODY PKG_DIRECCION AS

    PROCEDURE RegistrarDireccion
    (
        p_id_direccion IN DIRECCION.id_direccion%TYPE,
        p_id_cliente   IN DIRECCION.id_cliente%TYPE,
        p_direccion    IN DIRECCION.direccion%TYPE
    )
    AS
    BEGIN
        IF ExisteCliente(p_id_cliente) = 0 THEN
            RAISE_APPLICATION_ERROR
            (
                -20110,
                'No se puede registrar la dirección porque el cliente no existe.'
            );
        END IF;

        AgregarDireccion
        (
            p_id_direccion,
            p_id_cliente,
            p_direccion
        );
    END RegistrarDireccion;

    PROCEDURE BuscarDireccion
    (
        p_id_direccion IN DIRECCION.id_direccion%TYPE,
        p_id_cliente   OUT DIRECCION.id_cliente%TYPE,
        p_direccion    OUT DIRECCION.direccion%TYPE
    )
    AS
    BEGIN
        ConsultarDireccion
        (
            p_id_direccion,
            p_id_cliente,
            p_direccion
        );
    END BuscarDireccion;

    PROCEDURE ModificarDireccion
    (
        p_id_direccion IN DIRECCION.id_direccion%TYPE,
        p_id_cliente   IN DIRECCION.id_cliente%TYPE,
        p_direccion    IN DIRECCION.direccion%TYPE
    )
    AS
    BEGIN
        IF ExisteCliente(p_id_cliente) = 0 THEN
            RAISE_APPLICATION_ERROR
            (
                -20111,
                'No se puede actualizar la dirección porque el cliente no existe.'
            );
        END IF;

        ActualizarDireccion
        (
            p_id_direccion,
            p_id_cliente,
            p_direccion
        );
    END ModificarDireccion;

    PROCEDURE BorrarDireccion
    (
        p_id_direccion IN DIRECCION.id_direccion%TYPE
    )
    AS
    BEGIN
        EliminarDireccion(p_id_direccion);
    END BorrarDireccion;

    FUNCTION DireccionExiste
    (
        p_id_direccion IN DIRECCION.id_direccion%TYPE
    )
    RETURN NUMBER
    AS
    BEGIN
        RETURN ExisteDireccion(p_id_direccion);
    END DireccionExiste;

    FUNCTION TotalDireccionesCliente
    (
        p_id_cliente IN CLIENTE.id_cliente%TYPE
    )
    RETURN NUMBER
    AS
    BEGIN
        RETURN ContarDireccionesCliente(p_id_cliente);
    END TotalDireccionesCliente;

END PKG_DIRECCION;
/

/*====================================================
PAQUETE PKG_CATEGORIA
====================================================*/

CREATE OR REPLACE PACKAGE PKG_CATEGORIA AS

    PROCEDURE RegistrarCategoria
    (
        p_id_categoria     IN CATEGORIA.id_categoria%TYPE,
        p_nombre_categoria IN CATEGORIA.nombre_categoria%TYPE
    );

    PROCEDURE BuscarCategoria
    (
        p_id_categoria     IN CATEGORIA.id_categoria%TYPE,
        p_nombre_categoria OUT CATEGORIA.nombre_categoria%TYPE
    );

    PROCEDURE ModificarCategoria
    (
        p_id_categoria     IN CATEGORIA.id_categoria%TYPE,
        p_nombre_categoria IN CATEGORIA.nombre_categoria%TYPE
    );

    PROCEDURE BorrarCategoria
    (
        p_id_categoria IN CATEGORIA.id_categoria%TYPE
    );

    FUNCTION CategoriaExiste
    (
        p_id_categoria IN CATEGORIA.id_categoria%TYPE
    )
    RETURN NUMBER;

    FUNCTION TotalProductosCategoria
    (
        p_id_categoria IN CATEGORIA.id_categoria%TYPE
    )
    RETURN NUMBER;

END PKG_CATEGORIA;
/

CREATE OR REPLACE PACKAGE BODY PKG_CATEGORIA AS

    PROCEDURE RegistrarCategoria
    (
        p_id_categoria     IN CATEGORIA.id_categoria%TYPE,
        p_nombre_categoria IN CATEGORIA.nombre_categoria%TYPE
    )
    AS
    BEGIN
        AgregarCategoria
        (
            p_id_categoria,
            p_nombre_categoria
        );
    END RegistrarCategoria;

    PROCEDURE BuscarCategoria
    (
        p_id_categoria     IN CATEGORIA.id_categoria%TYPE,
        p_nombre_categoria OUT CATEGORIA.nombre_categoria%TYPE
    )
    AS
    BEGIN
        ConsultarCategoria
        (
            p_id_categoria,
            p_nombre_categoria
        );
    END BuscarCategoria;

    PROCEDURE ModificarCategoria
    (
        p_id_categoria     IN CATEGORIA.id_categoria%TYPE,
        p_nombre_categoria IN CATEGORIA.nombre_categoria%TYPE
    )
    AS
    BEGIN
        ActualizarCategoria
        (
            p_id_categoria,
            p_nombre_categoria
        );
    END ModificarCategoria;

    PROCEDURE BorrarCategoria
    (
        p_id_categoria IN CATEGORIA.id_categoria%TYPE
    )
    AS
    BEGIN
        EliminarCategoria(p_id_categoria);
    END BorrarCategoria;

    FUNCTION CategoriaExiste
    (
        p_id_categoria IN CATEGORIA.id_categoria%TYPE
    )
    RETURN NUMBER
    AS
    BEGIN
        RETURN ExisteCategoria(p_id_categoria);
    END CategoriaExiste;

    FUNCTION TotalProductosCategoria
    (
        p_id_categoria IN CATEGORIA.id_categoria%TYPE
    )
    RETURN NUMBER
    AS
    BEGIN
        RETURN ContarProductosPorCategoria(p_id_categoria);
    END TotalProductosCategoria;

END PKG_CATEGORIA;
/

/*====================================================
PAQUETE PKG_REPORTES_CLIENTES
====================================================*/

CREATE OR REPLACE PACKAGE PKG_REPORTES_CLIENTES AS

    PROCEDURE MostrarClientes;

    PROCEDURE MostrarDireccionesCliente
    (
        p_id_cliente IN CLIENTE.id_cliente%TYPE
    );

    PROCEDURE MostrarCategorias;

    PROCEDURE MostrarCategoriasConProductos;

    PROCEDURE MostrarClientesSinDireccion;

    PROCEDURE MostrarResumenClientesPedidos;

    PROCEDURE ObtenerTotalClientes
    (
        p_total_clientes OUT NUMBER
    );

END PKG_REPORTES_CLIENTES;
/

CREATE OR REPLACE PACKAGE BODY PKG_REPORTES_CLIENTES AS

    PROCEDURE MostrarClientes
    AS
    BEGIN
        ListarClientesCursor;
    END MostrarClientes;

    PROCEDURE MostrarDireccionesCliente
    (
        p_id_cliente IN CLIENTE.id_cliente%TYPE
    )
    AS
    BEGIN
        ListarDireccionesPorClienteCursor(p_id_cliente);
    END MostrarDireccionesCliente;

    PROCEDURE MostrarCategorias
    AS
    BEGIN
        ListarCategoriasCursor;
    END MostrarCategorias;

    PROCEDURE MostrarCategoriasConProductos
    AS
    BEGIN
        ListarCategoriasConProductosCursor;
    END MostrarCategoriasConProductos;

    PROCEDURE MostrarClientesSinDireccion
    AS
    BEGIN
        ListarClientesSinDireccionCursor;
    END MostrarClientesSinDireccion;

    PROCEDURE MostrarResumenClientesPedidos
    AS
    BEGIN
        ReporteClientesPedidosCursor;
    END MostrarResumenClientesPedidos;

    PROCEDURE ObtenerTotalClientes
    (
        p_total_clientes OUT NUMBER
    )
    AS
    BEGIN
        ContarClientesConCursor(p_total_clientes);
    END ObtenerTotalClientes;

END PKG_REPORTES_CLIENTES;
/