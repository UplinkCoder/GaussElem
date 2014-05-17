import std.stdio;
import std.string;
import aaSystem;
import reduceMatrix;
//import System;
import parseEquationSystem;
import forops;

void main(string[] args) {
	//x = 1
	//c = 5
	//d = 10
	//f = 12
	//e = 2.5
	
	string[] testInput = [
		"2x=2",
		"2y-c-d=-15",
		"4y+x+2c=11",
		"2e+d=15",
		"f+d-8e=2",
		"x+d=11",
		"x-f-j=-22"
		
	];
	string[] testInput2 = [
		"2a+4b=-12",
		"a+b  = 6",
		"6a-12d-e-b = 9",
		"2x+2m-2b=12",
		"2b-1q-3m=14",
		"a-b=-6"
	];
	
	auto testSystem = getAASystem(testInput);
	auto testSystem2 = getAASystem(testInput2);
	writeln("Initial System :");
	writeln(testSystem);
	writeln("Kown Variable Reduction (includes reduceSingle):");
	testSystem.eliminateKnownVariables.writeln;
	writeln("After row reduction");
	//	testSystem.rowReducedSystem.writeln;
	//	testSystem.rows[1] = testSystem.rows[1].applyTo('/',testSystem.rows[1].scalars.values[0]/testSystem.rows[2].scalars.values[0]);
	//	testSystem.rows[1] = testSystem.rows[1].applyTo('-',testSystem.rows[2]);
	//	testSystem.reduceSingles;
	//	testSystem.reduceKownVariables;
	//	testSystem.reduceSingles;
	//	writeln(testSystem);
}
