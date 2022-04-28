  const canvas = document.querySelectorAll('.chartjs-render-monitor');
  const chart1 = document.querySelectorAll('#chart-1');
  const chart2 = document.querySelectorAll('#chart-2');

  canvas.forEach((canvas) => {
    canvas.style.width = "56px";
    canvas.style.height = "56px";
  });

  chart1.forEach((chart) => {
    chart.style = "";
  });

  chart2.forEach((chart) => {
    chart.style = "";
  });
  