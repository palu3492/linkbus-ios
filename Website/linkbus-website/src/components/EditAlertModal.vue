<template>
    <b-modal id="bv-modal-edit" v-model="showModal">
        <div slot="modal-header" class="m-modal-header">
            <div>
                <h5 class="modal-title">Edit Alert</h5>
                <p class="m-0 small text-muted">ID: {{ formData.id }}</p>
            </div>
            <button type="button" aria-label="Close" class="close" @click="hideModal">×</button>
        </div>
        <b-overlay :show="updatingDatabase" rounded="sm" variant="light" spinner-variant="primary">
            <AlertCustomizeModal v-bind:formData="formData" v-bind:start="start" v-bind:end="end"
                                 v-bind:indefinite="indefinite"/>
        </b-overlay>
        <div slot="modal-footer">
            <b-button class="mx-1" variant="dark" @click="hideModal">Cancel</b-button>
<!--             class="needs-validation" novalidate @submit="checkForm"-->
            <b-button class="mx-1" variant="primary" @click="updateFirebase">Save</b-button>
        </div>
    </b-modal>
</template>

<script>
    import {db} from "../firebase";
    import AlertCustomizeModal from "./AlertCustomizeModal";
    import firebase from 'firebase/app'
    const { serverTimestamp } = firebase.firestore.FieldValue;

    const getDateTime = (dateTime) => {
        // console.log(dateTime)
        return `${dateTime.date} ${dateTime.time}`
    }

    export default {
        name: "CustomModal",
        components: {
            AlertCustomizeModal
        },
        props: {
            alertDoc: Object,
            showModal: Boolean,
            hideModal: Function,
            updateSuccessAlert: Function,
            user: Object
        },
        data() {
            return {
                // Placeholder values
                formData: {
                    // text: "",
                    // active: true,
                    // clickable: false,
                    // action: "",
                    // color: "",
                    // rgb: "#000",
                    // fullWidth: false,
                },
                updatingDatabase: false,
                indefinite: {
                    indefinite: true
                },
                start: {
                    date: "",
                    time: ""
                },
                end: {
                    date: "",
                    time: ""
                }
            }
        },
        methods: {
            async updateFirebase() {
                this.updatingDatabase = true
                const alertData = { ...this.formData }
                alertData.updated = serverTimestamp()
                alertData.created = this.alertDoc.created
                alertData.id = this.alertDoc.id
                alertData.uid = this.user.uid
                alertData.start = getDateTime(this.start);
                if(!this.indefinite.indefinite){
                    alertData.end = getDateTime(this.end);
                } else {
                    alertData.end = ""
                }
                // Convert rgb to color code
                try{
                    await db.doc(`alerts/${this.alertDoc.id}`).set(alertData);
                    this.updateSuccessAlert('Alert Saved!', 'success')
                } catch(error) {
                    console.log('ERROR:')
                    console.log(error)
                    this.updateSuccessAlert('Database communiction error', 'danger')
                }
                this.hideModal()
                this.updatingDatabase = false
            },
            parseDateTime() {
                // if(typeof this.formData.start === "string" && this.formData.start !== ""){
                const [startDate, startTime] = this.formData.start.split(" ")
                this.start.date = startDate
                this.start.time = startTime
                if(this.formData.end !== "") {
                    this.indefinite.indefinite = false
                    const [endDate, endTime] = this.formData.end.split(" ")
                    this.end.date = endDate
                    this.end.time = endTime
                } else {
                    this.indefinite.indefinite = true
                    this.end.date = this.start.date
                    this.end.time = this.start.time
                }
            }
        },
        computed: {
            rgb() {
                return{
                    value: this.formData.colorCode
                }
            }
        },
        watch: {
            alertDoc: {
                handler(alertDoc) {
                    if(alertDoc.start !== undefined && alertDoc.text !== undefined){
                        this.formData = { ...alertDoc }
                        this.parseDateTime()
                    }
                },
            },
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