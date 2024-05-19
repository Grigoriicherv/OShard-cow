
user/_cowtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <rotest_victim>:
    0x13, 0x05, 0xb0, 0x07,  // li a0, 123
    0x89, 0x48,              // li a7, 2
    0x73, 0x00, 0x00, 0x00   // ecall
};

void rotest_victim() { sleep(5); }
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
   8:	4515                	li	a0,5
   a:	00001097          	auipc	ra,0x1
   e:	98e080e7          	jalr	-1650(ra) # 998 <sleep>
  12:	60a2                	ld	ra,8(sp)
  14:	6402                	ld	s0,0(sp)
  16:	0141                	addi	sp,sp,16
  18:	8082                	ret

000000000000001a <simpletest>:
void simpletest() {
  1a:	7179                	addi	sp,sp,-48
  1c:	f406                	sd	ra,40(sp)
  1e:	f022                	sd	s0,32(sp)
  20:	ec26                	sd	s1,24(sp)
  22:	e84a                	sd	s2,16(sp)
  24:	e44e                	sd	s3,8(sp)
  26:	1800                	addi	s0,sp,48
  printf("simple: ");
  28:	00001517          	auipc	a0,0x1
  2c:	e0850513          	addi	a0,a0,-504 # e30 <malloc+0xf2>
  30:	00001097          	auipc	ra,0x1
  34:	c50080e7          	jalr	-944(ra) # c80 <printf>
  char *p = sbrk(sz);
  38:	05555537          	lui	a0,0x5555
  3c:	55450513          	addi	a0,a0,1364 # 5555554 <base+0x554f544>
  40:	00001097          	auipc	ra,0x1
  44:	950080e7          	jalr	-1712(ra) # 990 <sbrk>
  if (p == (char *)0xffffffffffffffffL) {
  48:	57fd                	li	a5,-1
  4a:	06f50563          	beq	a0,a5,b4 <simpletest+0x9a>
  4e:	84aa                	mv	s1,a0
  for (char *q = p; q < p + sz; q += 4096) {
  50:	05556937          	lui	s2,0x5556
  54:	992a                	add	s2,s2,a0
  56:	6985                	lui	s3,0x1
    *(int *)q = getpid();
  58:	00001097          	auipc	ra,0x1
  5c:	930080e7          	jalr	-1744(ra) # 988 <getpid>
  60:	c088                	sw	a0,0(s1)
  for (char *q = p; q < p + sz; q += 4096) {
  62:	94ce                	add	s1,s1,s3
  64:	fe991ae3          	bne	s2,s1,58 <simpletest+0x3e>
  int pid = fork();
  68:	00001097          	auipc	ra,0x1
  6c:	898080e7          	jalr	-1896(ra) # 900 <fork>
  if (pid < 0) {
  70:	06054363          	bltz	a0,d6 <simpletest+0xbc>
  if (pid == 0) exit(0);
  74:	cd35                	beqz	a0,f0 <simpletest+0xd6>
  wait(0);
  76:	4501                	li	a0,0
  78:	00001097          	auipc	ra,0x1
  7c:	898080e7          	jalr	-1896(ra) # 910 <wait>
  if (sbrk(-sz) == (char *)0xffffffffffffffffL) {
  80:	faaab537          	lui	a0,0xfaaab
  84:	aac50513          	addi	a0,a0,-1364 # fffffffffaaaaaac <base+0xfffffffffaaa4a9c>
  88:	00001097          	auipc	ra,0x1
  8c:	908080e7          	jalr	-1784(ra) # 990 <sbrk>
  90:	57fd                	li	a5,-1
  92:	06f50363          	beq	a0,a5,f8 <simpletest+0xde>
  printf("ok\n");
  96:	00001517          	auipc	a0,0x1
  9a:	dea50513          	addi	a0,a0,-534 # e80 <malloc+0x142>
  9e:	00001097          	auipc	ra,0x1
  a2:	be2080e7          	jalr	-1054(ra) # c80 <printf>
}
  a6:	70a2                	ld	ra,40(sp)
  a8:	7402                	ld	s0,32(sp)
  aa:	64e2                	ld	s1,24(sp)
  ac:	6942                	ld	s2,16(sp)
  ae:	69a2                	ld	s3,8(sp)
  b0:	6145                	addi	sp,sp,48
  b2:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
  b4:	055555b7          	lui	a1,0x5555
  b8:	55458593          	addi	a1,a1,1364 # 5555554 <base+0x554f544>
  bc:	00001517          	auipc	a0,0x1
  c0:	d8450513          	addi	a0,a0,-636 # e40 <malloc+0x102>
  c4:	00001097          	auipc	ra,0x1
  c8:	bbc080e7          	jalr	-1092(ra) # c80 <printf>
    exit(-1);
  cc:	557d                	li	a0,-1
  ce:	00001097          	auipc	ra,0x1
  d2:	83a080e7          	jalr	-1990(ra) # 908 <exit>
    printf("fork() failed\n");
  d6:	00001517          	auipc	a0,0x1
  da:	d8250513          	addi	a0,a0,-638 # e58 <malloc+0x11a>
  de:	00001097          	auipc	ra,0x1
  e2:	ba2080e7          	jalr	-1118(ra) # c80 <printf>
    exit(-1);
  e6:	557d                	li	a0,-1
  e8:	00001097          	auipc	ra,0x1
  ec:	820080e7          	jalr	-2016(ra) # 908 <exit>
  if (pid == 0) exit(0);
  f0:	00001097          	auipc	ra,0x1
  f4:	818080e7          	jalr	-2024(ra) # 908 <exit>
    printf("sbrk(-%d) failed\n", sz);
  f8:	055555b7          	lui	a1,0x5555
  fc:	55458593          	addi	a1,a1,1364 # 5555554 <base+0x554f544>
 100:	00001517          	auipc	a0,0x1
 104:	d6850513          	addi	a0,a0,-664 # e68 <malloc+0x12a>
 108:	00001097          	auipc	ra,0x1
 10c:	b78080e7          	jalr	-1160(ra) # c80 <printf>
    exit(-1);
 110:	557d                	li	a0,-1
 112:	00000097          	auipc	ra,0x0
 116:	7f6080e7          	jalr	2038(ra) # 908 <exit>

000000000000011a <threetest>:
void threetest() {
 11a:	7179                	addi	sp,sp,-48
 11c:	f406                	sd	ra,40(sp)
 11e:	f022                	sd	s0,32(sp)
 120:	ec26                	sd	s1,24(sp)
 122:	e84a                	sd	s2,16(sp)
 124:	e44e                	sd	s3,8(sp)
 126:	e052                	sd	s4,0(sp)
 128:	1800                	addi	s0,sp,48
  printf("three: ");
 12a:	00001517          	auipc	a0,0x1
 12e:	d5e50513          	addi	a0,a0,-674 # e88 <malloc+0x14a>
 132:	00001097          	auipc	ra,0x1
 136:	b4e080e7          	jalr	-1202(ra) # c80 <printf>
  char *p = sbrk(sz);
 13a:	02000537          	lui	a0,0x2000
 13e:	00001097          	auipc	ra,0x1
 142:	852080e7          	jalr	-1966(ra) # 990 <sbrk>
  if (p == (char *)0xffffffffffffffffL) {
 146:	57fd                	li	a5,-1
 148:	08f50763          	beq	a0,a5,1d6 <threetest+0xbc>
 14c:	84aa                	mv	s1,a0
  pid1 = fork();
 14e:	00000097          	auipc	ra,0x0
 152:	7b2080e7          	jalr	1970(ra) # 900 <fork>
  if (pid1 < 0) {
 156:	08054f63          	bltz	a0,1f4 <threetest+0xda>
  if (pid1 == 0) {
 15a:	c955                	beqz	a0,20e <threetest+0xf4>
  for (char *q = p; q < p + sz; q += 4096) {
 15c:	020009b7          	lui	s3,0x2000
 160:	99a6                	add	s3,s3,s1
 162:	8926                	mv	s2,s1
 164:	6a05                	lui	s4,0x1
    *(int *)q = getpid();
 166:	00001097          	auipc	ra,0x1
 16a:	822080e7          	jalr	-2014(ra) # 988 <getpid>
 16e:	00a92023          	sw	a0,0(s2) # 5556000 <base+0x554fff0>
  for (char *q = p; q < p + sz; q += 4096) {
 172:	9952                	add	s2,s2,s4
 174:	ff3919e3          	bne	s2,s3,166 <threetest+0x4c>
  wait(0);
 178:	4501                	li	a0,0
 17a:	00000097          	auipc	ra,0x0
 17e:	796080e7          	jalr	1942(ra) # 910 <wait>
  sleep(1);
 182:	4505                	li	a0,1
 184:	00001097          	auipc	ra,0x1
 188:	814080e7          	jalr	-2028(ra) # 998 <sleep>
  for (char *q = p; q < p + sz; q += 4096) {
 18c:	6a05                	lui	s4,0x1
    if (*(int *)q != getpid()) {
 18e:	0004a903          	lw	s2,0(s1)
 192:	00000097          	auipc	ra,0x0
 196:	7f6080e7          	jalr	2038(ra) # 988 <getpid>
 19a:	10a91a63          	bne	s2,a0,2ae <threetest+0x194>
  for (char *q = p; q < p + sz; q += 4096) {
 19e:	94d2                	add	s1,s1,s4
 1a0:	ff3497e3          	bne	s1,s3,18e <threetest+0x74>
  if (sbrk(-sz) == (char *)0xffffffffffffffffL) {
 1a4:	fe000537          	lui	a0,0xfe000
 1a8:	00000097          	auipc	ra,0x0
 1ac:	7e8080e7          	jalr	2024(ra) # 990 <sbrk>
 1b0:	57fd                	li	a5,-1
 1b2:	10f50b63          	beq	a0,a5,2c8 <threetest+0x1ae>
  printf("ok\n");
 1b6:	00001517          	auipc	a0,0x1
 1ba:	cca50513          	addi	a0,a0,-822 # e80 <malloc+0x142>
 1be:	00001097          	auipc	ra,0x1
 1c2:	ac2080e7          	jalr	-1342(ra) # c80 <printf>
}
 1c6:	70a2                	ld	ra,40(sp)
 1c8:	7402                	ld	s0,32(sp)
 1ca:	64e2                	ld	s1,24(sp)
 1cc:	6942                	ld	s2,16(sp)
 1ce:	69a2                	ld	s3,8(sp)
 1d0:	6a02                	ld	s4,0(sp)
 1d2:	6145                	addi	sp,sp,48
 1d4:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
 1d6:	020005b7          	lui	a1,0x2000
 1da:	00001517          	auipc	a0,0x1
 1de:	c6650513          	addi	a0,a0,-922 # e40 <malloc+0x102>
 1e2:	00001097          	auipc	ra,0x1
 1e6:	a9e080e7          	jalr	-1378(ra) # c80 <printf>
    exit(-1);
 1ea:	557d                	li	a0,-1
 1ec:	00000097          	auipc	ra,0x0
 1f0:	71c080e7          	jalr	1820(ra) # 908 <exit>
    printf("fork failed\n");
 1f4:	00001517          	auipc	a0,0x1
 1f8:	c9c50513          	addi	a0,a0,-868 # e90 <malloc+0x152>
 1fc:	00001097          	auipc	ra,0x1
 200:	a84080e7          	jalr	-1404(ra) # c80 <printf>
    exit(-1);
 204:	557d                	li	a0,-1
 206:	00000097          	auipc	ra,0x0
 20a:	702080e7          	jalr	1794(ra) # 908 <exit>
    pid2 = fork();
 20e:	00000097          	auipc	ra,0x0
 212:	6f2080e7          	jalr	1778(ra) # 900 <fork>
    if (pid2 < 0) {
 216:	04054263          	bltz	a0,25a <threetest+0x140>
    if (pid2 == 0) {
 21a:	ed29                	bnez	a0,274 <threetest+0x15a>
      for (char *q = p; q < p + (sz / 5) * 4; q += 4096) {
 21c:	0199a9b7          	lui	s3,0x199a
 220:	99a6                	add	s3,s3,s1
 222:	8926                	mv	s2,s1
 224:	6a05                	lui	s4,0x1
        *(int *)q = getpid();
 226:	00000097          	auipc	ra,0x0
 22a:	762080e7          	jalr	1890(ra) # 988 <getpid>
 22e:	00a92023          	sw	a0,0(s2)
      for (char *q = p; q < p + (sz / 5) * 4; q += 4096) {
 232:	9952                	add	s2,s2,s4
 234:	ff2999e3          	bne	s3,s2,226 <threetest+0x10c>
      for (char *q = p; q < p + (sz / 5) * 4; q += 4096) {
 238:	6a05                	lui	s4,0x1
        if (*(int *)q != getpid()) {
 23a:	0004a903          	lw	s2,0(s1)
 23e:	00000097          	auipc	ra,0x0
 242:	74a080e7          	jalr	1866(ra) # 988 <getpid>
 246:	04a91763          	bne	s2,a0,294 <threetest+0x17a>
      for (char *q = p; q < p + (sz / 5) * 4; q += 4096) {
 24a:	94d2                	add	s1,s1,s4
 24c:	fe9997e3          	bne	s3,s1,23a <threetest+0x120>
      exit(-1);
 250:	557d                	li	a0,-1
 252:	00000097          	auipc	ra,0x0
 256:	6b6080e7          	jalr	1718(ra) # 908 <exit>
      printf("fork failed");
 25a:	00001517          	auipc	a0,0x1
 25e:	c4650513          	addi	a0,a0,-954 # ea0 <malloc+0x162>
 262:	00001097          	auipc	ra,0x1
 266:	a1e080e7          	jalr	-1506(ra) # c80 <printf>
      exit(-1);
 26a:	557d                	li	a0,-1
 26c:	00000097          	auipc	ra,0x0
 270:	69c080e7          	jalr	1692(ra) # 908 <exit>
    for (char *q = p; q < p + (sz / 2); q += 4096) {
 274:	01000737          	lui	a4,0x1000
 278:	9726                	add	a4,a4,s1
      *(int *)q = 9999;
 27a:	6789                	lui	a5,0x2
 27c:	70f78793          	addi	a5,a5,1807 # 270f <junk3+0x6ff>
    for (char *q = p; q < p + (sz / 2); q += 4096) {
 280:	6685                	lui	a3,0x1
      *(int *)q = 9999;
 282:	c09c                	sw	a5,0(s1)
    for (char *q = p; q < p + (sz / 2); q += 4096) {
 284:	94b6                	add	s1,s1,a3
 286:	fee49ee3          	bne	s1,a4,282 <threetest+0x168>
    exit(0);
 28a:	4501                	li	a0,0
 28c:	00000097          	auipc	ra,0x0
 290:	67c080e7          	jalr	1660(ra) # 908 <exit>
          printf("wrong content\n");
 294:	00001517          	auipc	a0,0x1
 298:	c1c50513          	addi	a0,a0,-996 # eb0 <malloc+0x172>
 29c:	00001097          	auipc	ra,0x1
 2a0:	9e4080e7          	jalr	-1564(ra) # c80 <printf>
          exit(-1);
 2a4:	557d                	li	a0,-1
 2a6:	00000097          	auipc	ra,0x0
 2aa:	662080e7          	jalr	1634(ra) # 908 <exit>
      printf("wrong content\n");
 2ae:	00001517          	auipc	a0,0x1
 2b2:	c0250513          	addi	a0,a0,-1022 # eb0 <malloc+0x172>
 2b6:	00001097          	auipc	ra,0x1
 2ba:	9ca080e7          	jalr	-1590(ra) # c80 <printf>
      exit(-1);
 2be:	557d                	li	a0,-1
 2c0:	00000097          	auipc	ra,0x0
 2c4:	648080e7          	jalr	1608(ra) # 908 <exit>
    printf("sbrk(-%d) failed\n", sz);
 2c8:	020005b7          	lui	a1,0x2000
 2cc:	00001517          	auipc	a0,0x1
 2d0:	b9c50513          	addi	a0,a0,-1124 # e68 <malloc+0x12a>
 2d4:	00001097          	auipc	ra,0x1
 2d8:	9ac080e7          	jalr	-1620(ra) # c80 <printf>
    exit(-1);
 2dc:	557d                	li	a0,-1
 2de:	00000097          	auipc	ra,0x0
 2e2:	62a080e7          	jalr	1578(ra) # 908 <exit>

00000000000002e6 <filetest>:
void filetest() {
 2e6:	7179                	addi	sp,sp,-48
 2e8:	f406                	sd	ra,40(sp)
 2ea:	f022                	sd	s0,32(sp)
 2ec:	ec26                	sd	s1,24(sp)
 2ee:	e84a                	sd	s2,16(sp)
 2f0:	1800                	addi	s0,sp,48
  printf("file: ");
 2f2:	00001517          	auipc	a0,0x1
 2f6:	bce50513          	addi	a0,a0,-1074 # ec0 <malloc+0x182>
 2fa:	00001097          	auipc	ra,0x1
 2fe:	986080e7          	jalr	-1658(ra) # c80 <printf>
  buf[0] = 99;
 302:	06300793          	li	a5,99
 306:	00003717          	auipc	a4,0x3
 30a:	d0f70523          	sb	a5,-758(a4) # 3010 <buf>
  for (int i = 0; i < 4; i++) {
 30e:	fc042c23          	sw	zero,-40(s0)
    if (pipe(fds) != 0) {
 312:	00002497          	auipc	s1,0x2
 316:	cee48493          	addi	s1,s1,-786 # 2000 <fds>
  for (int i = 0; i < 4; i++) {
 31a:	490d                	li	s2,3
    if (pipe(fds) != 0) {
 31c:	8526                	mv	a0,s1
 31e:	00000097          	auipc	ra,0x0
 322:	5fa080e7          	jalr	1530(ra) # 918 <pipe>
 326:	e149                	bnez	a0,3a8 <filetest+0xc2>
    int pid = fork();
 328:	00000097          	auipc	ra,0x0
 32c:	5d8080e7          	jalr	1496(ra) # 900 <fork>
    if (pid < 0) {
 330:	08054963          	bltz	a0,3c2 <filetest+0xdc>
    if (pid == 0) {
 334:	c545                	beqz	a0,3dc <filetest+0xf6>
    if (write(fds[1], &i, sizeof(i)) != sizeof(i)) {
 336:	4611                	li	a2,4
 338:	fd840593          	addi	a1,s0,-40
 33c:	40c8                	lw	a0,4(s1)
 33e:	00000097          	auipc	ra,0x0
 342:	5ea080e7          	jalr	1514(ra) # 928 <write>
 346:	4791                	li	a5,4
 348:	10f51b63          	bne	a0,a5,45e <filetest+0x178>
  for (int i = 0; i < 4; i++) {
 34c:	fd842783          	lw	a5,-40(s0)
 350:	2785                	addiw	a5,a5,1
 352:	0007871b          	sext.w	a4,a5
 356:	fcf42c23          	sw	a5,-40(s0)
 35a:	fce951e3          	bge	s2,a4,31c <filetest+0x36>
  int xstatus = 0;
 35e:	fc042e23          	sw	zero,-36(s0)
 362:	4491                	li	s1,4
    wait(&xstatus);
 364:	fdc40513          	addi	a0,s0,-36
 368:	00000097          	auipc	ra,0x0
 36c:	5a8080e7          	jalr	1448(ra) # 910 <wait>
    if (xstatus != 0) {
 370:	fdc42783          	lw	a5,-36(s0)
 374:	10079263          	bnez	a5,478 <filetest+0x192>
  for (int i = 0; i < 4; i++) {
 378:	34fd                	addiw	s1,s1,-1
 37a:	f4ed                	bnez	s1,364 <filetest+0x7e>
  if (buf[0] != 99) {
 37c:	00003717          	auipc	a4,0x3
 380:	c9474703          	lbu	a4,-876(a4) # 3010 <buf>
 384:	06300793          	li	a5,99
 388:	0ef71d63          	bne	a4,a5,482 <filetest+0x19c>
  printf("ok\n");
 38c:	00001517          	auipc	a0,0x1
 390:	af450513          	addi	a0,a0,-1292 # e80 <malloc+0x142>
 394:	00001097          	auipc	ra,0x1
 398:	8ec080e7          	jalr	-1812(ra) # c80 <printf>
}
 39c:	70a2                	ld	ra,40(sp)
 39e:	7402                	ld	s0,32(sp)
 3a0:	64e2                	ld	s1,24(sp)
 3a2:	6942                	ld	s2,16(sp)
 3a4:	6145                	addi	sp,sp,48
 3a6:	8082                	ret
      printf("pipe() failed\n");
 3a8:	00001517          	auipc	a0,0x1
 3ac:	b2050513          	addi	a0,a0,-1248 # ec8 <malloc+0x18a>
 3b0:	00001097          	auipc	ra,0x1
 3b4:	8d0080e7          	jalr	-1840(ra) # c80 <printf>
      exit(-1);
 3b8:	557d                	li	a0,-1
 3ba:	00000097          	auipc	ra,0x0
 3be:	54e080e7          	jalr	1358(ra) # 908 <exit>
      printf("fork failed\n");
 3c2:	00001517          	auipc	a0,0x1
 3c6:	ace50513          	addi	a0,a0,-1330 # e90 <malloc+0x152>
 3ca:	00001097          	auipc	ra,0x1
 3ce:	8b6080e7          	jalr	-1866(ra) # c80 <printf>
      exit(-1);
 3d2:	557d                	li	a0,-1
 3d4:	00000097          	auipc	ra,0x0
 3d8:	534080e7          	jalr	1332(ra) # 908 <exit>
      sleep(1);
 3dc:	4505                	li	a0,1
 3de:	00000097          	auipc	ra,0x0
 3e2:	5ba080e7          	jalr	1466(ra) # 998 <sleep>
      if (read(fds[0], buf, sizeof(i)) != sizeof(i)) {
 3e6:	4611                	li	a2,4
 3e8:	00003597          	auipc	a1,0x3
 3ec:	c2858593          	addi	a1,a1,-984 # 3010 <buf>
 3f0:	00002517          	auipc	a0,0x2
 3f4:	c1052503          	lw	a0,-1008(a0) # 2000 <fds>
 3f8:	00000097          	auipc	ra,0x0
 3fc:	528080e7          	jalr	1320(ra) # 920 <read>
 400:	4791                	li	a5,4
 402:	02f51c63          	bne	a0,a5,43a <filetest+0x154>
      sleep(1);
 406:	4505                	li	a0,1
 408:	00000097          	auipc	ra,0x0
 40c:	590080e7          	jalr	1424(ra) # 998 <sleep>
      if (j != i) {
 410:	fd842703          	lw	a4,-40(s0)
 414:	00003797          	auipc	a5,0x3
 418:	bfc7a783          	lw	a5,-1028(a5) # 3010 <buf>
 41c:	02f70c63          	beq	a4,a5,454 <filetest+0x16e>
        printf("error: read the wrong value\n");
 420:	00001517          	auipc	a0,0x1
 424:	ad050513          	addi	a0,a0,-1328 # ef0 <malloc+0x1b2>
 428:	00001097          	auipc	ra,0x1
 42c:	858080e7          	jalr	-1960(ra) # c80 <printf>
        exit(1);
 430:	4505                	li	a0,1
 432:	00000097          	auipc	ra,0x0
 436:	4d6080e7          	jalr	1238(ra) # 908 <exit>
        printf("error: read failed\n");
 43a:	00001517          	auipc	a0,0x1
 43e:	a9e50513          	addi	a0,a0,-1378 # ed8 <malloc+0x19a>
 442:	00001097          	auipc	ra,0x1
 446:	83e080e7          	jalr	-1986(ra) # c80 <printf>
        exit(1);
 44a:	4505                	li	a0,1
 44c:	00000097          	auipc	ra,0x0
 450:	4bc080e7          	jalr	1212(ra) # 908 <exit>
      exit(0);
 454:	4501                	li	a0,0
 456:	00000097          	auipc	ra,0x0
 45a:	4b2080e7          	jalr	1202(ra) # 908 <exit>
      printf("error: write failed\n");
 45e:	00001517          	auipc	a0,0x1
 462:	ab250513          	addi	a0,a0,-1358 # f10 <malloc+0x1d2>
 466:	00001097          	auipc	ra,0x1
 46a:	81a080e7          	jalr	-2022(ra) # c80 <printf>
      exit(-1);
 46e:	557d                	li	a0,-1
 470:	00000097          	auipc	ra,0x0
 474:	498080e7          	jalr	1176(ra) # 908 <exit>
      exit(1);
 478:	4505                	li	a0,1
 47a:	00000097          	auipc	ra,0x0
 47e:	48e080e7          	jalr	1166(ra) # 908 <exit>
    printf("error: child overwrote parent\n");
 482:	00001517          	auipc	a0,0x1
 486:	aa650513          	addi	a0,a0,-1370 # f28 <malloc+0x1ea>
 48a:	00000097          	auipc	ra,0x0
 48e:	7f6080e7          	jalr	2038(ra) # c80 <printf>
    exit(1);
 492:	4505                	li	a0,1
 494:	00000097          	auipc	ra,0x0
 498:	474080e7          	jalr	1140(ra) # 908 <exit>

000000000000049c <rotest>:

typedef void (*func)();

// Checks that PTE access flags are not overwritten with incorrect values.
void rotest() {
 49c:	7179                	addi	sp,sp,-48
 49e:	f406                	sd	ra,40(sp)
 4a0:	f022                	sd	s0,32(sp)
 4a2:	ec26                	sd	s1,24(sp)
 4a4:	1800                	addi	s0,sp,48
  printf("ro: ");
 4a6:	00001517          	auipc	a0,0x1
 4aa:	aa250513          	addi	a0,a0,-1374 # f48 <malloc+0x20a>
 4ae:	00000097          	auipc	ra,0x0
 4b2:	7d2080e7          	jalr	2002(ra) # c80 <printf>

  int pid1 = fork();
 4b6:	00000097          	auipc	ra,0x0
 4ba:	44a080e7          	jalr	1098(ra) # 900 <fork>

  if (pid1 > 0) {
 4be:	0aa05663          	blez	a0,56a <rotest+0xce>
 4c2:	84aa                	mv	s1,a0
    int xstatus;
    if (wait(&xstatus) != pid1) {
 4c4:	fdc40513          	addi	a0,s0,-36
 4c8:	00000097          	auipc	ra,0x0
 4cc:	448080e7          	jalr	1096(ra) # 910 <wait>
 4d0:	02951963          	bne	a0,s1,502 <rotest+0x66>
      printf("error: first child not found\n");
      exit(1);
    }

    if (xstatus == 123) {
 4d4:	fdc42783          	lw	a5,-36(s0)
 4d8:	07b00713          	li	a4,123
 4dc:	04e78063          	beq	a5,a4,51c <rotest+0x80>
      printf("error: parent memory corrupted\n");
      exit(1);
    } else if (xstatus == 1) {
 4e0:	4705                	li	a4,1
 4e2:	04e78a63          	beq	a5,a4,536 <rotest+0x9a>
      printf("failed\n");
      exit(1);
    } else if (xstatus != 0) {
 4e6:	e7ad                	bnez	a5,550 <rotest+0xb4>
      printf("error: unexpected first child exit code %d\n");
      exit(1);
    }

    printf("ok\n");
 4e8:	00001517          	auipc	a0,0x1
 4ec:	99850513          	addi	a0,a0,-1640 # e80 <malloc+0x142>
 4f0:	00000097          	auipc	ra,0x0
 4f4:	790080e7          	jalr	1936(ra) # c80 <printf>

  memmove(rotest_victim, HACK, sizeof(HACK));
  rotest_victim();

  exit(0);
}
 4f8:	70a2                	ld	ra,40(sp)
 4fa:	7402                	ld	s0,32(sp)
 4fc:	64e2                	ld	s1,24(sp)
 4fe:	6145                	addi	sp,sp,48
 500:	8082                	ret
      printf("error: first child not found\n");
 502:	00001517          	auipc	a0,0x1
 506:	a4e50513          	addi	a0,a0,-1458 # f50 <malloc+0x212>
 50a:	00000097          	auipc	ra,0x0
 50e:	776080e7          	jalr	1910(ra) # c80 <printf>
      exit(1);
 512:	4505                	li	a0,1
 514:	00000097          	auipc	ra,0x0
 518:	3f4080e7          	jalr	1012(ra) # 908 <exit>
      printf("error: parent memory corrupted\n");
 51c:	00001517          	auipc	a0,0x1
 520:	a5450513          	addi	a0,a0,-1452 # f70 <malloc+0x232>
 524:	00000097          	auipc	ra,0x0
 528:	75c080e7          	jalr	1884(ra) # c80 <printf>
      exit(1);
 52c:	4505                	li	a0,1
 52e:	00000097          	auipc	ra,0x0
 532:	3da080e7          	jalr	986(ra) # 908 <exit>
      printf("failed\n");
 536:	00001517          	auipc	a0,0x1
 53a:	a5a50513          	addi	a0,a0,-1446 # f90 <malloc+0x252>
 53e:	00000097          	auipc	ra,0x0
 542:	742080e7          	jalr	1858(ra) # c80 <printf>
      exit(1);
 546:	4505                	li	a0,1
 548:	00000097          	auipc	ra,0x0
 54c:	3c0080e7          	jalr	960(ra) # 908 <exit>
      printf("error: unexpected first child exit code %d\n");
 550:	00001517          	auipc	a0,0x1
 554:	a4850513          	addi	a0,a0,-1464 # f98 <malloc+0x25a>
 558:	00000097          	auipc	ra,0x0
 55c:	728080e7          	jalr	1832(ra) # c80 <printf>
      exit(1);
 560:	4505                	li	a0,1
 562:	00000097          	auipc	ra,0x0
 566:	3a6080e7          	jalr	934(ra) # 908 <exit>
  int pid2 = fork();
 56a:	00000097          	auipc	ra,0x0
 56e:	396080e7          	jalr	918(ra) # 900 <fork>
 572:	84aa                	mv	s1,a0
  if (pid2 > 0) {
 574:	08a05363          	blez	a0,5fa <rotest+0x15e>
    if (wait(&xstatus) != pid2) {
 578:	fdc40513          	addi	a0,s0,-36
 57c:	00000097          	auipc	ra,0x0
 580:	394080e7          	jalr	916(ra) # 910 <wait>
 584:	02951c63          	bne	a0,s1,5bc <rotest+0x120>
    rotest_victim();
 588:	00000097          	auipc	ra,0x0
 58c:	a78080e7          	jalr	-1416(ra) # 0 <rotest_victim>
    if (xstatus == 123) {
 590:	fdc42583          	lw	a1,-36(s0)
 594:	07b00793          	li	a5,123
 598:	02f58f63          	beq	a1,a5,5d6 <rotest+0x13a>
    } else if (xstatus != -1) {
 59c:	57fd                	li	a5,-1
 59e:	04f58963          	beq	a1,a5,5f0 <rotest+0x154>
      printf("error: unexpected second child exit code %d\n", xstatus);
 5a2:	00001517          	auipc	a0,0x1
 5a6:	a6650513          	addi	a0,a0,-1434 # 1008 <malloc+0x2ca>
 5aa:	00000097          	auipc	ra,0x0
 5ae:	6d6080e7          	jalr	1750(ra) # c80 <printf>
      exit(1);
 5b2:	4505                	li	a0,1
 5b4:	00000097          	auipc	ra,0x0
 5b8:	354080e7          	jalr	852(ra) # 908 <exit>
      printf("error: second child not found\n");
 5bc:	00001517          	auipc	a0,0x1
 5c0:	a0c50513          	addi	a0,a0,-1524 # fc8 <malloc+0x28a>
 5c4:	00000097          	auipc	ra,0x0
 5c8:	6bc080e7          	jalr	1724(ra) # c80 <printf>
      exit(1);
 5cc:	4505                	li	a0,1
 5ce:	00000097          	auipc	ra,0x0
 5d2:	33a080e7          	jalr	826(ra) # 908 <exit>
      printf("error: self memory corrupted\n");
 5d6:	00001517          	auipc	a0,0x1
 5da:	a1250513          	addi	a0,a0,-1518 # fe8 <malloc+0x2aa>
 5de:	00000097          	auipc	ra,0x0
 5e2:	6a2080e7          	jalr	1698(ra) # c80 <printf>
      exit(1);
 5e6:	4505                	li	a0,1
 5e8:	00000097          	auipc	ra,0x0
 5ec:	320080e7          	jalr	800(ra) # 908 <exit>
    exit(0);
 5f0:	4501                	li	a0,0
 5f2:	00000097          	auipc	ra,0x0
 5f6:	316080e7          	jalr	790(ra) # 908 <exit>
  memmove(rotest_victim, HACK, sizeof(HACK));
 5fa:	4629                	li	a2,10
 5fc:	00001597          	auipc	a1,0x1
 600:	a5458593          	addi	a1,a1,-1452 # 1050 <HACK>
 604:	00000517          	auipc	a0,0x0
 608:	9fc50513          	addi	a0,a0,-1540 # 0 <rotest_victim>
 60c:	00000097          	auipc	ra,0x0
 610:	24a080e7          	jalr	586(ra) # 856 <memmove>
  rotest_victim();
 614:	00000097          	auipc	ra,0x0
 618:	9ec080e7          	jalr	-1556(ra) # 0 <rotest_victim>
  exit(0);
 61c:	4501                	li	a0,0
 61e:	00000097          	auipc	ra,0x0
 622:	2ea080e7          	jalr	746(ra) # 908 <exit>

0000000000000626 <main>:

int main(int argc, char *argv[]) {
 626:	1141                	addi	sp,sp,-16
 628:	e406                	sd	ra,8(sp)
 62a:	e022                	sd	s0,0(sp)
 62c:	0800                	addi	s0,sp,16
  simpletest();
 62e:	00000097          	auipc	ra,0x0
 632:	9ec080e7          	jalr	-1556(ra) # 1a <simpletest>

  // check that the first simpletest() freed the physical memory.
  simpletest();
 636:	00000097          	auipc	ra,0x0
 63a:	9e4080e7          	jalr	-1564(ra) # 1a <simpletest>

  threetest();
 63e:	00000097          	auipc	ra,0x0
 642:	adc080e7          	jalr	-1316(ra) # 11a <threetest>
  threetest();
 646:	00000097          	auipc	ra,0x0
 64a:	ad4080e7          	jalr	-1324(ra) # 11a <threetest>
  threetest();
 64e:	00000097          	auipc	ra,0x0
 652:	acc080e7          	jalr	-1332(ra) # 11a <threetest>

  filetest();
 656:	00000097          	auipc	ra,0x0
 65a:	c90080e7          	jalr	-880(ra) # 2e6 <filetest>

  rotest();
 65e:	00000097          	auipc	ra,0x0
 662:	e3e080e7          	jalr	-450(ra) # 49c <rotest>

  printf("ALL COW TESTS PASSED\n");
 666:	00001517          	auipc	a0,0x1
 66a:	9d250513          	addi	a0,a0,-1582 # 1038 <malloc+0x2fa>
 66e:	00000097          	auipc	ra,0x0
 672:	612080e7          	jalr	1554(ra) # c80 <printf>

  exit(0);
 676:	4501                	li	a0,0
 678:	00000097          	auipc	ra,0x0
 67c:	290080e7          	jalr	656(ra) # 908 <exit>

0000000000000680 <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
 680:	1141                	addi	sp,sp,-16
 682:	e406                	sd	ra,8(sp)
 684:	e022                	sd	s0,0(sp)
 686:	0800                	addi	s0,sp,16
  extern int main();
  main();
 688:	00000097          	auipc	ra,0x0
 68c:	f9e080e7          	jalr	-98(ra) # 626 <main>
  exit(0);
 690:	4501                	li	a0,0
 692:	00000097          	auipc	ra,0x0
 696:	276080e7          	jalr	630(ra) # 908 <exit>

000000000000069a <strcpy>:
}

char *strcpy(char *s, const char *t) {
 69a:	1141                	addi	sp,sp,-16
 69c:	e422                	sd	s0,8(sp)
 69e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 6a0:	87aa                	mv	a5,a0
 6a2:	0585                	addi	a1,a1,1
 6a4:	0785                	addi	a5,a5,1
 6a6:	fff5c703          	lbu	a4,-1(a1)
 6aa:	fee78fa3          	sb	a4,-1(a5)
 6ae:	fb75                	bnez	a4,6a2 <strcpy+0x8>
    ;
  return os;
}
 6b0:	6422                	ld	s0,8(sp)
 6b2:	0141                	addi	sp,sp,16
 6b4:	8082                	ret

00000000000006b6 <strcmp>:

int strcmp(const char *p, const char *q) {
 6b6:	1141                	addi	sp,sp,-16
 6b8:	e422                	sd	s0,8(sp)
 6ba:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
 6bc:	00054783          	lbu	a5,0(a0)
 6c0:	cb91                	beqz	a5,6d4 <strcmp+0x1e>
 6c2:	0005c703          	lbu	a4,0(a1)
 6c6:	00f71763          	bne	a4,a5,6d4 <strcmp+0x1e>
 6ca:	0505                	addi	a0,a0,1
 6cc:	0585                	addi	a1,a1,1
 6ce:	00054783          	lbu	a5,0(a0)
 6d2:	fbe5                	bnez	a5,6c2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 6d4:	0005c503          	lbu	a0,0(a1)
}
 6d8:	40a7853b          	subw	a0,a5,a0
 6dc:	6422                	ld	s0,8(sp)
 6de:	0141                	addi	sp,sp,16
 6e0:	8082                	ret

00000000000006e2 <strlen>:

uint strlen(const char *s) {
 6e2:	1141                	addi	sp,sp,-16
 6e4:	e422                	sd	s0,8(sp)
 6e6:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 6e8:	00054783          	lbu	a5,0(a0)
 6ec:	cf91                	beqz	a5,708 <strlen+0x26>
 6ee:	0505                	addi	a0,a0,1
 6f0:	87aa                	mv	a5,a0
 6f2:	4685                	li	a3,1
 6f4:	9e89                	subw	a3,a3,a0
 6f6:	00f6853b          	addw	a0,a3,a5
 6fa:	0785                	addi	a5,a5,1
 6fc:	fff7c703          	lbu	a4,-1(a5)
 700:	fb7d                	bnez	a4,6f6 <strlen+0x14>
    ;
  return n;
}
 702:	6422                	ld	s0,8(sp)
 704:	0141                	addi	sp,sp,16
 706:	8082                	ret
  for (n = 0; s[n]; n++)
 708:	4501                	li	a0,0
 70a:	bfe5                	j	702 <strlen+0x20>

000000000000070c <memset>:

void *memset(void *dst, int c, uint n) {
 70c:	1141                	addi	sp,sp,-16
 70e:	e422                	sd	s0,8(sp)
 710:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 712:	ca19                	beqz	a2,728 <memset+0x1c>
 714:	87aa                	mv	a5,a0
 716:	1602                	slli	a2,a2,0x20
 718:	9201                	srli	a2,a2,0x20
 71a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 71e:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 722:	0785                	addi	a5,a5,1
 724:	fee79de3          	bne	a5,a4,71e <memset+0x12>
  }
  return dst;
}
 728:	6422                	ld	s0,8(sp)
 72a:	0141                	addi	sp,sp,16
 72c:	8082                	ret

000000000000072e <strchr>:

char *strchr(const char *s, char c) {
 72e:	1141                	addi	sp,sp,-16
 730:	e422                	sd	s0,8(sp)
 732:	0800                	addi	s0,sp,16
  for (; *s; s++)
 734:	00054783          	lbu	a5,0(a0)
 738:	cb99                	beqz	a5,74e <strchr+0x20>
    if (*s == c) return (char *)s;
 73a:	00f58763          	beq	a1,a5,748 <strchr+0x1a>
  for (; *s; s++)
 73e:	0505                	addi	a0,a0,1
 740:	00054783          	lbu	a5,0(a0)
 744:	fbfd                	bnez	a5,73a <strchr+0xc>
  return 0;
 746:	4501                	li	a0,0
}
 748:	6422                	ld	s0,8(sp)
 74a:	0141                	addi	sp,sp,16
 74c:	8082                	ret
  return 0;
 74e:	4501                	li	a0,0
 750:	bfe5                	j	748 <strchr+0x1a>

0000000000000752 <gets>:

char *gets(char *buf, int max) {
 752:	711d                	addi	sp,sp,-96
 754:	ec86                	sd	ra,88(sp)
 756:	e8a2                	sd	s0,80(sp)
 758:	e4a6                	sd	s1,72(sp)
 75a:	e0ca                	sd	s2,64(sp)
 75c:	fc4e                	sd	s3,56(sp)
 75e:	f852                	sd	s4,48(sp)
 760:	f456                	sd	s5,40(sp)
 762:	f05a                	sd	s6,32(sp)
 764:	ec5e                	sd	s7,24(sp)
 766:	1080                	addi	s0,sp,96
 768:	8baa                	mv	s7,a0
 76a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 76c:	892a                	mv	s2,a0
 76e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
 770:	4aa9                	li	s5,10
 772:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 774:	89a6                	mv	s3,s1
 776:	2485                	addiw	s1,s1,1
 778:	0344d863          	bge	s1,s4,7a8 <gets+0x56>
    cc = read(0, &c, 1);
 77c:	4605                	li	a2,1
 77e:	faf40593          	addi	a1,s0,-81
 782:	4501                	li	a0,0
 784:	00000097          	auipc	ra,0x0
 788:	19c080e7          	jalr	412(ra) # 920 <read>
    if (cc < 1) break;
 78c:	00a05e63          	blez	a0,7a8 <gets+0x56>
    buf[i++] = c;
 790:	faf44783          	lbu	a5,-81(s0)
 794:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r') break;
 798:	01578763          	beq	a5,s5,7a6 <gets+0x54>
 79c:	0905                	addi	s2,s2,1
 79e:	fd679be3          	bne	a5,s6,774 <gets+0x22>
  for (i = 0; i + 1 < max;) {
 7a2:	89a6                	mv	s3,s1
 7a4:	a011                	j	7a8 <gets+0x56>
 7a6:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
 7a8:	99de                	add	s3,s3,s7
 7aa:	00098023          	sb	zero,0(s3) # 199a000 <base+0x1993ff0>
  return buf;
}
 7ae:	855e                	mv	a0,s7
 7b0:	60e6                	ld	ra,88(sp)
 7b2:	6446                	ld	s0,80(sp)
 7b4:	64a6                	ld	s1,72(sp)
 7b6:	6906                	ld	s2,64(sp)
 7b8:	79e2                	ld	s3,56(sp)
 7ba:	7a42                	ld	s4,48(sp)
 7bc:	7aa2                	ld	s5,40(sp)
 7be:	7b02                	ld	s6,32(sp)
 7c0:	6be2                	ld	s7,24(sp)
 7c2:	6125                	addi	sp,sp,96
 7c4:	8082                	ret

00000000000007c6 <stat>:

int stat(const char *n, struct stat *st) {
 7c6:	1101                	addi	sp,sp,-32
 7c8:	ec06                	sd	ra,24(sp)
 7ca:	e822                	sd	s0,16(sp)
 7cc:	e426                	sd	s1,8(sp)
 7ce:	e04a                	sd	s2,0(sp)
 7d0:	1000                	addi	s0,sp,32
 7d2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 7d4:	4581                	li	a1,0
 7d6:	00000097          	auipc	ra,0x0
 7da:	172080e7          	jalr	370(ra) # 948 <open>
  if (fd < 0) return -1;
 7de:	02054563          	bltz	a0,808 <stat+0x42>
 7e2:	84aa                	mv	s1,a0
  r = fstat(fd, st);
 7e4:	85ca                	mv	a1,s2
 7e6:	00000097          	auipc	ra,0x0
 7ea:	17a080e7          	jalr	378(ra) # 960 <fstat>
 7ee:	892a                	mv	s2,a0
  close(fd);
 7f0:	8526                	mv	a0,s1
 7f2:	00000097          	auipc	ra,0x0
 7f6:	13e080e7          	jalr	318(ra) # 930 <close>
  return r;
}
 7fa:	854a                	mv	a0,s2
 7fc:	60e2                	ld	ra,24(sp)
 7fe:	6442                	ld	s0,16(sp)
 800:	64a2                	ld	s1,8(sp)
 802:	6902                	ld	s2,0(sp)
 804:	6105                	addi	sp,sp,32
 806:	8082                	ret
  if (fd < 0) return -1;
 808:	597d                	li	s2,-1
 80a:	bfc5                	j	7fa <stat+0x34>

000000000000080c <atoi>:

int atoi(const char *s) {
 80c:	1141                	addi	sp,sp,-16
 80e:	e422                	sd	s0,8(sp)
 810:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 812:	00054603          	lbu	a2,0(a0)
 816:	fd06079b          	addiw	a5,a2,-48
 81a:	0ff7f793          	andi	a5,a5,255
 81e:	4725                	li	a4,9
 820:	02f76963          	bltu	a4,a5,852 <atoi+0x46>
 824:	86aa                	mv	a3,a0
  n = 0;
 826:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 828:	45a5                	li	a1,9
 82a:	0685                	addi	a3,a3,1
 82c:	0025179b          	slliw	a5,a0,0x2
 830:	9fa9                	addw	a5,a5,a0
 832:	0017979b          	slliw	a5,a5,0x1
 836:	9fb1                	addw	a5,a5,a2
 838:	fd07851b          	addiw	a0,a5,-48
 83c:	0006c603          	lbu	a2,0(a3) # 1000 <malloc+0x2c2>
 840:	fd06071b          	addiw	a4,a2,-48
 844:	0ff77713          	andi	a4,a4,255
 848:	fee5f1e3          	bgeu	a1,a4,82a <atoi+0x1e>
  return n;
}
 84c:	6422                	ld	s0,8(sp)
 84e:	0141                	addi	sp,sp,16
 850:	8082                	ret
  n = 0;
 852:	4501                	li	a0,0
 854:	bfe5                	j	84c <atoi+0x40>

0000000000000856 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
 856:	1141                	addi	sp,sp,-16
 858:	e422                	sd	s0,8(sp)
 85a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 85c:	02b57463          	bgeu	a0,a1,884 <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
 860:	00c05f63          	blez	a2,87e <memmove+0x28>
 864:	1602                	slli	a2,a2,0x20
 866:	9201                	srli	a2,a2,0x20
 868:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 86c:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
 86e:	0585                	addi	a1,a1,1
 870:	0705                	addi	a4,a4,1
 872:	fff5c683          	lbu	a3,-1(a1)
 876:	fed70fa3          	sb	a3,-1(a4)
 87a:	fee79ae3          	bne	a5,a4,86e <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
 87e:	6422                	ld	s0,8(sp)
 880:	0141                	addi	sp,sp,16
 882:	8082                	ret
    dst += n;
 884:	00c50733          	add	a4,a0,a2
    src += n;
 888:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
 88a:	fec05ae3          	blez	a2,87e <memmove+0x28>
 88e:	fff6079b          	addiw	a5,a2,-1
 892:	1782                	slli	a5,a5,0x20
 894:	9381                	srli	a5,a5,0x20
 896:	fff7c793          	not	a5,a5
 89a:	97ba                	add	a5,a5,a4
 89c:	15fd                	addi	a1,a1,-1
 89e:	177d                	addi	a4,a4,-1
 8a0:	0005c683          	lbu	a3,0(a1)
 8a4:	00d70023          	sb	a3,0(a4)
 8a8:	fee79ae3          	bne	a5,a4,89c <memmove+0x46>
 8ac:	bfc9                	j	87e <memmove+0x28>

00000000000008ae <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
 8ae:	1141                	addi	sp,sp,-16
 8b0:	e422                	sd	s0,8(sp)
 8b2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 8b4:	ca05                	beqz	a2,8e4 <memcmp+0x36>
 8b6:	fff6069b          	addiw	a3,a2,-1
 8ba:	1682                	slli	a3,a3,0x20
 8bc:	9281                	srli	a3,a3,0x20
 8be:	0685                	addi	a3,a3,1
 8c0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 8c2:	00054783          	lbu	a5,0(a0)
 8c6:	0005c703          	lbu	a4,0(a1)
 8ca:	00e79863          	bne	a5,a4,8da <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 8ce:	0505                	addi	a0,a0,1
    p2++;
 8d0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 8d2:	fed518e3          	bne	a0,a3,8c2 <memcmp+0x14>
  }
  return 0;
 8d6:	4501                	li	a0,0
 8d8:	a019                	j	8de <memcmp+0x30>
      return *p1 - *p2;
 8da:	40e7853b          	subw	a0,a5,a4
}
 8de:	6422                	ld	s0,8(sp)
 8e0:	0141                	addi	sp,sp,16
 8e2:	8082                	ret
  return 0;
 8e4:	4501                	li	a0,0
 8e6:	bfe5                	j	8de <memcmp+0x30>

00000000000008e8 <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
 8e8:	1141                	addi	sp,sp,-16
 8ea:	e406                	sd	ra,8(sp)
 8ec:	e022                	sd	s0,0(sp)
 8ee:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 8f0:	00000097          	auipc	ra,0x0
 8f4:	f66080e7          	jalr	-154(ra) # 856 <memmove>
}
 8f8:	60a2                	ld	ra,8(sp)
 8fa:	6402                	ld	s0,0(sp)
 8fc:	0141                	addi	sp,sp,16
 8fe:	8082                	ret

0000000000000900 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 900:	4885                	li	a7,1
 ecall
 902:	00000073          	ecall
 ret
 906:	8082                	ret

0000000000000908 <exit>:
.global exit
exit:
 li a7, SYS_exit
 908:	4889                	li	a7,2
 ecall
 90a:	00000073          	ecall
 ret
 90e:	8082                	ret

0000000000000910 <wait>:
.global wait
wait:
 li a7, SYS_wait
 910:	488d                	li	a7,3
 ecall
 912:	00000073          	ecall
 ret
 916:	8082                	ret

0000000000000918 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 918:	4891                	li	a7,4
 ecall
 91a:	00000073          	ecall
 ret
 91e:	8082                	ret

0000000000000920 <read>:
.global read
read:
 li a7, SYS_read
 920:	4895                	li	a7,5
 ecall
 922:	00000073          	ecall
 ret
 926:	8082                	ret

0000000000000928 <write>:
.global write
write:
 li a7, SYS_write
 928:	48c1                	li	a7,16
 ecall
 92a:	00000073          	ecall
 ret
 92e:	8082                	ret

0000000000000930 <close>:
.global close
close:
 li a7, SYS_close
 930:	48d5                	li	a7,21
 ecall
 932:	00000073          	ecall
 ret
 936:	8082                	ret

0000000000000938 <kill>:
.global kill
kill:
 li a7, SYS_kill
 938:	4899                	li	a7,6
 ecall
 93a:	00000073          	ecall
 ret
 93e:	8082                	ret

0000000000000940 <exec>:
.global exec
exec:
 li a7, SYS_exec
 940:	489d                	li	a7,7
 ecall
 942:	00000073          	ecall
 ret
 946:	8082                	ret

0000000000000948 <open>:
.global open
open:
 li a7, SYS_open
 948:	48bd                	li	a7,15
 ecall
 94a:	00000073          	ecall
 ret
 94e:	8082                	ret

0000000000000950 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 950:	48c5                	li	a7,17
 ecall
 952:	00000073          	ecall
 ret
 956:	8082                	ret

0000000000000958 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 958:	48c9                	li	a7,18
 ecall
 95a:	00000073          	ecall
 ret
 95e:	8082                	ret

0000000000000960 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 960:	48a1                	li	a7,8
 ecall
 962:	00000073          	ecall
 ret
 966:	8082                	ret

0000000000000968 <link>:
.global link
link:
 li a7, SYS_link
 968:	48cd                	li	a7,19
 ecall
 96a:	00000073          	ecall
 ret
 96e:	8082                	ret

0000000000000970 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 970:	48d1                	li	a7,20
 ecall
 972:	00000073          	ecall
 ret
 976:	8082                	ret

0000000000000978 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 978:	48a5                	li	a7,9
 ecall
 97a:	00000073          	ecall
 ret
 97e:	8082                	ret

0000000000000980 <dup>:
.global dup
dup:
 li a7, SYS_dup
 980:	48a9                	li	a7,10
 ecall
 982:	00000073          	ecall
 ret
 986:	8082                	ret

0000000000000988 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 988:	48ad                	li	a7,11
 ecall
 98a:	00000073          	ecall
 ret
 98e:	8082                	ret

0000000000000990 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 990:	48b1                	li	a7,12
 ecall
 992:	00000073          	ecall
 ret
 996:	8082                	ret

0000000000000998 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 998:	48b5                	li	a7,13
 ecall
 99a:	00000073          	ecall
 ret
 99e:	8082                	ret

00000000000009a0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 9a0:	48b9                	li	a7,14
 ecall
 9a2:	00000073          	ecall
 ret
 9a6:	8082                	ret

00000000000009a8 <putc>:
#include "kernel/types.h"
#include "user/user.h"

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 9a8:	1101                	addi	sp,sp,-32
 9aa:	ec06                	sd	ra,24(sp)
 9ac:	e822                	sd	s0,16(sp)
 9ae:	1000                	addi	s0,sp,32
 9b0:	feb407a3          	sb	a1,-17(s0)
 9b4:	4605                	li	a2,1
 9b6:	fef40593          	addi	a1,s0,-17
 9ba:	00000097          	auipc	ra,0x0
 9be:	f6e080e7          	jalr	-146(ra) # 928 <write>
 9c2:	60e2                	ld	ra,24(sp)
 9c4:	6442                	ld	s0,16(sp)
 9c6:	6105                	addi	sp,sp,32
 9c8:	8082                	ret

00000000000009ca <printint>:

static void printint(int fd, int xx, int base, int sgn) {
 9ca:	7139                	addi	sp,sp,-64
 9cc:	fc06                	sd	ra,56(sp)
 9ce:	f822                	sd	s0,48(sp)
 9d0:	f426                	sd	s1,40(sp)
 9d2:	f04a                	sd	s2,32(sp)
 9d4:	ec4e                	sd	s3,24(sp)
 9d6:	0080                	addi	s0,sp,64
 9d8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0) {
 9da:	c299                	beqz	a3,9e0 <printint+0x16>
 9dc:	0805c863          	bltz	a1,a6c <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 9e0:	2581                	sext.w	a1,a1
  neg = 0;
 9e2:	4881                	li	a7,0
 9e4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 9e8:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 9ea:	2601                	sext.w	a2,a2
 9ec:	00000517          	auipc	a0,0x0
 9f0:	67c50513          	addi	a0,a0,1660 # 1068 <digits>
 9f4:	883a                	mv	a6,a4
 9f6:	2705                	addiw	a4,a4,1
 9f8:	02c5f7bb          	remuw	a5,a1,a2
 9fc:	1782                	slli	a5,a5,0x20
 9fe:	9381                	srli	a5,a5,0x20
 a00:	97aa                	add	a5,a5,a0
 a02:	0007c783          	lbu	a5,0(a5)
 a06:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 a0a:	0005879b          	sext.w	a5,a1
 a0e:	02c5d5bb          	divuw	a1,a1,a2
 a12:	0685                	addi	a3,a3,1
 a14:	fec7f0e3          	bgeu	a5,a2,9f4 <printint+0x2a>
  if (neg) buf[i++] = '-';
 a18:	00088b63          	beqz	a7,a2e <printint+0x64>
 a1c:	fd040793          	addi	a5,s0,-48
 a20:	973e                	add	a4,a4,a5
 a22:	02d00793          	li	a5,45
 a26:	fef70823          	sb	a5,-16(a4)
 a2a:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) putc(fd, buf[i]);
 a2e:	02e05863          	blez	a4,a5e <printint+0x94>
 a32:	fc040793          	addi	a5,s0,-64
 a36:	00e78933          	add	s2,a5,a4
 a3a:	fff78993          	addi	s3,a5,-1
 a3e:	99ba                	add	s3,s3,a4
 a40:	377d                	addiw	a4,a4,-1
 a42:	1702                	slli	a4,a4,0x20
 a44:	9301                	srli	a4,a4,0x20
 a46:	40e989b3          	sub	s3,s3,a4
 a4a:	fff94583          	lbu	a1,-1(s2)
 a4e:	8526                	mv	a0,s1
 a50:	00000097          	auipc	ra,0x0
 a54:	f58080e7          	jalr	-168(ra) # 9a8 <putc>
 a58:	197d                	addi	s2,s2,-1
 a5a:	ff3918e3          	bne	s2,s3,a4a <printint+0x80>
}
 a5e:	70e2                	ld	ra,56(sp)
 a60:	7442                	ld	s0,48(sp)
 a62:	74a2                	ld	s1,40(sp)
 a64:	7902                	ld	s2,32(sp)
 a66:	69e2                	ld	s3,24(sp)
 a68:	6121                	addi	sp,sp,64
 a6a:	8082                	ret
    x = -xx;
 a6c:	40b005bb          	negw	a1,a1
    neg = 1;
 a70:	4885                	li	a7,1
    x = -xx;
 a72:	bf8d                	j	9e4 <printint+0x1a>

0000000000000a74 <vprintf>:
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap) {
 a74:	7119                	addi	sp,sp,-128
 a76:	fc86                	sd	ra,120(sp)
 a78:	f8a2                	sd	s0,112(sp)
 a7a:	f4a6                	sd	s1,104(sp)
 a7c:	f0ca                	sd	s2,96(sp)
 a7e:	ecce                	sd	s3,88(sp)
 a80:	e8d2                	sd	s4,80(sp)
 a82:	e4d6                	sd	s5,72(sp)
 a84:	e0da                	sd	s6,64(sp)
 a86:	fc5e                	sd	s7,56(sp)
 a88:	f862                	sd	s8,48(sp)
 a8a:	f466                	sd	s9,40(sp)
 a8c:	f06a                	sd	s10,32(sp)
 a8e:	ec6e                	sd	s11,24(sp)
 a90:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 a92:	0005c903          	lbu	s2,0(a1)
 a96:	18090f63          	beqz	s2,c34 <vprintf+0x1c0>
 a9a:	8aaa                	mv	s5,a0
 a9c:	8b32                	mv	s6,a2
 a9e:	00158493          	addi	s1,a1,1
  state = 0;
 aa2:	4981                	li	s3,0
      if (c == '%') {
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if (state == '%') {
 aa4:	02500a13          	li	s4,37
      if (c == 'd') {
 aa8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c == 'l') {
 aac:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if (c == 'x') {
 ab0:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if (c == 'p') {
 ab4:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 ab8:	00000b97          	auipc	s7,0x0
 abc:	5b0b8b93          	addi	s7,s7,1456 # 1068 <digits>
 ac0:	a839                	j	ade <vprintf+0x6a>
        putc(fd, c);
 ac2:	85ca                	mv	a1,s2
 ac4:	8556                	mv	a0,s5
 ac6:	00000097          	auipc	ra,0x0
 aca:	ee2080e7          	jalr	-286(ra) # 9a8 <putc>
 ace:	a019                	j	ad4 <vprintf+0x60>
    } else if (state == '%') {
 ad0:	01498f63          	beq	s3,s4,aee <vprintf+0x7a>
  for (i = 0; fmt[i]; i++) {
 ad4:	0485                	addi	s1,s1,1
 ad6:	fff4c903          	lbu	s2,-1(s1)
 ada:	14090d63          	beqz	s2,c34 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 ade:	0009079b          	sext.w	a5,s2
    if (state == 0) {
 ae2:	fe0997e3          	bnez	s3,ad0 <vprintf+0x5c>
      if (c == '%') {
 ae6:	fd479ee3          	bne	a5,s4,ac2 <vprintf+0x4e>
        state = '%';
 aea:	89be                	mv	s3,a5
 aec:	b7e5                	j	ad4 <vprintf+0x60>
      if (c == 'd') {
 aee:	05878063          	beq	a5,s8,b2e <vprintf+0xba>
      } else if (c == 'l') {
 af2:	05978c63          	beq	a5,s9,b4a <vprintf+0xd6>
      } else if (c == 'x') {
 af6:	07a78863          	beq	a5,s10,b66 <vprintf+0xf2>
      } else if (c == 'p') {
 afa:	09b78463          	beq	a5,s11,b82 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if (c == 's') {
 afe:	07300713          	li	a4,115
 b02:	0ce78663          	beq	a5,a4,bce <vprintf+0x15a>
        if (s == 0) s = "(null)";
        while (*s != 0) {
          putc(fd, *s);
          s++;
        }
      } else if (c == 'c') {
 b06:	06300713          	li	a4,99
 b0a:	0ee78e63          	beq	a5,a4,c06 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if (c == '%') {
 b0e:	11478863          	beq	a5,s4,c1e <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 b12:	85d2                	mv	a1,s4
 b14:	8556                	mv	a0,s5
 b16:	00000097          	auipc	ra,0x0
 b1a:	e92080e7          	jalr	-366(ra) # 9a8 <putc>
        putc(fd, c);
 b1e:	85ca                	mv	a1,s2
 b20:	8556                	mv	a0,s5
 b22:	00000097          	auipc	ra,0x0
 b26:	e86080e7          	jalr	-378(ra) # 9a8 <putc>
      }
      state = 0;
 b2a:	4981                	li	s3,0
 b2c:	b765                	j	ad4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 b2e:	008b0913          	addi	s2,s6,8
 b32:	4685                	li	a3,1
 b34:	4629                	li	a2,10
 b36:	000b2583          	lw	a1,0(s6)
 b3a:	8556                	mv	a0,s5
 b3c:	00000097          	auipc	ra,0x0
 b40:	e8e080e7          	jalr	-370(ra) # 9ca <printint>
 b44:	8b4a                	mv	s6,s2
      state = 0;
 b46:	4981                	li	s3,0
 b48:	b771                	j	ad4 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b4a:	008b0913          	addi	s2,s6,8
 b4e:	4681                	li	a3,0
 b50:	4629                	li	a2,10
 b52:	000b2583          	lw	a1,0(s6)
 b56:	8556                	mv	a0,s5
 b58:	00000097          	auipc	ra,0x0
 b5c:	e72080e7          	jalr	-398(ra) # 9ca <printint>
 b60:	8b4a                	mv	s6,s2
      state = 0;
 b62:	4981                	li	s3,0
 b64:	bf85                	j	ad4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 b66:	008b0913          	addi	s2,s6,8
 b6a:	4681                	li	a3,0
 b6c:	4641                	li	a2,16
 b6e:	000b2583          	lw	a1,0(s6)
 b72:	8556                	mv	a0,s5
 b74:	00000097          	auipc	ra,0x0
 b78:	e56080e7          	jalr	-426(ra) # 9ca <printint>
 b7c:	8b4a                	mv	s6,s2
      state = 0;
 b7e:	4981                	li	s3,0
 b80:	bf91                	j	ad4 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 b82:	008b0793          	addi	a5,s6,8
 b86:	f8f43423          	sd	a5,-120(s0)
 b8a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 b8e:	03000593          	li	a1,48
 b92:	8556                	mv	a0,s5
 b94:	00000097          	auipc	ra,0x0
 b98:	e14080e7          	jalr	-492(ra) # 9a8 <putc>
  putc(fd, 'x');
 b9c:	85ea                	mv	a1,s10
 b9e:	8556                	mv	a0,s5
 ba0:	00000097          	auipc	ra,0x0
 ba4:	e08080e7          	jalr	-504(ra) # 9a8 <putc>
 ba8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 baa:	03c9d793          	srli	a5,s3,0x3c
 bae:	97de                	add	a5,a5,s7
 bb0:	0007c583          	lbu	a1,0(a5)
 bb4:	8556                	mv	a0,s5
 bb6:	00000097          	auipc	ra,0x0
 bba:	df2080e7          	jalr	-526(ra) # 9a8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 bbe:	0992                	slli	s3,s3,0x4
 bc0:	397d                	addiw	s2,s2,-1
 bc2:	fe0914e3          	bnez	s2,baa <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 bc6:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 bca:	4981                	li	s3,0
 bcc:	b721                	j	ad4 <vprintf+0x60>
        s = va_arg(ap, char *);
 bce:	008b0993          	addi	s3,s6,8
 bd2:	000b3903          	ld	s2,0(s6)
        if (s == 0) s = "(null)";
 bd6:	02090163          	beqz	s2,bf8 <vprintf+0x184>
        while (*s != 0) {
 bda:	00094583          	lbu	a1,0(s2)
 bde:	c9a1                	beqz	a1,c2e <vprintf+0x1ba>
          putc(fd, *s);
 be0:	8556                	mv	a0,s5
 be2:	00000097          	auipc	ra,0x0
 be6:	dc6080e7          	jalr	-570(ra) # 9a8 <putc>
          s++;
 bea:	0905                	addi	s2,s2,1
        while (*s != 0) {
 bec:	00094583          	lbu	a1,0(s2)
 bf0:	f9e5                	bnez	a1,be0 <vprintf+0x16c>
        s = va_arg(ap, char *);
 bf2:	8b4e                	mv	s6,s3
      state = 0;
 bf4:	4981                	li	s3,0
 bf6:	bdf9                	j	ad4 <vprintf+0x60>
        if (s == 0) s = "(null)";
 bf8:	00000917          	auipc	s2,0x0
 bfc:	46890913          	addi	s2,s2,1128 # 1060 <HACK+0x10>
        while (*s != 0) {
 c00:	02800593          	li	a1,40
 c04:	bff1                	j	be0 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 c06:	008b0913          	addi	s2,s6,8
 c0a:	000b4583          	lbu	a1,0(s6)
 c0e:	8556                	mv	a0,s5
 c10:	00000097          	auipc	ra,0x0
 c14:	d98080e7          	jalr	-616(ra) # 9a8 <putc>
 c18:	8b4a                	mv	s6,s2
      state = 0;
 c1a:	4981                	li	s3,0
 c1c:	bd65                	j	ad4 <vprintf+0x60>
        putc(fd, c);
 c1e:	85d2                	mv	a1,s4
 c20:	8556                	mv	a0,s5
 c22:	00000097          	auipc	ra,0x0
 c26:	d86080e7          	jalr	-634(ra) # 9a8 <putc>
      state = 0;
 c2a:	4981                	li	s3,0
 c2c:	b565                	j	ad4 <vprintf+0x60>
        s = va_arg(ap, char *);
 c2e:	8b4e                	mv	s6,s3
      state = 0;
 c30:	4981                	li	s3,0
 c32:	b54d                	j	ad4 <vprintf+0x60>
    }
  }
}
 c34:	70e6                	ld	ra,120(sp)
 c36:	7446                	ld	s0,112(sp)
 c38:	74a6                	ld	s1,104(sp)
 c3a:	7906                	ld	s2,96(sp)
 c3c:	69e6                	ld	s3,88(sp)
 c3e:	6a46                	ld	s4,80(sp)
 c40:	6aa6                	ld	s5,72(sp)
 c42:	6b06                	ld	s6,64(sp)
 c44:	7be2                	ld	s7,56(sp)
 c46:	7c42                	ld	s8,48(sp)
 c48:	7ca2                	ld	s9,40(sp)
 c4a:	7d02                	ld	s10,32(sp)
 c4c:	6de2                	ld	s11,24(sp)
 c4e:	6109                	addi	sp,sp,128
 c50:	8082                	ret

0000000000000c52 <fprintf>:

void fprintf(int fd, const char *fmt, ...) {
 c52:	715d                	addi	sp,sp,-80
 c54:	ec06                	sd	ra,24(sp)
 c56:	e822                	sd	s0,16(sp)
 c58:	1000                	addi	s0,sp,32
 c5a:	e010                	sd	a2,0(s0)
 c5c:	e414                	sd	a3,8(s0)
 c5e:	e818                	sd	a4,16(s0)
 c60:	ec1c                	sd	a5,24(s0)
 c62:	03043023          	sd	a6,32(s0)
 c66:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 c6a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 c6e:	8622                	mv	a2,s0
 c70:	00000097          	auipc	ra,0x0
 c74:	e04080e7          	jalr	-508(ra) # a74 <vprintf>
}
 c78:	60e2                	ld	ra,24(sp)
 c7a:	6442                	ld	s0,16(sp)
 c7c:	6161                	addi	sp,sp,80
 c7e:	8082                	ret

0000000000000c80 <printf>:

void printf(const char *fmt, ...) {
 c80:	711d                	addi	sp,sp,-96
 c82:	ec06                	sd	ra,24(sp)
 c84:	e822                	sd	s0,16(sp)
 c86:	1000                	addi	s0,sp,32
 c88:	e40c                	sd	a1,8(s0)
 c8a:	e810                	sd	a2,16(s0)
 c8c:	ec14                	sd	a3,24(s0)
 c8e:	f018                	sd	a4,32(s0)
 c90:	f41c                	sd	a5,40(s0)
 c92:	03043823          	sd	a6,48(s0)
 c96:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 c9a:	00840613          	addi	a2,s0,8
 c9e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 ca2:	85aa                	mv	a1,a0
 ca4:	4505                	li	a0,1
 ca6:	00000097          	auipc	ra,0x0
 caa:	dce080e7          	jalr	-562(ra) # a74 <vprintf>
}
 cae:	60e2                	ld	ra,24(sp)
 cb0:	6442                	ld	s0,16(sp)
 cb2:	6125                	addi	sp,sp,96
 cb4:	8082                	ret

0000000000000cb6 <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
 cb6:	1141                	addi	sp,sp,-16
 cb8:	e422                	sd	s0,8(sp)
 cba:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 cbc:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cc0:	00001797          	auipc	a5,0x1
 cc4:	3487b783          	ld	a5,840(a5) # 2008 <freep>
 cc8:	a805                	j	cf8 <free+0x42>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 cca:	4618                	lw	a4,8(a2)
 ccc:	9db9                	addw	a1,a1,a4
 cce:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 cd2:	6398                	ld	a4,0(a5)
 cd4:	6318                	ld	a4,0(a4)
 cd6:	fee53823          	sd	a4,-16(a0)
 cda:	a091                	j	d1e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 cdc:	ff852703          	lw	a4,-8(a0)
 ce0:	9e39                	addw	a2,a2,a4
 ce2:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 ce4:	ff053703          	ld	a4,-16(a0)
 ce8:	e398                	sd	a4,0(a5)
 cea:	a099                	j	d30 <free+0x7a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 cec:	6398                	ld	a4,0(a5)
 cee:	00e7e463          	bltu	a5,a4,cf6 <free+0x40>
 cf2:	00e6ea63          	bltu	a3,a4,d06 <free+0x50>
void free(void *ap) {
 cf6:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cf8:	fed7fae3          	bgeu	a5,a3,cec <free+0x36>
 cfc:	6398                	ld	a4,0(a5)
 cfe:	00e6e463          	bltu	a3,a4,d06 <free+0x50>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 d02:	fee7eae3          	bltu	a5,a4,cf6 <free+0x40>
  if (bp + bp->s.size == p->s.ptr) {
 d06:	ff852583          	lw	a1,-8(a0)
 d0a:	6390                	ld	a2,0(a5)
 d0c:	02059713          	slli	a4,a1,0x20
 d10:	9301                	srli	a4,a4,0x20
 d12:	0712                	slli	a4,a4,0x4
 d14:	9736                	add	a4,a4,a3
 d16:	fae60ae3          	beq	a2,a4,cca <free+0x14>
    bp->s.ptr = p->s.ptr;
 d1a:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 d1e:	4790                	lw	a2,8(a5)
 d20:	02061713          	slli	a4,a2,0x20
 d24:	9301                	srli	a4,a4,0x20
 d26:	0712                	slli	a4,a4,0x4
 d28:	973e                	add	a4,a4,a5
 d2a:	fae689e3          	beq	a3,a4,cdc <free+0x26>
  } else
    p->s.ptr = bp;
 d2e:	e394                	sd	a3,0(a5)
  freep = p;
 d30:	00001717          	auipc	a4,0x1
 d34:	2cf73c23          	sd	a5,728(a4) # 2008 <freep>
}
 d38:	6422                	ld	s0,8(sp)
 d3a:	0141                	addi	sp,sp,16
 d3c:	8082                	ret

0000000000000d3e <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
 d3e:	7139                	addi	sp,sp,-64
 d40:	fc06                	sd	ra,56(sp)
 d42:	f822                	sd	s0,48(sp)
 d44:	f426                	sd	s1,40(sp)
 d46:	f04a                	sd	s2,32(sp)
 d48:	ec4e                	sd	s3,24(sp)
 d4a:	e852                	sd	s4,16(sp)
 d4c:	e456                	sd	s5,8(sp)
 d4e:	e05a                	sd	s6,0(sp)
 d50:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 d52:	02051493          	slli	s1,a0,0x20
 d56:	9081                	srli	s1,s1,0x20
 d58:	04bd                	addi	s1,s1,15
 d5a:	8091                	srli	s1,s1,0x4
 d5c:	0014899b          	addiw	s3,s1,1
 d60:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 d62:	00001517          	auipc	a0,0x1
 d66:	2a653503          	ld	a0,678(a0) # 2008 <freep>
 d6a:	c515                	beqz	a0,d96 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 d6c:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 d6e:	4798                	lw	a4,8(a5)
 d70:	02977f63          	bgeu	a4,s1,dae <malloc+0x70>
 d74:	8a4e                	mv	s4,s3
 d76:	0009871b          	sext.w	a4,s3
 d7a:	6685                	lui	a3,0x1
 d7c:	00d77363          	bgeu	a4,a3,d82 <malloc+0x44>
 d80:	6a05                	lui	s4,0x1
 d82:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 d86:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 d8a:	00001917          	auipc	s2,0x1
 d8e:	27e90913          	addi	s2,s2,638 # 2008 <freep>
  if (p == (char *)-1) return 0;
 d92:	5afd                	li	s5,-1
 d94:	a88d                	j	e06 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 d96:	00005797          	auipc	a5,0x5
 d9a:	27a78793          	addi	a5,a5,634 # 6010 <base>
 d9e:	00001717          	auipc	a4,0x1
 da2:	26f73523          	sd	a5,618(a4) # 2008 <freep>
 da6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 da8:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 dac:	b7e1                	j	d74 <malloc+0x36>
      if (p->s.size == nunits)
 dae:	02e48b63          	beq	s1,a4,de4 <malloc+0xa6>
        p->s.size -= nunits;
 db2:	4137073b          	subw	a4,a4,s3
 db6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 db8:	1702                	slli	a4,a4,0x20
 dba:	9301                	srli	a4,a4,0x20
 dbc:	0712                	slli	a4,a4,0x4
 dbe:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 dc0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 dc4:	00001717          	auipc	a4,0x1
 dc8:	24a73223          	sd	a0,580(a4) # 2008 <freep>
      return (void *)(p + 1);
 dcc:	01078513          	addi	a0,a5,16
      if ((p = morecore(nunits)) == 0) return 0;
  }
}
 dd0:	70e2                	ld	ra,56(sp)
 dd2:	7442                	ld	s0,48(sp)
 dd4:	74a2                	ld	s1,40(sp)
 dd6:	7902                	ld	s2,32(sp)
 dd8:	69e2                	ld	s3,24(sp)
 dda:	6a42                	ld	s4,16(sp)
 ddc:	6aa2                	ld	s5,8(sp)
 dde:	6b02                	ld	s6,0(sp)
 de0:	6121                	addi	sp,sp,64
 de2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 de4:	6398                	ld	a4,0(a5)
 de6:	e118                	sd	a4,0(a0)
 de8:	bff1                	j	dc4 <malloc+0x86>
  hp->s.size = nu;
 dea:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 dee:	0541                	addi	a0,a0,16
 df0:	00000097          	auipc	ra,0x0
 df4:	ec6080e7          	jalr	-314(ra) # cb6 <free>
  return freep;
 df8:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0) return 0;
 dfc:	d971                	beqz	a0,dd0 <malloc+0x92>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 dfe:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 e00:	4798                	lw	a4,8(a5)
 e02:	fa9776e3          	bgeu	a4,s1,dae <malloc+0x70>
    if (p == freep)
 e06:	00093703          	ld	a4,0(s2)
 e0a:	853e                	mv	a0,a5
 e0c:	fef719e3          	bne	a4,a5,dfe <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 e10:	8552                	mv	a0,s4
 e12:	00000097          	auipc	ra,0x0
 e16:	b7e080e7          	jalr	-1154(ra) # 990 <sbrk>
  if (p == (char *)-1) return 0;
 e1a:	fd5518e3          	bne	a0,s5,dea <malloc+0xac>
      if ((p = morecore(nunits)) == 0) return 0;
 e1e:	4501                	li	a0,0
 e20:	bf45                	j	dd0 <malloc+0x92>
