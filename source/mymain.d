import std.stdio;
import std.string;
import aaSystem;
import reduceMatrix;
//import System;
import parseEquationSystem;
import forops;

void main(string[] args) {

	string[] _sys;
	foreach(line;stdin.byLine) {
	if (line=="") break;
	_sys ~= line.dup;
	}
	

	auto testSystem = getAASystem(_sys);
	
	writeln("Initial System :");
	writeln(testSystem);
	writeln("GCD applyed:");
	writeln(testSystem.applyGCD);
	writeln("LCM applyed");
	writeln(testSystem.applyLCM);
	//writeln("Kown Variable Reduction (includes reduceSingle):");
	//testSystem.eliminateKnownVariables.writeln;
	//writeln("After row reduction");

	//	testSystem.rowReducedSystem.writeln;
	//	testSystem.rows[1] = testSystem.rows[1].applyTo('/',testSystem.rows[1].scalars.values[0]/testSystem.rows[2].scalars.values[0]);
	//	testSystem.rows[1] = testSystem.rows[1].applyTo('-',testSystem.rows[2]);
	//	testSystem.reduceSingles;
	//	testSystem.reduceKownVariables;
	//	testSystem.reduceSingles;
	//	writeln(testSystem);
}
