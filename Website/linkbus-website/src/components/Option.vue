<template>
    <span>
        <span class="px-2">
            <span v-if="optionType === 'boolean'">
                {{ option }}:
                <BIconCheckCircle variant="success" v-if="optionValue" />
                <BIconXCircle variant="danger" v-else />
            </span>
            <span v-else-if="optionType === 'string'">
                {{ option }}: {{ optionValue }}
            </span>
        </span>
    </span>
</template>

<script>
    import {BIconCheckCircle, BIconXCircle} from "bootstrap-vue";

    export default {
        name: "Option",
        props: ["option", "optionValue"],
        components: {
            BIconCheckCircle, BIconXCircle
        },
        data() {
            return {

            }
        },
        computed: {
            optionType: function() {
                return typeof this.optionValue
            }
        }
    }
</script>

<style scoped>

</style>