Shiny.addCustomMessageHandler("seq", js_string);
var ft2 = null ;
var seq =null;
function js_string (se){
 seq =se;
 console.log(seq);
 

ft2 = new FeatureViewer(seq,"#fv1", {
    showAxis: true,
    showSequence: true,
    brushActive: true,
    toolbar:true,
    bubbleHelp:true,
    zoomMax:10
            });
    
Shiny.addCustomMessageHandler("DT", to_json_patterns);
function to_json_patterns (patts) {
 
console.log (patts);
var mydata= patts;  


var my_json_hight =[];
var my_json_low =[];
for (var i = 0; i < mydata.length; i++){
  var obj = mydata[i];
  //console.log(obj.score===undefined)
  if (obj.score === undefined || obj.score[0]==="NaN"){
    var start =obj.start;
    var end = obj.stop;
    var description_=obj.signature_ac;
    var id_ =obj.sequence_ac;
    my_json_hight.push({
        x: start,
        y: end,
        description: description_,
        id:id_
    });
    
  }
  else {
    var start =obj.start;
    var end = obj.stop;
    var description_=obj.signature_ac;
    var id_ =obj.sequence_ac;
    var score_=obj.score;
    my_json_low.push({
      x: start,
      y: end,
      description: description_,
      id:id_,
      //score :score_
  });
  }
}
//Add some features
ft2.addFeature({
  data: my_json_hight,
  name: "high",
  className: "high",
  color: "#7CFC00",
  type: "rect",
  filter: "type1"
  
});

 
 
  if (my_json_low === undefined || my_json_low === 0 ) {
    // // array empty or does not exist
  }
else{
  ft2.addFeature({
    data: my_json_low ,
    name: "low",
    className: "test5",
    color: "#5C832F",
    height: 8,
    type: "rect"
  });


}

  
}
ft2.onFeatureSelected(function (d) {
  var d_=d.detail;
  console.log(d_);
  
  Shiny.onInputChange("docs", d_);
});




}




  



Shiny.addCustomMessageHandler("blast", addFeature_blast);
function addFeature_blast(results) {
 
  
  var my_json_blast =[];
  for (var i = 0; i < results.length; i++){   //results.length
    var obj = results[i];
    console.log(obj);
    var start = obj.start_pos   ;
    var end = obj.stop_pos;
    var bitscore_=obj.bitscore;
    var eval_=obj.eval__;
    var id_ =obj.hit_accs;
    var description_ =String(obj.hit_defs);
    my_json_blast=[{
        x: start,
        y: end,
        description: description_.concat("\n","id=\n",id_ ,"\n","e-val=\n",eval_,"\n","bitscore\n",bitscore_),
        id:id_
    }];
    
    ft2.addFeature({
  
  data: my_json_blast,
  name: id_,
  className: "Blast Hits",
  color: "#8B0000",
  type: "rect",
  filter: "type1"
  
});
    
  }
  

  


}

Shiny.addCustomMessageHandler("no_blast", alertnoblast);
function alertnoblast(message) {
  alert(message);
  
}





var ft3 =null ;
Shiny.addCustomMessageHandler("uniprot_id", uniprotdocs);
  function uniprotdocs (uniprot_id) {
  console.log(uniprot_id);

Shiny.addCustomMessageHandler("seq_blast", viewblast);
  function viewblast (seq_blast){
  seq =seq_blast;
  console.log(seq);
 
 
  Shiny.addCustomMessageHandler("db", verif_db);
  function verif_db (db){
  var db_=db;
  console.log(db);
  console.log(db_);
 
 
 ft3 = new FeatureViewer(seq,"#fv2", {
    showAxis: true,
    showSequence: true,
    brushActive: true,
    toolbar:true,
    bubbleHelp:true,
    zoomMax:10
            });
            
  console.log ("done");
  
  

  
  ft3.addFeature({
  data: [{x:1 ,y:seq.length, id:uniprot_id , description:"See Documentation"}],
  name: uniprot_id,
  className: "test7",
  color: "#8B0000",
  height: 8,
  type: "rect"
    
  });
  
  
  
Shiny.addCustomMessageHandler("DT_blast", to_json_patterns);
function to_json_patterns (patts_blast) {
 
console.log (patts_blast);
var mydata= patts_blast;  


var my_json_hight =[];
var my_json_low =[];
for (var i = 0; i < mydata.length; i++){
  var obj = mydata[i];
  //console.log(obj.score===undefined)
  if (obj.score === undefined || obj.score[0]==="NaN"){
    var start =obj.start;
    var end = obj.stop;
    var description_=obj.signature_ac;
    var id_ =obj.sequence_ac;
    my_json_hight.push({
        x: start,
        y: end,
        description: description_,
        id:id_
    });
    
  }
  else {
    var start =obj.start;
    var end = obj.stop;
    var description_=obj.signature_ac;
    var id_ =obj.sequence_ac;
    var score_=obj.score;
    my_json_low.push({
      x: start,
      y: end,
      description: description_,
      id:id_,
      //score :score_
  });
  }
}
//Add some features
ft3.addFeature({
  data: my_json_hight,
  name: "high",
  className: "high",
  color: "#7CFC00",
  type: "rect",
  filter: "type1"
  
});

 
 
  if (my_json_low === undefined || my_json_low === 0 ) {
    // // array empty or does not exist
  }
else{
  ft3.addFeature({
    data: my_json_low ,
    name: "low",
    className: "test5",
    color: "#5C832F",
    height: 8,
    type: "rect"
  });
  
}

}
  window.scrollBy(0,500);
if (db==="swissprot") //-----------------------------------------------------swissprot -------------------------------------------------------------------------------
 {


var url ="https://www.uniprot.org/uniprot/";
  
  
  ft3.onFeatureSelected(function (d) {
  var d_=d.detail;
  console.log(d_);
  if (d_.description==="See Documentation"){
  window.open(url+uniprot_id, "_blank"); 
    
  }
  
  else{
  Shiny.onInputChange("docs2", d_);
  
  }
});
  
  
  
  
 /* var a = document.createElement('a');
  var url ="https://www.uniprot.org/uniprot/";
  var link = document.createTextNode("This is link.");
  // Append the text node to anchor element. 
  a.appendChild(link);  
  // Set the title. 
  a.title = "This is Link";            
  a.href = url+uniprot_id;    
  var title ="<h3> hit with ID "+uniprot_id+"</h3>";
  document.getElementById("fv2").insertAdjacentHTML("afterbegin", title);
  document.getElementById("fv2").insertAdjacentHTML("afterend", a);
  //element.appendChild(a);*/
                 
                  
                  
                  
         
                  
  
 }//if ------------------------------------swissprot------------------------------------------------------------------------------------//
 else{
   console.log("still under constuction");
 }
 }
 //add FeatureViewer
}}
  



