# Proyecto FideStore

## Curso

Lenguajes de Base de Datos

## Integrantes

- Andrey Martín Corrales López
- Jorge Fernández Delgado
- Allan Sarmiento González

## Descripción del proyecto

FideStore es una propuesta de tienda virtual universitaria orientada a la venta de productos académicos y artículos relacionados con la vida estudiantil. El sistema busca organizar la información de clientes, direcciones, categorías, productos, proveedores, inventario, pedidos y detalle de pedidos mediante una base de datos relacional.

Este repositorio corresponde al Avance II del Proyecto de Investigación del curso Lenguajes de Base de Datos. En este avance se trabaja la programación de objetos de base de datos mediante SQL y PL/SQL, además de la conexión desde Python hacia la base de datos.

## Cambio de motor de base de datos

En el primer avance se había planteado el uso de MySQL. Sin embargo, para este segundo avance el grupo decidió trabajar con Oracle y PL/SQL, ya que las instrucciones solicitan elementos como procedimientos almacenados, funciones, vistas, cursores, paquetes, triggers y uso de SQL Developer.

Este cambio permite ajustarse mejor a los requisitos técnicos solicitados para el avance y facilita la implementación de estructuras propias de PL/SQL.

## Tecnologías utilizadas

- Oracle Database
- Oracle SQL Developer
- SQL
- PL/SQL
- Python
- Git
- GitHub
- Visual Studio Code

## Distribución del trabajo

| Integrante | Módulo asignado | Responsabilidades principales |
| ---------- | --------------- | ----------------------------- |
| Andrey | Cliente, Dirección, Categoría y documentación | Procedimientos CRUD, funciones, vistas, cursores, paquetes, pruebas del módulo y documentación del repositorio |
| Jorge | Producto, Proveedor, Producto_Proveedor e Inventario | Creación de tablas, procedimientos, funciones, vistas y triggers relacionados con productos e inventario |
| Allan | Pedido, Detalle_Pedido e integración con Python | Conexión desde Python, lógica de pedidos, procedimientos, triggers y cursores relacionados con pedidos |

## Estructura del repositorio

```text
ProyectoGrupo-27/
│
├── Python/
│   ├── conexion.py
│   ├── main.py
│   ├── pedidos.py
│   └── requisitos.txt
│
├── Sql/
│   ├── creacion_tablas.sql
│   ├── funciones_producto_inventario.sql
│   ├── procedimientos_inventario.sql
│   ├── procedimientos_producto.sql
│   ├── procedimientos_producto_proveedor.sql
│   ├── procedimientos_proveedor.sql
│   ├── triggers_inventario.sql
│   ├── vistas_producto_inventario.sql
│   ├── procedimientos_pedidos.sql
│   ├── triggers_pedidos.sql
│   ├── cursores_pedidos.sql
│   ├── procedimientos_cliente.sql
│   ├── procedimientos_direccion.sql
│   ├── procedimientos_categoria.sql
│   ├── funciones_cliente_direccion_categoria.sql
│   ├── vistas_cliente_direccion_categoria.sql
│   ├── cursores_cliente_direccion_categoria.sql
│   ├── paquetes_cliente_direccion_categoria.sql
│   └── pruebas_andrey.sql
│
└── README.md
```

## Orden sugerido de ejecución de scripts SQL

Para evitar errores por dependencias entre tablas, procedimientos, funciones, vistas, cursores y paquetes, se recomienda ejecutar los scripts en el siguiente orden:

### 1. Creación de tablas

```text
Sql/creacion_tablas.sql
```

### 2. Módulo de productos, proveedores e inventario

```text
Sql/procedimientos_producto.sql
Sql/procedimientos_proveedor.sql
Sql/procedimientos_producto_proveedor.sql
Sql/procedimientos_inventario.sql
Sql/funciones_producto_inventario.sql
Sql/vistas_producto_inventario.sql
Sql/triggers_inventario.sql
```

### 3. Módulo de pedidos

```text
Sql/procedimientos_pedidos.sql
Sql/triggers_pedidos.sql
Sql/cursores_pedidos.sql
```

### 4. Módulo de clientes, direcciones y categorías

```text
Sql/procedimientos_cliente.sql
Sql/procedimientos_direccion.sql
Sql/procedimientos_categoria.sql
Sql/funciones_cliente_direccion_categoria.sql
Sql/vistas_cliente_direccion_categoria.sql
Sql/cursores_cliente_direccion_categoria.sql
Sql/paquetes_cliente_direccion_categoria.sql
```

## Módulo de Andrey

El módulo desarrollado por Andrey incluye la gestión de clientes, direcciones y categorías. Para este módulo se crearon procedimientos almacenados, funciones, vistas, cursores, paquetes y un archivo de pruebas.

### Archivos desarrollados

```text
Sql/procedimientos_cliente.sql
Sql/procedimientos_direccion.sql
Sql/procedimientos_categoria.sql
Sql/funciones_cliente_direccion_categoria.sql
Sql/vistas_cliente_direccion_categoria.sql
Sql/cursores_cliente_direccion_categoria.sql
Sql/paquetes_cliente_direccion_categoria.sql
Sql/pruebas_andrey.sql
```

### Procedimientos almacenados

Se implementaron procedimientos CRUD para las siguientes tablas:

- CLIENTE
- DIRECCION
- CATEGORIA

Los procedimientos permiten registrar, consultar, actualizar y eliminar información de estas tablas. Además, incluyen manejo de excepciones para controlar registros duplicados, registros inexistentes y restricciones por relaciones con otras tablas.

### Funciones

Se agregaron funciones para validar y consultar información reutilizable dentro del sistema.

Funciones incluidas:

- `ExisteCliente`
- `ExisteCategoria`
- `ExisteDireccion`
- `ValidarFormatoCorreo`
- `ObtenerNombreCliente`
- `ObtenerCorreoCliente`
- `ContarDireccionesCliente`
- `ContarProductosPorCategoria`

Estas funciones permiten validar existencia de registros, verificar correos y obtener información relacionada con clientes, direcciones y categorías.

### Vistas

Se crearon vistas para facilitar consultas frecuentes dentro del sistema.

Vistas incluidas:

- `VistaClientes`
- `VistaDirecciones`
- `VistaClientesDirecciones`
- `VistaCategorias`
- `VistaCategoriasCantidadProductos`
- `VistaClientesPedidosResumen`

Estas vistas permiten consultar información de clientes, direcciones, categorías, productos asociados y pedidos por cliente sin escribir consultas directas desde la aplicación.

### Cursores

Se implementaron procedimientos con cursores explícitos para recorrer información de clientes, direcciones, categorías y reportes básicos.

Procedimientos con cursores incluidos:

- `ListarClientesCursor`
- `ListarDireccionesPorClienteCursor`
- `ListarCategoriasCursor`
- `ListarCategoriasConProductosCursor`
- `ListarClientesSinDireccionCursor`
- `ContarClientesConCursor`
- `ReporteClientesPedidosCursor`

Estos procedimientos utilizan `DBMS_OUTPUT` para mostrar los resultados durante las pruebas en Oracle SQL Developer.

### Paquetes

Se crearon paquetes PL/SQL para agrupar procedimientos y funciones relacionadas con el módulo.

Paquetes incluidos:

- `PKG_CLIENTE`
- `PKG_DIRECCION`
- `PKG_CATEGORIA`
- `PKG_REPORTES_CLIENTES`

El uso de paquetes permite organizar mejor la lógica del sistema y facilita el mantenimiento del código.

## Módulo de Jorge

El módulo desarrollado por Jorge incluye productos, proveedores, relación producto proveedor e inventario.

Según la estructura del repositorio, este módulo incluye:

```text
Sql/procedimientos_producto.sql
Sql/procedimientos_proveedor.sql
Sql/procedimientos_producto_proveedor.sql
Sql/procedimientos_inventario.sql
Sql/funciones_producto_inventario.sql
Sql/vistas_producto_inventario.sql
Sql/triggers_inventario.sql
```

Este módulo permite administrar productos, proveedores e inventario, además de incluir funciones, vistas y triggers relacionados con el control del stock.

## Módulo de Allan

El módulo desarrollado por Allan incluye pedidos, detalle de pedidos e integración desde Python.

Según la estructura del repositorio, este módulo incluye:

```text
Sql/procedimientos_pedidos.sql
Sql/triggers_pedidos.sql
Sql/cursores_pedidos.sql
Python/conexion.py
Python/main.py
Python/pedidos.py
Python/requisitos.txt
```

Este módulo permite trabajar la conexión de Python con la base de datos y la lógica relacionada con pedidos.

## Conexión desde Python

El proyecto incluye una carpeta `Python/` con archivos para realizar la conexión y probar funcionalidades desde la aplicación.

Para instalar las dependencias del proyecto, se puede usar:

```bash
pip install -r Python/requisitos.txt
```

Para ejecutar el programa principal:

```bash
python Python/main.py
```

La conexión debe configurarse según el ambiente local de Oracle utilizado por cada integrante.

## Consideraciones importantes

- Las operaciones principales del sistema deben ejecutarse mediante procedimientos almacenados, funciones, cursores, paquetes o triggers.
- No se recomienda colocar consultas directas dentro del código Python para operaciones principales de la base de datos.
- Los scripts deben ejecutarse respetando el orden sugerido para evitar errores por dependencias.
- Las pruebas deben ejecutarse al final, cuando los objetos de base de datos ya estén creados.
- Cada integrante debe realizar commits propios para que el profesor pueda revisar los aportes individuales en GitHub.

## Buenas prácticas aplicadas

- Separación de archivos por módulo.
- Uso de procedimientos almacenados para operaciones CRUD.
- Uso de funciones para validaciones y consultas reutilizables.
- Uso de vistas para consultas frecuentes.
- Uso de cursores explícitos para reportes.
- Uso de paquetes para agrupar lógica relacionada.
- Manejo de excepciones con `RAISE_APPLICATION_ERROR`.
- Commits separados por avance.
- Organización del repositorio por carpetas.
- Documentación del orden de ejecución de scripts.

## Estado del avance

Para este segundo avance, el repositorio contiene la estructura de base de datos, objetos PL/SQL por módulo, scripts de prueba y archivos de conexión desde Python.

El módulo de clientes, direcciones y categorías fue validado en Oracle SQL, comprobando la compilación y ejecución de procedimientos CRUD, funciones, vistas, cursores y paquetes PL/SQL.

El objetivo del repositorio es evidenciar un avance funcional del sistema y mantener el código organizado para la integración final del proyecto.