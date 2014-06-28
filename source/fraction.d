module fraction;
//import std.bigint;
import std.numeric:gcd;

struct Fraction
{
	int z,n;

	Fraction opBinary(string op)(int rhs)
	{
		static if (op=="*") {
			return Fraction(z*rhs,n*rhs);
		}
	}
	// b1=(7/28) b2=(7/14)  b1/gcd =(1/3)*2 b2/gcd(1/2)*3 (2/6)+(3/6) (1 n2/gcd = 2 || b2
	// b1(1/4) b2 (1/8) gcd(4,8) = 4 || b1*gcd(b1.n,b2.n) b2*(gcd(b1.n,b2.n)) 
	//  (8/16) + (16/2)  || (1/2) + 16/2

	void shorten () {
		auto div = gcd(z,n);
		z /= div,n /= div;
	}
	Fraction opBinary(string op)(Fraction rhs) {
		static if (op=="*") {
			return Fraction(z*rhs.z,n*rhs.n);
		} else static if (op=="/") {
			return Fraction(z*rhs.n,n*rhs.z);


		} else { assert(false,"Operator"~op~"not Implemented");}
	}

}

