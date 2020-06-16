
var ft = new FeatureViewer('MALWMRLLPLLALLALWGPGPGAGSLQPLALEGSLQKRGIVEQCCTSICSLYQLE',
                           '#fv1',
                            {
                                showAxis: true,
                                showSequence: true,
                                brushActive: true, //zoom
                                toolbar:true, //current zoom & mouse position
                                bubbleHelp:true, 
                                zoomMax:50 //define the maximum range of the zoom
                            });
                            
//Instead of a sequence, you can also initialize the feature viewer with a length (integer) :
//var ft = new FeatureViewer(213,'#fv1');