const pieCharts = ["", "2", "3", "4", "5"]
const locale = $("#locale").attr('value');
const account_earnings_limit = $('#account_earnings_limit');
const balance = $('#balance');
const total_bonus = $('#total_bonus');
const gross_bonus = $('#gross_bonus');
const chargebacks = $('#chargebacks');
const unilevel_affiliates_count = $('#unilevel_affiliates_count');
const binary_affiliates_count = $('#binary_affiliates_count');

$(document).on('click', '.bt-toggle', {}, function(e) {
  charts_cleaner();
  $('.donut-legend').empty();
  getInstance();
});

function charts_cleaner() {
  pieCharts.forEach(function(item, _, _) {
    $('#pie-chart' + item).empty();
  })
  account_earnings_limit.empty();
  balance.empty();
  total_bonus.empty();
  gross_bonus.empty();
  chargebacks.empty();
  unilevel_affiliates_count.empty();
  binary_affiliates_count.empty();
  return false;
};


async function getInstance() {
  let path = '/backoffice/dashboard/user_data.json?locale=' + locale
  try {
    let response = await fetch(path);
    if (response.ok) {
      let instances = await response.json();
      let user_data = JSON.parse(JSON.stringify(instances.data))
      let labels = JSON.parse(JSON.stringify(instances.labels))
      let bonus = user_data.bonus
      let earnings = user_data.earnings
      let balances = user_data.balances
      let unilevel_counts = user_data.unilevel_counts
      let binary_count = user_data.binary_count

      account_earnings_limit.append("<strong>" + earnings.account_earnings_limit + "</strong>").addClass('btn-info');
      balance.append(balances.balance).addClass('btn-success');
      total_bonus.append(bonus.total_bonus).addClass('btn-warning');
      gross_bonus.append(bonus.gross_bonus).addClass('btn-success');
      chargebacks.append(bonus.chargebacks).addClass('btn-danger');
      unilevel_affiliates_count.append(unilevel_counts.unilevel_affiliates_count).addClass('btn-primary');
      binary_affiliates_count.append(binary_count.binary_affiliates_count).addClass('btn-white');
      var browsersChart = Morris.Donut({
        element: 'pie-chart',
        colors: ["#00a65a", "#555299"],
        data: [
          {label: labels.receivable_amount, value: earnings.receivable_amount},
          {label: labels.received_amount, value: earnings.received_amount}
        ]
      });


      browsersChart.options.data.forEach(function(label, i){
        var legendItem = $('<div class="fix-right-a"></div>').text(label['label'] + " ( " +label['value'] + " )").prepend('<i>&nbsp;</i>');

          legendItem.find('i').css('backgroundColor', browsersChart.options.colors[i]);
          $('#legend1').append(legendItem)
          $('#legend1').addClass('text-center')
        })


      let browsersChart2 = Morris.Donut({
        element: 'pie-chart2',
        colors: ["#00a65a", "#d9534f"],
        data: [
          {label: labels.available_balance, value: balances.available_balance},
          {label: labels.blocked_balance, value: balances.blocked_balance},
        ]
      });

      browsersChart2.options.data.forEach(function(label, i){
        var legendItem = $('<div class="fix-right-a"></div>').text(label['label'] + " ( " +label['value'] + " )").prepend('<i>&nbsp;</i>');

          legendItem.find('i').css('backgroundColor', browsersChart2.options.colors[i]);
          $('#legend2').append(legendItem)
          $('#legend2').addClass('text-center')
        })

      let browsersChart3 = Morris.Donut({
        element: 'pie-chart3',
        colors: ["#00a65a", "#292b2c", "#3c8dbc", "#5bc0de", "#a3a3a3", "#d9534f"],
        data: [
          {label: labels.binary_bonus, value: bonus.binary_bonus},
          {label: labels.matching_bonus, value: bonus.matching_bonus},
          {label: labels.pool_trade_bonus, value: bonus.pool_trade_bonus},
          {label: labels.residual_bonus, value: bonus.residual_bonus},
          {label: labels.direct_commission_bonus, value: bonus.direct_commission_bonus},
          {label: labels.chargebacks, value: bonus.chargebacks}
        ]
      });

      browsersChart3.options.data.forEach(function(label, i){
        var legendItem = $('<div class="fix-right-a"></div>').text(label['label'] + " ( " +label['value'] + " )").prepend('<i>&nbsp;</i>');

          legendItem.find('i').css('backgroundColor', browsersChart3.options.colors[i]);
          $('#legend3').append(legendItem)
          $('#legend3').addClass('text-center')
        })

      let browsersChart4 = Morris.Donut({
        element: 'pie-chart4',
        colors: ["#3c8dbc", "#dd4b39", "#555299"],
        data: [
          {label: labels.unilevel_affiliates_actives_count, value: unilevel_counts.unilevel_affiliates_actives_count},
          {label: labels.unilevel_affiliates_inactives_count, value: unilevel_counts.unilevel_affiliates_inactives_count}
        ]
      });

      browsersChart4.options.data.forEach(function(label, i){
        var legendItem = $('<div class="fix-right-a"></div>').text(label['label'] + " ( " +label['value'] + " )").prepend('<i>&nbsp;</i>');

          legendItem.find('i').css('backgroundColor', browsersChart4.options.colors[i]);
          $('#legend4').append(legendItem)
          $('#legend4').addClass('text-center')
        })

    let browsersChart5 = Morris.Donut({
        element: 'pie-chart5',
        colors: ["#00a65a", "#f39c12"],
        data: [
          {label: labels.binary_affiliates_left_count, value: binary_count.binary_affiliates_left_count},
          {label: labels.binary_affiliates_right_count, value: binary_count.binary_affiliates_right_count}
        ]
      });

      browsersChart5.options.data.forEach(function(label, i){
        var legendItem = $('<div class="fix-right-a"></div>').text(label['label'] + " ( " +label['value'] + " )").prepend('<i>&nbsp;</i>');

        legendItem.find('i').css('backgroundColor', browsersChart5.options.colors[i]);
        $('#legend5').append(legendItem)
        $('#legend5').addClass('text-center')
      });


      return instances;
    }
    throw new Error('Request failed!');
  }
  catch(error) {
    console.log(error);
  }
}

$(document).ready(function(){
  getInstance();
});
