
import firebase from 'firebase/app'

const firebaseConfig = {
    apiKey: "AIzaSyC7zIyDcPvsjI0qqfJSRlbcf4Dqtlod_dM",
    authDomain: "linkbus-website.firebaseapp.com",
    databaseURL: "https://linkbus-website.firebaseio.com",
    projectId: "linkbus-website",
    storageBucket: "linkbus-website.appspot.com",
    messagingSenderId: "974887645339",
    appId: "1:974887645339:web:7356dbff63bd18e841d63e",
    measurementId: "G-ZCGSH2CENZ"
};
// Initialize Firebase
const firebaseApp = firebase.initializeApp(firebaseConfig);
console.log(firebaseApp)