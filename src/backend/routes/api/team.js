// add, delete, or replace pokemon on your team.

const express = require('express')
const mongodb = require('mongodb')

const router = express.Router()

// Get Current Team (GET)
router.get('/', async (req, res) => {
    const team = await loadTeamCollection()

    res.send(await team.find({}).toArray())
})

// Add Pokemon to Team (POST)
router.post('/', async (req, res) => {
    const team = await loadTeamCollection()
    await team.insertOne({
        name: req.body.name,
        sprite: req.body.sprite,
        type: req.body.type,
        typeImages: req.body.typeImages
    })
    res.status(201).send()
})

// Delete Pokemon on Team

router.delete('/:id', async (req, res) => {
    const team = await loadTeamCollection()
    await team.deleteOne({_id: new mongodb.ObjectId(req.params.id)})
    res.status(200).send()
})

// Replace, which utlilizes deleting and then adding.

async function loadTeamCollection() {
    const client = await mongodb.MongoClient.connect('mongodb+srv://currentUser:12345@pokemon-vue-express.y3wbvor.mongodb.net/?retryWrites=true&w=majority', {
        useNewUrlParser: true
    })

    return client.db('pokemon-vue-express').collection('posts')
}

module.exports = router
