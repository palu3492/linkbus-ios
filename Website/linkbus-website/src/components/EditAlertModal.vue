<template>
    <b-modal id="bv-modal-edit" v-model="showModal">
        <div slot="modal-header" class="m-modal-header">
            <div>
                <h5 class="modal-title">Edit Alert</h5>
                <p class="m-0 small text-muted">ID: {{ formData.id }}</p>
            </div>
            <button type="button" aria-label="Close" class="close" @click="hideModal">×</button>
        </div>
        <b-overlay :show="updatingDatabase" rounded="sm" :variant="'light'" spinner-variant="primary">
            <AlertCustomizeModal v-bind:formData="formData"/>
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
                updatingDatabase: false
            }
        },
        methods: {
            async updateFirebase() {
                this.updatingDatabase = true
                this.formData.serverTimestamp = serverTimestamp()
                this.formData.uid = this.user.uid
                // Convert rgb to color code
                try{
                    await db.doc(`alerts/${this.alertDoc.id}`).set(this.formData);
                    this.updateSuccessAlert('Alert Saved!', 'success')
                } catch(error) {
                    console.log('ERROR:')
                    console.log(error)
                    this.updateSuccessAlert('Database communiction error', 'danger')
                }
                this.hideModal()
                this.updatingDatabase = false
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
                    // Convert rgb to color code
                    this.formData = { ...alertDoc }
                    this.formData.id = alertDoc.id
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