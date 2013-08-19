////////////////////////////////////////////////////////////////////////////
////////////ANALYSIS OF PLANE TRUSSES WITH STIFFENESS MATRIX////////////////
////////////FARZAD KARKHANI/////////////////////////////////////////////////
////////////PROGRAMMED IN ACTION SCRIPT 3.0 ////////////////////////////////
////////////DESIGN BY ADOBE FLASH CS4///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////GENERALS////////////////////////////////////////////////////////
import fl.controls.DataGrid;
import fl.data.DataProvider;
bgLayer.visible = false;
var trussShape:MovieClip=new MovieClip();
bgLayer.addChild (trussShape);
var color:uint = 0x444444;
var Angel:Number=0
//////////////////////////////////////
///////////////JOINTS/////////////////
//////////////////////////////////////
nodeSubmit.addEventListener (MouseEvent.CLICK, submitNode);
nodeRemove.addEventListener (MouseEvent.CLICK, removeNode);
nodeRemoveAll.addEventListener (MouseEvent.CLICK, removeAllNode);
var nodes:Array = new Array();
var nodeData:DataGrid;
nodeData.columns = ["Number","X","Y","Xload","Yload","Xsup","Ysup"];
nodeData.columns[0].width = 50;
nodeData.columns[1].width = 40;
nodeData.columns[2].width = 40;
nodeData.columns[3].width = 40;
nodeData.columns[4].width = 40;
nodeData.columns[5].width = 40;
nodeData.columns[6].width = 40;
var NumberOfSup:int = 0;
var NumberOfLoad:int = 0;
function removeAllNode (event:MouseEvent):void {
	for (var n:int=nodes.length+1; n>0; n--) {
		nodes.pop ();
	}
	var dp:DataProvider = new DataProvider(nodes);
	nodeData.dataProvider = dp;
	nodeData.height = (nodeData.length * 20)+25;
	nodeNumber.text = String(0);
}
function removeNode (event:MouseEvent):void {
	if (nodes.length > 0) {
		nodes.pop ();
		var dp:DataProvider = new DataProvider(nodes);
		nodeData.dataProvider = dp;
		nodeData.height = (nodeData.length * 20)+25;
		nodeNumber.text = String(Number(nodeNumber.text) - 1);
	}
}
function submitNode (event:MouseEvent):void {
	var nodeNo:Number = new Number(nodeNumber.text);
	var Xpos:Number = new Number(nodeXpos.text);
	var dYpos:Number = new Number(nodeYpos.text);
	var Xload:Number = new Number(nodeXload.text);
	var Yload:Number = new Number(nodeYload.text);
	var nodeXs:int = 0;
	var nodeYs:int = 0;
	if (nodeXsup.selected == true) {
		nodeXs = 1;
	} else {
		nodeXs = 0;
	}
	if (nodeYsup.selected == true) {
		nodeYs = 1;
	} else {
		nodeYs = 0;
	}
	nodes.push ({Number:nodeNo,X:Xpos*100,Y:dYpos*100,Xload:Xload,Yload:Yload,Xsup:nodeXs,Ysup:nodeYs});
	var dp:DataProvider = new DataProvider(nodes);
	nodeData.dataProvider = dp;
	if (nodeData.length <= 10) {
		nodeData.height = (nodeData.length * 20)+25;
	}
	nodeNumber.text = String(nodeNo + 1);
}
//////////////////////////////////////
///////////////ELEMENTS///////////////
//////////////////////////////////////
elemDraw.addEventListener (MouseEvent.CLICK, drawElements);
elemSubmit.addEventListener (MouseEvent.CLICK, submitElem);
elemRemove.addEventListener (MouseEvent.CLICK, removeElem);
elemRemoveAll.addEventListener (MouseEvent.CLICK, removeAllElem);
var elements:Array = new Array();
var elemData:DataGrid;
elemData.columns = ["Number","Start","End","Area","Elasticity","Lengh","Sin","Cos"];
elemData.columns[0].width = 50;
elemData.columns[1].width = 40;
elemData.columns[2].width = 40;
elemData.columns[3].width = 40;
elemData.columns[4].width = 60;
elemData.columns[5].width = 50;
elemData.columns[6].width = 40;
elemData.columns[7].width = 40;
function removeAllElem (event:MouseEvent):void {
	for (var m:int=elements.length+1; m>0; m--) {
		elements.pop ();
	}
	var dp1:DataProvider = new DataProvider(elements);
	elemData.dataProvider = dp1;
	elemData.height = (elemData.length * 20)+25;
	elemNumber.text = String(0);
}
function removeElem (event:MouseEvent):void {
	if (elements.length > 0) {
		elements.pop ();
		var dp1:DataProvider = new DataProvider(elements);
		elemData.dataProvider = dp1;
		elemData.height = (elemData.length * 20)+25;
		elemNumber.text = String(Number(elemNumber.text) - 1);
	}
}
function submitElem (event:MouseEvent):void {
	var elemNo:Number = new Number(elemNumber.text);
	var Snode:int = new int(elemS.text);
	var Enode:int = new int(elemE.text);
	var Area:Number = new Number(elemArea.text);
	var Elast:Number = new Number(elemElast.text);
	var Len:Number= Math.sqrt(((nodes[Enode].Y-nodes[Snode].Y)*(nodes[Enode].Y-nodes[Snode].Y))+((nodes[Enode].X-nodes[Snode].X)*(nodes[Enode].X-nodes[Snode].X)));
	var Sin:Number=(nodes[Enode].Y-nodes[Snode].Y)/Len;
	var Cos:Number=(nodes[Enode].X-nodes[Snode].X)/Len;
	elements.push ({Number:elemNo,Start:Snode,End:Enode,Area:Area,Elasticity:Elast,Lengh:Len,Sin:Sin,Cos:Cos});
	var dp1:DataProvider = new DataProvider(elements);
	elemData.dataProvider = dp1;
	if (elemData.length <= 10) {
		elemData.height = (elemData.length * 20)+25;
	}
	elemNumber.text = String(elemNo + 1);
}
//////////////////////////////////////////////////
//////////////////DRAWING/////////////////////////
//////////////////////////////////////////////////
function drawNodes () {
	for (var i:int=0; i<nodes.length; i++) {
		var p1:int = nodes[i].Number;
		var p2:Number = nodes[i].X;
		var p3:Number = nodes[i].Y;
		var p4:Number = nodes[i].Xload;
		var p5:Number = nodes[i].Yload;
		var p6:Number = nodes[i].Xsup;
		var p7:Number = nodes[i].Ysup;
		if (p6 == 1 || p7 == 1) {
			NumberOfSup += 1;
		}
		if (p4!=0||p5!=0) {
			NumberOfLoad+=1;
		}
		doJoint (p1,p2,p3,p4,p5,p6,p7);
	}
}
function drawElements (event:MouseEvent):void {
	analysis ();
	bgLayer.visible=true;
	for (var k:int=0; k<elements.length; k++) {
		var e1:int=elements[k].Number;
		var e2:Number=elements[k].Start;
		var e3:Number=elements[k].End;
		var e4:Number=elements[k].Area;
		var e5:Number=elements[k].Sin;
		var e6:Number=elements[k].Cos;
		doElement (e1,e2,e3,e4,e5,e6);
	}
	drawNodes ();
}
function doJoint (jNo:int,h:Number,v:Number,xL:Number,yL:Number,xS:Number,yS:Number):void {
	var joint:jointG = new jointG();
	joint.name="joint"+String(jNo);
	joint.animStatus.status.jointNo.text=String(jNo);
	joint.animStatus.status.jointXpos.text=String(h)+" ["+String(D[2*jNo])+"]";
	joint.animStatus.status.jointYpos.text=String(v)+" ["+String(D[2*jNo+1])+"]";
	joint.animStatus.status.jointXload.text=String(xL);
	joint.animStatus.status.jointYload.text=String(yL);
	joint.animStatus.status.jointXsup_r.text=String(RX[jNo]);
	joint.animStatus.status.jointYsup_r.text=String(RY[jNo]);
	joint.animStatus.status.jointXsup.text=String(xS);
	joint.animStatus.status.jointYsup.text=String(yS);
	var ypos:Number=v*(-1)+stage.stageHeight-100;
	var xpos:Number=h+100;
	joint.x=xpos;
	joint.y=ypos;
	trussShape.addChild (joint);
}
function doElement (eNo:int,F:int,E:int,Ar:Number,eSin:Number,eCos:Number) {
	var sxPoint:Number = (nodes[F].X)+100;
	var syPoint:Number = (nodes[F].Y)*(-1)+stage.stageHeight-100;
	var exPoint:Number = (nodes[E].X)+100;
	var eyPoint:Number = (nodes[E].Y)*(-1)+stage.stageHeight-100;
	var element:MovieClip=new MovieClip();
	element.name="element"+String(eNo);
	var force:forceLabel = new forceLabel();
	force.x=sxPoint+((exPoint-sxPoint)/2)+10;
	force.y=syPoint+((eyPoint-syPoint)/2)+10
	Angel=(Math.atan(eSin/eCos)*180/Math.PI);
	force.rotation=(-1)*Angel
	force.inv.force_txt.text=String(S[eNo]);
	force.name="force"+String(eNo);
	if (S[eNo]>0) {
		color=0x009900;
	} else if (S[eNo]<0) {
		color=0x990000;
	} else {
		color=0x444444;
	}
	element.graphics.lineStyle (4,color,1,false,LineScaleMode.NONE,CapsStyle.SQUARE);
	element.graphics.moveTo (sxPoint, syPoint);
	element.graphics.lineTo (exPoint, eyPoint);
	trussShape.addChild (element);
	trussShape.addChild (force);
}
