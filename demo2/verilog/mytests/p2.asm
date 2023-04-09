// Authors: Yeon Jae Cho and Seth Thao
// Spring 2023
// MEM to EX forwarding test
lbi r1, 5 // r1 = 5
lbi r2, 10 // r2 = 10
lbi r3, 15 // r3 = 15
lbi r4, 20 // r4 = 20
st r4, r2, 4 // MEM[14] <- 20
sub r4, r4, r1 // r4 = r4 - r1 = 20 - 5 = 15
ld r1, r2, 4 // r1 <- MEM[14]
add r3, r1, r4 // r3 = r1 + r4 = 20 + 15 = 35
halt // stop the processor