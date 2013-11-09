/* Note I should propebly make use of pegged :D */

// Input will come in following form : 
// 2a+4b=-12
// a+b  = 6
// will make use of pegged right now
import pegged.grammar;

import std.stdio,std.numeric;

enum GGstring = `
    GaussGrammar:

    Formula  <- ('+'? LeftSideElement)+ '=' RightSideElement
    
    LeftSideElement <-  Number Letter / Minus? Letter
    RightSideElement <- Number
   
    Plus      <- '+'
    Minus     <- '-'     
    Equals <- '='
    
    Number <- Minus? ~Digit+
    Digit   <- [0-9]
    Letter <- [a-z]
`;
mixin(grammar(GGstring));

void main() {
  //pegged.grammar.asModule("GaussParser","src/GausParser",GGstring);
  // I need to transform a LeftSideElement into a pair
  // [char Identifier,int Number]
    
  struct matrix(T) {
      uint x,y;
      
      T get(uint x,uint y) {
          return matrix(x,y);
      }
  }

} 
