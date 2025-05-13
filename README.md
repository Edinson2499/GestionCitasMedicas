# Gestión de Citas Médicas

Aplicación web desarrollada en Java para gestionar citas entre pacientes y médicos. Permite a los usuarios registrarse, iniciar sesión, solicitar citas, y a los administradores supervisar el sistema.

## 🛠 Tecnologías Utilizadas

- **Java EE** (Servlets y JSP)
- **MySQL** (Base de datos relacional)
- **Apache Tomcat** (Servidor de aplicaciones)
- **JDBC** (`mysql-connector-j-9.2.0.jar`)
- **Apache Ant** (`build.xml`) para construcción
- **HTML/CSS/JS** para la interfaz

## 📁 Estructura del Proyecto

GestionCitasMedicas/
-├── build.xml # Script de construcción con Ant
-├── CitasMedicasBase.sql # Script para crear la base de datos
-├── mysql-connector-j-9.2.0.jar# Driver JDBC
-│
-├── src/java/Servlets/ # Lógica del servidor (Servlets)
-├── src/java/SQL/ # Acceso a la base de datos
-│
-├── web/ # Archivos de la interfaz (JSP, CSS, imágenes)
-│ ├── WEB-INF/
-│ ├── css/
-│ ├── js/
-│ ├── imagenes/
-│ └── *.jsp


## ✅ Requisitos

- JDK 8 o superior
- Apache Tomcat 9+
- MySQL Server
- NetBeans (opcional, recomendado)
- Ant (para compilar con `build.xml`)

## 🚀 Instalación

1. **Base de datos**  
   Ejecuta el script `CitasMedicasBase.sql` en tu servidor MySQL para crear las tablas necesarias.

2. **Conexión a la base de datos**  
   Modifica la clase `SQL.Conexion.java` con tus credenciales de MySQL.

3. **Compilar y desplegar**  
   Usa Ant para compilar el proyecto con `build.xml` o genera un archivo WAR y despliega en Tomcat.

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
