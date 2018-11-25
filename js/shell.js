/* global Worker */
import { createStore } from './app/store';
import { createApp } from "./app/main";

if (!("Worker" in window)) {
    throw new Error("I need WebWorkers to be enabled!");
}

const trace = (...args) => console.log("[shell]", ...args);

const worker = new Worker("/js/worker.js?id=Core");
trace("worker", worker);

const pretty = (it) => JSON.stringify(it, null, "  ");

const root = document.createElement("div");
window.document.body.appendChild(root);

const pre = document.createElement("pre");
window.document.body.appendChild(pre);

const store = createStore((msg = {}, state = {}) => {
    switch (msg.topic) {
    case "system/INITIALIZED":
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
    trace("send: ", msg);
    worker.postMessage(msg);
};

const app = createApp({
    dispatch,
    subscribe: store.subscribe,
}, root);

worker.addEventListener("message", (ev) => {
    // FIXME: ORIGIN CHECKS!!!
    const msg = ev.data;
    trace("recv: ", msg, ev);

    store.dispatch(msg);
});

trace("dist/app waiting for instructions", app, store);
