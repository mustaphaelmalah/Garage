/*
 * Automatically attempts to recharge firewalls every 1 seconds by using jQuery
 * to simulate click events.
 *
 * Author: Mustapha Elmalah
 *
 * Fix (for devs): suggest randomizing/obfuscating element ids at small interval
 * or better yet using a canvas element.
 *
 */
var recharge_timeout = null;
function recharge() {
	if(recharge_timeout) clearTimeout(recharge_timeout);
	recharge_timeout = setTimeout(function() {
		// rechange firewall A
		$("#window-firewall-part1-amount").click(); // open fw page
		$("#shop-firewall-charge5 .window-shop-element-info").eq(0).click();
		$("#window-firewall-pagebutton").click(); // go back

		// rechange firewall B
		$("#window-firewall-part2-amount").click(); // open fw page
		$("#shop-firewall-charge5 .window-shop-element-info").eq(0).click();
		$("#window-firewall-pagebutton").click(); // go back

		// rechange firewall C
		$("#window-firewall-part3-amount").click(); // open fw page
		$("#shop-firewall-charge5 .window-shop-element-info").eq(0).click();
		$("#window-firewall-pagebutton").click(); // go back

		// run next cycle
		recharge();
	}, 1000);
}

recharge();
