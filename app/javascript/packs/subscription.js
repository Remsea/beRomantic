
if (navigator.serviceWorker) {
  navigator.serviceWorker.register('/serviceworker.js')
    .then(function(reg) {
      subscribeNotification();
    });
} else {
  console.error('Service worker is not supported in this browser');
}

function subscribeNotification() {
  navigator.serviceWorker.ready.then((serviceWorkerRegistration) => {
    serviceWorkerRegistration.pushManager
      .subscribe({
        userVisibleOnly: true,
        applicationServerKey: window.vapidPublicKey
      })
      .then(() => {
        sendCredentialsToServer();
      })
  });
}

function sendCredentialsToServer() {
  navigator.serviceWorker.ready
    .then((serviceWorkerRegistration) => {
      serviceWorkerRegistration.pushManager.getSubscription()
      .then((subscription) => {
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
}
