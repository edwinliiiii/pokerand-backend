import axios from 'axios'

const url = 'http://localhost:5000/api/team/'

class CollectService {
    // Get Collection
    static getCollection() {
        return new Promise ((resolve,reject) => {
            axios.get(url).then((res) => {
                const data = res.data;
                resolve(
                    data.map(poke => ({
                        ...poke,
                    }))
                );
            })
            .catch((err)=> {
                reject(err);
            })
        });
    }

    // Add to Collection
    static insertPoke(name, sprite, type, typeImages) {
        return axios.post(url, {
            name,
            sprite,
            type,
            typeImages,
        })
    }

    // Delete from Collection
    static deletePoke(id) {
        return axios.delete(
            `${url}${id}`
        )
    }
}

export default CollectService
