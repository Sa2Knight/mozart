$(function() {

  /*データ定義*/
  var json = $('#database').text();
  var manga = json != "" && JSON.parse(json);

  /*インフォメーションバーを定義*/
  var information = {
    show: function(mes) {
     $('#information').text(mes);
     $('#information-wrap').show();
    } ,
    hide: function() {
      $('#information-wrap').hide();
    }
  };

  /*イベント定義*/
  $('.thumbnail').hover(
    function() {  //in
      var id = $(this).attr('id');
      var origin = manga[id].origin;
      var name = manga[id].name;
      var mes = origin + ": " + name;
      information.show(mes);
    } ,
    function() {  //out
      information.hide();
    }
  );
})
