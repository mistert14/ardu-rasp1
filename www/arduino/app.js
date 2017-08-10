var param=' ';


maj=function(){
  $.ajax({
    url: "http://localhost:8080/",
    method: 'GET',
    data: param,
  }).done(function(data) {
   $("#resultat").html(data);
  });

};

$(function(){
   $("#cmd_P").click(function(){
      param='P';
      maj();
   });
   $("#cmd_p").click(function(){
      param='p';
      maj();
   });
   $("#cmd_D").click(function(){
      param='D';
      maj();
   });


});
