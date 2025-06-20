# Prueba testing - Bryan Fonseca

Esta suite automatizada valida el comportamiento de la API REST de personajes de Marvel usando Karate.
Las pruebas están organizadas estratégicamente en pruebas de humo (smoke) y pruebas de flujo (flow), siguiendo buenas prácticas de diseño y mantenimiento de pruebas para aplicaciones backend.

## Justificación: ¿Por qué todo el flujo CRUD en un solo scenario?

El testing en Karate se ve beneficiado de las buenas prácticas, como los principios FIRST, donde se indica que los test deben ser atomicos, independientes y repetibles.
Mantener todo el flujo en un solo Sceneario nos permite no solamente simular un E2E, sino también permitir paralelismo, ya que ningún Scenario depende de otro, y Karate puede hacer uso de múltiples hilos para ejecutar la suite con mayor velocidad.
