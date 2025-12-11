# Gestión de Citas Médicas

Proyecto Java (NetBeans) para gestionar citas médicas.

Descripción

Este repositorio contiene una aplicación de ejemplo para la gestión de citas médicas. Incluye el código fuente (NetBeans), el script SQL para crear la base de datos y el conector MySQL.

Estado

- Lenguaje: Java
- IDE recomendado: NetBeans
- Sistema de build: Ant (build.xml incluido)
- Tipo de proyecto: Aplicación web (carpeta web presente, nbproject)

Contenido principal

- src/              : Código fuente Java
- web/              : Recursos web (JSP, HTML, JS, CSS)
- CitasMedicasBase.sql : Script SQL para crear la base de datos y tablas
- mysql-connector-j-9.2.0.jar : Conector JDBC para MySQL
- build.xml         : Script de construcción (Ant)
- nbproject/        : Archivos de proyecto de NetBeans

Requisitos

- Java 11 o superior
- MySQL 5.7/8.0 (u otra versión compatible)
- Apache Ant (opcional si usas build.xml)
- Servidor de aplicaciones compatible con JSP/Servlets (por ejemplo, Apache Tomcat) si ejecutas la aplicación web

Instalación y puesta en marcha

1. Clonar el repositorio

   git clone https://github.com/Edinson2499/GestionCitasMedicas.git
   cd GestionCitasMedicas

2. Crear la base de datos

   - Importa el script SQL incluido:
     mysql -u <usuario> -p < CitasMedicasBase.sql

   - Ajusta los parámetros de conexión a la base de datos en el proyecto (archivo de configuración o clase de conexión). El conector JDBC ya está incluido en el repositorio (mysql-connector-j-9.2.0.jar), pero en entornos productivos es mejor gestionarlo con un gestor de dependencias o colocarlo en el classpath del servidor.

3. Construir el proyecto

   - Si usas NetBeans: abre el proyecto (carpeta con nbproject) y ejecuta desde el IDE.
   - Con Ant (desde la raíz del proyecto):
     ant

4. Desplegar y ejecutar

   - Si es una aplicación web, despliega el archivo WAR o la carpeta del proyecto en tu servidor (Tomcat) o ejecuta desde NetBeans.

Personalización

- Revisa y actualiza las credenciales y URL de la base de datos en la clase de conexión antes de ejecutar.
- Si vas a usar otro servidor o versión de Java, actualiza el classpath y la configuración del proyecto.

Contribuciones

Si quieres contribuir:

- Abre un issue describiendo la propuesta o el bug.
- Envía un pull request con cambios claros y pruebas cuando sea posible.

Licencia

Añade aquí la licencia del proyecto (por ejemplo, MIT) o un archivo LICENSE en la raíz.

Contacto

Para dudas o soporte, abre un issue en el repositorio.
