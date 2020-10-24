<template>
    <b-modal id="bv-modal-create" v-model="showModal">
        <div slot="modal-header" class="m-modal-header">
            <h5 class="modal-title">Create New Alert</h5>
            <button type="button" aria-label="Close" class="close" @click="hideModal">×</button>
        </div>
        <b-overlay :show="updatingDatabase" rounded="sm" :variant="'light'" spinner-variant="primary">
            <b-form>
                <div class="d-flex">
                    <b-input-group style="width: auto">
                        <span class="mr-2">Active</span>
                        <b-form-checkbox switch v-model="formData.active"></b-form-checkbox>
                    </b-input-group>
                    <b-input-group class="ml-md-4" style="width: auto">
                        <span class="mr-2">Full-width</span>
                        <b-form-checkbox switch v-model="formData.fullWidth"></b-form-checkbox>
                    </b-input-group>
                </div>

                <b-input-group prepend="Body" class="mt-3">
                    <b-form-input :state="validBody" v-model="formData.text" required></b-form-input>
                </b-input-group>

                <b-input-group prepend="Action" class="mt-3">
                    <b-input-group-prepend is-text>
                        <b-form-checkbox switch v-model="formData.clickable"></b-form-checkbox>
                    </b-input-group-prepend>
                    <b-form-input url v-model="formData.action" :disabled="!formData.clickable"
                                  :state="validUrl" placeholder="http://www.example.com"></b-form-input>
                </b-input-group>

                <p class="mb-0 mt-3">Background Color</p>
                <b-row class="d-flex">
                    <b-col>
                        <b-form-text class="m-0">iOS Color Palette</b-form-text>
                        <b-form-select v-model="formData.color" :options="colorOptions"></b-form-select>
                    </b-col>
                    <b-col cols='auto'>
                        <p class="mt-4 mb-0">OR</p>
                    </b-col>
                    <b-col>
                        <b-form-text class="m-0">RGB Color</b-form-text>
                        <b-form-input type="color" v-model="formData.colorCode"></b-form-input>
                    </b-col>
                </b-row>
            </b-form>
        </b-overlay>
        <div slot="modal-footer">
            <b-button class="mx-1" variant="dark" @click="hideModal">Cancel</b-button>
            <b-button class="mx-1" variant="success" @click="updateFirebase">Create</b-button>
        </div>
    </b-modal>
</template>

<script>
    import {db} from "../firebase";

    export default {
        name: "CreateModal",
        props: {
            alertDoc: Object,
            showModal: Boolean,
            hideModal: Function,
            updateSuccessAlert: Function
        },
        data() {
            return {formData: {
                    text: "",
                    active: true,
                    clickable: false,
                    action: "",
                    color: "red",
                    rgb: "#f54",
                    fullWidth: false,
                    uid: 1
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
                try{
                    await db.collection('alerts').add(this.formData)
                } catch(error) {
                    console.log(error)
                }
                this.hideModal()
                this.updateSuccessAlert('Alert Created!')
                this.updatingDatabase = false
            },
        },
        computed: {

            rgb() {
                return{
                    value: this.formData.colorCode
                }
            },
            validUrl() {
                if(this.formData.clickable === undefined || this.formData.action === undefined){
                    return null;
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
                    return null;
                }
                if(this.formData.text.length === 0){
                    return null
                } else if (this.formData.text.length < 5){
                    return false;
                }
                return true;
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