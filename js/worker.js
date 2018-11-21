(function (window, main) {

    const flags = {
        id: null,
    };

    window.location.href.replace(/id=([^&]+)/, (_, id) => {
        flags.id = id;
    });

    main(window, flags);

}(self, (window, flags) => {
    window.importScripts("/dist/core.js");

    const trace = (...args) => console.log(...args);

    const app = window.Elm.Game.Core.init({
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
