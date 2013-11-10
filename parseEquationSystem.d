/* Note I should propebly make use of pegged :D */

// Input will come in following form : 
// 2a+4b=-12
// a+b  = 6
// will make use of pegged right now
import pegged.grammar;
//import GaussParser;
import std.stdio,std.numeric,std.algorithm;

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

 struct Pair {
      int val;
      char chr;
  }


void main() {
  //pegged.grammar.asModule("GaussParser","src/GausParser",GGstring);
  // I need to transform a LeftSideElement into a pair
  // [char Identifier,int Number]
  foreach (line;stdin.byLine) {
      ParseTree Input =GaussGrammar(cast(string)line);
      Pair[] row=parseRow(Input);
      writeln(row);
      //checkRow(row)
      
  }
  
  
   
  //ParseTree cleand = pegged.peg.decimateTree(Input);
 //writeln(Input);
  
  // HERE ROW PARSING STARTS
  
  
  // HERE ROW PARSING ENDS
}

Pair[] parseRow (ParseTree Input) {
  Pair[] PairStack;
  foreach (ref child;Input.children[0].children) {
      debug writeln(child);
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