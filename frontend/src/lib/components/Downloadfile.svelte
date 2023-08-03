<script>
    // Define the file URL from the CDN
    export let fileURL;
    export let fileName;
    // const fileURL =
    //     "https://ds-storage.sgp1.cdn.digitaloceanspaces.com/blocktheory/op-script/initial.sh";

    // Define the desired filename for the downloaded file

    // Function to handle the download
    function downloadFile() {
        const link = document.createElement("a");
        link.href = fileURL;
        link.download = fileName;
        link.target = "_blank"; // To support older browsers

        // Append the link to the document and programmatically click it
        document.body.appendChild(link);
        link.click();

        // Remove the link from the document
        document.body.removeChild(link);
    }
</script>

<main>
    <!-- Button to trigger the file download -->
    <button
        on:click={downloadFile}
        class="btn variant-filled p-4 bg-slate-400 mb-3"
    >
        Download {fileName}
    </button>
</main>
