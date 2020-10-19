<template>
    <b-modal id="bv-modal-edit" title="Edit Alert" v-model="showModal">
        <b-form>
            <b-input-group>
                <span class="mr-2">Active</span>
                <b-form-checkbox switch v-model="active"></b-form-checkbox>
            </b-input-group>
            <b-input-group prepend="Body" class="mt-3">
                <b-form-input v-model="body"></b-form-input>
            </b-input-group>
            Clickable: <b-form-checkbox v-model="clickable"></b-form-checkbox>
            <b-input-group prepend="Action" class="mt-3">
                <b-form-input v-model="action"></b-form-input>
            </b-input-group>
            Color: <b-form-select v-model="color" :options="options"></b-form-select>
<!--            RGB Color: <b-form-input v-model="rgb"></b-form-input>-->
            Full-width: <b-form-checkbox v-model="fullWidth"></b-form-checkbox>
        </b-form>
        <div slot="modal-footer">
            <b-button class="mx-1" variant="dark" @click="hideModal">Cancel</b-button>
            <b-button class="mx-1" variant="primary" @click="hideModal">Save</b-button>
        </div>
    </b-modal>
</template>

<script>
    export default {
        name: "CustomModal",
        props: {
            alert: Object,
            showModal: Boolean,
            hideModal: Function
        },
        data() {
            return {
                body: "",
                active: true,
                clickable: false,
                action: "",
                color: "red",
                rgb: {},
                fullWidth: false,

                options: [
                    { value: 'red', text: 'Red' },
                    { value: 'blue', text: 'Blue' },
                ]
            }
        },
        watch: {
            alert: {
                handler(alert) {
                    this.body = alert.text
                    this.action = alert.action
                },
            },
        }
    }
</script>

<style scoped>

</style>