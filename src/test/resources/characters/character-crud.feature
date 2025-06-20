@flow
Feature: Flujo completo CRUD de personajes

    Background:
        * url baseUrl
        * def basePath = '/' + username + '/api/characters'

        # Nuevo personaje
        * def uuid = java.util.UUID.randomUUID().toString()
        * def newCharFn = function(){ return { name: "Name" + uuid, alterego: "Alter" + uuid, description: "Desc" + uuid, powers: ['Flight'] } }
        * def newChar = call newCharFn

        # Schemas
        * def characterSchema = { id: '#number', name: '#string', alterego: '#string', description: '#string', powers: '#[]' }
        * def errorSchema = { error: "#string" }

    Scenario: Crear, leer, actualizar, eliminar

        # --- Crear Personaje (exitoso) ---
        # Se comprueba que el personaje creado cumpla con la estructura JSON definida.
        Given path basePath
        And request newChar
        And header Content-Type = 'application/json'
        When method post
        Then status 201
        And match response == characterSchema
        And match response contains { id: '#number' }
        And match response.name == "#(newChar.name)"
        And match response.alterego == "#(newChar.alterego)"
        And match response.powers == "#(newChar.powers)"
        * def id = response.id

        # --- Leer detalle ---
        # Se usa el ID del personaje que se acaba de crear para decuperar sus detalles.
        Given path basePath, id
        When method get
        Then status 200
        And match response == characterSchema
        And match response.id == id

        # --- Duplicado (400) ---
        Given path basePath
        And request newChar
        And header Content-Type = 'application/json'
        When method post
        Then status 400
        And match response == errorSchema
        And match response.error contains 'exists'

        # --- Campos faltantes (400) ---
        * def badChar = read('classpath:data/invalid-character.json')
        Given path basePath
        And request badChar
        And header Content-Type = 'application/json'
        When method post
        Then status 400
        # Name and alterego are required
        And match response contains { name: '#string', alterego: '#string' }
        And match response.name == '#regex .*required.*'
        And match response.alterego == '#regex .*required.*'

        # --- Update éxito ---
        * def updated = newChar
        * updated.description = 'Descripción actualizada'
        Given path basePath, id
        And request updated
        And header Content-Type = 'application/json'
        When method put
        Then status 200
        And match response == characterSchema
        And match response.description == 'Descripción actualizada'

        # --- Update 404 ---
        Given path basePath, 999999
        And request updated
        And header Content-Type = 'application/json'
        When method put
        Then status 404
        And match response == errorSchema

        # --- Delete éxito ---
        Given path basePath, id
        When method delete
        Then status 204

        # --- Delete 404 ---
        Given path basePath, id
        When method delete
        Then status 404
        And match response == errorSchema