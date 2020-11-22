<template>
    <div class="sortable alert-container mb-3 p-2">
        <b-row class="m-0 p-0 flex-md-row flex-column">
            <b-col class="flex-grow-1 pl-md-0 p-0">
                <b-row class="m-0">
                    <b-col cols="auto" class="d-flex pr-md-2 p-0" style="flex-wrap: nowrap">
                        <div class="text-center pr-3">
                            <p class="mb-1">Active</p>
                            <BIconCheckCircle variant="success" class="active-icon" v-if="active" />
                            <BIconXCircle variant="danger" class="active-icon" v-else />
                        </div>
                       <div>  <!-- class="overflow-auto"-->
                            <p style="font-size: 0.8em; color: grey" class="m-0"><b>Preview:</b></p>
                            <p class="alert-preview m-0" :style="backgroundColor">{{ text }}</p>
                        </div>
                    </b-col>
                    <b-col cols="auto" class="px-2 d-flex mt-4">
                        <p class="mb-0">Full-width: </p>
                        <BIconCheckCircle v-if="fullWidth" class="ml-2 mt-1" variant="success"/>
                        <BIconXCircle v-else class="ml-2 mt-1" variant="danger" />
                    </b-col>
                    <b-col cols="auto" class="px-2 d-flex mt-4">
                        <p class="mb-0">Action: </p>
                        <p v-if="clickable" class="ml-1 mb-0"><a :href="action" target="_blank">{{ action }}</a></p>
                        <BIconXCircle v-else class="ml-2 mt-1" variant="danger" />
                    </b-col>
                    <b-col cols="auto" class="px-2 d-flex mt-4">
                        <BIconCalendarRange class="mr-1 mt-1" style="font-size: 1.1em"/>
                        <p class="">{{ startDate }}</p>
                        <BIconArrowRight class="mx-2 mt-1"/>
                        <p class="">{{ endDate }}</p>
                    </b-col>
                </b-row>
            </b-col>
            <b-col class="pl-md-3 pt-md-0 pr-0 pl-0 pt-3 justify-content-around d-flex" cols="auto" v-if="signedIn">
                <BIconTriangleFill class="d-block d-sm-none" @click="() => orderUp(order)"/>
                <BIconPencilSquare variant="dark" class="icon mx-1" title="Edit" @click="openEditModal(alertDoc)" />
                <BIconXSquare variant="danger" class="icon mx-1" title="Delete" @click="openDeleteModal(alertDoc)" />
                <BIconTriangleFill rotate="180" class="d-block d-sm-none" @click="orderDown(order)" />
            </b-col>
        </b-row>
    </div>
</template>

<script>
    import { BIconPencilSquare, BIconXSquare, BIconCheckCircle, BIconXCircle,
        BIconCalendarRange, BIconArrowRight, BIconTriangleFill } from 'bootstrap-vue'
    // import Option from "./Option";
    import moment from "moment";
    import jQuery from "jquery"
    export default {
        name: "Alert",
        props: {
            action: String,
            text: String,
            color: String,
            colorCode: String,
            active: Boolean,
            clickable: Boolean,
            fullWidth: Boolean,
            alertDoc: Object,
            openEditModal: Function,
            openDeleteModal: Function,
            signedIn: Boolean,
            start: Object,
            end: Object,
            order: Number,
            orderUp: Function,
            orderDown: Function,
        },
        components: {
            BIconPencilSquare, BIconXSquare, BIconCheckCircle, BIconXCircle, BIconCalendarRange, BIconArrowRight,
            BIconTriangleFill
        },
        // data() {
        //     return {
        //         options: this._props
        //     }
        // }
        computed: {
            backgroundColor() {
                let bg = ''
                if(this.color === ''){
                    bg = this.colorCode;
                } else {
                    bg = this.color;
                }
                return `background-color: ${bg}`;
            },
            startDate() {
                const date = moment(this.start.toDate());
                return date.format('L LT');
            },
            endDate() {
                if(jQuery.isEmptyObject(this.end)) {
                    return "Indefinite";
                }
                const date = moment(this.end.toDate());
                return date.format('L LT');
            },
        }
    }
</script>

<style scoped>
    .alert-container {
        background-color: #fff;
        border-radius: 3px;
        box-shadow: 0 1px 0 rgba(9,30,66,.25);
    }
    .alert-container:hover {
        background-color: #f4f5f7;
        border-bottom-color: rgba(9,30,66,.25);
    }
    .sortable {
        cursor: move;
    }
    .sortable-drag {
        opacity: 0;
    }
    .icon {
        font-size: 1.3em;
        cursor: pointer;
    }
    .active-icon {
        font-size: 1.6em;
    }
    .alert-preview{
        color: white;
        font-size: 1em;
        border: solid 0;
        border-radius: 1em;
        padding: 0.5em;
        /*overflow: hidden;*/
        /*text-overflow: ellipsis;*/
        /*white-space: nowrap;*/
        /*width: 100%;*/
    }
    /*hr {*/
    /*    border-top: 1px solid rgb(0 0 0 / 53%);*/
    /*}*/
</style>