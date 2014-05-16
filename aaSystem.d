import std.algorithm;
import std.array;
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
			enum OPS = ['/','*'];
			AARow ar;
			foreach (k,v;scalars) {
				mixin(ForOps!("ar.scalars[k] = v ",/*~op~*/" val",
				              "ar.res = res ",/*~op~*/" val") (OPS));
			}
			return ar;
		}

		AARow applyTo (char op,AARow r) {
			enum OPS = ['+','-'];
			AARow ar = this;
			char[] vars = to!(char[])(setIntersection(scalars.keys,r.scalars.keys).array);
			if (vars && r!is this) {
				foreach(var;vars) {
					mixin(ForOps!("ar.scalars[var] ","= r.scalars[var]")(OPS));
				}
				mixin (ForOps!("ar.res ","= r.res")(OPS));
			}
			return ar;
		}

		void removeZeroScalars() {
			foreach (key;scalars.keys)
				if (scalars[key]==0) scalars.remove(key);
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

	
	AASystem reduceSingles() {
		foreach (ref r;rows) {
			r.removeZeroScalars;
			if (r.singleVariable) {
				r = r.applyTo('/',r.scalars.values[0]);
				knwvars[r.scalars.keys[0]] = r.res;
			}
		}
		return this; 
	}

	this (AARow[] aars) {
		rows = aars;
	}

	string toString() {
		char[] vstring;
		foreach (r;rows) {
			foreach (i;0 .. r.scalars.length) {
				if (r.scalars.values[i]>0 && i!=0) vstring ~= '+';
				if (r.scalars.values[i]!=1) vstring ~= to!string(r.scalars.values[i]);
				vstring ~= r.scalars.keys[i];
			}
			vstring ~= "=" ~ to!string(r.res) ~ "\n";
		}
		return cast(string)vstring;
	}

}
alias Variable = AASystem.Variable;