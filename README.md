# 🏥 Gestión de Citas Médicas

![Ask DeepWiki](https://deepwiki.com/badge.svg)  
[Consulta el artículo completo en DeepWiki](https://deepwiki.com/Shadowfiend2504/GestionCitasMedicas)

## 📘 Propósito y Alcance

Este documento proporciona una visión general del sistema de gestión de citas médicas (**GestionCitasMedicas**), una aplicación web en Java que facilita la programación de citas entre pacientes y especialistas médicos. El sistema maneja el registro de usuarios, la reserva de citas, la gestión de disponibilidad y el envío automatizado de notificaciones por correo electrónico y SMS.

> Para detalles sobre autenticación y seguridad, consulta **Authentication and Security**.  
> Para información sobre el diseño de la base de datos, consulta **Database Design**.  
> Para documentación de la interfaz de usuario, consulta **User Interfaces**.

## 🧱 Arquitectura del Sistema

El sistema sigue una arquitectura clásica de tres capas utilizando tecnologías Java EE:

- **Capa de presentación**: JSP/HTML/CSS con Bootstrap
- **Lógica de negocio**: Servlets Java
- **Persistencia de datos**: MySQL
- **Servicios externos**: Gmail SMTP (correo), Twilio API (SMS)

## 🛠️ Tecnologías Utilizadas

| Componente         | Tecnología            | Versión           |
|--------------------|------------------------|-------------------|
| Servidor web       | Apache Tomcat          | 11.0              |
| Backend            | Java EE (Servlets, JSP)| Jakarta EE        |
| Base de datos      | MySQL                  | —                 |
| Servicio de correo | Gmail SMTP             | Jakarta Mail 2.0.1|
| Servicio SMS       | Twilio API             | —                 |
| Build tool         | Apache Ant             | —                 |
| IDE                | NetBeans               | —                 |

## 🧩 Componentes Principales

### Capas del sistema

- **Presentación**:  
  - `agendar_cita.jsp`  
  - `consultar_citas.jsp`  
  - `actualizar_disponibilidad.jsp`

- **Lógica de negocio (Servlets)**:  
  - `AgendarCitaServlet`: programación de citas  
  - `ActualizarDatosServlet`: gestión de perfil  
  - `CancelarCitaServlet`: cancelación  
  - `ConfirmarCitaServlet`: confirmación  
  - `Authentication Servlets`: manejo de sesión

- **Persistencia y utilitarios**:  
  - `ConexionBD`: conexiones con MySQL  
  - `MetodosSQL`: operaciones SQL  
  - `EmailSender`: integración con Gmail  
  - `SMSSender`: integración con Twilio

## 👥 Roles de Usuario

| Rol           | Registro               | Reservar Cita     | Gestión de Disponibilidad | Administración |
|---------------|------------------------|-------------------|----------------------------|----------------|
| **Paciente**   | ✓ (`altaUsuario.jsp`)   | ✓ (`AgendarCitaServlet`) | ✗                          | ✗              |
| **Especialista** | ✓ (`altaUsuarioE.jsp`) | Solo lectura       | ✓ (`actualizar_disponibilidad.jsp`) | ✗              |
| **Administrador** | Nivel sistema         | Acceso completo    | ✓                          | ✓ (`registrar_usuario.jsp`) |

## 📅 Flujo de Agenda de Citas

1. `POST /AgendarCitaServlet?action=consultar`  
   → `obtenerDisponibilidad()`  
   → devuelve especialistas y horarios disponibles

2. `POST /AgendarCitaServlet?action=agendar`  
   → `existeTraslape()` para evitar conflictos  
   → `insertarCita()`, luego  
   → `enviarEmailHTML()` y `enviarSMS()` con confirmación

## 🌟 Funcionalidades Clave

### Gestión de Citas
- **Consulta de disponibilidad en tiempo real**: `obtenerDisponibilidad()` en intervalos de 20 minutos  
- **Prevención de conflictos**: `existeTraslape()` evita doble reserva  
- **Notificaciones automáticas**: con `EmailSender` y `SMSSender`

### Gestión de Usuarios
- **Registros separados** para pacientes y especialistas  
- **Sesiones seguras** mediante `HttpSession` con control de acceso  
- **Actualización de perfiles** mediante `ActualizarDatosServlet`

### Persistencia de Datos
- **Pooling de conexiones**: `ConexionBD`  
- **Operaciones centralizadas SQL**: `MetodosSQL`  
- **Transacciones** manejadas a nivel de servlet

## 🧬 Esquema de Base de Datos (MySQL)

### Tablas Principales

#### `Usuario`
- `id` (PK)
- `nombre`, `apellidos`, `telefono`, `direccion`, `correo` (UK), `contrasena`, `usuario_generado` (UK)
- `tipo_usuario` (enum)

#### `Especialista`
- `id_usuario` (PK, FK)
- `especialidad`, `numero_tarjeta_profesional` (UK)

#### `Cita`
- `id` (PK)
- `id_paciente` (FK), `id_especialista` (FK)
- `fecha_hora`, `motivo`, `descripcion`, `estado` (enum)

#### `DisponibilidadEspecialista`
- `id` (PK)
- `id_especialista` (FK), `fecha`, `hora_inicio`, `hora_fin`

#### `Factura`
- Relación con cita y datos de facturación (no detallado)

## 🔗 Integraciones con Servicios Externos

- **Correo Electrónico**: `EmailSender` usa Gmail SMTP, con plantillas HTML para confirmación
- **Mensajes de Texto (SMS)**: `SMSSender` usa Twilio para envío de citas a dispositivos móviles

## 🚀 Desarrollo y Despliegue

- Construido como archivo WAR: `citasMedicas.war`
- Desplegable en Tomcat mediante Ant
- Dependencias clave:
  - `mysql-connector-j-9.2.0.jar`
  - `jakarta.mail-2.0.1.jar`
  - `gson-2.13.1.jar`
  - `httpclient-4.5.14.jar`
---

## 📘 Tutorial de Funcionamiento de la Página Web

Esta aplicación permite gestionar citas médicas entre pacientes y médicos a través de una interfaz web sencilla. A continuación se detalla cómo utilizar las principales funcionalidades:

### 🔐 Inicio de Sesión / Registro

1. **Registro de Usuario:**
   - Accede a `altaUsuario.jsp` si eres paciente o a `altaUsuarioE.jsp` si eres especialista.
   - Completa el formulario con tus datos personales.
   - Una vez registrado, puedes iniciar sesión.

   *Registro Especialista*
   
 ![image](https://github.com/user-attachments/assets/4f9ce6f2-5aa7-40f8-affa-dc950c9f05cb)


   *Resgistro Paciente*
   
![image](https://github.com/user-attachments/assets/54935df7-9a2a-435a-a873-f26bea4c27a7)


3. **Inicio de Sesión:**
   - Ingresa tus credenciales en la página de login.
   - Según el rol (paciente o médico), serás redirigido al panel correspondiente.
   
![image](https://github.com/user-attachments/assets/b9fd8410-4e0d-428f-82e5-c25140e44f57)


   
## 👤 🏥Registro de Nuevo Paciente

Como nuevo usuario del sistema (paciente),
quiero registrarme mediante un formulario en línea,
para que pueda acceder al sistema y agendar mis citas médicas.

-Criterios de Aceptación:
   -El formulario debe estar disponible en la vista altaUsuario.jsp.

   -El usuario debe ingresar datos como nombre, correo electrónico, contraseña y documento.

   -Se debe validar que los datos sean correctos antes de registrarlos en la base de datos.

   -El sistema debe confirmar el registro y redirigir al usuario a la página de login (login.jsp).
   
### 📅 Agendar una Cita (Paciente)

1. Dirígete a la sección de **Agendar Cita** (`agendar_cita.jsp`).
2. Selecciona el especialista, fecha y hora disponible.
3. Confirma tu cita. Recibirás una notificación de éxito.

![image](https://github.com/user-attachments/assets/76ef36ee-1a63-475d-916b-45f57096f2ce)


### 🕒 Gestionar Disponibilidad (Especialista)

1. Accede a `actualizar_disponibilidad.jsp`.
2. Indica los días y horas en que estás disponible para atender citas.
3. Guarda los cambios para que los pacientes puedan agendar en esos espacios.

![image](https://github.com/user-attachments/assets/b7cdd284-f8ed-4ec1-846f-de7e3dd3cd28)


### 📋 Ver y Administrar Citas

- Tanto pacientes como médicos pueden consultar sus citas programadas.
- Es posible cancelar o modificar citas según los permisos establecidos.

![image](https://github.com/user-attachments/assets/5c78416c-af6b-4078-b511-608d8a6cc091)

### 🛠 Requisitos Técnicos

- Java 8+
- Servidor Apache Tomcat
- MySQL (importar `CitasMedicasBase.sql`)
- Maven para gestión de dependencias (`pom.xml`)

### 🚀 Despliegue

1. Importa el proyecto en tu IDE (NetBeans/Eclipse).
2. Configura el servidor Tomcat.
3. Importa la base de datos desde `CitasMedicasBase.sql`.
4. Ejecuta el proyecto y accede a la app vía navegador.


# 🏥 Gestión de Citas Médicas

Sistema web para la gestión de citas médicas, desarrollado con JSP, Servlets y MySQL. Este proyecto permite a pacientes registrarse, iniciar sesión y agendar citas médicas, mientras que los administradores pueden gestionar usuarios y horarios disponibles.

## 📌 Características Principales

- Registro de nuevos pacientes.
- Inicio de sesión para pacientes y administradores.
- Agendamiento y gestión de citas médicas.
- Validación de formularios en el cliente y servidor.
- Panel de administración para gestión de usuarios y citas.
---------------------------------------------------------------------------------------------
## 🚀 Tecnologías Utilizadas

- Java EE (Servlets, JSP)
- Apache Tomcat
- HTML5, CSS3
- MySQL
- JDBC

## 📂 Estructura del Proyecto

GestionCitasMedicas/
├── build.xml # Script de construcción con Ant
├── CitasMedicasBase.sql # Script para crear la base de datos
├── mysql-connector-j-9.2.0.jar# Driver JDBC
│
├── src/java/Servlets/ # Lógica del servidor (Servlets)
├── src/java/SQL/ # Acceso a la base de datos
│├── web/ # Archivos de la interfaz (JSP, CSS, imágenes)
│ ├── WEB-INF/
│ ├── css/
│ ├── js/
│ ├── imagenes/
│ └── *.jsp

![ChatGPT Image 18 may 2025, 12_05_38 (1)](https://github.com/user-attachments/assets/f2b544a3-e566-4360-8a4d-b6fe70a2f30a)


## ⚙️ Requisitos

- Java JDK 8 o superior
- Apache Tomcat 9 o superior
- MySQL Server
- IDE como Eclipse o IntelliJ (opcional)

## 🛠️ Instalación y Configuración

1. **Clona este repositorio:**

bash
git clone [https://github.com/Shadowfiend2504/GestionCitasMedicas](https://github.com/Shadowfiend2504/GestionCitasMedicas).git

## 👤 Roles de Usuario

- **Paciente**: Registro, inicio de sesión, solicitud y consulta de citas.
- **Médico**: Visualización de citas asignadas.
- **Administrador**: Gestión de usuarios y sistema.

## 📄 Principales JSPs

- `login.jsp`: Inicio de sesión
- `altaUsuario.jsp`: Registro de usuarios
- `menu.jsp`: Menú principal
- `citas.jsp`: Gestión de citas
- `admin.jsp`: Panel administrativo

## 🔒 Seguridad

- Validación de formularios del lado del cliente y servidor.
- Control de acceso mediante sesiones.

Repositorio gestionado con Git.

---

> Para dudas o mejoras, siéntete libre de abrir un issue o pull request.
