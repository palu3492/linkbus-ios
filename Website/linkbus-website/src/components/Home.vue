<template>
    <div >
        <h3>General</h3>
        <hr />
<!--        <p>Background Color:</p>-->
<!--        <p>Font Color:</p>-->

        <h3>Alerts</h3>
        <hr />
        <div>
            <div  v-if="alerts.length > 0">
                <Alert v-for="alert in alerts" v-bind:key="alert.id" v-bind:text="alert.text"/>
            </div>
            <p v-else>No Alerts</p>
        </div>

        <h3>Routes</h3>
        <hr />

        <DeleteModal />
        <EditModal />
    </div>
</template>

<script>
    import { db } from '../firebase';
    import Alert from './Alert.vue'
    import DeleteModal from './DeleteModal.vue'
    import EditModal from './EditModal.vue'
    const alertsPath = 'alerts/alert-0293857245';

    const alertsCollection = db.collection('alerts');

    export default {
        name: "Home",
        components: {
            Alert,
            DeleteModal,
            EditModal
        },
        data: () => {
            return {
                formData: {},
                alerts: []
            }
        },

        other() {
            console.log('other test');
        },

        firestore() {
            // console.log('called');
            // const data = db.doc(alertsPath)
            // console.log(data)
            // return {
            //     firebaseData: data
            // }
            // const updatedAlerts = []
            // const alertsRef = db.collection('alerts');
            // Get user's alerts
            const alertDocs = alertsCollection
                .where('uid', '==', 1)
            return {
                alerts: alertDocs
            }
            // if(alertDocs.size === 0){
            //     // No alerts!
            //     this.alerts = [];
            // } else {
            //     // More than 1 alert
            //     alertDocs.forEach(alertDoc => {
            //         let alert = alertDoc.data();
            //         alert.id = alertDoc.id;
            //         updatedAlerts.push(alert)
            //     })
            // }
            // this.alerts = updatedAlerts;
        },

        methods: {
            async updateFirebase() {
                try{
                    await db.doc(alertsPath).set(this.formData)
                } catch(error) {
                    console.log(error)
                }
            }
        },

        created: async function() {
            // // const alertsRef = db.doc(documentPath);
            // const alertsRef = db.collection('alerts');
            // console.log('alertsRef');
            // console.log(alertsRef)
            // const alerts = await alertsRef
            //     .where('uid', '==', 1)
            //     .get()
            // if(alerts.size === 0){
            //     // No alerts!
            //     this.alerts = [];
            // } else {
            //     alerts.forEach(alertDoc => {
            //         let alert = alertDoc.data();
            //         alert.id = alertDoc.id;
            //         this.alerts.push(alert)
            //     })
            // }
            // // let data = (await alertsRef
            // //     .where('uid','==', 1).get()).data()
            // // let data = (await alertsRef.get())
            // // //
            // // console.log('data')
            // // console.log(data)
        }
    }
</script>

<style scoped>
    h1{
        text-align: center;
    }
    h3{
        margin-bottom: 0;
    }
    hr{
        margin-top: 0;
    }

</style>