<template>
    <b-modal id="bv-modal-edit" title="Edit Alert" v-model="showModal">
        <b-spinner variant="primary" label="Spinning" v-if="updatingDatabase"></b-spinner>
        <b-form v-else>
            <b-input-group>
                <span class="mr-2">Active</span>
                <b-form-checkbox switch v-model="formData.active"></b-form-checkbox>
            </b-input-group>
            <b-input-group prepend="Body" class="mt-3">
                <b-form-input v-model="formData.text"></b-form-input>
            </b-input-group>

<!--            <b-form-text class="mt-3">Website to open when alert is clicked</b-form-text>-->
            <b-input-group class="mt-3">
                <template #prepend>
                    <b-input-group-text>Action</b-input-group-text>
                    <b-input-group-text>
                        <b-form-checkbox switch v-model="formData.clickable"></b-form-checkbox>
                    </b-input-group-text>
                </template>
                <b-form-input v-model="formData.action" :disabled="!formData.clickable"></b-form-input>
            </b-input-group>

            <b-input-group class="mt-3">
                <span class="mr-2 mt-2">iOS Color Palette</span>
                <b-form-select v-model="formData.color" :options="colorOptions"></b-form-select>
            </b-input-group>

            <b-form-group class="mt-3">
                <b-form-text>RGB Color</b-form-text>
                <b-form-input type="color" v-model="formData.rgb"></b-form-input>
            </b-form-group>

            <b-input-group class="mt-3">
                <span class="mr-2">Full-width</span>
                <b-form-checkbox v-model="formData.fullWidth"></b-form-checkbox>
            </b-input-group>
        </b-form>
        <div slot="modal-footer">
            <b-button class="mx-1" variant="dark" @click="hideModal">Cancel</b-button>
            <b-button class="mx-1" variant="primary" @click="updateFirebase">Save</b-button>
        </div>
    </b-modal>
</template>

<script>
    import {db} from "../firebase";
    export default {
        name: "CustomModal",
        props: {
            alertDoc: Object,
            showModal: Boolean,
            hideModal: Function,
            updateSuccessAlert: Function
        },
        data() {
            return {
                formData: {},
                // body: "",
                // active: true,
                // clickable: false,
                // action: "",
                // color: "red",
                // rgb: "#000",
                // fullWidth: false,
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
                    await db.doc(`alerts/${this.alertDoc.id}`).set(this.formData);
                } catch(error) {
                    console.log(error)
                }
                this.hideModal()
                this.updateSuccessAlert()
                this.updatingDatabase = false
            }
        },
        watch: {
            alertDoc: {
                handler(alertDoc) {
                    alertDoc.rgb = "#000"
                    this.formData = alertDoc
                },
            },
        }
    }
</script>

<style scoped>

</style>