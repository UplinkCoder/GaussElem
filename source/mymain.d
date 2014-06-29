import std.stdio;
import std.string;
import aaSystem;
import reduceMatrix;

import parseEquationSystem;


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
	uint[] rowstoremove;
	uint varnum = testSystem.vars.length;
	while (goon) {
		writeln ("still sloving");
		writeln(testSystem);
		writeln (varstore);
		foreach (i;rowstoremove) testSystem.rows.remove(i);

		foreach (uint i,ref row;testSystem.rows) {

			if (row.singleVariable) {
				if (row.keys[0] !in varstore) {
				row.eliminateSingels(varstore);
				} else {
					continue;
				}
			} else {
				row = row.eliminateKnownVariables(varstore);
				if (row.singleVariable) break;
				if (testSystem.rows.length>1) {
					auto r2=testSystem.rows[0];


				if (i != testSystem.rows.length-1) 
						r2=testSystem.rows[i+1];

					if (!r2.singleVariable) 
					row = eliminateRowVar(row,r2);
					break;
				} else {
					goon = false;
				}
			}


		}
		if (varstore.length == varnum) goon = false;
	}
	writeln(testSystem);
	writeln("Solved vars are: ",varstore);
}
