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
	writeln("after solving");
	double[char] varstore;
	bool goon = true;

	while (goon) {
		writeln ("still sloving");
		writeln (varstore);
		uint[] rowstoremove;
		foreach (i;rowstoremove) testSystem.rows.remove(i);

		foreach (uint i,ref row;testSystem.rows) {
			if (row.singleVariable) {
				row.eliminateSingels(varstore);
				rowstoremove~=i;
			} else {
				row = row.eliminateKnownVariables(varstore);
			}

			if (i != testSystem.rows.length-1) {
				auto r2 = testSystem.rows[i+1]; 
			row = eliminateRowVar(row,r2);
			}
		}
		if (varstore.length == testSystem.vars.length) goon = false;
	}
	writeln(testSystem);
}
