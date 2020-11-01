<template>
    <div>
        <!-- Alert notifications -->
        <b-alert :show="dismissCountDown" dismissible :variant="dbStatus" @dismissed="dismissCountDown=0"
                 @dismiss-count-down="countDownChanged">
            <p class="mb-1">{{ alertUpdatedReason }}</p>
            <b-progress :variant="dbStatus" :max="dismissSecs" :value="dismissCountDown" height="4px"></b-progress>
        </b-alert>
        <!-- GENERAL -->
        <General />
        <!-- ALERTS -->
        <Alerts v-bind:updateSuccessAlert="showSuccessAlert" v-bind:signedIn="signedIn" v-bind:user="user"/>
        <!-- ROUTES -->
        <Routes />
    </div>
</template>

<script>
    import Alerts from './Alerts.vue'
    import Routes from "./Routes";
    import General from "./General";

    export default {
        name: "Home",
        components: {
            Routes, Alerts, General
        },
        props: {
            signedIn: Boolean,
            user: Object
        },
        data() {
            return {
                dismissSecs: 5,
                dismissCountDown: 0,
                alertUpdatedReason: '',
                dbStatus: ''
            }
        },
        methods: {
            showSuccessAlert(reason, status) {
                this.alertUpdatedReason = reason
                this.dbStatus = status
                this.dismissCountDown = this.dismissSecs
            },
            countDownChanged(dismissCountDown) {
                this.dismissCountDown = dismissCountDown
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