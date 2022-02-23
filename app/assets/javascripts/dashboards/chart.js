Chart.defaults.global.defaultFontColor = '#000'
Chart.defaults.global.legend.display = false

const dashboardLineChart = () => {
  const ctx = document.querySelector('#application-chart')
  const labels = ctx.getAttribute('data-labels').replace(/[^a-z0-9, ]/gi, '').split(',')
  const incomingAmounts = ctx.getAttribute('data-incoming-amounts').split(',').map(Number)
  const paidWithdrawsAmounts = ctx.getAttribute('data-paid-withdraws-amounts').split(',').map(Number)
  const expensesAmounts = ctx.getAttribute('data-expenses-amounts').split(',').map(Number)
  const data = {
    labels: labels,
    datasets: [
      {
        label: '',
        data: incomingAmounts,
        backgroundColor: '#373737',
        fill: false,
        borderColor: '#ff8800',
        tension: 0.1,
        color: '#ffffff',
        display: false
      },
      {
        label: '',
        data: paidWithdrawsAmounts,
        backgroundColor: '#373737',
        fill: false,
        borderColor: '#1119ff',
        tension: 0.1,
        color: '#ffffff',
        display: false
      },
      {
        label: '',
        data: expensesAmounts,
        backgroundColor: '#373737',
        fill: false,
        borderColor: '#0fb1ff',
        tension: 0.1,
        color: '#ffffff',
        display: false
      }
    ]
  }

  const config = {
    type: 'line',
    data: data,
    options: {
      plugins: {
        legend: {
          labels: {
            boxWidth: 0
          }
        }
      }
    }
  }
  new Chart(ctx, config)
};
dashboardLineChart()
