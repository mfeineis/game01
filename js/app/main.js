
const trace = (...args) => console.log("[app]", ...args);

export const createApp = (store, root) => {
    trace(`createApp`, store, root);

    root.onclick = (evt) => store.dispatch({
        topic: "ROOT_CLICK",
    });

    store.subscribe(({ initialized }) => {
        root.innerHTML = `

<b>initialized: ${Boolean(initialized)}</b>

        `;
    });
};

