window.addEventListener('resize', function() {
  const hamburgerToggle = document.getElementById('hamburgerToggle');
  const hamburgerToggleMobile = document.getElementById('hamburgerToggleMobile');

  if (hamburgerToggle) {
    hamburgerToggle.checked = false;
  }

  if (hamburgerToggleMobile) {
    hamburgerToggleMobile.checked = false;
  }
});
