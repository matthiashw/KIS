/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


function togglethis(id) {
	var ele = document.getElementById(id);

	if(ele.style.display == "block") {
    		ele.style.display = "none";
  	}
	else {
		ele.style.display = "block";
	}
}