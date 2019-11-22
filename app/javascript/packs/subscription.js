
if (navigator.serviceWorker) {
  navigator.serviceWorker.register('/serviceworker.js')
    .then(function(reg) {
     console.log('Service worker change, registered the service worker');
  });
} else {
  console.error('Service worker is not supported in this browser');
}


navigator.serviceWorker.ready.then((serviceWorkerRegistration) => {
  serviceWorkerRegistration.pushManager
  .subscribe({
    userVisibleOnly: true,
    applicationServerKey: window.vapidPublicKey
  });
});
console.log('gdgfd')
// $(".webpush-button").on("click", (e) => {
  navigator.serviceWorker.ready
  .then((serviceWorkerRegistration) => {
    serviceWorkerRegistration.pushManager.getSubscription()
    .then((subscription) => {
      // $.post("/push", { subscription: subscription.toJSON(), message: "You clicked a button!" });
      // Donner l'info JSON en AJAX et updater le champ subscription du USER.
      console.log(subscription.toJSON());

      $.ajax({
        url: `http://localhost:3000/ajax/users`,
        method: "post",
        // data: {userId: currentUserToScript}
        data: "subscription=" + JSON.stringify(subscription),
        dataType : 'html'
      })
    });
  });
// });
