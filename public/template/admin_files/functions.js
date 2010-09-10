// This file contain some small javascript functions
// require for Open Cafe to work.

// Following function is used in sidebar nav menu
$(document).ready(function() {
  $('div.sidenav:eq(0)> div.subnav').hide();
  $('div.sidenav:eq(0)> div.navhead').click(function() {
	$(this).next().slideToggle('fast');
  });
});