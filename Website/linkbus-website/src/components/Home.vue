<template>
    <div>
        <b-alert v-model="showDatabaseUpdateAlert" variant="success" dismissible>
            Alert Saved!
        </b-alert>
        <h3>General</h3>
        <hr />
<!--        <p>Background Color:</p>-->
<!--        <p>Font Color:</p>-->
<!--        <p>Show daily message as alert</p>-->

        <Alerts v-bind:updateSuccessAlert="updateSuccessAlert"/>

        <h3 class="mt-3">Routes</h3>
        <hr />
    </div>
</template>

<script>
    import Alerts from './Alerts.vue'

    export default {
        name: "Home",
        components: {
            Alerts
        },
        data() {
            return {
                showDatabaseUpdateAlert: false
            }
        },
        methods: {
            updateSuccessAlert() {
                this.showDatabaseUpdateAlert = true
            }
        }
    }
</script>

<style scoped>
    h1{
        text-align: center;
    }
    h3{
        margin-bottom: 0;
    }
    hr{
        margin-top: 0;
    }
</style>