# ITSystem — Sistema de Transporte NOM-012 SCT (PHP + Local Database CRUD)

Sistema de gestión logística, monitoreo NOM-012/NOM-087, control de costos operativos y registro unificado de flotilla y operadores, desarrollado en **PHP puro con base de datos local y hashing seguro BCrypt**.

---

## 🚀 Inicio Inmediato (Ejecución Local)

No se requiere instalación de frameworks externos ni configuración de servicios en la nube. Abre tu terminal en esta carpeta y ejecuta:

```bash
php -S localhost:8000 index.php
```

Luego abre tu navegador en:
👉 **[http://localhost:8000/](http://localhost:8000/)**

---

## 🔐 Credenciales de Acceso

La base de datos **comienza completamente limpia sin datos inventados**. Se inicia únicamente con la cuenta administradora para permitir el acceso inicial al sistema:

| Rol | Correo Electrónico | Contraseña | Acceso |
| :--- | :--- | :--- | :--- |
| **Administrador** | `admin@itsystem.com` | `admin1234` | Panel general, registro de unidades, operadores, viajes y costos |

> **Nota:** Todos los vehículos, operadores, viajes y costos se registrarán conforme uses el sistema desde sus respectivos formularios.

---

## 🛠️ Auditoría, Protección de Datos y Autoescalabilidad

### 1. Protección de Datos y Seguridad Criptográfica
- **Cero Inyecciones SQL:** Todas las consultas a la base de datos están parametrizadas con sentencias preparadas de PDO (`$stmt->prepare()` y `$stmt->execute()`).
- **Hashing BCrypt:** Contraseñas protegidas mediante `password_hash($pass, PASSWORD_BCRYPT)`.
- **Protección CSRF:** Generación y validación de tokens únicos en todas las peticiones POST y llamadas asíncronas AJAX.
- **Protección XSS:** Sanitización con `htmlspecialchars(..., ENT_QUOTES, 'UTF-8')`.
- **Seguridad en Sesiones:** `session_regenerate_id(true)` en cada autenticación para mitigar ataques de fijación de sesión, con cookies configuradas en `HttpOnly` y `SameSite=Lax`.

### 2. Autoescalabilidad y Concurrencia
- **SQLite en Modo WAL (Write-Ahead Logging):** Se activó `PRAGMA journal_mode = WAL;` y `PRAGMA synchronous = NORMAL;`, lo que permite lecturas concurrentes sin bloquear escrituras simultáneas.
- **Manejo de Bloqueos:** `PRAGMA busy_timeout = 5000;` para tolerar transacciones concurrentes bajo carga de peticiones.
- **Escalamiento Transparente a MySQL / MariaDB:** Conexión abstracta vía PDO. Si el proyecto se traslada a un clúster de servidores, solo se modifica `'DB_DRIVER' => 'mysql'` en [`config/config.php`](config/config.php) sin necesidad de tocar una sola línea de lógica de negocio.

### 3. Cero Dependencias Externas Innecesarias
- Se eliminaron las librerías remotas y referencias a Firebase, Firestore y servicios no presentes en la carpeta.
- Se eliminaron los módulos de inventario y jefes de mantenimiento para mantener el sistema enfocado exclusivamente en transporte, flotilla, viajes NOM-012 y costos operativos.

---

## 📁 Estructura del Proyecto

```text
ITP/
├── app/
│   ├── Database.php            # Conexión PDO SQLite/MySQL + Concurrencia WAL
│   ├── Auth.php                # Autenticación, sesiones y verificación BCrypt
│   ├── Controllers/
│   │   └── ApiController.php   # Endpoints REST locales para rutas y operadores
│   ├── Models/
│   │   ├── User.php            # CRUD Usuarios
│   │   ├── Vehicle.php         # CRUD Unidades / Vehículos
│   │   ├── Operator.php        # CRUD Operadores y auditoría de vencimientos NOM-012
│   │   ├── Route.php           # CRUD Viajes y asignaciones
│   │   └── Cost.php            # CRUD Gastos operativos y desglose
│   └── Services/
│       ├── MexRoutes.php       # Puerto de cálculo de casetas SCT, descansos NOM-087 y costos
│       ├── MexData.php         # Restricciones de circulación y zonas de seguridad
│       └── OverpassProxy.php   # Proxy para búsqueda de gasolineras y puntos de interés
├── config/
│   └── config.php              # Parámetros del sistema, sesiones y configuración DB
├── views/
│   └── layout/
│       ├── header.php          # Navbar con control de rol y flash messages
│       └── footer.php          # Cierre de página y scripts base
├── index.php                   # Front Controller y enrutador limpio
├── login.php                   # Vista y autenticación de inicio de sesión
├── dashboard.php               # Panel de control principal con mapa Leaflet y métricas
├── unified_registry.php        # Flotilla y operadores con auditoría NOM-012
├── add_opv.php                 # Alta unificada de unidad / operador
├── add_trip.php                # Asignación de viajes, ruteo y Carta de Instrucción PDF
├── cost.php                    # Historial y control de gastos operativos
├── add_cost.php                # Calculadora y registro de costos
├── trip_history.php            # Historial detallado de viajes con filtros por fecha
├── reports.php                 # Exportación de bitácoras y finanzas en CSV/Excel
└── README.md                   # Documentación y credenciales
```
