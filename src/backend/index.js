const express = require('express')
const bodyParser = require('body-parser')
const cors = require('cors')

const app = express()

// Middleware
app.use(bodyParser.json())
app.use(cors())

const team = require('./routes/api/team')
const random = require('./routes/api/random')

app.use('/api/team', team)
app.use('/api/random', random)

const port = process.env.PORT || 5000
app.listen(port, () => console.log(`Server started on port:  + ${port}`))
