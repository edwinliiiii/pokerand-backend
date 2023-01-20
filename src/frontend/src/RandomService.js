import axios from 'axios'

const url = 'http://localhost:5000/api/random/'

class RandomService {
    // Get Random
    static getRandom() {
        return new Promise ((resolve,reject) => {
            axios.get(url).then((res) => {
                const data = res.data;
                resolve( data );
            })
            .catch((err) => {
                console.log(err.message)
                reject(err);
            })
        });
    }
}

export default RandomService
