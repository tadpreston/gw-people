$(() => {
  $('.main.menu  .ui.dropdown').dropdown({
    on: 'hover'
  });

  $(".item.signout").click((e)=> {
    e.preventDefault();
    let URL = $(e.target).data('target');
    $.ajax({
      url: URL,
      type: 'DELETE',
      xhrFields: {
        withCredentials: true
      }
    }).done(function() {
      console.log("You've been logged out");
      window.location.href = '/';
    }).fail(function() {
      console.log("error logging out");
    });
  });
});
