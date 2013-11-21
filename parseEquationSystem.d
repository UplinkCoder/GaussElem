/* Note I should propebly make use of pegged :D */

// Input will come in following form : 
// 2a+4b=-12
// a+b  = 6
// will make use of pegged right now
import pegged.grammar;
import System:System,Row;
import std.algorithm:sort;
//import GaussParser;
import std.stdio;
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
mixin(grammar(GGstring));

System getSystem(string[] input) {
  Row[] Rows;
  foreach (line;input) {
	  if (line=="") break;
      ParseTree Input =GaussGrammar(cast(string)line);
      Row row=parseRow(Input);
     Rows ~= row;
  }
return System(Rows); 
}

private bool duplicatesInRow (Row.Pair[] pa){
	// check for duplicate Identifier
	for(int i=0;i<pa.length-1;i++) {
		if((pa[i].chr)==(pa[i+1].chr)) return true;
	}
	return false;
}

private Row parseRow (ParseTree Input) {
  Row.Pair[] vars;
  int res;
  foreach (ref child;Input.children[0].children) {
      if (child.name=="GaussGrammar.LeftSideElement")
        if (child.matches.length == 2)
     vars ~= Row.Pair(to!int(child.matches[0]),to!char(child.matches[1]));
        else if (child.matches.length == 1 && child.matches[0][0] != '-') 
     vars ~= Row.Pair(1,to!char(child.matches[0]));
        else 
     vars ~= Row.Pair(-1,to!char(child.matches[0][1]));     
     
     else if (child.name=="GaussGrammar.RightSideElement") 
     res = to!int(child.matches[0]);   
    }
    if (!duplicatesInRow(vars)) 
    return Row(vars,res);
    throw (new Exception("There where duplicars in one row") );
}
