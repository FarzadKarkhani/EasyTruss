////////////////////////////////////////////////////////////////////////////
////////////ANALYSIS OF PLANE TRUSSES WITH STIFFENESS MATRIX////////////////
////////////FARZAD KARKHANI/////////////////////////////////////////////////
////////////PROGRAMMED IN ACTION SCRIPT 3.0 ////////////////////////////////
////////////DESIGN BY ADOBE FLASH CS4///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////MAIN ANALYSIS CODES/////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////DEFENTION OF VARIABLES AND ARRAYS///////////////////////////////
var dataSize:Array = new Array();
var X:Array = new Array();
var Y:Array = new Array();
var JM:Array = new Array();
var AX:Array = new Array();
var E:Array = new Array();
var JRX:Array = new Array();
var JRY:Array = new Array();
var W:Array = new Array();
var RX:Array = new Array();
var RY:Array = new Array();
var CX:Array = new Array();
var CY:Array = new Array();
var TL:Array = new Array();
var XK:Array = new Array();
var D:Array = new Array();
var S:Array = new Array();
var NEQ:int = 0;
var J1:int = 0;
var J2:int = 0;
var AEOL:Number = 0;
var XX:Number = 0;
var YY:Number = 0;
var XY:Number = 0;
var J12M1:int = 0;
var J12:int = 0;
var J22M1:int = 0;
var J22:int = 0;
var I2M1:int = 0;
var I2:int = 0;
var PIVOT:Number = 0;
var PIVR:Number = 0;
function analysis () {
	////////////READ STRUCTURE SIZE DATA
	dataSize.push ({NJ:nodes.length,NM:elements.length,NSUP:NumberOfSup,NLJ:NumberOfLoad});
	NEQ=(dataSize[0].NJ*2);
	trace (" NJ: "+dataSize[0].NJ+" NM: "+dataSize[0].NM+" NSUP: "+dataSize[0].NSUP+" NLJ: "+dataSize[0].NLJ);
	////////////READ STRUCTURE JOINTS & ELEMENTS DATA
	for (var i:int=0; i<dataSize[0].NJ; i++) {
		X[i]=(nodes[i].X);
		Y[i]=(nodes[i].Y);
		trace (" X:"+X[i]+" Y:"+Y[i]);
	}
	for (var i:int=0; i<dataSize[0].NM; i++) {
		JM[i]= new Array();
		JM[i][1]= (elements[i].Start);
		JM[i][2]= (elements[i].End);
		E[i]=(elements[i].Elasticity);
		AX[i]=(elements[i].Area);
		trace (" JM(1):"+JM[i][1]+" JM(2):"+JM[i][2]+" AX:"+AX[i]);
	}
	for (var i:int=0; i<dataSize[0].NJ; i++) {
		JRX[i]=(nodes[i].Xsup);
		JRY[i]=(nodes[i].Ysup);
		trace (" JRX:"+JRX[i]+" JRY:"+JRY[i]);
	}
	for (var i:int=0; i<NEQ; i++) {
		W[i] = 0;
	}
	for (var i:int=0; i<dataSize[0].NJ; i++) {
		if ((nodes[i].Xload)!= 0) {
			W[(2*i)]=(nodes[i].Xload);
		}
		if ((nodes[i].Yload)!= 0) {
			W[(2*i+1)]=(nodes[i].Yload);
		}
		trace (" W("+(2*i)+"):"+W[(2*i)]+" W("+(2*i+1)+"):"+W[(2*i+1)]);
	}
	////////////JOINT RESTRAINTS
	for (var i:int=0; i<dataSize[0].NJ; i++) {
		if (JRX[i]!=0 && W[(i*2)]!=0) {
			RX[i]=-1*(W[(i*2)]);
		} else {
			RX[i] = 0;
		}
		if (JRY[i]!=0 && W[(i*2+1)]!=0) {
			RY[i]=-1*(W[(i*2+1)]);
		} else {
			RY[i] = 0;
		}
	}
	////////////ELEMENTS CONDITIONS & PROPERTISE
	for (var i:int=0; i<dataSize[0].NM; i++) {
		TL[i]=(elements[i].Lengh);
		CX[i]=(elements[i].Cos);
		CY[i]=(elements[i].Sin);
		trace (" TL:"+TL[i]+" CX:"+CX[i]+" CY:"+CY[i]);
	}
	////////////GENERATE STIFFNESS MATRIX
	for (var i:int=0; i<NEQ; i++) {
		XK[i]= new Array();
		for (var j:int=0; j<NEQ; j++) {
			XK[i][j] = 0;
		}
	}
	for (var i:int=0; i<dataSize[0].NM; i++) {
		J1 = JM[i][1];
		J2 = JM[i][2];
		AEOL = AX[i] * E[i] / TL[i];
		XX = AEOL * CX[i] * CX[i];
		YY = AEOL * CY[i] * CY[i];
		XY = AEOL * CX[i] * CY[i];
		J12M1 = 2 * J1;
		J12 = 2 * J1 + 1;
		J22M1 = 2 * J2;
		J22 = 2 * J2 + 1;
		XK[J12M1][J12M1] = XK[J12M1][J12M1] + XX;
		XK[J12M1][J12] = XK[J12M1][J12] + XY;
		XK[J12M1][J22M1] = XK[J12M1][J22M1] - XX;
		XK[J12M1][J22] = XK[J12M1][J22] - XY;
		XK[J12][J12M1] = XK[J12][J12M1] + XY;
		XK[J12][J12] = XK[J12][J12] + YY;
		XK[J12][J22M1] = XK[J12][J22M1] - XY;
		XK[J12][J22] = XK[J12][J22] - YY;
		XK[J22M1][J12M1] = XK[J22M1][J12M1] - XX;
		XK[J22M1][J12] = XK[J22M1][J12] - XY;
		XK[J22M1][J22M1] = XK[J22M1][J22M1] + XX;
		XK[J22M1][J22] = XK[J22M1][J22] + XY;
		XK[J22][J12M1] = XK[J22][J12M1] - XY;
		XK[J22][J12] = XK[J22][J12] - YY;
		XK[J22][J22M1] = XK[J22][J22M1] + XY;
		XK[J22][J22] = XK[J22][J22] + YY;
	}
	////////////SUPPORT RESTRAINTS
	for (var i:int=0; i<dataSize[0].NJ; i++) {
		if (JRX[i] != 0) {
			I2M1 = 2 * i;
			for (var j:int=0; j<NEQ; j++) {
				XK[I2M1][j] = 0;
				XK[j][I2M1] = 0;
			}
			XK[I2M1][I2M1] = 1;
			W[I2M1] = 0;
		}
		if (JRY[i] != 0) {
			I2 = 2 * i + 1;
			for (var j:int=0; j<NEQ; j++) {
				XK[I2][j] = 0;
				XK[j][I2] = 0;
			}
			XK[I2][I2] = 1;
			W[I2] = 0;
		}
	}
	////////////INVERT STIFFNESS MATRIX & MAKE FLEXIBILITY MATRIX
	for (var i:int=0; i<NEQ; i++) {
		PIVOT = XK[i][i];
		if (Math.abs(PIVOT) == 0) {
			trace ("MATRIX IS SINGULAR");
		} else {
			PIVR=(1/PIVOT);
			for (var NCOL:int=0; NCOL<NEQ; NCOL++) {
				XK[i][NCOL]=(XK[i][NCOL])/PIVOT;
			}
			for (var k:int=0; k<NEQ; k++) {
				if (k != i) {
					PIVOT = XK[k][i];
					for (var NCOL:int=0; NCOL<NEQ; NCOL++) {
						XK[k][NCOL]=(XK[k][NCOL])-(XK[i][NCOL])*PIVOT;
					}
					XK[k][i]=-1*(PIVOT*PIVR);
				}
			}
			XK[i][i] = PIVR;
		}
	}
	////////////JOINT DISPLACEMENTS
	for (var i:int=0; i<NEQ; i++) {
		D[i] = 0;
		for (var j:int=0; j<NEQ; j++) {
			D[i] = D[i] + XK[i][j] * W[j];
		}
	}
	for (var i:int=0; i<dataSize[0].NJ; i++) {
		trace (" Joint:"+i+" X-DISP:"+D[2*i]+" Y-DISP:"+D[2*i+1]);
	}
	////////////MEMBER FORCES
	for (var i:int=0; i<dataSize[0].NM; i++) {
		AEOL = AX[i] * E[i] / TL[i];
		J1 = JM[i][1];
		J2 = JM[i][2];
		S[i]=AEOL*((CX[i]*(D[2*J2]-D[2*J1]))+(CY[i]*(D[2*J2+1]-D[2*J1+1])));
		trace ("Member:"+i+" Force:"+S[i]);
	}
	////////////REACTIONS
	for (var i:int=0; i<dataSize[0].NM; i++) {
		J1 = JM[i][1];
		J2 = JM[i][2];
		if (JRX[J1] != 0) {
			RX[J1] = RX[J1] - CX[i] * S[i];
		}
		if (JRY[J1] != 0) {
			RY[J1] = RY[J1] - CY[i] * S[i];
		}
		if (JRX[J2] != 0) {
			RX[J2] = RX[J2] + CX[i] * S[i];
		}
		if (JRY[J2] != 0) {
			RY[J2] = RY[J2] + CY[i] * S[i];
		}
	}
	for (var i:int=0; i<dataSize[0].NJ; i++) {
		if (JRX[i] != 0 || JRY[i] != 0) {
			trace ("Joint:"+i+" RX:"+RX[i]+" RY:"+RY[i]);
		}
	}
	////////////ANALYSIS COMPLETED
}
