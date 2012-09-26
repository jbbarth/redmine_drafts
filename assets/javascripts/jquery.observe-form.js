/* 
 * Add a jQuery method to observe a whole form each N seconds
 * 
 * adapted from: http://blessednotes.wordpress.com/2009/07/28/jquery-form-changes-observer/
 */
$.fn.observe = function( time, callback ){
  return this.each(function(){
    var form = this, changed = false;
    /* observe for changes */
    $(form.elements).change(function(){ changed = true })
    $(form).find('input,textarea').keyup(function(){ changed = true })
    /* call callback if needed */
    setInterval(function(){
      if ( changed ) callback.call( form );
      changed = false;
    }, time * 1000);
  });
};
