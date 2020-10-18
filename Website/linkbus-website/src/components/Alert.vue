<template>
    <div>
        <b-row class="alert-row p-0 m-0">
            <b-col class="d-flex">
                <b-col class="p-0" cols="autos">
                    <p style="font-size: 0.8em; color: grey" class="m-0"><b>Preview:</b></p>
                    <p class="alert-preview">{{ text }}</p>
                </b-col>
                <b-col class="py-4">
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
            </b-col>
            <b-col cols="auto">
                <BIconPencilSquare variant="dark" class="icon mx-1" title="Edit" v-b-modal.bv-modal-edit />
                <BIconXSquare variant="danger" class="icon mx-1" title="Delete" v-b-modal.bv-modal-delete />
            </b-col>
        </b-row>
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
</style>