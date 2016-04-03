view = (function() {
  var url;
  var page;
  var edit = false;
  return {
    init : function (_url , _page) {
      url = _url;
      page = _page;
    } ,
    next : function () {
      location.href = url + "?page=" + (page + 2);
    } ,
    prev : function () {
      if (page > 0) {
        location.href = url + "?page=" + (page - 2);
      }
    } ,
    top : function () {
      location.href = url;
    } ,
    last : function() {
      location.href = url + "?page=" + (-1);
    } ,
  };
})();
