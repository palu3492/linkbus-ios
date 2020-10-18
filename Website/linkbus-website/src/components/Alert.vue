<template>
    <div>
        <p><b>Alert</b> Text: {{ text }}</p>

    </div>
</template>

<!--action-->
<!--"https://www.csbsju.edu/covid-19"-->
<!--active-->
<!--true-->
<!--clickable-->
<!--true-->
<!--color-->
<!--"red"-->
<!--fullWidth-->
<!--false-->
<!--id-->
<!--1-->
<!--text-->
<!--"A face mask is required to ride the CSB/SJU Link."-->
<!--uid-->
<!--1-->

<script>
    export default {
        name: "Alert",
        props: ["action", "active", "clickable", "color", "rgb", "fullWidth", "text"]
    }
</script>

<style scoped>

</style>