<template>
    <b-form-group :disabled="disabled" class="date-form">
        <b-form-datepicker v-model="date" locale="en" hide-header label-help="" dropup
                           nav-button-variant="primary"></b-form-datepicker>
        <b-form-timepicker v-model="time" locale="en" hide-header label-help="" dropup
                           close-button-variant="outline-primary"></b-form-timepicker>
    </b-form-group>
</template>

<script>

    export default {
        name: "ChangeDate",
        data() {
            return {
                // dateContext: {},
                // timeContext: {},
                time: "",
                date: "",
            }
        },
        props: {
            // timeProp: String,
            // dateProp: String,
            dateTime: Object,
            disabled: Boolean,
            // onDateContext: Function,
            // onTimeContext: Function
        },
        methods: {
            // onDateContext(ctx) {
            //     this.dateContext = ctx
            // },
            // onTimeContext(ctx) {
            //     this.timeContext = ctx
            // }
            // onDateContext(context) {
            //     console.log(context.selectedYMD)
            //     // this.dateChanged()
            // },
            // onTimeContext(context) {
            //     console.log(context.value)
            // }
            /*
            activeDate: Fri Nov 27 2020 00:00:00 GMT-0600 (Central Standard Time) {}
            activeFormatted: "Friday, November 27, 2020"
            activeYMD: "2020-11-27"
            calendarLocale: "en"
            disabled: false
            locale: "en"
            rtl: false
            selectedDate: Fri Nov 27 2020 00:00:00 GMT-0600 (Central Standard Time) {}
            selectedFormatted: "Friday, November 27, 2020"
            selectedYMD: "2020-11-27"
             */
        },
        watch: {
            dateTime: {
                immediate: true,
                handler(dateTime) {
                    // console.log(dateTime);
                    this.time = dateTime.time;
                    this.date = dateTime.date;
                }
            },
            time: {
                immediate: true,
                handler(time) {
                    // console.log(time);
                    this.dateTime.time = time;
                }
            },
            date: {
                immediate: true,
                handler(date) {
                    // console.log(date);
                    this.dateTime.date = date;
                }
            },
            // dateProp: {
            //     immediate: true,
            //     handler(date) {
            //         this.date = date;
            //     }
            // },
            // timeProp: {
            //     // deep: true,
            //     immediate: true,
            //     handler(time) {
            //         this.time = time;
            //     }
            //     // console.log(time);
            //     // console.log(old);
            //     // this.date = time;
            // }
        },
    }
</script>

<style scoped>
    /* Remove border on time and date picker */
    .b-form-datepicker, .b-form-timepicker {
        border: none !important;
        box-shadow: none !important;
    }
    .date-form {
        border: 1px solid #ced4da;
        border-radius: .25rem;
    }
    /*.disabled-overlay {*/
    /*    position: absolute;*/
    /*    top: 0;*/
    /*    left: 0;*/
    /*    width: 100%;*/
    /*    background: grey;*/
    /*}*/
</style>