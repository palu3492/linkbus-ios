<template>
    <div>
        <div class="d-flex">
            <h3 class="mr-3" style="flex-grow: 1;">Alerts</h3>
            <b-button size="sm" variant="outline-primary" class="create-button m-1" v-b-modal.bv-modal-create>
                <BIconPlus v-if="false"/>
                Create Alert
            </b-button>
        </div>
        <hr class="m-0" />
        <div>
            <div v-if="alerts.length > 0">
                <Alert v-for="alert in alerts" v-bind:key="alert.id" v-bind:text="alert.text"
                       v-bind:action="alert.action"/>
            </div>
            <p v-else>No Alerts</p>
        </div>

        <DeleteModal />
        <EditModal />
        <CreateModal />
    </div>
</template>

<script>
    import Alert from "./Alert";
    import DeleteModal from "./DeleteModal";
    import EditModal from "./EditModal";
    import CreateModal from "./CreateModal";
    import {BIconPlus} from "bootstrap-vue";
    import {db} from "../firebase";

    const alertsCollection = db.collection('alerts');

    export default {
        name: "Alerts",
        components: {
            Alert, DeleteModal, EditModal, CreateModal, BIconPlus
        },
        data: () => {
            return {
                formData: {},
                alerts: []
            }
        },
        firestore() {
            const alertDocs = alertsCollection
                .where('uid', '==', 1)
            return {
                alerts: alertDocs
            }
        },
        methods: {
            async updateFirebase() {
                try{
                    if(this.formData.uid){
                        await db.doc('').set(this.formData)
                    }
                } catch(error) {
                    console.log(error)
                }
            }
        }
    }
</script>

<style scoped>
    hr{
        margin-top: 0;
    }
</style>