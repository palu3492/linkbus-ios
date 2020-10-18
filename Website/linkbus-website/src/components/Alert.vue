<template>
    <div>
        <b-row class="alert-row p-0 m-0 py-2 flex-wrap-reverse">
            <b-col class="d-flex">
                <b-row>
                    <b-col class="p-0" md="auto" sm="12">
                        <p style="font-size: 0.8em; color: grey" class="m-0"><b>Preview:</b></p>
                        <p class="alert-preview">{{ text }}</p>
                    </b-col>
                    <b-col class="py-4" md="auto" sm="12">
                        <span class="px-2">
                            Enabled <BIconCheckCircle variant="success"/>
                        </span>
                        <span class="px-2">
                            Clickable <BIconXCircle variant="danger"/>
                        </span>
                        <span class="px-2">
                            Action {{ action }}
                        </span>
                    </b-col>
                </b-row>
            </b-col>
            <b-col md="auto">
                <BIconPencilSquare variant="dark" class="icon mx-1" title="Edit" v-b-modal.bv-modal-edit />
                <BIconXSquare variant="danger" class="icon mx-1" title="Delete" v-b-modal.bv-modal-delete />
            </b-col>
        </b-row>
        <hr  class="m-0"/>
    </div>
</template>

<!--action-->
<!--"https://www.csbsju.edu/covid-19"-->
<!--active-->
<!--true-->
<!--clickable-->
<!--true-->
<!--color-->
<!--"red"-->
<!--fullWidth-->
<!--false-->
<!--id-->
<!--1-->
<!--text-->
<!--"A face mask is required to ride the CSB/SJU Link."-->
<!--uid-->
<!--1-->

<script>
    import { BIconPencilSquare, BIconXSquare, BIconCheckCircle, BIconXCircle } from 'bootstrap-vue'
    export default {
        name: "Alert",
        props: ["action", "active", "clickable", "color", "rgb", "fullWidth", "text"],
        components: {
            BIconPencilSquare, BIconXSquare, BIconCheckCircle, BIconXCircle
        }
    }
</script>

<style scoped>
    .icon {
        font-size: 1.1em;
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