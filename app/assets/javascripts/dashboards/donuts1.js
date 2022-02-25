Chart.defaults.global.defaultFontColor = '#000'
Chart.defaults.global.legend.display = false

const dashboardFirstDonutChart = () => {
  const ctx = document.querySelector('#application-chart-donuts1')
  const values = ctx.getAttribute('data-values').split(',').map(Number)
  const config = {
    type: 'doughnut',
    data: {
      labels: ['Free', 'BTC', 'Admin', 'Admin NB'],
      datasets: [{
        label: '# of Votes',
        data: values,
        backgroundColor: [
          '#1cb51c',
          '#f6921a',
          '#373737',
          '#9b9b9b'
        ],
        borderColor: [
          '#1cb51c',
          '#f6921a',
          '#373737',
          '#9b9b9b'
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
    }
  }

  new Chart(ctx, config)
}
dashboardFirstDonutChart()
