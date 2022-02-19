Chart.defaults.global.defaultFontColor = "#000"
Chart.defaults.global.legend.display = false

let applicationChart = () => {
  const ctx = document.querySelector('#application-chart');
  const labels = ctx.getAttribute('data-labels').replace(/[^a-z0-9, ]/gi,'').split(',');
  const values = ctx.getAttribute('data-values').split(',').map(Number);;
  const valuesA = ctx.getAttribute('data-values-2').split(',').map(Number);;
  const valuesB = ctx.getAttribute('data-values-3').split(',').map(Number);;
  const title = ctx.getAttribute('data-title');
  const data = {
    labels: labels,
    datasets: [
      {
        label: '',
        data: values,
        backgroundColor: '#373737',
        fill: false,
        borderColor: '#81c869',
        tension: 0.1,
        color: '#ffffff',
        display: false,
      },
      {
        label: '',
        data: valuesA,
        backgroundColor: '#373737',
        fill: false,
        borderColor: '#000',
        tension: 0.1,
        color: '#ffffff',
        display: false,
      },
      {
        label: '',
        data: valuesB,
        backgroundColor: '#373737',
        fill: false,
        borderColor: '#ff00f0',
        tension: 0.1,
        color: '#ffffff',
        display: false,
      }
    ]
  };

  const config = {
    type: 'line',
    data: data,
    options: {
      plugins: {
        legend: {
          labels: {
            boxWidth: 0
          },
        },
      },
      scales: {
        x: {
          display: true,
          title: {
            display: true,
            text: title
          }
        }
      },
    },
  };
  new Chart(ctx, config);
};
applicationChart();
