document
    .querySelector("#command-install")
    .addEventListener("click", event => {
        event.target.select();
        // event.target.setSelectionRange(0, 99999);
        // navigator.clipboard.writeText(event.target.value);
    });
