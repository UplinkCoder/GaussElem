/* Note I should propebly make use of pegged :D */

// Input will come in following form : 
// 2a+4b=-12
// a+b  = 6
// will make use of pegged right now
import std.conv:to;
import System:AASystem,AARow;
import GaussParser;
import std.stdio;

AASystem getAASystem(string[] input) {
  AARow[] Rows;
  foreach (line;input) {
      if (line=="") break;
      ParseTree Input =GaussGrammar(cast(string)line);
      Rows ~= parseRow(Input);
  }
return AASystem(Rows); 
}

private AARow parseRow (ParseTree Input) {
  AARow.aaType val;
  int res;
  foreach (ref child;Input.children[0].children) {
      if (child.name=="GaussGrammar.LeftSideElement")
        if (child.matches.length == 2)
     val[to!char(child.matches[1])] = to!int(child.matches[0]);
        else if (child.matches.length == 1 && child.matches[0][0] != '-') 
     val[to!char(child.matches[0])] = 1;
        else 
     val[to!char(child.matches[0][1])] = -1;
     
     else if (child.name=="GaussGrammar.RightSideElement") 
     res = to!int(child.matches[0]);   
    }
   
    return AARow(val,res);
}
