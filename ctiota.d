module ctiota;

template toTypeTuple(alias range)
{
	import std.range : isInputRange;
	alias Arr = typeof(range);
	static if (isArray!Arr && !isNarrowString!Arr)
	{
		static if (range.length == 0)
		{
			alias toTypeTuple = TypeTuple!();
		}
		else static if (range.length == 1)
		{
			alias toTypeTuple = TypeTuple!(range[0]);
		}
		else
		{
			alias toTypeTuple = TypeTuple!(toTypeTuple!(range[0 .. $/2]), toTypeTuple!(range[$/2 .. $]));
		}
	}
	else static if (isInputRange!Arr)
	{
		import std.array : array;
		alias toTypeTuple = toTypeTuple!(array(range));
	}
	else
	{
		import std.string : format;
		static assert (0, format("Cannot transform %s of type %s into a TypeTuple.", range, Arr.stringof));
	}
}

template Iota(int stop) {
	static if (stop <= 0)
		alias TypeTuple!() Iota;
	else
		alias TypeTuple!(Iota!(stop-1), stop-1) Iota;
}

/// ditto
template Iota(int start, int stop) {
	static if (stop <= start)
		alias TypeTuple!() Iota;
	else
		alias TypeTuple!(Iota!(start, stop-1), stop-1) Iota;
}

/// ditto
template Iota(int start, int stop, int step) {
	import std.typetuple;
	static assert(step != 0, "Iota: step must be != 0");
	
	static if (step > 0) {
		static if (stop <= start)
			alias TypeTuple!() Iota;
		else
			alias TypeTuple!(Iota!(start, stop-step, step), stop-step) Iota;
	} else {
		static if (stop >= start)
			alias TypeTuple!() Iota;
		else
			alias TypeTuple!(Iota!(start, stop-step, step), stop-step) Iota;
	}
} // End Iota!(a,b,c)
