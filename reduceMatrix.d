import aaSystem;

double[char] reduceSingles(AASystem sys/*,ref Variable[char] vars*/) {
	auto svrs = sys.getSingleVariableRows;
	double[char] res;
	foreach (svr;svrs) {
		res[svr.vals.keys[0]] = svr.applyTo('/',svr.vals.values[0]).res;
	}
	return res;
} 

double[char] reduce_(AASystem sys, double[char] results) {
	auto rs = sys.getRowsWith(results.keys);
	double[char] res;
	foreach (ref r;rs) {
		//r = r.eliminateKnownVariables(results);
	}
	return AASystem(rs).reduceSingles;
}

//AARow eliminateKnownVariables(AARow row, double[char] kwnvars) {
	 
  
