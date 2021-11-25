let item1 = document.querySelector(".item1");
let item2 = document.querySelector(".item2");
let item3 = document.querySelector(".item3");
let item4 = document.querySelector(".item4");
let item5 = document.querySelector(".item5");
let item6 = document.querySelector(".item6");
let item7 = document.querySelector(".item7");
let item8 = document.querySelector(".item8");
let item9 = document.querySelector(".item9");
let item10 = document.querySelector(".item10");
let item11 = document.querySelector(".item11");
let item12 = document.querySelector(".item12");

let items = [item1, item2, item3, item4, item5, item6, item7, item8, item9, item10, item11, item12];

function boxSelected(){
    items.forEach((item) => {
        if(item.pathname == window.location.pathname){
            item.style.background = "#31db02";
            item.style.color = "black";
        }
        else{
            item.classList.remove('box-selected');
        }
    })
}

boxSelected();
