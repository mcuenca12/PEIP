# [SPEC-XXX] Nombre de la Especificacion

## Metadatos
- ID: SPEC-XXX
- Fecha: YYYY-MM-DD
- Autor: [Nombre / Agente]
- Estado: [DRAFT | REVIEW | APPROVED]
- Epica relacionada: [Epica N - nombre] (ver .agents/memory/epics.md)

## Contexto y Objetivo
Problema o necesidad que resuelve la funcionalidad, en lenguaje de negocio.

## Roles Involucrados
- [Usuario | Entrenador | Administrador]: que puede hacer en esta funcionalidad.

## Historias de Usuario

### HU-01: [Titulo]
- Como: [Rol]
- Quiero: [Accion]
- Para: [Beneficio]

## Comportamiento por Pantalla / Flujo

### [Nombre de la pantalla o flujo]
- Punto de entrada: [Desde donde se llega]
- Informacion mostrada: [Datos visibles]
- Acciones disponibles: [Botones, gestos, navegacion de salida]
- Estados: cargando | vacio | error | exito (describir cada uno)

#### Campos de formulario (si aplica)
| Campo | Tipo | Obligatorio | Validaciones | Mensaje de error |
| :--- | :--- | :--- | :--- | :--- |
| nombre | Texto | Si | 3 a 50 caracteres | "El nombre es obligatorio" |

## Reglas de Negocio
- RN-01: [Regla]

## Requerimientos No Funcionales
- [Accesibilidad, responsividad movil/web/escritorio, rendimiento]

## Criterios de Aceptacion (Gherkin)

```gherkin
Feature: [Nombre de la funcionalidad]

  Scenario: [Camino feliz]
    Given que el usuario esta en la pantalla "[Pantalla]"
    When completa los datos validos y confirma
    Then ve el resultado esperado
    And regresa a la pantalla "[Pantalla destino]"

  Scenario: [Validacion fallida]
    Given que el usuario esta en la pantalla "[Pantalla]"
    When deja vacio el campo obligatorio "nombre" y confirma
    Then ve el mensaje "El nombre es obligatorio"
    And no se guarda ningun cambio

  Scenario: [Estado vacio]
    Given que no existen elementos
    When el usuario abre la pantalla "[Pantalla]"
    Then ve un mensaje de estado vacio
```

## Fuera de Alcance
- [Lo que explicitamente no se hara]
