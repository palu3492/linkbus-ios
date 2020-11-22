<template>
    <div class="my-3">
        <div class="d-flex px-2 px-sm-0">
            <h3 class="mr-3 mb-0" style="flex-grow: 1;">Alerts</h3>
            <b-button size="sm" variant="outline-primary" class="create-button m-1"
                      @click="openCreateModal" v-if="signedIn">
                Create Alert
            </b-button>
        </div>
        <hr class="m-0" />
        <div class="alerts-container p-2 p-sm-3">
            <div v-if="alerts.length === 0 && loading" class="d-flex justify-content-around mt-3">
                <b-spinner variant="primary" label="Spinning"></b-spinner>
            </div>
            <div v-else-if="alerts.length > 0">
                <div class="d-none d-md-block">
                    <draggable v-model="alertsSorted" ghost-class="ghost" animation="200" @end="onEndMove">
                        <Alert v-for="alert in alertsSorted" v-bind:key="alert.id" v-bind:text="alert.text"
                               v-bind:action="alert.action" v-bind:clickable="alert.clickable" v-bind:alertDoc="alert"
                               v-bind:openEditModal="openEditModal" v-bind:openDeleteModal="openDeleteModal"
                               v-bind:active="alert.active" v-bind:fullWidth="alert.fullWidth"
                               v-bind:color="alert.color" v-bind:colorCode="alert.colorCode" v-bind:signedIn="signedIn"
                               v-bind:start="alert.start" v-bind:end="alertEnd(alert.end)" />
                    </draggable>
                </div>
                <div class="d-block d-md-none">
                    <transition-group name="list">
                        <Alert v-for="alert in alertsSorted" v-bind:key="alert.id" v-bind:text="alert.text"
                               v-bind:action="alert.action" v-bind:clickable="alert.clickable" v-bind:alertDoc="alert"
                               v-bind:openEditModal="openEditModal" v-bind:openDeleteModal="openDeleteModal"
                               v-bind:active="alert.active" v-bind:fullWidth="alert.fullWidth"
                               v-bind:color="alert.color" v-bind:colorCode="alert.colorCode" v-bind:signedIn="signedIn"
                               v-bind:start="alert.start" v-bind:end="alertEnd(alert.end)" v-bind:order="alert.order"
                               v-bind:orderUp="orderUp" v-bind:orderDown="orderDown" />
                    </transition-group>
                </div>
            </div>
            <p v-else class="ml-2 mt-3 mb-0">No Alerts</p>
        </div>

        <DeleteModal v-bind:showModal="showDeleteModal" v-bind:hideModal="hideDeleteModal"
                     v-bind:alertDoc="clickedAlert" v-bind:updateSuccessAlert="updateSuccessAlert"
                     v-bind:user="user"/>
        <EditModal v-bind:showModal="showEditModal" v-bind:hideModal="hideEditModal" v-bind:alertDoc="clickedAlert"
                   v-bind:updateSuccessAlert="updateSuccessAlert" v-bind:user="user"/>
        <CreateModal v-bind:showModal="showCreateModal" v-bind:hideModal="hideCreateModal"
                     v-bind:updateSuccessAlert="updateSuccessAlert" v-bind:user="user" v-bind:order="newOrder"/>
    </div>
</template>

<script>
    import Alert from "./Alert";
    import DeleteModal from "./DeleteAlertModal";
    import EditModal from "./EditAlertModal";
    import CreateModal from "./CreateAlertModal";
    import {db} from "../firebase";
    import draggable from 'vuedraggable'

    const alertsCollection = db.collection('alerts');

    const production = false; // PRODUCTION VARIABLE
    const staging = false; // STAGING VARIABLE
    const development = true; // DEVELOPMENT VARIABLE
    let adminUserId = ""
    if(production) {
        adminUserId = "mZK3hiDTGbaejz9vBfdm9d92kdf1"
    } else if(staging) {
        adminUserId = "0ZUHsGrupYcTLfxMXuriAZZEElp2"
    } else if(development) {
        adminUserId = "1J6yYtccJ3c7ZeiAqUOuDpAgZvo1"
    }

    export default {
        name: "Alerts",
        components: {
            Alert, DeleteModal, EditModal, CreateModal, draggable
        },
        props: {
            updateSuccessAlert: Function,
            signedIn: Boolean,
            user: Object,
        },
        data() {
            return {
                formData: {},
                alerts: [],
                alertsSorted: [],
                showEditModal: false,
                showDeleteModal: false,
                showCreateModal: false,
                clickedAlert: {},
                loading: true,
                drag: false
            }
        },
        firestore() {
            const alertDocs = alertsCollection
                .where('uid', '==', adminUserId);
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
            },
            alertEnd(end) {
                if(end === "") {
                    return {};
                }
                return end;
            },
            async onEndMove() {
                const batch = db.batch();
                for(let i = 0; i < this.alertsSorted.length; i++){
                    const alert = this.alertsSorted[i];
                    alert.order = i;
                    let doc = db.doc(`alerts/${alert.id}`)
                    batch.set(doc, alert);
                }
                await batch.commit();
            },
            sortAlerts() {
                let alertsTmp = [...this.alerts];
                this.alertsSorted = alertsTmp.sort((a, b) => a.order - b.order);
            },
            orderUp(index) {
                if(index > 0) {
                    let alertsTmp = [...this.alertsSorted];
                    alertsTmp[index].order = index - 1;
                    alertsTmp[index - 1].order = index;
                    // console.log(alertsTmp[index].order)
                    // console.log(alertsTmp[index - 1].order)
                    this.alerts = [...alertsTmp];
                    this.updateOrder(index, -1);
                }
            },
            orderDown(index) {
                if(index >= 0 && index < this.alertsSorted.length - 1) {
                    let alertsTmp = [...this.alertsSorted];
                    alertsTmp[index].order = index + 1;
                    alertsTmp[index + 1].order = index;
                    // console.log(alertsTmp[index].order)
                    // console.log(alertsTmp[index - 1].order)
                    this.alerts = [...alertsTmp];
                    this.updateOrder(index, 1);
                }
            },
            async updateOrder(index, change) {
                const batch = db.batch();
                let alert = this.alerts[index];
                let doc = db.doc(`alerts/${alert.id}`)
                batch.set(doc, alert);
                alert = this.alerts[index + change];
                doc = db.doc(`alerts/${alert.id}`)
                batch.set(doc, alert);
                await batch.commit();
            }
        },
        created: function () {
            setTimeout(function() {
                this.loading = false
            }.bind(this),5000);
        },
        computed: {
            newOrder() {
                return this.alerts.length;
            }
        },
        watch: {
            alerts() {
                this.sortAlerts();
            }
        }
    }
</script>

<style scoped>
    hr{
        margin-top: 0;
    }
    .alerts-container {
        background: #ebecf0;
    }
    .ghost {
        border-left: solid #007bff 6px;
    }
    .list-move {
        transition: transform 500ms;
    }
</style>