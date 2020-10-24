<template>
    <div>
        <b-alert :show="dismissCountDown" dismissible variant="success" @dismissed="dismissCountDown=0"
                 @dismiss-count-down="countDownChanged" >
            <p class="mb-1">{{ alertUpdatedReason }}</p>
            <b-progress variant="success" :max="dismissSecs" :value="dismissCountDown" height="4px"></b-progress>
        </b-alert>
        <h3>General</h3>
        <hr />
<!--        <p>Background Color:</p>-->
<!--        <p>Font Color:</p>-->
<!--        <p>Show daily message as alert</p>-->

        <Alerts v-bind:updateSuccessAlert="showSuccessAlert"/>

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
                dismissSecs: 5,
                dismissCountDown: 0,
                alertUpdatedReason: ''
            }
        },
        methods: {
            showSuccessAlert(reason) {
                this.alertUpdatedReason = reason
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