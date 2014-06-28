import aaSystem;
import std.math:approxEqual;
import std.numeric:gcd;

import std.exception:enforce;
import std.array:array;
import std.algorithm:filter,remove,find,setIntersection,map,reduce;
alias AASystem.AARow AARow;
import std.stdio;


//AARow applyLCM (AARow row) {
//
//}
AASystem applyFuncToEachRow(alias f)(AASystem sys) pure
if (is(typeof(&f):AARow function (AARow))||is(typeof(&f):AARow function(AARow,double))) {
	foreach (ref row;sys.rows) {
		row = f(row);
	}
	return sys;
}

T lcm (T)(T a,T b) pure {
	return a/gcd(a,b) * b;
}
AARow mulByLCM (AARow row, double v=1) pure {
	auto multiplicator = reduce!((a,b) => lcm(a,b))(v,row.scalars);
	return row*multiplicator;
}
AARow divByGCD (AARow row,double v=1) pure {
		auto divisor = reduce!((a,b) => gcd(a,b))(v,row.scalars);
		return row / divisor;
}
AASystem applyGCD (AASystem sys) pure {
	return applyFuncToEachRow!divByGCD(sys);
}
AASystem applyLCM (AASystem sys) pure {
	return applyFuncToEachRow!mulByLCM(sys);
}

AARow eliminateKnownVariables(AARow row,in double[char] kwnvars) {
		if (!row.singleVariable) {
			foreach(var;row.vars) {
				if(var in kwnvars) {
					row.res -= row[var]*kwnvars[var]; // a=7;a+b=9;  a+b=9 / -a; b=2
					row.scalars.remove(var);
				}
			}
		}
	return row;
}

			// eliminate if singleVariable
AARow eliminateSingels(AARow row,ref double[char] kwnvars) {
		if (row.singleVariable) {
			foreach(var;row.vars) {			
				auto ev = row.vars[0];
				if (row.scalars.keys[0] in kwnvars) {
					assert(0,"something is wrong");
				}
				assert( (row/row[ev])[ev] == 1, "something is very wrong");
				kwnvars[ev] = (row/row[ev]).res;  // 7a=14  | /7; a=2 | knwvars[a] = 2
			}  	
		}
	return row;
}

	// now we can try to reduce even more by subtracting rows form each other
AARow eliminateRowVar(AARow r1,AARow r2) {
			writefln("looking for intersctions in row %s and %s",r1,r2);
			auto intr= cast(char[])setIntersection(r1.vars,r2.vars).array;
			if (intr) {
				auto var = intr[0];
					r1 = r1.mulByLCM(r1[var] / r2[var]);
				if (r1[var].approxEqual(0)) r1.scalars.remove(var);
			}
	return r1;
}
