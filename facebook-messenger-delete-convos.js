setInterval(() => {
	var a = document.querySelector("[aria-label='Conversation List']").children[0].children[1].children[0];
	a.children[a.children.length-1].children[0].click();
	var x = [...document.querySelectorAll("li>a>span>span")];
	for(var i = 0; i < x.length; ++i) {
		if(x[i].innerText.trim() === "Delete") {
			x[i].click();
			document.querySelectorAll("[role=dialog] button")[1].click();
			break;
		}
	}
}, 1500);
