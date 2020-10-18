<template>
    <div>
        <b-row>
            <b-col>
                <p><b>Alert</b> Text: {{ text }}</p>
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
    import { BIconPencilSquare, BIconXSquare } from 'bootstrap-vue'
    export default {
        name: "Alert",
        props: ["action", "active", "clickable", "color", "rgb", "fullWidth", "text"],
        components: {
            BIconPencilSquare, BIconXSquare
        }
    }
</script>

<style scoped>
    .icon {
        font-size: 1.1em;
        cursor: pointer;
    }
</style>