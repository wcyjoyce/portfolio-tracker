const chart5y = document.getElementById("toggle-5y");
chart5y.addEventListener("click", (event) => {
  event.preventDefault();
  $(".performance-chart").addClass("hidden")
  $("#chart-5y").removeClass("hidden")
});

const chart1y = document.getElementById("toggle-1y");
chart1y.addEventListener("click", (event) => {
  event.preventDefault();
  $(".performance-chart").addClass("hidden")
  $("#chart-1y").removeClass("hidden")
});

const chartYTD = document.getElementById("toggle-ytd");
chartYTD.addEventListener("click", (event) => {
  event.preventDefault();
  $(".performance-chart").addClass("hidden")
  $("#chart-ytd").removeClass("hidden")
});

const chart6m = document.getElementById("toggle-6m");
chart6m.addEventListener("click", (event) => {
  event.preventDefault();
  $(".performance-chart").addClass("hidden")
  $("#chart-6m").removeClass("hidden")
});

const chart1m = document.getElementById("toggle-1m");
chart1m.addEventListener("click", (event) => {
  event.preventDefault();
  $(".performance-chart").addClass("hidden")
  $("#chart-1m").removeClass("hidden")
});

const chart1d = document.getElementById("toggle-1d");
chart1d.addEventListener("click", (event) => {
  event.preventDefault();
  $(".performance-chart").addClass("hidden")
  $("#chart-1d").removeClass("hidden")
});

console.log("Chart toggling enabled");
