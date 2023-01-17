<template>
    <button class="addButton"> Add to Collection</button>
    <hr>
    <div class="row">

    </div>
    <div class="row">

    </div>
</template>

<script> 

export default {
    data() {

    }
}

</script>

<style>

#app2 {
    width: 50px;
    height: 100px;
    text-align: center;
    flex-direction: column;
    justify-content: center;
    align-items: center;
}

.teamTitle {
    font-family: Verdana, Geneva, Tahoma, sans-serif;
    align-items: center;
}

.row {
    width: 300px;
    height:100px;
    border: 1px solid black;
    border-collapse: collapse;
    align-items: center;
}

</style>

<style scoped>

div.container { max-width: 800px; margin: 0 auto; }

p.error { border: 1px solid #ff5b5f; background-color: #ffc5c1; padding: 10px; margin-bottom: 15px; }

div.collect { position: relative; border: 1px solid lightblue; background-color: 3bcffb8; padding: 10px 10px 30px 10px; margin-bottom: 15px; }

div.created-at { position: absolute; top: 0; left: 0; padding: 5px 15px 5px 15px; background-color: lightblue; }

p.text { font-size: 22px; font-weight: 700; margin-bottom: 0; }

</style>