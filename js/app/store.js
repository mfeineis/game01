
export const createStore = (reducer) => {
    const store = {
        all: [],
        byTopic: {},
        states: [],
        subscriptions: [],
    };

    store.states.push(reducer());

    const getState = () => store.states[store.states.length - 1];

    const dispatch = (msg) => {
        if (!store.byTopic[msg.topic]) {
            store.byTopic[msg.topic] = [];
        }

        const envelope = {
            msg,
            timestamp: Date.now(),
        };

        store.byTopic[msg.topic].push(envelope);
        store.all.push(envelope);

        const oldState = getState();
        const state = reducer(msg, oldState);
        store.states.push(state);

        store.subscriptions.forEach((it) => it(state, msg, oldState));
    };

    const subscribe = (fn) => {
        store.subscriptions.push(fn);
        return () => {
            store.subscriptions = store.subscriptions.filter((it) => {
                return it !== fn;
            });
        };
    };

    const api = {
        dispatch,
        subscribe,
    };

    if (!window.__STORES__) {
        window.__STORES__ = [];
    }

    window.__STORES__.push({ api, store });

    return api;
};

