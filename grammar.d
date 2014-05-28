

immutable string GGstring = 
	"  GaussGrammar:

    Row  <  ((RowId)':')? (:'+'? LeftSideElement)+ '=' RightSideElement (:'|'? RowOp)? /
			((RowId)':') RowId RowOp
    
  
    LeftSideElement <- Number Letter /
                       ~(Minus? Letter) 
    RightSideElement <- Number
   
    RowOp < (('*'/'/') Number) / (('+'/'-') RowId) 
   
	RowId <- :('r'/'R')? Number
	
    Minus     <- '-'     
    
    Number <~ :'('? Minus? ~Digit+ :')'? 
    Digit   <- [0-9]
    Letter <- [a-z]
";
