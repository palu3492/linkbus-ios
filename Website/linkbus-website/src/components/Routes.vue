<template>
    <div class="my-3">
        <div class="px-2 px-sm-0">
            <h3 class="m-0">Routes</h3>
        </div>
        <hr class="m-0"/>
        <div class="mt-2 px-2 px-sm-0">
<!--            "routeId": 1, "coordinates": { "longitude": -94.3221, "latitude": 45.5605 }, "origin": "Gorecki",
"originLocation": "Gorecki Center, CSB", "destination": "Sexton", "destinationLocation":
"Sexton Commons, SJU", "city": "Saint Joseph", "state": "Minnesota", "uid": 1, "title": "Gorecki to Sexton"-->
            <div v-for="route in routes" v-bind:key="route.id" class="d-flex">
                <p class="mr-4">{{ route.title }}:</p>
                <p>{{ route.coordinates.longitude }}, {{ route.coordinates.latitude }}</p>
            </div>
        </div>
    </div>
</template>

<script>
    import {db} from "../firebase";

    const alertsCollection = db.collection('routes');

    export default {
        name: "Routes",
        components: {

        },
        props: {

        },
        data() {
            return {
                // formData: {},
                routes: [],
            }
        },
        firestore() {
            const routeDocs = alertsCollection
                .where('uid', '==', 1);
            return {
                routes: routeDocs
            }
        },
        methods: {
            async updateFirebase() {
                const data = {new: 1, ...this.routes[0]}
                try{
                    await alertsCollection.add(data);
                } catch(error) {
                    console.log('ERROR:')
                }
            }
        }
    }
</script>

<style scoped>

</style>