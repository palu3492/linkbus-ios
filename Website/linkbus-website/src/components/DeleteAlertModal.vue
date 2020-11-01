<template>
    <b-modal id="bv-modal-delete" v-model="showModal">
        <div slot="modal-header" class="m-modal-header">
            <div>
                <h5 class="modal-title">Delete Alert</h5>
                <p class="m-0 small text-muted">ID: {{ alertDoc.id }}</p>
            </div>
            <button type="button" aria-label="Close" class="close" @click="hideModal">×</button>
        </div>
        <b-overlay :show="updatingDatabase" rounded="sm" :variant="'light'" spinner-variant="primary">
            <p class="my-3">Are you sure you want to delete this alert?</p>
        </b-overlay>
        <div slot="modal-footer">
            <b-button class="mx-1" variant="dark" @click="hideModal">Cancel</b-button>
            <b-button class="mx-1" variant="danger" @click="updateFirebase">Yes, delete</b-button>
        </div>
    </b-modal>
</template>

<script>
    import {db} from "../firebase";

    export default {
        name: "DeleteModal",
        props: {
            alertDoc: Object,
            showModal: Boolean,
            hideModal: Function,
            updateSuccessAlert: Function
        },
        data() {
            return {
                updatingDatabase: false
            }
        },
        methods: {
            async updateFirebase() {
                this.updatingDatabase = true
                try{
                    await db.doc(`alerts/${this.alertDoc.id}`).delete()
                    this.updateSuccessAlert('Alert Deleted!', 'success')
                } catch(error) {
                    console.log('ERROR:')
                    console.log(error)
                    this.updateSuccessAlert('Database communiction error', 'danger')
                }
                this.hideModal()
                this.updatingDatabase = false
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