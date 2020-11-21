<template>
    <div>
        <b-row class="alert-row m-0 p-3 flex-md-row flex-column">
            <b-col class="flex-grow-1 pl-md-0 p-0">
                <b-row class="m-0">
<!--            <b-col sm="auto" cols="auto" class="pl-0 text-center">-->
<!--                <p class="mb-1">Active</p>-->

<!--                <BIconCheckCircle variant="success" class="activeIcon" v-if="active" />-->
<!--                <BIconXCircle variant="danger" class="activeIcon" v-else />-->
<!--            </b-col>-->
<!--            <b-col sm="auto" cols="auto" v-if="text !== '' && text !== undefined" class="p-0">-->
<!--                <p style="font-size: 0.8em; color: grey" class="m-0"><b>Preview:</b></p>-->
<!--                <p class="alert-preview m-0" :style="backgroundColor">{{ text }}</p>-->
<!--            </b-col>-->
                    <b-col cols="auto" class="d-flex pr-md-2 p-0" style="flex-wrap: nowrap">
                        <div class="text-center pr-3">
                            <p class="mb-1">Active</p>
                            <BIconCheckCircle variant="success" class="activeIcon" v-if="active" />
                            <BIconXCircle variant="danger" class="activeIcon" v-else />
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
                        <BIconClock class="mr-1 mt-1" />
                        <p class="">{{ startDate }}</p>
                        <BIconArrowRight class="mx-2 mt-1"/>
                        <p class="">{{ endDate }}</p>
                    </b-col>
                </b-row>
            </b-col>
            <b-col class="pl-md-3 pt-md-0 pr-0 pl-0 pt-3 justify-content-around d-flex" cols="auto" v-if="signedIn">
                <BIconPencilSquare variant="dark" class="icon mx-1" title="Edit" @click="openEditModal(alertDoc)" />
                <BIconXSquare variant="danger" class="icon mx-1" title="Delete" @click="openDeleteModal(alertDoc)" />
            </b-col>
        </b-row>
        <hr  class="m-0"/>
    </div>
</template>

<script>
    import { BIconPencilSquare, BIconXSquare, BIconCheckCircle, BIconXCircle, BIconClock, BIconArrowRight } from 'bootstrap-vue'
    // import Option from "./Option";
    import moment from "moment";
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
            end: Object
        },
        components: {
            BIconPencilSquare, BIconXSquare, BIconCheckCircle, BIconXCircle, BIconClock, BIconArrowRight
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
                if(this.end.length === 0) {
                    return "Indefinite";
                }
                const date = moment(this.end.toDate());
                return date.calendar();
            },
        }
    }
</script>

<style scoped>
    .icon {
        font-size: 1.3em;
        cursor: pointer;
    }
    .activeIcon {
        font-size: 1.6em;
    }
    .alert-row:hover {
        background: #0000000a;
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
    hr {
        border-top: 1px solid rgb(0 0 0 / 53%);
    }
</style>