/* Note I should propebly make use of pegged :D */

// Input will come in following form : 
// 2a+4b=-12
// a+b  = 6
// will make use of pegged right now
import pegged.grammar;

import GaussParser;
import std.stdio,std.numeric,std.algorithm,std.exception;
import std.container;

enum GGstring = `
    GaussGrammar:

    Formula  <  (:'+'? LeftSideElement)+ '=' RightSideElement
   
    LeftSideElement <- Number Letter /
                       ~('-'? Letter) 
                       
    RightSideElement <- Number
   
    Number <~ '-'? ~Digit+ 
    Digit   <- [0-9]
    Letter <- [a-z]
`;
//mixin(grammar(GGstring));

 struct Pair {
      int val;
      char chr;
  }


void main() {
  Pair[][] System;
  foreach (line;stdin.byLine) {
	  if (line=="") break;
      ParseTree Input =GaussGrammar(cast(string)line);
      Pair[] row=parseRow(Input);
      if(!duplicatesInRow(row))
          writeln("How can you do that !?!");
      System ~= row;
  }
 auto allVars=getAllVariables(System);
 createPaddedMatrix(System,allVars);
 
 foreach(Row;System) writeln(Row); 
}

char[] getAllVariables (Pair[][] parsedSysten) {
	char[] vars;
	foreach (Row;parsedSysten) {
		foreach (pair;Row) {
			if(find(vars,pair.chr)==[])
			vars ~= pair.chr;
		}
	} 
	return cast(char[])sort(cast(ubyte[])vars).release;
}

//int stratsWithOrEndsWith(alias pred = "a == b", Range, Needles...)(Range doesThisStartOrEnd, Needles withOneOfThese)
// if (isBidirectionalRange!Range && Needles.length > 1 && (
// 			(is(typeof(.endsWith!pred(doesThisEnd, withOneOfThese[0])) : bool) 
// 			&& is(typeof(.endsWith!pred(doesThisEnd, withOneOfThese[1..__dollar])) : uint))
// 		|| 
// 			(is(typeof(.startsWith!pred(doesThisStart, withOneOfThese[0])) : bool) 
// 			&& is(typeof(.startsWith!pred(doesThisStart, withOneOfThese[1..__dollar])) : uint)) 	
// 		)
// 	)	
// {
//	auto sw = std.algorithm.startsWith(doesThisStartOrEnd,withOneOfThese);
//	auto ew = std.algorithm.endsWith(doesThisStartOrEnd,retro(withOneOfThese));  
//}	


//void testArrs() {
//	auto arr0=['b','c','d'];//result ['0','a','b','c'] :0/-4
//	auto arr1=['a','c','d'];//result ['a','0','c','d'] :1/-3
//	auto arr2=['a','b','d'];//result ['a','b','0','d'] :2/-2 
//	auto arr3=['a','b','c'];//result ['a','b','c','0'] :3/-1
//	auto arr4=['b',    'd'];//result ['0','b','0','d'] :[0,2]/[-4,-2]
//	auto arr5=['a','b'    ];//result ['a','b','0','0'] :[0,1]/[-4,-3]
//	auto arr=['a','b','c','d'];
//	writeln(padArray(arr0,arr));
//	assert(padArray(arr0,arr)==[' ','a','b','c']);
//}
 // assert ([a,c,d],[a,b,c,d]) I get [1,-2] and for ([a,b,d],[a,b,c,d]) I get [2,-1]

Pair[][] createPaddedMatrix (ref Pair[][] System,char[] allVariables) {
	Pair[][] paddedSystem; 
	int i=0;
	foreach (ref Row;System) {
		if (Row.length != allVariables.length) {
			alias  map!("a.chr") chrmap;
			writeln(chrmap(Row));
			writeln(allVariables);
			writeln (std.algorithm.startsWith(allVariables,chrmap(Row))); 
			
		} else {
			paddedSystem[i]=System[i]; 
		}
		i++;
	}
	return paddedSystem;
	
}
bool duplicatesInRow (Pair[] Row){
	// check for duplicate Identifier
	// because it is already sorted i just need to compare
	// in order
	for(int i=0;i<Row.length-1;i++) {
		if((Row[i].chr)==(Row[i+1].chr)) return false;
	}
	return true;
}


Pair[] parseRow (ParseTree Input) {
  Pair[] PairStack;
  foreach (ref child;Input.children[0].children) {
      if (child.name=="GaussGrammar.LeftSideElement")
        if (child.matches.length == 2)
     PairStack ~= Pair(to!int(child.matches[0]),to!char(child.matches[1]));
        else if (child.matches.length == 1 && child.matches[0][0] != '-') 
     PairStack ~= Pair(1,to!char(child.matches[0]));
        else 
     PairStack ~= Pair(-1,to!char(child.matches[0][1]));     
     
     else if (child.name=="GaussGrammar.RightSideElement") 
     PairStack ~= Pair(to!int(child.matches[0]),'=');   
    }
    return (sort!("a.chr<b.chr")(PairStack)).release;
}
