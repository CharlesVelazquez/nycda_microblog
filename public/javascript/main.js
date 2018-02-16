var numbers = ['0','1','2','3','4','5','6','7','8','9']
var flash_alert_box = document.getElementsByClassName('close')


flash_alert_box.addEventListener("click", function () {
	flash_alert_box.style.display = "none"; 
})





function passwordCheck(form){
	var check = form.password.value.split("")
	for (var i = numbers.length - 1; i >= 0; i--) {
		for (var j = check.length - 1; j >= 0; j--) {
			if (check[j] == numbers[i]){
				return true
			}
		}
	}
	alert('You done goofed, you need atleast 1 number in your password')
	return false;
}