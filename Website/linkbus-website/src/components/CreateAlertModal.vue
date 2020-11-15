<template>
    <b-modal id="bv-modal-create" v-model="showModal" ref="createModal" @hide="handleHideEvent">
        <div slot="modal-header" class="m-modal-header">
            <h5 class="modal-title">Create New Alert</h5>
            <button type="button" aria-label="Close" class="close" @click="hideModal(); reset();">×</button>
        </div>
        <b-overlay :show="updatingDatabase" rounded="sm" variant="light" spinner-variant="primary">
            <AlertCustomizeModal v-bind:formData="formData" v-bind:start="start" v-bind:end="end"
                                 v-bind:indefinite="indefinite"/>
        </b-overlay>
        <div slot="modal-footer">
            <b-button class="mx-1" variant="dark" @click="hideModal(); reset();">Cancel</b-button>
            <b-button class="mx-1" variant="success" @click="updateFirebase">Create</b-button>
        </div>
    </b-modal>
</template>

<script>
    import AlertCustomizeModal from "./AlertCustomizeModal";
    import {db} from "../firebase";
    import firebase from 'firebase/app'
    const { serverTimestamp } = firebase.firestore.FieldValue;

    const getDate = () => {
        const today = new Date();
        const dd = today.getDate();
        const mm = today.getMonth()+1;
        const yyyy = today.getFullYear();
        return `${yyyy}-${mm}-${dd}`
    }
    const getTime = () => {
        const today = new Date();
        const hour = today.getHours()
        const minute = today.getMinutes()
        return `${hour}:${minute}:00`
    }
    const getDateTime = (dateTime) => {
        // console.log(dateTime)
        if(dateTime.date === ""){
            return ""
        }
        return `${dateTime.date} ${dateTime.time}`
    }

    const formDataDefault = {
        text: "",
        active: true,
        clickable: false,
        action: "",
        color: "red",
        colorCode: "#46d8e2",
        fullWidth: false
    };

    export default {
        name: "CreateModal",
        components: {
            AlertCustomizeModal
        },
        props: {
            showModal: Boolean,
            hideModal: Function,
            updateSuccessAlert: Function,
            user: Object
        },
        data() {
            return {
                formData: { ...formDataDefault },
                updatingDatabase: false,
                indefinite: {
                    indefinite: true
                },
                start: {
                    date: getDate(),
                    time: getTime()
                },
                end: {
                    date: getDate(),
                    time: getTime()
                }
            }
        },
        methods: {
            async updateFirebase() {
                this.updatingDatabase = true
                const alertData = { ...this.formData };
                alertData.rgb = this.rgb()
                alertData.uid = this.user.uid
                alertData.created = serverTimestamp()
                alertData.updated = null
                alertData.start = firebase.firestore.Timestamp.fromDate(new Date(getDateTime(this.start)));
                if(!this.indefinite.indefinite){
                    alertData.end = firebase.firestore.Timestamp.fromDate(new Date(getDateTime(this.end)));
                } else {
                    alertData.end = ""
                }
                try{
                    await db.collection('alerts').add(alertData)
                    this.updateSuccessAlert('Alert Created!', 'success')
                } catch(error) {
                    console.log('ERROR:')
                    console.log(error)
                    this.updateSuccessAlert('Database communiction error', 'danger')
                }
                this.hideModal()
                this.updatingDatabase = false
                this.reset()
            },
            rgb() {
                const hexToRgb = (color, start, end) => {
                    let value = parseInt(color.slice(start, end), 16) / 255;
                    value = Math.round(value * 100) / 100
                    if(typeof value !== "number"){
                        value = 0
                    }
                    return value
                }
                let red, green, blue, opacity;
                red = hexToRgb(this.formData.colorCode,1, 3)
                green = hexToRgb(this.formData.colorCode,3, 5)
                blue = hexToRgb(this.formData.colorCode,5, 7)
                opacity = 1.0
                return {
                    red: red,
                    green: green,
                    blue: blue,
                    opacity: opacity
                }
            },
            reset() {
                this.formData = { ...formDataDefault }
                this.start = {
                    date: getDate(),
                    time: getTime()
                }
                this.end = {
                    date: getDate(),
                    time: getTime()
                }
                this.indefinite.indefinite = true
            },
            handleHideEvent() {
                if(this.showModal === true){
                    this.hideModal();
                }
            }
        }
    }
</script>

<style scoped>
    .m-modal-header {
        display: flex;
        justify-content: space-between;
        width: 100%;
        align-items: baseline;
    }
</style>