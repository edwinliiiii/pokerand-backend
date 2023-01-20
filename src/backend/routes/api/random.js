// generate and return a random pokemon from PokeAPI
const allPokemon = require('./allPokemon.json')

const express = require('express')
const { json } = require('body-parser')
const router = express.Router()

// Get Random Pokemon (GET)
router.get('/', async (req, res) => {
    const hit = randomPokemon()
    res.send(hit)
})

function randomPokemon() {
    const random = Math.floor(Math.random() * allPokemon.results.length)
    const hit = allPokemon.results[random].url
    return hit
}

module.exports = router
