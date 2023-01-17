<template>
    <div style="display:flex; flex-direction: column;">
    <!-- Generator Section -->
    <div class="generator">
    <img class="sprite" :src="sprite" :alt="name"/>
    <h1 class="name"> {{name}} </h1>
    <div class="row-types"><img v-for="item in typeImages" :key="item.imageURL" :src="item.imageURL" class="typeImage"/></div>
    <div class="col-buttons"><button class="genButton" v-on:click="randomPokemon()"> Generate Random </button>
    <button class="addButton" v-on:click="addPokemon()"> Add to Collection </button></div>
    <br><br><hr><br><br>
    </div>

    <!-- Collected Section -->
    <p class="error" v-if="error">{{ error }}</p>
    <div class="collect-container">
        <div style="display:flex; flex-direction:row"
            v-for="(poke, index) in collected"
            v-bind:item="poke"
            v-bind:index="index"
            v-bind:key="poke._id">

            <div class="collect">

                <img class="collect-sprite" :src="poke.sprite" :alt="name"/>

                <div style="display:flex; flex-direction: column; align-items: center; margin-top: 7px">
                    <p class="collect-name"> {{ poke.name }}</p>
                    <img v-for="item in poke.typeImages" :key="item.imageURL" :src="item.imageURL" class="collect-typeImage"/>
                </div>

            </div>

            <button class="deleteButton" v-on:click="deletePokemon(poke._id)"> Delete </button>

        </div>

    </div>
    </div>
</template>

<script>
import CollectService from '../CollectService'
export default {
    // containing our data. could be better abstracted 
    // into Pokemon objects, but we can just utilize fields 
    // of the current statebelow.
    data() {
        return {
            name: 'Bulbasaur',
            //art: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png",
            sprite: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
            type: ['grass', 'poison'],
            typeMap: this.initMap(new Map()),
            typeImages:[
                {
                    imageURL: 'https://raw.githubusercontent.com/edwinliiiii/pokerand/main/src/frontend/types/Grass.jpeg'
                },
                {
                    imageURL: 'https://raw.githubusercontent.com/edwinliiiii/pokerand/main/src/frontend/types/Poison.jpeg'
                },
            ],
            collected: [],
            error: '',
        }
    },
    // on initialization
    async created() {
        try {
            this.collected = await CollectService.getCollection()
            this.collected = this.collected.reverse()
        } catch(err) {
            this.err = err.message
        }
    },
    // all methods
    methods: {
        async randomPokemon() {
            const res = await fetch('https://pokeapi.co/api/v2/pokemon?limit=100000&offset=0')
            const allPokemon = await res.json()
                                                                                    // This handles additions and deletions to the api
            const choice = Math.floor(Math.random() * allPokemon.results.length);

            const finalRes = await fetch(allPokemon.results[choice].url) 
            const randomPokemon = await finalRes.json()

            let randomName = randomPokemon.name
            this.name = randomName.charAt(0).toUpperCase() + randomName.slice(1); // Capitalizes First Letter.
            //this.art = randomPokemon.sprites.other.official-artwork.front_default
            if (randomPokemon.sprites.front_default == null) {
              this.sprite = 'https://github.com/edwinliiiii/pokerand/blob/main/src/frontend/src/assets/pokeNotFound.png?raw=true'
            } else {
              this.sprite = randomPokemon.sprites.front_default
            } 

            // handling types
            this.type = []
            for (let i = 0; i < randomPokemon.types.length; i++) {
                this.type.push(randomPokemon.types[i].type.name)
            }
            
            this.adjustTypeImages()  // handles updating type Images
        },
        adjustTypeImages() {
            this.typeImages = []
            for (let i = 0; i < this.type.length; i++) {
                this.typeImages.push({ imageURL: this.typeMap.get(this.type[i])})
            }
        },
        initMap(map) {
                map.set('bug', "https://raw.githubusercontent.com/edwinliiiii/pokerand/main/src/frontend/types/Bug.jpeg")
                map.set('dark', "https://raw.githubusercontent.com/edwinliiiii/pokerand/main/src/frontend/types/Dark.jpeg")
                map.set('dragon', "https://raw.githubusercontent.com/edwinliiiii/pokerand/main/src/frontend/types/Dragon.jpeg")
                map.set('electric', "https://raw.githubusercontent.com/edwinliiiii/pokerand/main/src/frontend/types/Electric.jpeg")
                map.set('fairy', "https://raw.githubusercontent.com/edwinliiiii/pokerand/main/src/frontend/types/Fairy.jpeg")
                map.set('fighting', "https://raw.githubusercontent.com/edwinliiiii/pokerand/main/src/frontend/types/Fight.jpeg")
                map.set('fire', "https://raw.githubusercontent.com/edwinliiiii/pokerand/main/src/frontend/types/Fire.jpeg")
                map.set('flying', "https://raw.githubusercontent.com/edwinliiiii/pokerand/main/src/frontend/types/Flying.jpeg")
                map.set('ghost', "https://raw.githubusercontent.com/edwinliiiii/pokerand/main/src/frontend/types/Ghost.jpeg")
                map.set('grass', "https://raw.githubusercontent.com/edwinliiiii/pokerand/main/src/frontend/types/Grass.jpeg")
                map.set('ground', "https://raw.githubusercontent.com/edwinliiiii/pokerand/main/src/frontend/types/Ground.jpeg")
                map.set('ice', "https://raw.githubusercontent.com/edwinliiiii/pokerand/main/src/frontend/types/Ice.jpeg")
                map.set('normal', "https://raw.githubusercontent.com/edwinliiiii/pokerand/main/src/frontend/types/Normal.jpeg")
                map.set('poison', "https://raw.githubusercontent.com/edwinliiiii/pokerand/main/src/frontend/types/Poison.jpeg")
                map.set('psychic', "https://raw.githubusercontent.com/edwinliiiii/pokerand/main/src/frontend/types/Psychic.jpeg")
                map.set('rock', "https://raw.githubusercontent.com/edwinliiiii/pokerand/main/src/frontend/types/Rock.jpeg")
                map.set('steel', "https://raw.githubusercontent.com/edwinliiiii/pokerand/main/src/frontend/types/Steel.jpeg")
                map.set('water', "https://raw.githubusercontent.com/edwinliiiii/pokerand/main/src/frontend/types/Water.jpeg")
                map.set('water', "https://raw.githubusercontent.com/edwinliiiii/pokerand/main/src/frontend/types/Water.jpeg")
                return map
        },
        async addPokemon() {
            await CollectService.insertPoke(this.name, this.sprite, this.type, this.typeImages)
            this.collected = await CollectService.getCollection()
            this.collected = this.collected.reverse()
        },
        async deletePokemon(id) {
            await CollectService.deletePoke(id)
            this.collected = await CollectService.getCollection()
            this.collected = this.collected.reverse()
        }
    }
}
</script>

<style scoped>
#app1 {
    width: 100px;
    height: 100px;
    text-align: center;
    flex-direction: column;
    justify-content: center;
    align-items: center;
}

.name {
    margin-left: 5px;
    max-width: 350px;
    font-family: Verdana, Geneva, Tahoma, sans-serif;
    align-items: center;
}

.art {
    width: 200px;
    height: 200px;
    align-items: center;
}

.sprite {
    width: 200px;
    height: 200px;
    align-items: center;
    outline-style: solid;
    outline: 2px;
    margin-top: 10px;
}

.typeImage {
    margin: 5px;
    margin-bottom: 15px;
}

.teamTitle {
    font-family: Verdana, Geneva, Tahoma, sans-serif;
    align-items: center;
    flex-direction: column;
}

div.container { max-width: 800px; margin: 0 auto; }

p.error { border: 1px solid #ff5b5f; background-color: #ffc5c1; padding: 10px; margin-bottom: 15px; }

div.collect { position: relative; border: 1px solid darkgray; background-color: lightblue; padding: 10px 10px 30px 10px; margin-bottom: 15px; }

/*div.created-at { position: absolute; top: 0; left: 0; padding: 5px 15px 5px 15px; background-color: lightblue; } */

p.text { font-size: 22px; font-weight: 700; margin-bottom: 0; }

.genButton {
  width: 150px;
  height: 35px;
  margin:auto;
  padding:auto;
  background-color:orangered;
}
.addButton {
  width: 150px;
  height: 35px;
  margin:auto;
  padding:auto;
  background-color:lightgray;
}

.deleteButton {
  width: 60px;
  height: 20px;
  margin:auto;
  padding:auto;
  margin-left: 35px;
  background-color:lightgray;
}

.col-buttons {
    width: 150px;
    height: auto;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    margin: auto;
}

.row {
    width: 300px;
    height:100px;
    border: 1px solid black;
    border-collapse: collapse;
    align-items: center;
}

.collect-name {
    align-items: center;
    justify-content: center;
    font-family: Verdana, Geneva, Tahoma, sans-serif;
    width: 150px;
}

.collect-sprite {
    margin-top: 10px;
    margin-left: 15px;
    width: 150px;
    height: auto
}

.collect-container {
    position: relative;
}

.collect-typeImage {
    width: 65px;
    height:auto;
   /*padding-bottom:8px; */
}

.collect {
    width: 250px;
    height: 100px;
    position: relative;
    display: flex;
    flex-direction: row;
}
</style>
