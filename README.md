# 🐚 Bash Scripts

Una colección completa de scripts de Bash para automatización de tareas de sistema, administración de usuarios, manipulación de archivos y más. Este repositorio contiene herramientas útiles para administradores de sistemas y desarrolladores que trabajan en entornos Linux/Unix.

## 📋 Tabla de Contenidos

- [Características](#-características)
- [Requisitos](#-requisitos)
- [Instalación](#-instalación)
- [Scripts Disponibles](#-scripts-disponibles)
  - [Administración de Usuarios](#-administración-de-usuarios)
  - [Gestión de Archivos](#-gestión-de-archivos)
  - [Herramientas de Red](#-herramientas-de-red)
  - [Utilidades Varias](#-utilidades-varias)
  - [Algoritmos y Programación](#-algoritmos-y-programación)
- [Uso](#-uso)
- [Estructura del Proyecto](#-estructura-del-repositorio)
- [Contribución](#-contribución)
- [Licencia](#-licencia)

## ✨ Características

- 🔐 Scripts de administración de usuarios
- 📁 Herramientas de manipulación de archivos
- 🌐 Utilidades de red y configuración IP
- 📊 Scripts de monitoreo y logs
- 🔄 Automatización de tareas repetitivas
- 📦 Herramientas de compresión y backup
- 🧮 Implementaciones de algoritmos
- ✅ Validación de parámetros y entrada de datos

## 🔧 Requisitos

- Sistema operativo Linux/Unix
- Bash shell (versión 4.0 o superior)
- Permisos de administrador para algunos scripts
- Herramientas adicionales según el script:
  - `zip/unzip` para scripts de compresión
  - `curl/wget` para scripts de red
  - Acceso root para scripts de administración de usuarios

## 📥 Instalación

1. Clona este repositorio:
```bash
git clone https://github.com/Esperilla/Bash-Scripts.git
cd bash-scripts
```

2. Da permisos de ejecución a los scripts:
```bash
chmod +x *.sh
```

3. (Opcional) Añade el directorio al PATH para acceso global:
```bash
export PATH=$PATH:$(pwd)
```

## 📜 Scripts Disponibles

### 👥 Administración de Usuarios

| Script | Descripción |
|--------|-------------|
| `creadorUsuarios.sh` | Crea nuevos usuarios del sistema con validaciones |
| `borradoUsuarios.sh` | Elimina usuarios del sistema de forma segura |
| `Usuario_Fecha.sh` | Gestiona usuarios con información de fecha |

### 📁 Gestión de Archivos

| Script | Descripción |
|--------|-------------|
| `compresor.sh` | Comprime archivos recursivamente en directorios |
| `concatenarArchivos.sh` | Concatena múltiples archivos en uno solo |
| `copiarMover.sh` | Automatiza operaciones de copia y movimiento |
| `deleterRecursivo.sh` | Elimina archivos y directorios recursivamente |
| `archivosLista.sh` | Lista archivos con diferentes criterios |
| `archivoFecha.sh` | Organiza archivos por fecha |

### 🌐 Herramientas de Red

| Script | Descripción |
|--------|-------------|
| `paraIP.sh` | Herramientas para trabajar con direcciones IP |
| `ataque.sh` | Scripts de seguridad y testing de red |
| `confIP.txt` | Archivo de configuración para IPs |

### 🔧 Utilidades Varias

| Script | Descripción |
|--------|-------------|
| `fecha.sh` | Manipulación y formateo de fechas |
| `contar.sh` | Contadores y estadísticas de archivos |
| `convertidor.sh` | Conversiones entre diferentes formatos |
| `validacion.sh` | Validación de parámetros y entrada de datos |
| `lastParametro.sh` | Manejo de parámetros de línea de comandos |
| `ejemploUsosdeLogs.sh` | Ejemplos de trabajo con logs del sistema |
| `updateMenu.sh` | Sistema de menús interactivos |
| `examen.sh` | Scripts de evaluación y testing |

### 🧮 Algoritmos y Programación

| Script | Descripción |
|--------|-------------|
| `fibo.sh` | Implementación recursiva de la secuencia de Fibonacci |

## 🚀 Uso

### Ejemplo básico:
```bash
# Ejecutar un script directamente
./creadorUsuarios.sh

# Ejecutar con parámetros
./validacion.sh archivo.txt /home/usuario/documentos
```

### Ejemplos específicos:

**Crear un usuario:**
```bash
sudo ./creadorUsuarios.sh
```

**Comprimir archivos:**
```bash
./compresor.sh /ruta/del/directorio
```

**Calcular Fibonacci:**
```bash
./fibo.sh 10
```

**Validar parámetros:**
```bash
./validacion.sh mi_archivo.txt /mi/directorio
```

## 📂 Estructura del Repositorio

```
bash-scripts/
├── README.md
├── Scripts.code-workspace
├── confIP.txt
│
├── 👥 Administración de Usuarios
├── creadorUsuarios.sh
├── borradoUsuarios.sh
└── Usuario_Fecha.sh
│
├── 📁 Gestión de Archivos
├── compresor.sh
├── concatenarArchivos.sh
├── copiarMover.sh
├── deleterRecursivo.sh
├── archivosLista.sh
└── archivoFecha.sh
│
├── 🌐 Red y Seguridad
├── paraIP.sh
├── ataque.sh
└── confIP.txt
│
├── 🔧 Utilidades
├── fecha.sh
├── contar.sh
├── convertidor.sh
├── validacion.sh
├── lastParametro.sh
├── ejemploUsosdeLogs.sh
├── updateMenu.sh
└── examen.sh
│
├── 🧮 Algoritmos
└── fibo.sh
│
└── 📁 Directorios Especiales
    ├── archivosPrueba/
    ├── cracker/
    ├── dircontMaster-Slave/
    ├── Exámenes/
    ├── How/
    ├── maestro_esclavo/
    └── Servidor/
```

## 🔒 Seguridad

⚠️ **Advertencia**: Algunos scripts requieren permisos de administrador y pueden modificar el sistema. Siempre:
- Revisa el código antes de ejecutar
- Ejecuta en un entorno de prueba primero
- Haz backup de datos importantes
- Usa `sudo` solo cuando sea necesario

## 🤝 Contribución

Las contribuciones son bienvenidas. Para contribuir:

1. Fork al proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Añade nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

### Pautas para contribuir:
- Añade comentarios descriptivos en tus scripts
- Incluye validación de parámetros
- Sigue las convenciones de nomenclatura existentes
- Actualiza la documentación si es necesario

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 📞 Contacto

Si tienes preguntas o sugerencias, no dudes en:
- Abrir un issue en GitHub
- Contactarme a través de mi perfil de GitHub

## 🏆 Reconocimientos

- Inspirado en la comunidad de administradores de sistemas Linux
- Basado en buenas prácticas de scripting en Bash
- Desarrollado para fines educativos y de automatización

---

**⭐ Si este repositorio te ha sido útil, no olvides darle una estrella ⭐**

## 📊 Estadísticas del Proyecto

- 🔢 **Total de Scripts**: 20+
- 📂 **Categorías**: 5
- 🔄 **Estado**: Activo
- 📅 **Última actualización**: Julio 2025

## 🎯 Próximas Características

- [ ] Scripts de monitoreo del sistema
- [ ] Herramientas de backup automatizado
- [ ] Scripts de instalación de software
- [ ] Utilidades de análisis de logs
- [ ] Scripts de configuración de servicios

## 📚 Recursos Adicionales

- [Guía de Bash Scripting](https://tldp.org/LDP/Bash-Beginners-Guide/html/)
- [Manual de Bash](https://www.gnu.org/software/bash/manual/)
- [ShellCheck - Linter para scripts](https://www.shellcheck.net/)
