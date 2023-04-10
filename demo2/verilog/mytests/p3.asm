// Authors: Yeon Jae Cho and Seth Thao
// Spring 2023
// MEM to MEM forwarding test
lbi r1, 20     ; r1 = 20
lbi r3, -15    ; r3 = -15
xor r2, r2     ; r2 = 0
subi r2, r2, 5 ; r2 = -5
sub r2, r1, r2 ; r2 = r1 - (-5) = 25
sub r2, r2, r3 ; r2 = r2 - r3 = 10
halt