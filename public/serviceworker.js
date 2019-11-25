self.addEventListener("push", (event) => {
  let title = (event.data && event.data.text()) || "Yay a message";
  let body = "Nouvelle notification de BeRomantic.fr";
  let tag = "push-simple-demo-notification-tag";
  let icon = 'BeRomantic_logo_1.png';

  event.waitUntil(
    self.registration.showNotification(title, { body, icon, tag })
  )
});
