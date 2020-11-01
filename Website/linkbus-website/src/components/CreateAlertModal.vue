<template>
    <b-modal id="bv-modal-create" v-model="showModal" ref="createModal" @hide="handleHideEvent">
        <div slot="modal-header" class="m-modal-header">
            <h5 class="modal-title">Create New Alert</h5>
            <button type="button" aria-label="Close" class="close" @click="hideModal(); reset();">×</button>
        </div>
        <b-overlay :show="updatingDatabase" rounded="sm" :variant="'light'" spinner-variant="primary">
            <AlertCustomizeModal v-bind:formData="formData"/>
        </b-overlay>
        <div slot="modal-footer">
            <b-button class="mx-1" variant="dark" @click="hideModal(); reset();">Cancel</b-button>
            <b-button class="mx-1" variant="success" @click="updateFirebase">Create</b-button>
        </div>
    </b-modal>
</template>

<script>
    import AlertCustomizeModal from "./AlertCustomizeModal";
    import {db} from "../firebase";

    const formDataDefault = {
        text: "",
        active: true,
        clickable: false,
        action: "",
        color: "",
        colorCode: "#000000",
        fullWidth: false,
        uid: 1
    };

    export default {
        name: "CreateModal",
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
                formData: { ...formDataDefault },
                updatingDatabase: false,
                showModalValue: false
            }
        },
        methods: {
            async updateFirebase() {
                this.updatingDatabase = true
                let alertData = { ...this.formData };
                alertData.rgb = this.rgb()
                alertData.uid = this.user.uid
                try{
                    await db.collection('alerts').add(alertData);
                    this.updateSuccessAlert('Alert Created!', 'success')
                } catch(error) {
                    console.log('ERROR:')
                    console.log(error)
                    this.updateSuccessAlert('Database communiction error', 'danger')
                }
                this.hideModal()
                this.updatingDatabase = false
                this.formData = { ...formDataDefault }
            },
            rgb() {
                const hexToRgb = (color, start, end) => {
                    let value = parseInt(color.slice(start, end), 16) / 255;
                    value = Math.round(value * 100) / 100
                    if(typeof value !== "number"){
                        value = 0
                    }
                    return value
                }
                let red, green, blue, opacity;
                red = hexToRgb(this.formData.colorCode,1, 3)
                green = hexToRgb(this.formData.colorCode,3, 5)
                blue = hexToRgb(this.formData.colorCode,5, 7)
                opacity = 1.0
                return {
                    red: red,
                    green: green,
                    blue: blue,
                    opacity: opacity
                }
            },
            reset() {
                this.formData = { ...formDataDefault }
            },
            handleHideEvent() {
                if(this.showModal === true){
                    this.hideModal();
                }
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