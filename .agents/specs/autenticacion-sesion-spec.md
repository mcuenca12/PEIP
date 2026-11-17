# [SPEC-002] Autenticación y sesión persistente

## Metadatos
- ID: SPEC-002
- Fecha: 2026-11-16
- Autor: Alejandro Arango (Bloque B, entrega 4)
- Estado: DRAFT
- Épica relacionada: Épica 1 - Autenticación y gestión de usuarios (HU-01, HU-02, HU-03). Toca también RF-02 (onboarding de intereses). Ver .agents/memory/epics.md

## Contexto y Objetivo
Hoy el inicio de sesión de PEIP compara el correo y la contraseña contra una lista que vive en memoria. Las cuentas creadas en el registro desaparecen al cerrar la aplicación, la contraseña se guarda junto a los datos del usuario y cada vez que se abre la aplicación hay que volver a iniciar sesión.

Esta especificación define cómo se comportan el registro, el inicio y el cierre de sesión cuando pasan a un servicio de autenticación en la nube:

1. Las cuentas existen de verdad y sobreviven al cierre de la aplicación.
2. La contraseña la gestiona el servicio de autenticación y nunca se guarda en la información propia de PEIP.
3. La aplicación recuerda la sesión: quien ya inició sesión entra directo a la pantalla principal.
4. Lo que el usuario elige al registrarse (ciudad e intereses) queda en su perfil y alimenta las recomendaciones desde el primer momento.

Las pantallas conservan su apariencia y su recorrido actual. Cambia de dónde salen y adónde van los datos.

## Roles Involucrados
- Visitante sin sesión: puede iniciar sesión o crear una cuenta. No accede a la pantalla principal.
- Asistente: inicia y cierra sesión, y su sesión se conserva entre aperturas de la aplicación.
- Organizador: toda cuenta nueva queda habilitada también para publicar eventos, sin pasos adicionales.

## Historias de Usuario

### HU-01: Registro de cuenta
- Como: Visitante
- Quiero: crear una cuenta con mi nombre, correo, contraseña y ciudad, y elegir mis intereses
- Para: empezar a recibir recomendaciones pensadas para mí

### HU-02: Inicio y cierre de sesión
- Como: Usuario registrado
- Quiero: iniciar sesión con mi correo y contraseña, y cerrarla cuando termine
- Para: acceder a mi información y dejarla protegida cuando no uso la aplicación

### HU-03: Sesión persistente
- Como: Usuario con sesión iniciada
- Quiero: que la aplicación me recuerde al volver a abrirla
- Para: no escribir mis datos cada vez

## Comportamiento por Pantalla / Flujo

### Apertura de la aplicación
- Punto de entrada: el usuario abre la aplicación.
- Comportamiento:
  - Si hay una sesión vigente, entra directo a la pantalla principal sin ver el inicio de sesión.
  - Si no hay sesión, o la sesión guardada ya no es válida, ve la pantalla de inicio de sesión.
- Estados:
  - cargando: mientras se comprueba si hay sesión, no se muestra ni el inicio de sesión ni la pantalla principal, para que el usuario no vea un parpadeo entre las dos.
  - éxito: se muestra la pantalla que corresponde.

### Inicio de sesión
- Punto de entrada: apertura sin sesión, o después de cerrar sesión.
- Información mostrada: presentación de PEIP, campos de correo y contraseña, enlace para crear cuenta.
- Acciones disponibles: iniciar sesión; ir al registro.
- Estados:
  - cargando: mientras se validan las credenciales, el botón "Iniciar sesión" no admite un segundo toque y muestra que está trabajando.
  - error: el mensaje aparece debajo de los campos y el usuario sigue en la misma pantalla, con lo que escribió intacto.
  - éxito: entra a la pantalla principal. Con el botón atrás no se puede volver al inicio de sesión.

#### Campos de formulario
| Campo | Tipo | Obligatorio | Validaciones | Mensaje de error |
| :--- | :--- | :--- | :--- | :--- |
| Correo | Correo electrónico | Sí | Formato de correo | "Escribe un correo válido." |
| Contraseña | Texto oculto | Sí | No vacía | "Escribe tu contraseña." |

Mensajes adicionales:
- Credenciales incorrectas: "Correo o contraseña incorrectos." El mensaje no indica cuál de los dos falló.
- Sin conexión: "No pudimos conectarnos. Revisa tu conexión e inténtalo de nuevo."

### Registro, paso 1 de 3: datos de la cuenta
- Punto de entrada: enlace "¿No tienes cuenta? Regístrate" del inicio de sesión.
- Información mostrada: indicador de paso 1 de 3, formulario de cuenta, listado de ciudades disponibles.
- Acciones disponibles: registrarse; volver al inicio de sesión.
- Estados:
  - cargando: el listado de ciudades se está consultando, o la cuenta se está creando; el botón "Registrarme" no admite un segundo toque.
  - error: mensaje debajo del formulario, sin perder lo escrito.
  - éxito: la cuenta queda creada con su sesión iniciada y el usuario pasa al paso 2.

#### Campos de formulario
| Campo | Tipo | Obligatorio | Validaciones | Mensaje de error |
| :--- | :--- | :--- | :--- | :--- |
| Nombre | Texto | Sí | No vacío | "Escribe un nombre y un correo válido." |
| Correo | Correo electrónico | Sí | Formato de correo; no registrado antes | "Escribe un nombre y un correo válido." / "Ese correo ya está registrado." |
| Contraseña | Texto oculto | Sí | Mínimo 6 caracteres | "La contraseña debe tener al menos 6 caracteres." |
| Ciudad | Selección de una opción | Sí | Una de las ciudades del catálogo | (siempre hay una seleccionada) |

### Registro, paso 2 de 3: intereses
- Punto de entrada: registro exitoso.
- Información mostrada: indicador de paso 2 de 3, las doce áreas de interés, cantidad seleccionada.
- Acciones disponibles: seleccionar y quitar áreas; continuar (habilitado con tres o más); saltar.
- Estados:
  - cargando: mientras se guardan los intereses, "Continuar" no admite un segundo toque.
  - error: aviso de que no se pudieron guardar, con la selección intacta para volver a intentar.
  - éxito: los intereses quedan en el perfil del usuario y pasa al paso 3.

### Registro, paso 3 de 3: preferencias
- Sin cambios de comportamiento. "Empezar a explorar" lleva a la pantalla principal. Las respuestas de este paso no se guardan en esta entrega (ver Fuera de Alcance).

### Cierre de sesión
- Punto de entrada: botón "Cerrar sesión" en Ajustes.
- Comportamiento: la sesión se cierra en el servicio de autenticación, se descarta la información del usuario que estaba en pantalla y se vuelve al inicio de sesión.
- Estados:
  - éxito: el usuario ve el inicio de sesión con los campos vacíos. Con el botón atrás no puede volver a la pantalla principal.
  - error: si no hay conexión, la sesión se cierra igual en el dispositivo. El usuario nunca queda atrapado dentro de su cuenta.

## Reglas de Negocio
- RN-01 Credenciales: la contraseña la gestiona el servicio de autenticación. La información propia de PEIP no guarda contraseñas ni versiones cifradas de ellas.
- RN-02 Perfil automático: al crear una cuenta, el sistema crea su perfil con el nombre y la ciudad del formulario, y la habilita como organizador. La aplicación no tiene que dar un paso aparte para lograrlo.
- RN-03 Correo único: no pueden existir dos cuentas con el mismo correo, sin importar mayúsculas y minúsculas.
- RN-04 Cuenta activa de inmediato: la cuenta queda lista para usarse al terminar el paso 1, sin confirmar el correo. Supuesto que el equipo debe confirmar (ver Fuera de Alcance).
- RN-05 Intereses: al continuar desde el paso 2 se guardan los intereses elegidos, mínimo tres. Si el usuario salta el paso, su perfil queda sin intereses y puede definirlos después desde Ajustes.
- RN-06 Sesión persistente: la sesión se conserva al cerrar y volver a abrir la aplicación hasta que el usuario cierre sesión o la sesión deje de ser válida.
- RN-07 Acceso protegido: la pantalla principal y todo lo que cuelga de ella solo se muestran con una sesión vigente.
- RN-08 Mensajes sin pistas: el error de inicio de sesión no revela si el correo existe.
- RN-09 Formularios limpios: el inicio de sesión no viene diligenciado con credenciales de ninguna cuenta.

## Requerimientos No Funcionales
- Seguridad: las llaves de conexión con el servicio no se escriben en el código ni se suben al repositorio. Se documentan sus nombres para que cualquier integrante pueda configurarlas.
- Experiencia: toda operación remota de esta funcionalidad tiene estado de carga y mensaje de error en lenguaje del usuario, sin códigos técnicos.
- Rendimiento: comprobar la sesión al abrir la aplicación no debe exigir conexión a internet cuando la sesión guardada sigue vigente.

## Criterios de Aceptación (Gherkin)

```gherkin
Feature: Autenticación y sesión persistente

  Scenario: Registro exitoso
    Given que Carla está en la pantalla "Crear cuenta"
    When escribe su nombre, un correo nuevo, una contraseña de 6 caracteres, elige "Cali" y toca "Registrarme"
    Then pasa al paso "¿Qué te mueve?"
    And su perfil existe con el nombre "Carla" y la ciudad "Cali"

  Scenario: Registro con correo repetido
    Given que ya existe una cuenta con el correo "ana.torres@icesi.edu.co"
    When alguien intenta registrarse con "ANA.TORRES@icesi.edu.co"
    Then ve el mensaje "Ese correo ya está registrado."
    And sigue en la pantalla "Crear cuenta"

  Scenario: Registro con contraseña corta
    Given que Carla está en la pantalla "Crear cuenta"
    When escribe una contraseña de 4 caracteres y toca "Registrarme"
    Then ve el mensaje "La contraseña debe tener al menos 6 caracteres."
    And no se crea ninguna cuenta

  Scenario: Los intereses quedan en el perfil
    Given que Carla acaba de crear su cuenta
    When elige "Leadership", "Innovation" y "Research" y toca "Continuar"
    Then esos tres intereses quedan guardados en su perfil
    And al terminar el registro ve los eventos ordenados según esos intereses

  Scenario: Saltar los intereses
    Given que Carla acaba de crear su cuenta
    When toca "Saltar"
    Then pasa al paso 3 sin intereses guardados

  Scenario: Inicio de sesión exitoso
    Given que Ana tiene una cuenta y está en la pantalla de inicio de sesión
    When escribe su correo y su contraseña y toca "Iniciar sesión"
    Then entra a la pestaña "Explorar"
    And al tocar atrás no vuelve al inicio de sesión

  Scenario: Credenciales incorrectas
    Given que Ana está en la pantalla de inicio de sesión
    When escribe una contraseña equivocada y toca "Iniciar sesión"
    Then ve el mensaje "Correo o contraseña incorrectos."
    And sigue en la pantalla de inicio de sesión con su correo escrito

  Scenario: Inicio de sesión sin conexión
    Given que el dispositivo no tiene conexión
    When Ana intenta iniciar sesión
    Then ve un mensaje que le pide revisar su conexión

  Scenario: La sesión se recuerda
    Given que Ana inició sesión
    When cierra la aplicación y la vuelve a abrir
    Then entra directo a la pantalla principal sin ver el inicio de sesión

  Scenario: Cerrar sesión
    Given que Ana tiene sesión iniciada y está en "Ajustes"
    When toca "Cerrar sesión"
    Then ve la pantalla de inicio de sesión con los campos vacíos
    And al cerrar y abrir la aplicación sigue viendo el inicio de sesión

  Scenario: La contraseña no queda en los datos de PEIP
    Given que Carla creó su cuenta
    When se revisa la información propia de PEIP
    Then su perfil no contiene su contraseña ni una versión cifrada de ella
```

## Fuera de Alcance
- Confirmación de correo, recuperación y cambio de contraseña. RN-04 asume que la confirmación está desactivada; si el equipo decide activarla, esta especificación debe actualizarse.
- Inicio de sesión con Google u otros proveedores.
- Edición del nombre y la ciudad desde Ajustes.
- Guardar los cambios de intereses y del interruptor de personalización hechos desde Ajustes. No está asignado a ningún bloque; queda pendiente de definir con el equipo.
- Guardar las respuestas del paso 3 (formato y horario preferidos). El modelo de datos no tiene dónde guardarlas.
- Definición de tablas y permisos por usuario (Bloque A), carga de catálogos y del resto de la información en la pantalla principal (Bloque C).
