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
