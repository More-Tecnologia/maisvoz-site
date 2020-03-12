let groups = [
  {
    group: "earnings",
    head: "account_earnings_limit",
    data: ["receivable_amount", "received_amount"],
    colors: ["#001d6e", "#FFD878"],
    path: "earnings_data",
    amount_sign: "&#36;"
  },
  {
    group: "balances",
    head: "balance",
    data: [ "blocked_balance", "available_balance"],
    colors: ["#001d6e", "#FFD878"],
    path: "balances_data",
    amount_sign: "&#36;"
  },
  {
    group: "unilevel_counts",
    head: "unilevel_affiliates_count",
    data: ["unilevel_affiliates_inactives_count", "unilevel_affiliates_actives_count"],
    colors: ["#001d6e", "#FFD878"],
    path: "unilevel_counts_data",
    amount_sign: ""
  },
  {
    group: "binary_count",
    head: "binary_affiliates_count",
    data: ["binary_affiliates_left_count", "binary_affiliates_right_count"],
    colors: ["#001d6e", "#FFD878"],
    path: "binary_counts_data",
    amount_sign: ""
  },
  {
    group: "binary_scores",
    head: "binary_score",
    data: ["left_binary_score", "right_binary_score"],
    colors: ["#001d6e", "#FFD878"],
    path: "binary_scores_data",
    amount_sign: ""
  }
];

$(document).on("click", ".bt-bars", {}, function(e) {
  groups.forEach(function(object) {
    bar_cleaner(object);
    getBarInstance(object);
  });
});

function bar_cleaner(object) {
  $('#' + object['group']).empty();
  $('#' + object['head']).empty();
  let arr = Object.values(object['data']);

  arr.forEach(function(i) {
      $('#' + i).empty();
    });



  $('#legend_' + object['group']).empty();

  return false;
};

async function getBarInstance(object) {
  let arr = Object.values(object['data']);
  let url = '/backoffice/dashboard/' + object['path'] + '.json?locale=' + locale
  try {
    let response = await fetch(url);
    if (response.ok) {
      let instances = await response.json();
      let user_data = JSON.parse(JSON.stringify(instances.data))
      let labels = JSON.parse(JSON.stringify(instances.labels))
      console.log(user_data)

      $('#' + object['head']).append(object['amount_sign'] + user_data[object['group']][object['head']]);

      arr.forEach(function(key, i) {
        let width = ((user_data[object['group']][key] * 100) / user_data[object['group']][object['head']]).toFixed(2);
        let right_css = '';
        if([arr].length - 1 === i) {
          right_css = 'display: block; float: right; '
        };
        let background_color = 'background-color: ' + object['colors'][i] + ' ;';
        let progressbar = $('<div class="progress-bar" role="progressbar" style="width: ' + width + '%; ' + right_css + background_color + '"></div>');

        $('#' + object['group']).append(progressbar);
      })

      arr.forEach(function(label, i){
        let legendItem = $('<span class="">' + labels[label] + " ( " + object['amount_sign'] + user_data[object['group']][label] + " )" + '&nbsp;&nbsp;</span>').prepend('<i>&nbsp;</i>');
        console.log(object['colors'])
        console.log(object['colors'].reverse())
        console.log(i)
        let a = [...object['colors'].reverse()];
        console.log(a[i])
        legendItem.find('i').css('backgroundColor', a[i]);
        $('#legend_' + object['group']).prepend(legendItem).addClass('text-center');
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
  $('.bt-bars').each(function() {
    $(this).trigger('click');
  })
});
