import aaSystem;
alias AASystem.AARow AARow;
debug import std.stdio;

AASystem reduceKownVariables(ref AASystem sys) {
	foreach (ref r;sys.rows) {
		r = r.eliminateKnownVariables(sys.knwvars);
	}
	return sys;
}

AARow reduceRowbyRow(AARow r1,AARow r2) {
	
}

AARow eliminateKnownVariables(AARow row, double[char] kwnvars) {
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