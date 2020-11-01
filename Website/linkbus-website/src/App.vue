<template>
  <div id="app">
    <b-container class="px-0 d-flex flex-column">
        <b-row class="m-0">
          <b-col cols="3"/>
          <b-col cols="6">
            <h1 id="title" class="mt-2">Linkbus</h1>
          </b-col>
          <b-col cols="3" class="text-right mt-3">
            <b-button v-if="!signedIn" @click="signIn" size="sm" variant="outline-primary">
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
  </div>
</template>

<script>
import Home from './components/Home.vue'
import firebase from 'firebase/app'
import "firebase/auth";

const auth = firebase.auth();
const provider = new firebase.auth.GoogleAuthProvider();
provider.addScope('profile');
provider.addScope('email');

import { BIconPerson } from 'bootstrap-vue'

export default {

  name: 'App',
  components: {
    Home, BIconPerson
  },
  data() {
    return {
      signedIn: false,
      token: null,
      user: null
    }
  },
  methods: {
    // Bind
    signIn() {
      // Using a popup
      auth.signInWithPopup(provider).then(function(result) {
        // This gives you a Google Access Token.
        this.token = result.credential.accessToken;
        // The signed-in user info.
        this.user = result.user;
        console.log(this.user);
        this.signedIn = true
      }.bind(this));
    },
    signOut() {
      auth.signOut()
      this.signedIn = false
    }
    // auth.onAuthStateChanged(user => {
    //   if(user) {
    //     itemsReference = db.collection('items')
    //
    //     const { serverTimestamp } = firebase.firestore.FieldValue;
    //     createItemButton.onclick = () => {
    //       itemsReference.add({
    //         uid: user.uid,
    //         name: 'Item New',
    //         createdAt: serverTimestamp()
    //       })
    //     }
    //
    //     unsubscribe = itemsReference
    //             .where('uid', '==', user.uid)
    //             .onSnapshot(querySnapshot => {
    //               const items = querySnapshot.docs.map(doc => {
    //                 return `<li>${ doc.data().name }</li>`
    //               });
    //               itemsList.innerHTML = items.join(' ')
    //             });
    //
    //   } else {
    //     unsubscribe && unsubscribe()
    //   }
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
