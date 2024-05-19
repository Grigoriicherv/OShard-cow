
user/_lazytests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <sparse_memory>:
#include "kernel/types.h"
#include "user/user.h"

#define REGION_SZ (1024 * 1024 * 1024)

void sparse_memory(char *s) {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  char *i, *prev_end, *new_end;

  prev_end = sbrk(REGION_SZ);
   8:	40000537          	lui	a0,0x40000
   c:	00000097          	auipc	ra,0x0
  10:	616080e7          	jalr	1558(ra) # 622 <sbrk>
  if (prev_end == (char *)0xffffffffffffffffL) {
  14:	57fd                	li	a5,-1
  16:	02f50b63          	beq	a0,a5,4c <sparse_memory+0x4c>
    printf("sbrk() failed\n");
    exit(1);
  }
  new_end = prev_end + REGION_SZ;

  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) *(char **)i = i;
  1a:	6605                	lui	a2,0x1
  1c:	962a                	add	a2,a2,a0
  1e:	40001737          	lui	a4,0x40001
  22:	972a                	add	a4,a4,a0
  24:	87b2                	mv	a5,a2
  26:	000406b7          	lui	a3,0x40
  2a:	e39c                	sd	a5,0(a5)
  2c:	97b6                	add	a5,a5,a3
  2e:	fee79ee3          	bne	a5,a4,2a <sparse_memory+0x2a>

  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
  32:	000406b7          	lui	a3,0x40
    if (*(char **)i != i) {
  36:	621c                	ld	a5,0(a2)
  38:	02c79763          	bne	a5,a2,66 <sparse_memory+0x66>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
  3c:	9636                	add	a2,a2,a3
  3e:	fee61ce3          	bne	a2,a4,36 <sparse_memory+0x36>
      printf("failed to read value from memory\n");
      exit(1);
    }
  }

  exit(0);
  42:	4501                	li	a0,0
  44:	00000097          	auipc	ra,0x0
  48:	556080e7          	jalr	1366(ra) # 59a <exit>
    printf("sbrk() failed\n");
  4c:	00001517          	auipc	a0,0x1
  50:	aa450513          	addi	a0,a0,-1372 # af0 <malloc+0x120>
  54:	00001097          	auipc	ra,0x1
  58:	8be080e7          	jalr	-1858(ra) # 912 <printf>
    exit(1);
  5c:	4505                	li	a0,1
  5e:	00000097          	auipc	ra,0x0
  62:	53c080e7          	jalr	1340(ra) # 59a <exit>
      printf("failed to read value from memory\n");
  66:	00001517          	auipc	a0,0x1
  6a:	a9a50513          	addi	a0,a0,-1382 # b00 <malloc+0x130>
  6e:	00001097          	auipc	ra,0x1
  72:	8a4080e7          	jalr	-1884(ra) # 912 <printf>
      exit(1);
  76:	4505                	li	a0,1
  78:	00000097          	auipc	ra,0x0
  7c:	522080e7          	jalr	1314(ra) # 59a <exit>

0000000000000080 <sparse_memory_unmap>:
}

void sparse_memory_unmap(char *s) {
  80:	7139                	addi	sp,sp,-64
  82:	fc06                	sd	ra,56(sp)
  84:	f822                	sd	s0,48(sp)
  86:	f426                	sd	s1,40(sp)
  88:	f04a                	sd	s2,32(sp)
  8a:	ec4e                	sd	s3,24(sp)
  8c:	0080                	addi	s0,sp,64
  int pid;
  char *i, *prev_end, *new_end;

  prev_end = sbrk(REGION_SZ);
  8e:	40000537          	lui	a0,0x40000
  92:	00000097          	auipc	ra,0x0
  96:	590080e7          	jalr	1424(ra) # 622 <sbrk>
  if (prev_end == (char *)0xffffffffffffffffL) {
  9a:	57fd                	li	a5,-1
  9c:	04f50863          	beq	a0,a5,ec <sparse_memory_unmap+0x6c>
    printf("sbrk() failed\n");
    exit(1);
  }
  new_end = prev_end + REGION_SZ;

  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
  a0:	6905                	lui	s2,0x1
  a2:	992a                	add	s2,s2,a0
  a4:	400014b7          	lui	s1,0x40001
  a8:	94aa                	add	s1,s1,a0
  aa:	87ca                	mv	a5,s2
  ac:	01000737          	lui	a4,0x1000
    *(char **)i = i;
  b0:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
  b2:	97ba                	add	a5,a5,a4
  b4:	fef49ee3          	bne	s1,a5,b0 <sparse_memory_unmap+0x30>

  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
  b8:	010009b7          	lui	s3,0x1000
    pid = fork();
  bc:	00000097          	auipc	ra,0x0
  c0:	4d6080e7          	jalr	1238(ra) # 592 <fork>
    if (pid < 0) {
  c4:	04054163          	bltz	a0,106 <sparse_memory_unmap+0x86>
      printf("error forking\n");
      exit(1);
    } else if (pid == 0) {
  c8:	cd21                	beqz	a0,120 <sparse_memory_unmap+0xa0>
      sbrk(-1L * REGION_SZ);
      *(char **)i = i;
      exit(0);
    } else {
      int status;
      wait(&status);
  ca:	fcc40513          	addi	a0,s0,-52
  ce:	00000097          	auipc	ra,0x0
  d2:	4d4080e7          	jalr	1236(ra) # 5a2 <wait>
      if (status == 0) {
  d6:	fcc42783          	lw	a5,-52(s0)
  da:	c3a5                	beqz	a5,13a <sparse_memory_unmap+0xba>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
  dc:	994e                	add	s2,s2,s3
  de:	fd249fe3          	bne	s1,s2,bc <sparse_memory_unmap+0x3c>
        exit(1);
      }
    }
  }

  exit(0);
  e2:	4501                	li	a0,0
  e4:	00000097          	auipc	ra,0x0
  e8:	4b6080e7          	jalr	1206(ra) # 59a <exit>
    printf("sbrk() failed\n");
  ec:	00001517          	auipc	a0,0x1
  f0:	a0450513          	addi	a0,a0,-1532 # af0 <malloc+0x120>
  f4:	00001097          	auipc	ra,0x1
  f8:	81e080e7          	jalr	-2018(ra) # 912 <printf>
    exit(1);
  fc:	4505                	li	a0,1
  fe:	00000097          	auipc	ra,0x0
 102:	49c080e7          	jalr	1180(ra) # 59a <exit>
      printf("error forking\n");
 106:	00001517          	auipc	a0,0x1
 10a:	a2250513          	addi	a0,a0,-1502 # b28 <malloc+0x158>
 10e:	00001097          	auipc	ra,0x1
 112:	804080e7          	jalr	-2044(ra) # 912 <printf>
      exit(1);
 116:	4505                	li	a0,1
 118:	00000097          	auipc	ra,0x0
 11c:	482080e7          	jalr	1154(ra) # 59a <exit>
      sbrk(-1L * REGION_SZ);
 120:	c0000537          	lui	a0,0xc0000
 124:	00000097          	auipc	ra,0x0
 128:	4fe080e7          	jalr	1278(ra) # 622 <sbrk>
      *(char **)i = i;
 12c:	01293023          	sd	s2,0(s2) # 1000 <freep>
      exit(0);
 130:	4501                	li	a0,0
 132:	00000097          	auipc	ra,0x0
 136:	468080e7          	jalr	1128(ra) # 59a <exit>
        printf("memory not unmapped\n");
 13a:	00001517          	auipc	a0,0x1
 13e:	9fe50513          	addi	a0,a0,-1538 # b38 <malloc+0x168>
 142:	00000097          	auipc	ra,0x0
 146:	7d0080e7          	jalr	2000(ra) # 912 <printf>
        exit(1);
 14a:	4505                	li	a0,1
 14c:	00000097          	auipc	ra,0x0
 150:	44e080e7          	jalr	1102(ra) # 59a <exit>

0000000000000154 <oom>:
}

void oom(char *s) {
 154:	7179                	addi	sp,sp,-48
 156:	f406                	sd	ra,40(sp)
 158:	f022                	sd	s0,32(sp)
 15a:	ec26                	sd	s1,24(sp)
 15c:	1800                	addi	s0,sp,48
  void *m1, *m2;
  int pid;

  if ((pid = fork()) == 0) {
 15e:	00000097          	auipc	ra,0x0
 162:	434080e7          	jalr	1076(ra) # 592 <fork>
    m1 = 0;
 166:	4481                	li	s1,0
  if ((pid = fork()) == 0) {
 168:	c10d                	beqz	a0,18a <oom+0x36>
      m1 = m2;
    }
    exit(0);
  } else {
    int xstatus;
    wait(&xstatus);
 16a:	fdc40513          	addi	a0,s0,-36
 16e:	00000097          	auipc	ra,0x0
 172:	434080e7          	jalr	1076(ra) # 5a2 <wait>
    exit(xstatus == 0);
 176:	fdc42503          	lw	a0,-36(s0)
 17a:	00153513          	seqz	a0,a0
 17e:	00000097          	auipc	ra,0x0
 182:	41c080e7          	jalr	1052(ra) # 59a <exit>
      *(char **)m2 = m1;
 186:	e104                	sd	s1,0(a0)
      m1 = m2;
 188:	84aa                	mv	s1,a0
    while ((m2 = malloc(4096 * 4096)) != 0) {
 18a:	01000537          	lui	a0,0x1000
 18e:	00001097          	auipc	ra,0x1
 192:	842080e7          	jalr	-1982(ra) # 9d0 <malloc>
 196:	f965                	bnez	a0,186 <oom+0x32>
    exit(0);
 198:	00000097          	auipc	ra,0x0
 19c:	402080e7          	jalr	1026(ra) # 59a <exit>

00000000000001a0 <run>:
  }
}

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int run(void f(char *), char *s) {
 1a0:	7179                	addi	sp,sp,-48
 1a2:	f406                	sd	ra,40(sp)
 1a4:	f022                	sd	s0,32(sp)
 1a6:	ec26                	sd	s1,24(sp)
 1a8:	e84a                	sd	s2,16(sp)
 1aa:	1800                	addi	s0,sp,48
 1ac:	892a                	mv	s2,a0
 1ae:	84ae                	mv	s1,a1
  int pid;
  int xstatus;

  printf("running test %s\n", s);
 1b0:	00001517          	auipc	a0,0x1
 1b4:	9a050513          	addi	a0,a0,-1632 # b50 <malloc+0x180>
 1b8:	00000097          	auipc	ra,0x0
 1bc:	75a080e7          	jalr	1882(ra) # 912 <printf>
  if ((pid = fork()) < 0) {
 1c0:	00000097          	auipc	ra,0x0
 1c4:	3d2080e7          	jalr	978(ra) # 592 <fork>
 1c8:	02054f63          	bltz	a0,206 <run+0x66>
    printf("runtest: fork error\n");
    exit(1);
  }
  if (pid == 0) {
 1cc:	c931                	beqz	a0,220 <run+0x80>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
 1ce:	fdc40513          	addi	a0,s0,-36
 1d2:	00000097          	auipc	ra,0x0
 1d6:	3d0080e7          	jalr	976(ra) # 5a2 <wait>
    if (xstatus != 0)
 1da:	fdc42783          	lw	a5,-36(s0)
 1de:	cba1                	beqz	a5,22e <run+0x8e>
      printf("test %s: FAILED\n", s);
 1e0:	85a6                	mv	a1,s1
 1e2:	00001517          	auipc	a0,0x1
 1e6:	99e50513          	addi	a0,a0,-1634 # b80 <malloc+0x1b0>
 1ea:	00000097          	auipc	ra,0x0
 1ee:	728080e7          	jalr	1832(ra) # 912 <printf>
    else
      printf("test %s: OK\n", s);
    return xstatus == 0;
 1f2:	fdc42503          	lw	a0,-36(s0)
  }
}
 1f6:	00153513          	seqz	a0,a0
 1fa:	70a2                	ld	ra,40(sp)
 1fc:	7402                	ld	s0,32(sp)
 1fe:	64e2                	ld	s1,24(sp)
 200:	6942                	ld	s2,16(sp)
 202:	6145                	addi	sp,sp,48
 204:	8082                	ret
    printf("runtest: fork error\n");
 206:	00001517          	auipc	a0,0x1
 20a:	96250513          	addi	a0,a0,-1694 # b68 <malloc+0x198>
 20e:	00000097          	auipc	ra,0x0
 212:	704080e7          	jalr	1796(ra) # 912 <printf>
    exit(1);
 216:	4505                	li	a0,1
 218:	00000097          	auipc	ra,0x0
 21c:	382080e7          	jalr	898(ra) # 59a <exit>
    f(s);
 220:	8526                	mv	a0,s1
 222:	9902                	jalr	s2
    exit(0);
 224:	4501                	li	a0,0
 226:	00000097          	auipc	ra,0x0
 22a:	374080e7          	jalr	884(ra) # 59a <exit>
      printf("test %s: OK\n", s);
 22e:	85a6                	mv	a1,s1
 230:	00001517          	auipc	a0,0x1
 234:	96850513          	addi	a0,a0,-1688 # b98 <malloc+0x1c8>
 238:	00000097          	auipc	ra,0x0
 23c:	6da080e7          	jalr	1754(ra) # 912 <printf>
 240:	bf4d                	j	1f2 <run+0x52>

0000000000000242 <main>:

int main(int argc, char *argv[]) {
 242:	7159                	addi	sp,sp,-112
 244:	f486                	sd	ra,104(sp)
 246:	f0a2                	sd	s0,96(sp)
 248:	eca6                	sd	s1,88(sp)
 24a:	e8ca                	sd	s2,80(sp)
 24c:	e4ce                	sd	s3,72(sp)
 24e:	e0d2                	sd	s4,64(sp)
 250:	1880                	addi	s0,sp,112
  char *n = 0;
  if (argc > 1) {
 252:	4785                	li	a5,1
  char *n = 0;
 254:	4901                	li	s2,0
  if (argc > 1) {
 256:	00a7d463          	bge	a5,a0,25e <main+0x1c>
    n = argv[1];
 25a:	0085b903          	ld	s2,8(a1)
  }

  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
 25e:	00001797          	auipc	a5,0x1
 262:	99278793          	addi	a5,a5,-1646 # bf0 <malloc+0x220>
 266:	0007b883          	ld	a7,0(a5)
 26a:	0087b803          	ld	a6,8(a5)
 26e:	6b88                	ld	a0,16(a5)
 270:	6f8c                	ld	a1,24(a5)
 272:	7390                	ld	a2,32(a5)
 274:	7794                	ld	a3,40(a5)
 276:	7b98                	ld	a4,48(a5)
 278:	7f9c                	ld	a5,56(a5)
 27a:	f9143823          	sd	a7,-112(s0)
 27e:	f9043c23          	sd	a6,-104(s0)
 282:	faa43023          	sd	a0,-96(s0)
 286:	fab43423          	sd	a1,-88(s0)
 28a:	fac43823          	sd	a2,-80(s0)
 28e:	fad43c23          	sd	a3,-72(s0)
 292:	fce43023          	sd	a4,-64(s0)
 296:	fcf43423          	sd	a5,-56(s0)
      {sparse_memory_unmap, "lazy unmap"},
      {oom, "out of memory"},
      {0, 0},
  };

  printf("lazytests starting\n");
 29a:	00001517          	auipc	a0,0x1
 29e:	90e50513          	addi	a0,a0,-1778 # ba8 <malloc+0x1d8>
 2a2:	00000097          	auipc	ra,0x0
 2a6:	670080e7          	jalr	1648(ra) # 912 <printf>

  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
 2aa:	f9843503          	ld	a0,-104(s0)
 2ae:	c529                	beqz	a0,2f8 <main+0xb6>
 2b0:	f9040493          	addi	s1,s0,-112
  int fail = 0;
 2b4:	4981                	li	s3,0
    if ((n == 0) || strcmp(t->s, n) == 0) {
      if (!run(t->f, t->s)) fail = 1;
 2b6:	4a05                	li	s4,1
 2b8:	a021                	j	2c0 <main+0x7e>
  for (struct test *t = tests; t->s != 0; t++) {
 2ba:	04c1                	addi	s1,s1,16
 2bc:	6488                	ld	a0,8(s1)
 2be:	c115                	beqz	a0,2e2 <main+0xa0>
    if ((n == 0) || strcmp(t->s, n) == 0) {
 2c0:	00090863          	beqz	s2,2d0 <main+0x8e>
 2c4:	85ca                	mv	a1,s2
 2c6:	00000097          	auipc	ra,0x0
 2ca:	082080e7          	jalr	130(ra) # 348 <strcmp>
 2ce:	f575                	bnez	a0,2ba <main+0x78>
      if (!run(t->f, t->s)) fail = 1;
 2d0:	648c                	ld	a1,8(s1)
 2d2:	6088                	ld	a0,0(s1)
 2d4:	00000097          	auipc	ra,0x0
 2d8:	ecc080e7          	jalr	-308(ra) # 1a0 <run>
 2dc:	fd79                	bnez	a0,2ba <main+0x78>
 2de:	89d2                	mv	s3,s4
 2e0:	bfe9                	j	2ba <main+0x78>
    }
  }
  if (!fail)
 2e2:	00098b63          	beqz	s3,2f8 <main+0xb6>
    printf("ALL TESTS PASSED\n");
  else
    printf("SOME TESTS FAILED\n");
 2e6:	00001517          	auipc	a0,0x1
 2ea:	8f250513          	addi	a0,a0,-1806 # bd8 <malloc+0x208>
 2ee:	00000097          	auipc	ra,0x0
 2f2:	624080e7          	jalr	1572(ra) # 912 <printf>
 2f6:	a809                	j	308 <main+0xc6>
    printf("ALL TESTS PASSED\n");
 2f8:	00001517          	auipc	a0,0x1
 2fc:	8c850513          	addi	a0,a0,-1848 # bc0 <malloc+0x1f0>
 300:	00000097          	auipc	ra,0x0
 304:	612080e7          	jalr	1554(ra) # 912 <printf>
  exit(1);  // not reached.
 308:	4505                	li	a0,1
 30a:	00000097          	auipc	ra,0x0
 30e:	290080e7          	jalr	656(ra) # 59a <exit>

0000000000000312 <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
 312:	1141                	addi	sp,sp,-16
 314:	e406                	sd	ra,8(sp)
 316:	e022                	sd	s0,0(sp)
 318:	0800                	addi	s0,sp,16
  extern int main();
  main();
 31a:	00000097          	auipc	ra,0x0
 31e:	f28080e7          	jalr	-216(ra) # 242 <main>
  exit(0);
 322:	4501                	li	a0,0
 324:	00000097          	auipc	ra,0x0
 328:	276080e7          	jalr	630(ra) # 59a <exit>

000000000000032c <strcpy>:
}

char *strcpy(char *s, const char *t) {
 32c:	1141                	addi	sp,sp,-16
 32e:	e422                	sd	s0,8(sp)
 330:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 332:	87aa                	mv	a5,a0
 334:	0585                	addi	a1,a1,1
 336:	0785                	addi	a5,a5,1
 338:	fff5c703          	lbu	a4,-1(a1)
 33c:	fee78fa3          	sb	a4,-1(a5)
 340:	fb75                	bnez	a4,334 <strcpy+0x8>
    ;
  return os;
}
 342:	6422                	ld	s0,8(sp)
 344:	0141                	addi	sp,sp,16
 346:	8082                	ret

0000000000000348 <strcmp>:

int strcmp(const char *p, const char *q) {
 348:	1141                	addi	sp,sp,-16
 34a:	e422                	sd	s0,8(sp)
 34c:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
 34e:	00054783          	lbu	a5,0(a0)
 352:	cb91                	beqz	a5,366 <strcmp+0x1e>
 354:	0005c703          	lbu	a4,0(a1)
 358:	00f71763          	bne	a4,a5,366 <strcmp+0x1e>
 35c:	0505                	addi	a0,a0,1
 35e:	0585                	addi	a1,a1,1
 360:	00054783          	lbu	a5,0(a0)
 364:	fbe5                	bnez	a5,354 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 366:	0005c503          	lbu	a0,0(a1)
}
 36a:	40a7853b          	subw	a0,a5,a0
 36e:	6422                	ld	s0,8(sp)
 370:	0141                	addi	sp,sp,16
 372:	8082                	ret

0000000000000374 <strlen>:

uint strlen(const char *s) {
 374:	1141                	addi	sp,sp,-16
 376:	e422                	sd	s0,8(sp)
 378:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 37a:	00054783          	lbu	a5,0(a0)
 37e:	cf91                	beqz	a5,39a <strlen+0x26>
 380:	0505                	addi	a0,a0,1
 382:	87aa                	mv	a5,a0
 384:	4685                	li	a3,1
 386:	9e89                	subw	a3,a3,a0
 388:	00f6853b          	addw	a0,a3,a5
 38c:	0785                	addi	a5,a5,1
 38e:	fff7c703          	lbu	a4,-1(a5)
 392:	fb7d                	bnez	a4,388 <strlen+0x14>
    ;
  return n;
}
 394:	6422                	ld	s0,8(sp)
 396:	0141                	addi	sp,sp,16
 398:	8082                	ret
  for (n = 0; s[n]; n++)
 39a:	4501                	li	a0,0
 39c:	bfe5                	j	394 <strlen+0x20>

000000000000039e <memset>:

void *memset(void *dst, int c, uint n) {
 39e:	1141                	addi	sp,sp,-16
 3a0:	e422                	sd	s0,8(sp)
 3a2:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 3a4:	ca19                	beqz	a2,3ba <memset+0x1c>
 3a6:	87aa                	mv	a5,a0
 3a8:	1602                	slli	a2,a2,0x20
 3aa:	9201                	srli	a2,a2,0x20
 3ac:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 3b0:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 3b4:	0785                	addi	a5,a5,1
 3b6:	fee79de3          	bne	a5,a4,3b0 <memset+0x12>
  }
  return dst;
}
 3ba:	6422                	ld	s0,8(sp)
 3bc:	0141                	addi	sp,sp,16
 3be:	8082                	ret

00000000000003c0 <strchr>:

char *strchr(const char *s, char c) {
 3c0:	1141                	addi	sp,sp,-16
 3c2:	e422                	sd	s0,8(sp)
 3c4:	0800                	addi	s0,sp,16
  for (; *s; s++)
 3c6:	00054783          	lbu	a5,0(a0)
 3ca:	cb99                	beqz	a5,3e0 <strchr+0x20>
    if (*s == c) return (char *)s;
 3cc:	00f58763          	beq	a1,a5,3da <strchr+0x1a>
  for (; *s; s++)
 3d0:	0505                	addi	a0,a0,1
 3d2:	00054783          	lbu	a5,0(a0)
 3d6:	fbfd                	bnez	a5,3cc <strchr+0xc>
  return 0;
 3d8:	4501                	li	a0,0
}
 3da:	6422                	ld	s0,8(sp)
 3dc:	0141                	addi	sp,sp,16
 3de:	8082                	ret
  return 0;
 3e0:	4501                	li	a0,0
 3e2:	bfe5                	j	3da <strchr+0x1a>

00000000000003e4 <gets>:

char *gets(char *buf, int max) {
 3e4:	711d                	addi	sp,sp,-96
 3e6:	ec86                	sd	ra,88(sp)
 3e8:	e8a2                	sd	s0,80(sp)
 3ea:	e4a6                	sd	s1,72(sp)
 3ec:	e0ca                	sd	s2,64(sp)
 3ee:	fc4e                	sd	s3,56(sp)
 3f0:	f852                	sd	s4,48(sp)
 3f2:	f456                	sd	s5,40(sp)
 3f4:	f05a                	sd	s6,32(sp)
 3f6:	ec5e                	sd	s7,24(sp)
 3f8:	1080                	addi	s0,sp,96
 3fa:	8baa                	mv	s7,a0
 3fc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 3fe:	892a                	mv	s2,a0
 400:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
 402:	4aa9                	li	s5,10
 404:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 406:	89a6                	mv	s3,s1
 408:	2485                	addiw	s1,s1,1
 40a:	0344d863          	bge	s1,s4,43a <gets+0x56>
    cc = read(0, &c, 1);
 40e:	4605                	li	a2,1
 410:	faf40593          	addi	a1,s0,-81
 414:	4501                	li	a0,0
 416:	00000097          	auipc	ra,0x0
 41a:	19c080e7          	jalr	412(ra) # 5b2 <read>
    if (cc < 1) break;
 41e:	00a05e63          	blez	a0,43a <gets+0x56>
    buf[i++] = c;
 422:	faf44783          	lbu	a5,-81(s0)
 426:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r') break;
 42a:	01578763          	beq	a5,s5,438 <gets+0x54>
 42e:	0905                	addi	s2,s2,1
 430:	fd679be3          	bne	a5,s6,406 <gets+0x22>
  for (i = 0; i + 1 < max;) {
 434:	89a6                	mv	s3,s1
 436:	a011                	j	43a <gets+0x56>
 438:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
 43a:	99de                	add	s3,s3,s7
 43c:	00098023          	sb	zero,0(s3) # 1000000 <base+0xffeff0>
  return buf;
}
 440:	855e                	mv	a0,s7
 442:	60e6                	ld	ra,88(sp)
 444:	6446                	ld	s0,80(sp)
 446:	64a6                	ld	s1,72(sp)
 448:	6906                	ld	s2,64(sp)
 44a:	79e2                	ld	s3,56(sp)
 44c:	7a42                	ld	s4,48(sp)
 44e:	7aa2                	ld	s5,40(sp)
 450:	7b02                	ld	s6,32(sp)
 452:	6be2                	ld	s7,24(sp)
 454:	6125                	addi	sp,sp,96
 456:	8082                	ret

0000000000000458 <stat>:

int stat(const char *n, struct stat *st) {
 458:	1101                	addi	sp,sp,-32
 45a:	ec06                	sd	ra,24(sp)
 45c:	e822                	sd	s0,16(sp)
 45e:	e426                	sd	s1,8(sp)
 460:	e04a                	sd	s2,0(sp)
 462:	1000                	addi	s0,sp,32
 464:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 466:	4581                	li	a1,0
 468:	00000097          	auipc	ra,0x0
 46c:	172080e7          	jalr	370(ra) # 5da <open>
  if (fd < 0) return -1;
 470:	02054563          	bltz	a0,49a <stat+0x42>
 474:	84aa                	mv	s1,a0
  r = fstat(fd, st);
 476:	85ca                	mv	a1,s2
 478:	00000097          	auipc	ra,0x0
 47c:	17a080e7          	jalr	378(ra) # 5f2 <fstat>
 480:	892a                	mv	s2,a0
  close(fd);
 482:	8526                	mv	a0,s1
 484:	00000097          	auipc	ra,0x0
 488:	13e080e7          	jalr	318(ra) # 5c2 <close>
  return r;
}
 48c:	854a                	mv	a0,s2
 48e:	60e2                	ld	ra,24(sp)
 490:	6442                	ld	s0,16(sp)
 492:	64a2                	ld	s1,8(sp)
 494:	6902                	ld	s2,0(sp)
 496:	6105                	addi	sp,sp,32
 498:	8082                	ret
  if (fd < 0) return -1;
 49a:	597d                	li	s2,-1
 49c:	bfc5                	j	48c <stat+0x34>

000000000000049e <atoi>:

int atoi(const char *s) {
 49e:	1141                	addi	sp,sp,-16
 4a0:	e422                	sd	s0,8(sp)
 4a2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 4a4:	00054603          	lbu	a2,0(a0)
 4a8:	fd06079b          	addiw	a5,a2,-48
 4ac:	0ff7f793          	andi	a5,a5,255
 4b0:	4725                	li	a4,9
 4b2:	02f76963          	bltu	a4,a5,4e4 <atoi+0x46>
 4b6:	86aa                	mv	a3,a0
  n = 0;
 4b8:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 4ba:	45a5                	li	a1,9
 4bc:	0685                	addi	a3,a3,1
 4be:	0025179b          	slliw	a5,a0,0x2
 4c2:	9fa9                	addw	a5,a5,a0
 4c4:	0017979b          	slliw	a5,a5,0x1
 4c8:	9fb1                	addw	a5,a5,a2
 4ca:	fd07851b          	addiw	a0,a5,-48
 4ce:	0006c603          	lbu	a2,0(a3) # 40000 <base+0x3eff0>
 4d2:	fd06071b          	addiw	a4,a2,-48
 4d6:	0ff77713          	andi	a4,a4,255
 4da:	fee5f1e3          	bgeu	a1,a4,4bc <atoi+0x1e>
  return n;
}
 4de:	6422                	ld	s0,8(sp)
 4e0:	0141                	addi	sp,sp,16
 4e2:	8082                	ret
  n = 0;
 4e4:	4501                	li	a0,0
 4e6:	bfe5                	j	4de <atoi+0x40>

00000000000004e8 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
 4e8:	1141                	addi	sp,sp,-16
 4ea:	e422                	sd	s0,8(sp)
 4ec:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4ee:	02b57463          	bgeu	a0,a1,516 <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
 4f2:	00c05f63          	blez	a2,510 <memmove+0x28>
 4f6:	1602                	slli	a2,a2,0x20
 4f8:	9201                	srli	a2,a2,0x20
 4fa:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4fe:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
 500:	0585                	addi	a1,a1,1
 502:	0705                	addi	a4,a4,1
 504:	fff5c683          	lbu	a3,-1(a1)
 508:	fed70fa3          	sb	a3,-1(a4) # ffffff <base+0xffefef>
 50c:	fee79ae3          	bne	a5,a4,500 <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
 510:	6422                	ld	s0,8(sp)
 512:	0141                	addi	sp,sp,16
 514:	8082                	ret
    dst += n;
 516:	00c50733          	add	a4,a0,a2
    src += n;
 51a:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
 51c:	fec05ae3          	blez	a2,510 <memmove+0x28>
 520:	fff6079b          	addiw	a5,a2,-1
 524:	1782                	slli	a5,a5,0x20
 526:	9381                	srli	a5,a5,0x20
 528:	fff7c793          	not	a5,a5
 52c:	97ba                	add	a5,a5,a4
 52e:	15fd                	addi	a1,a1,-1
 530:	177d                	addi	a4,a4,-1
 532:	0005c683          	lbu	a3,0(a1)
 536:	00d70023          	sb	a3,0(a4)
 53a:	fee79ae3          	bne	a5,a4,52e <memmove+0x46>
 53e:	bfc9                	j	510 <memmove+0x28>

0000000000000540 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
 540:	1141                	addi	sp,sp,-16
 542:	e422                	sd	s0,8(sp)
 544:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 546:	ca05                	beqz	a2,576 <memcmp+0x36>
 548:	fff6069b          	addiw	a3,a2,-1
 54c:	1682                	slli	a3,a3,0x20
 54e:	9281                	srli	a3,a3,0x20
 550:	0685                	addi	a3,a3,1
 552:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 554:	00054783          	lbu	a5,0(a0)
 558:	0005c703          	lbu	a4,0(a1)
 55c:	00e79863          	bne	a5,a4,56c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 560:	0505                	addi	a0,a0,1
    p2++;
 562:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 564:	fed518e3          	bne	a0,a3,554 <memcmp+0x14>
  }
  return 0;
 568:	4501                	li	a0,0
 56a:	a019                	j	570 <memcmp+0x30>
      return *p1 - *p2;
 56c:	40e7853b          	subw	a0,a5,a4
}
 570:	6422                	ld	s0,8(sp)
 572:	0141                	addi	sp,sp,16
 574:	8082                	ret
  return 0;
 576:	4501                	li	a0,0
 578:	bfe5                	j	570 <memcmp+0x30>

000000000000057a <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
 57a:	1141                	addi	sp,sp,-16
 57c:	e406                	sd	ra,8(sp)
 57e:	e022                	sd	s0,0(sp)
 580:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 582:	00000097          	auipc	ra,0x0
 586:	f66080e7          	jalr	-154(ra) # 4e8 <memmove>
}
 58a:	60a2                	ld	ra,8(sp)
 58c:	6402                	ld	s0,0(sp)
 58e:	0141                	addi	sp,sp,16
 590:	8082                	ret

0000000000000592 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 592:	4885                	li	a7,1
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <exit>:
.global exit
exit:
 li a7, SYS_exit
 59a:	4889                	li	a7,2
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5a2:	488d                	li	a7,3
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5aa:	4891                	li	a7,4
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <read>:
.global read
read:
 li a7, SYS_read
 5b2:	4895                	li	a7,5
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <write>:
.global write
write:
 li a7, SYS_write
 5ba:	48c1                	li	a7,16
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <close>:
.global close
close:
 li a7, SYS_close
 5c2:	48d5                	li	a7,21
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <kill>:
.global kill
kill:
 li a7, SYS_kill
 5ca:	4899                	li	a7,6
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5d2:	489d                	li	a7,7
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <open>:
.global open
open:
 li a7, SYS_open
 5da:	48bd                	li	a7,15
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5e2:	48c5                	li	a7,17
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5ea:	48c9                	li	a7,18
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	8082                	ret

00000000000005f2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5f2:	48a1                	li	a7,8
 ecall
 5f4:	00000073          	ecall
 ret
 5f8:	8082                	ret

00000000000005fa <link>:
.global link
link:
 li a7, SYS_link
 5fa:	48cd                	li	a7,19
 ecall
 5fc:	00000073          	ecall
 ret
 600:	8082                	ret

0000000000000602 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 602:	48d1                	li	a7,20
 ecall
 604:	00000073          	ecall
 ret
 608:	8082                	ret

000000000000060a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 60a:	48a5                	li	a7,9
 ecall
 60c:	00000073          	ecall
 ret
 610:	8082                	ret

0000000000000612 <dup>:
.global dup
dup:
 li a7, SYS_dup
 612:	48a9                	li	a7,10
 ecall
 614:	00000073          	ecall
 ret
 618:	8082                	ret

000000000000061a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 61a:	48ad                	li	a7,11
 ecall
 61c:	00000073          	ecall
 ret
 620:	8082                	ret

0000000000000622 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 622:	48b1                	li	a7,12
 ecall
 624:	00000073          	ecall
 ret
 628:	8082                	ret

000000000000062a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 62a:	48b5                	li	a7,13
 ecall
 62c:	00000073          	ecall
 ret
 630:	8082                	ret

0000000000000632 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 632:	48b9                	li	a7,14
 ecall
 634:	00000073          	ecall
 ret
 638:	8082                	ret

000000000000063a <putc>:
#include "kernel/types.h"
#include "user/user.h"

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 63a:	1101                	addi	sp,sp,-32
 63c:	ec06                	sd	ra,24(sp)
 63e:	e822                	sd	s0,16(sp)
 640:	1000                	addi	s0,sp,32
 642:	feb407a3          	sb	a1,-17(s0)
 646:	4605                	li	a2,1
 648:	fef40593          	addi	a1,s0,-17
 64c:	00000097          	auipc	ra,0x0
 650:	f6e080e7          	jalr	-146(ra) # 5ba <write>
 654:	60e2                	ld	ra,24(sp)
 656:	6442                	ld	s0,16(sp)
 658:	6105                	addi	sp,sp,32
 65a:	8082                	ret

000000000000065c <printint>:

static void printint(int fd, int xx, int base, int sgn) {
 65c:	7139                	addi	sp,sp,-64
 65e:	fc06                	sd	ra,56(sp)
 660:	f822                	sd	s0,48(sp)
 662:	f426                	sd	s1,40(sp)
 664:	f04a                	sd	s2,32(sp)
 666:	ec4e                	sd	s3,24(sp)
 668:	0080                	addi	s0,sp,64
 66a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0) {
 66c:	c299                	beqz	a3,672 <printint+0x16>
 66e:	0805c863          	bltz	a1,6fe <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 672:	2581                	sext.w	a1,a1
  neg = 0;
 674:	4881                	li	a7,0
 676:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 67a:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 67c:	2601                	sext.w	a2,a2
 67e:	00000517          	auipc	a0,0x0
 682:	5ba50513          	addi	a0,a0,1466 # c38 <digits>
 686:	883a                	mv	a6,a4
 688:	2705                	addiw	a4,a4,1
 68a:	02c5f7bb          	remuw	a5,a1,a2
 68e:	1782                	slli	a5,a5,0x20
 690:	9381                	srli	a5,a5,0x20
 692:	97aa                	add	a5,a5,a0
 694:	0007c783          	lbu	a5,0(a5)
 698:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 69c:	0005879b          	sext.w	a5,a1
 6a0:	02c5d5bb          	divuw	a1,a1,a2
 6a4:	0685                	addi	a3,a3,1
 6a6:	fec7f0e3          	bgeu	a5,a2,686 <printint+0x2a>
  if (neg) buf[i++] = '-';
 6aa:	00088b63          	beqz	a7,6c0 <printint+0x64>
 6ae:	fd040793          	addi	a5,s0,-48
 6b2:	973e                	add	a4,a4,a5
 6b4:	02d00793          	li	a5,45
 6b8:	fef70823          	sb	a5,-16(a4)
 6bc:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) putc(fd, buf[i]);
 6c0:	02e05863          	blez	a4,6f0 <printint+0x94>
 6c4:	fc040793          	addi	a5,s0,-64
 6c8:	00e78933          	add	s2,a5,a4
 6cc:	fff78993          	addi	s3,a5,-1
 6d0:	99ba                	add	s3,s3,a4
 6d2:	377d                	addiw	a4,a4,-1
 6d4:	1702                	slli	a4,a4,0x20
 6d6:	9301                	srli	a4,a4,0x20
 6d8:	40e989b3          	sub	s3,s3,a4
 6dc:	fff94583          	lbu	a1,-1(s2)
 6e0:	8526                	mv	a0,s1
 6e2:	00000097          	auipc	ra,0x0
 6e6:	f58080e7          	jalr	-168(ra) # 63a <putc>
 6ea:	197d                	addi	s2,s2,-1
 6ec:	ff3918e3          	bne	s2,s3,6dc <printint+0x80>
}
 6f0:	70e2                	ld	ra,56(sp)
 6f2:	7442                	ld	s0,48(sp)
 6f4:	74a2                	ld	s1,40(sp)
 6f6:	7902                	ld	s2,32(sp)
 6f8:	69e2                	ld	s3,24(sp)
 6fa:	6121                	addi	sp,sp,64
 6fc:	8082                	ret
    x = -xx;
 6fe:	40b005bb          	negw	a1,a1
    neg = 1;
 702:	4885                	li	a7,1
    x = -xx;
 704:	bf8d                	j	676 <printint+0x1a>

0000000000000706 <vprintf>:
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap) {
 706:	7119                	addi	sp,sp,-128
 708:	fc86                	sd	ra,120(sp)
 70a:	f8a2                	sd	s0,112(sp)
 70c:	f4a6                	sd	s1,104(sp)
 70e:	f0ca                	sd	s2,96(sp)
 710:	ecce                	sd	s3,88(sp)
 712:	e8d2                	sd	s4,80(sp)
 714:	e4d6                	sd	s5,72(sp)
 716:	e0da                	sd	s6,64(sp)
 718:	fc5e                	sd	s7,56(sp)
 71a:	f862                	sd	s8,48(sp)
 71c:	f466                	sd	s9,40(sp)
 71e:	f06a                	sd	s10,32(sp)
 720:	ec6e                	sd	s11,24(sp)
 722:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 724:	0005c903          	lbu	s2,0(a1)
 728:	18090f63          	beqz	s2,8c6 <vprintf+0x1c0>
 72c:	8aaa                	mv	s5,a0
 72e:	8b32                	mv	s6,a2
 730:	00158493          	addi	s1,a1,1
  state = 0;
 734:	4981                	li	s3,0
      if (c == '%') {
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if (state == '%') {
 736:	02500a13          	li	s4,37
      if (c == 'd') {
 73a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c == 'l') {
 73e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if (c == 'x') {
 742:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if (c == 'p') {
 746:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 74a:	00000b97          	auipc	s7,0x0
 74e:	4eeb8b93          	addi	s7,s7,1262 # c38 <digits>
 752:	a839                	j	770 <vprintf+0x6a>
        putc(fd, c);
 754:	85ca                	mv	a1,s2
 756:	8556                	mv	a0,s5
 758:	00000097          	auipc	ra,0x0
 75c:	ee2080e7          	jalr	-286(ra) # 63a <putc>
 760:	a019                	j	766 <vprintf+0x60>
    } else if (state == '%') {
 762:	01498f63          	beq	s3,s4,780 <vprintf+0x7a>
  for (i = 0; fmt[i]; i++) {
 766:	0485                	addi	s1,s1,1
 768:	fff4c903          	lbu	s2,-1(s1) # 40000fff <base+0x3fffffef>
 76c:	14090d63          	beqz	s2,8c6 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 770:	0009079b          	sext.w	a5,s2
    if (state == 0) {
 774:	fe0997e3          	bnez	s3,762 <vprintf+0x5c>
      if (c == '%') {
 778:	fd479ee3          	bne	a5,s4,754 <vprintf+0x4e>
        state = '%';
 77c:	89be                	mv	s3,a5
 77e:	b7e5                	j	766 <vprintf+0x60>
      if (c == 'd') {
 780:	05878063          	beq	a5,s8,7c0 <vprintf+0xba>
      } else if (c == 'l') {
 784:	05978c63          	beq	a5,s9,7dc <vprintf+0xd6>
      } else if (c == 'x') {
 788:	07a78863          	beq	a5,s10,7f8 <vprintf+0xf2>
      } else if (c == 'p') {
 78c:	09b78463          	beq	a5,s11,814 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if (c == 's') {
 790:	07300713          	li	a4,115
 794:	0ce78663          	beq	a5,a4,860 <vprintf+0x15a>
        if (s == 0) s = "(null)";
        while (*s != 0) {
          putc(fd, *s);
          s++;
        }
      } else if (c == 'c') {
 798:	06300713          	li	a4,99
 79c:	0ee78e63          	beq	a5,a4,898 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if (c == '%') {
 7a0:	11478863          	beq	a5,s4,8b0 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7a4:	85d2                	mv	a1,s4
 7a6:	8556                	mv	a0,s5
 7a8:	00000097          	auipc	ra,0x0
 7ac:	e92080e7          	jalr	-366(ra) # 63a <putc>
        putc(fd, c);
 7b0:	85ca                	mv	a1,s2
 7b2:	8556                	mv	a0,s5
 7b4:	00000097          	auipc	ra,0x0
 7b8:	e86080e7          	jalr	-378(ra) # 63a <putc>
      }
      state = 0;
 7bc:	4981                	li	s3,0
 7be:	b765                	j	766 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 7c0:	008b0913          	addi	s2,s6,8
 7c4:	4685                	li	a3,1
 7c6:	4629                	li	a2,10
 7c8:	000b2583          	lw	a1,0(s6)
 7cc:	8556                	mv	a0,s5
 7ce:	00000097          	auipc	ra,0x0
 7d2:	e8e080e7          	jalr	-370(ra) # 65c <printint>
 7d6:	8b4a                	mv	s6,s2
      state = 0;
 7d8:	4981                	li	s3,0
 7da:	b771                	j	766 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7dc:	008b0913          	addi	s2,s6,8
 7e0:	4681                	li	a3,0
 7e2:	4629                	li	a2,10
 7e4:	000b2583          	lw	a1,0(s6)
 7e8:	8556                	mv	a0,s5
 7ea:	00000097          	auipc	ra,0x0
 7ee:	e72080e7          	jalr	-398(ra) # 65c <printint>
 7f2:	8b4a                	mv	s6,s2
      state = 0;
 7f4:	4981                	li	s3,0
 7f6:	bf85                	j	766 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7f8:	008b0913          	addi	s2,s6,8
 7fc:	4681                	li	a3,0
 7fe:	4641                	li	a2,16
 800:	000b2583          	lw	a1,0(s6)
 804:	8556                	mv	a0,s5
 806:	00000097          	auipc	ra,0x0
 80a:	e56080e7          	jalr	-426(ra) # 65c <printint>
 80e:	8b4a                	mv	s6,s2
      state = 0;
 810:	4981                	li	s3,0
 812:	bf91                	j	766 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 814:	008b0793          	addi	a5,s6,8
 818:	f8f43423          	sd	a5,-120(s0)
 81c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 820:	03000593          	li	a1,48
 824:	8556                	mv	a0,s5
 826:	00000097          	auipc	ra,0x0
 82a:	e14080e7          	jalr	-492(ra) # 63a <putc>
  putc(fd, 'x');
 82e:	85ea                	mv	a1,s10
 830:	8556                	mv	a0,s5
 832:	00000097          	auipc	ra,0x0
 836:	e08080e7          	jalr	-504(ra) # 63a <putc>
 83a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 83c:	03c9d793          	srli	a5,s3,0x3c
 840:	97de                	add	a5,a5,s7
 842:	0007c583          	lbu	a1,0(a5)
 846:	8556                	mv	a0,s5
 848:	00000097          	auipc	ra,0x0
 84c:	df2080e7          	jalr	-526(ra) # 63a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 850:	0992                	slli	s3,s3,0x4
 852:	397d                	addiw	s2,s2,-1
 854:	fe0914e3          	bnez	s2,83c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 858:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 85c:	4981                	li	s3,0
 85e:	b721                	j	766 <vprintf+0x60>
        s = va_arg(ap, char *);
 860:	008b0993          	addi	s3,s6,8
 864:	000b3903          	ld	s2,0(s6)
        if (s == 0) s = "(null)";
 868:	02090163          	beqz	s2,88a <vprintf+0x184>
        while (*s != 0) {
 86c:	00094583          	lbu	a1,0(s2)
 870:	c9a1                	beqz	a1,8c0 <vprintf+0x1ba>
          putc(fd, *s);
 872:	8556                	mv	a0,s5
 874:	00000097          	auipc	ra,0x0
 878:	dc6080e7          	jalr	-570(ra) # 63a <putc>
          s++;
 87c:	0905                	addi	s2,s2,1
        while (*s != 0) {
 87e:	00094583          	lbu	a1,0(s2)
 882:	f9e5                	bnez	a1,872 <vprintf+0x16c>
        s = va_arg(ap, char *);
 884:	8b4e                	mv	s6,s3
      state = 0;
 886:	4981                	li	s3,0
 888:	bdf9                	j	766 <vprintf+0x60>
        if (s == 0) s = "(null)";
 88a:	00000917          	auipc	s2,0x0
 88e:	3a690913          	addi	s2,s2,934 # c30 <malloc+0x260>
        while (*s != 0) {
 892:	02800593          	li	a1,40
 896:	bff1                	j	872 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 898:	008b0913          	addi	s2,s6,8
 89c:	000b4583          	lbu	a1,0(s6)
 8a0:	8556                	mv	a0,s5
 8a2:	00000097          	auipc	ra,0x0
 8a6:	d98080e7          	jalr	-616(ra) # 63a <putc>
 8aa:	8b4a                	mv	s6,s2
      state = 0;
 8ac:	4981                	li	s3,0
 8ae:	bd65                	j	766 <vprintf+0x60>
        putc(fd, c);
 8b0:	85d2                	mv	a1,s4
 8b2:	8556                	mv	a0,s5
 8b4:	00000097          	auipc	ra,0x0
 8b8:	d86080e7          	jalr	-634(ra) # 63a <putc>
      state = 0;
 8bc:	4981                	li	s3,0
 8be:	b565                	j	766 <vprintf+0x60>
        s = va_arg(ap, char *);
 8c0:	8b4e                	mv	s6,s3
      state = 0;
 8c2:	4981                	li	s3,0
 8c4:	b54d                	j	766 <vprintf+0x60>
    }
  }
}
 8c6:	70e6                	ld	ra,120(sp)
 8c8:	7446                	ld	s0,112(sp)
 8ca:	74a6                	ld	s1,104(sp)
 8cc:	7906                	ld	s2,96(sp)
 8ce:	69e6                	ld	s3,88(sp)
 8d0:	6a46                	ld	s4,80(sp)
 8d2:	6aa6                	ld	s5,72(sp)
 8d4:	6b06                	ld	s6,64(sp)
 8d6:	7be2                	ld	s7,56(sp)
 8d8:	7c42                	ld	s8,48(sp)
 8da:	7ca2                	ld	s9,40(sp)
 8dc:	7d02                	ld	s10,32(sp)
 8de:	6de2                	ld	s11,24(sp)
 8e0:	6109                	addi	sp,sp,128
 8e2:	8082                	ret

00000000000008e4 <fprintf>:

void fprintf(int fd, const char *fmt, ...) {
 8e4:	715d                	addi	sp,sp,-80
 8e6:	ec06                	sd	ra,24(sp)
 8e8:	e822                	sd	s0,16(sp)
 8ea:	1000                	addi	s0,sp,32
 8ec:	e010                	sd	a2,0(s0)
 8ee:	e414                	sd	a3,8(s0)
 8f0:	e818                	sd	a4,16(s0)
 8f2:	ec1c                	sd	a5,24(s0)
 8f4:	03043023          	sd	a6,32(s0)
 8f8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8fc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 900:	8622                	mv	a2,s0
 902:	00000097          	auipc	ra,0x0
 906:	e04080e7          	jalr	-508(ra) # 706 <vprintf>
}
 90a:	60e2                	ld	ra,24(sp)
 90c:	6442                	ld	s0,16(sp)
 90e:	6161                	addi	sp,sp,80
 910:	8082                	ret

0000000000000912 <printf>:

void printf(const char *fmt, ...) {
 912:	711d                	addi	sp,sp,-96
 914:	ec06                	sd	ra,24(sp)
 916:	e822                	sd	s0,16(sp)
 918:	1000                	addi	s0,sp,32
 91a:	e40c                	sd	a1,8(s0)
 91c:	e810                	sd	a2,16(s0)
 91e:	ec14                	sd	a3,24(s0)
 920:	f018                	sd	a4,32(s0)
 922:	f41c                	sd	a5,40(s0)
 924:	03043823          	sd	a6,48(s0)
 928:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 92c:	00840613          	addi	a2,s0,8
 930:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 934:	85aa                	mv	a1,a0
 936:	4505                	li	a0,1
 938:	00000097          	auipc	ra,0x0
 93c:	dce080e7          	jalr	-562(ra) # 706 <vprintf>
}
 940:	60e2                	ld	ra,24(sp)
 942:	6442                	ld	s0,16(sp)
 944:	6125                	addi	sp,sp,96
 946:	8082                	ret

0000000000000948 <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
 948:	1141                	addi	sp,sp,-16
 94a:	e422                	sd	s0,8(sp)
 94c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 94e:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 952:	00000797          	auipc	a5,0x0
 956:	6ae7b783          	ld	a5,1710(a5) # 1000 <freep>
 95a:	a805                	j	98a <free+0x42>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 95c:	4618                	lw	a4,8(a2)
 95e:	9db9                	addw	a1,a1,a4
 960:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 964:	6398                	ld	a4,0(a5)
 966:	6318                	ld	a4,0(a4)
 968:	fee53823          	sd	a4,-16(a0)
 96c:	a091                	j	9b0 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 96e:	ff852703          	lw	a4,-8(a0)
 972:	9e39                	addw	a2,a2,a4
 974:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 976:	ff053703          	ld	a4,-16(a0)
 97a:	e398                	sd	a4,0(a5)
 97c:	a099                	j	9c2 <free+0x7a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 97e:	6398                	ld	a4,0(a5)
 980:	00e7e463          	bltu	a5,a4,988 <free+0x40>
 984:	00e6ea63          	bltu	a3,a4,998 <free+0x50>
void free(void *ap) {
 988:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 98a:	fed7fae3          	bgeu	a5,a3,97e <free+0x36>
 98e:	6398                	ld	a4,0(a5)
 990:	00e6e463          	bltu	a3,a4,998 <free+0x50>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 994:	fee7eae3          	bltu	a5,a4,988 <free+0x40>
  if (bp + bp->s.size == p->s.ptr) {
 998:	ff852583          	lw	a1,-8(a0)
 99c:	6390                	ld	a2,0(a5)
 99e:	02059713          	slli	a4,a1,0x20
 9a2:	9301                	srli	a4,a4,0x20
 9a4:	0712                	slli	a4,a4,0x4
 9a6:	9736                	add	a4,a4,a3
 9a8:	fae60ae3          	beq	a2,a4,95c <free+0x14>
    bp->s.ptr = p->s.ptr;
 9ac:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 9b0:	4790                	lw	a2,8(a5)
 9b2:	02061713          	slli	a4,a2,0x20
 9b6:	9301                	srli	a4,a4,0x20
 9b8:	0712                	slli	a4,a4,0x4
 9ba:	973e                	add	a4,a4,a5
 9bc:	fae689e3          	beq	a3,a4,96e <free+0x26>
  } else
    p->s.ptr = bp;
 9c0:	e394                	sd	a3,0(a5)
  freep = p;
 9c2:	00000717          	auipc	a4,0x0
 9c6:	62f73f23          	sd	a5,1598(a4) # 1000 <freep>
}
 9ca:	6422                	ld	s0,8(sp)
 9cc:	0141                	addi	sp,sp,16
 9ce:	8082                	ret

00000000000009d0 <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
 9d0:	7139                	addi	sp,sp,-64
 9d2:	fc06                	sd	ra,56(sp)
 9d4:	f822                	sd	s0,48(sp)
 9d6:	f426                	sd	s1,40(sp)
 9d8:	f04a                	sd	s2,32(sp)
 9da:	ec4e                	sd	s3,24(sp)
 9dc:	e852                	sd	s4,16(sp)
 9de:	e456                	sd	s5,8(sp)
 9e0:	e05a                	sd	s6,0(sp)
 9e2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 9e4:	02051493          	slli	s1,a0,0x20
 9e8:	9081                	srli	s1,s1,0x20
 9ea:	04bd                	addi	s1,s1,15
 9ec:	8091                	srli	s1,s1,0x4
 9ee:	0014899b          	addiw	s3,s1,1
 9f2:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 9f4:	00000517          	auipc	a0,0x0
 9f8:	60c53503          	ld	a0,1548(a0) # 1000 <freep>
 9fc:	c515                	beqz	a0,a28 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 9fe:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 a00:	4798                	lw	a4,8(a5)
 a02:	02977f63          	bgeu	a4,s1,a40 <malloc+0x70>
 a06:	8a4e                	mv	s4,s3
 a08:	0009871b          	sext.w	a4,s3
 a0c:	6685                	lui	a3,0x1
 a0e:	00d77363          	bgeu	a4,a3,a14 <malloc+0x44>
 a12:	6a05                	lui	s4,0x1
 a14:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a18:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 a1c:	00000917          	auipc	s2,0x0
 a20:	5e490913          	addi	s2,s2,1508 # 1000 <freep>
  if (p == (char *)-1) return 0;
 a24:	5afd                	li	s5,-1
 a26:	a88d                	j	a98 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 a28:	00000797          	auipc	a5,0x0
 a2c:	5e878793          	addi	a5,a5,1512 # 1010 <base>
 a30:	00000717          	auipc	a4,0x0
 a34:	5cf73823          	sd	a5,1488(a4) # 1000 <freep>
 a38:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a3a:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 a3e:	b7e1                	j	a06 <malloc+0x36>
      if (p->s.size == nunits)
 a40:	02e48b63          	beq	s1,a4,a76 <malloc+0xa6>
        p->s.size -= nunits;
 a44:	4137073b          	subw	a4,a4,s3
 a48:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a4a:	1702                	slli	a4,a4,0x20
 a4c:	9301                	srli	a4,a4,0x20
 a4e:	0712                	slli	a4,a4,0x4
 a50:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a52:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a56:	00000717          	auipc	a4,0x0
 a5a:	5aa73523          	sd	a0,1450(a4) # 1000 <freep>
      return (void *)(p + 1);
 a5e:	01078513          	addi	a0,a5,16
      if ((p = morecore(nunits)) == 0) return 0;
  }
}
 a62:	70e2                	ld	ra,56(sp)
 a64:	7442                	ld	s0,48(sp)
 a66:	74a2                	ld	s1,40(sp)
 a68:	7902                	ld	s2,32(sp)
 a6a:	69e2                	ld	s3,24(sp)
 a6c:	6a42                	ld	s4,16(sp)
 a6e:	6aa2                	ld	s5,8(sp)
 a70:	6b02                	ld	s6,0(sp)
 a72:	6121                	addi	sp,sp,64
 a74:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a76:	6398                	ld	a4,0(a5)
 a78:	e118                	sd	a4,0(a0)
 a7a:	bff1                	j	a56 <malloc+0x86>
  hp->s.size = nu;
 a7c:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 a80:	0541                	addi	a0,a0,16
 a82:	00000097          	auipc	ra,0x0
 a86:	ec6080e7          	jalr	-314(ra) # 948 <free>
  return freep;
 a8a:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0) return 0;
 a8e:	d971                	beqz	a0,a62 <malloc+0x92>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 a90:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 a92:	4798                	lw	a4,8(a5)
 a94:	fa9776e3          	bgeu	a4,s1,a40 <malloc+0x70>
    if (p == freep)
 a98:	00093703          	ld	a4,0(s2)
 a9c:	853e                	mv	a0,a5
 a9e:	fef719e3          	bne	a4,a5,a90 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 aa2:	8552                	mv	a0,s4
 aa4:	00000097          	auipc	ra,0x0
 aa8:	b7e080e7          	jalr	-1154(ra) # 622 <sbrk>
  if (p == (char *)-1) return 0;
 aac:	fd5518e3          	bne	a0,s5,a7c <malloc+0xac>
      if ((p = morecore(nunits)) == 0) return 0;
 ab0:	4501                	li	a0,0
 ab2:	bf45                	j	a62 <malloc+0x92>
