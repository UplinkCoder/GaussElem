import std.stdio;
import std.string;
import aaSystem;
import reduceMatrix;
//import System;
import parseEquationSystem;
import forops;

void main(string[] args) {
	string[] testInput = [
		"2x=10",
		"2y-c=-6",
		"4y-x+2c=81",
		"7d=7"];
	string[] testInput2 = [
		"2a+4b=-12",
		"a+b  = 6",
		"6a-12d-e-b = 9",
		"2x+2m-2b=12",
		"2b-1q-3m=14",
		"a-b=-6"];

	auto testSystem = getAASystem(testInput);
	auto testSystem2 = getAASystem(testInput2);
	writeln(testSystem);
	writeln(testSystem2);
	writeln(AASystem(testSystem2.getRowsWith(['a','e'])).applyTo('/',12).applyTo('*',-24));
	writeln(testSystem2.allIdentifiers);
	testSystem.reduceSingles.writeln;
	
	//writeln("all used Indentifiers are:",testSystem.allIdentifiers);
}
