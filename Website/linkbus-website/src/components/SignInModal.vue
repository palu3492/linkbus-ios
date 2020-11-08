<template>
    <b-modal id="bv-modal-sign-in" v-model="showModal" @hide="handleHideEvent">
        <div slot="modal-header" class="m-modal-header">
            <div>
                <h5 class="modal-title">Sign In</h5>
            </div>
            <button type="button" aria-label="Close" class="close" @click="hideModal">×</button>
        </div>
        <b-overlay :show="signingIn" rounded="sm" :variant="'light'" spinner-variant="primary">
            <b-form-group>
            <label>Email:</label>
            <b-form-input type="text" v-model="email"></b-form-input>
            </b-form-group>
            <label>Password:</label>
            <b-form-input type="password" v-model="password"></b-form-input>
        </b-overlay>
        <div slot="modal-footer">
            <b-button class="mx-1" variant="dark" @click="hideModal">Cancel</b-button>
            <b-button class="mx-1" variant="primary" @click="signIn">Sign In</b-button>
        </div>
    </b-modal>
</template>

<script>

    export default {
        name: "SignInModal",
        props: {
            showModal: Boolean,
            hideModal: Function,
            auth: Object
        },
        data() {
            return {
                email: null,
                password: null,
                signingIn: false
            }
        },
        methods: {
            signIn() {
                if(this.email !== null && this.password !== null) {
                    this.signingIn = true
                    this.auth.signInWithEmailAndPassword(this.email, this.password)
                        .then(function() {
                            this.signInSuccessful()
                        }.bind(this))
                }
            },
            signInSuccessful() {
                this.clear()
                this.signingIn = false
                this.hideModal()
            },
            clear() {
                this.email = null
                this.password = null
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
