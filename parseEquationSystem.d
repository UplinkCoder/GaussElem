import std.conv:to;
import GaussParser;
import std.stdio;
import aaSystem:AASystem;

AASystem getAASystem(string[] input) {
	AASystem.AARow[] Rows;
	foreach (line;input) {
		if (line=="") break;
		ParseTree Input =GaussGrammar(cast(string)line);
		Rows ~= parseRow(Input);
	}
	return AASystem(Rows); 
}

private AASystem.AARow parseRow (ParseTree Input) {
	double[char] val;
	char chr;
	double scalar;
	double res;
	foreach (ref child;Input.children[0].children) {
		if (child.name=="GaussGrammar.LeftSideElement") {
			if (child.matches.length == 2)
				scalar = to!double(child.matches[0]), chr = to!char(child.matches[1]);
			else if (child.matches.length == 1 && child.matches[0][0] != '-') 
				scalar = 1, chr = to!char(child.matches[0]);
			else 
				scalar =  -1, chr = to!char(child.matches[0][1]);

			val[chr] = scalar;
		}
		else if (child.name=="GaussGrammar.RightSideElement") 
			res = to!int(child.matches[0]);   

	}
	
	return AASystem.AARow(val,res);
}