<template>
    <img class="sprite" :src="sprite" :alt="name"/>
    <h1 class="name"> {{name}} </h1>
    <div class="row-types"><img v-for="item in typeImages" :key="item.imageURL" :src="item.imageURL" class="typeImage"/></div>
    <button class="genButton" v-on:click="randomPokemon()"> Generate Random </button>
</template>

<script>
export default {
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
        }
    },
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
              this.sprite = 'src/frontend/src/components/pokeNotFound.png'
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
        }
    }
}
</script>

<style>
#app1 {
    width: 50px;
    height: 100px;
    text-align: center;
    flex-direction: column;
    justify-content: center;
    align-items: center;
}

.name {
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
}

.typeImage {
    margin: 5px;
    margin-bottom: 10px;
}


</style>