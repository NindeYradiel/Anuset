cat <<EOF > ritual.js
function iniciarRitual() {
  const splash = document.getElementById("splash");
  splash.style.transition = "opacity 2s ease-out";
  splash.style.opacity = 0;

  setTimeout(() => {
    window.location.href = "/"; // redirige al frontend real
  }, 2000);
}
EOF
