// Consolidated Holdings
const consolidatedDetailed = document.getElementById("consolidated-detailed");
consolidatedDetailed.addEventListener("click", (event) => {
  event.preventDefault();
  $(".toggle-mobile-consolidated").addClass("hidden-xs")
  $("#consolidated-simplified").removeClass("hidden-xs")
  $("#consolidated-desktop").removeClass("hidden-xs")
  $("#consolidated-mobile").addClass("hidden-xs")
});

const consolidatedSimplified = document.getElementById("consolidated-simplified");
consolidatedSimplified.addEventListener("click", (event) => {
  event.preventDefault();
  $(".toggle-mobile-consolidated").addClass("hidden-xs")
  $("#consolidated-detailed").removeClass("hidden-xs")
  $("#consolidated-mobile").removeClass("hidden-xs")
  $("#consolidated-desktop").addClass("hidden-xs")
});

// All Holdings
const allDetailed = document.getElementById("all-detailed");
allDetailed.addEventListener("click", (event) => {
  event.preventDefault();
  $(".toggle-mobile-simplified").addClass("hidden-xs")
  $("#all-simplified").removeClass("hidden-xs")
  $("#all-desktop").removeClass("hidden-xs")
  $("#all-mobile").addClass("hidden-xs")
});

const allSimplified = document.getElementById("all-simplified");
allSimplified.addEventListener("click", (event) => {
  event.preventDefault();
  $(".toggle-mobile-simplified").addClass("hidden-xs")
  $("#all-detailed").removeClass("hidden-xs")
  $("#all-mobile").removeClass("hidden-xs")
  $("#all-desktop").addClass("hidden-xs")
});

console.log("Mobile toggling enabled")
