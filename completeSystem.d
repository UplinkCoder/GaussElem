
//int stratsWithOrEndsWith(alias pred = "a == b", Range, Needles...)(Range doesThisStartOrEnd, Needles withOneOfThese)
// if (isBidirectionalRange!Range && Needles.length > 1 && (
// 			(is(typeof(.endsWith!pred(doesThisEnd, withOneOfThese[0])) : bool) 
// 			&& is(typeof(.endsWith!pred(doesThisEnd, withOneOfThese[1..__dollar])) : uint))
// 		|| 
// 			(is(typeof(.startsWith!pred(doesThisStart, withOneOfThese[0])) : bool) 
// 			&& is(typeof(.startsWith!pred(doesThisStart, withOneOfThese[1..__dollar])) : uint)) 	
// 		)
// 	)	
// {
//	auto sw = std.algorithm.startsWith(doesThisStartOrEnd,withOneOfThese);
//	auto ew = std.algorithm.endsWith(doesThisStartOrEnd,retro(withOneOfThese));  
//}	


//void testArrs() {
//	auto arr0=['b','c','d'];//result ['0','a','b','c'] :0/-4
//	auto arr1=['a','c','d'];//result ['a','0','c','d'] :1/-3
//	auto arr2=['a','b','d'];//result ['a','b','0','d'] :2/-2 
//	auto arr3=['a','b','c'];//result ['a','b','c','0'] :3/-1
//	auto arr4=['b',    'd'];//result ['0','b','0','d'] :[0,2]/[-4,-2]
//	auto arr5=['a','b'    ];//result ['a','b','0','0'] :[0,1]/[-4,-3]
//	auto arr=['a','b','c','d'];
//	writeln(padArray(arr0,arr));
//	assert(padArray(arr0,arr)==[' ','a','b','c']);
//}
// assert ([a,c,d],[a,b,c,d]) I get [1,-2] and for ([a,b,d],[a,b,c,d]) I get [2,-1]
T[] padArray (T,U)(T[] a,U[] b) {
	assert(a.length<=b.length);
	T[] aux;
	aux.length = b.length;
	int firsteq; // first equal
	
	for (int i=0;i<b.length;i++)
		if(a[0]==b[i]) {
		firsteq=i;		
		}
		
}
