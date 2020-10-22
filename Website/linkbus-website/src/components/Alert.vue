<template>
    <div>
        <b-row class="alert-row m-0 p-3 flex-wrap-reverse">
            <b-col class="d-flex">
                <b-row>
                    <b-col class="p-0 pr-1" md="auto" sm="12">
                        <p style="font-size: 0.8em; color: grey" class="m-0"><b>Preview:</b></p>
                        <p class="alert-preview">{{ text }}</p>
                    </b-col>
                    <b-col class="p-0 pt-3 options" md="auto" sm="12">
                        <Option v-for="(optionValue, option, i) in options" v-bind:optionValue="optionValue"
                                v-bind:option="option" v-bind:key="i"/>
                    </b-col>
                </b-row>
            </b-col>
            <b-col md="auto">
                <BIconPencilSquare variant="dark" class="icon mx-1" title="Edit" @click="openEditModal(alertDoc)" />
                <BIconXSquare variant="danger" class="icon mx-1" title="Delete" v-b-modal.bv-modal-delete />
            </b-col>
        </b-row>
        <hr  class="m-0"/>
    </div>
</template>

<script>
    import { BIconPencilSquare, BIconXSquare } from 'bootstrap-vue'
    import Option from "./Option";
    export default {
        name: "Alert",
        props: {
            action: String,
            text: String,
            color: String,
            active: Boolean,
            clickable: Boolean,
            fullWidth: Boolean,
            rgb: Object,
            alertDoc: Object,
            openEditModal: Function
        },
        components: {
            Option,
            BIconPencilSquare, BIconXSquare
        },
        data() {
            return {
                options: this._props
            }
        }
    }
</script>

<style scoped>
    .icon {
        font-size: 1.3em;
        cursor: pointer;
    }
    .alert-row:hover {
        background: #0000000a;
    }
    .alert-preview{
        background: red;
        color: white;
        font-size: 1em;
        border: solid 0;
        border-radius: 1em;
        padding: 0.5em;
        width: fit-content;
    }
    hr {
        border-top: 1px solid rgb(0 0 0 / 53%);
    }
</style>