// Transaction Summary
const transactionsDetailed = document.getElementById("transactions-detailed");
transactionsDetailed.addEventListener("click", (event) => {
  event.preventDefault();
  $(".toggle-mobile-transactions").addClass("hidden-xs hidden-sm")
  $("#transactions-simplified").removeClass("hidden-xs hidden-sm")
  $("#transactions-desktop").removeClass("hidden-xs hidden-sm")
  $("#transactions-mobile").addClass("hidden-xs hidden-sm")
});

const transactionsSimplified = document.getElementById("transactions-simplified");
transactionsSimplified.addEventListener("click", (event) => {
  event.preventDefault();
  $(".toggle-mobile-transactions").addClass("hidden-xs hidden-sm")
  $("#transactions-detailed").removeClass("hidden-xs hidden-sm")
  $("#transactions-mobile").removeClass("hidden-xs hidden-sm")
  $("#transactions-desktop").addClass("hidden-xs hidden-sm")
});
