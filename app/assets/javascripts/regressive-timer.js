function regressiveTimer(){
  var date = new Date();
  var regressive_hours = (23 - date.getUTCHours()).toString().padStart(2, '0');
  var regressive_minutes = (59 - date.getUTCMinutes()).toString().padStart(2, '0');
  var regressive_seconds = (59 - date.getUTCSeconds()).toString().padStart(2, '0');
	time = [regressive_hours, regressive_minutes, regressive_seconds].join(':');
	$(".regressive-timer").html(time);
}

regressiveTimer();
setInterval(function(){
  regressiveTimer();
}, 1000);
