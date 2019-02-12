// Landing Page: Performance Charts
const chartSPY = document.getElementById("tab-spy");
chartSPY.addEventListener("click", (event) => {
  event.preventDefault();
  $(".performance-chart").addClass("hidden")
  $("#chart-spy").removeClass("hidden")
  $(".tab").removeClass("selected")
  $("#tab-spy").addClass("selected")
});

const chartCommunications = document.getElementById("tab-communications");
chartCommunications.addEventListener("click", (event) => {
  event.preventDefault();
  $(".performance-chart").addClass("hidden")
  $("#chart-communications").removeClass("hidden")
  $(".tab").removeClass("selected")
  $("#tab-communications").addClass("selected")
});

const chartTechnology = document.getElementById("tab-technology");
chartTechnology.addEventListener("click", (event) => {
  event.preventDefault();
  $(".performance-chart").addClass("hidden")
  $("#chart-technology").removeClass("hidden")
  $(".tab").removeClass("selected")
  $("#tab-technology").addClass("selected")
});

const chartUtilities = document.getElementById("tab-utilities");
chartUtilities.addEventListener("click", (event) => {
  event.preventDefault();
  $(".performance-chart").addClass("hidden")
  $("#chart-utilities").removeClass("hidden")
  $(".tab").removeClass("selected")
  $("#tab-utilities").addClass("selected")
});

const chartHealthcare = document.getElementById("tab-healthcare");
chartHealthcare.addEventListener("click", (event) => {
  event.preventDefault();
  $(".performance-chart").addClass("hidden")
  $("#chart-healthcare").removeClass("hidden")
  $(".tab").removeClass("selected")
  $("#tab-healthcare").addClass("selected")
});

const chartRealEstate = document.getElementById("tab-realestate");
chartRealEstate.addEventListener("click", (event) => {
  event.preventDefault();
  $(".performance-chart").addClass("hidden")
  $("#chart-realestate").removeClass("hidden")
  $(".tab").removeClass("selected")
  $("#tab-realestate").addClass("selected")
});

const chartMaterials = document.getElementById("tab-materials");
chartMaterials.addEventListener("click", (event) => {
  event.preventDefault();
  $(".performance-chart").addClass("hidden")
  $("#chart-materials").removeClass("hidden")
  $(".tab").removeClass("selected")
  $("#tab-materials").addClass("selected")
});

const chartConsumer = document.getElementById("tab-consumer");
chartConsumer.addEventListener("click", (event) => {
  event.preventDefault();
  $(".performance-chart").addClass("hidden")
  $("#chart-consumer").removeClass("hidden")
  $(".tab").removeClass("selected")
  $("#tab-consumer").addClass("selected")
});

const chartEnergy = document.getElementById("tab-energy");
chartEnergy.addEventListener("click", (event) => {
  event.preventDefault();
  $(".performance-chart").addClass("hidden")
  $("#chart-energy").removeClass("hidden")
  $(".tab").removeClass("selected")
  $("#tab-energy").addClass("selected")
});

const chartFinancials = document.getElementById("tab-financials");
chartFinancials.addEventListener("click", (event) => {
  event.preventDefault();
  $(".performance-chart").addClass("hidden")
  $("#chart-financials").removeClass("hidden")
  $(".tab").removeClass("selected")
  $("#tab-financials").addClass("selected")
});

console.log("Sector toggling enabled")
