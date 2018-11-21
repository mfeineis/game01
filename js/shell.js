/* global Worker */
import { createStore } from './app/store';
import { createApp } from "./app/main";

if (!("Worker" in window)) {
    throw new Error("I need WebWorkers to be enabled!");
}

const worker = new Worker("/js/worker.js?id=x");
console.log("worker", worker);

const pretty = (it) => JSON.stringify(it, null, "  ");

const root = document.createElement("div");
window.document.body.appendChild(root);

const pre = document.createElement("pre");
window.document.body.appendChild(pre);

const store = createStore((msg = {}, state = {}) => {
    switch (msg.topic) {
    case "GAME_INITIALIZED":
        return {
            ...state,
            initialized: true,
        };
    case "ROOT_CLICKED":
        return {
            ...state,
            rootClicked: true,
        };
    default:
        return state;
    }
});

const dispose = store.subscribe((newState, msg, oldState) => {
    pre.innerHTML = `MSG:   ${pretty(msg)}\n` + pre.innerHTML;
    pre.innerHTML = `STATE: ${pretty(newState)}\n` + pre.innerHTML;
});

const dispatch = (msg) => {
    console.log("send: ", msg);
    worker.postMessage(msg);
};

const app = createApp({
    dispatch,
    subscribe: store.subscribe,
}, root);

worker.addEventListener("message", (ev) => {
    // FIXME: ORIGIN CHECKS!!!
    const msg = ev.data;
    console.log("recv: ", msg, ev);

    store.dispatch(msg);
});

console.log("dist/app", app, store);
