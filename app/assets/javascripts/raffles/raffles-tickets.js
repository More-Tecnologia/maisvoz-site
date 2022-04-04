const numbersRaffle = document.querySelector(".raffles-cart-numbers");
const btnTop = document.querySelector(".scroll-top-numbers");
const btnBottom = document.querySelector(".scroll-bottom-numbers");
const btnFullTop = document.querySelector('.scroll-full-top');
const btnFullBottom = document.querySelector('.scroll-full-bottom');
const numbers = document.querySelectorAll('.number-raffle');
const numbersSelected = document.querySelector('.numbers-selected');
const listNumbers = [];
const inputNumbers = [];
const inputSelectedNumbers = document.querySelector('.hidden-input-tickets');

numbers.forEach(number => {
    number.addEventListener("click", function(){
        let thisValue = this.attributes.value.value;
        let valueElement = this.getAttribute('value');
        if(this.classList[1] == "number-selected"){
            this.classList.remove("number-selected")
            listNumbers.forEach((number, index) => {
                let newNumber = new DOMParser().parseFromString(number, "text/xml");
                if(newNumber.firstChild.attributes.value.value == thisValue){
                    listNumbers.splice(index, 1)
                    inputNumbers.splice(index, 1)
                    numbersSelected.innerHTML = listNumbers;
                    inputSelectedNumbers.innerHTML = inputNumbers;
                }
            })
        }
        else {
            this.classList.add('number-selected')
            listNumbers.push(`<div class="number-raffle" value="${thisValue}">${this.innerHTML}</div>`);
            numbersSelected.innerHTML = listNumbers;
            inputNumbers.push(`<option value="${valueElement}">${valueElement}</option>`)
            inputSelectedNumbers.innerHTML = inputNumbers;
        }
    })
})

btnFullTop.addEventListener("click", function() {
  numbersRaffle.scrollTop -= numbersRaffle.scrollHeight;
})

btnFullBottom.addEventListener("click", function() {
  numbersRaffle.scrollTop += numbersRaffle.scrollHeight;
})

btnTop.addEventListener("click", function () {
  numbersRaffle.scrollTop -= 100;
});

btnBottom.addEventListener("click", function () {
  numbersRaffle.scrollTop += 100;
});