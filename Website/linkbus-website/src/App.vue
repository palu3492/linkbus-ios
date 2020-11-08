<template>
  <div id="app">
    <b-container class="px-0 d-flex flex-column">
        <b-row class="m-0">
          <b-col cols="3"/>
          <b-col cols="6">
            <h1 id="title" class="mt-2">Linkbus</h1>
          </b-col>
          <b-col cols="3" class="text-right mt-3">
            <b-button v-if="!signedIn" @click="openSignInModal" size="sm" variant="outline-primary">
              <span class="d-none d-sm-block">Sign In</span>
              <BIconPerson class="d-block d-sm-none"/>
            </b-button>
            <b-button v-else @click="signOut" size="sm" variant="outline-primary">
              <span class="d-none d-sm-block">Sign Out</span>
              <BIconPerson class="d-block d-sm-none"/>
            </b-button>
          </b-col>
        </b-row>
      <Home v-bind:signedIn="signedIn" v-bind:user="user"/>
    </b-container>
    <SignInModal v-bind:showModal="showSignInModal" v-bind:hideModal="hideSignInModal" v-bind:auth="auth"/>
  </div>
</template>

<script>
import Home from './components/Home.vue'
import firebase from 'firebase/app'
import "firebase/auth";

// const provider = new firebase.auth.GoogleAuthProvider();
// const provider = new firebase.auth.EmailAuthProvider();
// provider.addScope('profile');
// provider.addScope('email');

import { BIconPerson } from 'bootstrap-vue'
import SignInModal from "./components/SignInModal";

export default {

  name: 'App',
  components: {
    SignInModal,
    Home, BIconPerson
  },
  data() {
    return {
      signedIn: false,
      token: null,
      user: null,
      showSignInModal: false,
      auth: firebase.auth()
    }
  },
  methods: {
    // For Google Auth
    // signIn() {
    //   // Using a popup
    //   auth.signInWithPopup(provider).then(function(result) {
    //     // This gives you a Google Access Token.
    //     this.token = result.credential.accessToken;
    //     // The signed-in user info.
    //     this.user = result.user;
    //     console.log(this.user);
    //     this.signedIn = true
    //   }.bind(this));
    // },
    openSignInModal() {
      this.showSignInModal = true;
    },
    hideSignInModal() {
      this.showSignInModal = false;
    },
    userSignedIn() {
      this.signedIn = true
    },
    signOut() {
      this.auth.signOut()
    },
    userSignedOut(){
      this.user = null
      this.signedIn = false
    },
  },
  created() {
    this.auth.onAuthStateChanged(function(user) {
      if(user){
        // Signed in
        this.user = user
        this.userSignedIn()
      } else {
        // Signed out
        this.userSignedOut()
      }
    }.bind(this))
  }
}
</script>

<style>
  #app {
    font-family: Avenir, Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    color: #2c3e50;
  }
  #title {
    text-align: center;
  }
</style>
