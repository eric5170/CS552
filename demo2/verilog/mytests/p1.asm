// Authors: Yeon Jae Cho and Seth Thao
// Spring 2023
// EX -> EX forwarding example
lbi r1, 10 // r1 = 10
lbi r2, -5 // r2 = -5
add r3, r1, r2 // r3 = r1 + r2 = 10 - 5 = 5
sub r4, r3, r1 // r4 = r3 - r1 = 5 - 10 = -5
add r5, r4, r2 // r5 = r4 + r2 = -5 - 5 = -10
halt // stop the processor