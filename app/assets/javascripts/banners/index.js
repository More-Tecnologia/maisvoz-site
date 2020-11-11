var cont = 1;
var total = document.querySelectorAll(".number-solitary").length;
var process = 0;
var processAnt = 0;

setInterval(function(){
  if(cont < total){
    process = document.querySelectorAll(".number-solitary")[cont];
    processAnt = document.querySelectorAll(".number-solitary")[cont -1];
    processAnt.classList.remove("active");
    process.classList.add("active");
  }else{
    clearInterval();
  }

  if(cont == total){
      console.log("final");
      $('#myModal').modal('show');
  }

  cont++;
}, 5000)
