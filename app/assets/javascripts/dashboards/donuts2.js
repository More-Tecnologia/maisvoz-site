Chart.defaults.global.defaultFontColor = "#000"
Chart.defaults.global.legend.display = false

const dashboardSecondDonutChart = () => {
  const ctx = document.querySelector('#application-chart-donuts2')
  const values = ctx.getAttribute('data-values').split(',').map(Number)
  const labels = ctx.getAttribute('data-labels').split(',')
  const config = {
    type: 'doughnut',
    data: {
      labels: labels,
      datasets: [{
        label: '# of Votes',
        data: values,
        backgroundColor: [
          '#1cb51c',
          '#f6921a',
          '#627de9',
          '#9b9b9b',
          '#FF0000'
        ],
        borderColor: [
          '#1cb51c',
          '#f6921a',
          '#627de9',
          '#9b9b9b',
          '#FF0000'
        ],
        borderWidth: 1
      }]
    },
    options: {
      scales: {
        y: {
          beginAtZero: true
        }
      }
    },
    hoverOffset: 4
  }

  new Chart(ctx, config)
}
dashboardSecondDonutChart()
