<script lang="ts">
    import { popup } from "@skeletonlabs/skeleton";
    import type { PopupSettings } from "@skeletonlabs/skeleton";
    import Info from "$lib/images/info.svg";
    const popupHover: PopupSettings = {
        event: "hover",
        target: "popupHover",
        placement: "top",
    };

    export let content: string = "";
</script>

<span use:popup={popupHover}>
    <img src={Info} alt="info_icon" class="cursor-pointer w-4 h-4 mx-2" />
</span>

<div class="card p-4 variant-filled-white" data-popup="popupHover">
    <div class="text-sm">{content}</div>
    <div class="arrow variant-filled-white" />
</div>
