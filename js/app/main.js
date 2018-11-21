
export const createApp = (store, root) => {
    console.log(`createApp`, store, root);

    root.onclick = (evt) => store.dispatch({
        topic: "ROOT_CLICK",
    });

    store.subscribe(({ initialized }) => {
        root.innerHTML = `

<b>initialized: ${Boolean(initialized)}</b>

        `;
    });
};

