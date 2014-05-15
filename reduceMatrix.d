import aaSystem;
alias AASystem.AARow AARow;
debug import std.stdio;


double[char] reduceSingles(AASystem sys/*,ref Variable[char] vars*/) {
	auto svrs = sys.getSingleVariableRows;
	double[char] res;
	foreach (svr;svrs) {
		res[svr.vals.keys[0]] = svr.applyTo('/',svr.vals.values[0]).res;
	}
	return res;
} 

auto reduce_(AASystem sys, double[char] results) {
	AARow[] rs;
	foreach (key;results.keys) {
		rs ~= sys.getRowsWith([key]);
	}
	debug  writeln(rs);
	double[char] res;
	foreach (ref r;rs) {
		r = r.eliminateKnownVariables(results);
	}
	return rs;
}

AARow eliminateKnownVariables(AARow row, double[char] kwnvars) {
	if (row.singleVariable) return row;
	AARow res;
	res.res = row.res;
	foreach(var;row.vals.keys) {
		if(var !in kwnvars) {
			res.vals[var] = row.vals[var];
		} else {
			res.res -= row.vals[var]*kwnvars[var];
		}
	}
	return res;
}


