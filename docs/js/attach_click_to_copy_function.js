/*
	Copy text from any appropriate field to the clipboard!
  Sourced from : https://www.sitepoint.com/javascript-copy-to-clipboard/
  Generously made available by : Craig Buckler, @craigbuckler
  
  B.Haos is using it, abusing it, and doing whatever he likes with it!
  (Per Sir Buckler's request!)
*/
(function() {

	'use strict';
  
  // click events
  document.body.addEventListener('click', copy, true);

	// event handler
	function copy(e) {

    // find target element
    var 
      t = e.target,
      c = t.dataset.copytarget,
      inp = (c ? document.querySelector(c) : null);
      
    // is element selectable?
    if (inp && inp.select) {
      
      // select text
      inp.select();

      try {
        // copy text
        document.execCommand('copy');
        inp.blur();
        
        // copied animation
        t.classList.add('copied');
        setTimeout(function() { t.classList.remove('copied'); }, 1500);
      }
      catch (err) {
        alert('please press Ctrl/Cmd+C to copy');
      }
      
    }
    
	}

})();