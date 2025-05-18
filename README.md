# 🏥 Gestión de Citas Médicas

Sistema web para la gestión de citas médicas, desarrollado con JSP, Servlets y MySQL. Este proyecto permite a pacientes registrarse, iniciar sesión y agendar citas médicas, mientras que los administradores pueden gestionar usuarios y horarios disponibles.

## 📌 Características Principales

- Registro de nuevos pacientes.
- Inicio de sesión para pacientes y administradores.
- Agendamiento y gestión de citas médicas.
- Validación de formularios en el cliente y servidor.
- Panel de administración para gestión de usuarios y citas.

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

![image](https://github.com/user-attachments/assets/1c8e2163-2870-43c0-88cd-61557e03328b)


## ⚙️ Requisitos

- Java JDK 8 o superior
- Apache Tomcat 9 o superior
- MySQL Server
- IDE como Eclipse o IntelliJ (opcional)

## 🛠️ Instalación y Configuración

1. **Clona este repositorio:**

bash
git clone https://github.com/tu-usuario/GestionCitasMedicas.git

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
## 👤 🏥Registro de Nuevo Paciente

Como nuevo usuario del sistema (paciente),
quiero registrarme mediante un formulario en línea,
para que pueda acceder al sistema y agendar mis citas médicas.

-Criterios de Aceptación:
   -El formulario debe estar disponible en la vista altaUsuario.jsp.

   -El usuario debe ingresar datos como nombre, correo electrónico, contraseña y documento.

   -Se debe validar que los datos sean correctos antes de registrarlos en la base de datos.

   -El sistema debe confirmar el registro y redirigir al usuario a la página de login (login.jsp).
   
## 🔒 Seguridad

- Validación de formularios del lado del cliente y servidor.
- Control de acceso mediante sesiones.


Repositorio gestionado con Git.

---

> Para dudas o mejoras, siéntete libre de abrir un issue o pull request.
