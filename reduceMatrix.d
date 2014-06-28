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
AASystem applyFuncToEachRow(alias f)(AASystem sys)
if (is(typeof(&f):AARow function (AARow))||is(typeof(&f):AARow function(AARow,double))) {
	foreach (ref row;sys.rows) {
		row = f(row);
	}
	return sys;
}

T lcm (T)(T a,T b) {
	return a/gcd(a,b) * b;
}
AARow mulByLCM (AARow row,double v=1) {
	auto multiplicator = reduce!((a,b) => lcm(a,b))(v,row.scalars);
	return row*multiplicator;
}
AARow divByGCD (AARow row,double v=1) {
		auto divisor = reduce!((a,b) => gcd(a,b))(v,row.scalars);
		return row / divisor;
}
AASystem applyGCD (AASystem sys) {
	return applyFuncToEachRow!divByGCD(sys);
}
AASystem applyLCM (AASystem sys) {
	return applyFuncToEachRow!mulByLCM(sys);
}

AASystem eliminateKnownVariables(AASystem sys,in double[char] kwnvars) {
	foreach (i,ref row;sys.rows) {
		if (!row.singleVariable) {
			foreach(var;row.vars) {
				if(var in kwnvars) {
					row.res -= row[var]*sys.kwnvars[var]; // a=7;a+b=9;  a+b=9 / -a; b=2
					row.scalars.remove(var);
				}
			}
		}
	}
	return sys;
}

			// eliminate if singleVariable
AASystem eliminateSingels(AASystem sys,inout double[char] kwnvars) {
	foreach (i,ref row;sys.rows) {
		if (row.singleVariable) {
			foreach(var;row.vars) {			
				auto ev = row.vars[0];

				if (row.scalars.keys[0] in sys.kwnvars) {
					assert(0,"something is wrong");
					break;
				}
				assert( (row/row[ev])[ev] == 1, "something is very wrong");
				sys.kwnvars[ev] = (row/row[ev]).res;  // 7a=14  | /7; a=2 | knwvars[a] = 2
				sys.rows.remove(i);
				sys.rows.length -= 1;
			}  	
		}
	}
	return sys;
}

	// now we can try to reduce even more by subtracting rows form each other
AASystem eliminateRowVar(AASystem sys,in double[char] kwnvars) {
	if (sys.rows.length>1) {
		foreach (i,row;sys.rows[1 .. $]) {
			writeln("looking for intersctions in row 0 and ",i+1);
			auto intr= cast(char[])setIntersection(sys.rows[0].vars,row.vars).array;
			if (intr) {
				auto var = intr[0];
					sys.rows[0] = sys.rows[0].mulByLCM(sys.rows[0][var] / row[var]);
				if (sys.rows[0][var].approxEqual(0)) sys.rows[0].scalars.remove(var);
			}
		}
	}
	return sys;
}
