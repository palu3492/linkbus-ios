<template>
    <div class="my-3">
        <div class="d-flex px-2 px-sm-0">
            <h3 class="mr-3 mb-0" style="flex-grow: 1;">Alerts</h3>
            <b-button size="sm" variant="outline-primary" class="create-button m-1" @click="openCreateModal">
                <BIconPlus v-if="false"/>
                Create Alert
            </b-button>
        </div>
        <hr class="m-0" />
        <div>
            <div v-if="alerts.length > 0">
                <Alert v-for="alert in alerts" v-bind:key="alert.id" v-bind:text="alert.text"
                       v-bind:action="alert.action" v-bind:clickable="alert.clickable" v-bind:alertDoc="alert"
                       v-bind:openEditModal="openEditModal" v-bind:openDeleteModal="openDeleteModal"
                       v-bind:active="alert.active" v-bind:fullWidth="alert.fullWidth"
                       v-bind:color="alert.color" v-bind:colorCode="alert.colorCode" />
            </div>
            <p v-else class="mt-3">No Alerts</p>
        </div>

        <DeleteModal v-bind:showModal="showDeleteModal" v-bind:hideModal="hideDeleteModal"
                     v-bind:alertDoc="clickedAlert" v-bind:updateSuccessAlert="updateSuccessAlert"/>
        <EditModal v-bind:showModal="showEditModal" v-bind:hideModal="hideEditModal" v-bind:alertDoc="clickedAlert"
                   v-bind:updateSuccessAlert="updateSuccessAlert"/>
        <CreateModal v-bind:showModal="showCreateModal" v-bind:hideModal="hideCreateModal"
                     v-bind:updateSuccessAlert="updateSuccessAlert"/>
    </div>
</template>

<script>
    import Alert from "./Alert";
    import DeleteModal from "./DeleteAlertModal";
    import EditModal from "./EditAlertModal";
    import CreateModal from "./CreateAlertModal";
    import {BIconPlus} from "bootstrap-vue";
    import {db} from "../firebase";

    const alertsCollection = db.collection('alerts');

    export default {
        name: "Alerts",
        components: {
            Alert, DeleteModal, EditModal, CreateModal, BIconPlus
        },
        props: {
            updateSuccessAlert: Function
        },
        data() {
            return {
                formData: {},
                alerts: [],
                showEditModal: false,
                showDeleteModal: false,
                showCreateModal: false,
                clickedAlert: {}
            }
        },
        firestore() {
            const alertDocs = alertsCollection
                .where('uid', '==', 1);
            return {
                alerts: alertDocs
            }
        },
        methods: {
            openEditModal(alertDoc) {
                this.clickedAlert = alertDoc;
                this.showEditModal = true;
            },
            hideEditModal() {
                this.showEditModal = false;
                this.clickedAlert = {};
            },
            openDeleteModal(alertDoc) {
                this.clickedAlert = alertDoc;
                this.showDeleteModal = true;
            },
            hideDeleteModal() {
                this.showDeleteModal = false;
                this.clickedAlert = {};
            },
            openCreateModal() {
                this.showCreateModal = true;
            },
            hideCreateModal() {
                this.showCreateModal = false;
            }
        }
    }
</script>

<style scoped>
    hr{
        margin-top: 0;
    }
</style>