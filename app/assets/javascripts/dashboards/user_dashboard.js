const locale = $("#locale").attr('value');

$(document).on('click', '.bt-toggle', {}, function(e) {
  let group = $(this).attr('group');
  let head = $(this).attr('head');
  let subheads = $(this).attr('subheads') || null;
  let data = $(this).attr('object');
  let colors = $(this).attr('colors');
  let path = $(this).attr('path');
  let admin = $(this).attr('admin') || null
  let amount_sign = $(this).attr('amount_sign') || ''
  if(subheads) { subheads = subheads.split(', ') }

  chart_cleaner(group, head, subheads);

  getInstance(group, head, subheads, data, colors, path, admin, amount_sign);
});

function chart_cleaner(group, head, subheads) {
  $('#' + group).empty();
  $('#' + head).empty();
  if(subheads) {
    subheads.forEach(function(i) {
      $('#' + i).empty();
    });
  }
  $('#legend_' + group).empty();

  return false;
};

async function getInstance(group, head, subheads, data, colors, path, admin = false, amount_sign = '') {
  let admin_path = admin ? 'admin/' : ''
  let url = '/backoffice/' + admin_path + 'dashboard/' + path + '.json?locale=' + locale
  try {
    let response = await fetch(url);
    if (response.ok) {
      let instances = await response.json();
      let user_data = JSON.parse(JSON.stringify(instances.data))
      let labels = JSON.parse(JSON.stringify(instances.labels))

      $('#' + head).append(amount_sign + user_data[group][head]).addClass('btn-primary');
      if(subheads) {
        subheads.forEach(function(key) {
          $('#' + key).append(amount_sign + user_data[group][key]).addClass('btn-primary');
        })
      }

      let chart = Morris.Donut({
        element: group,
        colors: colors.split(', '),
        data: data.split(', ').map(key => ({ label: labels[key], value: user_data[group][key]}))
      });

      chart.options.data.forEach(function(label, i){
        let legendItem = $('<div class="fix-right-a"></div>').text(label['label'] + " ( " + amount_sign + label['value'] + " )").prepend('<i>&nbsp;</i>');

        legendItem.find('i').css('backgroundColor', chart.options.colors[i]);
        $('#legend_' + group).append(legendItem).addClass('text-center')
      })

      return instances;
    }
    throw new Error('Request failed!');
  }
  catch(error) {
    console.log(error);
  }
}

$(document).ready(function(){
  $('.bt-toggle').each(function() {
    $(this).trigger('click');
  })
});
