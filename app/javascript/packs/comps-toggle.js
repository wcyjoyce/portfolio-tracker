// Comps
const compsDetailed = document.getElementById("comps-detailed");
compsDetailed.addEventListener("click", (event) => {
  event.preventDefault();
  $(".toggle-mobile-comps").addClass("hidden-xs hidden-sm")
  $("#comps-simplified").removeClass("hidden-xs hidden-sm")
  $("#comps-desktop").removeClass("hidden-xs hidden-sm")
  $("#comps-mobile").addClass("hidden-xs hidden-sm")
});

const compsSimplified = document.getElementById("comps-simplified");
compsSimplified.addEventListener("click", (event) => {
  event.preventDefault();
  $(".toggle-mobile-comps").addClass("hidden-xs hidden-sm")
  $("#comps-detailed").removeClass("hidden-xs hidden-sm")
  $("#comps-mobile").removeClass("hidden-xs hidden-sm")
  $("#comps-desktop").addClass("hidden-xs hidden-sm")
});

console.log("Comps toggling enabled")
