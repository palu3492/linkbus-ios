
import firebase from 'firebase/app'
import 'firebase/firestore'

const production = false; // PRODUCTION VARIABLE
const staging = false; // STAGING VARIABLE
const development = true; // DEVELOPMENT VARIABLE
let firebaseConfig = {}
if(production){
    firebaseConfig = {
        apiKey: "AIzaSyC7zIyDcPvsjI0qqfJSRlbcf4Dqtlod_dM",
        authDomain: "linkbus-website.firebaseapp.com",
        databaseURL: "https://linkbus-website.firebaseio.com",
        projectId: "linkbus-website",
        storageBucket: "linkbus-website.appspot.com",
        messagingSenderId: "974887645339",
        appId: "1:974887645339:web:7356dbff63bd18e841d63e",
        measurementId: "G-ZCGSH2CENZ"
    };
} else if(staging) {
    firebaseConfig = {
        apiKey: "AIzaSyCAOJ3A8ErRAEmZ4jbS6WKWlNFvnXykD38",
        authDomain: "linkbus-website-staging.firebaseapp.com",
        databaseURL: "https://linkbus-website-staging.firebaseio.com",
        projectId: "linkbus-website-staging",
        storageBucket: "linkbus-website-staging.appspot.com",
        messagingSenderId: "732764342754",
        appId: "1:732764342754:web:0440f0284efead531451bb",
        measurementId: "G-2FWG5HH16D"
    };
} else if(development) {
    firebaseConfig = {
        apiKey: "AIzaSyA0WX8iuYyJyS1Qq3JwxdVMnWuoFFwoBIk",
        authDomain: "linkbus-website-development.firebaseapp.com",
        databaseURL: "https://linkbus-website-development.firebaseio.com",
        projectId: "linkbus-website-development",
        storageBucket: "linkbus-website-development.appspot.com",
        messagingSenderId: "800787565397",
        appId: "1:800787565397:web:a8172fb6d432cf145a7ddc",
        measurementId: "G-GCRQX5F34M"
    };
}

// Initialize Firebase
const firebaseApp = firebase.initializeApp(firebaseConfig);
const db = firebaseApp.firestore()
const { Timestamp } = firebase.firestore

export { db, Timestamp }