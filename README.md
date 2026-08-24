# Proyecto FideStore

## Curso

Lenguajes de Base de Datos

## Integrantes

- Andrey Martín Corrales López
- Jorge Fernández Delgado
- Allan Sarmiento González

## Descripción del proyecto

FideStore es un proyecto académico que simula una tienda virtual universitaria orientada a la venta de productos académicos y artículos relacionados con la vida estudiantil.

El sistema utiliza una base de datos relacional para organizar la información correspondiente a clientes, direcciones, categorías, productos, proveedores, inventario, pedidos y detalle de pedidos.

La solución fue desarrollada principalmente utilizando Oracle Database, SQL y PL/SQL para la capa de datos, mientras que Python se utiliza como capa de aplicación para interactuar con algunos de los objetos almacenados en Oracle.

El repositorio contiene la implementación desarrollada durante el Proyecto de Investigación del curso Lenguajes de Base de Datos, incluyendo la estructura relacional, objetos PL/SQL, pruebas, conexión desde Python y documentación necesaria para la revisión del proyecto.

---

## Objetivo

Desarrollar un sistema basado en una base de datos relacional que permita gestionar la información operativa de FideStore mediante SQL y PL/SQL, aplicando conceptos de diseño relacional, integridad de datos, procedimientos almacenados, funciones, vistas, triggers, cursores y paquetes.

---

## Tecnologías utilizadas

- Oracle Database
- SQL
- PL/SQL
- Python 3.10+
- python-oracledb
- Oracle SQL Developer
- Oracle FreeSQL
- Git
- GitHub
- Visual Studio Code

---

## Decisión técnica: Oracle y PL/SQL

Durante la etapa inicial del proyecto se había considerado MySQL como motor de base de datos. Conforme avanzó el desarrollo se decidió utilizar Oracle Database y PL/SQL.

El cambio permitió trabajar de manera directa con los elementos requeridos durante el curso, entre ellos:

- Procedimientos almacenados
- Funciones
- Vistas
- Triggers
- Cursores
- Paquetes PL/SQL

Python se mantuvo como lenguaje para la capa de aplicación utilizando el controlador `python-oracledb`.

---

## Modelo relacional

La base de datos de FideStore está compuesta por nueve tablas principales:

| Tabla | Propósito |
| --- | --- |
| `CLIENTE` | Información de clientes |
| `DIRECCION` | Direcciones asociadas a clientes |
| `CATEGORIA` | Clasificación de productos |
| `PRODUCTO` | Productos disponibles |
| `PROVEEDOR` | Información de proveedores |
| `PRODUCTO_PROVEEDOR` | Relación entre productos y proveedores |
| `INVENTARIO` | Existencias disponibles por producto |
| `PEDIDO` | Pedidos realizados por clientes |
| `DETALLE_PEDIDO` | Productos asociados a cada pedido |

El modelo utiliza claves primarias, claves foráneas y restricciones para mantener la integridad de los datos.

---

## Distribución del trabajo

| Integrante | Módulo asignado | Responsabilidades principales |
| --- | --- | --- |
| Andrey Martín Corrales López | Cliente, Dirección, Categoría y documentación | Procedimientos CRUD, funciones, vistas, cursores, paquetes, pruebas del módulo, README y documentación |
| Jorge Fernández Delgado | Producto, Proveedor, Producto_Proveedor e Inventario | Creación de tablas, procedimientos, funciones, vistas y triggers relacionados con catálogo e inventario |
| Allan Sarmiento González | Pedido, Detalle_Pedido e integración con Python | Conexión desde Python, lógica de pedidos, procedimientos, triggers y cursores |

---

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
│   ├── cursores_cliente_direccion_categoria.sql
│   ├── cursores_pedidos.sql
│   ├── funciones_cliente_direccion_categoria.sql
│   ├── funciones_producto_inventario.sql
│   ├── objetos_complementarios_avance2.sql
│   ├── paquetes_cliente_direccion_categoria.sql
│   ├── procedimientos_categoria.sql
│   ├── procedimientos_cliente.sql
│   ├── procedimientos_direccion.sql
│   ├── procedimientos_inventario.sql
│   ├── procedimientos_pedidos.sql
│   ├── procedimientos_producto_proveedor.sql
│   ├── procedimientos_producto.sql
│   ├── procedimientos_proveedor.sql
│   ├── pruebas_andrey.sql
│   ├── triggers_inventario.sql
│   ├── triggers_pedidos.sql
│   ├── vistas_cliente_direccion_categoria.sql
│   └── vistas_producto_inventario.sql
│
├── LEAME.txt
└── README.md
```

---

## Módulo de clientes, direcciones y categorías

Este módulo contiene la lógica necesaria para administrar la información de clientes, direcciones y categorías.

### Procedimientos almacenados

Se implementaron operaciones CRUD para:

- `CLIENTE`
- `DIRECCION`
- `CATEGORIA`

Los procedimientos permiten registrar, consultar, actualizar y eliminar información e incluyen manejo de excepciones para controlar situaciones como registros duplicados, registros inexistentes y relaciones entre tablas.

### Funciones

El módulo incluye las siguientes funciones:

- `ExisteCliente`
- `ExisteCategoria`
- `ExisteDireccion`
- `ValidarFormatoCorreo`
- `ObtenerNombreCliente`
- `ObtenerCorreoCliente`
- `ContarDireccionesCliente`
- `ContarProductosPorCategoria`

Estas funciones permiten realizar validaciones y recuperar información reutilizable desde distintos objetos PL/SQL.

### Vistas

Se implementaron las siguientes vistas:

- `VistaClientes`
- `VistaDirecciones`
- `VistaClientesDirecciones`
- `VistaCategorias`
- `VistaCategoriasCantidadProductos`
- `VistaClientesPedidosResumen`

### Cursores

Los procedimientos con cursores permiten recorrer conjuntos de registros y generar reportes mediante `DBMS_OUTPUT`.

Entre ellos se encuentran:

- `ListarClientesCursor`
- `ListarDireccionesPorClienteCursor`
- `ListarCategoriasCursor`
- `ListarCategoriasConProductosCursor`
- `ListarClientesSinDireccionCursor`
- `ContarClientesConCursor`
- `ReporteClientesPedidosCursor`

### Paquetes

Se desarrollaron paquetes para agrupar operaciones relacionadas:

- `PKG_CLIENTE`
- `PKG_DIRECCION`
- `PKG_CATEGORIA`
- `PKG_REPORTES_CLIENTES`

---

## Módulo de productos, proveedores e inventario

Este módulo administra la información relacionada con productos, proveedores, relaciones de suministro e inventario.

Los principales archivos son:

```text
Sql/procedimientos_producto.sql
Sql/procedimientos_proveedor.sql
Sql/procedimientos_producto_proveedor.sql
Sql/procedimientos_inventario.sql
Sql/funciones_producto_inventario.sql
Sql/vistas_producto_inventario.sql
Sql/triggers_inventario.sql
```

El módulo incorpora lógica para la administración del catálogo, consulta de disponibilidad y control del inventario mediante objetos PL/SQL.

---

## Módulo de pedidos e integración con Python

Este módulo contiene la lógica asociada con pedidos, detalle de pedidos y la comunicación entre Python y Oracle.

Los archivos principales son:

```text
Sql/procedimientos_pedidos.sql
Sql/triggers_pedidos.sql
Sql/cursores_pedidos.sql
Python/conexion.py
Python/main.py
Python/pedidos.py
Python/requisitos.txt
```

La aplicación Python proporciona un menú de consola para probar operaciones del módulo de pedidos.

Entre las funcionalidades disponibles se encuentran:

1. Crear un pedido.
2. Agregar un producto a un pedido.
3. Consultar el detalle y total de un pedido.
4. Verificar disponibilidad de inventario.
5. Cambiar el estado de un pedido.
6. Consultar pedidos realizados por un cliente y su resumen.

---

## Conexión entre Python y Oracle

La conexión se realiza mediante el controlador oficial `python-oracledb`.

La aplicación está organizada de forma que Python actúe como capa de aplicación y utilice la lógica previamente programada dentro de Oracle.

Archivos:

### `conexion.py`

Contiene la configuración y creación de la conexión con Oracle Database.

### `pedidos.py`

Contiene funciones de Python relacionadas con las operaciones de pedidos y la invocación de objetos de base de datos.

### `main.py`

Contiene el menú principal utilizado para probar el módulo desde consola.

### `requisitos.txt`

Contiene la dependencia:

```text
oracledb>=2.0
```

La configuración de conexión debe ajustarse según el ambiente Oracle utilizado.

Las instrucciones completas se encuentran en:

```text
LEAME.txt
```

---

## Conteo de objetos programados

Durante el desarrollo del proyecto se alcanzó el siguiente conteo de objetos:

| Objeto | Cantidad | Mínimo solicitado | Estado |
| --- | ---: | ---: | --- |
| Procedimientos almacenados | 48 | 25 | Cumple |
| Funciones | 16 | 15 | Cumple |
| Vistas | 11 | 10 | Cumple |
| Triggers | 6 | 5 | Cumple |
| Cursores | 16 | 15 | Cumple |
| Paquetes | 10 | 10 | Cumple |

Además del cumplimiento numérico, los objetos fueron distribuidos entre diferentes módulos para mantener organizada la lógica del sistema.

---

## Pruebas realizadas

Durante el desarrollo se realizaron pruebas de los objetos SQL y PL/SQL utilizando Oracle.

Entre las validaciones realizadas se encuentran:

- Creación de las nueve tablas del modelo.
- Operaciones de inserción, consulta, actualización y eliminación.
- Compilación de procedimientos almacenados.
- Ejecución de funciones.
- Consultas mediante vistas.
- Ejecución de cursores utilizando `DBMS_OUTPUT`.
- Compilación y ejecución de paquetes PL/SQL.
- Validación de objetos complementarios.
- Manejo de excepciones y reglas de negocio.

Durante las pruebas del módulo de clientes se identificó un detalle en la función encargada de validar correos electrónicos. La implementación inicial no reconocía correctamente algunos correos que contenían un punto antes del símbolo arroba. La función fue corregida y posteriormente validada nuevamente.

---

## Orden general de ejecución

Para levantar la base de datos se debe comenzar por:

```text
Sql/creacion_tablas.sql
```

Después deben ejecutarse los objetos correspondientes a los diferentes módulos respetando sus dependencias.

Debido a que el proyecto contiene varios procedimientos, funciones, vistas, triggers, cursores y paquetes relacionados entre sí, las instrucciones detalladas de configuración y ejecución se encuentran en:

```text
LEAME.txt
```

Se recomienda seguir ese archivo antes de ejecutar la aplicación Python.

---

## Instalación de dependencias de Python

Desde la raíz del proyecto ejecutar:

```bash
pip install -r Python/requisitos.txt
```

Luego configurar los datos de conexión dentro de:

```text
Python/conexion.py
```

Finalmente, para iniciar el menú de prueba:

```bash
python Python/main.py
```

---

## Buenas prácticas aplicadas

- Organización del código por módulos.
- Uso de Git y GitHub para control de versiones.
- Commits identificables por integrante.
- Separación entre scripts SQL y código Python.
- Uso de procedimientos almacenados para centralizar operaciones.
- Uso de funciones para validaciones y cálculos reutilizables.
- Uso de vistas para facilitar consultas.
- Uso de triggers para reglas automáticas.
- Uso de cursores para procesamiento y reportes.
- Uso de paquetes para agrupar lógica relacionada.
- Manejo de errores mediante excepciones PL/SQL.
- Documentación del proyecto y del proceso de ejecución.

---

## Instrucciones de ejecución

Antes de ejecutar el proyecto se recomienda consultar:

```text
LEAME.txt
```

Este archivo contiene:

- Requisitos de software.
- Preparación del ambiente Oracle.
- Orden de ejecución de scripts.
- Instalación de dependencias.
- Configuración de `conexion.py`.
- Ejecución de Python.
- Consideraciones adicionales para levantar el proyecto.

---

## Estado final del proyecto

El repositorio contiene la estructura relacional de FideStore, los objetos SQL y PL/SQL desarrollados durante el curso, la integración con Python, scripts de prueba y documentación de configuración.

La implementación demuestra la aplicación práctica de conceptos de bases de datos relacionales, programación SQL y PL/SQL, organización modular y control de versiones mediante GitHub.

El código y la documentación se presentan como parte de la entrega final del Proyecto de Investigación del curso Lenguajes de Base de Datos.