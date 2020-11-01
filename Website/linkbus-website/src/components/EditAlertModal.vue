<template>
    <b-modal id="bv-modal-edit" v-model="showModal">
        <div slot="modal-header" class="m-modal-header">
            <div>
                <h5 class="modal-title">Edit Alert</h5>
                <p class="m-0 small text-muted">ID: {{ formData.id }}</p>
            </div>
            <button type="button" aria-label="Close" class="close" @click="hideModal">×</button>
        </div>
<!--        <div class="d-flex" v-if="updatingDatabase">-->
<!--            <span class="mr-2">Saving</span>-->
<!--            <b-spinner variant="primary" label="Spinning"></b-spinner>-->
<!--        </div>-->
        <b-overlay :show="updatingDatabase" rounded="sm" :variant="'light'" spinner-variant="primary">
            <AlertCustomizeModal v-bind:formData="formData"/>
<!--            <b-form>-->
<!--                <div class="d-flex">-->
<!--                    <b-input-group style="width: auto">-->
<!--                        <span class="mr-2">Active</span>-->
<!--                        <b-form-checkbox switch v-model="formData.active"></b-form-checkbox>-->
<!--                    </b-input-group>-->
<!--                    <b-input-group class="ml-md-4" style="width: auto">-->
<!--                        <span class="mr-2">Full-width</span>-->
<!--                        <b-form-checkbox switch v-model="formData.fullWidth"></b-form-checkbox>-->
<!--                    </b-input-group>-->
<!--                </div>-->

<!--                <b-input-group prepend="Body" class="mt-3">-->
<!--                    <b-form-input :state="validBody" v-model="formData.text" required></b-form-input>-->
<!--                </b-input-group>-->

<!--                <b-input-group prepend="Action" class="mt-3">-->
<!--                    <b-input-group-prepend is-text>-->
<!--                        <b-form-checkbox switch v-model="formData.clickable"></b-form-checkbox>-->
<!--                    </b-input-group-prepend>-->
<!--                    <b-form-input url v-model="formData.action" :disabled="!formData.clickable"-->
<!--                                  :state="validUrl" placeholder="http://www.example.com"></b-form-input>-->
<!--                </b-input-group>-->

<!--                <p class="mb-0 mt-3">Background Color</p>-->
<!--                <b-row class="d-flex">-->
<!--                    <b-col>-->
<!--                        <b-form-text class="m-0">iOS Color Palette</b-form-text>-->
<!--                        <b-form-select v-model="formData.color" :options="colorOptions"></b-form-select>-->
<!--                    </b-col>-->
<!--                    <b-col cols='auto'>-->
<!--                        <p class="mt-4 mb-0">OR</p>-->
<!--                    </b-col>-->
<!--                    <b-col>-->
<!--                        <b-form-text class="m-0">RGB Color</b-form-text>-->
<!--                        <b-form-input type="color" v-model="formData.colorCode"></b-form-input>-->
<!--                    </b-col>-->
<!--                </b-row>-->
<!--            </b-form>-->
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

    export default {
        name: "CustomModal",
        components: {
            AlertCustomizeModal
        },
        props: {
            alertDoc: Object,
            showModal: Boolean,
            hideModal: Function,
            updateSuccessAlert: Function
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
                colorOptions: [
                    { value: 'red', text: 'Red' },
                    { value: 'blue', text: 'Blue' },
                    { value: 'green', text: 'Green' },
                ],
                updatingDatabase: false
            }
        },
        methods: {
            async updateFirebase() {
                this.updatingDatabase = true
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
            },
            validUrl() {
                if(this.formData.clickable === undefined || this.formData.action === undefined){
                    return
                }
                if(this.formData.clickable) {
                    if(this.formData.action.length > 0){
                        return true;
                    }
                }
                return null;
            },
            validBody() {
                if(this.formData.text === undefined){
                    return
                }
                if(this.formData.text.length === 0){
                    return null
                } else if (this.formData.text.length < 5){
                    return false;
                }
                return true;
            },
        },
        watch: {
            alertDoc: {
                handler(alertDoc) {
                    // Convert rgb to color code
                    this.formData = { ...alertDoc }
                    this.formData.id = alertDoc.id
                    // if(alertDoc.text !== undefined && alertDoc.action !== undefined) {
                    //     this.formData.colorCode = "#c41a1a"
                    //     this.formData = alertDoc
                    // }
                    // if(alertDoc.text !== undefined && alertDoc.action !== undefined){
                    //     // this.formData = alertDoc
                    //     console.log('change');
                    //     this.formData.text = alertDoc.text
                    //     this.formData.active = alertDoc.active
                    //     this.formData.clickable = alertDoc.clickable
                    //     this.formData.action = alertDoc.action
                    //     this.formData.color = alertDoc.color
                    //     this.formData.colorCode = "#c41a1a"
                    //     this.formData.fullWidth = alertDoc.fullWidth
                    // }
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