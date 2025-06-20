@flow
Feature: Flujo completo CRUD de personajes

    Background:
        * url baseUrl
        * def basePath = '/' + username + '/api/characters'
        * def uuid = java.util.UUID.randomUUID().toString()
        * def newCharFn = function(){ return { name: "Name" + uuid, alterego: "Alter" + uuid, description: "Desc" + uuid, powers: ['Flight'] } }
        * def newChar = call newCharFn
        * print newChar

    Scenario: Crear, leer, actualizar, eliminar

        # --- Crear Personaje (exitoso) ---
        Given path basePath
        And request newChar
        And header Content-Type = 'application/json'
        When method post
        Then status 201
        And match response == { id: '#number', name: '#(newChar.name)', alterego: '#(newChar.alterego)', description: '#(newChar.description)', powers: '#(newChar.powers)' }
        * def id = response.id

        # --- Leer detalle ---
        Given path basePath, id
        When method get
        Then status 200
        And match response.id == id

        # --- Duplicado (400) ---
        Given path basePath
        And request newChar
        And header Content-Type = 'application/json'
        When method post
        Then status 400
        And match response.error contains 'exists'

        # --- Campos faltantes (400) ---
        * def badChar = { name: '', alterego: '', description: '', powers: [] }
        Given path basePath
        And request badChar
        And header Content-Type = 'application/json'
        When method post
        Then status 400
        # Name is required
        And match response contains { name: '#string', alterego: '#string' }

        # --- Update éxito ---
        * def updated = newChar
        * updated.description = 'Descripción actualizada'
        Given path basePath, id
        And request updated
        And header Content-Type = 'application/json'
        When method put
        Then status 200
        And match response.description == 'Descripción actualizada'

        # --- Update 404 ---
        Given path basePath, 999999
        And request updated
        And header Content-Type = 'application/json'
        When method put
        Then status 404

        # --- Delete éxito ---
        Given path basePath, id
        When method delete
        Then status 204

        # --- Delete 404 ---
        Given path basePath, id
        When method delete
        Then status 404