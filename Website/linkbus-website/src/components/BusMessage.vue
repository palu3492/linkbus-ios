<template>
    <div>
        <!-- @click="openCreateModal" v-if="signedIn" -->
        <b-button size="sm" variant="outline-primary" class="m-1 mt-3" @click="openModal">
            Customize Daily Message
        </b-button>
        <MessageCustomizeModal v-bind:showModal="showModal" v-bind:hideModal="hideModal" v-bind:message="message"
                               v-bind:updateSuccessAlert="updateSuccessAlert"/>
    </div>
</template>

<script>
    import MessageCustomizeModal from "./MessageCustomizeModal";
    import { db } from "../firebase";

    const messagesCollection = db.collection('messages');
    export default {
        name: "BusMessage",
        components: {
            MessageCustomizeModal
        },
        props: {
            updateSuccessAlert: Function
        },
        data() {
            return {
                showModal: false,
                messageDocs: [],
                message: {}
            }
        },
        firestore() {
            // const messageDocs = messagesCollection
                // .where('uid', '==', adminUserId); // No UID for daily message yet
            return {
                messageDocs: messagesCollection
            }
        },
        methods: {
            openModal() {
                this.showModal = true;
            },
            hideModal() {
                this.showModal = false;
            }
        },
        watch: {
            messageDocs: {
                handler(messages) {
                    if(messages.length === 1) {
                        this.message = messages[0];
                    }
                }
            }
        }
    }
</script>

<style scoped>

</style>