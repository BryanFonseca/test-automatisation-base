@smoke
Feature: Pruebas de humo para Marvel Characters

    Background:
        * url baseUrl
        * def basePath = '/' + username + '/api/characters'

    Scenario: GET list
        Given path basePath
        When method get
        Then status 200
        # Comprueba que la lista está retornando un arreglo lleno o vacío
        And match response == "#[]"

    Scenario: GET by ID
        Given path basePath, 1
        When method get
        # Dado que karate no evalúa múltiples status, se comprueba con JS
        * assert responseStatus == 200 || responseStatus == 404
