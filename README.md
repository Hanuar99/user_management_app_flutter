# User Management App - Flutter

Aplicación móvil desarrollada en Flutter para la gestión de usuarios y direcciones, construida como prueba técnica demostrando dominio de arquitectura limpia, buenas prácticas de desarrollo y testing profesional.

---

## 🚀 Descripción General

La aplicación permite administrar usuarios y sus direcciones asociadas de manera completamente local, con persistencia entre sesiones y una interfaz moderna e intuitiva.

El proyecto fue desarrollado siguiendo principios de código limpio, separación de responsabilidades y arquitectura escalable.

---

## 🎯 Funcionalidades Implementadas

### 👤 Gestión de Usuarios

- Crear, editar y eliminar usuarios.
- Validaciones en tiempo real:
  - Nombre y apellido obligatorios (mínimo 2 caracteres).
  - Email con formato válido.
  - Teléfono con formato regional.
  - Fecha de nacimiento válida (edad entre 18 y 100 años).
- Búsqueda y filtrado dinámico de usuarios.
- Persistencia local de la información.
- Visualización detallada de cada usuario.

### 🏠 Gestión de Direcciones

Cada usuario puede tener múltiples direcciones con:

- Calle y número.
- Barrio o colonia.
- Ciudad.
- Estado o provincia.
- Código postal.
- Etiqueta (Casa, Trabajo, Otro).
- Marcar una dirección como principal.
- CRUD completo de direcciones.

---

## 📱 Pantallas del Sistema

La aplicación incluye las siguientes pantallas principales:

1. Lista de usuarios con búsqueda.
2. Formulario de usuario (crear y editar).
3. Gestión de direcciones por usuario.
4. Detalle completo del usuario.

---

## 🧩 Arquitectura del Proyecto

Se implementó Clean Architecture con separación clara en capas:

```
lib/
├── core/
│ ├── constants/
│ ├── di/
│ ├── errors/
│ ├── hive/
│ ├── routes/
│ ├── theme/
│ ├── usecases/
│ ├── validators/
│ └── utils/
├── data/
│ ├── datasources/
│ │ ├── address_local_datasource/
│ │ └── user_local_datasource/
│ ├── models/
│ │ ├── address_model/
│ │ └── user_model/
│ └── repositories/
│ ├── address_repository_impl/
│ └── user_repository_impl/
├── domain/
│ ├── entities/
│ │ ├── user/
│ │ └── address/
│ ├── repositories/
│ │ ├── address_repository/
│ │ └── user_repository/
│ └── usecases/
│ ├── user/
│ └── addresses/
├── presentation/
│ ├── blocs/
│ │ ├── user_form/
│ │ ├── user_detail/
│ │ └── user_list/
│ ├── pages/
│ │ ├── user_form/
│ │ ├── user_detail/
│ │ ├── user_list/
│ │ └── address/
│ └── widgets/
└── main.dart
```

### Beneficios

- Alta mantenibilidad.
- Código desacoplado.
- Fácil escalabilidad.
- Testing sencillo y efectivo.
- Separación real entre UI y lógica de negocio.

---

## 🛠 Tecnologías Utilizadas

- Flutter
- Dart
- flutter_bloc (BLoC Pattern)
- Hive (Base de datos local)
- GetIt (Inyección de dependencias)
- GoRouter (Navegación)
- Equatable
- Intl

---

## 💾 Persistencia de Datos

Se utilizó Hive como motor de almacenamiento local por:

- Alto rendimiento.
- Sencillez de integración.
- Base de datos ligera.
- Persistencia offline sin configuración compleja.

---

## 🧪 Testing

El proyecto incluye pruebas automatizadas profesionales:

### Tipos de Pruebas

#### Unit Tests

- Casos de uso.
- Repositorios.
- Validaciones.
- Lógica de negocio.

#### Widget Tests

- Renderizado de pantallas.
- Interacciones con el usuario.
- Estados de carga, éxito y error.

### Herramientas Utilizadas

- flutter_test
- mocktail
- bloc_test

### Cobertura

Se alcanzó una cobertura de pruebas superior al 60% cumpliendo con los requisitos solicitados.

---

## ⚙️ Instalación y Ejecución

### Pasos para Ejecutar

1. Clonar repositorio

```
git clone https://github.com/tu_usuario/user_management_app_flutter.git
```

2. Entrar al proyecto

```
cd user_management_app_flutter
```

3. Instalar dependencias

```
flutter pub get
```

4. Ejecutar generadores

```
flutter pub run build_runner build --delete-conflicting-outputs
```

5. Ejecutar la aplicación

```
flutter run
```

---

## 🧪 Ejecutar Pruebas

Para ejecutar todas las pruebas:

```
flutter test
```

Para obtener reporte de cobertura:

```
flutter test --coverage
```

---

## 🧠 Decisiones Técnicas

### ¿Por qué BLoC?

- Arquitectura predecible.
- Separación clara de responsabilidades.
- Excelente soporte para pruebas.
- Escalable a proyectos grandes.

### ¿Por qué Hive?

- Base de datos local rápida.
- Fácil de integrar.
- Ideal para prototipos y pruebas técnicas.
- Persistencia estructurada sin backend.

---

## 👨‍💻 Autor

**Hanuar Rubio**  
Flutter Mobile Developer  

---
