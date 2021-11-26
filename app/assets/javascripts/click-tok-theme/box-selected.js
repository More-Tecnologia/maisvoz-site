let items = document.querySelectorAll('.card-menu-admin');

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
