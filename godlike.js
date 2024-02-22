document
    .querySelector("#command-install")
    .addEventListener("click", event => {
        window.getSelection().selectAllChildren(
            event.target
        );
    });
