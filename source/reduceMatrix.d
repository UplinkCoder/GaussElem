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
AASystem applyFuncToEachRow(alias f, Args...)(AASystem sys,ref Args args) /*pure*/
/*if (is(typeof(&f):AARow function (AARow,Args))||is(typeof(&f):AARow function(AARow,double)))*/ {
	AARow[] tmp; 
	foreach (row;sys.rows) {
		tmp ~= f(row,args);
	}
	return AASystem(tmp);
}

T lcm (T)(T a,T b) pure {
	import std.math:abs;
	return abs(a*b)/gcd(a,b);
} 
unittest {
	alias _lcm = reduce!((a,b) => lcm(a,b));
	bool isCumulative(alias f)() if (is(typeof(f) ==function))
	{

	}
	assert(lcm(21,7) == 21);
	assert(_lcm(21,7,14,28) == 28);
}
AARow mulByLCM (AARow row, double v=1) /*pure*/ {
	auto multiplicator = reduce!((a,b) => lcm(a,b))(v,row.scalars);
	if (multiplicator<0) multiplicator = 1;
	return row*multiplicator;
}
AARow divByGCD (AARow row,double v=0) /*pure*/ {
	return row / reduce!((a,b) => gcd(a,b))(v,row.scalars);
}
AASystem applyGCD (AASystem sys) /*pure*/ {
	return applyFuncToEachRow!divByGCD(sys);
}
AASystem applyLCM (AASystem sys) /*pure*/ {
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
			if (ev in kwnvars) {
				if ((row/row[ev]).res != kwnvars[ev])
					assert(0,"something is ambiguas");
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
	auto intr= setIntersection(r1.vars,r2.vars).array;
		if(intr) {
		char v = cast(char)intr[0];
		auto scl1 = lcm(r1[v],r2[v])/r1[v];
		auto scl2 = lcm(r1[v],r2[v])/r2[v];
		r1 = r1*scl1-r2*scl2;
		foreach(k,v;r1) {
			if(v.approxEqual(0)) r1.scalars.remove(k);
		}
	}
	return r1;
}
unittest {
	auto r1 = AARow(['a':2,'b':4],16);
	auto r2 = AARow(['a':-2,'b':2],16);

	auto res = eliminateRowVar(r1,r2);
	//assert(res == AARow['b':)
}