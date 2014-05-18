import aaSystem;
import std.exception:enforce;
import std.array:array;
import std.algorithm:filter,remove,find,setIntersection,map;
alias AASystem.AARow AARow;
debug import std.stdio;


AASystem eliminateKnownVariables(AASystem sys) {
	
	//writeln(sys.rows);
	bool hadtobreak  = false;
	
	// first reduce Everything without RowbyRow operations
reset_foreach: 
	foreach (i,ref row;sys.rows) {
		if (!row.singleVariable) {
			foreach(var;row.scalars.keys) {
				if(var in sys.kwnvars) {
					//					writeln("removeing Variable: ",var," in row ",i);
					//					writeln("knvrs",sys.kwnvars);
					row.res -= row.scalars[var]*sys.kwnvars[var];
					row.scalars.remove(var);
					goto reset_foreach;
				}
			}
		} else {
			// eliminate if singleVariable
			//			writeln("solving singleVariable ",row.scalars.keys[0]," in row ",i);
			if (row.scalars.keys[0] in sys.kwnvars) {
				assert(0,"something is wrong");
				break;
			} 
			sys.kwnvars[row.scalars.keys[0]] = row.applyTo('/',row.scalars.values[0]).res;
			sys.rows.remove(i);
			sys.rows.length -= 1;
			goto reset_foreach;
		}  	
	}
	
	// now we can try to reduce even more by subtracting rows form each other
	if (sys.rows.length>1) {
		foreach (row;sys.rows[1 .. $]) {
			auto intr= cast(char[])setIntersection(sys.rows[0].scalars.keys,row.scalars.keys).array;
			if (intr) {
			sys.rows[0] = sys.rows[0].applyTo('-',row.applyTo('*',sys.rows[0].scalars[intr[0]] / row.scalars[intr[0]]));
			sys.rows[0].scalars.remove(intr[0]);
			}
		}
		goto reset_foreach;
	}
	return sys;
}
