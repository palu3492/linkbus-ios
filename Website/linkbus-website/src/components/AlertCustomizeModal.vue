<template>
    <b-form>
        <div class="d-flex">
            <b-input-group style="width: auto">
                <span class="mr-2">Active</span>
                <b-form-checkbox switch v-model="formData.active"></b-form-checkbox>
            </b-input-group>
            <b-input-group class="ml-md-4" style="width: auto">
                <span class="mr-2">Full-width</span>
                <b-form-checkbox switch v-model="formData.fullWidth"></b-form-checkbox>
            </b-input-group>
        </div>

        <b-input-group prepend="Body" class="mt-3">
            <b-form-input :state="validBody" v-model="formData.text" required></b-form-input>
        </b-input-group>

        <b-input-group prepend="Action" class="mt-3">
            <b-input-group-prepend is-text>
                <b-form-checkbox switch v-model="formData.clickable"></b-form-checkbox>
            </b-input-group-prepend>
            <b-form-input url v-model="formData.action" :disabled="!formData.clickable"
                          :state="validUrl" placeholder="http://www.example.com"></b-form-input>
        </b-input-group>

        <p class="mb-0 mt-3">Background Color</p>
        <b-row class="d-flex">
            <b-col>
                <b-form-text class="m-0">iOS Color Palette</b-form-text>
                <b-form-select v-model="formData.color" :options="colorOptions"></b-form-select>
            </b-col>
            <b-col cols='auto'>
                <p class="mt-4 mb-0">OR</p>
            </b-col>
            <b-col>
                <b-form-text class="m-0">RGB Color</b-form-text>
                <b-form-input type="color" v-model="formData.colorCode" :disabled="formData.color !== ''"></b-form-input>
            </b-col>
        </b-row>
    </b-form>
</template>

<script>
    export default {
        name: "AlertModal",
        props: {
            formData: Object
        },
        data() {
            return {
                colorOptions: [
                    {value: '', text: 'Select'},
                    {value: 'red', text: 'Red'},
                    {value: 'green', text: 'Green'},
                    {value: 'blue', text: 'Blue'},
                    {value: 'yellow', text: 'Yellow'},
                ]
            }
        },
        computed: {
            validUrl() {
                if(this.formData.clickable === undefined || this.formData.action === undefined){
                    return null;
                }
                if(this.formData.clickable) {
                    if(this.formData.action.length > 0){
                        return true;
                    }
                }
                return null;
            },
            validBody() {
                if(this.formData.text === undefined){
                    return null;
                }
                if(this.formData.text.length === 0){
                    return null
                } else if (this.formData.text.length < 5){
                    return false;
                }
                return true;
            }
        }
    }
</script>

<style scoped>

</style>