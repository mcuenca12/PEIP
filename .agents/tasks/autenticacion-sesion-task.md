# [TASK-002] Tareas de autenticación y sesión persistente

## Metadatos
- ID: TASK-002
- Plan asociado: [PLAN-002](../plans/autenticacion-sesion-plan.md)
- Spec asociada: [SPEC-002](../specs/autenticacion-sesion-spec.md)
- Autor: Alejandro Arango (Bloque B, entrega 4)
- Fecha: 2026-11-17
- Estado general: NOT_STARTED

## Resumen de Progreso
- [ ] Tarea 1: Dependencia e inicialización de Supabase
- [ ] Tarea 2: `AuthService` y traducción de errores
- [ ] Tarea 3: `PerfilService`
- [ ] Tarea 4: Inicio de sesión contra Supabase Auth
- [ ] Tarea 5: Registro contra Supabase Auth
- [ ] Tarea 6: Intereses del onboarding en el perfil
- [ ] Tarea 7: Cierre de sesión
- [ ] Tarea 8: Guardia de sesión al abrir la aplicación
- [ ] Tarea 9: Retiro de la contraseña simulada
- [ ] Tarea 10: Cierre y documentación

Un commit por tarea.

Dependencias externas:
- La Tarea 1 no depende de nadie y desbloquea las Tareas 3 a 7 del Bloque C. Va primero.
- La Tarea 2 solo depende de la 1.
- Desde la Tarea 3 hace falta que los scripts del Bloque A (`supabase/01_schema.sql` y `02_policies.sql`) estén desplegados en el proyecto `oqgftzulvfedjxptbltl`, y que "Confirm email" esté desactivado en Authentication.
- Las Tareas 5 y 6 usan `CatalogoService` del Bloque C. La Tarea 8 se integra con la carga inicial de `MainScreen` del Bloque C.

---

## Desglose Detallado

### - [ ] Tarea 1: Dependencia e inicialización de Supabase
- Dependencias previas: ninguna
- Archivos involucrados:
  - `pubspec.yaml` (modificar)
  - `lib/main.dart` (modificar)
- Acciones:
  - [ ] 1. Agregar `supabase_flutter: ^2.17.2` y correr `flutter pub get`.
  - [ ] 2. Declarar `supabaseUrl` y `supabaseKey` con `String.fromEnvironment('SUPABASE_URL')` y `String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY')`, los mismos nombres de `env.example.json`.
  - [ ] 3. Volver `main()` asíncrono: `WidgetsFlutterBinding.ensureInitialized()`, `await Supabase.initialize(...)` y `runApp`.
  - [ ] 4. Agregar a `PeipApp` el parámetro `initialRoute` con valor por defecto `AppRoutes.login`, para que las pruebas construyan la app sin Supabase.
  - [ ] 5. Crear `env.json` local a partir de `env.example.json` con la URL y la llave publicable del proyecto. No se commitea.
- Verificación:
  - [ ] `flutter analyze` sin problemas.
  - [ ] `flutter test` en verde (la app sigue funcionando con datos en memoria).
  - [ ] `git status` no muestra `env.json`.
  - [ ] Manual: `flutter run --dart-define-from-file=env.json` abre el login sin errores en consola.
- Commit sugerido: `chore(deps): agrega supabase_flutter e inicializa el cliente`

---

### - [ ] Tarea 2: `AuthService` y traducción de errores
- Dependencias previas: Tarea 1
- Archivos involucrados:
  - `lib/services/auth_service.dart` (crear)
  - `lib/utils/mensajes_auth.dart` (crear)
  - `test/utils/mensajes_auth_test.dart` (crear)
- Acciones:
  - [ ] 1. Crear `AuthService` con `iniciarSesion`, `registrar` (envía `nombre` e `id_ciudad` en `data`), `cerrarSesion`, y los getters `haySesion`, `idUsuarioActual` y `emailActual`. Sin capturar excepciones.
  - [ ] 2. Crear `mensajeAuth(Object error)` con los mensajes de la spec: credenciales incorrectas, correo ya registrado, contraseña corta, sin conexión y un genérico.
  - [ ] 3. Probar `mensajeAuth` con una excepción de cada tipo.
- Verificación:
  - [ ] `flutter test test/utils/mensajes_auth_test.dart` en verde.
  - [ ] `flutter analyze` sin problemas.
- Commit sugerido: `feat(services): agrega servicio de autenticacion y sus mensajes de error`

---

### - [ ] Tarea 3: `PerfilService`
- Dependencias previas: Tarea 1; esquema del Bloque A desplegado
- Archivos involucrados:
  - `lib/services/perfil_service.dart` (crear)
- Acciones:
  - [ ] 1. `cargar(idUsuario)`: leer la fila de `usuario`, sus `usuario_interes` y sus `usuario_etiqueta`, y armar el modelo con `Usuario.fromMap`, pasando el correo de la sesión.
  - [ ] 2. `guardarIntereses(idUsuario, idCategorias)`: borrar las filas del usuario en `usuario_interes` e insertar las nuevas.
- Verificación:
  - [ ] `flutter analyze` sin problemas.
  - [ ] Manual: con la cuenta demo, `cargar` devuelve los intereses sembrados por el Bloque A.
- Commit sugerido: `feat(services): agrega servicio de perfil de usuario`

---

### - [ ] Tarea 4: Inicio de sesión contra Supabase Auth
- Dependencias previas: Tareas 2 y 3
- Archivos involucrados:
  - `lib/pages/login_page.dart` (modificar)
  - `lib/screens/login_screen.dart` (modificar)
  - `test/pages/login_page_test.dart` (crear)
  - `test/widget_test.dart` (modificar)
- Acciones:
  - [ ] 1. `onLogin` pasa a `Future<String?> Function(String, String)`. Agregar `_cargando`; el botón queda deshabilitado mientras espera. Validar correo y contraseña no vacíos antes de llamar.
  - [ ] 2. Quitar las credenciales precargadas de los controladores (RN-09).
  - [ ] 3. `LoginScreen` llama a `AuthService.iniciarSesion`, carga el perfil con `PerfilService.cargar` y navega a `/main`. Ante un error devuelve `mensajeAuth(e)`. El paso del perfil por argumento es temporal hasta la Tarea 8.
  - [ ] 4. Widget tests de `LoginPage` con callbacks falsos: el mensaje de error se ve y el botón no responde mientras carga.
  - [ ] 5. Reducir `test/widget_test.dart` a comprobar que el login se construye, porque el recorrido completo dependía del login simulado. Avisar al Bloque C, que tenía este ajuste en su Tarea 7.
- Verificación:
  - [ ] `flutter test` en verde (cubre "Credenciales incorrectas").
  - [ ] `flutter analyze` sin problemas.
  - [ ] Manual: la cuenta demo entra a Explorar; una contraseña errada muestra "Correo o contraseña incorrectos."; sin wifi aparece el mensaje de conexión (cubre "Inicio de sesión exitoso" e "Inicio de sesión sin conexión").
- Commit sugerido: `feat(auth): conecta el inicio de sesion con supabase auth`

---

### - [ ] Tarea 5: Registro contra Supabase Auth
- Dependencias previas: Tarea 4; `CatalogoService` del Bloque C; trigger `handle_new_user` desplegado
- Archivos involucrados:
  - `lib/pages/registro_page.dart` (modificar)
  - `lib/screens/registro_screen.dart` (modificar)
  - `test/pages/registro_page_test.dart` (crear)
- Acciones:
  - [ ] 1. `onRegistro` pasa a asíncrono con `_cargando`, como en el login.
  - [ ] 2. `RegistroScreen` pasa a Stateful: carga ciudades con `CatalogoService` y muestra `LoadingState` o `ErrorState` con reintento.
  - [ ] 3. Conservar las validaciones locales, llamar a `AuthService.registrar` y navegar a onboarding sin argumentos.
  - [ ] 4. Widget tests de `RegistroPage`: contraseña corta y correo repetido muestran su mensaje.
- Verificación:
  - [ ] `flutter test` en verde (cubre "Registro con contraseña corta" y "Registro con correo repetido").
  - [ ] `flutter analyze` sin problemas.
  - [ ] Manual: una cuenta nueva aparece en Authentication y tiene su fila en `usuario` y en `organizador`, sin contraseña en `usuario` (cubre "Registro exitoso" y "La contraseña no queda en los datos de PEIP").
- Commit sugerido: `feat(auth): conecta el registro con supabase auth`

---

### - [ ] Tarea 6: Intereses del onboarding en el perfil
- Dependencias previas: Tareas 3 y 5
- Archivos involucrados:
  - `lib/pages/onboarding_page.dart` (modificar)
  - `lib/screens/onboarding_screen.dart` (modificar)
  - `lib/screens/preferencias_screen.dart` (modificar)
  - `test/pages/onboarding_page_test.dart` (crear)
- Acciones:
  - [ ] 1. `onTerminar` pasa a `Future<String?> Function(Set<int>)`; si falla, se muestra el error y la selección se conserva.
  - [ ] 2. `OnboardingScreen` carga categorías con `CatalogoService`; al continuar llama a `PerfilService.guardarIntereses`; con "Saltar" no guarda nada.
  - [ ] 3. `OnboardingScreen` y `PreferenciasScreen` dejan de leer un `Usuario` de los argumentos.
  - [ ] 4. Widget test: "Continuar" deshabilitado con menos de tres; "Saltar" entrega un conjunto vacío.
- Verificación:
  - [ ] `flutter test` en verde (cubre "Saltar los intereses").
  - [ ] `flutter analyze` sin problemas.
  - [ ] Manual: después del registro, `usuario_interes` tiene las tres categorías elegidas (cubre "Los intereses quedan en el perfil").
- Commit sugerido: `feat(auth): guarda los intereses del onboarding en el perfil`

---

### - [ ] Tarea 7: Cierre de sesión
- Dependencias previas: Tarea 2
- Archivos involucrados:
  - `lib/screens/main_screen.dart` (modificar)
- Acciones:
  - [ ] 1. `_cerrarSesion` llama a `AuthService.cerrarSesion` y, falle o no, navega al login limpiando la pila.
- Verificación:
  - [ ] `flutter analyze` sin problemas.
  - [ ] Manual: cerrar sesión lleva al login con los campos vacíos; atrás no regresa; al reabrir la app se ve el login (cubre "Cerrar sesión").
- Commit sugerido: `feat(auth): cierra la sesion en supabase al salir`

---

### - [ ] Tarea 8: Guardia de sesión al abrir la aplicación
- Dependencias previas: Tareas 3 y 7; carga inicial de `MainScreen` del Bloque C (su Tarea 5)
- Archivos involucrados:
  - `lib/main.dart` (modificar)
  - `lib/screens/main_screen.dart` (modificar, coordinado con el Bloque C)
  - `lib/screens/login_screen.dart` (modificar)
- Acciones:
  - [ ] 1. En `main()`, elegir `initialRoute`: `AppRoutes.main` si `AuthService.haySesion`, `AppRoutes.login` si no.
  - [ ] 2. `MainScreen` deja de leer `Usuario` de los argumentos y lo obtiene con `PerfilService.cargar(idUsuarioActual)` dentro de su carga inicial. Si falla porque la sesión ya no es válida, vuelve al login.
  - [ ] 3. `LoginScreen` navega a `/main` sin argumentos.
- Verificación:
  - [ ] `flutter analyze` y `flutter test` en verde.
  - [ ] Manual: iniciar sesión, cerrar la app por completo y abrirla entra directo a Explorar (cubre "La sesión se recuerda").
- Commit sugerido: `feat(auth): entra directo a la pantalla principal con sesion activa`

---

### - [ ] Tarea 9: Retiro de la contraseña simulada
- Dependencias previas: Tareas 4 a 8
- Archivos involucrados:
  - `lib/model/models.dart` (modificar)
  - `lib/model/mock_data.dart` (modificar)
  - `test/model/models_test.dart` (modificar si aplica)
- Acciones:
  - [ ] 1. Quitar `contrasenaHash` de `Usuario` y de `Usuario.fromMap`.
  - [ ] 2. Quitar `hashSimulado` y sus usos.
- Verificación:
  - [ ] `grep -rn "contrasenaHash\|hashSimulado" lib test` sin resultados.
  - [ ] `flutter analyze` y `flutter test` en verde.
- Commit sugerido: `refactor(model): retira la contrasena simulada del usuario`

---

### - [ ] Tarea 10: Cierre y documentación
- Dependencias previas: Tareas 1 a 9
- Archivos involucrados:
  - `README.md` (modificar)
  - `.agents/memory/epics.md` (modificar)
  - `.agents/memory/project_state.md` (modificar)
  - `.agents/specs/autenticacion-sesion-spec.md` y `.agents/plans/autenticacion-sesion-plan.md` (modificar estado)
- Acciones:
  - [ ] 1. Reemplazar en el README la sección "Usuario de prueba" por cómo crear una cuenta o usar la cuenta demo, sin escribir contraseñas.
  - [ ] 2. Marcar HU-01, HU-02 y HU-03 en `epics.md` y actualizar `project_state.md`.
  - [ ] 3. Pasar spec y plan a `COMPLETED`.
  - [ ] 4. Correr `project-architecture-auditor` y `flutter-clean-code-linter`.
- Verificación:
  - [ ] `dart format --set-exit-if-changed lib test` sin cambios.
  - [ ] `flutter analyze` y `flutter test` en verde.
  - [ ] `grep -rn "Supabase.instance.client" lib/screens lib/pages` sin resultados.
  - [ ] Cada escenario Gherkin de la spec quedó cubierto por alguna verificación de las Tareas 4 a 8.
- Commit sugerido: `docs(memory): cierra el bloque de autenticacion`
