// Consolidated Holdings
const consolidatedDetailed = document.getElementById("consolidated-detailed");
consolidatedDetailed.addEventListener("click", (event) => {
  event.preventDefault();
  $(".toggle-mobile-consolidated").addClass("hidden-xs hidden-sm")
  $("#consolidated-simplified").removeClass("hidden-xs hidden-sm")
  $("#consolidated-desktop").removeClass("hidden-xs hidden-sm")
  $("#consolidated-mobile").addClass("hidden-xs hidden-sm")
});

const consolidatedSimplified = document.getElementById("consolidated-simplified");
consolidatedSimplified.addEventListener("click", (event) => {
  event.preventDefault();
  $(".toggle-mobile-consolidated").addClass("hidden-xs hidden-sm")
  $("#consolidated-detailed").removeClass("hidden-xs hidden-sm")
  $("#consolidated-mobile").removeClass("hidden-xs hidden-sm")
  $("#consolidated-desktop").addClass("hidden-xs hidden-sm")
});

// All Holdings
const allDetailed = document.getElementById("all-detailed");
allDetailed.addEventListener("click", (event) => {
  event.preventDefault();
  $(".toggle-mobile-simplified").addClass("hidden-xs hidden-sm")
  $("#all-simplified").removeClass("hidden-xs hidden-sm")
  $("#all-desktop").removeClass("hidden-xs hidden-sm")
  $("#all-mobile").addClass("hidden-xs hidden-sm")
});

const allSimplified = document.getElementById("all-simplified");
allSimplified.addEventListener("click", (event) => {
  event.preventDefault();
  $(".toggle-mobile-simplified").addClass("hidden-xs hidden-sm")
  $("#all-detailed").removeClass("hidden-xs hidden-sm")
  $("#all-mobile").removeClass("hidden-xs hidden-sm")
  $("#all-desktop").addClass("hidden-xs hidden-sm")
});

console.log("Mobile toggling enabled")
