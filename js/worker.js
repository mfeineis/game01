(function (window, main) {

    const flags = {
        id: null,
    };

    window.location.href.replace(/id=([^&]+)/, (_, id) => {
        flags.id = id;
    });

    const whitelist = {
        Core: true,
    };

    if (!whitelist.hasOwnProperty(flags.id)) {
        throw new Error(`"${flags.id}" is not a known game system!`);
    }

    main(window, flags, flags.id.toLowerCase());

}(self, (window, flags, tag) => {
    window.importScripts(`/dist/${tag}.js`);

    const trace = (...args) => console.log(`[${tag}]`, ...args);

    const app = window.Elm.Game[flags.id].init({
        flags,
    });

    app.ports.send.subscribe((data) => {
        trace(`app.ports.send`, data);
        window.postMessage(data);
    });

    window.addEventListener("message", (ev) => {
        // FIXME: ORIGIN CHECKS!!!
        trace(`app.ports.recv`, ev.data);
        app.ports.recv.send(ev.data);
    });

    trace("worker setup done", flags, app, window);

}));
