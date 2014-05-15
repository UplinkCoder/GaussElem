import std.algorithm;
import std.conv:to;
import std.stdio;
import forops;
struct AASystem {
	static struct Variable {
		char chr;
		double val;
		@property hasValue() {return (val != double.init);}
		
		void opAssign(char c) {
			this.chr = c;
		}

	}

	struct AARow {
		double[char] scalars;
		double res;
		this (double[char] v,double r) {
			foreach(key,val;v) {
				scalars[key]=val;
			}
			res=r;
		}

		bool isSolved() {return (singleVariable && scalars.values[0] == 1);}
		
		@property bool singleVariable() {return scalars.length == 1;}

		bool hasVariables(char[] vars) {
			foreach (v;vars)
				if (!hasVariable(v))
					return false;
			return true;
		}

		bool hasVariable(char var) {
			foreach(v;scalars.byKey) {
				if (var == v) 
					return true;
			}
			return false;
		}
		
		AARow applyTo(char op,double val) {
			double res;
			double[char] vals;
			foreach (v;scalars.byKey) {
				mixin(ForOps!("vals[v] = this.scalars[v]",/*~op~*/"val",
				              "res = this.res",/*~op~*/"val") (['/','*']));
			}
			return AARow(vals,res);
		}
	}

	
	AARow rows[];
	double[char] knwvars; 
	
	char[] allIdentifiers;

	AARow[] getSingleVariableRows() {
		AARow[] res;
		foreach (ref r;rows) {
			if (r.singleVariable) {
				res ~= r;
			}
		}
		return res;
	}

	
	AASystem applyTo(char op,double val) {
		AARow[] aars;
		foreach (r;rows) {
			aars ~=   r.applyTo(op,val);
		}
		return AASystem(aars);
	}

	AARow[] getRowsWith(char[] vars) {
		AARow[] res;
		foreach (r;rows) {
			if (r.hasVariables(vars)) {
				res ~= r;
			}
		}
		return res;
	}

	void reduceSingles() {
		foreach (ref r;rows) {
			if (r.singleVariable) {
				r = r.applyTo('/',r.scalars.values[0]);
				knwvars[r.scalars.keys[0]] = r.res;
			}
		}
	}

	this (AARow[] aars) {
		rows = aars;
	}

	string toString() {
		char[] vstring;
		foreach (r;rows) {
			foreach (i;0 .. r.scalars.length) {
				if (r.scalars[r.scalars.keys[i]]>0 && i!=0) vstring ~= '+';
				vstring ~= to!string(r.scalars[r.scalars.keys[i]]) ~ r.scalars.keys[i];
			}
			vstring ~= "=" ~ to!string(r.res) ~ "\n";
		}
		return cast(string)vstring;
	}

}
alias Variable = AASystem.Variable;