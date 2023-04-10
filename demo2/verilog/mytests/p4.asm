// Authors: Yeon Jae Cho and Seth Thao
// Spring 2023
// MEM to WB forwarding test
lbi r1, 5		// r1 = 5
lbi r2, 2		// r2 = 2
add r3, r1, r2		// r3 = r1 + r2 = 5 + 2 = 7
sw r3, [r4]		// store r3 in memory at the address in r4
halt			// stop