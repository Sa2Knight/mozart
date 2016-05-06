$(function() {

  /*データ定義*/
  var json = $('#database').text();
  var manga = json != "" && JSON.parse(json);

  /*検索にマッチしないサムネイルを非表示に*/
  (function() {
    var arg = {}
    var pair=location.search.substring(1).split('&');
    for(var i=0;pair[i];i++) {
      var kv = pair[i].split('=');
      arg[kv[0]]=kv[1];
    }
  })();

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
