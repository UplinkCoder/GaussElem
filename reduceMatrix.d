import aaSystem;
import std.array:array;
import std.algorithm:setIntersection;
import std.conv:to;
alias AASystem.AARow AARow;
debug import std.stdio;

AASystem reduceKownVariables(ref AASystem sys) {
	sys.reduceSingles;
	foreach (ref r;sys.rows) {
		r = r.eliminateKnownVariables(sys.knwvars);
	}
	sys.reduceSingles;
	return sys;
}

AASystem rowReducedSystem(AASystem sys) {
	foreach (i; 0 .. sys.rows.length) {
		foreach (j; i .. sys.rows.length) {
			sys.rows[i] = sys.rows[i].applyTo('-',sys.rows[j]);
		}
	}
	return sys;
}



AARow eliminateKnownVariables(AARow row, double[char] kwnvars) {
	row.removeZeroScalars;
	if (row.singleVariable) return row;
	AARow res;
	res.res = row.res;
	foreach(var;row.scalars.keys) {
		if(var !in kwnvars) {
			res.scalars[var] = row.scalars[var];
		} else {
			res.res -= row.scalars[var]*kwnvars[var];
		}
	}
	return res;
}