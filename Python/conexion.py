"""
Modulo de conexion a la base de datos FideStore (Oracle).

IMPORTANTE: Jorge programo su parte en Oracle PL/SQL, no en MySQL.
Por eso aqui se usa el conector oficial de Oracle para Python
(python-oracledb) en lugar de mysql-connector-python.

"""

import oracledb

# TODO: ajustar estos valores a los datos reales del Oracle del curso
# (host, puerto y nombre de servicio los da el profesor o el XE local)
CONFIG = {
    "user": "fidestore_app",
    "password": "CAMBIARCONTRASEÑA",
    "dsn": "localhost:1521/XEPDB1",  # host:puerto/servicio
}


def obtener_conexion():
    """Crea y retorna una nueva conexion a la base de datos Oracle."""
    try:
        conexion = oracledb.connect(**CONFIG)
        return conexion
    except oracledb.Error as e:
        print(f"Error al conectar a la base de datos: {e}")
        raise
