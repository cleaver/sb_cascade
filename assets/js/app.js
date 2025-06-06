// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";
import Sortable from "../vendor/sortablejs";
import ToggleThemeHook from "../vendor/set_theme";

let Hooks = {};
Hooks.ToggleThemeHook = ToggleThemeHook;
// Hooks.Sortable = {
//   mounted(){
//     let group = this.el.dataset.group
//     let sorter = new Sortable(this.el, {
//       group: group ? {name: group, pull: true, put: true} : undefined,
//       animation: 150,
//       delay: 100,
//       dragClass: "drag-item",
//       ghostClass: "drag-ghost",
//       forceFallback: true,
//       onEnd: e => {
//         let params = {old: e.oldIndex, new: e.newIndex, to: e.to.dataset, ...e.item.dataset}
//         this.pushEventTo(this.el, "reposition", params)
//       }
//     })
//   }
// }

Hooks.SortableInputsFor = {
  mounted(){
    let group = this.el.dataset.group
    let sorter = new Sortable(this.el, {
      group: group ? {name: group, pull: true, put: true} : undefined,
      animation: 150,
      dragClass: "drag-item",
      ghostClass: "drag-ghost",
      handle: "[data-handle]",
      forceFallback: true,
      onEnd: e => {
        this.el.closest("form").querySelector("input").dispatchEvent(new Event("input", {bubbles: true}))
      }
    })
  }
}


let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// Format all time elements with a datetime attribute
document.addEventListener("phx:update", () => {
  const source_elements = document.querySelectorAll("time");
  source_elements.forEach((source_element) => {
    source_element.innerText = new Date(
      source_element.getAttribute("datetime"),
    ).toLocaleString();
  });
});

// Have flash messages disappear after 6 seconds.
document.addEventListener("phx:update", () => {
  const flashMessages = document.querySelectorAll("#flash-group > div");
  flashMessages.forEach((flashMessage) => {
    setTimeout(() => {
      flashMessage.remove();
    }, 6000);
  });
});

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
