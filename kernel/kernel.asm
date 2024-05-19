
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0003a117          	auipc	sp,0x3a
    80000004:	bf010113          	addi	sp,sp,-1040 # 80039bf0 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	229050ef          	jal	ra,80005a3e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <pg_num>:
                    // defined by kernel.ld.

struct run {
  struct run *next;
};
uint64 pg_num(uint64 pa) { return (PGROUNDDOWN(pa) - KERNBASE) / PGSIZE; }
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
    80000022:	77fd                	lui	a5,0xfffff
    80000024:	8d7d                	and	a0,a0,a5
    80000026:	800007b7          	lui	a5,0x80000
    8000002a:	953e                	add	a0,a0,a5
    8000002c:	8131                	srli	a0,a0,0xc
    8000002e:	6422                	ld	s0,8(sp)
    80000030:	0141                	addi	sp,sp,16
    80000032:	8082                	ret

0000000080000034 <getref>:
  char *p;
  p = (char *)PGROUNDUP((uint64)pa_start);
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE) kfree(p);
}

int getref(uint64 pa) {
    80000034:	1101                	addi	sp,sp,-32
    80000036:	ec06                	sd	ra,24(sp)
    80000038:	e822                	sd	s0,16(sp)
    8000003a:	e426                	sd	s1,8(sp)
    8000003c:	1000                	addi	s0,sp,32
    8000003e:	84aa                	mv	s1,a0
  int res;
  acquire(&kmem.lock);
    80000040:	00009517          	auipc	a0,0x9
    80000044:	84050513          	addi	a0,a0,-1984 # 80008880 <kmem>
    80000048:	00006097          	auipc	ra,0x6
    8000004c:	3e2080e7          	jalr	994(ra) # 8000642a <acquire>
  res = kmem.ref_count[pg_num((uint64)pa)];
    80000050:	00009517          	auipc	a0,0x9
    80000054:	83050513          	addi	a0,a0,-2000 # 80008880 <kmem>
uint64 pg_num(uint64 pa) { return (PGROUNDDOWN(pa) - KERNBASE) / PGSIZE; }
    80000058:	77fd                	lui	a5,0xfffff
    8000005a:	8cfd                	and	s1,s1,a5
    8000005c:	800007b7          	lui	a5,0x80000
    80000060:	94be                	add	s1,s1,a5
  res = kmem.ref_count[pg_num((uint64)pa)];
    80000062:	80a9                	srli	s1,s1,0xa
    80000064:	94aa                	add	s1,s1,a0
    80000066:	5084                	lw	s1,32(s1)
  release(&kmem.lock);
    80000068:	00006097          	auipc	ra,0x6
    8000006c:	476080e7          	jalr	1142(ra) # 800064de <release>
  return res;
}
    80000070:	8526                	mv	a0,s1
    80000072:	60e2                	ld	ra,24(sp)
    80000074:	6442                	ld	s0,16(sp)
    80000076:	64a2                	ld	s1,8(sp)
    80000078:	6105                	addi	sp,sp,32
    8000007a:	8082                	ret

000000008000007c <increase_ref>:

int increase_ref(void *pa) {
    8000007c:	1101                	addi	sp,sp,-32
    8000007e:	ec06                	sd	ra,24(sp)
    80000080:	e822                	sd	s0,16(sp)
    80000082:	e426                	sd	s1,8(sp)
    80000084:	1000                	addi	s0,sp,32
    80000086:	84aa                	mv	s1,a0
  acquire(&kmem.lock);
    80000088:	00008517          	auipc	a0,0x8
    8000008c:	7f850513          	addi	a0,a0,2040 # 80008880 <kmem>
    80000090:	00006097          	auipc	ra,0x6
    80000094:	39a080e7          	jalr	922(ra) # 8000642a <acquire>
uint64 pg_num(uint64 pa) { return (PGROUNDDOWN(pa) - KERNBASE) / PGSIZE; }
    80000098:	77fd                	lui	a5,0xfffff
    8000009a:	8fe5                	and	a5,a5,s1
    8000009c:	800004b7          	lui	s1,0x80000
    800000a0:	97a6                	add	a5,a5,s1
  int ret = ++kmem.ref_count[pg_num((uint64)pa)];
    800000a2:	00008517          	auipc	a0,0x8
    800000a6:	7de50513          	addi	a0,a0,2014 # 80008880 <kmem>
    800000aa:	83a9                	srli	a5,a5,0xa
    800000ac:	02078793          	addi	a5,a5,32 # fffffffffffff020 <end+0xffffffff7ffbd330>
    800000b0:	97aa                	add	a5,a5,a0
    800000b2:	4398                	lw	a4,0(a5)
    800000b4:	2705                	addiw	a4,a4,1
    800000b6:	0007049b          	sext.w	s1,a4
    800000ba:	c398                	sw	a4,0(a5)
  release(&kmem.lock);
    800000bc:	00006097          	auipc	ra,0x6
    800000c0:	422080e7          	jalr	1058(ra) # 800064de <release>
  return ret;
}
    800000c4:	8526                	mv	a0,s1
    800000c6:	60e2                	ld	ra,24(sp)
    800000c8:	6442                	ld	s0,16(sp)
    800000ca:	64a2                	ld	s1,8(sp)
    800000cc:	6105                	addi	sp,sp,32
    800000ce:	8082                	ret

00000000800000d0 <decrease_ref>:

int decrease_ref(void *pa) {
    800000d0:	1101                	addi	sp,sp,-32
    800000d2:	ec06                	sd	ra,24(sp)
    800000d4:	e822                	sd	s0,16(sp)
    800000d6:	e426                	sd	s1,8(sp)
    800000d8:	1000                	addi	s0,sp,32
    800000da:	84aa                	mv	s1,a0
  acquire(&kmem.lock);
    800000dc:	00008517          	auipc	a0,0x8
    800000e0:	7a450513          	addi	a0,a0,1956 # 80008880 <kmem>
    800000e4:	00006097          	auipc	ra,0x6
    800000e8:	346080e7          	jalr	838(ra) # 8000642a <acquire>
uint64 pg_num(uint64 pa) { return (PGROUNDDOWN(pa) - KERNBASE) / PGSIZE; }
    800000ec:	77fd                	lui	a5,0xfffff
    800000ee:	8fe5                	and	a5,a5,s1
    800000f0:	800004b7          	lui	s1,0x80000
    800000f4:	97a6                	add	a5,a5,s1
  int ret = --kmem.ref_count[pg_num((uint64)pa)];
    800000f6:	00008517          	auipc	a0,0x8
    800000fa:	78a50513          	addi	a0,a0,1930 # 80008880 <kmem>
    800000fe:	83a9                	srli	a5,a5,0xa
    80000100:	02078793          	addi	a5,a5,32 # fffffffffffff020 <end+0xffffffff7ffbd330>
    80000104:	97aa                	add	a5,a5,a0
    80000106:	4398                	lw	a4,0(a5)
    80000108:	377d                	addiw	a4,a4,-1
    8000010a:	0007049b          	sext.w	s1,a4
    8000010e:	c398                	sw	a4,0(a5)
  release(&kmem.lock);
    80000110:	00006097          	auipc	ra,0x6
    80000114:	3ce080e7          	jalr	974(ra) # 800064de <release>
  return ret;
}
    80000118:	8526                	mv	a0,s1
    8000011a:	60e2                	ld	ra,24(sp)
    8000011c:	6442                	ld	s0,16(sp)
    8000011e:	64a2                	ld	s1,8(sp)
    80000120:	6105                	addi	sp,sp,32
    80000122:	8082                	ret

0000000080000124 <kfree>:

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa) {
    80000124:	1101                	addi	sp,sp,-32
    80000126:	ec06                	sd	ra,24(sp)
    80000128:	e822                	sd	s0,16(sp)
    8000012a:	e426                	sd	s1,8(sp)
    8000012c:	1000                	addi	s0,sp,32
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    8000012e:	03451793          	slli	a5,a0,0x34
    80000132:	e79d                	bnez	a5,80000160 <kfree+0x3c>
    80000134:	84aa                	mv	s1,a0
    80000136:	00042797          	auipc	a5,0x42
    8000013a:	bba78793          	addi	a5,a5,-1094 # 80041cf0 <end>
    8000013e:	02f56163          	bltu	a0,a5,80000160 <kfree+0x3c>
    80000142:	47c5                	li	a5,17
    80000144:	07ee                	slli	a5,a5,0x1b
    80000146:	00f57d63          	bgeu	a0,a5,80000160 <kfree+0x3c>
    panic("kfree");

  int ref_cnt = decrease_ref(pa);
    8000014a:	00000097          	auipc	ra,0x0
    8000014e:	f86080e7          	jalr	-122(ra) # 800000d0 <decrease_ref>
  if (ref_cnt > 0) return;
    80000152:	00a05f63          	blez	a0,80000170 <kfree+0x4c>

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}
    80000156:	60e2                	ld	ra,24(sp)
    80000158:	6442                	ld	s0,16(sp)
    8000015a:	64a2                	ld	s1,8(sp)
    8000015c:	6105                	addi	sp,sp,32
    8000015e:	8082                	ret
    panic("kfree");
    80000160:	00008517          	auipc	a0,0x8
    80000164:	eb050513          	addi	a0,a0,-336 # 80008010 <etext+0x10>
    80000168:	00006097          	auipc	ra,0x6
    8000016c:	d86080e7          	jalr	-634(ra) # 80005eee <panic>
  memset(pa, 1, PGSIZE);
    80000170:	6605                	lui	a2,0x1
    80000172:	4585                	li	a1,1
    80000174:	8526                	mv	a0,s1
    80000176:	00000097          	auipc	ra,0x0
    8000017a:	12c080e7          	jalr	300(ra) # 800002a2 <memset>
  acquire(&kmem.lock);
    8000017e:	00008517          	auipc	a0,0x8
    80000182:	70250513          	addi	a0,a0,1794 # 80008880 <kmem>
    80000186:	00006097          	auipc	ra,0x6
    8000018a:	2a4080e7          	jalr	676(ra) # 8000642a <acquire>
  r->next = kmem.freelist;
    8000018e:	00008517          	auipc	a0,0x8
    80000192:	6f250513          	addi	a0,a0,1778 # 80008880 <kmem>
    80000196:	6d1c                	ld	a5,24(a0)
    80000198:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    8000019a:	ed04                	sd	s1,24(a0)
  release(&kmem.lock);
    8000019c:	00006097          	auipc	ra,0x6
    800001a0:	342080e7          	jalr	834(ra) # 800064de <release>
    800001a4:	bf4d                	j	80000156 <kfree+0x32>

00000000800001a6 <freerange>:
void freerange(void *pa_start, void *pa_end) {
    800001a6:	7179                	addi	sp,sp,-48
    800001a8:	f406                	sd	ra,40(sp)
    800001aa:	f022                	sd	s0,32(sp)
    800001ac:	ec26                	sd	s1,24(sp)
    800001ae:	e84a                	sd	s2,16(sp)
    800001b0:	e44e                	sd	s3,8(sp)
    800001b2:	e052                	sd	s4,0(sp)
    800001b4:	1800                	addi	s0,sp,48
  p = (char *)PGROUNDUP((uint64)pa_start);
    800001b6:	6785                	lui	a5,0x1
    800001b8:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800001bc:	94aa                	add	s1,s1,a0
    800001be:	757d                	lui	a0,0xfffff
    800001c0:	8ce9                	and	s1,s1,a0
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE) kfree(p);
    800001c2:	94be                	add	s1,s1,a5
    800001c4:	0095ee63          	bltu	a1,s1,800001e0 <freerange+0x3a>
    800001c8:	892e                	mv	s2,a1
    800001ca:	7a7d                	lui	s4,0xfffff
    800001cc:	6985                	lui	s3,0x1
    800001ce:	01448533          	add	a0,s1,s4
    800001d2:	00000097          	auipc	ra,0x0
    800001d6:	f52080e7          	jalr	-174(ra) # 80000124 <kfree>
    800001da:	94ce                	add	s1,s1,s3
    800001dc:	fe9979e3          	bgeu	s2,s1,800001ce <freerange+0x28>
}
    800001e0:	70a2                	ld	ra,40(sp)
    800001e2:	7402                	ld	s0,32(sp)
    800001e4:	64e2                	ld	s1,24(sp)
    800001e6:	6942                	ld	s2,16(sp)
    800001e8:	69a2                	ld	s3,8(sp)
    800001ea:	6a02                	ld	s4,0(sp)
    800001ec:	6145                	addi	sp,sp,48
    800001ee:	8082                	ret

00000000800001f0 <kinit>:
void kinit() {
    800001f0:	1141                	addi	sp,sp,-16
    800001f2:	e406                	sd	ra,8(sp)
    800001f4:	e022                	sd	s0,0(sp)
    800001f6:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800001f8:	00008597          	auipc	a1,0x8
    800001fc:	e2058593          	addi	a1,a1,-480 # 80008018 <etext+0x18>
    80000200:	00008517          	auipc	a0,0x8
    80000204:	68050513          	addi	a0,a0,1664 # 80008880 <kmem>
    80000208:	00006097          	auipc	ra,0x6
    8000020c:	192080e7          	jalr	402(ra) # 8000639a <initlock>
  freerange(end, (void *)PHYSTOP);
    80000210:	45c5                	li	a1,17
    80000212:	05ee                	slli	a1,a1,0x1b
    80000214:	00042517          	auipc	a0,0x42
    80000218:	adc50513          	addi	a0,a0,-1316 # 80041cf0 <end>
    8000021c:	00000097          	auipc	ra,0x0
    80000220:	f8a080e7          	jalr	-118(ra) # 800001a6 <freerange>
}
    80000224:	60a2                	ld	ra,8(sp)
    80000226:	6402                	ld	s0,0(sp)
    80000228:	0141                	addi	sp,sp,16
    8000022a:	8082                	ret

000000008000022c <kalloc>:

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *kalloc(void) {
    8000022c:	1101                	addi	sp,sp,-32
    8000022e:	ec06                	sd	ra,24(sp)
    80000230:	e822                	sd	s0,16(sp)
    80000232:	e426                	sd	s1,8(sp)
    80000234:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000236:	00008517          	auipc	a0,0x8
    8000023a:	64a50513          	addi	a0,a0,1610 # 80008880 <kmem>
    8000023e:	00006097          	auipc	ra,0x6
    80000242:	1ec080e7          	jalr	492(ra) # 8000642a <acquire>
  r = kmem.freelist;
    80000246:	00008497          	auipc	s1,0x8
    8000024a:	6524b483          	ld	s1,1618(s1) # 80008898 <kmem+0x18>
  if (r) {
    8000024e:	c0a9                	beqz	s1,80000290 <kalloc+0x64>
    kmem.ref_count[pg_num((uint64)r)] = 1;
    80000250:	00008517          	auipc	a0,0x8
    80000254:	63050513          	addi	a0,a0,1584 # 80008880 <kmem>
uint64 pg_num(uint64 pa) { return (PGROUNDDOWN(pa) - KERNBASE) / PGSIZE; }
    80000258:	77fd                	lui	a5,0xfffff
    8000025a:	8fe5                	and	a5,a5,s1
    8000025c:	80000737          	lui	a4,0x80000
    80000260:	97ba                	add	a5,a5,a4
    kmem.ref_count[pg_num((uint64)r)] = 1;
    80000262:	83a9                	srli	a5,a5,0xa
    80000264:	97aa                	add	a5,a5,a0
    80000266:	4705                	li	a4,1
    80000268:	d398                	sw	a4,32(a5)
    kmem.freelist = r->next;
    8000026a:	609c                	ld	a5,0(s1)
    8000026c:	ed1c                	sd	a5,24(a0)
  }
  release(&kmem.lock);
    8000026e:	00006097          	auipc	ra,0x6
    80000272:	270080e7          	jalr	624(ra) # 800064de <release>

  if (r) memset((char *)r, 5, PGSIZE);  // fill with junk
    80000276:	6605                	lui	a2,0x1
    80000278:	4595                	li	a1,5
    8000027a:	8526                	mv	a0,s1
    8000027c:	00000097          	auipc	ra,0x0
    80000280:	026080e7          	jalr	38(ra) # 800002a2 <memset>
  return (void *)r;
}
    80000284:	8526                	mv	a0,s1
    80000286:	60e2                	ld	ra,24(sp)
    80000288:	6442                	ld	s0,16(sp)
    8000028a:	64a2                	ld	s1,8(sp)
    8000028c:	6105                	addi	sp,sp,32
    8000028e:	8082                	ret
  release(&kmem.lock);
    80000290:	00008517          	auipc	a0,0x8
    80000294:	5f050513          	addi	a0,a0,1520 # 80008880 <kmem>
    80000298:	00006097          	auipc	ra,0x6
    8000029c:	246080e7          	jalr	582(ra) # 800064de <release>
  if (r) memset((char *)r, 5, PGSIZE);  // fill with junk
    800002a0:	b7d5                	j	80000284 <kalloc+0x58>

00000000800002a2 <memset>:
#include "types.h"

void *memset(void *dst, int c, uint n) {
    800002a2:	1141                	addi	sp,sp,-16
    800002a4:	e422                	sd	s0,8(sp)
    800002a6:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    800002a8:	ca19                	beqz	a2,800002be <memset+0x1c>
    800002aa:	87aa                	mv	a5,a0
    800002ac:	1602                	slli	a2,a2,0x20
    800002ae:	9201                	srli	a2,a2,0x20
    800002b0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800002b4:	00b78023          	sb	a1,0(a5) # fffffffffffff000 <end+0xffffffff7ffbd310>
  for (i = 0; i < n; i++) {
    800002b8:	0785                	addi	a5,a5,1
    800002ba:	fee79de3          	bne	a5,a4,800002b4 <memset+0x12>
  }
  return dst;
}
    800002be:	6422                	ld	s0,8(sp)
    800002c0:	0141                	addi	sp,sp,16
    800002c2:	8082                	ret

00000000800002c4 <memcmp>:

int memcmp(const void *v1, const void *v2, uint n) {
    800002c4:	1141                	addi	sp,sp,-16
    800002c6:	e422                	sd	s0,8(sp)
    800002c8:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while (n-- > 0) {
    800002ca:	ca05                	beqz	a2,800002fa <memcmp+0x36>
    800002cc:	fff6069b          	addiw	a3,a2,-1
    800002d0:	1682                	slli	a3,a3,0x20
    800002d2:	9281                	srli	a3,a3,0x20
    800002d4:	0685                	addi	a3,a3,1
    800002d6:	96aa                	add	a3,a3,a0
    if (*s1 != *s2) return *s1 - *s2;
    800002d8:	00054783          	lbu	a5,0(a0)
    800002dc:	0005c703          	lbu	a4,0(a1)
    800002e0:	00e79863          	bne	a5,a4,800002f0 <memcmp+0x2c>
    s1++, s2++;
    800002e4:	0505                	addi	a0,a0,1
    800002e6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    800002e8:	fed518e3          	bne	a0,a3,800002d8 <memcmp+0x14>
  }

  return 0;
    800002ec:	4501                	li	a0,0
    800002ee:	a019                	j	800002f4 <memcmp+0x30>
    if (*s1 != *s2) return *s1 - *s2;
    800002f0:	40e7853b          	subw	a0,a5,a4
}
    800002f4:	6422                	ld	s0,8(sp)
    800002f6:	0141                	addi	sp,sp,16
    800002f8:	8082                	ret
  return 0;
    800002fa:	4501                	li	a0,0
    800002fc:	bfe5                	j	800002f4 <memcmp+0x30>

00000000800002fe <memmove>:

void *memmove(void *dst, const void *src, uint n) {
    800002fe:	1141                	addi	sp,sp,-16
    80000300:	e422                	sd	s0,8(sp)
    80000302:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if (n == 0) return dst;
    80000304:	c205                	beqz	a2,80000324 <memmove+0x26>

  s = src;
  d = dst;
  if (s < d && s + n > d) {
    80000306:	02a5e263          	bltu	a1,a0,8000032a <memmove+0x2c>
    s += n;
    d += n;
    while (n-- > 0) *--d = *--s;
  } else
    while (n-- > 0) *d++ = *s++;
    8000030a:	1602                	slli	a2,a2,0x20
    8000030c:	9201                	srli	a2,a2,0x20
    8000030e:	00c587b3          	add	a5,a1,a2
void *memmove(void *dst, const void *src, uint n) {
    80000312:	872a                	mv	a4,a0
    while (n-- > 0) *d++ = *s++;
    80000314:	0585                	addi	a1,a1,1
    80000316:	0705                	addi	a4,a4,1
    80000318:	fff5c683          	lbu	a3,-1(a1)
    8000031c:	fed70fa3          	sb	a3,-1(a4) # ffffffff7fffffff <end+0xfffffffefffbe30f>
    80000320:	fef59ae3          	bne	a1,a5,80000314 <memmove+0x16>

  return dst;
}
    80000324:	6422                	ld	s0,8(sp)
    80000326:	0141                	addi	sp,sp,16
    80000328:	8082                	ret
  if (s < d && s + n > d) {
    8000032a:	02061693          	slli	a3,a2,0x20
    8000032e:	9281                	srli	a3,a3,0x20
    80000330:	00d58733          	add	a4,a1,a3
    80000334:	fce57be3          	bgeu	a0,a4,8000030a <memmove+0xc>
    d += n;
    80000338:	96aa                	add	a3,a3,a0
    while (n-- > 0) *--d = *--s;
    8000033a:	fff6079b          	addiw	a5,a2,-1
    8000033e:	1782                	slli	a5,a5,0x20
    80000340:	9381                	srli	a5,a5,0x20
    80000342:	fff7c793          	not	a5,a5
    80000346:	97ba                	add	a5,a5,a4
    80000348:	177d                	addi	a4,a4,-1
    8000034a:	16fd                	addi	a3,a3,-1
    8000034c:	00074603          	lbu	a2,0(a4)
    80000350:	00c68023          	sb	a2,0(a3)
    80000354:	fee79ae3          	bne	a5,a4,80000348 <memmove+0x4a>
    80000358:	b7f1                	j	80000324 <memmove+0x26>

000000008000035a <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *memcpy(void *dst, const void *src, uint n) {
    8000035a:	1141                	addi	sp,sp,-16
    8000035c:	e406                	sd	ra,8(sp)
    8000035e:	e022                	sd	s0,0(sp)
    80000360:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000362:	00000097          	auipc	ra,0x0
    80000366:	f9c080e7          	jalr	-100(ra) # 800002fe <memmove>
}
    8000036a:	60a2                	ld	ra,8(sp)
    8000036c:	6402                	ld	s0,0(sp)
    8000036e:	0141                	addi	sp,sp,16
    80000370:	8082                	ret

0000000080000372 <strncmp>:

int strncmp(const char *p, const char *q, uint n) {
    80000372:	1141                	addi	sp,sp,-16
    80000374:	e422                	sd	s0,8(sp)
    80000376:	0800                	addi	s0,sp,16
  while (n > 0 && *p && *p == *q) n--, p++, q++;
    80000378:	ce11                	beqz	a2,80000394 <strncmp+0x22>
    8000037a:	00054783          	lbu	a5,0(a0)
    8000037e:	cf89                	beqz	a5,80000398 <strncmp+0x26>
    80000380:	0005c703          	lbu	a4,0(a1)
    80000384:	00f71a63          	bne	a4,a5,80000398 <strncmp+0x26>
    80000388:	367d                	addiw	a2,a2,-1
    8000038a:	0505                	addi	a0,a0,1
    8000038c:	0585                	addi	a1,a1,1
    8000038e:	f675                	bnez	a2,8000037a <strncmp+0x8>
  if (n == 0) return 0;
    80000390:	4501                	li	a0,0
    80000392:	a809                	j	800003a4 <strncmp+0x32>
    80000394:	4501                	li	a0,0
    80000396:	a039                	j	800003a4 <strncmp+0x32>
    80000398:	ca09                	beqz	a2,800003aa <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    8000039a:	00054503          	lbu	a0,0(a0)
    8000039e:	0005c783          	lbu	a5,0(a1)
    800003a2:	9d1d                	subw	a0,a0,a5
}
    800003a4:	6422                	ld	s0,8(sp)
    800003a6:	0141                	addi	sp,sp,16
    800003a8:	8082                	ret
  if (n == 0) return 0;
    800003aa:	4501                	li	a0,0
    800003ac:	bfe5                	j	800003a4 <strncmp+0x32>

00000000800003ae <strncpy>:

char *strncpy(char *s, const char *t, int n) {
    800003ae:	1141                	addi	sp,sp,-16
    800003b0:	e422                	sd	s0,8(sp)
    800003b2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while (n-- > 0 && (*s++ = *t++) != 0)
    800003b4:	872a                	mv	a4,a0
    800003b6:	8832                	mv	a6,a2
    800003b8:	367d                	addiw	a2,a2,-1
    800003ba:	01005963          	blez	a6,800003cc <strncpy+0x1e>
    800003be:	0705                	addi	a4,a4,1
    800003c0:	0005c783          	lbu	a5,0(a1)
    800003c4:	fef70fa3          	sb	a5,-1(a4)
    800003c8:	0585                	addi	a1,a1,1
    800003ca:	f7f5                	bnez	a5,800003b6 <strncpy+0x8>
    ;
  while (n-- > 0) *s++ = 0;
    800003cc:	86ba                	mv	a3,a4
    800003ce:	00c05c63          	blez	a2,800003e6 <strncpy+0x38>
    800003d2:	0685                	addi	a3,a3,1
    800003d4:	fe068fa3          	sb	zero,-1(a3)
    800003d8:	fff6c793          	not	a5,a3
    800003dc:	9fb9                	addw	a5,a5,a4
    800003de:	010787bb          	addw	a5,a5,a6
    800003e2:	fef048e3          	bgtz	a5,800003d2 <strncpy+0x24>
  return os;
}
    800003e6:	6422                	ld	s0,8(sp)
    800003e8:	0141                	addi	sp,sp,16
    800003ea:	8082                	ret

00000000800003ec <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *safestrcpy(char *s, const char *t, int n) {
    800003ec:	1141                	addi	sp,sp,-16
    800003ee:	e422                	sd	s0,8(sp)
    800003f0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if (n <= 0) return os;
    800003f2:	02c05363          	blez	a2,80000418 <safestrcpy+0x2c>
    800003f6:	fff6069b          	addiw	a3,a2,-1
    800003fa:	1682                	slli	a3,a3,0x20
    800003fc:	9281                	srli	a3,a3,0x20
    800003fe:	96ae                	add	a3,a3,a1
    80000400:	87aa                	mv	a5,a0
  while (--n > 0 && (*s++ = *t++) != 0)
    80000402:	00d58963          	beq	a1,a3,80000414 <safestrcpy+0x28>
    80000406:	0585                	addi	a1,a1,1
    80000408:	0785                	addi	a5,a5,1
    8000040a:	fff5c703          	lbu	a4,-1(a1)
    8000040e:	fee78fa3          	sb	a4,-1(a5)
    80000412:	fb65                	bnez	a4,80000402 <safestrcpy+0x16>
    ;
  *s = 0;
    80000414:	00078023          	sb	zero,0(a5)
  return os;
}
    80000418:	6422                	ld	s0,8(sp)
    8000041a:	0141                	addi	sp,sp,16
    8000041c:	8082                	ret

000000008000041e <strlen>:

int strlen(const char *s) {
    8000041e:	1141                	addi	sp,sp,-16
    80000420:	e422                	sd	s0,8(sp)
    80000422:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    80000424:	00054783          	lbu	a5,0(a0)
    80000428:	cf91                	beqz	a5,80000444 <strlen+0x26>
    8000042a:	0505                	addi	a0,a0,1
    8000042c:	87aa                	mv	a5,a0
    8000042e:	4685                	li	a3,1
    80000430:	9e89                	subw	a3,a3,a0
    80000432:	00f6853b          	addw	a0,a3,a5
    80000436:	0785                	addi	a5,a5,1
    80000438:	fff7c703          	lbu	a4,-1(a5)
    8000043c:	fb7d                	bnez	a4,80000432 <strlen+0x14>
    ;
  return n;
}
    8000043e:	6422                	ld	s0,8(sp)
    80000440:	0141                	addi	sp,sp,16
    80000442:	8082                	ret
  for (n = 0; s[n]; n++)
    80000444:	4501                	li	a0,0
    80000446:	bfe5                	j	8000043e <strlen+0x20>

0000000080000448 <main>:
#include "defs.h"

volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void main() {
    80000448:	1141                	addi	sp,sp,-16
    8000044a:	e406                	sd	ra,8(sp)
    8000044c:	e022                	sd	s0,0(sp)
    8000044e:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    80000450:	00001097          	auipc	ra,0x1
    80000454:	ce8080e7          	jalr	-792(ra) # 80001138 <cpuid>
    virtio_disk_init();  // emulated hard disk
    userinit();          // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while (started == 0)
    80000458:	00008717          	auipc	a4,0x8
    8000045c:	3f870713          	addi	a4,a4,1016 # 80008850 <started>
  if (cpuid() == 0) {
    80000460:	c139                	beqz	a0,800004a6 <main+0x5e>
    while (started == 0)
    80000462:	431c                	lw	a5,0(a4)
    80000464:	2781                	sext.w	a5,a5
    80000466:	dff5                	beqz	a5,80000462 <main+0x1a>
      ;
    __sync_synchronize();
    80000468:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000046c:	00001097          	auipc	ra,0x1
    80000470:	ccc080e7          	jalr	-820(ra) # 80001138 <cpuid>
    80000474:	85aa                	mv	a1,a0
    80000476:	00008517          	auipc	a0,0x8
    8000047a:	bc250513          	addi	a0,a0,-1086 # 80008038 <etext+0x38>
    8000047e:	00006097          	auipc	ra,0x6
    80000482:	aba080e7          	jalr	-1350(ra) # 80005f38 <printf>
    kvminithart();   // turn on paging
    80000486:	00000097          	auipc	ra,0x0
    8000048a:	0d8080e7          	jalr	216(ra) # 8000055e <kvminithart>
    trapinithart();  // install kernel trap vector
    8000048e:	00002097          	auipc	ra,0x2
    80000492:	976080e7          	jalr	-1674(ra) # 80001e04 <trapinithart>
    plicinithart();  // ask PLIC for device interrupts
    80000496:	00005097          	auipc	ra,0x5
    8000049a:	f5a080e7          	jalr	-166(ra) # 800053f0 <plicinithart>
  }

  scheduler();
    8000049e:	00001097          	auipc	ra,0x1
    800004a2:	1c0080e7          	jalr	448(ra) # 8000165e <scheduler>
    consoleinit();
    800004a6:	00006097          	auipc	ra,0x6
    800004aa:	95a080e7          	jalr	-1702(ra) # 80005e00 <consoleinit>
    printfinit();
    800004ae:	00006097          	auipc	ra,0x6
    800004b2:	c6a080e7          	jalr	-918(ra) # 80006118 <printfinit>
    printf("\n");
    800004b6:	00008517          	auipc	a0,0x8
    800004ba:	b9250513          	addi	a0,a0,-1134 # 80008048 <etext+0x48>
    800004be:	00006097          	auipc	ra,0x6
    800004c2:	a7a080e7          	jalr	-1414(ra) # 80005f38 <printf>
    printf("xv6 kernel is booting\n");
    800004c6:	00008517          	auipc	a0,0x8
    800004ca:	b5a50513          	addi	a0,a0,-1190 # 80008020 <etext+0x20>
    800004ce:	00006097          	auipc	ra,0x6
    800004d2:	a6a080e7          	jalr	-1430(ra) # 80005f38 <printf>
    printf("\n");
    800004d6:	00008517          	auipc	a0,0x8
    800004da:	b7250513          	addi	a0,a0,-1166 # 80008048 <etext+0x48>
    800004de:	00006097          	auipc	ra,0x6
    800004e2:	a5a080e7          	jalr	-1446(ra) # 80005f38 <printf>
    kinit();             // physical page allocator
    800004e6:	00000097          	auipc	ra,0x0
    800004ea:	d0a080e7          	jalr	-758(ra) # 800001f0 <kinit>
    kvminit();           // create kernel page table
    800004ee:	00000097          	auipc	ra,0x0
    800004f2:	30c080e7          	jalr	780(ra) # 800007fa <kvminit>
    kvminithart();       // turn on paging
    800004f6:	00000097          	auipc	ra,0x0
    800004fa:	068080e7          	jalr	104(ra) # 8000055e <kvminithart>
    procinit();          // process table
    800004fe:	00001097          	auipc	ra,0x1
    80000502:	b86080e7          	jalr	-1146(ra) # 80001084 <procinit>
    trapinit();          // trap vectors
    80000506:	00002097          	auipc	ra,0x2
    8000050a:	8d6080e7          	jalr	-1834(ra) # 80001ddc <trapinit>
    trapinithart();      // install kernel trap vector
    8000050e:	00002097          	auipc	ra,0x2
    80000512:	8f6080e7          	jalr	-1802(ra) # 80001e04 <trapinithart>
    plicinit();          // set up interrupt controller
    80000516:	00005097          	auipc	ra,0x5
    8000051a:	ec4080e7          	jalr	-316(ra) # 800053da <plicinit>
    plicinithart();      // ask PLIC for device interrupts
    8000051e:	00005097          	auipc	ra,0x5
    80000522:	ed2080e7          	jalr	-302(ra) # 800053f0 <plicinithart>
    binit();             // buffer cache
    80000526:	00002097          	auipc	ra,0x2
    8000052a:	060080e7          	jalr	96(ra) # 80002586 <binit>
    iinit();             // inode table
    8000052e:	00002097          	auipc	ra,0x2
    80000532:	704080e7          	jalr	1796(ra) # 80002c32 <iinit>
    fileinit();          // file table
    80000536:	00003097          	auipc	ra,0x3
    8000053a:	6a2080e7          	jalr	1698(ra) # 80003bd8 <fileinit>
    virtio_disk_init();  // emulated hard disk
    8000053e:	00005097          	auipc	ra,0x5
    80000542:	fba080e7          	jalr	-70(ra) # 800054f8 <virtio_disk_init>
    userinit();          // first user process
    80000546:	00001097          	auipc	ra,0x1
    8000054a:	efa080e7          	jalr	-262(ra) # 80001440 <userinit>
    __sync_synchronize();
    8000054e:	0ff0000f          	fence
    started = 1;
    80000552:	4785                	li	a5,1
    80000554:	00008717          	auipc	a4,0x8
    80000558:	2ef72e23          	sw	a5,764(a4) # 80008850 <started>
    8000055c:	b789                	j	8000049e <main+0x56>

000000008000055e <kvminithart>:
// Initialize the one kernel_pagetable
void kvminit(void) { kernel_pagetable = kvmmake(); }

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart() {
    8000055e:	1141                	addi	sp,sp,-16
    80000560:	e422                	sd	s0,8(sp)
    80000562:	0800                	addi	s0,sp,16
}

// flush the TLB.
static inline void sfence_vma() {
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000564:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000568:	00008797          	auipc	a5,0x8
    8000056c:	2f07b783          	ld	a5,752(a5) # 80008858 <kernel_pagetable>
    80000570:	83b1                	srli	a5,a5,0xc
    80000572:	577d                	li	a4,-1
    80000574:	177e                	slli	a4,a4,0x3f
    80000576:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r"(x));
    80000578:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000057c:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000580:	6422                	ld	s0,8(sp)
    80000582:	0141                	addi	sp,sp,16
    80000584:	8082                	ret

0000000080000586 <walk>:
//   39..63 -- must be zero.
//   30..38 -- 9 bits of level-2 index.
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc) {
    80000586:	7139                	addi	sp,sp,-64
    80000588:	fc06                	sd	ra,56(sp)
    8000058a:	f822                	sd	s0,48(sp)
    8000058c:	f426                	sd	s1,40(sp)
    8000058e:	f04a                	sd	s2,32(sp)
    80000590:	ec4e                	sd	s3,24(sp)
    80000592:	e852                	sd	s4,16(sp)
    80000594:	e456                	sd	s5,8(sp)
    80000596:	e05a                	sd	s6,0(sp)
    80000598:	0080                	addi	s0,sp,64
    8000059a:	84aa                	mv	s1,a0
    8000059c:	89ae                	mv	s3,a1
    8000059e:	8ab2                	mv	s5,a2
  if (va >= MAXVA) panic("walk");
    800005a0:	57fd                	li	a5,-1
    800005a2:	83e9                	srli	a5,a5,0x1a
    800005a4:	4a79                	li	s4,30

  for (int level = 2; level > 0; level--) {
    800005a6:	4b31                	li	s6,12
  if (va >= MAXVA) panic("walk");
    800005a8:	04b7f263          	bgeu	a5,a1,800005ec <walk+0x66>
    800005ac:	00008517          	auipc	a0,0x8
    800005b0:	aa450513          	addi	a0,a0,-1372 # 80008050 <etext+0x50>
    800005b4:	00006097          	auipc	ra,0x6
    800005b8:	93a080e7          	jalr	-1734(ra) # 80005eee <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if (*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0) return 0;
    800005bc:	060a8663          	beqz	s5,80000628 <walk+0xa2>
    800005c0:	00000097          	auipc	ra,0x0
    800005c4:	c6c080e7          	jalr	-916(ra) # 8000022c <kalloc>
    800005c8:	84aa                	mv	s1,a0
    800005ca:	c529                	beqz	a0,80000614 <walk+0x8e>
      memset(pagetable, 0, PGSIZE);
    800005cc:	6605                	lui	a2,0x1
    800005ce:	4581                	li	a1,0
    800005d0:	00000097          	auipc	ra,0x0
    800005d4:	cd2080e7          	jalr	-814(ra) # 800002a2 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800005d8:	00c4d793          	srli	a5,s1,0xc
    800005dc:	07aa                	slli	a5,a5,0xa
    800005de:	0017e793          	ori	a5,a5,1
    800005e2:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--) {
    800005e6:	3a5d                	addiw	s4,s4,-9
    800005e8:	036a0063          	beq	s4,s6,80000608 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800005ec:	0149d933          	srl	s2,s3,s4
    800005f0:	1ff97913          	andi	s2,s2,511
    800005f4:	090e                	slli	s2,s2,0x3
    800005f6:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    800005f8:	00093483          	ld	s1,0(s2)
    800005fc:	0014f793          	andi	a5,s1,1
    80000600:	dfd5                	beqz	a5,800005bc <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000602:	80a9                	srli	s1,s1,0xa
    80000604:	04b2                	slli	s1,s1,0xc
    80000606:	b7c5                	j	800005e6 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000608:	00c9d513          	srli	a0,s3,0xc
    8000060c:	1ff57513          	andi	a0,a0,511
    80000610:	050e                	slli	a0,a0,0x3
    80000612:	9526                	add	a0,a0,s1
}
    80000614:	70e2                	ld	ra,56(sp)
    80000616:	7442                	ld	s0,48(sp)
    80000618:	74a2                	ld	s1,40(sp)
    8000061a:	7902                	ld	s2,32(sp)
    8000061c:	69e2                	ld	s3,24(sp)
    8000061e:	6a42                	ld	s4,16(sp)
    80000620:	6aa2                	ld	s5,8(sp)
    80000622:	6b02                	ld	s6,0(sp)
    80000624:	6121                	addi	sp,sp,64
    80000626:	8082                	ret
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0) return 0;
    80000628:	4501                	li	a0,0
    8000062a:	b7ed                	j	80000614 <walk+0x8e>

000000008000062c <walkaddr>:
// Can only be used to look up user pages.
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA) return 0;
    8000062c:	57fd                	li	a5,-1
    8000062e:	83e9                	srli	a5,a5,0x1a
    80000630:	00b7f463          	bgeu	a5,a1,80000638 <walkaddr+0xc>
    80000634:	4501                	li	a0,0
  if (pte == 0) return 0;
  if ((*pte & PTE_V) == 0) return 0;
  if ((*pte & PTE_U) == 0) return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000636:	8082                	ret
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
    80000638:	1141                	addi	sp,sp,-16
    8000063a:	e406                	sd	ra,8(sp)
    8000063c:	e022                	sd	s0,0(sp)
    8000063e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000640:	4601                	li	a2,0
    80000642:	00000097          	auipc	ra,0x0
    80000646:	f44080e7          	jalr	-188(ra) # 80000586 <walk>
  if (pte == 0) return 0;
    8000064a:	c105                	beqz	a0,8000066a <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0) return 0;
    8000064c:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0) return 0;
    8000064e:	0117f693          	andi	a3,a5,17
    80000652:	4745                	li	a4,17
    80000654:	4501                	li	a0,0
    80000656:	00e68663          	beq	a3,a4,80000662 <walkaddr+0x36>
}
    8000065a:	60a2                	ld	ra,8(sp)
    8000065c:	6402                	ld	s0,0(sp)
    8000065e:	0141                	addi	sp,sp,16
    80000660:	8082                	ret
  pa = PTE2PA(*pte);
    80000662:	00a7d513          	srli	a0,a5,0xa
    80000666:	0532                	slli	a0,a0,0xc
  return pa;
    80000668:	bfcd                	j	8000065a <walkaddr+0x2e>
  if (pte == 0) return 0;
    8000066a:	4501                	li	a0,0
    8000066c:	b7fd                	j	8000065a <walkaddr+0x2e>

000000008000066e <mappages>:
// physical addresses starting at pa.
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa,
             int perm) {
    8000066e:	715d                	addi	sp,sp,-80
    80000670:	e486                	sd	ra,72(sp)
    80000672:	e0a2                	sd	s0,64(sp)
    80000674:	fc26                	sd	s1,56(sp)
    80000676:	f84a                	sd	s2,48(sp)
    80000678:	f44e                	sd	s3,40(sp)
    8000067a:	f052                	sd	s4,32(sp)
    8000067c:	ec56                	sd	s5,24(sp)
    8000067e:	e85a                	sd	s6,16(sp)
    80000680:	e45e                	sd	s7,8(sp)
    80000682:	0880                	addi	s0,sp,80
    80000684:	8aaa                	mv	s5,a0
    80000686:	8b3a                	mv	s6,a4
  uint64 a, last;
  pte_t *pte;
  a = va;
  last = va + size - PGSIZE;
    80000688:	79fd                	lui	s3,0xfffff
    8000068a:	964e                	add	a2,a2,s3
    8000068c:	00b609b3          	add	s3,a2,a1
  a = va;
    80000690:	892e                	mv	s2,a1
    80000692:	40b68a33          	sub	s4,a3,a1
  for (;;) {
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    if (*pte & PTE_V) panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last) break;
    a += PGSIZE;
    80000696:	6b85                	lui	s7,0x1
    80000698:	012a04b3          	add	s1,s4,s2
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    8000069c:	4605                	li	a2,1
    8000069e:	85ca                	mv	a1,s2
    800006a0:	8556                	mv	a0,s5
    800006a2:	00000097          	auipc	ra,0x0
    800006a6:	ee4080e7          	jalr	-284(ra) # 80000586 <walk>
    800006aa:	c51d                	beqz	a0,800006d8 <mappages+0x6a>
    if (*pte & PTE_V) panic("mappages: remap");
    800006ac:	611c                	ld	a5,0(a0)
    800006ae:	8b85                	andi	a5,a5,1
    800006b0:	ef81                	bnez	a5,800006c8 <mappages+0x5a>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800006b2:	80b1                	srli	s1,s1,0xc
    800006b4:	04aa                	slli	s1,s1,0xa
    800006b6:	0164e4b3          	or	s1,s1,s6
    800006ba:	0014e493          	ori	s1,s1,1
    800006be:	e104                	sd	s1,0(a0)
    if (a == last) break;
    800006c0:	03390863          	beq	s2,s3,800006f0 <mappages+0x82>
    a += PGSIZE;
    800006c4:	995e                	add	s2,s2,s7
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    800006c6:	bfc9                	j	80000698 <mappages+0x2a>
    if (*pte & PTE_V) panic("mappages: remap");
    800006c8:	00008517          	auipc	a0,0x8
    800006cc:	99050513          	addi	a0,a0,-1648 # 80008058 <etext+0x58>
    800006d0:	00006097          	auipc	ra,0x6
    800006d4:	81e080e7          	jalr	-2018(ra) # 80005eee <panic>
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    800006d8:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800006da:	60a6                	ld	ra,72(sp)
    800006dc:	6406                	ld	s0,64(sp)
    800006de:	74e2                	ld	s1,56(sp)
    800006e0:	7942                	ld	s2,48(sp)
    800006e2:	79a2                	ld	s3,40(sp)
    800006e4:	7a02                	ld	s4,32(sp)
    800006e6:	6ae2                	ld	s5,24(sp)
    800006e8:	6b42                	ld	s6,16(sp)
    800006ea:	6ba2                	ld	s7,8(sp)
    800006ec:	6161                	addi	sp,sp,80
    800006ee:	8082                	ret
  return 0;
    800006f0:	4501                	li	a0,0
    800006f2:	b7e5                	j	800006da <mappages+0x6c>

00000000800006f4 <kvmmap>:
void kvmmap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm) {
    800006f4:	1141                	addi	sp,sp,-16
    800006f6:	e406                	sd	ra,8(sp)
    800006f8:	e022                	sd	s0,0(sp)
    800006fa:	0800                	addi	s0,sp,16
    800006fc:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0) panic("kvmmap");
    800006fe:	86b2                	mv	a3,a2
    80000700:	863e                	mv	a2,a5
    80000702:	00000097          	auipc	ra,0x0
    80000706:	f6c080e7          	jalr	-148(ra) # 8000066e <mappages>
    8000070a:	e509                	bnez	a0,80000714 <kvmmap+0x20>
}
    8000070c:	60a2                	ld	ra,8(sp)
    8000070e:	6402                	ld	s0,0(sp)
    80000710:	0141                	addi	sp,sp,16
    80000712:	8082                	ret
  if (mappages(kpgtbl, va, sz, pa, perm) != 0) panic("kvmmap");
    80000714:	00008517          	auipc	a0,0x8
    80000718:	95450513          	addi	a0,a0,-1708 # 80008068 <etext+0x68>
    8000071c:	00005097          	auipc	ra,0x5
    80000720:	7d2080e7          	jalr	2002(ra) # 80005eee <panic>

0000000080000724 <kvmmake>:
pagetable_t kvmmake(void) {
    80000724:	1101                	addi	sp,sp,-32
    80000726:	ec06                	sd	ra,24(sp)
    80000728:	e822                	sd	s0,16(sp)
    8000072a:	e426                	sd	s1,8(sp)
    8000072c:	e04a                	sd	s2,0(sp)
    8000072e:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    80000730:	00000097          	auipc	ra,0x0
    80000734:	afc080e7          	jalr	-1284(ra) # 8000022c <kalloc>
    80000738:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000073a:	6605                	lui	a2,0x1
    8000073c:	4581                	li	a1,0
    8000073e:	00000097          	auipc	ra,0x0
    80000742:	b64080e7          	jalr	-1180(ra) # 800002a2 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000746:	4719                	li	a4,6
    80000748:	6685                	lui	a3,0x1
    8000074a:	10000637          	lui	a2,0x10000
    8000074e:	100005b7          	lui	a1,0x10000
    80000752:	8526                	mv	a0,s1
    80000754:	00000097          	auipc	ra,0x0
    80000758:	fa0080e7          	jalr	-96(ra) # 800006f4 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000075c:	4719                	li	a4,6
    8000075e:	6685                	lui	a3,0x1
    80000760:	10001637          	lui	a2,0x10001
    80000764:	100015b7          	lui	a1,0x10001
    80000768:	8526                	mv	a0,s1
    8000076a:	00000097          	auipc	ra,0x0
    8000076e:	f8a080e7          	jalr	-118(ra) # 800006f4 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000772:	4719                	li	a4,6
    80000774:	004006b7          	lui	a3,0x400
    80000778:	0c000637          	lui	a2,0xc000
    8000077c:	0c0005b7          	lui	a1,0xc000
    80000780:	8526                	mv	a0,s1
    80000782:	00000097          	auipc	ra,0x0
    80000786:	f72080e7          	jalr	-142(ra) # 800006f4 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    8000078a:	00008917          	auipc	s2,0x8
    8000078e:	87690913          	addi	s2,s2,-1930 # 80008000 <etext>
    80000792:	4729                	li	a4,10
    80000794:	80008697          	auipc	a3,0x80008
    80000798:	86c68693          	addi	a3,a3,-1940 # 8000 <_entry-0x7fff8000>
    8000079c:	4605                	li	a2,1
    8000079e:	067e                	slli	a2,a2,0x1f
    800007a0:	85b2                	mv	a1,a2
    800007a2:	8526                	mv	a0,s1
    800007a4:	00000097          	auipc	ra,0x0
    800007a8:	f50080e7          	jalr	-176(ra) # 800006f4 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext,
    800007ac:	4719                	li	a4,6
    800007ae:	46c5                	li	a3,17
    800007b0:	06ee                	slli	a3,a3,0x1b
    800007b2:	412686b3          	sub	a3,a3,s2
    800007b6:	864a                	mv	a2,s2
    800007b8:	85ca                	mv	a1,s2
    800007ba:	8526                	mv	a0,s1
    800007bc:	00000097          	auipc	ra,0x0
    800007c0:	f38080e7          	jalr	-200(ra) # 800006f4 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800007c4:	4729                	li	a4,10
    800007c6:	6685                	lui	a3,0x1
    800007c8:	00007617          	auipc	a2,0x7
    800007cc:	83860613          	addi	a2,a2,-1992 # 80007000 <_trampoline>
    800007d0:	040005b7          	lui	a1,0x4000
    800007d4:	15fd                	addi	a1,a1,-1
    800007d6:	05b2                	slli	a1,a1,0xc
    800007d8:	8526                	mv	a0,s1
    800007da:	00000097          	auipc	ra,0x0
    800007de:	f1a080e7          	jalr	-230(ra) # 800006f4 <kvmmap>
  proc_mapstacks(kpgtbl);
    800007e2:	8526                	mv	a0,s1
    800007e4:	00001097          	auipc	ra,0x1
    800007e8:	80a080e7          	jalr	-2038(ra) # 80000fee <proc_mapstacks>
}
    800007ec:	8526                	mv	a0,s1
    800007ee:	60e2                	ld	ra,24(sp)
    800007f0:	6442                	ld	s0,16(sp)
    800007f2:	64a2                	ld	s1,8(sp)
    800007f4:	6902                	ld	s2,0(sp)
    800007f6:	6105                	addi	sp,sp,32
    800007f8:	8082                	ret

00000000800007fa <kvminit>:
void kvminit(void) { kernel_pagetable = kvmmake(); }
    800007fa:	1141                	addi	sp,sp,-16
    800007fc:	e406                	sd	ra,8(sp)
    800007fe:	e022                	sd	s0,0(sp)
    80000800:	0800                	addi	s0,sp,16
    80000802:	00000097          	auipc	ra,0x0
    80000806:	f22080e7          	jalr	-222(ra) # 80000724 <kvmmake>
    8000080a:	00008797          	auipc	a5,0x8
    8000080e:	04a7b723          	sd	a0,78(a5) # 80008858 <kernel_pagetable>
    80000812:	60a2                	ld	ra,8(sp)
    80000814:	6402                	ld	s0,0(sp)
    80000816:	0141                	addi	sp,sp,16
    80000818:	8082                	ret

000000008000081a <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free) {
    8000081a:	715d                	addi	sp,sp,-80
    8000081c:	e486                	sd	ra,72(sp)
    8000081e:	e0a2                	sd	s0,64(sp)
    80000820:	fc26                	sd	s1,56(sp)
    80000822:	f84a                	sd	s2,48(sp)
    80000824:	f44e                	sd	s3,40(sp)
    80000826:	f052                	sd	s4,32(sp)
    80000828:	ec56                	sd	s5,24(sp)
    8000082a:	e85a                	sd	s6,16(sp)
    8000082c:	e45e                	sd	s7,8(sp)
    8000082e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0) panic("uvmunmap: not aligned");
    80000830:	03459793          	slli	a5,a1,0x34
    80000834:	e795                	bnez	a5,80000860 <uvmunmap+0x46>
    80000836:	8a2a                	mv	s4,a0
    80000838:	892e                	mv	s2,a1
    8000083a:	8b36                	mv	s6,a3

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8000083c:	0632                	slli	a2,a2,0xc
    8000083e:	00b609b3          	add	s3,a2,a1
    if ((pte = walk(pagetable, a, 0)) == 0) continue;
    if ((*pte & PTE_V) == 0) continue;
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    80000842:	4b85                	li	s7,1
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80000844:	6a85                	lui	s5,0x1
    80000846:	0535e263          	bltu	a1,s3,8000088a <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
  }
}
    8000084a:	60a6                	ld	ra,72(sp)
    8000084c:	6406                	ld	s0,64(sp)
    8000084e:	74e2                	ld	s1,56(sp)
    80000850:	7942                	ld	s2,48(sp)
    80000852:	79a2                	ld	s3,40(sp)
    80000854:	7a02                	ld	s4,32(sp)
    80000856:	6ae2                	ld	s5,24(sp)
    80000858:	6b42                	ld	s6,16(sp)
    8000085a:	6ba2                	ld	s7,8(sp)
    8000085c:	6161                	addi	sp,sp,80
    8000085e:	8082                	ret
  if ((va % PGSIZE) != 0) panic("uvmunmap: not aligned");
    80000860:	00008517          	auipc	a0,0x8
    80000864:	81050513          	addi	a0,a0,-2032 # 80008070 <etext+0x70>
    80000868:	00005097          	auipc	ra,0x5
    8000086c:	686080e7          	jalr	1670(ra) # 80005eee <panic>
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    80000870:	00008517          	auipc	a0,0x8
    80000874:	81850513          	addi	a0,a0,-2024 # 80008088 <etext+0x88>
    80000878:	00005097          	auipc	ra,0x5
    8000087c:	676080e7          	jalr	1654(ra) # 80005eee <panic>
    *pte = 0;
    80000880:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80000884:	9956                	add	s2,s2,s5
    80000886:	fd3972e3          	bgeu	s2,s3,8000084a <uvmunmap+0x30>
    if ((pte = walk(pagetable, a, 0)) == 0) continue;
    8000088a:	4601                	li	a2,0
    8000088c:	85ca                	mv	a1,s2
    8000088e:	8552                	mv	a0,s4
    80000890:	00000097          	auipc	ra,0x0
    80000894:	cf6080e7          	jalr	-778(ra) # 80000586 <walk>
    80000898:	84aa                	mv	s1,a0
    8000089a:	d56d                	beqz	a0,80000884 <uvmunmap+0x6a>
    if ((*pte & PTE_V) == 0) continue;
    8000089c:	611c                	ld	a5,0(a0)
    8000089e:	0017f713          	andi	a4,a5,1
    800008a2:	d36d                	beqz	a4,80000884 <uvmunmap+0x6a>
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    800008a4:	3ff7f713          	andi	a4,a5,1023
    800008a8:	fd7704e3          	beq	a4,s7,80000870 <uvmunmap+0x56>
    if (do_free) {
    800008ac:	fc0b0ae3          	beqz	s6,80000880 <uvmunmap+0x66>
      uint64 pa = PTE2PA(*pte);
    800008b0:	83a9                	srli	a5,a5,0xa
      kfree((void *)pa);
    800008b2:	00c79513          	slli	a0,a5,0xc
    800008b6:	00000097          	auipc	ra,0x0
    800008ba:	86e080e7          	jalr	-1938(ra) # 80000124 <kfree>
    800008be:	b7c9                	j	80000880 <uvmunmap+0x66>

00000000800008c0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t uvmcreate() {
    800008c0:	1101                	addi	sp,sp,-32
    800008c2:	ec06                	sd	ra,24(sp)
    800008c4:	e822                	sd	s0,16(sp)
    800008c6:	e426                	sd	s1,8(sp)
    800008c8:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    800008ca:	00000097          	auipc	ra,0x0
    800008ce:	962080e7          	jalr	-1694(ra) # 8000022c <kalloc>
    800008d2:	84aa                	mv	s1,a0
  if (pagetable == 0) return 0;
    800008d4:	c519                	beqz	a0,800008e2 <uvmcreate+0x22>
  memset(pagetable, 0, PGSIZE);
    800008d6:	6605                	lui	a2,0x1
    800008d8:	4581                	li	a1,0
    800008da:	00000097          	auipc	ra,0x0
    800008de:	9c8080e7          	jalr	-1592(ra) # 800002a2 <memset>
  return pagetable;
}
    800008e2:	8526                	mv	a0,s1
    800008e4:	60e2                	ld	ra,24(sp)
    800008e6:	6442                	ld	s0,16(sp)
    800008e8:	64a2                	ld	s1,8(sp)
    800008ea:	6105                	addi	sp,sp,32
    800008ec:	8082                	ret

00000000800008ee <uvmfirst>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvmfirst(pagetable_t pagetable, uchar *src, uint sz) {
    800008ee:	7179                	addi	sp,sp,-48
    800008f0:	f406                	sd	ra,40(sp)
    800008f2:	f022                	sd	s0,32(sp)
    800008f4:	ec26                	sd	s1,24(sp)
    800008f6:	e84a                	sd	s2,16(sp)
    800008f8:	e44e                	sd	s3,8(sp)
    800008fa:	e052                	sd	s4,0(sp)
    800008fc:	1800                	addi	s0,sp,48
  char *mem;

  if (sz >= PGSIZE) panic("uvmfirst: more than a page");
    800008fe:	6785                	lui	a5,0x1
    80000900:	04f67863          	bgeu	a2,a5,80000950 <uvmfirst+0x62>
    80000904:	8a2a                	mv	s4,a0
    80000906:	89ae                	mv	s3,a1
    80000908:	84b2                	mv	s1,a2
  mem = kalloc();
    8000090a:	00000097          	auipc	ra,0x0
    8000090e:	922080e7          	jalr	-1758(ra) # 8000022c <kalloc>
    80000912:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000914:	6605                	lui	a2,0x1
    80000916:	4581                	li	a1,0
    80000918:	00000097          	auipc	ra,0x0
    8000091c:	98a080e7          	jalr	-1654(ra) # 800002a2 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    80000920:	4779                	li	a4,30
    80000922:	86ca                	mv	a3,s2
    80000924:	6605                	lui	a2,0x1
    80000926:	4581                	li	a1,0
    80000928:	8552                	mv	a0,s4
    8000092a:	00000097          	auipc	ra,0x0
    8000092e:	d44080e7          	jalr	-700(ra) # 8000066e <mappages>
  memmove(mem, src, sz);
    80000932:	8626                	mv	a2,s1
    80000934:	85ce                	mv	a1,s3
    80000936:	854a                	mv	a0,s2
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	9c6080e7          	jalr	-1594(ra) # 800002fe <memmove>
}
    80000940:	70a2                	ld	ra,40(sp)
    80000942:	7402                	ld	s0,32(sp)
    80000944:	64e2                	ld	s1,24(sp)
    80000946:	6942                	ld	s2,16(sp)
    80000948:	69a2                	ld	s3,8(sp)
    8000094a:	6a02                	ld	s4,0(sp)
    8000094c:	6145                	addi	sp,sp,48
    8000094e:	8082                	ret
  if (sz >= PGSIZE) panic("uvmfirst: more than a page");
    80000950:	00007517          	auipc	a0,0x7
    80000954:	75050513          	addi	a0,a0,1872 # 800080a0 <etext+0xa0>
    80000958:	00005097          	auipc	ra,0x5
    8000095c:	596080e7          	jalr	1430(ra) # 80005eee <panic>

0000000080000960 <uvmdealloc>:

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64 uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz) {
    80000960:	1101                	addi	sp,sp,-32
    80000962:	ec06                	sd	ra,24(sp)
    80000964:	e822                	sd	s0,16(sp)
    80000966:	e426                	sd	s1,8(sp)
    80000968:	1000                	addi	s0,sp,32
  if (newsz >= oldsz) return oldsz;
    8000096a:	84ae                	mv	s1,a1
    8000096c:	00b67d63          	bgeu	a2,a1,80000986 <uvmdealloc+0x26>
    80000970:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    80000972:	6785                	lui	a5,0x1
    80000974:	17fd                	addi	a5,a5,-1
    80000976:	00f60733          	add	a4,a2,a5
    8000097a:	767d                	lui	a2,0xfffff
    8000097c:	8f71                	and	a4,a4,a2
    8000097e:	97ae                	add	a5,a5,a1
    80000980:	8ff1                	and	a5,a5,a2
    80000982:	00f76863          	bltu	a4,a5,80000992 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000986:	8526                	mv	a0,s1
    80000988:	60e2                	ld	ra,24(sp)
    8000098a:	6442                	ld	s0,16(sp)
    8000098c:	64a2                	ld	s1,8(sp)
    8000098e:	6105                	addi	sp,sp,32
    80000990:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000992:	8f99                	sub	a5,a5,a4
    80000994:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000996:	4685                	li	a3,1
    80000998:	0007861b          	sext.w	a2,a5
    8000099c:	85ba                	mv	a1,a4
    8000099e:	00000097          	auipc	ra,0x0
    800009a2:	e7c080e7          	jalr	-388(ra) # 8000081a <uvmunmap>
    800009a6:	b7c5                	j	80000986 <uvmdealloc+0x26>

00000000800009a8 <uvmalloc>:
  if (newsz < oldsz) return oldsz;
    800009a8:	0ab66563          	bltu	a2,a1,80000a52 <uvmalloc+0xaa>
uint64 uvmalloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz, int xperm) {
    800009ac:	7139                	addi	sp,sp,-64
    800009ae:	fc06                	sd	ra,56(sp)
    800009b0:	f822                	sd	s0,48(sp)
    800009b2:	f426                	sd	s1,40(sp)
    800009b4:	f04a                	sd	s2,32(sp)
    800009b6:	ec4e                	sd	s3,24(sp)
    800009b8:	e852                	sd	s4,16(sp)
    800009ba:	e456                	sd	s5,8(sp)
    800009bc:	e05a                	sd	s6,0(sp)
    800009be:	0080                	addi	s0,sp,64
    800009c0:	8aaa                	mv	s5,a0
    800009c2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800009c4:	6985                	lui	s3,0x1
    800009c6:	19fd                	addi	s3,s3,-1
    800009c8:	95ce                	add	a1,a1,s3
    800009ca:	79fd                	lui	s3,0xfffff
    800009cc:	0135f9b3          	and	s3,a1,s3
  for (a = oldsz; a < newsz; a += PGSIZE) {
    800009d0:	08c9f363          	bgeu	s3,a2,80000a56 <uvmalloc+0xae>
    800009d4:	894e                	mv	s2,s3
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    800009d6:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800009da:	00000097          	auipc	ra,0x0
    800009de:	852080e7          	jalr	-1966(ra) # 8000022c <kalloc>
    800009e2:	84aa                	mv	s1,a0
    if (mem == 0) {
    800009e4:	c51d                	beqz	a0,80000a12 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800009e6:	6605                	lui	a2,0x1
    800009e8:	4581                	li	a1,0
    800009ea:	00000097          	auipc	ra,0x0
    800009ee:	8b8080e7          	jalr	-1864(ra) # 800002a2 <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    800009f2:	875a                	mv	a4,s6
    800009f4:	86a6                	mv	a3,s1
    800009f6:	6605                	lui	a2,0x1
    800009f8:	85ca                	mv	a1,s2
    800009fa:	8556                	mv	a0,s5
    800009fc:	00000097          	auipc	ra,0x0
    80000a00:	c72080e7          	jalr	-910(ra) # 8000066e <mappages>
    80000a04:	e90d                	bnez	a0,80000a36 <uvmalloc+0x8e>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    80000a06:	6785                	lui	a5,0x1
    80000a08:	993e                	add	s2,s2,a5
    80000a0a:	fd4968e3          	bltu	s2,s4,800009da <uvmalloc+0x32>
  return newsz;
    80000a0e:	8552                	mv	a0,s4
    80000a10:	a809                	j	80000a22 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000a12:	864e                	mv	a2,s3
    80000a14:	85ca                	mv	a1,s2
    80000a16:	8556                	mv	a0,s5
    80000a18:	00000097          	auipc	ra,0x0
    80000a1c:	f48080e7          	jalr	-184(ra) # 80000960 <uvmdealloc>
      return 0;
    80000a20:	4501                	li	a0,0
}
    80000a22:	70e2                	ld	ra,56(sp)
    80000a24:	7442                	ld	s0,48(sp)
    80000a26:	74a2                	ld	s1,40(sp)
    80000a28:	7902                	ld	s2,32(sp)
    80000a2a:	69e2                	ld	s3,24(sp)
    80000a2c:	6a42                	ld	s4,16(sp)
    80000a2e:	6aa2                	ld	s5,8(sp)
    80000a30:	6b02                	ld	s6,0(sp)
    80000a32:	6121                	addi	sp,sp,64
    80000a34:	8082                	ret
      kfree(mem);
    80000a36:	8526                	mv	a0,s1
    80000a38:	fffff097          	auipc	ra,0xfffff
    80000a3c:	6ec080e7          	jalr	1772(ra) # 80000124 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000a40:	864e                	mv	a2,s3
    80000a42:	85ca                	mv	a1,s2
    80000a44:	8556                	mv	a0,s5
    80000a46:	00000097          	auipc	ra,0x0
    80000a4a:	f1a080e7          	jalr	-230(ra) # 80000960 <uvmdealloc>
      return 0;
    80000a4e:	4501                	li	a0,0
    80000a50:	bfc9                	j	80000a22 <uvmalloc+0x7a>
  if (newsz < oldsz) return oldsz;
    80000a52:	852e                	mv	a0,a1
}
    80000a54:	8082                	ret
  return newsz;
    80000a56:	8532                	mv	a0,a2
    80000a58:	b7e9                	j	80000a22 <uvmalloc+0x7a>

0000000080000a5a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable) {
    80000a5a:	7179                	addi	sp,sp,-48
    80000a5c:	f406                	sd	ra,40(sp)
    80000a5e:	f022                	sd	s0,32(sp)
    80000a60:	ec26                	sd	s1,24(sp)
    80000a62:	e84a                	sd	s2,16(sp)
    80000a64:	e44e                	sd	s3,8(sp)
    80000a66:	e052                	sd	s4,0(sp)
    80000a68:	1800                	addi	s0,sp,48
    80000a6a:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    80000a6c:	84aa                	mv	s1,a0
    80000a6e:	6905                	lui	s2,0x1
    80000a70:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80000a72:	4985                	li	s3,1
    80000a74:	a821                	j	80000a8c <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000a76:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000a78:	0532                	slli	a0,a0,0xc
    80000a7a:	00000097          	auipc	ra,0x0
    80000a7e:	fe0080e7          	jalr	-32(ra) # 80000a5a <freewalk>
      pagetable[i] = 0;
    80000a82:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++) {
    80000a86:	04a1                	addi	s1,s1,8
    80000a88:	03248163          	beq	s1,s2,80000aaa <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000a8c:	6088                	ld	a0,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80000a8e:	00f57793          	andi	a5,a0,15
    80000a92:	ff3782e3          	beq	a5,s3,80000a76 <freewalk+0x1c>
    } else if (pte & PTE_V) {
    80000a96:	8905                	andi	a0,a0,1
    80000a98:	d57d                	beqz	a0,80000a86 <freewalk+0x2c>
      panic("freewalk: leaf");
    80000a9a:	00007517          	auipc	a0,0x7
    80000a9e:	62650513          	addi	a0,a0,1574 # 800080c0 <etext+0xc0>
    80000aa2:	00005097          	auipc	ra,0x5
    80000aa6:	44c080e7          	jalr	1100(ra) # 80005eee <panic>
    }
  }
  kfree((void *)pagetable);
    80000aaa:	8552                	mv	a0,s4
    80000aac:	fffff097          	auipc	ra,0xfffff
    80000ab0:	678080e7          	jalr	1656(ra) # 80000124 <kfree>
}
    80000ab4:	70a2                	ld	ra,40(sp)
    80000ab6:	7402                	ld	s0,32(sp)
    80000ab8:	64e2                	ld	s1,24(sp)
    80000aba:	6942                	ld	s2,16(sp)
    80000abc:	69a2                	ld	s3,8(sp)
    80000abe:	6a02                	ld	s4,0(sp)
    80000ac0:	6145                	addi	sp,sp,48
    80000ac2:	8082                	ret

0000000080000ac4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz) {
    80000ac4:	1101                	addi	sp,sp,-32
    80000ac6:	ec06                	sd	ra,24(sp)
    80000ac8:	e822                	sd	s0,16(sp)
    80000aca:	e426                	sd	s1,8(sp)
    80000acc:	1000                	addi	s0,sp,32
    80000ace:	84aa                	mv	s1,a0
  if (sz > 0) uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80000ad0:	e999                	bnez	a1,80000ae6 <uvmfree+0x22>
  freewalk(pagetable);
    80000ad2:	8526                	mv	a0,s1
    80000ad4:	00000097          	auipc	ra,0x0
    80000ad8:	f86080e7          	jalr	-122(ra) # 80000a5a <freewalk>
}
    80000adc:	60e2                	ld	ra,24(sp)
    80000ade:	6442                	ld	s0,16(sp)
    80000ae0:	64a2                	ld	s1,8(sp)
    80000ae2:	6105                	addi	sp,sp,32
    80000ae4:	8082                	ret
  if (sz > 0) uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80000ae6:	6605                	lui	a2,0x1
    80000ae8:	167d                	addi	a2,a2,-1
    80000aea:	962e                	add	a2,a2,a1
    80000aec:	4685                	li	a3,1
    80000aee:	8231                	srli	a2,a2,0xc
    80000af0:	4581                	li	a1,0
    80000af2:	00000097          	auipc	ra,0x0
    80000af6:	d28080e7          	jalr	-728(ra) # 8000081a <uvmunmap>
    80000afa:	bfe1                	j	80000ad2 <uvmfree+0xe>

0000000080000afc <uvmcopy>:
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
  pte_t *pte;
  uint64 i;
  for (i = 0; i < sz; i += PGSIZE) {
    80000afc:	c255                	beqz	a2,80000ba0 <uvmcopy+0xa4>
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
    80000afe:	7139                	addi	sp,sp,-64
    80000b00:	fc06                	sd	ra,56(sp)
    80000b02:	f822                	sd	s0,48(sp)
    80000b04:	f426                	sd	s1,40(sp)
    80000b06:	f04a                	sd	s2,32(sp)
    80000b08:	ec4e                	sd	s3,24(sp)
    80000b0a:	e852                	sd	s4,16(sp)
    80000b0c:	e456                	sd	s5,8(sp)
    80000b0e:	0080                	addi	s0,sp,64
    80000b10:	8a2a                	mv	s4,a0
    80000b12:	8aae                	mv	s5,a1
    80000b14:	89b2                	mv	s3,a2
  for (i = 0; i < sz; i += PGSIZE) {
    80000b16:	4901                	li	s2,0
    80000b18:	a815                	j	80000b4c <uvmcopy+0x50>
    if ((*pte & PTE_V) == 0) continue;
    if (*pte & PTE_W) {
      *pte &= ~PTE_W;
      *pte |= PTE_RSW;
    }
    if (mappages(new, i, PGSIZE, PTE2PA(*pte), PTE_FLAGS(*pte)) != 0) {
    80000b1a:	6098                	ld	a4,0(s1)
    80000b1c:	00a75693          	srli	a3,a4,0xa
    80000b20:	3ff77713          	andi	a4,a4,1023
    80000b24:	06b2                	slli	a3,a3,0xc
    80000b26:	6605                	lui	a2,0x1
    80000b28:	85ca                	mv	a1,s2
    80000b2a:	8556                	mv	a0,s5
    80000b2c:	00000097          	auipc	ra,0x0
    80000b30:	b42080e7          	jalr	-1214(ra) # 8000066e <mappages>
    80000b34:	e129                	bnez	a0,80000b76 <uvmcopy+0x7a>
      goto err;
    }
    increase_ref((void *)PTE2PA(*pte));
    80000b36:	6088                	ld	a0,0(s1)
    80000b38:	8129                	srli	a0,a0,0xa
    80000b3a:	0532                	slli	a0,a0,0xc
    80000b3c:	fffff097          	auipc	ra,0xfffff
    80000b40:	540080e7          	jalr	1344(ra) # 8000007c <increase_ref>
  for (i = 0; i < sz; i += PGSIZE) {
    80000b44:	6785                	lui	a5,0x1
    80000b46:	993e                	add	s2,s2,a5
    80000b48:	05397263          	bgeu	s2,s3,80000b8c <uvmcopy+0x90>
    if ((pte = walk(old, i, 0)) == 0) continue;
    80000b4c:	4601                	li	a2,0
    80000b4e:	85ca                	mv	a1,s2
    80000b50:	8552                	mv	a0,s4
    80000b52:	00000097          	auipc	ra,0x0
    80000b56:	a34080e7          	jalr	-1484(ra) # 80000586 <walk>
    80000b5a:	84aa                	mv	s1,a0
    80000b5c:	d565                	beqz	a0,80000b44 <uvmcopy+0x48>
    if ((*pte & PTE_V) == 0) continue;
    80000b5e:	611c                	ld	a5,0(a0)
    80000b60:	0017f713          	andi	a4,a5,1
    80000b64:	d365                	beqz	a4,80000b44 <uvmcopy+0x48>
    if (*pte & PTE_W) {
    80000b66:	0047f713          	andi	a4,a5,4
    80000b6a:	db45                	beqz	a4,80000b1a <uvmcopy+0x1e>
      *pte &= ~PTE_W;
    80000b6c:	9bed                	andi	a5,a5,-5
      *pte |= PTE_RSW;
    80000b6e:	1007e793          	ori	a5,a5,256
    80000b72:	e11c                	sd	a5,0(a0)
    80000b74:	b75d                	j	80000b1a <uvmcopy+0x1e>
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b76:	4685                	li	a3,1
    80000b78:	00c95613          	srli	a2,s2,0xc
    80000b7c:	4581                	li	a1,0
    80000b7e:	8556                	mv	a0,s5
    80000b80:	00000097          	auipc	ra,0x0
    80000b84:	c9a080e7          	jalr	-870(ra) # 8000081a <uvmunmap>
  return -1;
    80000b88:	557d                	li	a0,-1
    80000b8a:	a011                	j	80000b8e <uvmcopy+0x92>
  return 0;
    80000b8c:	4501                	li	a0,0
}
    80000b8e:	70e2                	ld	ra,56(sp)
    80000b90:	7442                	ld	s0,48(sp)
    80000b92:	74a2                	ld	s1,40(sp)
    80000b94:	7902                	ld	s2,32(sp)
    80000b96:	69e2                	ld	s3,24(sp)
    80000b98:	6a42                	ld	s4,16(sp)
    80000b9a:	6aa2                	ld	s5,8(sp)
    80000b9c:	6121                	addi	sp,sp,64
    80000b9e:	8082                	ret
  return 0;
    80000ba0:	4501                	li	a0,0
}
    80000ba2:	8082                	ret

0000000080000ba4 <uvmcopy_cow>:
int uvmcopy_cow(pagetable_t old, uint64 addr) {
  pte_t *pte;
  uint64 pa;
  uint flags;
  char *mem;
  if (addr >= MAXVA) {
    80000ba4:	57fd                	li	a5,-1
    80000ba6:	83e9                	srli	a5,a5,0x1a
    80000ba8:	0cb7e563          	bltu	a5,a1,80000c72 <uvmcopy_cow+0xce>
int uvmcopy_cow(pagetable_t old, uint64 addr) {
    80000bac:	7179                	addi	sp,sp,-48
    80000bae:	f406                	sd	ra,40(sp)
    80000bb0:	f022                	sd	s0,32(sp)
    80000bb2:	ec26                	sd	s1,24(sp)
    80000bb4:	e84a                	sd	s2,16(sp)
    80000bb6:	e44e                	sd	s3,8(sp)
    80000bb8:	e052                	sd	s4,0(sp)
    80000bba:	1800                	addi	s0,sp,48
    80000bbc:	89aa                	mv	s3,a0
    80000bbe:	84ae                	mv	s1,a1
    return -1;
  };
  if (((pte = walk(old, addr, 0)) != 0) && ((*pte & PTE_V) != 0) &&
    80000bc0:	4601                	li	a2,0
    80000bc2:	00000097          	auipc	ra,0x0
    80000bc6:	9c4080e7          	jalr	-1596(ra) # 80000586 <walk>
    80000bca:	c519                	beqz	a0,80000bd8 <uvmcopy_cow+0x34>
    80000bcc:	611c                	ld	a5,0(a0)
    80000bce:	1017f793          	andi	a5,a5,257
    80000bd2:	4705                	li	a4,1
    80000bd4:	0ae78163          	beq	a5,a4,80000c76 <uvmcopy_cow+0xd2>
      ((*pte & PTE_RSW) == 0)) {
    return -1;
  }
  pte = walk(old, addr, 0);
    80000bd8:	4601                	li	a2,0
    80000bda:	85a6                	mv	a1,s1
    80000bdc:	854e                	mv	a0,s3
    80000bde:	00000097          	auipc	ra,0x0
    80000be2:	9a8080e7          	jalr	-1624(ra) # 80000586 <walk>
    80000be6:	892a                	mv	s2,a0
  if ((pte == 0 || (*pte & PTE_V) == 0) || (mem = kalloc()) == 0) {
    80000be8:	c93d                	beqz	a0,80000c5e <uvmcopy_cow+0xba>
    80000bea:	611c                	ld	a5,0(a0)
    80000bec:	8b85                	andi	a5,a5,1
    80000bee:	cba5                	beqz	a5,80000c5e <uvmcopy_cow+0xba>
    80000bf0:	fffff097          	auipc	ra,0xfffff
    80000bf4:	63c080e7          	jalr	1596(ra) # 8000022c <kalloc>
    80000bf8:	8a2a                	mv	s4,a0
    80000bfa:	c135                	beqz	a0,80000c5e <uvmcopy_cow+0xba>
    goto err;
  }
  if (pte != 0 && (*pte & PTE_V) != 0) {
    80000bfc:	00093903          	ld	s2,0(s2) # 1000 <_entry-0x7ffff000>
    80000c00:	00197793          	andi	a5,s2,1
      kfree(mem);
      goto err;
    }
  }

  return 0;
    80000c04:	4501                	li	a0,0
  if (pte != 0 && (*pte & PTE_V) != 0) {
    80000c06:	eb89                	bnez	a5,80000c18 <uvmcopy_cow+0x74>

err:
  uvmunmap(old, addr, 1, 1);
  return -1;
}
    80000c08:	70a2                	ld	ra,40(sp)
    80000c0a:	7402                	ld	s0,32(sp)
    80000c0c:	64e2                	ld	s1,24(sp)
    80000c0e:	6942                	ld	s2,16(sp)
    80000c10:	69a2                	ld	s3,8(sp)
    80000c12:	6a02                	ld	s4,0(sp)
    80000c14:	6145                	addi	sp,sp,48
    80000c16:	8082                	ret
    pa = PTE2PA(*pte);
    80000c18:	00a95593          	srli	a1,s2,0xa
    memmove(mem, (char *)pa, PGSIZE);
    80000c1c:	6605                	lui	a2,0x1
    80000c1e:	05b2                	slli	a1,a1,0xc
    80000c20:	8552                	mv	a0,s4
    80000c22:	fffff097          	auipc	ra,0xfffff
    80000c26:	6dc080e7          	jalr	1756(ra) # 800002fe <memmove>
    uvmunmap(old, addr, 1, 1);
    80000c2a:	4685                	li	a3,1
    80000c2c:	4605                	li	a2,1
    80000c2e:	85a6                	mv	a1,s1
    80000c30:	854e                	mv	a0,s3
    80000c32:	00000097          	auipc	ra,0x0
    80000c36:	be8080e7          	jalr	-1048(ra) # 8000081a <uvmunmap>
    flags = (PTE_FLAGS(*pte) & ~PTE_RSW) | PTE_W;
    80000c3a:	2fb97713          	andi	a4,s2,763
    if (mappages(old, addr, PGSIZE, (uint64)mem, flags) != 0) {
    80000c3e:	00476713          	ori	a4,a4,4
    80000c42:	86d2                	mv	a3,s4
    80000c44:	6605                	lui	a2,0x1
    80000c46:	85a6                	mv	a1,s1
    80000c48:	854e                	mv	a0,s3
    80000c4a:	00000097          	auipc	ra,0x0
    80000c4e:	a24080e7          	jalr	-1500(ra) # 8000066e <mappages>
    80000c52:	d95d                	beqz	a0,80000c08 <uvmcopy_cow+0x64>
      kfree(mem);
    80000c54:	8552                	mv	a0,s4
    80000c56:	fffff097          	auipc	ra,0xfffff
    80000c5a:	4ce080e7          	jalr	1230(ra) # 80000124 <kfree>
  uvmunmap(old, addr, 1, 1);
    80000c5e:	4685                	li	a3,1
    80000c60:	4605                	li	a2,1
    80000c62:	85a6                	mv	a1,s1
    80000c64:	854e                	mv	a0,s3
    80000c66:	00000097          	auipc	ra,0x0
    80000c6a:	bb4080e7          	jalr	-1100(ra) # 8000081a <uvmunmap>
  return -1;
    80000c6e:	557d                	li	a0,-1
    80000c70:	bf61                	j	80000c08 <uvmcopy_cow+0x64>
    return -1;
    80000c72:	557d                	li	a0,-1
}
    80000c74:	8082                	ret
    return -1;
    80000c76:	557d                	li	a0,-1
    80000c78:	bf41                	j	80000c08 <uvmcopy_cow+0x64>

0000000080000c7a <uvmclear>:
// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va) {
    80000c7a:	1141                	addi	sp,sp,-16
    80000c7c:	e406                	sd	ra,8(sp)
    80000c7e:	e022                	sd	s0,0(sp)
    80000c80:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80000c82:	4601                	li	a2,0
    80000c84:	00000097          	auipc	ra,0x0
    80000c88:	902080e7          	jalr	-1790(ra) # 80000586 <walk>
  if (pte == 0) panic("uvmclear");
    80000c8c:	c901                	beqz	a0,80000c9c <uvmclear+0x22>
  *pte &= ~PTE_U;
    80000c8e:	611c                	ld	a5,0(a0)
    80000c90:	9bbd                	andi	a5,a5,-17
    80000c92:	e11c                	sd	a5,0(a0)
}
    80000c94:	60a2                	ld	ra,8(sp)
    80000c96:	6402                	ld	s0,0(sp)
    80000c98:	0141                	addi	sp,sp,16
    80000c9a:	8082                	ret
  if (pte == 0) panic("uvmclear");
    80000c9c:	00007517          	auipc	a0,0x7
    80000ca0:	43450513          	addi	a0,a0,1076 # 800080d0 <etext+0xd0>
    80000ca4:	00005097          	auipc	ra,0x5
    80000ca8:	24a080e7          	jalr	586(ra) # 80005eee <panic>

0000000080000cac <copyout>:
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
  void *mem;
  pte_t *pte;
  uint64 n, va0, pa0;

  while (len > 0) {
    80000cac:	c2f5                	beqz	a3,80000d90 <copyout+0xe4>
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
    80000cae:	711d                	addi	sp,sp,-96
    80000cb0:	ec86                	sd	ra,88(sp)
    80000cb2:	e8a2                	sd	s0,80(sp)
    80000cb4:	e4a6                	sd	s1,72(sp)
    80000cb6:	e0ca                	sd	s2,64(sp)
    80000cb8:	fc4e                	sd	s3,56(sp)
    80000cba:	f852                	sd	s4,48(sp)
    80000cbc:	f456                	sd	s5,40(sp)
    80000cbe:	f05a                	sd	s6,32(sp)
    80000cc0:	ec5e                	sd	s7,24(sp)
    80000cc2:	e862                	sd	s8,16(sp)
    80000cc4:	e466                	sd	s9,8(sp)
    80000cc6:	1080                	addi	s0,sp,96
    80000cc8:	8baa                	mv	s7,a0
    80000cca:	8aae                	mv	s5,a1
    80000ccc:	8b32                	mv	s6,a2
    80000cce:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80000cd0:	74fd                	lui	s1,0xfffff
    80000cd2:	8ced                	and	s1,s1,a1
    if (va0 >= MAXVA) return -1;
    80000cd4:	57fd                	li	a5,-1
    80000cd6:	83e9                	srli	a5,a5,0x1a
    80000cd8:	0a97ee63          	bltu	a5,s1,80000d94 <copyout+0xe8>
    pte = walk(pagetable, va0, 0);
    if (va0 == 0) return -1;
    if (pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0) return -1;
    80000cdc:	4cc5                	li	s9,17
    if (va0 >= MAXVA) return -1;
    80000cde:	8c3e                	mv	s8,a5
    80000ce0:	a025                	j	80000d08 <copyout+0x5c>
    }
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0) return -1;
    n = PGSIZE - (dstva - va0);
    if (n > len) n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000ce2:	409a84b3          	sub	s1,s5,s1
    80000ce6:	0009861b          	sext.w	a2,s3
    80000cea:	85da                	mv	a1,s6
    80000cec:	9526                	add	a0,a0,s1
    80000cee:	fffff097          	auipc	ra,0xfffff
    80000cf2:	610080e7          	jalr	1552(ra) # 800002fe <memmove>

    len -= n;
    80000cf6:	413a0a33          	sub	s4,s4,s3
    src += n;
    80000cfa:	9b4e                	add	s6,s6,s3
  while (len > 0) {
    80000cfc:	080a0863          	beqz	s4,80000d8c <copyout+0xe0>
    if (va0 >= MAXVA) return -1;
    80000d00:	092c6c63          	bltu	s8,s2,80000d98 <copyout+0xec>
    va0 = PGROUNDDOWN(dstva);
    80000d04:	84ca                	mv	s1,s2
    dstva = va0 + PGSIZE;
    80000d06:	8aca                	mv	s5,s2
    pte = walk(pagetable, va0, 0);
    80000d08:	4601                	li	a2,0
    80000d0a:	85a6                	mv	a1,s1
    80000d0c:	855e                	mv	a0,s7
    80000d0e:	00000097          	auipc	ra,0x0
    80000d12:	878080e7          	jalr	-1928(ra) # 80000586 <walk>
    80000d16:	892a                	mv	s2,a0
    if (va0 == 0) return -1;
    80000d18:	c0d1                	beqz	s1,80000d9c <copyout+0xf0>
    if (pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0) return -1;
    80000d1a:	cd59                	beqz	a0,80000db8 <copyout+0x10c>
    80000d1c:	00053983          	ld	s3,0(a0)
    80000d20:	0119f793          	andi	a5,s3,17
    80000d24:	09979c63          	bne	a5,s9,80000dbc <copyout+0x110>
    if ((*pte & PTE_RSW) != 0) {
    80000d28:	1009f793          	andi	a5,s3,256
    80000d2c:	c3a9                	beqz	a5,80000d6e <copyout+0xc2>
      if ((mem = kalloc()) == 0) return -1;
    80000d2e:	fffff097          	auipc	ra,0xfffff
    80000d32:	4fe080e7          	jalr	1278(ra) # 8000022c <kalloc>
    80000d36:	c549                	beqz	a0,80000dc0 <copyout+0x114>
      *pte = (PA2PTE(mem) | PTE_FLAGS(*pte) | PTE_W) & ~PTE_RSW;
    80000d38:	00c55793          	srli	a5,a0,0xc
    80000d3c:	00a79713          	slli	a4,a5,0xa
    80000d40:	00093783          	ld	a5,0(s2)
    80000d44:	2fb7f793          	andi	a5,a5,763
    80000d48:	8fd9                	or	a5,a5,a4
    80000d4a:	0047e793          	ori	a5,a5,4
    80000d4e:	00f93023          	sd	a5,0(s2)
    uint64 pa = PTE2PA(*pte);
    80000d52:	00a9d993          	srli	s3,s3,0xa
    80000d56:	09b2                	slli	s3,s3,0xc
      memmove(mem, (char *)pa, PGSIZE);
    80000d58:	6605                	lui	a2,0x1
    80000d5a:	85ce                	mv	a1,s3
    80000d5c:	fffff097          	auipc	ra,0xfffff
    80000d60:	5a2080e7          	jalr	1442(ra) # 800002fe <memmove>
      kfree((char *)pa);
    80000d64:	854e                	mv	a0,s3
    80000d66:	fffff097          	auipc	ra,0xfffff
    80000d6a:	3be080e7          	jalr	958(ra) # 80000124 <kfree>
    pa0 = walkaddr(pagetable, va0);
    80000d6e:	85a6                	mv	a1,s1
    80000d70:	855e                	mv	a0,s7
    80000d72:	00000097          	auipc	ra,0x0
    80000d76:	8ba080e7          	jalr	-1862(ra) # 8000062c <walkaddr>
    if (pa0 == 0) return -1;
    80000d7a:	c529                	beqz	a0,80000dc4 <copyout+0x118>
    n = PGSIZE - (dstva - va0);
    80000d7c:	6905                	lui	s2,0x1
    80000d7e:	9926                	add	s2,s2,s1
    80000d80:	415909b3          	sub	s3,s2,s5
    if (n > len) n = len;
    80000d84:	f53a7fe3          	bgeu	s4,s3,80000ce2 <copyout+0x36>
    80000d88:	89d2                	mv	s3,s4
    80000d8a:	bfa1                	j	80000ce2 <copyout+0x36>
  }
  return 0;
    80000d8c:	4501                	li	a0,0
    80000d8e:	a801                	j	80000d9e <copyout+0xf2>
    80000d90:	4501                	li	a0,0
}
    80000d92:	8082                	ret
    if (va0 >= MAXVA) return -1;
    80000d94:	557d                	li	a0,-1
    80000d96:	a021                	j	80000d9e <copyout+0xf2>
    80000d98:	557d                	li	a0,-1
    80000d9a:	a011                	j	80000d9e <copyout+0xf2>
    if (va0 == 0) return -1;
    80000d9c:	557d                	li	a0,-1
}
    80000d9e:	60e6                	ld	ra,88(sp)
    80000da0:	6446                	ld	s0,80(sp)
    80000da2:	64a6                	ld	s1,72(sp)
    80000da4:	6906                	ld	s2,64(sp)
    80000da6:	79e2                	ld	s3,56(sp)
    80000da8:	7a42                	ld	s4,48(sp)
    80000daa:	7aa2                	ld	s5,40(sp)
    80000dac:	7b02                	ld	s6,32(sp)
    80000dae:	6be2                	ld	s7,24(sp)
    80000db0:	6c42                	ld	s8,16(sp)
    80000db2:	6ca2                	ld	s9,8(sp)
    80000db4:	6125                	addi	sp,sp,96
    80000db6:	8082                	ret
    if (pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0) return -1;
    80000db8:	557d                	li	a0,-1
    80000dba:	b7d5                	j	80000d9e <copyout+0xf2>
    80000dbc:	557d                	li	a0,-1
    80000dbe:	b7c5                	j	80000d9e <copyout+0xf2>
      if ((mem = kalloc()) == 0) return -1;
    80000dc0:	557d                	li	a0,-1
    80000dc2:	bff1                	j	80000d9e <copyout+0xf2>
    if (pa0 == 0) return -1;
    80000dc4:	557d                	li	a0,-1
    80000dc6:	bfe1                	j	80000d9e <copyout+0xf2>

0000000080000dc8 <copyin>:
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
  uint64 n, va0, pa0;

  while (len > 0) {
    80000dc8:	caa5                	beqz	a3,80000e38 <copyin+0x70>
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
    80000dca:	715d                	addi	sp,sp,-80
    80000dcc:	e486                	sd	ra,72(sp)
    80000dce:	e0a2                	sd	s0,64(sp)
    80000dd0:	fc26                	sd	s1,56(sp)
    80000dd2:	f84a                	sd	s2,48(sp)
    80000dd4:	f44e                	sd	s3,40(sp)
    80000dd6:	f052                	sd	s4,32(sp)
    80000dd8:	ec56                	sd	s5,24(sp)
    80000dda:	e85a                	sd	s6,16(sp)
    80000ddc:	e45e                	sd	s7,8(sp)
    80000dde:	e062                	sd	s8,0(sp)
    80000de0:	0880                	addi	s0,sp,80
    80000de2:	8b2a                	mv	s6,a0
    80000de4:	8a2e                	mv	s4,a1
    80000de6:	8c32                	mv	s8,a2
    80000de8:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000dea:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0) return -1;
    n = PGSIZE - (srcva - va0);
    80000dec:	6a85                	lui	s5,0x1
    80000dee:	a01d                	j	80000e14 <copyin+0x4c>
    if (n > len) n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000df0:	018505b3          	add	a1,a0,s8
    80000df4:	0004861b          	sext.w	a2,s1
    80000df8:	412585b3          	sub	a1,a1,s2
    80000dfc:	8552                	mv	a0,s4
    80000dfe:	fffff097          	auipc	ra,0xfffff
    80000e02:	500080e7          	jalr	1280(ra) # 800002fe <memmove>

    len -= n;
    80000e06:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000e0a:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000e0c:	01590c33          	add	s8,s2,s5
  while (len > 0) {
    80000e10:	02098263          	beqz	s3,80000e34 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000e14:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000e18:	85ca                	mv	a1,s2
    80000e1a:	855a                	mv	a0,s6
    80000e1c:	00000097          	auipc	ra,0x0
    80000e20:	810080e7          	jalr	-2032(ra) # 8000062c <walkaddr>
    if (pa0 == 0) return -1;
    80000e24:	cd01                	beqz	a0,80000e3c <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000e26:	418904b3          	sub	s1,s2,s8
    80000e2a:	94d6                	add	s1,s1,s5
    if (n > len) n = len;
    80000e2c:	fc99f2e3          	bgeu	s3,s1,80000df0 <copyin+0x28>
    80000e30:	84ce                	mv	s1,s3
    80000e32:	bf7d                	j	80000df0 <copyin+0x28>
  }
  return 0;
    80000e34:	4501                	li	a0,0
    80000e36:	a021                	j	80000e3e <copyin+0x76>
    80000e38:	4501                	li	a0,0
}
    80000e3a:	8082                	ret
    if (pa0 == 0) return -1;
    80000e3c:	557d                	li	a0,-1
}
    80000e3e:	60a6                	ld	ra,72(sp)
    80000e40:	6406                	ld	s0,64(sp)
    80000e42:	74e2                	ld	s1,56(sp)
    80000e44:	7942                	ld	s2,48(sp)
    80000e46:	79a2                	ld	s3,40(sp)
    80000e48:	7a02                	ld	s4,32(sp)
    80000e4a:	6ae2                	ld	s5,24(sp)
    80000e4c:	6b42                	ld	s6,16(sp)
    80000e4e:	6ba2                	ld	s7,8(sp)
    80000e50:	6c02                	ld	s8,0(sp)
    80000e52:	6161                	addi	sp,sp,80
    80000e54:	8082                	ret

0000000080000e56 <copyinstr>:
// Return 0 on success, -1 on error.
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0) {
    80000e56:	c6c5                	beqz	a3,80000efe <copyinstr+0xa8>
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
    80000e58:	715d                	addi	sp,sp,-80
    80000e5a:	e486                	sd	ra,72(sp)
    80000e5c:	e0a2                	sd	s0,64(sp)
    80000e5e:	fc26                	sd	s1,56(sp)
    80000e60:	f84a                	sd	s2,48(sp)
    80000e62:	f44e                	sd	s3,40(sp)
    80000e64:	f052                	sd	s4,32(sp)
    80000e66:	ec56                	sd	s5,24(sp)
    80000e68:	e85a                	sd	s6,16(sp)
    80000e6a:	e45e                	sd	s7,8(sp)
    80000e6c:	0880                	addi	s0,sp,80
    80000e6e:	8a2a                	mv	s4,a0
    80000e70:	8b2e                	mv	s6,a1
    80000e72:	8bb2                	mv	s7,a2
    80000e74:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000e76:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0) return -1;
    n = PGSIZE - (srcva - va0);
    80000e78:	6985                	lui	s3,0x1
    80000e7a:	a035                	j	80000ea6 <copyinstr+0x50>
    if (n > max) n = max;

    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0) {
      if (*p == '\0') {
        *dst = '\0';
    80000e7c:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000e80:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null) {
    80000e82:	0017b793          	seqz	a5,a5
    80000e86:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000e8a:	60a6                	ld	ra,72(sp)
    80000e8c:	6406                	ld	s0,64(sp)
    80000e8e:	74e2                	ld	s1,56(sp)
    80000e90:	7942                	ld	s2,48(sp)
    80000e92:	79a2                	ld	s3,40(sp)
    80000e94:	7a02                	ld	s4,32(sp)
    80000e96:	6ae2                	ld	s5,24(sp)
    80000e98:	6b42                	ld	s6,16(sp)
    80000e9a:	6ba2                	ld	s7,8(sp)
    80000e9c:	6161                	addi	sp,sp,80
    80000e9e:	8082                	ret
    srcva = va0 + PGSIZE;
    80000ea0:	01390bb3          	add	s7,s2,s3
  while (got_null == 0 && max > 0) {
    80000ea4:	c8a9                	beqz	s1,80000ef6 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000ea6:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000eaa:	85ca                	mv	a1,s2
    80000eac:	8552                	mv	a0,s4
    80000eae:	fffff097          	auipc	ra,0xfffff
    80000eb2:	77e080e7          	jalr	1918(ra) # 8000062c <walkaddr>
    if (pa0 == 0) return -1;
    80000eb6:	c131                	beqz	a0,80000efa <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000eb8:	41790833          	sub	a6,s2,s7
    80000ebc:	984e                	add	a6,a6,s3
    if (n > max) n = max;
    80000ebe:	0104f363          	bgeu	s1,a6,80000ec4 <copyinstr+0x6e>
    80000ec2:	8826                	mv	a6,s1
    char *p = (char *)(pa0 + (srcva - va0));
    80000ec4:	955e                	add	a0,a0,s7
    80000ec6:	41250533          	sub	a0,a0,s2
    while (n > 0) {
    80000eca:	fc080be3          	beqz	a6,80000ea0 <copyinstr+0x4a>
    80000ece:	985a                	add	a6,a6,s6
    80000ed0:	87da                	mv	a5,s6
      if (*p == '\0') {
    80000ed2:	41650633          	sub	a2,a0,s6
    80000ed6:	14fd                	addi	s1,s1,-1
    80000ed8:	9b26                	add	s6,s6,s1
    80000eda:	00f60733          	add	a4,a2,a5
    80000ede:	00074703          	lbu	a4,0(a4)
    80000ee2:	df49                	beqz	a4,80000e7c <copyinstr+0x26>
        *dst = *p;
    80000ee4:	00e78023          	sb	a4,0(a5)
      --max;
    80000ee8:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000eec:	0785                	addi	a5,a5,1
    while (n > 0) {
    80000eee:	ff0796e3          	bne	a5,a6,80000eda <copyinstr+0x84>
      dst++;
    80000ef2:	8b42                	mv	s6,a6
    80000ef4:	b775                	j	80000ea0 <copyinstr+0x4a>
    80000ef6:	4781                	li	a5,0
    80000ef8:	b769                	j	80000e82 <copyinstr+0x2c>
    if (pa0 == 0) return -1;
    80000efa:	557d                	li	a0,-1
    80000efc:	b779                	j	80000e8a <copyinstr+0x34>
  int got_null = 0;
    80000efe:	4781                	li	a5,0
  if (got_null) {
    80000f00:	0017b793          	seqz	a5,a5
    80000f04:	40f00533          	neg	a0,a5
}
    80000f08:	8082                	ret

0000000080000f0a <printpgtbl>:

void printpgtbl(int level, pagetable_t pagetable) {
    80000f0a:	7159                	addi	sp,sp,-112
    80000f0c:	f486                	sd	ra,104(sp)
    80000f0e:	f0a2                	sd	s0,96(sp)
    80000f10:	eca6                	sd	s1,88(sp)
    80000f12:	e8ca                	sd	s2,80(sp)
    80000f14:	e4ce                	sd	s3,72(sp)
    80000f16:	e0d2                	sd	s4,64(sp)
    80000f18:	fc56                	sd	s5,56(sp)
    80000f1a:	f85a                	sd	s6,48(sp)
    80000f1c:	f45e                	sd	s7,40(sp)
    80000f1e:	f062                	sd	s8,32(sp)
    80000f20:	ec66                	sd	s9,24(sp)
    80000f22:	e86a                	sd	s10,16(sp)
    80000f24:	e46e                	sd	s11,8(sp)
    80000f26:	1880                	addi	s0,sp,112
    80000f28:	8c2a                	mv	s8,a0
    80000f2a:	89ae                	mv	s3,a1
  int i, cnt;
  pte_t pte;
  uint64 pa;
  for (i = 0; i < 512; i++) {
    80000f2c:	4901                	li	s2,0
    pte = pagetable[i];
    if (pte & PTE_V) {
      for (cnt = level; cnt < 3; cnt++) {
    80000f2e:	4d09                	li	s10,2
        printf(" ..");
      }
      pa = PTE2PA(pte);
      printf("%d: pte %p pa %p\n", i, pte, pa);
    80000f30:	00007c97          	auipc	s9,0x7
    80000f34:	1b8c8c93          	addi	s9,s9,440 # 800080e8 <etext+0xe8>
      if (level > 0) {
        printpgtbl(level - 1, (pagetable_t)pa);
    80000f38:	fff50d9b          	addiw	s11,a0,-1
        printf(" ..");
    80000f3c:	00007b17          	auipc	s6,0x7
    80000f40:	1a4b0b13          	addi	s6,s6,420 # 800080e0 <etext+0xe0>
      for (cnt = level; cnt < 3; cnt++) {
    80000f44:	4a8d                	li	s5,3
  for (i = 0; i < 512; i++) {
    80000f46:	20000b93          	li	s7,512
    80000f4a:	a029                	j	80000f54 <printpgtbl+0x4a>
    80000f4c:	2905                	addiw	s2,s2,1
    80000f4e:	09a1                	addi	s3,s3,8
    80000f50:	05790663          	beq	s2,s7,80000f9c <printpgtbl+0x92>
    pte = pagetable[i];
    80000f54:	0009ba03          	ld	s4,0(s3) # 1000 <_entry-0x7ffff000>
    if (pte & PTE_V) {
    80000f58:	001a7793          	andi	a5,s4,1
    80000f5c:	dbe5                	beqz	a5,80000f4c <printpgtbl+0x42>
      for (cnt = level; cnt < 3; cnt++) {
    80000f5e:	018d4b63          	blt	s10,s8,80000f74 <printpgtbl+0x6a>
    80000f62:	84e2                	mv	s1,s8
        printf(" ..");
    80000f64:	855a                	mv	a0,s6
    80000f66:	00005097          	auipc	ra,0x5
    80000f6a:	fd2080e7          	jalr	-46(ra) # 80005f38 <printf>
      for (cnt = level; cnt < 3; cnt++) {
    80000f6e:	2485                	addiw	s1,s1,1
    80000f70:	ff549ae3          	bne	s1,s5,80000f64 <printpgtbl+0x5a>
      pa = PTE2PA(pte);
    80000f74:	00aa5493          	srli	s1,s4,0xa
    80000f78:	04b2                	slli	s1,s1,0xc
      printf("%d: pte %p pa %p\n", i, pte, pa);
    80000f7a:	86a6                	mv	a3,s1
    80000f7c:	8652                	mv	a2,s4
    80000f7e:	85ca                	mv	a1,s2
    80000f80:	8566                	mv	a0,s9
    80000f82:	00005097          	auipc	ra,0x5
    80000f86:	fb6080e7          	jalr	-74(ra) # 80005f38 <printf>
      if (level > 0) {
    80000f8a:	fd8051e3          	blez	s8,80000f4c <printpgtbl+0x42>
        printpgtbl(level - 1, (pagetable_t)pa);
    80000f8e:	85a6                	mv	a1,s1
    80000f90:	856e                	mv	a0,s11
    80000f92:	00000097          	auipc	ra,0x0
    80000f96:	f78080e7          	jalr	-136(ra) # 80000f0a <printpgtbl>
    80000f9a:	bf4d                	j	80000f4c <printpgtbl+0x42>
      }
    }
  }
}
    80000f9c:	70a6                	ld	ra,104(sp)
    80000f9e:	7406                	ld	s0,96(sp)
    80000fa0:	64e6                	ld	s1,88(sp)
    80000fa2:	6946                	ld	s2,80(sp)
    80000fa4:	69a6                	ld	s3,72(sp)
    80000fa6:	6a06                	ld	s4,64(sp)
    80000fa8:	7ae2                	ld	s5,56(sp)
    80000faa:	7b42                	ld	s6,48(sp)
    80000fac:	7ba2                	ld	s7,40(sp)
    80000fae:	7c02                	ld	s8,32(sp)
    80000fb0:	6ce2                	ld	s9,24(sp)
    80000fb2:	6d42                	ld	s10,16(sp)
    80000fb4:	6da2                	ld	s11,8(sp)
    80000fb6:	6165                	addi	sp,sp,112
    80000fb8:	8082                	ret

0000000080000fba <vmprint>:

void vmprint(pagetable_t pagetable) {
    80000fba:	1101                	addi	sp,sp,-32
    80000fbc:	ec06                	sd	ra,24(sp)
    80000fbe:	e822                	sd	s0,16(sp)
    80000fc0:	e426                	sd	s1,8(sp)
    80000fc2:	1000                	addi	s0,sp,32
    80000fc4:	84aa                	mv	s1,a0
  printf("page table %p\n", pagetable);
    80000fc6:	85aa                	mv	a1,a0
    80000fc8:	00007517          	auipc	a0,0x7
    80000fcc:	13850513          	addi	a0,a0,312 # 80008100 <etext+0x100>
    80000fd0:	00005097          	auipc	ra,0x5
    80000fd4:	f68080e7          	jalr	-152(ra) # 80005f38 <printf>
  printpgtbl(2, pagetable);
    80000fd8:	85a6                	mv	a1,s1
    80000fda:	4509                	li	a0,2
    80000fdc:	00000097          	auipc	ra,0x0
    80000fe0:	f2e080e7          	jalr	-210(ra) # 80000f0a <printpgtbl>
}
    80000fe4:	60e2                	ld	ra,24(sp)
    80000fe6:	6442                	ld	s0,16(sp)
    80000fe8:	64a2                	ld	s1,8(sp)
    80000fea:	6105                	addi	sp,sp,32
    80000fec:	8082                	ret

0000000080000fee <proc_mapstacks>:
struct spinlock wait_lock;

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl) {
    80000fee:	7139                	addi	sp,sp,-64
    80000ff0:	fc06                	sd	ra,56(sp)
    80000ff2:	f822                	sd	s0,48(sp)
    80000ff4:	f426                	sd	s1,40(sp)
    80000ff6:	f04a                	sd	s2,32(sp)
    80000ff8:	ec4e                	sd	s3,24(sp)
    80000ffa:	e852                	sd	s4,16(sp)
    80000ffc:	e456                	sd	s5,8(sp)
    80000ffe:	e05a                	sd	s6,0(sp)
    80001000:	0080                	addi	s0,sp,64
    80001002:	89aa                	mv	s3,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80001004:	00028497          	auipc	s1,0x28
    80001008:	ccc48493          	addi	s1,s1,-820 # 80028cd0 <proc>
    char *pa = kalloc();
    if (pa == 0) panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    8000100c:	8b26                	mv	s6,s1
    8000100e:	00007a97          	auipc	s5,0x7
    80001012:	ff2a8a93          	addi	s5,s5,-14 # 80008000 <etext>
    80001016:	04000937          	lui	s2,0x4000
    8000101a:	197d                	addi	s2,s2,-1
    8000101c:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    8000101e:	0002da17          	auipc	s4,0x2d
    80001022:	6b2a0a13          	addi	s4,s4,1714 # 8002e6d0 <tickslock>
    char *pa = kalloc();
    80001026:	fffff097          	auipc	ra,0xfffff
    8000102a:	206080e7          	jalr	518(ra) # 8000022c <kalloc>
    8000102e:	862a                	mv	a2,a0
    if (pa == 0) panic("kalloc");
    80001030:	c131                	beqz	a0,80001074 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int)(p - proc));
    80001032:	416485b3          	sub	a1,s1,s6
    80001036:	858d                	srai	a1,a1,0x3
    80001038:	000ab783          	ld	a5,0(s5)
    8000103c:	02f585b3          	mul	a1,a1,a5
    80001040:	2585                	addiw	a1,a1,1
    80001042:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001046:	4719                	li	a4,6
    80001048:	6685                	lui	a3,0x1
    8000104a:	40b905b3          	sub	a1,s2,a1
    8000104e:	854e                	mv	a0,s3
    80001050:	fffff097          	auipc	ra,0xfffff
    80001054:	6a4080e7          	jalr	1700(ra) # 800006f4 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001058:	16848493          	addi	s1,s1,360
    8000105c:	fd4495e3          	bne	s1,s4,80001026 <proc_mapstacks+0x38>
  }
}
    80001060:	70e2                	ld	ra,56(sp)
    80001062:	7442                	ld	s0,48(sp)
    80001064:	74a2                	ld	s1,40(sp)
    80001066:	7902                	ld	s2,32(sp)
    80001068:	69e2                	ld	s3,24(sp)
    8000106a:	6a42                	ld	s4,16(sp)
    8000106c:	6aa2                	ld	s5,8(sp)
    8000106e:	6b02                	ld	s6,0(sp)
    80001070:	6121                	addi	sp,sp,64
    80001072:	8082                	ret
    if (pa == 0) panic("kalloc");
    80001074:	00007517          	auipc	a0,0x7
    80001078:	09c50513          	addi	a0,a0,156 # 80008110 <etext+0x110>
    8000107c:	00005097          	auipc	ra,0x5
    80001080:	e72080e7          	jalr	-398(ra) # 80005eee <panic>

0000000080001084 <procinit>:

// initialize the proc table.
void procinit(void) {
    80001084:	7139                	addi	sp,sp,-64
    80001086:	fc06                	sd	ra,56(sp)
    80001088:	f822                	sd	s0,48(sp)
    8000108a:	f426                	sd	s1,40(sp)
    8000108c:	f04a                	sd	s2,32(sp)
    8000108e:	ec4e                	sd	s3,24(sp)
    80001090:	e852                	sd	s4,16(sp)
    80001092:	e456                	sd	s5,8(sp)
    80001094:	e05a                	sd	s6,0(sp)
    80001096:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80001098:	00007597          	auipc	a1,0x7
    8000109c:	08058593          	addi	a1,a1,128 # 80008118 <etext+0x118>
    800010a0:	00028517          	auipc	a0,0x28
    800010a4:	80050513          	addi	a0,a0,-2048 # 800288a0 <pid_lock>
    800010a8:	00005097          	auipc	ra,0x5
    800010ac:	2f2080e7          	jalr	754(ra) # 8000639a <initlock>
  initlock(&wait_lock, "wait_lock");
    800010b0:	00007597          	auipc	a1,0x7
    800010b4:	07058593          	addi	a1,a1,112 # 80008120 <etext+0x120>
    800010b8:	00028517          	auipc	a0,0x28
    800010bc:	80050513          	addi	a0,a0,-2048 # 800288b8 <wait_lock>
    800010c0:	00005097          	auipc	ra,0x5
    800010c4:	2da080e7          	jalr	730(ra) # 8000639a <initlock>
  for (p = proc; p < &proc[NPROC]; p++) {
    800010c8:	00028497          	auipc	s1,0x28
    800010cc:	c0848493          	addi	s1,s1,-1016 # 80028cd0 <proc>
    initlock(&p->lock, "proc");
    800010d0:	00007b17          	auipc	s6,0x7
    800010d4:	060b0b13          	addi	s6,s6,96 # 80008130 <etext+0x130>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    800010d8:	8aa6                	mv	s5,s1
    800010da:	00007a17          	auipc	s4,0x7
    800010de:	f26a0a13          	addi	s4,s4,-218 # 80008000 <etext>
    800010e2:	04000937          	lui	s2,0x4000
    800010e6:	197d                	addi	s2,s2,-1
    800010e8:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    800010ea:	0002d997          	auipc	s3,0x2d
    800010ee:	5e698993          	addi	s3,s3,1510 # 8002e6d0 <tickslock>
    initlock(&p->lock, "proc");
    800010f2:	85da                	mv	a1,s6
    800010f4:	8526                	mv	a0,s1
    800010f6:	00005097          	auipc	ra,0x5
    800010fa:	2a4080e7          	jalr	676(ra) # 8000639a <initlock>
    p->state = UNUSED;
    800010fe:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    80001102:	415487b3          	sub	a5,s1,s5
    80001106:	878d                	srai	a5,a5,0x3
    80001108:	000a3703          	ld	a4,0(s4)
    8000110c:	02e787b3          	mul	a5,a5,a4
    80001110:	2785                	addiw	a5,a5,1
    80001112:	00d7979b          	slliw	a5,a5,0xd
    80001116:	40f907b3          	sub	a5,s2,a5
    8000111a:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++) {
    8000111c:	16848493          	addi	s1,s1,360
    80001120:	fd3499e3          	bne	s1,s3,800010f2 <procinit+0x6e>
  }
}
    80001124:	70e2                	ld	ra,56(sp)
    80001126:	7442                	ld	s0,48(sp)
    80001128:	74a2                	ld	s1,40(sp)
    8000112a:	7902                	ld	s2,32(sp)
    8000112c:	69e2                	ld	s3,24(sp)
    8000112e:	6a42                	ld	s4,16(sp)
    80001130:	6aa2                	ld	s5,8(sp)
    80001132:	6b02                	ld	s6,0(sp)
    80001134:	6121                	addi	sp,sp,64
    80001136:	8082                	ret

0000000080001138 <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid() {
    80001138:	1141                	addi	sp,sp,-16
    8000113a:	e422                	sd	s0,8(sp)
    8000113c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    8000113e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001140:	2501                	sext.w	a0,a0
    80001142:	6422                	ld	s0,8(sp)
    80001144:	0141                	addi	sp,sp,16
    80001146:	8082                	ret

0000000080001148 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *mycpu(void) {
    80001148:	1141                	addi	sp,sp,-16
    8000114a:	e422                	sd	s0,8(sp)
    8000114c:	0800                	addi	s0,sp,16
    8000114e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001150:	2781                	sext.w	a5,a5
    80001152:	079e                	slli	a5,a5,0x7
  return c;
}
    80001154:	00027517          	auipc	a0,0x27
    80001158:	77c50513          	addi	a0,a0,1916 # 800288d0 <cpus>
    8000115c:	953e                	add	a0,a0,a5
    8000115e:	6422                	ld	s0,8(sp)
    80001160:	0141                	addi	sp,sp,16
    80001162:	8082                	ret

0000000080001164 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *myproc(void) {
    80001164:	1101                	addi	sp,sp,-32
    80001166:	ec06                	sd	ra,24(sp)
    80001168:	e822                	sd	s0,16(sp)
    8000116a:	e426                	sd	s1,8(sp)
    8000116c:	1000                	addi	s0,sp,32
  push_off();
    8000116e:	00005097          	auipc	ra,0x5
    80001172:	270080e7          	jalr	624(ra) # 800063de <push_off>
    80001176:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001178:	2781                	sext.w	a5,a5
    8000117a:	079e                	slli	a5,a5,0x7
    8000117c:	00027717          	auipc	a4,0x27
    80001180:	72470713          	addi	a4,a4,1828 # 800288a0 <pid_lock>
    80001184:	97ba                	add	a5,a5,a4
    80001186:	7b84                	ld	s1,48(a5)
  pop_off();
    80001188:	00005097          	auipc	ra,0x5
    8000118c:	2f6080e7          	jalr	758(ra) # 8000647e <pop_off>
  return p;
}
    80001190:	8526                	mv	a0,s1
    80001192:	60e2                	ld	ra,24(sp)
    80001194:	6442                	ld	s0,16(sp)
    80001196:	64a2                	ld	s1,8(sp)
    80001198:	6105                	addi	sp,sp,32
    8000119a:	8082                	ret

000000008000119c <forkret>:
  release(&p->lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void) {
    8000119c:	1141                	addi	sp,sp,-16
    8000119e:	e406                	sd	ra,8(sp)
    800011a0:	e022                	sd	s0,0(sp)
    800011a2:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800011a4:	00000097          	auipc	ra,0x0
    800011a8:	fc0080e7          	jalr	-64(ra) # 80001164 <myproc>
    800011ac:	00005097          	auipc	ra,0x5
    800011b0:	332080e7          	jalr	818(ra) # 800064de <release>

  if (first) {
    800011b4:	00007797          	auipc	a5,0x7
    800011b8:	64c7a783          	lw	a5,1612(a5) # 80008800 <first.1>
    800011bc:	eb89                	bnez	a5,800011ce <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    800011be:	00001097          	auipc	ra,0x1
    800011c2:	c5e080e7          	jalr	-930(ra) # 80001e1c <usertrapret>
}
    800011c6:	60a2                	ld	ra,8(sp)
    800011c8:	6402                	ld	s0,0(sp)
    800011ca:	0141                	addi	sp,sp,16
    800011cc:	8082                	ret
    fsinit(ROOTDEV);
    800011ce:	4505                	li	a0,1
    800011d0:	00002097          	auipc	ra,0x2
    800011d4:	9e2080e7          	jalr	-1566(ra) # 80002bb2 <fsinit>
    first = 0;
    800011d8:	00007797          	auipc	a5,0x7
    800011dc:	6207a423          	sw	zero,1576(a5) # 80008800 <first.1>
    __sync_synchronize();
    800011e0:	0ff0000f          	fence
    800011e4:	bfe9                	j	800011be <forkret+0x22>

00000000800011e6 <allocpid>:
int allocpid() {
    800011e6:	1101                	addi	sp,sp,-32
    800011e8:	ec06                	sd	ra,24(sp)
    800011ea:	e822                	sd	s0,16(sp)
    800011ec:	e426                	sd	s1,8(sp)
    800011ee:	e04a                	sd	s2,0(sp)
    800011f0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800011f2:	00027917          	auipc	s2,0x27
    800011f6:	6ae90913          	addi	s2,s2,1710 # 800288a0 <pid_lock>
    800011fa:	854a                	mv	a0,s2
    800011fc:	00005097          	auipc	ra,0x5
    80001200:	22e080e7          	jalr	558(ra) # 8000642a <acquire>
  pid = nextpid;
    80001204:	00007797          	auipc	a5,0x7
    80001208:	60078793          	addi	a5,a5,1536 # 80008804 <nextpid>
    8000120c:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000120e:	0014871b          	addiw	a4,s1,1
    80001212:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001214:	854a                	mv	a0,s2
    80001216:	00005097          	auipc	ra,0x5
    8000121a:	2c8080e7          	jalr	712(ra) # 800064de <release>
}
    8000121e:	8526                	mv	a0,s1
    80001220:	60e2                	ld	ra,24(sp)
    80001222:	6442                	ld	s0,16(sp)
    80001224:	64a2                	ld	s1,8(sp)
    80001226:	6902                	ld	s2,0(sp)
    80001228:	6105                	addi	sp,sp,32
    8000122a:	8082                	ret

000000008000122c <proc_pagetable>:
pagetable_t proc_pagetable(struct proc *p) {
    8000122c:	1101                	addi	sp,sp,-32
    8000122e:	ec06                	sd	ra,24(sp)
    80001230:	e822                	sd	s0,16(sp)
    80001232:	e426                	sd	s1,8(sp)
    80001234:	e04a                	sd	s2,0(sp)
    80001236:	1000                	addi	s0,sp,32
    80001238:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    8000123a:	fffff097          	auipc	ra,0xfffff
    8000123e:	686080e7          	jalr	1670(ra) # 800008c0 <uvmcreate>
    80001242:	84aa                	mv	s1,a0
  if (pagetable == 0) return 0;
    80001244:	c121                	beqz	a0,80001284 <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    80001246:	4729                	li	a4,10
    80001248:	00006697          	auipc	a3,0x6
    8000124c:	db868693          	addi	a3,a3,-584 # 80007000 <_trampoline>
    80001250:	6605                	lui	a2,0x1
    80001252:	040005b7          	lui	a1,0x4000
    80001256:	15fd                	addi	a1,a1,-1
    80001258:	05b2                	slli	a1,a1,0xc
    8000125a:	fffff097          	auipc	ra,0xfffff
    8000125e:	414080e7          	jalr	1044(ra) # 8000066e <mappages>
    80001262:	02054863          	bltz	a0,80001292 <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    80001266:	4719                	li	a4,6
    80001268:	05893683          	ld	a3,88(s2)
    8000126c:	6605                	lui	a2,0x1
    8000126e:	020005b7          	lui	a1,0x2000
    80001272:	15fd                	addi	a1,a1,-1
    80001274:	05b6                	slli	a1,a1,0xd
    80001276:	8526                	mv	a0,s1
    80001278:	fffff097          	auipc	ra,0xfffff
    8000127c:	3f6080e7          	jalr	1014(ra) # 8000066e <mappages>
    80001280:	02054163          	bltz	a0,800012a2 <proc_pagetable+0x76>
}
    80001284:	8526                	mv	a0,s1
    80001286:	60e2                	ld	ra,24(sp)
    80001288:	6442                	ld	s0,16(sp)
    8000128a:	64a2                	ld	s1,8(sp)
    8000128c:	6902                	ld	s2,0(sp)
    8000128e:	6105                	addi	sp,sp,32
    80001290:	8082                	ret
    uvmfree(pagetable, 0);
    80001292:	4581                	li	a1,0
    80001294:	8526                	mv	a0,s1
    80001296:	00000097          	auipc	ra,0x0
    8000129a:	82e080e7          	jalr	-2002(ra) # 80000ac4 <uvmfree>
    return 0;
    8000129e:	4481                	li	s1,0
    800012a0:	b7d5                	j	80001284 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800012a2:	4681                	li	a3,0
    800012a4:	4605                	li	a2,1
    800012a6:	040005b7          	lui	a1,0x4000
    800012aa:	15fd                	addi	a1,a1,-1
    800012ac:	05b2                	slli	a1,a1,0xc
    800012ae:	8526                	mv	a0,s1
    800012b0:	fffff097          	auipc	ra,0xfffff
    800012b4:	56a080e7          	jalr	1386(ra) # 8000081a <uvmunmap>
    uvmfree(pagetable, 0);
    800012b8:	4581                	li	a1,0
    800012ba:	8526                	mv	a0,s1
    800012bc:	00000097          	auipc	ra,0x0
    800012c0:	808080e7          	jalr	-2040(ra) # 80000ac4 <uvmfree>
    return 0;
    800012c4:	4481                	li	s1,0
    800012c6:	bf7d                	j	80001284 <proc_pagetable+0x58>

00000000800012c8 <proc_freepagetable>:
void proc_freepagetable(pagetable_t pagetable, uint64 sz) {
    800012c8:	1101                	addi	sp,sp,-32
    800012ca:	ec06                	sd	ra,24(sp)
    800012cc:	e822                	sd	s0,16(sp)
    800012ce:	e426                	sd	s1,8(sp)
    800012d0:	e04a                	sd	s2,0(sp)
    800012d2:	1000                	addi	s0,sp,32
    800012d4:	84aa                	mv	s1,a0
    800012d6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800012d8:	4681                	li	a3,0
    800012da:	4605                	li	a2,1
    800012dc:	040005b7          	lui	a1,0x4000
    800012e0:	15fd                	addi	a1,a1,-1
    800012e2:	05b2                	slli	a1,a1,0xc
    800012e4:	fffff097          	auipc	ra,0xfffff
    800012e8:	536080e7          	jalr	1334(ra) # 8000081a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800012ec:	4681                	li	a3,0
    800012ee:	4605                	li	a2,1
    800012f0:	020005b7          	lui	a1,0x2000
    800012f4:	15fd                	addi	a1,a1,-1
    800012f6:	05b6                	slli	a1,a1,0xd
    800012f8:	8526                	mv	a0,s1
    800012fa:	fffff097          	auipc	ra,0xfffff
    800012fe:	520080e7          	jalr	1312(ra) # 8000081a <uvmunmap>
  uvmfree(pagetable, sz);
    80001302:	85ca                	mv	a1,s2
    80001304:	8526                	mv	a0,s1
    80001306:	fffff097          	auipc	ra,0xfffff
    8000130a:	7be080e7          	jalr	1982(ra) # 80000ac4 <uvmfree>
}
    8000130e:	60e2                	ld	ra,24(sp)
    80001310:	6442                	ld	s0,16(sp)
    80001312:	64a2                	ld	s1,8(sp)
    80001314:	6902                	ld	s2,0(sp)
    80001316:	6105                	addi	sp,sp,32
    80001318:	8082                	ret

000000008000131a <freeproc>:
static void freeproc(struct proc *p) {
    8000131a:	1101                	addi	sp,sp,-32
    8000131c:	ec06                	sd	ra,24(sp)
    8000131e:	e822                	sd	s0,16(sp)
    80001320:	e426                	sd	s1,8(sp)
    80001322:	1000                	addi	s0,sp,32
    80001324:	84aa                	mv	s1,a0
  if (p->trapframe) kfree((void *)p->trapframe);
    80001326:	6d28                	ld	a0,88(a0)
    80001328:	c509                	beqz	a0,80001332 <freeproc+0x18>
    8000132a:	fffff097          	auipc	ra,0xfffff
    8000132e:	dfa080e7          	jalr	-518(ra) # 80000124 <kfree>
  p->trapframe = 0;
    80001332:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable) proc_freepagetable(p->pagetable, p->sz);
    80001336:	68a8                	ld	a0,80(s1)
    80001338:	c511                	beqz	a0,80001344 <freeproc+0x2a>
    8000133a:	64ac                	ld	a1,72(s1)
    8000133c:	00000097          	auipc	ra,0x0
    80001340:	f8c080e7          	jalr	-116(ra) # 800012c8 <proc_freepagetable>
  p->pagetable = 0;
    80001344:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001348:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000134c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001350:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001354:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001358:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000135c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001360:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001364:	0004ac23          	sw	zero,24(s1)
}
    80001368:	60e2                	ld	ra,24(sp)
    8000136a:	6442                	ld	s0,16(sp)
    8000136c:	64a2                	ld	s1,8(sp)
    8000136e:	6105                	addi	sp,sp,32
    80001370:	8082                	ret

0000000080001372 <allocproc>:
static struct proc *allocproc(void) {
    80001372:	1101                	addi	sp,sp,-32
    80001374:	ec06                	sd	ra,24(sp)
    80001376:	e822                	sd	s0,16(sp)
    80001378:	e426                	sd	s1,8(sp)
    8000137a:	e04a                	sd	s2,0(sp)
    8000137c:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) {
    8000137e:	00028497          	auipc	s1,0x28
    80001382:	95248493          	addi	s1,s1,-1710 # 80028cd0 <proc>
    80001386:	0002d917          	auipc	s2,0x2d
    8000138a:	34a90913          	addi	s2,s2,842 # 8002e6d0 <tickslock>
    acquire(&p->lock);
    8000138e:	8526                	mv	a0,s1
    80001390:	00005097          	auipc	ra,0x5
    80001394:	09a080e7          	jalr	154(ra) # 8000642a <acquire>
    if (p->state == UNUSED) {
    80001398:	4c9c                	lw	a5,24(s1)
    8000139a:	cf81                	beqz	a5,800013b2 <allocproc+0x40>
      release(&p->lock);
    8000139c:	8526                	mv	a0,s1
    8000139e:	00005097          	auipc	ra,0x5
    800013a2:	140080e7          	jalr	320(ra) # 800064de <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    800013a6:	16848493          	addi	s1,s1,360
    800013aa:	ff2492e3          	bne	s1,s2,8000138e <allocproc+0x1c>
  return 0;
    800013ae:	4481                	li	s1,0
    800013b0:	a889                	j	80001402 <allocproc+0x90>
  p->pid = allocpid();
    800013b2:	00000097          	auipc	ra,0x0
    800013b6:	e34080e7          	jalr	-460(ra) # 800011e6 <allocpid>
    800013ba:	d888                	sw	a0,48(s1)
  p->state = USED;
    800013bc:	4785                	li	a5,1
    800013be:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    800013c0:	fffff097          	auipc	ra,0xfffff
    800013c4:	e6c080e7          	jalr	-404(ra) # 8000022c <kalloc>
    800013c8:	892a                	mv	s2,a0
    800013ca:	eca8                	sd	a0,88(s1)
    800013cc:	c131                	beqz	a0,80001410 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800013ce:	8526                	mv	a0,s1
    800013d0:	00000097          	auipc	ra,0x0
    800013d4:	e5c080e7          	jalr	-420(ra) # 8000122c <proc_pagetable>
    800013d8:	892a                	mv	s2,a0
    800013da:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0) {
    800013dc:	c531                	beqz	a0,80001428 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800013de:	07000613          	li	a2,112
    800013e2:	4581                	li	a1,0
    800013e4:	06048513          	addi	a0,s1,96
    800013e8:	fffff097          	auipc	ra,0xfffff
    800013ec:	eba080e7          	jalr	-326(ra) # 800002a2 <memset>
  p->context.ra = (uint64)forkret;
    800013f0:	00000797          	auipc	a5,0x0
    800013f4:	dac78793          	addi	a5,a5,-596 # 8000119c <forkret>
    800013f8:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800013fa:	60bc                	ld	a5,64(s1)
    800013fc:	6705                	lui	a4,0x1
    800013fe:	97ba                	add	a5,a5,a4
    80001400:	f4bc                	sd	a5,104(s1)
}
    80001402:	8526                	mv	a0,s1
    80001404:	60e2                	ld	ra,24(sp)
    80001406:	6442                	ld	s0,16(sp)
    80001408:	64a2                	ld	s1,8(sp)
    8000140a:	6902                	ld	s2,0(sp)
    8000140c:	6105                	addi	sp,sp,32
    8000140e:	8082                	ret
    freeproc(p);
    80001410:	8526                	mv	a0,s1
    80001412:	00000097          	auipc	ra,0x0
    80001416:	f08080e7          	jalr	-248(ra) # 8000131a <freeproc>
    release(&p->lock);
    8000141a:	8526                	mv	a0,s1
    8000141c:	00005097          	auipc	ra,0x5
    80001420:	0c2080e7          	jalr	194(ra) # 800064de <release>
    return 0;
    80001424:	84ca                	mv	s1,s2
    80001426:	bff1                	j	80001402 <allocproc+0x90>
    freeproc(p);
    80001428:	8526                	mv	a0,s1
    8000142a:	00000097          	auipc	ra,0x0
    8000142e:	ef0080e7          	jalr	-272(ra) # 8000131a <freeproc>
    release(&p->lock);
    80001432:	8526                	mv	a0,s1
    80001434:	00005097          	auipc	ra,0x5
    80001438:	0aa080e7          	jalr	170(ra) # 800064de <release>
    return 0;
    8000143c:	84ca                	mv	s1,s2
    8000143e:	b7d1                	j	80001402 <allocproc+0x90>

0000000080001440 <userinit>:
void userinit(void) {
    80001440:	1101                	addi	sp,sp,-32
    80001442:	ec06                	sd	ra,24(sp)
    80001444:	e822                	sd	s0,16(sp)
    80001446:	e426                	sd	s1,8(sp)
    80001448:	1000                	addi	s0,sp,32
  p = allocproc();
    8000144a:	00000097          	auipc	ra,0x0
    8000144e:	f28080e7          	jalr	-216(ra) # 80001372 <allocproc>
    80001452:	84aa                	mv	s1,a0
  initproc = p;
    80001454:	00007797          	auipc	a5,0x7
    80001458:	40a7b623          	sd	a0,1036(a5) # 80008860 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000145c:	03400613          	li	a2,52
    80001460:	00007597          	auipc	a1,0x7
    80001464:	3b058593          	addi	a1,a1,944 # 80008810 <initcode>
    80001468:	6928                	ld	a0,80(a0)
    8000146a:	fffff097          	auipc	ra,0xfffff
    8000146e:	484080e7          	jalr	1156(ra) # 800008ee <uvmfirst>
  p->sz = PGSIZE;
    80001472:	6785                	lui	a5,0x1
    80001474:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001476:	6cb8                	ld	a4,88(s1)
    80001478:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000147c:	6cb8                	ld	a4,88(s1)
    8000147e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001480:	4641                	li	a2,16
    80001482:	00007597          	auipc	a1,0x7
    80001486:	cb658593          	addi	a1,a1,-842 # 80008138 <etext+0x138>
    8000148a:	15848513          	addi	a0,s1,344
    8000148e:	fffff097          	auipc	ra,0xfffff
    80001492:	f5e080e7          	jalr	-162(ra) # 800003ec <safestrcpy>
  p->cwd = namei("/");
    80001496:	00007517          	auipc	a0,0x7
    8000149a:	cb250513          	addi	a0,a0,-846 # 80008148 <etext+0x148>
    8000149e:	00002097          	auipc	ra,0x2
    800014a2:	136080e7          	jalr	310(ra) # 800035d4 <namei>
    800014a6:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800014aa:	478d                	li	a5,3
    800014ac:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800014ae:	8526                	mv	a0,s1
    800014b0:	00005097          	auipc	ra,0x5
    800014b4:	02e080e7          	jalr	46(ra) # 800064de <release>
}
    800014b8:	60e2                	ld	ra,24(sp)
    800014ba:	6442                	ld	s0,16(sp)
    800014bc:	64a2                	ld	s1,8(sp)
    800014be:	6105                	addi	sp,sp,32
    800014c0:	8082                	ret

00000000800014c2 <growproc>:
int growproc(int n) {
    800014c2:	1101                	addi	sp,sp,-32
    800014c4:	ec06                	sd	ra,24(sp)
    800014c6:	e822                	sd	s0,16(sp)
    800014c8:	e426                	sd	s1,8(sp)
    800014ca:	e04a                	sd	s2,0(sp)
    800014cc:	1000                	addi	s0,sp,32
    800014ce:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800014d0:	00000097          	auipc	ra,0x0
    800014d4:	c94080e7          	jalr	-876(ra) # 80001164 <myproc>
    800014d8:	84aa                	mv	s1,a0
  sz = p->sz;
    800014da:	652c                	ld	a1,72(a0)
  if (n > 0) {
    800014dc:	01204c63          	bgtz	s2,800014f4 <growproc+0x32>
  } else if (n < 0) {
    800014e0:	02094663          	bltz	s2,8000150c <growproc+0x4a>
  p->sz = sz;
    800014e4:	e4ac                	sd	a1,72(s1)
  return 0;
    800014e6:	4501                	li	a0,0
}
    800014e8:	60e2                	ld	ra,24(sp)
    800014ea:	6442                	ld	s0,16(sp)
    800014ec:	64a2                	ld	s1,8(sp)
    800014ee:	6902                	ld	s2,0(sp)
    800014f0:	6105                	addi	sp,sp,32
    800014f2:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800014f4:	4691                	li	a3,4
    800014f6:	00b90633          	add	a2,s2,a1
    800014fa:	6928                	ld	a0,80(a0)
    800014fc:	fffff097          	auipc	ra,0xfffff
    80001500:	4ac080e7          	jalr	1196(ra) # 800009a8 <uvmalloc>
    80001504:	85aa                	mv	a1,a0
    80001506:	fd79                	bnez	a0,800014e4 <growproc+0x22>
      return -1;
    80001508:	557d                	li	a0,-1
    8000150a:	bff9                	j	800014e8 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000150c:	00b90633          	add	a2,s2,a1
    80001510:	6928                	ld	a0,80(a0)
    80001512:	fffff097          	auipc	ra,0xfffff
    80001516:	44e080e7          	jalr	1102(ra) # 80000960 <uvmdealloc>
    8000151a:	85aa                	mv	a1,a0
    8000151c:	b7e1                	j	800014e4 <growproc+0x22>

000000008000151e <fork>:
int fork(void) {
    8000151e:	7139                	addi	sp,sp,-64
    80001520:	fc06                	sd	ra,56(sp)
    80001522:	f822                	sd	s0,48(sp)
    80001524:	f426                	sd	s1,40(sp)
    80001526:	f04a                	sd	s2,32(sp)
    80001528:	ec4e                	sd	s3,24(sp)
    8000152a:	e852                	sd	s4,16(sp)
    8000152c:	e456                	sd	s5,8(sp)
    8000152e:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001530:	00000097          	auipc	ra,0x0
    80001534:	c34080e7          	jalr	-972(ra) # 80001164 <myproc>
    80001538:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    8000153a:	00000097          	auipc	ra,0x0
    8000153e:	e38080e7          	jalr	-456(ra) # 80001372 <allocproc>
    80001542:	10050c63          	beqz	a0,8000165a <fork+0x13c>
    80001546:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    80001548:	048ab603          	ld	a2,72(s5)
    8000154c:	692c                	ld	a1,80(a0)
    8000154e:	050ab503          	ld	a0,80(s5)
    80001552:	fffff097          	auipc	ra,0xfffff
    80001556:	5aa080e7          	jalr	1450(ra) # 80000afc <uvmcopy>
    8000155a:	04054863          	bltz	a0,800015aa <fork+0x8c>
  np->sz = p->sz;
    8000155e:	048ab783          	ld	a5,72(s5)
    80001562:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001566:	058ab683          	ld	a3,88(s5)
    8000156a:	87b6                	mv	a5,a3
    8000156c:	058a3703          	ld	a4,88(s4)
    80001570:	12068693          	addi	a3,a3,288
    80001574:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001578:	6788                	ld	a0,8(a5)
    8000157a:	6b8c                	ld	a1,16(a5)
    8000157c:	6f90                	ld	a2,24(a5)
    8000157e:	01073023          	sd	a6,0(a4)
    80001582:	e708                	sd	a0,8(a4)
    80001584:	eb0c                	sd	a1,16(a4)
    80001586:	ef10                	sd	a2,24(a4)
    80001588:	02078793          	addi	a5,a5,32
    8000158c:	02070713          	addi	a4,a4,32
    80001590:	fed792e3          	bne	a5,a3,80001574 <fork+0x56>
  np->trapframe->a0 = 0;
    80001594:	058a3783          	ld	a5,88(s4)
    80001598:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    8000159c:	0d0a8493          	addi	s1,s5,208
    800015a0:	0d0a0913          	addi	s2,s4,208
    800015a4:	150a8993          	addi	s3,s5,336
    800015a8:	a00d                	j	800015ca <fork+0xac>
    freeproc(np);
    800015aa:	8552                	mv	a0,s4
    800015ac:	00000097          	auipc	ra,0x0
    800015b0:	d6e080e7          	jalr	-658(ra) # 8000131a <freeproc>
    release(&np->lock);
    800015b4:	8552                	mv	a0,s4
    800015b6:	00005097          	auipc	ra,0x5
    800015ba:	f28080e7          	jalr	-216(ra) # 800064de <release>
    return -1;
    800015be:	597d                	li	s2,-1
    800015c0:	a059                	j	80001646 <fork+0x128>
  for (i = 0; i < NOFILE; i++)
    800015c2:	04a1                	addi	s1,s1,8
    800015c4:	0921                	addi	s2,s2,8
    800015c6:	01348b63          	beq	s1,s3,800015dc <fork+0xbe>
    if (p->ofile[i]) np->ofile[i] = filedup(p->ofile[i]);
    800015ca:	6088                	ld	a0,0(s1)
    800015cc:	d97d                	beqz	a0,800015c2 <fork+0xa4>
    800015ce:	00002097          	auipc	ra,0x2
    800015d2:	69c080e7          	jalr	1692(ra) # 80003c6a <filedup>
    800015d6:	00a93023          	sd	a0,0(s2)
    800015da:	b7e5                	j	800015c2 <fork+0xa4>
  np->cwd = idup(p->cwd);
    800015dc:	150ab503          	ld	a0,336(s5)
    800015e0:	00002097          	auipc	ra,0x2
    800015e4:	810080e7          	jalr	-2032(ra) # 80002df0 <idup>
    800015e8:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800015ec:	4641                	li	a2,16
    800015ee:	158a8593          	addi	a1,s5,344
    800015f2:	158a0513          	addi	a0,s4,344
    800015f6:	fffff097          	auipc	ra,0xfffff
    800015fa:	df6080e7          	jalr	-522(ra) # 800003ec <safestrcpy>
  pid = np->pid;
    800015fe:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001602:	8552                	mv	a0,s4
    80001604:	00005097          	auipc	ra,0x5
    80001608:	eda080e7          	jalr	-294(ra) # 800064de <release>
  acquire(&wait_lock);
    8000160c:	00027497          	auipc	s1,0x27
    80001610:	2ac48493          	addi	s1,s1,684 # 800288b8 <wait_lock>
    80001614:	8526                	mv	a0,s1
    80001616:	00005097          	auipc	ra,0x5
    8000161a:	e14080e7          	jalr	-492(ra) # 8000642a <acquire>
  np->parent = p;
    8000161e:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001622:	8526                	mv	a0,s1
    80001624:	00005097          	auipc	ra,0x5
    80001628:	eba080e7          	jalr	-326(ra) # 800064de <release>
  acquire(&np->lock);
    8000162c:	8552                	mv	a0,s4
    8000162e:	00005097          	auipc	ra,0x5
    80001632:	dfc080e7          	jalr	-516(ra) # 8000642a <acquire>
  np->state = RUNNABLE;
    80001636:	478d                	li	a5,3
    80001638:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000163c:	8552                	mv	a0,s4
    8000163e:	00005097          	auipc	ra,0x5
    80001642:	ea0080e7          	jalr	-352(ra) # 800064de <release>
}
    80001646:	854a                	mv	a0,s2
    80001648:	70e2                	ld	ra,56(sp)
    8000164a:	7442                	ld	s0,48(sp)
    8000164c:	74a2                	ld	s1,40(sp)
    8000164e:	7902                	ld	s2,32(sp)
    80001650:	69e2                	ld	s3,24(sp)
    80001652:	6a42                	ld	s4,16(sp)
    80001654:	6aa2                	ld	s5,8(sp)
    80001656:	6121                	addi	sp,sp,64
    80001658:	8082                	ret
    return -1;
    8000165a:	597d                	li	s2,-1
    8000165c:	b7ed                	j	80001646 <fork+0x128>

000000008000165e <scheduler>:
void scheduler(void) {
    8000165e:	7139                	addi	sp,sp,-64
    80001660:	fc06                	sd	ra,56(sp)
    80001662:	f822                	sd	s0,48(sp)
    80001664:	f426                	sd	s1,40(sp)
    80001666:	f04a                	sd	s2,32(sp)
    80001668:	ec4e                	sd	s3,24(sp)
    8000166a:	e852                	sd	s4,16(sp)
    8000166c:	e456                	sd	s5,8(sp)
    8000166e:	e05a                	sd	s6,0(sp)
    80001670:	0080                	addi	s0,sp,64
    80001672:	8792                	mv	a5,tp
  int id = r_tp();
    80001674:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001676:	00779a93          	slli	s5,a5,0x7
    8000167a:	00027717          	auipc	a4,0x27
    8000167e:	22670713          	addi	a4,a4,550 # 800288a0 <pid_lock>
    80001682:	9756                	add	a4,a4,s5
    80001684:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001688:	00027717          	auipc	a4,0x27
    8000168c:	25070713          	addi	a4,a4,592 # 800288d8 <cpus+0x8>
    80001690:	9aba                	add	s5,s5,a4
      if (p->state == RUNNABLE) {
    80001692:	498d                	li	s3,3
        p->state = RUNNING;
    80001694:	4b11                	li	s6,4
        c->proc = p;
    80001696:	079e                	slli	a5,a5,0x7
    80001698:	00027a17          	auipc	s4,0x27
    8000169c:	208a0a13          	addi	s4,s4,520 # 800288a0 <pid_lock>
    800016a0:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++) {
    800016a2:	0002d917          	auipc	s2,0x2d
    800016a6:	02e90913          	addi	s2,s2,46 # 8002e6d0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800016aa:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    800016ae:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800016b2:	10079073          	csrw	sstatus,a5
    800016b6:	00027497          	auipc	s1,0x27
    800016ba:	61a48493          	addi	s1,s1,1562 # 80028cd0 <proc>
    800016be:	a811                	j	800016d2 <scheduler+0x74>
      release(&p->lock);
    800016c0:	8526                	mv	a0,s1
    800016c2:	00005097          	auipc	ra,0x5
    800016c6:	e1c080e7          	jalr	-484(ra) # 800064de <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    800016ca:	16848493          	addi	s1,s1,360
    800016ce:	fd248ee3          	beq	s1,s2,800016aa <scheduler+0x4c>
      acquire(&p->lock);
    800016d2:	8526                	mv	a0,s1
    800016d4:	00005097          	auipc	ra,0x5
    800016d8:	d56080e7          	jalr	-682(ra) # 8000642a <acquire>
      if (p->state == RUNNABLE) {
    800016dc:	4c9c                	lw	a5,24(s1)
    800016de:	ff3791e3          	bne	a5,s3,800016c0 <scheduler+0x62>
        p->state = RUNNING;
    800016e2:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800016e6:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800016ea:	06048593          	addi	a1,s1,96
    800016ee:	8556                	mv	a0,s5
    800016f0:	00000097          	auipc	ra,0x0
    800016f4:	682080e7          	jalr	1666(ra) # 80001d72 <swtch>
        c->proc = 0;
    800016f8:	020a3823          	sd	zero,48(s4)
    800016fc:	b7d1                	j	800016c0 <scheduler+0x62>

00000000800016fe <sched>:
void sched(void) {
    800016fe:	7179                	addi	sp,sp,-48
    80001700:	f406                	sd	ra,40(sp)
    80001702:	f022                	sd	s0,32(sp)
    80001704:	ec26                	sd	s1,24(sp)
    80001706:	e84a                	sd	s2,16(sp)
    80001708:	e44e                	sd	s3,8(sp)
    8000170a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000170c:	00000097          	auipc	ra,0x0
    80001710:	a58080e7          	jalr	-1448(ra) # 80001164 <myproc>
    80001714:	84aa                	mv	s1,a0
  if (!holding(&p->lock)) panic("sched p->lock");
    80001716:	00005097          	auipc	ra,0x5
    8000171a:	c9a080e7          	jalr	-870(ra) # 800063b0 <holding>
    8000171e:	c93d                	beqz	a0,80001794 <sched+0x96>
  asm volatile("mv %0, tp" : "=r"(x));
    80001720:	8792                	mv	a5,tp
  if (mycpu()->noff != 1) panic("sched locks");
    80001722:	2781                	sext.w	a5,a5
    80001724:	079e                	slli	a5,a5,0x7
    80001726:	00027717          	auipc	a4,0x27
    8000172a:	17a70713          	addi	a4,a4,378 # 800288a0 <pid_lock>
    8000172e:	97ba                	add	a5,a5,a4
    80001730:	0a87a703          	lw	a4,168(a5)
    80001734:	4785                	li	a5,1
    80001736:	06f71763          	bne	a4,a5,800017a4 <sched+0xa6>
  if (p->state == RUNNING) panic("sched running");
    8000173a:	4c98                	lw	a4,24(s1)
    8000173c:	4791                	li	a5,4
    8000173e:	06f70b63          	beq	a4,a5,800017b4 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001742:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001746:	8b89                	andi	a5,a5,2
  if (intr_get()) panic("sched interruptible");
    80001748:	efb5                	bnez	a5,800017c4 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r"(x));
    8000174a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000174c:	00027917          	auipc	s2,0x27
    80001750:	15490913          	addi	s2,s2,340 # 800288a0 <pid_lock>
    80001754:	2781                	sext.w	a5,a5
    80001756:	079e                	slli	a5,a5,0x7
    80001758:	97ca                	add	a5,a5,s2
    8000175a:	0ac7a983          	lw	s3,172(a5)
    8000175e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001760:	2781                	sext.w	a5,a5
    80001762:	079e                	slli	a5,a5,0x7
    80001764:	00027597          	auipc	a1,0x27
    80001768:	17458593          	addi	a1,a1,372 # 800288d8 <cpus+0x8>
    8000176c:	95be                	add	a1,a1,a5
    8000176e:	06048513          	addi	a0,s1,96
    80001772:	00000097          	auipc	ra,0x0
    80001776:	600080e7          	jalr	1536(ra) # 80001d72 <swtch>
    8000177a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000177c:	2781                	sext.w	a5,a5
    8000177e:	079e                	slli	a5,a5,0x7
    80001780:	97ca                	add	a5,a5,s2
    80001782:	0b37a623          	sw	s3,172(a5)
}
    80001786:	70a2                	ld	ra,40(sp)
    80001788:	7402                	ld	s0,32(sp)
    8000178a:	64e2                	ld	s1,24(sp)
    8000178c:	6942                	ld	s2,16(sp)
    8000178e:	69a2                	ld	s3,8(sp)
    80001790:	6145                	addi	sp,sp,48
    80001792:	8082                	ret
  if (!holding(&p->lock)) panic("sched p->lock");
    80001794:	00007517          	auipc	a0,0x7
    80001798:	9bc50513          	addi	a0,a0,-1604 # 80008150 <etext+0x150>
    8000179c:	00004097          	auipc	ra,0x4
    800017a0:	752080e7          	jalr	1874(ra) # 80005eee <panic>
  if (mycpu()->noff != 1) panic("sched locks");
    800017a4:	00007517          	auipc	a0,0x7
    800017a8:	9bc50513          	addi	a0,a0,-1604 # 80008160 <etext+0x160>
    800017ac:	00004097          	auipc	ra,0x4
    800017b0:	742080e7          	jalr	1858(ra) # 80005eee <panic>
  if (p->state == RUNNING) panic("sched running");
    800017b4:	00007517          	auipc	a0,0x7
    800017b8:	9bc50513          	addi	a0,a0,-1604 # 80008170 <etext+0x170>
    800017bc:	00004097          	auipc	ra,0x4
    800017c0:	732080e7          	jalr	1842(ra) # 80005eee <panic>
  if (intr_get()) panic("sched interruptible");
    800017c4:	00007517          	auipc	a0,0x7
    800017c8:	9bc50513          	addi	a0,a0,-1604 # 80008180 <etext+0x180>
    800017cc:	00004097          	auipc	ra,0x4
    800017d0:	722080e7          	jalr	1826(ra) # 80005eee <panic>

00000000800017d4 <yield>:
void yield(void) {
    800017d4:	1101                	addi	sp,sp,-32
    800017d6:	ec06                	sd	ra,24(sp)
    800017d8:	e822                	sd	s0,16(sp)
    800017da:	e426                	sd	s1,8(sp)
    800017dc:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800017de:	00000097          	auipc	ra,0x0
    800017e2:	986080e7          	jalr	-1658(ra) # 80001164 <myproc>
    800017e6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800017e8:	00005097          	auipc	ra,0x5
    800017ec:	c42080e7          	jalr	-958(ra) # 8000642a <acquire>
  p->state = RUNNABLE;
    800017f0:	478d                	li	a5,3
    800017f2:	cc9c                	sw	a5,24(s1)
  sched();
    800017f4:	00000097          	auipc	ra,0x0
    800017f8:	f0a080e7          	jalr	-246(ra) # 800016fe <sched>
  release(&p->lock);
    800017fc:	8526                	mv	a0,s1
    800017fe:	00005097          	auipc	ra,0x5
    80001802:	ce0080e7          	jalr	-800(ra) # 800064de <release>
}
    80001806:	60e2                	ld	ra,24(sp)
    80001808:	6442                	ld	s0,16(sp)
    8000180a:	64a2                	ld	s1,8(sp)
    8000180c:	6105                	addi	sp,sp,32
    8000180e:	8082                	ret

0000000080001810 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk) {
    80001810:	7179                	addi	sp,sp,-48
    80001812:	f406                	sd	ra,40(sp)
    80001814:	f022                	sd	s0,32(sp)
    80001816:	ec26                	sd	s1,24(sp)
    80001818:	e84a                	sd	s2,16(sp)
    8000181a:	e44e                	sd	s3,8(sp)
    8000181c:	1800                	addi	s0,sp,48
    8000181e:	89aa                	mv	s3,a0
    80001820:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001822:	00000097          	auipc	ra,0x0
    80001826:	942080e7          	jalr	-1726(ra) # 80001164 <myproc>
    8000182a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  // DOC: sleeplock1
    8000182c:	00005097          	auipc	ra,0x5
    80001830:	bfe080e7          	jalr	-1026(ra) # 8000642a <acquire>
  release(lk);
    80001834:	854a                	mv	a0,s2
    80001836:	00005097          	auipc	ra,0x5
    8000183a:	ca8080e7          	jalr	-856(ra) # 800064de <release>

  // Go to sleep.
  p->chan = chan;
    8000183e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001842:	4789                	li	a5,2
    80001844:	cc9c                	sw	a5,24(s1)

  sched();
    80001846:	00000097          	auipc	ra,0x0
    8000184a:	eb8080e7          	jalr	-328(ra) # 800016fe <sched>

  // Tidy up.
  p->chan = 0;
    8000184e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001852:	8526                	mv	a0,s1
    80001854:	00005097          	auipc	ra,0x5
    80001858:	c8a080e7          	jalr	-886(ra) # 800064de <release>
  acquire(lk);
    8000185c:	854a                	mv	a0,s2
    8000185e:	00005097          	auipc	ra,0x5
    80001862:	bcc080e7          	jalr	-1076(ra) # 8000642a <acquire>
}
    80001866:	70a2                	ld	ra,40(sp)
    80001868:	7402                	ld	s0,32(sp)
    8000186a:	64e2                	ld	s1,24(sp)
    8000186c:	6942                	ld	s2,16(sp)
    8000186e:	69a2                	ld	s3,8(sp)
    80001870:	6145                	addi	sp,sp,48
    80001872:	8082                	ret

0000000080001874 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan) {
    80001874:	7139                	addi	sp,sp,-64
    80001876:	fc06                	sd	ra,56(sp)
    80001878:	f822                	sd	s0,48(sp)
    8000187a:	f426                	sd	s1,40(sp)
    8000187c:	f04a                	sd	s2,32(sp)
    8000187e:	ec4e                	sd	s3,24(sp)
    80001880:	e852                	sd	s4,16(sp)
    80001882:	e456                	sd	s5,8(sp)
    80001884:	0080                	addi	s0,sp,64
    80001886:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80001888:	00027497          	auipc	s1,0x27
    8000188c:	44848493          	addi	s1,s1,1096 # 80028cd0 <proc>
    if (p != myproc()) {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan) {
    80001890:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001892:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++) {
    80001894:	0002d917          	auipc	s2,0x2d
    80001898:	e3c90913          	addi	s2,s2,-452 # 8002e6d0 <tickslock>
    8000189c:	a811                	j	800018b0 <wakeup+0x3c>
      }
      release(&p->lock);
    8000189e:	8526                	mv	a0,s1
    800018a0:	00005097          	auipc	ra,0x5
    800018a4:	c3e080e7          	jalr	-962(ra) # 800064de <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    800018a8:	16848493          	addi	s1,s1,360
    800018ac:	03248663          	beq	s1,s2,800018d8 <wakeup+0x64>
    if (p != myproc()) {
    800018b0:	00000097          	auipc	ra,0x0
    800018b4:	8b4080e7          	jalr	-1868(ra) # 80001164 <myproc>
    800018b8:	fea488e3          	beq	s1,a0,800018a8 <wakeup+0x34>
      acquire(&p->lock);
    800018bc:	8526                	mv	a0,s1
    800018be:	00005097          	auipc	ra,0x5
    800018c2:	b6c080e7          	jalr	-1172(ra) # 8000642a <acquire>
      if (p->state == SLEEPING && p->chan == chan) {
    800018c6:	4c9c                	lw	a5,24(s1)
    800018c8:	fd379be3          	bne	a5,s3,8000189e <wakeup+0x2a>
    800018cc:	709c                	ld	a5,32(s1)
    800018ce:	fd4798e3          	bne	a5,s4,8000189e <wakeup+0x2a>
        p->state = RUNNABLE;
    800018d2:	0154ac23          	sw	s5,24(s1)
    800018d6:	b7e1                	j	8000189e <wakeup+0x2a>
    }
  }
}
    800018d8:	70e2                	ld	ra,56(sp)
    800018da:	7442                	ld	s0,48(sp)
    800018dc:	74a2                	ld	s1,40(sp)
    800018de:	7902                	ld	s2,32(sp)
    800018e0:	69e2                	ld	s3,24(sp)
    800018e2:	6a42                	ld	s4,16(sp)
    800018e4:	6aa2                	ld	s5,8(sp)
    800018e6:	6121                	addi	sp,sp,64
    800018e8:	8082                	ret

00000000800018ea <reparent>:
void reparent(struct proc *p) {
    800018ea:	7179                	addi	sp,sp,-48
    800018ec:	f406                	sd	ra,40(sp)
    800018ee:	f022                	sd	s0,32(sp)
    800018f0:	ec26                	sd	s1,24(sp)
    800018f2:	e84a                	sd	s2,16(sp)
    800018f4:	e44e                	sd	s3,8(sp)
    800018f6:	e052                	sd	s4,0(sp)
    800018f8:	1800                	addi	s0,sp,48
    800018fa:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    800018fc:	00027497          	auipc	s1,0x27
    80001900:	3d448493          	addi	s1,s1,980 # 80028cd0 <proc>
      pp->parent = initproc;
    80001904:	00007a17          	auipc	s4,0x7
    80001908:	f5ca0a13          	addi	s4,s4,-164 # 80008860 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000190c:	0002d997          	auipc	s3,0x2d
    80001910:	dc498993          	addi	s3,s3,-572 # 8002e6d0 <tickslock>
    80001914:	a029                	j	8000191e <reparent+0x34>
    80001916:	16848493          	addi	s1,s1,360
    8000191a:	01348d63          	beq	s1,s3,80001934 <reparent+0x4a>
    if (pp->parent == p) {
    8000191e:	7c9c                	ld	a5,56(s1)
    80001920:	ff279be3          	bne	a5,s2,80001916 <reparent+0x2c>
      pp->parent = initproc;
    80001924:	000a3503          	ld	a0,0(s4)
    80001928:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000192a:	00000097          	auipc	ra,0x0
    8000192e:	f4a080e7          	jalr	-182(ra) # 80001874 <wakeup>
    80001932:	b7d5                	j	80001916 <reparent+0x2c>
}
    80001934:	70a2                	ld	ra,40(sp)
    80001936:	7402                	ld	s0,32(sp)
    80001938:	64e2                	ld	s1,24(sp)
    8000193a:	6942                	ld	s2,16(sp)
    8000193c:	69a2                	ld	s3,8(sp)
    8000193e:	6a02                	ld	s4,0(sp)
    80001940:	6145                	addi	sp,sp,48
    80001942:	8082                	ret

0000000080001944 <exit>:
void exit(int status) {
    80001944:	7179                	addi	sp,sp,-48
    80001946:	f406                	sd	ra,40(sp)
    80001948:	f022                	sd	s0,32(sp)
    8000194a:	ec26                	sd	s1,24(sp)
    8000194c:	e84a                	sd	s2,16(sp)
    8000194e:	e44e                	sd	s3,8(sp)
    80001950:	e052                	sd	s4,0(sp)
    80001952:	1800                	addi	s0,sp,48
    80001954:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001956:	00000097          	auipc	ra,0x0
    8000195a:	80e080e7          	jalr	-2034(ra) # 80001164 <myproc>
    8000195e:	89aa                	mv	s3,a0
  if (p == initproc) panic("init exiting");
    80001960:	00007797          	auipc	a5,0x7
    80001964:	f007b783          	ld	a5,-256(a5) # 80008860 <initproc>
    80001968:	0d050493          	addi	s1,a0,208
    8000196c:	15050913          	addi	s2,a0,336
    80001970:	02a79363          	bne	a5,a0,80001996 <exit+0x52>
    80001974:	00007517          	auipc	a0,0x7
    80001978:	82450513          	addi	a0,a0,-2012 # 80008198 <etext+0x198>
    8000197c:	00004097          	auipc	ra,0x4
    80001980:	572080e7          	jalr	1394(ra) # 80005eee <panic>
      fileclose(f);
    80001984:	00002097          	auipc	ra,0x2
    80001988:	338080e7          	jalr	824(ra) # 80003cbc <fileclose>
      p->ofile[fd] = 0;
    8000198c:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++) {
    80001990:	04a1                	addi	s1,s1,8
    80001992:	01248563          	beq	s1,s2,8000199c <exit+0x58>
    if (p->ofile[fd]) {
    80001996:	6088                	ld	a0,0(s1)
    80001998:	f575                	bnez	a0,80001984 <exit+0x40>
    8000199a:	bfdd                	j	80001990 <exit+0x4c>
  begin_op();
    8000199c:	00002097          	auipc	ra,0x2
    800019a0:	e54080e7          	jalr	-428(ra) # 800037f0 <begin_op>
  iput(p->cwd);
    800019a4:	1509b503          	ld	a0,336(s3)
    800019a8:	00001097          	auipc	ra,0x1
    800019ac:	640080e7          	jalr	1600(ra) # 80002fe8 <iput>
  end_op();
    800019b0:	00002097          	auipc	ra,0x2
    800019b4:	ec0080e7          	jalr	-320(ra) # 80003870 <end_op>
  p->cwd = 0;
    800019b8:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800019bc:	00027497          	auipc	s1,0x27
    800019c0:	efc48493          	addi	s1,s1,-260 # 800288b8 <wait_lock>
    800019c4:	8526                	mv	a0,s1
    800019c6:	00005097          	auipc	ra,0x5
    800019ca:	a64080e7          	jalr	-1436(ra) # 8000642a <acquire>
  reparent(p);
    800019ce:	854e                	mv	a0,s3
    800019d0:	00000097          	auipc	ra,0x0
    800019d4:	f1a080e7          	jalr	-230(ra) # 800018ea <reparent>
  wakeup(p->parent);
    800019d8:	0389b503          	ld	a0,56(s3)
    800019dc:	00000097          	auipc	ra,0x0
    800019e0:	e98080e7          	jalr	-360(ra) # 80001874 <wakeup>
  acquire(&p->lock);
    800019e4:	854e                	mv	a0,s3
    800019e6:	00005097          	auipc	ra,0x5
    800019ea:	a44080e7          	jalr	-1468(ra) # 8000642a <acquire>
  p->xstate = status;
    800019ee:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800019f2:	4795                	li	a5,5
    800019f4:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800019f8:	8526                	mv	a0,s1
    800019fa:	00005097          	auipc	ra,0x5
    800019fe:	ae4080e7          	jalr	-1308(ra) # 800064de <release>
  sched();
    80001a02:	00000097          	auipc	ra,0x0
    80001a06:	cfc080e7          	jalr	-772(ra) # 800016fe <sched>
  panic("zombie exit");
    80001a0a:	00006517          	auipc	a0,0x6
    80001a0e:	79e50513          	addi	a0,a0,1950 # 800081a8 <etext+0x1a8>
    80001a12:	00004097          	auipc	ra,0x4
    80001a16:	4dc080e7          	jalr	1244(ra) # 80005eee <panic>

0000000080001a1a <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid) {
    80001a1a:	7179                	addi	sp,sp,-48
    80001a1c:	f406                	sd	ra,40(sp)
    80001a1e:	f022                	sd	s0,32(sp)
    80001a20:	ec26                	sd	s1,24(sp)
    80001a22:	e84a                	sd	s2,16(sp)
    80001a24:	e44e                	sd	s3,8(sp)
    80001a26:	1800                	addi	s0,sp,48
    80001a28:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80001a2a:	00027497          	auipc	s1,0x27
    80001a2e:	2a648493          	addi	s1,s1,678 # 80028cd0 <proc>
    80001a32:	0002d997          	auipc	s3,0x2d
    80001a36:	c9e98993          	addi	s3,s3,-866 # 8002e6d0 <tickslock>
    acquire(&p->lock);
    80001a3a:	8526                	mv	a0,s1
    80001a3c:	00005097          	auipc	ra,0x5
    80001a40:	9ee080e7          	jalr	-1554(ra) # 8000642a <acquire>
    if (p->pid == pid) {
    80001a44:	589c                	lw	a5,48(s1)
    80001a46:	01278d63          	beq	a5,s2,80001a60 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001a4a:	8526                	mv	a0,s1
    80001a4c:	00005097          	auipc	ra,0x5
    80001a50:	a92080e7          	jalr	-1390(ra) # 800064de <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001a54:	16848493          	addi	s1,s1,360
    80001a58:	ff3491e3          	bne	s1,s3,80001a3a <kill+0x20>
  }
  return -1;
    80001a5c:	557d                	li	a0,-1
    80001a5e:	a829                	j	80001a78 <kill+0x5e>
      p->killed = 1;
    80001a60:	4785                	li	a5,1
    80001a62:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING) {
    80001a64:	4c98                	lw	a4,24(s1)
    80001a66:	4789                	li	a5,2
    80001a68:	00f70f63          	beq	a4,a5,80001a86 <kill+0x6c>
      release(&p->lock);
    80001a6c:	8526                	mv	a0,s1
    80001a6e:	00005097          	auipc	ra,0x5
    80001a72:	a70080e7          	jalr	-1424(ra) # 800064de <release>
      return 0;
    80001a76:	4501                	li	a0,0
}
    80001a78:	70a2                	ld	ra,40(sp)
    80001a7a:	7402                	ld	s0,32(sp)
    80001a7c:	64e2                	ld	s1,24(sp)
    80001a7e:	6942                	ld	s2,16(sp)
    80001a80:	69a2                	ld	s3,8(sp)
    80001a82:	6145                	addi	sp,sp,48
    80001a84:	8082                	ret
        p->state = RUNNABLE;
    80001a86:	478d                	li	a5,3
    80001a88:	cc9c                	sw	a5,24(s1)
    80001a8a:	b7cd                	j	80001a6c <kill+0x52>

0000000080001a8c <setkilled>:

void setkilled(struct proc *p) {
    80001a8c:	1101                	addi	sp,sp,-32
    80001a8e:	ec06                	sd	ra,24(sp)
    80001a90:	e822                	sd	s0,16(sp)
    80001a92:	e426                	sd	s1,8(sp)
    80001a94:	1000                	addi	s0,sp,32
    80001a96:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001a98:	00005097          	auipc	ra,0x5
    80001a9c:	992080e7          	jalr	-1646(ra) # 8000642a <acquire>
  p->killed = 1;
    80001aa0:	4785                	li	a5,1
    80001aa2:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001aa4:	8526                	mv	a0,s1
    80001aa6:	00005097          	auipc	ra,0x5
    80001aaa:	a38080e7          	jalr	-1480(ra) # 800064de <release>
}
    80001aae:	60e2                	ld	ra,24(sp)
    80001ab0:	6442                	ld	s0,16(sp)
    80001ab2:	64a2                	ld	s1,8(sp)
    80001ab4:	6105                	addi	sp,sp,32
    80001ab6:	8082                	ret

0000000080001ab8 <killed>:

int killed(struct proc *p) {
    80001ab8:	1101                	addi	sp,sp,-32
    80001aba:	ec06                	sd	ra,24(sp)
    80001abc:	e822                	sd	s0,16(sp)
    80001abe:	e426                	sd	s1,8(sp)
    80001ac0:	e04a                	sd	s2,0(sp)
    80001ac2:	1000                	addi	s0,sp,32
    80001ac4:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    80001ac6:	00005097          	auipc	ra,0x5
    80001aca:	964080e7          	jalr	-1692(ra) # 8000642a <acquire>
  k = p->killed;
    80001ace:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001ad2:	8526                	mv	a0,s1
    80001ad4:	00005097          	auipc	ra,0x5
    80001ad8:	a0a080e7          	jalr	-1526(ra) # 800064de <release>
  return k;
}
    80001adc:	854a                	mv	a0,s2
    80001ade:	60e2                	ld	ra,24(sp)
    80001ae0:	6442                	ld	s0,16(sp)
    80001ae2:	64a2                	ld	s1,8(sp)
    80001ae4:	6902                	ld	s2,0(sp)
    80001ae6:	6105                	addi	sp,sp,32
    80001ae8:	8082                	ret

0000000080001aea <wait>:
int wait(uint64 addr) {
    80001aea:	715d                	addi	sp,sp,-80
    80001aec:	e486                	sd	ra,72(sp)
    80001aee:	e0a2                	sd	s0,64(sp)
    80001af0:	fc26                	sd	s1,56(sp)
    80001af2:	f84a                	sd	s2,48(sp)
    80001af4:	f44e                	sd	s3,40(sp)
    80001af6:	f052                	sd	s4,32(sp)
    80001af8:	ec56                	sd	s5,24(sp)
    80001afa:	e85a                	sd	s6,16(sp)
    80001afc:	e45e                	sd	s7,8(sp)
    80001afe:	e062                	sd	s8,0(sp)
    80001b00:	0880                	addi	s0,sp,80
    80001b02:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001b04:	fffff097          	auipc	ra,0xfffff
    80001b08:	660080e7          	jalr	1632(ra) # 80001164 <myproc>
    80001b0c:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001b0e:	00027517          	auipc	a0,0x27
    80001b12:	daa50513          	addi	a0,a0,-598 # 800288b8 <wait_lock>
    80001b16:	00005097          	auipc	ra,0x5
    80001b1a:	914080e7          	jalr	-1772(ra) # 8000642a <acquire>
    havekids = 0;
    80001b1e:	4b81                	li	s7,0
        if (pp->state == ZOMBIE) {
    80001b20:	4a15                	li	s4,5
        havekids = 1;
    80001b22:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001b24:	0002d997          	auipc	s3,0x2d
    80001b28:	bac98993          	addi	s3,s3,-1108 # 8002e6d0 <tickslock>
    sleep(p, &wait_lock);  // DOC: wait-sleep
    80001b2c:	00027c17          	auipc	s8,0x27
    80001b30:	d8cc0c13          	addi	s8,s8,-628 # 800288b8 <wait_lock>
    havekids = 0;
    80001b34:	875e                	mv	a4,s7
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001b36:	00027497          	auipc	s1,0x27
    80001b3a:	19a48493          	addi	s1,s1,410 # 80028cd0 <proc>
    80001b3e:	a0bd                	j	80001bac <wait+0xc2>
          pid = pp->pid;
    80001b40:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001b44:	000b0e63          	beqz	s6,80001b60 <wait+0x76>
    80001b48:	4691                	li	a3,4
    80001b4a:	02c48613          	addi	a2,s1,44
    80001b4e:	85da                	mv	a1,s6
    80001b50:	05093503          	ld	a0,80(s2)
    80001b54:	fffff097          	auipc	ra,0xfffff
    80001b58:	158080e7          	jalr	344(ra) # 80000cac <copyout>
    80001b5c:	02054563          	bltz	a0,80001b86 <wait+0x9c>
          freeproc(pp);
    80001b60:	8526                	mv	a0,s1
    80001b62:	fffff097          	auipc	ra,0xfffff
    80001b66:	7b8080e7          	jalr	1976(ra) # 8000131a <freeproc>
          release(&pp->lock);
    80001b6a:	8526                	mv	a0,s1
    80001b6c:	00005097          	auipc	ra,0x5
    80001b70:	972080e7          	jalr	-1678(ra) # 800064de <release>
          release(&wait_lock);
    80001b74:	00027517          	auipc	a0,0x27
    80001b78:	d4450513          	addi	a0,a0,-700 # 800288b8 <wait_lock>
    80001b7c:	00005097          	auipc	ra,0x5
    80001b80:	962080e7          	jalr	-1694(ra) # 800064de <release>
          return pid;
    80001b84:	a0b5                	j	80001bf0 <wait+0x106>
            release(&pp->lock);
    80001b86:	8526                	mv	a0,s1
    80001b88:	00005097          	auipc	ra,0x5
    80001b8c:	956080e7          	jalr	-1706(ra) # 800064de <release>
            release(&wait_lock);
    80001b90:	00027517          	auipc	a0,0x27
    80001b94:	d2850513          	addi	a0,a0,-728 # 800288b8 <wait_lock>
    80001b98:	00005097          	auipc	ra,0x5
    80001b9c:	946080e7          	jalr	-1722(ra) # 800064de <release>
            return -1;
    80001ba0:	59fd                	li	s3,-1
    80001ba2:	a0b9                	j	80001bf0 <wait+0x106>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001ba4:	16848493          	addi	s1,s1,360
    80001ba8:	03348463          	beq	s1,s3,80001bd0 <wait+0xe6>
      if (pp->parent == p) {
    80001bac:	7c9c                	ld	a5,56(s1)
    80001bae:	ff279be3          	bne	a5,s2,80001ba4 <wait+0xba>
        acquire(&pp->lock);
    80001bb2:	8526                	mv	a0,s1
    80001bb4:	00005097          	auipc	ra,0x5
    80001bb8:	876080e7          	jalr	-1930(ra) # 8000642a <acquire>
        if (pp->state == ZOMBIE) {
    80001bbc:	4c9c                	lw	a5,24(s1)
    80001bbe:	f94781e3          	beq	a5,s4,80001b40 <wait+0x56>
        release(&pp->lock);
    80001bc2:	8526                	mv	a0,s1
    80001bc4:	00005097          	auipc	ra,0x5
    80001bc8:	91a080e7          	jalr	-1766(ra) # 800064de <release>
        havekids = 1;
    80001bcc:	8756                	mv	a4,s5
    80001bce:	bfd9                	j	80001ba4 <wait+0xba>
    if (!havekids || killed(p)) {
    80001bd0:	c719                	beqz	a4,80001bde <wait+0xf4>
    80001bd2:	854a                	mv	a0,s2
    80001bd4:	00000097          	auipc	ra,0x0
    80001bd8:	ee4080e7          	jalr	-284(ra) # 80001ab8 <killed>
    80001bdc:	c51d                	beqz	a0,80001c0a <wait+0x120>
      release(&wait_lock);
    80001bde:	00027517          	auipc	a0,0x27
    80001be2:	cda50513          	addi	a0,a0,-806 # 800288b8 <wait_lock>
    80001be6:	00005097          	auipc	ra,0x5
    80001bea:	8f8080e7          	jalr	-1800(ra) # 800064de <release>
      return -1;
    80001bee:	59fd                	li	s3,-1
}
    80001bf0:	854e                	mv	a0,s3
    80001bf2:	60a6                	ld	ra,72(sp)
    80001bf4:	6406                	ld	s0,64(sp)
    80001bf6:	74e2                	ld	s1,56(sp)
    80001bf8:	7942                	ld	s2,48(sp)
    80001bfa:	79a2                	ld	s3,40(sp)
    80001bfc:	7a02                	ld	s4,32(sp)
    80001bfe:	6ae2                	ld	s5,24(sp)
    80001c00:	6b42                	ld	s6,16(sp)
    80001c02:	6ba2                	ld	s7,8(sp)
    80001c04:	6c02                	ld	s8,0(sp)
    80001c06:	6161                	addi	sp,sp,80
    80001c08:	8082                	ret
    sleep(p, &wait_lock);  // DOC: wait-sleep
    80001c0a:	85e2                	mv	a1,s8
    80001c0c:	854a                	mv	a0,s2
    80001c0e:	00000097          	auipc	ra,0x0
    80001c12:	c02080e7          	jalr	-1022(ra) # 80001810 <sleep>
    havekids = 0;
    80001c16:	bf39                	j	80001b34 <wait+0x4a>

0000000080001c18 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len) {
    80001c18:	7179                	addi	sp,sp,-48
    80001c1a:	f406                	sd	ra,40(sp)
    80001c1c:	f022                	sd	s0,32(sp)
    80001c1e:	ec26                	sd	s1,24(sp)
    80001c20:	e84a                	sd	s2,16(sp)
    80001c22:	e44e                	sd	s3,8(sp)
    80001c24:	e052                	sd	s4,0(sp)
    80001c26:	1800                	addi	s0,sp,48
    80001c28:	84aa                	mv	s1,a0
    80001c2a:	892e                	mv	s2,a1
    80001c2c:	89b2                	mv	s3,a2
    80001c2e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001c30:	fffff097          	auipc	ra,0xfffff
    80001c34:	534080e7          	jalr	1332(ra) # 80001164 <myproc>
  if (user_dst) {
    80001c38:	c08d                	beqz	s1,80001c5a <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001c3a:	86d2                	mv	a3,s4
    80001c3c:	864e                	mv	a2,s3
    80001c3e:	85ca                	mv	a1,s2
    80001c40:	6928                	ld	a0,80(a0)
    80001c42:	fffff097          	auipc	ra,0xfffff
    80001c46:	06a080e7          	jalr	106(ra) # 80000cac <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001c4a:	70a2                	ld	ra,40(sp)
    80001c4c:	7402                	ld	s0,32(sp)
    80001c4e:	64e2                	ld	s1,24(sp)
    80001c50:	6942                	ld	s2,16(sp)
    80001c52:	69a2                	ld	s3,8(sp)
    80001c54:	6a02                	ld	s4,0(sp)
    80001c56:	6145                	addi	sp,sp,48
    80001c58:	8082                	ret
    memmove((char *)dst, src, len);
    80001c5a:	000a061b          	sext.w	a2,s4
    80001c5e:	85ce                	mv	a1,s3
    80001c60:	854a                	mv	a0,s2
    80001c62:	ffffe097          	auipc	ra,0xffffe
    80001c66:	69c080e7          	jalr	1692(ra) # 800002fe <memmove>
    return 0;
    80001c6a:	8526                	mv	a0,s1
    80001c6c:	bff9                	j	80001c4a <either_copyout+0x32>

0000000080001c6e <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len) {
    80001c6e:	7179                	addi	sp,sp,-48
    80001c70:	f406                	sd	ra,40(sp)
    80001c72:	f022                	sd	s0,32(sp)
    80001c74:	ec26                	sd	s1,24(sp)
    80001c76:	e84a                	sd	s2,16(sp)
    80001c78:	e44e                	sd	s3,8(sp)
    80001c7a:	e052                	sd	s4,0(sp)
    80001c7c:	1800                	addi	s0,sp,48
    80001c7e:	892a                	mv	s2,a0
    80001c80:	84ae                	mv	s1,a1
    80001c82:	89b2                	mv	s3,a2
    80001c84:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001c86:	fffff097          	auipc	ra,0xfffff
    80001c8a:	4de080e7          	jalr	1246(ra) # 80001164 <myproc>
  if (user_src) {
    80001c8e:	c08d                	beqz	s1,80001cb0 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001c90:	86d2                	mv	a3,s4
    80001c92:	864e                	mv	a2,s3
    80001c94:	85ca                	mv	a1,s2
    80001c96:	6928                	ld	a0,80(a0)
    80001c98:	fffff097          	auipc	ra,0xfffff
    80001c9c:	130080e7          	jalr	304(ra) # 80000dc8 <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80001ca0:	70a2                	ld	ra,40(sp)
    80001ca2:	7402                	ld	s0,32(sp)
    80001ca4:	64e2                	ld	s1,24(sp)
    80001ca6:	6942                	ld	s2,16(sp)
    80001ca8:	69a2                	ld	s3,8(sp)
    80001caa:	6a02                	ld	s4,0(sp)
    80001cac:	6145                	addi	sp,sp,48
    80001cae:	8082                	ret
    memmove(dst, (char *)src, len);
    80001cb0:	000a061b          	sext.w	a2,s4
    80001cb4:	85ce                	mv	a1,s3
    80001cb6:	854a                	mv	a0,s2
    80001cb8:	ffffe097          	auipc	ra,0xffffe
    80001cbc:	646080e7          	jalr	1606(ra) # 800002fe <memmove>
    return 0;
    80001cc0:	8526                	mv	a0,s1
    80001cc2:	bff9                	j	80001ca0 <either_copyin+0x32>

0000000080001cc4 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
    80001cc4:	715d                	addi	sp,sp,-80
    80001cc6:	e486                	sd	ra,72(sp)
    80001cc8:	e0a2                	sd	s0,64(sp)
    80001cca:	fc26                	sd	s1,56(sp)
    80001ccc:	f84a                	sd	s2,48(sp)
    80001cce:	f44e                	sd	s3,40(sp)
    80001cd0:	f052                	sd	s4,32(sp)
    80001cd2:	ec56                	sd	s5,24(sp)
    80001cd4:	e85a                	sd	s6,16(sp)
    80001cd6:	e45e                	sd	s7,8(sp)
    80001cd8:	0880                	addi	s0,sp,80
      [UNUSED] = "unused",   [USED] = "used",      [SLEEPING] = "sleep ",
      [RUNNABLE] = "runble", [RUNNING] = "run   ", [ZOMBIE] = "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    80001cda:	00006517          	auipc	a0,0x6
    80001cde:	36e50513          	addi	a0,a0,878 # 80008048 <etext+0x48>
    80001ce2:	00004097          	auipc	ra,0x4
    80001ce6:	256080e7          	jalr	598(ra) # 80005f38 <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001cea:	00027497          	auipc	s1,0x27
    80001cee:	13e48493          	addi	s1,s1,318 # 80028e28 <proc+0x158>
    80001cf2:	0002d917          	auipc	s2,0x2d
    80001cf6:	b3690913          	addi	s2,s2,-1226 # 8002e828 <bcache+0x140>
    if (p->state == UNUSED) continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001cfa:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001cfc:	00006997          	auipc	s3,0x6
    80001d00:	4bc98993          	addi	s3,s3,1212 # 800081b8 <etext+0x1b8>
    printf("%d %s %s", p->pid, state, p->name);
    80001d04:	00006a97          	auipc	s5,0x6
    80001d08:	4bca8a93          	addi	s5,s5,1212 # 800081c0 <etext+0x1c0>
    printf("\n");
    80001d0c:	00006a17          	auipc	s4,0x6
    80001d10:	33ca0a13          	addi	s4,s4,828 # 80008048 <etext+0x48>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001d14:	00006b97          	auipc	s7,0x6
    80001d18:	4ecb8b93          	addi	s7,s7,1260 # 80008200 <states.0>
    80001d1c:	a00d                	j	80001d3e <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001d1e:	ed86a583          	lw	a1,-296(a3)
    80001d22:	8556                	mv	a0,s5
    80001d24:	00004097          	auipc	ra,0x4
    80001d28:	214080e7          	jalr	532(ra) # 80005f38 <printf>
    printf("\n");
    80001d2c:	8552                	mv	a0,s4
    80001d2e:	00004097          	auipc	ra,0x4
    80001d32:	20a080e7          	jalr	522(ra) # 80005f38 <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001d36:	16848493          	addi	s1,s1,360
    80001d3a:	03248163          	beq	s1,s2,80001d5c <procdump+0x98>
    if (p->state == UNUSED) continue;
    80001d3e:	86a6                	mv	a3,s1
    80001d40:	ec04a783          	lw	a5,-320(s1)
    80001d44:	dbed                	beqz	a5,80001d36 <procdump+0x72>
      state = "???";
    80001d46:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001d48:	fcfb6be3          	bltu	s6,a5,80001d1e <procdump+0x5a>
    80001d4c:	1782                	slli	a5,a5,0x20
    80001d4e:	9381                	srli	a5,a5,0x20
    80001d50:	078e                	slli	a5,a5,0x3
    80001d52:	97de                	add	a5,a5,s7
    80001d54:	6390                	ld	a2,0(a5)
    80001d56:	f661                	bnez	a2,80001d1e <procdump+0x5a>
      state = "???";
    80001d58:	864e                	mv	a2,s3
    80001d5a:	b7d1                	j	80001d1e <procdump+0x5a>
  }
}
    80001d5c:	60a6                	ld	ra,72(sp)
    80001d5e:	6406                	ld	s0,64(sp)
    80001d60:	74e2                	ld	s1,56(sp)
    80001d62:	7942                	ld	s2,48(sp)
    80001d64:	79a2                	ld	s3,40(sp)
    80001d66:	7a02                	ld	s4,32(sp)
    80001d68:	6ae2                	ld	s5,24(sp)
    80001d6a:	6b42                	ld	s6,16(sp)
    80001d6c:	6ba2                	ld	s7,8(sp)
    80001d6e:	6161                	addi	sp,sp,80
    80001d70:	8082                	ret

0000000080001d72 <swtch>:
    80001d72:	00153023          	sd	ra,0(a0)
    80001d76:	00253423          	sd	sp,8(a0)
    80001d7a:	e900                	sd	s0,16(a0)
    80001d7c:	ed04                	sd	s1,24(a0)
    80001d7e:	03253023          	sd	s2,32(a0)
    80001d82:	03353423          	sd	s3,40(a0)
    80001d86:	03453823          	sd	s4,48(a0)
    80001d8a:	03553c23          	sd	s5,56(a0)
    80001d8e:	05653023          	sd	s6,64(a0)
    80001d92:	05753423          	sd	s7,72(a0)
    80001d96:	05853823          	sd	s8,80(a0)
    80001d9a:	05953c23          	sd	s9,88(a0)
    80001d9e:	07a53023          	sd	s10,96(a0)
    80001da2:	07b53423          	sd	s11,104(a0)
    80001da6:	0005b083          	ld	ra,0(a1)
    80001daa:	0085b103          	ld	sp,8(a1)
    80001dae:	6980                	ld	s0,16(a1)
    80001db0:	6d84                	ld	s1,24(a1)
    80001db2:	0205b903          	ld	s2,32(a1)
    80001db6:	0285b983          	ld	s3,40(a1)
    80001dba:	0305ba03          	ld	s4,48(a1)
    80001dbe:	0385ba83          	ld	s5,56(a1)
    80001dc2:	0405bb03          	ld	s6,64(a1)
    80001dc6:	0485bb83          	ld	s7,72(a1)
    80001dca:	0505bc03          	ld	s8,80(a1)
    80001dce:	0585bc83          	ld	s9,88(a1)
    80001dd2:	0605bd03          	ld	s10,96(a1)
    80001dd6:	0685bd83          	ld	s11,104(a1)
    80001dda:	8082                	ret

0000000080001ddc <trapinit>:
// in kernelvec.S, calls kerneltrap().
void kernelvec();

extern int devintr();

void trapinit(void) { initlock(&tickslock, "time"); }
    80001ddc:	1141                	addi	sp,sp,-16
    80001dde:	e406                	sd	ra,8(sp)
    80001de0:	e022                	sd	s0,0(sp)
    80001de2:	0800                	addi	s0,sp,16
    80001de4:	00006597          	auipc	a1,0x6
    80001de8:	44c58593          	addi	a1,a1,1100 # 80008230 <states.0+0x30>
    80001dec:	0002d517          	auipc	a0,0x2d
    80001df0:	8e450513          	addi	a0,a0,-1820 # 8002e6d0 <tickslock>
    80001df4:	00004097          	auipc	ra,0x4
    80001df8:	5a6080e7          	jalr	1446(ra) # 8000639a <initlock>
    80001dfc:	60a2                	ld	ra,8(sp)
    80001dfe:	6402                	ld	s0,0(sp)
    80001e00:	0141                	addi	sp,sp,16
    80001e02:	8082                	ret

0000000080001e04 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void) { w_stvec((uint64)kernelvec); }
    80001e04:	1141                	addi	sp,sp,-16
    80001e06:	e422                	sd	s0,8(sp)
    80001e08:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001e0a:	00003797          	auipc	a5,0x3
    80001e0e:	51678793          	addi	a5,a5,1302 # 80005320 <kernelvec>
    80001e12:	10579073          	csrw	stvec,a5
    80001e16:	6422                	ld	s0,8(sp)
    80001e18:	0141                	addi	sp,sp,16
    80001e1a:	8082                	ret

0000000080001e1c <usertrapret>:
}

//
// return to user space
//
void usertrapret(void) {
    80001e1c:	1141                	addi	sp,sp,-16
    80001e1e:	e406                	sd	ra,8(sp)
    80001e20:	e022                	sd	s0,0(sp)
    80001e22:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001e24:	fffff097          	auipc	ra,0xfffff
    80001e28:	340080e7          	jalr	832(ra) # 80001164 <myproc>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001e2c:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    80001e30:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001e32:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001e36:	00005617          	auipc	a2,0x5
    80001e3a:	1ca60613          	addi	a2,a2,458 # 80007000 <_trampoline>
    80001e3e:	00005697          	auipc	a3,0x5
    80001e42:	1c268693          	addi	a3,a3,450 # 80007000 <_trampoline>
    80001e46:	8e91                	sub	a3,a3,a2
    80001e48:	040007b7          	lui	a5,0x4000
    80001e4c:	17fd                	addi	a5,a5,-1
    80001e4e:	07b2                	slli	a5,a5,0xc
    80001e50:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001e52:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();          // kernel page table
    80001e56:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80001e58:	180026f3          	csrr	a3,satp
    80001e5c:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE;  // process's kernel stack
    80001e5e:	6d38                	ld	a4,88(a0)
    80001e60:	6134                	ld	a3,64(a0)
    80001e62:	6585                	lui	a1,0x1
    80001e64:	96ae                	add	a3,a3,a1
    80001e66:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001e68:	6d38                	ld	a4,88(a0)
    80001e6a:	00000697          	auipc	a3,0x0
    80001e6e:	13068693          	addi	a3,a3,304 # 80001f9a <usertrap>
    80001e72:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();  // hartid for cpuid()
    80001e74:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    80001e76:	8692                	mv	a3,tp
    80001e78:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001e7a:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP;  // clear SPP to 0 for user mode
    80001e7e:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE;  // enable interrupts in user mode
    80001e82:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001e86:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001e8a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    80001e8c:	6f18                	ld	a4,24(a4)
    80001e8e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001e92:	6928                	ld	a0,80(a0)
    80001e94:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001e96:	00005717          	auipc	a4,0x5
    80001e9a:	20670713          	addi	a4,a4,518 # 8000709c <userret>
    80001e9e:	8f11                	sub	a4,a4,a2
    80001ea0:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001ea2:	577d                	li	a4,-1
    80001ea4:	177e                	slli	a4,a4,0x3f
    80001ea6:	8d59                	or	a0,a0,a4
    80001ea8:	9782                	jalr	a5
}
    80001eaa:	60a2                	ld	ra,8(sp)
    80001eac:	6402                	ld	s0,0(sp)
    80001eae:	0141                	addi	sp,sp,16
    80001eb0:	8082                	ret

0000000080001eb2 <clockintr>:
  // so restore trap registers for use by kernelvec.S's sepc instruction.
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr() {
    80001eb2:	1101                	addi	sp,sp,-32
    80001eb4:	ec06                	sd	ra,24(sp)
    80001eb6:	e822                	sd	s0,16(sp)
    80001eb8:	e426                	sd	s1,8(sp)
    80001eba:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001ebc:	0002d497          	auipc	s1,0x2d
    80001ec0:	81448493          	addi	s1,s1,-2028 # 8002e6d0 <tickslock>
    80001ec4:	8526                	mv	a0,s1
    80001ec6:	00004097          	auipc	ra,0x4
    80001eca:	564080e7          	jalr	1380(ra) # 8000642a <acquire>
  ticks++;
    80001ece:	00007517          	auipc	a0,0x7
    80001ed2:	99a50513          	addi	a0,a0,-1638 # 80008868 <ticks>
    80001ed6:	411c                	lw	a5,0(a0)
    80001ed8:	2785                	addiw	a5,a5,1
    80001eda:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001edc:	00000097          	auipc	ra,0x0
    80001ee0:	998080e7          	jalr	-1640(ra) # 80001874 <wakeup>
  release(&tickslock);
    80001ee4:	8526                	mv	a0,s1
    80001ee6:	00004097          	auipc	ra,0x4
    80001eea:	5f8080e7          	jalr	1528(ra) # 800064de <release>
}
    80001eee:	60e2                	ld	ra,24(sp)
    80001ef0:	6442                	ld	s0,16(sp)
    80001ef2:	64a2                	ld	s1,8(sp)
    80001ef4:	6105                	addi	sp,sp,32
    80001ef6:	8082                	ret

0000000080001ef8 <devintr>:
// check if it's an external interrupt or software interrupt,
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr() {
    80001ef8:	1101                	addi	sp,sp,-32
    80001efa:	ec06                	sd	ra,24(sp)
    80001efc:	e822                	sd	s0,16(sp)
    80001efe:	e426                	sd	s1,8(sp)
    80001f00:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    80001f02:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80001f06:	00074d63          	bltz	a4,80001f20 <devintr+0x28>
    // interrupt at a time; tell the PLIC the device is
    // now allowed to interrupt again.
    if (irq) plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000001L) {
    80001f0a:	57fd                	li	a5,-1
    80001f0c:	17fe                	slli	a5,a5,0x3f
    80001f0e:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001f10:	4501                	li	a0,0
  } else if (scause == 0x8000000000000001L) {
    80001f12:	06f70363          	beq	a4,a5,80001f78 <devintr+0x80>
  }
}
    80001f16:	60e2                	ld	ra,24(sp)
    80001f18:	6442                	ld	s0,16(sp)
    80001f1a:	64a2                	ld	s1,8(sp)
    80001f1c:	6105                	addi	sp,sp,32
    80001f1e:	8082                	ret
  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80001f20:	0ff77793          	andi	a5,a4,255
    80001f24:	46a5                	li	a3,9
    80001f26:	fed792e3          	bne	a5,a3,80001f0a <devintr+0x12>
    int irq = plic_claim();
    80001f2a:	00003097          	auipc	ra,0x3
    80001f2e:	4fe080e7          	jalr	1278(ra) # 80005428 <plic_claim>
    80001f32:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    80001f34:	47a9                	li	a5,10
    80001f36:	02f50763          	beq	a0,a5,80001f64 <devintr+0x6c>
    } else if (irq == VIRTIO0_IRQ) {
    80001f3a:	4785                	li	a5,1
    80001f3c:	02f50963          	beq	a0,a5,80001f6e <devintr+0x76>
    return 1;
    80001f40:	4505                	li	a0,1
    } else if (irq) {
    80001f42:	d8f1                	beqz	s1,80001f16 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001f44:	85a6                	mv	a1,s1
    80001f46:	00006517          	auipc	a0,0x6
    80001f4a:	2f250513          	addi	a0,a0,754 # 80008238 <states.0+0x38>
    80001f4e:	00004097          	auipc	ra,0x4
    80001f52:	fea080e7          	jalr	-22(ra) # 80005f38 <printf>
    if (irq) plic_complete(irq);
    80001f56:	8526                	mv	a0,s1
    80001f58:	00003097          	auipc	ra,0x3
    80001f5c:	4f4080e7          	jalr	1268(ra) # 8000544c <plic_complete>
    return 1;
    80001f60:	4505                	li	a0,1
    80001f62:	bf55                	j	80001f16 <devintr+0x1e>
      uartintr();
    80001f64:	00004097          	auipc	ra,0x4
    80001f68:	3e6080e7          	jalr	998(ra) # 8000634a <uartintr>
    80001f6c:	b7ed                	j	80001f56 <devintr+0x5e>
      virtio_disk_intr();
    80001f6e:	00004097          	auipc	ra,0x4
    80001f72:	9aa080e7          	jalr	-1622(ra) # 80005918 <virtio_disk_intr>
    80001f76:	b7c5                	j	80001f56 <devintr+0x5e>
    if (cpuid() == 0) {
    80001f78:	fffff097          	auipc	ra,0xfffff
    80001f7c:	1c0080e7          	jalr	448(ra) # 80001138 <cpuid>
    80001f80:	c901                	beqz	a0,80001f90 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r"(x));
    80001f82:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001f86:	9bf5                	andi	a5,a5,-3
static inline void w_sip(uint64 x) { asm volatile("csrw sip, %0" : : "r"(x)); }
    80001f88:	14479073          	csrw	sip,a5
    return 2;
    80001f8c:	4509                	li	a0,2
    80001f8e:	b761                	j	80001f16 <devintr+0x1e>
      clockintr();
    80001f90:	00000097          	auipc	ra,0x0
    80001f94:	f22080e7          	jalr	-222(ra) # 80001eb2 <clockintr>
    80001f98:	b7ed                	j	80001f82 <devintr+0x8a>

0000000080001f9a <usertrap>:
void usertrap(void) {
    80001f9a:	1101                	addi	sp,sp,-32
    80001f9c:	ec06                	sd	ra,24(sp)
    80001f9e:	e822                	sd	s0,16(sp)
    80001fa0:	e426                	sd	s1,8(sp)
    80001fa2:	e04a                	sd	s2,0(sp)
    80001fa4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001fa6:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0) panic("usertrap: not from user mode");
    80001faa:	1007f793          	andi	a5,a5,256
    80001fae:	ebb5                	bnez	a5,80002022 <usertrap+0x88>
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001fb0:	00003797          	auipc	a5,0x3
    80001fb4:	37078793          	addi	a5,a5,880 # 80005320 <kernelvec>
    80001fb8:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001fbc:	fffff097          	auipc	ra,0xfffff
    80001fc0:	1a8080e7          	jalr	424(ra) # 80001164 <myproc>
    80001fc4:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001fc6:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001fc8:	14102773          	csrr	a4,sepc
    80001fcc:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    80001fce:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    80001fd2:	47a1                	li	a5,8
    80001fd4:	04f70f63          	beq	a4,a5,80002032 <usertrap+0x98>
    80001fd8:	14202773          	csrr	a4,scause
  } else if (r_scause() == 13 || r_scause() == 15) {
    80001fdc:	47b5                	li	a5,13
    80001fde:	00f70763          	beq	a4,a5,80001fec <usertrap+0x52>
    80001fe2:	14202773          	csrr	a4,scause
    80001fe6:	47bd                	li	a5,15
    80001fe8:	08f71563          	bne	a4,a5,80002072 <usertrap+0xd8>
  asm volatile("csrr %0, stval" : "=r"(x));
    80001fec:	143025f3          	csrr	a1,stval
    if (uvmcopy_cow(p->pagetable, PGROUNDDOWN(r_stval())) <= -1) {
    80001ff0:	77fd                	lui	a5,0xfffff
    80001ff2:	8dfd                	and	a1,a1,a5
    80001ff4:	68a8                	ld	a0,80(s1)
    80001ff6:	fffff097          	auipc	ra,0xfffff
    80001ffa:	bae080e7          	jalr	-1106(ra) # 80000ba4 <uvmcopy_cow>
    80001ffe:	06054463          	bltz	a0,80002066 <usertrap+0xcc>
  if (killed(p)) exit(-1);
    80002002:	8526                	mv	a0,s1
    80002004:	00000097          	auipc	ra,0x0
    80002008:	ab4080e7          	jalr	-1356(ra) # 80001ab8 <killed>
    8000200c:	ed4d                	bnez	a0,800020c6 <usertrap+0x12c>
  usertrapret();
    8000200e:	00000097          	auipc	ra,0x0
    80002012:	e0e080e7          	jalr	-498(ra) # 80001e1c <usertrapret>
}
    80002016:	60e2                	ld	ra,24(sp)
    80002018:	6442                	ld	s0,16(sp)
    8000201a:	64a2                	ld	s1,8(sp)
    8000201c:	6902                	ld	s2,0(sp)
    8000201e:	6105                	addi	sp,sp,32
    80002020:	8082                	ret
  if ((r_sstatus() & SSTATUS_SPP) != 0) panic("usertrap: not from user mode");
    80002022:	00006517          	auipc	a0,0x6
    80002026:	23650513          	addi	a0,a0,566 # 80008258 <states.0+0x58>
    8000202a:	00004097          	auipc	ra,0x4
    8000202e:	ec4080e7          	jalr	-316(ra) # 80005eee <panic>
    if (killed(p)) exit(-1);
    80002032:	00000097          	auipc	ra,0x0
    80002036:	a86080e7          	jalr	-1402(ra) # 80001ab8 <killed>
    8000203a:	e105                	bnez	a0,8000205a <usertrap+0xc0>
    p->trapframe->epc += 4;
    8000203c:	6cb8                	ld	a4,88(s1)
    8000203e:	6f1c                	ld	a5,24(a4)
    80002040:	0791                	addi	a5,a5,4
    80002042:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002044:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80002048:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    8000204c:	10079073          	csrw	sstatus,a5
    syscall();
    80002050:	00000097          	auipc	ra,0x0
    80002054:	2dc080e7          	jalr	732(ra) # 8000232c <syscall>
    80002058:	b76d                	j	80002002 <usertrap+0x68>
    if (killed(p)) exit(-1);
    8000205a:	557d                	li	a0,-1
    8000205c:	00000097          	auipc	ra,0x0
    80002060:	8e8080e7          	jalr	-1816(ra) # 80001944 <exit>
    80002064:	bfe1                	j	8000203c <usertrap+0xa2>
      setkilled(p);
    80002066:	8526                	mv	a0,s1
    80002068:	00000097          	auipc	ra,0x0
    8000206c:	a24080e7          	jalr	-1500(ra) # 80001a8c <setkilled>
    80002070:	bf49                	j	80002002 <usertrap+0x68>
  } else if ((which_dev = devintr()) != 0) {
    80002072:	00000097          	auipc	ra,0x0
    80002076:	e86080e7          	jalr	-378(ra) # 80001ef8 <devintr>
    8000207a:	892a                	mv	s2,a0
    8000207c:	c901                	beqz	a0,8000208c <usertrap+0xf2>
  if (killed(p)) exit(-1);
    8000207e:	8526                	mv	a0,s1
    80002080:	00000097          	auipc	ra,0x0
    80002084:	a38080e7          	jalr	-1480(ra) # 80001ab8 <killed>
    80002088:	c529                	beqz	a0,800020d2 <usertrap+0x138>
    8000208a:	a83d                	j	800020c8 <usertrap+0x12e>
  asm volatile("csrr %0, scause" : "=r"(x));
    8000208c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002090:	5890                	lw	a2,48(s1)
    80002092:	00006517          	auipc	a0,0x6
    80002096:	1e650513          	addi	a0,a0,486 # 80008278 <states.0+0x78>
    8000209a:	00004097          	auipc	ra,0x4
    8000209e:	e9e080e7          	jalr	-354(ra) # 80005f38 <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    800020a2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    800020a6:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    800020aa:	00006517          	auipc	a0,0x6
    800020ae:	1fe50513          	addi	a0,a0,510 # 800082a8 <states.0+0xa8>
    800020b2:	00004097          	auipc	ra,0x4
    800020b6:	e86080e7          	jalr	-378(ra) # 80005f38 <printf>
    setkilled(p);
    800020ba:	8526                	mv	a0,s1
    800020bc:	00000097          	auipc	ra,0x0
    800020c0:	9d0080e7          	jalr	-1584(ra) # 80001a8c <setkilled>
    800020c4:	bf3d                	j	80002002 <usertrap+0x68>
  if (killed(p)) exit(-1);
    800020c6:	4901                	li	s2,0
    800020c8:	557d                	li	a0,-1
    800020ca:	00000097          	auipc	ra,0x0
    800020ce:	87a080e7          	jalr	-1926(ra) # 80001944 <exit>
  if (which_dev == 2) yield();
    800020d2:	4789                	li	a5,2
    800020d4:	f2f91de3          	bne	s2,a5,8000200e <usertrap+0x74>
    800020d8:	fffff097          	auipc	ra,0xfffff
    800020dc:	6fc080e7          	jalr	1788(ra) # 800017d4 <yield>
    800020e0:	b73d                	j	8000200e <usertrap+0x74>

00000000800020e2 <kerneltrap>:
void kerneltrap() {
    800020e2:	7179                	addi	sp,sp,-48
    800020e4:	f406                	sd	ra,40(sp)
    800020e6:	f022                	sd	s0,32(sp)
    800020e8:	ec26                	sd	s1,24(sp)
    800020ea:	e84a                	sd	s2,16(sp)
    800020ec:	e44e                	sd	s3,8(sp)
    800020ee:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    800020f0:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800020f4:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    800020f8:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    800020fc:	1004f793          	andi	a5,s1,256
    80002100:	cb85                	beqz	a5,80002130 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002102:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002106:	8b89                	andi	a5,a5,2
  if (intr_get() != 0) panic("kerneltrap: interrupts enabled");
    80002108:	ef85                	bnez	a5,80002140 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0) {
    8000210a:	00000097          	auipc	ra,0x0
    8000210e:	dee080e7          	jalr	-530(ra) # 80001ef8 <devintr>
    80002112:	cd1d                	beqz	a0,80002150 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING) yield();
    80002114:	4789                	li	a5,2
    80002116:	06f50a63          	beq	a0,a5,8000218a <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r"(x));
    8000211a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    8000211e:	10049073          	csrw	sstatus,s1
}
    80002122:	70a2                	ld	ra,40(sp)
    80002124:	7402                	ld	s0,32(sp)
    80002126:	64e2                	ld	s1,24(sp)
    80002128:	6942                	ld	s2,16(sp)
    8000212a:	69a2                	ld	s3,8(sp)
    8000212c:	6145                	addi	sp,sp,48
    8000212e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002130:	00006517          	auipc	a0,0x6
    80002134:	19850513          	addi	a0,a0,408 # 800082c8 <states.0+0xc8>
    80002138:	00004097          	auipc	ra,0x4
    8000213c:	db6080e7          	jalr	-586(ra) # 80005eee <panic>
  if (intr_get() != 0) panic("kerneltrap: interrupts enabled");
    80002140:	00006517          	auipc	a0,0x6
    80002144:	1b050513          	addi	a0,a0,432 # 800082f0 <states.0+0xf0>
    80002148:	00004097          	auipc	ra,0x4
    8000214c:	da6080e7          	jalr	-602(ra) # 80005eee <panic>
    printf("scause %p\n", scause);
    80002150:	85ce                	mv	a1,s3
    80002152:	00006517          	auipc	a0,0x6
    80002156:	1be50513          	addi	a0,a0,446 # 80008310 <states.0+0x110>
    8000215a:	00004097          	auipc	ra,0x4
    8000215e:	dde080e7          	jalr	-546(ra) # 80005f38 <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002162:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80002166:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000216a:	00006517          	auipc	a0,0x6
    8000216e:	1b650513          	addi	a0,a0,438 # 80008320 <states.0+0x120>
    80002172:	00004097          	auipc	ra,0x4
    80002176:	dc6080e7          	jalr	-570(ra) # 80005f38 <printf>
    panic("kerneltrap");
    8000217a:	00006517          	auipc	a0,0x6
    8000217e:	1be50513          	addi	a0,a0,446 # 80008338 <states.0+0x138>
    80002182:	00004097          	auipc	ra,0x4
    80002186:	d6c080e7          	jalr	-660(ra) # 80005eee <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING) yield();
    8000218a:	fffff097          	auipc	ra,0xfffff
    8000218e:	fda080e7          	jalr	-38(ra) # 80001164 <myproc>
    80002192:	d541                	beqz	a0,8000211a <kerneltrap+0x38>
    80002194:	fffff097          	auipc	ra,0xfffff
    80002198:	fd0080e7          	jalr	-48(ra) # 80001164 <myproc>
    8000219c:	4d18                	lw	a4,24(a0)
    8000219e:	4791                	li	a5,4
    800021a0:	f6f71de3          	bne	a4,a5,8000211a <kerneltrap+0x38>
    800021a4:	fffff097          	auipc	ra,0xfffff
    800021a8:	630080e7          	jalr	1584(ra) # 800017d4 <yield>
    800021ac:	b7bd                	j	8000211a <kerneltrap+0x38>

00000000800021ae <argraw>:
  struct proc *p = myproc();
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
  return strlen(buf);
}

static uint64 argraw(int n) {
    800021ae:	1101                	addi	sp,sp,-32
    800021b0:	ec06                	sd	ra,24(sp)
    800021b2:	e822                	sd	s0,16(sp)
    800021b4:	e426                	sd	s1,8(sp)
    800021b6:	1000                	addi	s0,sp,32
    800021b8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800021ba:	fffff097          	auipc	ra,0xfffff
    800021be:	faa080e7          	jalr	-86(ra) # 80001164 <myproc>
  switch (n) {
    800021c2:	4795                	li	a5,5
    800021c4:	0497e163          	bltu	a5,s1,80002206 <argraw+0x58>
    800021c8:	048a                	slli	s1,s1,0x2
    800021ca:	00006717          	auipc	a4,0x6
    800021ce:	1a670713          	addi	a4,a4,422 # 80008370 <states.0+0x170>
    800021d2:	94ba                	add	s1,s1,a4
    800021d4:	409c                	lw	a5,0(s1)
    800021d6:	97ba                	add	a5,a5,a4
    800021d8:	8782                	jr	a5
    case 0:
      return p->trapframe->a0;
    800021da:	6d3c                	ld	a5,88(a0)
    800021dc:	7ba8                	ld	a0,112(a5)
    case 5:
      return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800021de:	60e2                	ld	ra,24(sp)
    800021e0:	6442                	ld	s0,16(sp)
    800021e2:	64a2                	ld	s1,8(sp)
    800021e4:	6105                	addi	sp,sp,32
    800021e6:	8082                	ret
      return p->trapframe->a1;
    800021e8:	6d3c                	ld	a5,88(a0)
    800021ea:	7fa8                	ld	a0,120(a5)
    800021ec:	bfcd                	j	800021de <argraw+0x30>
      return p->trapframe->a2;
    800021ee:	6d3c                	ld	a5,88(a0)
    800021f0:	63c8                	ld	a0,128(a5)
    800021f2:	b7f5                	j	800021de <argraw+0x30>
      return p->trapframe->a3;
    800021f4:	6d3c                	ld	a5,88(a0)
    800021f6:	67c8                	ld	a0,136(a5)
    800021f8:	b7dd                	j	800021de <argraw+0x30>
      return p->trapframe->a4;
    800021fa:	6d3c                	ld	a5,88(a0)
    800021fc:	6bc8                	ld	a0,144(a5)
    800021fe:	b7c5                	j	800021de <argraw+0x30>
      return p->trapframe->a5;
    80002200:	6d3c                	ld	a5,88(a0)
    80002202:	6fc8                	ld	a0,152(a5)
    80002204:	bfe9                	j	800021de <argraw+0x30>
  panic("argraw");
    80002206:	00006517          	auipc	a0,0x6
    8000220a:	14250513          	addi	a0,a0,322 # 80008348 <states.0+0x148>
    8000220e:	00004097          	auipc	ra,0x4
    80002212:	ce0080e7          	jalr	-800(ra) # 80005eee <panic>

0000000080002216 <fetchaddr>:
int fetchaddr(uint64 addr, uint64 *ip) {
    80002216:	1101                	addi	sp,sp,-32
    80002218:	ec06                	sd	ra,24(sp)
    8000221a:	e822                	sd	s0,16(sp)
    8000221c:	e426                	sd	s1,8(sp)
    8000221e:	e04a                	sd	s2,0(sp)
    80002220:	1000                	addi	s0,sp,32
    80002222:	84aa                	mv	s1,a0
    80002224:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002226:	fffff097          	auipc	ra,0xfffff
    8000222a:	f3e080e7          	jalr	-194(ra) # 80001164 <myproc>
  if (addr >= p->sz ||
    8000222e:	653c                	ld	a5,72(a0)
    80002230:	02f4f863          	bgeu	s1,a5,80002260 <fetchaddr+0x4a>
      addr + sizeof(uint64) > p->sz)  // both tests needed, in case of overflow
    80002234:	00848713          	addi	a4,s1,8
  if (addr >= p->sz ||
    80002238:	02e7e663          	bltu	a5,a4,80002264 <fetchaddr+0x4e>
  if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0) return -1;
    8000223c:	46a1                	li	a3,8
    8000223e:	8626                	mv	a2,s1
    80002240:	85ca                	mv	a1,s2
    80002242:	6928                	ld	a0,80(a0)
    80002244:	fffff097          	auipc	ra,0xfffff
    80002248:	b84080e7          	jalr	-1148(ra) # 80000dc8 <copyin>
    8000224c:	00a03533          	snez	a0,a0
    80002250:	40a00533          	neg	a0,a0
}
    80002254:	60e2                	ld	ra,24(sp)
    80002256:	6442                	ld	s0,16(sp)
    80002258:	64a2                	ld	s1,8(sp)
    8000225a:	6902                	ld	s2,0(sp)
    8000225c:	6105                	addi	sp,sp,32
    8000225e:	8082                	ret
    return -1;
    80002260:	557d                	li	a0,-1
    80002262:	bfcd                	j	80002254 <fetchaddr+0x3e>
    80002264:	557d                	li	a0,-1
    80002266:	b7fd                	j	80002254 <fetchaddr+0x3e>

0000000080002268 <fetchstr>:
int fetchstr(uint64 addr, char *buf, int max) {
    80002268:	7179                	addi	sp,sp,-48
    8000226a:	f406                	sd	ra,40(sp)
    8000226c:	f022                	sd	s0,32(sp)
    8000226e:	ec26                	sd	s1,24(sp)
    80002270:	e84a                	sd	s2,16(sp)
    80002272:	e44e                	sd	s3,8(sp)
    80002274:	1800                	addi	s0,sp,48
    80002276:	892a                	mv	s2,a0
    80002278:	84ae                	mv	s1,a1
    8000227a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000227c:	fffff097          	auipc	ra,0xfffff
    80002280:	ee8080e7          	jalr	-280(ra) # 80001164 <myproc>
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
    80002284:	86ce                	mv	a3,s3
    80002286:	864a                	mv	a2,s2
    80002288:	85a6                	mv	a1,s1
    8000228a:	6928                	ld	a0,80(a0)
    8000228c:	fffff097          	auipc	ra,0xfffff
    80002290:	bca080e7          	jalr	-1078(ra) # 80000e56 <copyinstr>
    80002294:	00054e63          	bltz	a0,800022b0 <fetchstr+0x48>
  return strlen(buf);
    80002298:	8526                	mv	a0,s1
    8000229a:	ffffe097          	auipc	ra,0xffffe
    8000229e:	184080e7          	jalr	388(ra) # 8000041e <strlen>
}
    800022a2:	70a2                	ld	ra,40(sp)
    800022a4:	7402                	ld	s0,32(sp)
    800022a6:	64e2                	ld	s1,24(sp)
    800022a8:	6942                	ld	s2,16(sp)
    800022aa:	69a2                	ld	s3,8(sp)
    800022ac:	6145                	addi	sp,sp,48
    800022ae:	8082                	ret
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
    800022b0:	557d                	li	a0,-1
    800022b2:	bfc5                	j	800022a2 <fetchstr+0x3a>

00000000800022b4 <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip) { *ip = argraw(n); }
    800022b4:	1101                	addi	sp,sp,-32
    800022b6:	ec06                	sd	ra,24(sp)
    800022b8:	e822                	sd	s0,16(sp)
    800022ba:	e426                	sd	s1,8(sp)
    800022bc:	1000                	addi	s0,sp,32
    800022be:	84ae                	mv	s1,a1
    800022c0:	00000097          	auipc	ra,0x0
    800022c4:	eee080e7          	jalr	-274(ra) # 800021ae <argraw>
    800022c8:	c088                	sw	a0,0(s1)
    800022ca:	60e2                	ld	ra,24(sp)
    800022cc:	6442                	ld	s0,16(sp)
    800022ce:	64a2                	ld	s1,8(sp)
    800022d0:	6105                	addi	sp,sp,32
    800022d2:	8082                	ret

00000000800022d4 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip) { *ip = argraw(n); }
    800022d4:	1101                	addi	sp,sp,-32
    800022d6:	ec06                	sd	ra,24(sp)
    800022d8:	e822                	sd	s0,16(sp)
    800022da:	e426                	sd	s1,8(sp)
    800022dc:	1000                	addi	s0,sp,32
    800022de:	84ae                	mv	s1,a1
    800022e0:	00000097          	auipc	ra,0x0
    800022e4:	ece080e7          	jalr	-306(ra) # 800021ae <argraw>
    800022e8:	e088                	sd	a0,0(s1)
    800022ea:	60e2                	ld	ra,24(sp)
    800022ec:	6442                	ld	s0,16(sp)
    800022ee:	64a2                	ld	s1,8(sp)
    800022f0:	6105                	addi	sp,sp,32
    800022f2:	8082                	ret

00000000800022f4 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max) {
    800022f4:	7179                	addi	sp,sp,-48
    800022f6:	f406                	sd	ra,40(sp)
    800022f8:	f022                	sd	s0,32(sp)
    800022fa:	ec26                	sd	s1,24(sp)
    800022fc:	e84a                	sd	s2,16(sp)
    800022fe:	1800                	addi	s0,sp,48
    80002300:	84ae                	mv	s1,a1
    80002302:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002304:	fd840593          	addi	a1,s0,-40
    80002308:	00000097          	auipc	ra,0x0
    8000230c:	fcc080e7          	jalr	-52(ra) # 800022d4 <argaddr>
  return fetchstr(addr, buf, max);
    80002310:	864a                	mv	a2,s2
    80002312:	85a6                	mv	a1,s1
    80002314:	fd843503          	ld	a0,-40(s0)
    80002318:	00000097          	auipc	ra,0x0
    8000231c:	f50080e7          	jalr	-176(ra) # 80002268 <fetchstr>
}
    80002320:	70a2                	ld	ra,40(sp)
    80002322:	7402                	ld	s0,32(sp)
    80002324:	64e2                	ld	s1,24(sp)
    80002326:	6942                	ld	s2,16(sp)
    80002328:	6145                	addi	sp,sp,48
    8000232a:	8082                	ret

000000008000232c <syscall>:
    [SYS_mknod] = sys_mknod,   [SYS_unlink] = sys_unlink,
    [SYS_link] = sys_link,     [SYS_mkdir] = sys_mkdir,
    [SYS_close] = sys_close,
};

void syscall(void) {
    8000232c:	1101                	addi	sp,sp,-32
    8000232e:	ec06                	sd	ra,24(sp)
    80002330:	e822                	sd	s0,16(sp)
    80002332:	e426                	sd	s1,8(sp)
    80002334:	e04a                	sd	s2,0(sp)
    80002336:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002338:	fffff097          	auipc	ra,0xfffff
    8000233c:	e2c080e7          	jalr	-468(ra) # 80001164 <myproc>
    80002340:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002342:	05853903          	ld	s2,88(a0)
    80002346:	0a893783          	ld	a5,168(s2)
    8000234a:	0007869b          	sext.w	a3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000234e:	37fd                	addiw	a5,a5,-1
    80002350:	4751                	li	a4,20
    80002352:	00f76f63          	bltu	a4,a5,80002370 <syscall+0x44>
    80002356:	00369713          	slli	a4,a3,0x3
    8000235a:	00006797          	auipc	a5,0x6
    8000235e:	02e78793          	addi	a5,a5,46 # 80008388 <syscalls>
    80002362:	97ba                	add	a5,a5,a4
    80002364:	639c                	ld	a5,0(a5)
    80002366:	c789                	beqz	a5,80002370 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002368:	9782                	jalr	a5
    8000236a:	06a93823          	sd	a0,112(s2)
    8000236e:	a839                	j	8000238c <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    80002370:	15848613          	addi	a2,s1,344
    80002374:	588c                	lw	a1,48(s1)
    80002376:	00006517          	auipc	a0,0x6
    8000237a:	fda50513          	addi	a0,a0,-38 # 80008350 <states.0+0x150>
    8000237e:	00004097          	auipc	ra,0x4
    80002382:	bba080e7          	jalr	-1094(ra) # 80005f38 <printf>
    p->trapframe->a0 = -1;
    80002386:	6cbc                	ld	a5,88(s1)
    80002388:	577d                	li	a4,-1
    8000238a:	fbb8                	sd	a4,112(a5)
  }
}
    8000238c:	60e2                	ld	ra,24(sp)
    8000238e:	6442                	ld	s0,16(sp)
    80002390:	64a2                	ld	s1,8(sp)
    80002392:	6902                	ld	s2,0(sp)
    80002394:	6105                	addi	sp,sp,32
    80002396:	8082                	ret

0000000080002398 <sys_exit>:
#include "defs.h"
#include "proc.h"
#include "types.h"

uint64 sys_exit(void) {
    80002398:	1101                	addi	sp,sp,-32
    8000239a:	ec06                	sd	ra,24(sp)
    8000239c:	e822                	sd	s0,16(sp)
    8000239e:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800023a0:	fec40593          	addi	a1,s0,-20
    800023a4:	4501                	li	a0,0
    800023a6:	00000097          	auipc	ra,0x0
    800023aa:	f0e080e7          	jalr	-242(ra) # 800022b4 <argint>
  exit(n);
    800023ae:	fec42503          	lw	a0,-20(s0)
    800023b2:	fffff097          	auipc	ra,0xfffff
    800023b6:	592080e7          	jalr	1426(ra) # 80001944 <exit>
  return 0;  // not reached
}
    800023ba:	4501                	li	a0,0
    800023bc:	60e2                	ld	ra,24(sp)
    800023be:	6442                	ld	s0,16(sp)
    800023c0:	6105                	addi	sp,sp,32
    800023c2:	8082                	ret

00000000800023c4 <sys_getpid>:

uint64 sys_getpid(void) { return myproc()->pid; }
    800023c4:	1141                	addi	sp,sp,-16
    800023c6:	e406                	sd	ra,8(sp)
    800023c8:	e022                	sd	s0,0(sp)
    800023ca:	0800                	addi	s0,sp,16
    800023cc:	fffff097          	auipc	ra,0xfffff
    800023d0:	d98080e7          	jalr	-616(ra) # 80001164 <myproc>
    800023d4:	5908                	lw	a0,48(a0)
    800023d6:	60a2                	ld	ra,8(sp)
    800023d8:	6402                	ld	s0,0(sp)
    800023da:	0141                	addi	sp,sp,16
    800023dc:	8082                	ret

00000000800023de <sys_fork>:

uint64 sys_fork(void) { return fork(); }
    800023de:	1141                	addi	sp,sp,-16
    800023e0:	e406                	sd	ra,8(sp)
    800023e2:	e022                	sd	s0,0(sp)
    800023e4:	0800                	addi	s0,sp,16
    800023e6:	fffff097          	auipc	ra,0xfffff
    800023ea:	138080e7          	jalr	312(ra) # 8000151e <fork>
    800023ee:	60a2                	ld	ra,8(sp)
    800023f0:	6402                	ld	s0,0(sp)
    800023f2:	0141                	addi	sp,sp,16
    800023f4:	8082                	ret

00000000800023f6 <sys_wait>:

uint64 sys_wait(void) {
    800023f6:	1101                	addi	sp,sp,-32
    800023f8:	ec06                	sd	ra,24(sp)
    800023fa:	e822                	sd	s0,16(sp)
    800023fc:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800023fe:	fe840593          	addi	a1,s0,-24
    80002402:	4501                	li	a0,0
    80002404:	00000097          	auipc	ra,0x0
    80002408:	ed0080e7          	jalr	-304(ra) # 800022d4 <argaddr>
  return wait(p);
    8000240c:	fe843503          	ld	a0,-24(s0)
    80002410:	fffff097          	auipc	ra,0xfffff
    80002414:	6da080e7          	jalr	1754(ra) # 80001aea <wait>
}
    80002418:	60e2                	ld	ra,24(sp)
    8000241a:	6442                	ld	s0,16(sp)
    8000241c:	6105                	addi	sp,sp,32
    8000241e:	8082                	ret

0000000080002420 <sys_sbrk>:

uint64 sys_sbrk(void) {
    80002420:	7179                	addi	sp,sp,-48
    80002422:	f406                	sd	ra,40(sp)
    80002424:	f022                	sd	s0,32(sp)
    80002426:	ec26                	sd	s1,24(sp)
    80002428:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000242a:	fdc40593          	addi	a1,s0,-36
    8000242e:	4501                	li	a0,0
    80002430:	00000097          	auipc	ra,0x0
    80002434:	e84080e7          	jalr	-380(ra) # 800022b4 <argint>
  addr = myproc()->sz;
    80002438:	fffff097          	auipc	ra,0xfffff
    8000243c:	d2c080e7          	jalr	-724(ra) # 80001164 <myproc>
    80002440:	6524                	ld	s1,72(a0)
  if (growproc(n) < 0) return -1;
    80002442:	fdc42503          	lw	a0,-36(s0)
    80002446:	fffff097          	auipc	ra,0xfffff
    8000244a:	07c080e7          	jalr	124(ra) # 800014c2 <growproc>
    8000244e:	00054863          	bltz	a0,8000245e <sys_sbrk+0x3e>
  return addr;
}
    80002452:	8526                	mv	a0,s1
    80002454:	70a2                	ld	ra,40(sp)
    80002456:	7402                	ld	s0,32(sp)
    80002458:	64e2                	ld	s1,24(sp)
    8000245a:	6145                	addi	sp,sp,48
    8000245c:	8082                	ret
  if (growproc(n) < 0) return -1;
    8000245e:	54fd                	li	s1,-1
    80002460:	bfcd                	j	80002452 <sys_sbrk+0x32>

0000000080002462 <sys_sleep>:

uint64 sys_sleep(void) {
    80002462:	7139                	addi	sp,sp,-64
    80002464:	fc06                	sd	ra,56(sp)
    80002466:	f822                	sd	s0,48(sp)
    80002468:	f426                	sd	s1,40(sp)
    8000246a:	f04a                	sd	s2,32(sp)
    8000246c:	ec4e                	sd	s3,24(sp)
    8000246e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002470:	fcc40593          	addi	a1,s0,-52
    80002474:	4501                	li	a0,0
    80002476:	00000097          	auipc	ra,0x0
    8000247a:	e3e080e7          	jalr	-450(ra) # 800022b4 <argint>
  if (n < 0) n = 0;
    8000247e:	fcc42783          	lw	a5,-52(s0)
    80002482:	0607cf63          	bltz	a5,80002500 <sys_sleep+0x9e>
  acquire(&tickslock);
    80002486:	0002c517          	auipc	a0,0x2c
    8000248a:	24a50513          	addi	a0,a0,586 # 8002e6d0 <tickslock>
    8000248e:	00004097          	auipc	ra,0x4
    80002492:	f9c080e7          	jalr	-100(ra) # 8000642a <acquire>
  ticks0 = ticks;
    80002496:	00006917          	auipc	s2,0x6
    8000249a:	3d292903          	lw	s2,978(s2) # 80008868 <ticks>
  while (ticks - ticks0 < n) {
    8000249e:	fcc42783          	lw	a5,-52(s0)
    800024a2:	cf9d                	beqz	a5,800024e0 <sys_sleep+0x7e>
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800024a4:	0002c997          	auipc	s3,0x2c
    800024a8:	22c98993          	addi	s3,s3,556 # 8002e6d0 <tickslock>
    800024ac:	00006497          	auipc	s1,0x6
    800024b0:	3bc48493          	addi	s1,s1,956 # 80008868 <ticks>
    if (killed(myproc())) {
    800024b4:	fffff097          	auipc	ra,0xfffff
    800024b8:	cb0080e7          	jalr	-848(ra) # 80001164 <myproc>
    800024bc:	fffff097          	auipc	ra,0xfffff
    800024c0:	5fc080e7          	jalr	1532(ra) # 80001ab8 <killed>
    800024c4:	e129                	bnez	a0,80002506 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    800024c6:	85ce                	mv	a1,s3
    800024c8:	8526                	mv	a0,s1
    800024ca:	fffff097          	auipc	ra,0xfffff
    800024ce:	346080e7          	jalr	838(ra) # 80001810 <sleep>
  while (ticks - ticks0 < n) {
    800024d2:	409c                	lw	a5,0(s1)
    800024d4:	412787bb          	subw	a5,a5,s2
    800024d8:	fcc42703          	lw	a4,-52(s0)
    800024dc:	fce7ece3          	bltu	a5,a4,800024b4 <sys_sleep+0x52>
  }
  release(&tickslock);
    800024e0:	0002c517          	auipc	a0,0x2c
    800024e4:	1f050513          	addi	a0,a0,496 # 8002e6d0 <tickslock>
    800024e8:	00004097          	auipc	ra,0x4
    800024ec:	ff6080e7          	jalr	-10(ra) # 800064de <release>
  return 0;
    800024f0:	4501                	li	a0,0
}
    800024f2:	70e2                	ld	ra,56(sp)
    800024f4:	7442                	ld	s0,48(sp)
    800024f6:	74a2                	ld	s1,40(sp)
    800024f8:	7902                	ld	s2,32(sp)
    800024fa:	69e2                	ld	s3,24(sp)
    800024fc:	6121                	addi	sp,sp,64
    800024fe:	8082                	ret
  if (n < 0) n = 0;
    80002500:	fc042623          	sw	zero,-52(s0)
    80002504:	b749                	j	80002486 <sys_sleep+0x24>
      release(&tickslock);
    80002506:	0002c517          	auipc	a0,0x2c
    8000250a:	1ca50513          	addi	a0,a0,458 # 8002e6d0 <tickslock>
    8000250e:	00004097          	auipc	ra,0x4
    80002512:	fd0080e7          	jalr	-48(ra) # 800064de <release>
      return -1;
    80002516:	557d                	li	a0,-1
    80002518:	bfe9                	j	800024f2 <sys_sleep+0x90>

000000008000251a <sys_kill>:

uint64 sys_kill(void) {
    8000251a:	1101                	addi	sp,sp,-32
    8000251c:	ec06                	sd	ra,24(sp)
    8000251e:	e822                	sd	s0,16(sp)
    80002520:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002522:	fec40593          	addi	a1,s0,-20
    80002526:	4501                	li	a0,0
    80002528:	00000097          	auipc	ra,0x0
    8000252c:	d8c080e7          	jalr	-628(ra) # 800022b4 <argint>
  return kill(pid);
    80002530:	fec42503          	lw	a0,-20(s0)
    80002534:	fffff097          	auipc	ra,0xfffff
    80002538:	4e6080e7          	jalr	1254(ra) # 80001a1a <kill>
}
    8000253c:	60e2                	ld	ra,24(sp)
    8000253e:	6442                	ld	s0,16(sp)
    80002540:	6105                	addi	sp,sp,32
    80002542:	8082                	ret

0000000080002544 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
    80002544:	1101                	addi	sp,sp,-32
    80002546:	ec06                	sd	ra,24(sp)
    80002548:	e822                	sd	s0,16(sp)
    8000254a:	e426                	sd	s1,8(sp)
    8000254c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000254e:	0002c517          	auipc	a0,0x2c
    80002552:	18250513          	addi	a0,a0,386 # 8002e6d0 <tickslock>
    80002556:	00004097          	auipc	ra,0x4
    8000255a:	ed4080e7          	jalr	-300(ra) # 8000642a <acquire>
  xticks = ticks;
    8000255e:	00006497          	auipc	s1,0x6
    80002562:	30a4a483          	lw	s1,778(s1) # 80008868 <ticks>
  release(&tickslock);
    80002566:	0002c517          	auipc	a0,0x2c
    8000256a:	16a50513          	addi	a0,a0,362 # 8002e6d0 <tickslock>
    8000256e:	00004097          	auipc	ra,0x4
    80002572:	f70080e7          	jalr	-144(ra) # 800064de <release>
  return xticks;
}
    80002576:	02049513          	slli	a0,s1,0x20
    8000257a:	9101                	srli	a0,a0,0x20
    8000257c:	60e2                	ld	ra,24(sp)
    8000257e:	6442                	ld	s0,16(sp)
    80002580:	64a2                	ld	s1,8(sp)
    80002582:	6105                	addi	sp,sp,32
    80002584:	8082                	ret

0000000080002586 <binit>:
  // Sorted by how recently the buffer was used.
  // head.next is most recent, head.prev is least.
  struct buf head;
} bcache;

void binit(void) {
    80002586:	7179                	addi	sp,sp,-48
    80002588:	f406                	sd	ra,40(sp)
    8000258a:	f022                	sd	s0,32(sp)
    8000258c:	ec26                	sd	s1,24(sp)
    8000258e:	e84a                	sd	s2,16(sp)
    80002590:	e44e                	sd	s3,8(sp)
    80002592:	e052                	sd	s4,0(sp)
    80002594:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002596:	00006597          	auipc	a1,0x6
    8000259a:	ea258593          	addi	a1,a1,-350 # 80008438 <syscalls+0xb0>
    8000259e:	0002c517          	auipc	a0,0x2c
    800025a2:	14a50513          	addi	a0,a0,330 # 8002e6e8 <bcache>
    800025a6:	00004097          	auipc	ra,0x4
    800025aa:	df4080e7          	jalr	-524(ra) # 8000639a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800025ae:	00034797          	auipc	a5,0x34
    800025b2:	13a78793          	addi	a5,a5,314 # 800366e8 <bcache+0x8000>
    800025b6:	00034717          	auipc	a4,0x34
    800025ba:	39a70713          	addi	a4,a4,922 # 80036950 <bcache+0x8268>
    800025be:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800025c2:	2ae7bc23          	sd	a4,696(a5)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    800025c6:	0002c497          	auipc	s1,0x2c
    800025ca:	13a48493          	addi	s1,s1,314 # 8002e700 <bcache+0x18>
    b->next = bcache.head.next;
    800025ce:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800025d0:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800025d2:	00006a17          	auipc	s4,0x6
    800025d6:	e6ea0a13          	addi	s4,s4,-402 # 80008440 <syscalls+0xb8>
    b->next = bcache.head.next;
    800025da:	2b893783          	ld	a5,696(s2)
    800025de:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800025e0:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800025e4:	85d2                	mv	a1,s4
    800025e6:	01048513          	addi	a0,s1,16
    800025ea:	00001097          	auipc	ra,0x1
    800025ee:	4c4080e7          	jalr	1220(ra) # 80003aae <initsleeplock>
    bcache.head.next->prev = b;
    800025f2:	2b893783          	ld	a5,696(s2)
    800025f6:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800025f8:	2a993c23          	sd	s1,696(s2)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    800025fc:	45848493          	addi	s1,s1,1112
    80002600:	fd349de3          	bne	s1,s3,800025da <binit+0x54>
  }
}
    80002604:	70a2                	ld	ra,40(sp)
    80002606:	7402                	ld	s0,32(sp)
    80002608:	64e2                	ld	s1,24(sp)
    8000260a:	6942                	ld	s2,16(sp)
    8000260c:	69a2                	ld	s3,8(sp)
    8000260e:	6a02                	ld	s4,0(sp)
    80002610:	6145                	addi	sp,sp,48
    80002612:	8082                	ret

0000000080002614 <bread>:
  }
  panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.
struct buf *bread(uint dev, uint blockno) {
    80002614:	7179                	addi	sp,sp,-48
    80002616:	f406                	sd	ra,40(sp)
    80002618:	f022                	sd	s0,32(sp)
    8000261a:	ec26                	sd	s1,24(sp)
    8000261c:	e84a                	sd	s2,16(sp)
    8000261e:	e44e                	sd	s3,8(sp)
    80002620:	1800                	addi	s0,sp,48
    80002622:	892a                	mv	s2,a0
    80002624:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002626:	0002c517          	auipc	a0,0x2c
    8000262a:	0c250513          	addi	a0,a0,194 # 8002e6e8 <bcache>
    8000262e:	00004097          	auipc	ra,0x4
    80002632:	dfc080e7          	jalr	-516(ra) # 8000642a <acquire>
  for (b = bcache.head.next; b != &bcache.head; b = b->next) {
    80002636:	00034497          	auipc	s1,0x34
    8000263a:	36a4b483          	ld	s1,874(s1) # 800369a0 <bcache+0x82b8>
    8000263e:	00034797          	auipc	a5,0x34
    80002642:	31278793          	addi	a5,a5,786 # 80036950 <bcache+0x8268>
    80002646:	02f48f63          	beq	s1,a5,80002684 <bread+0x70>
    8000264a:	873e                	mv	a4,a5
    8000264c:	a021                	j	80002654 <bread+0x40>
    8000264e:	68a4                	ld	s1,80(s1)
    80002650:	02e48a63          	beq	s1,a4,80002684 <bread+0x70>
    if (b->dev == dev && b->blockno == blockno) {
    80002654:	449c                	lw	a5,8(s1)
    80002656:	ff279ce3          	bne	a5,s2,8000264e <bread+0x3a>
    8000265a:	44dc                	lw	a5,12(s1)
    8000265c:	ff3799e3          	bne	a5,s3,8000264e <bread+0x3a>
      b->refcnt++;
    80002660:	40bc                	lw	a5,64(s1)
    80002662:	2785                	addiw	a5,a5,1
    80002664:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002666:	0002c517          	auipc	a0,0x2c
    8000266a:	08250513          	addi	a0,a0,130 # 8002e6e8 <bcache>
    8000266e:	00004097          	auipc	ra,0x4
    80002672:	e70080e7          	jalr	-400(ra) # 800064de <release>
      acquiresleep(&b->lock);
    80002676:	01048513          	addi	a0,s1,16
    8000267a:	00001097          	auipc	ra,0x1
    8000267e:	46e080e7          	jalr	1134(ra) # 80003ae8 <acquiresleep>
      return b;
    80002682:	a8b9                	j	800026e0 <bread+0xcc>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002684:	00034497          	auipc	s1,0x34
    80002688:	3144b483          	ld	s1,788(s1) # 80036998 <bcache+0x82b0>
    8000268c:	00034797          	auipc	a5,0x34
    80002690:	2c478793          	addi	a5,a5,708 # 80036950 <bcache+0x8268>
    80002694:	00f48863          	beq	s1,a5,800026a4 <bread+0x90>
    80002698:	873e                	mv	a4,a5
    if (b->refcnt == 0) {
    8000269a:	40bc                	lw	a5,64(s1)
    8000269c:	cf81                	beqz	a5,800026b4 <bread+0xa0>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    8000269e:	64a4                	ld	s1,72(s1)
    800026a0:	fee49de3          	bne	s1,a4,8000269a <bread+0x86>
  panic("bget: no buffers");
    800026a4:	00006517          	auipc	a0,0x6
    800026a8:	da450513          	addi	a0,a0,-604 # 80008448 <syscalls+0xc0>
    800026ac:	00004097          	auipc	ra,0x4
    800026b0:	842080e7          	jalr	-1982(ra) # 80005eee <panic>
      b->dev = dev;
    800026b4:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800026b8:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800026bc:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800026c0:	4785                	li	a5,1
    800026c2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800026c4:	0002c517          	auipc	a0,0x2c
    800026c8:	02450513          	addi	a0,a0,36 # 8002e6e8 <bcache>
    800026cc:	00004097          	auipc	ra,0x4
    800026d0:	e12080e7          	jalr	-494(ra) # 800064de <release>
      acquiresleep(&b->lock);
    800026d4:	01048513          	addi	a0,s1,16
    800026d8:	00001097          	auipc	ra,0x1
    800026dc:	410080e7          	jalr	1040(ra) # 80003ae8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid) {
    800026e0:	409c                	lw	a5,0(s1)
    800026e2:	cb89                	beqz	a5,800026f4 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800026e4:	8526                	mv	a0,s1
    800026e6:	70a2                	ld	ra,40(sp)
    800026e8:	7402                	ld	s0,32(sp)
    800026ea:	64e2                	ld	s1,24(sp)
    800026ec:	6942                	ld	s2,16(sp)
    800026ee:	69a2                	ld	s3,8(sp)
    800026f0:	6145                	addi	sp,sp,48
    800026f2:	8082                	ret
    virtio_disk_rw(b, 0);
    800026f4:	4581                	li	a1,0
    800026f6:	8526                	mv	a0,s1
    800026f8:	00003097          	auipc	ra,0x3
    800026fc:	fec080e7          	jalr	-20(ra) # 800056e4 <virtio_disk_rw>
    b->valid = 1;
    80002700:	4785                	li	a5,1
    80002702:	c09c                	sw	a5,0(s1)
  return b;
    80002704:	b7c5                	j	800026e4 <bread+0xd0>

0000000080002706 <bwrite>:

// Write b's contents to disk.  Must be locked.
void bwrite(struct buf *b) {
    80002706:	1101                	addi	sp,sp,-32
    80002708:	ec06                	sd	ra,24(sp)
    8000270a:	e822                	sd	s0,16(sp)
    8000270c:	e426                	sd	s1,8(sp)
    8000270e:	1000                	addi	s0,sp,32
    80002710:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock)) panic("bwrite");
    80002712:	0541                	addi	a0,a0,16
    80002714:	00001097          	auipc	ra,0x1
    80002718:	46e080e7          	jalr	1134(ra) # 80003b82 <holdingsleep>
    8000271c:	cd01                	beqz	a0,80002734 <bwrite+0x2e>
  virtio_disk_rw(b, 1);
    8000271e:	4585                	li	a1,1
    80002720:	8526                	mv	a0,s1
    80002722:	00003097          	auipc	ra,0x3
    80002726:	fc2080e7          	jalr	-62(ra) # 800056e4 <virtio_disk_rw>
}
    8000272a:	60e2                	ld	ra,24(sp)
    8000272c:	6442                	ld	s0,16(sp)
    8000272e:	64a2                	ld	s1,8(sp)
    80002730:	6105                	addi	sp,sp,32
    80002732:	8082                	ret
  if (!holdingsleep(&b->lock)) panic("bwrite");
    80002734:	00006517          	auipc	a0,0x6
    80002738:	d2c50513          	addi	a0,a0,-724 # 80008460 <syscalls+0xd8>
    8000273c:	00003097          	auipc	ra,0x3
    80002740:	7b2080e7          	jalr	1970(ra) # 80005eee <panic>

0000000080002744 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void brelse(struct buf *b) {
    80002744:	1101                	addi	sp,sp,-32
    80002746:	ec06                	sd	ra,24(sp)
    80002748:	e822                	sd	s0,16(sp)
    8000274a:	e426                	sd	s1,8(sp)
    8000274c:	e04a                	sd	s2,0(sp)
    8000274e:	1000                	addi	s0,sp,32
    80002750:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock)) panic("brelse");
    80002752:	01050913          	addi	s2,a0,16
    80002756:	854a                	mv	a0,s2
    80002758:	00001097          	auipc	ra,0x1
    8000275c:	42a080e7          	jalr	1066(ra) # 80003b82 <holdingsleep>
    80002760:	c92d                	beqz	a0,800027d2 <brelse+0x8e>

  releasesleep(&b->lock);
    80002762:	854a                	mv	a0,s2
    80002764:	00001097          	auipc	ra,0x1
    80002768:	3da080e7          	jalr	986(ra) # 80003b3e <releasesleep>

  acquire(&bcache.lock);
    8000276c:	0002c517          	auipc	a0,0x2c
    80002770:	f7c50513          	addi	a0,a0,-132 # 8002e6e8 <bcache>
    80002774:	00004097          	auipc	ra,0x4
    80002778:	cb6080e7          	jalr	-842(ra) # 8000642a <acquire>
  b->refcnt--;
    8000277c:	40bc                	lw	a5,64(s1)
    8000277e:	37fd                	addiw	a5,a5,-1
    80002780:	0007871b          	sext.w	a4,a5
    80002784:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002786:	eb05                	bnez	a4,800027b6 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002788:	68bc                	ld	a5,80(s1)
    8000278a:	64b8                	ld	a4,72(s1)
    8000278c:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000278e:	64bc                	ld	a5,72(s1)
    80002790:	68b8                	ld	a4,80(s1)
    80002792:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002794:	00034797          	auipc	a5,0x34
    80002798:	f5478793          	addi	a5,a5,-172 # 800366e8 <bcache+0x8000>
    8000279c:	2b87b703          	ld	a4,696(a5)
    800027a0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800027a2:	00034717          	auipc	a4,0x34
    800027a6:	1ae70713          	addi	a4,a4,430 # 80036950 <bcache+0x8268>
    800027aa:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800027ac:	2b87b703          	ld	a4,696(a5)
    800027b0:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800027b2:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    800027b6:	0002c517          	auipc	a0,0x2c
    800027ba:	f3250513          	addi	a0,a0,-206 # 8002e6e8 <bcache>
    800027be:	00004097          	auipc	ra,0x4
    800027c2:	d20080e7          	jalr	-736(ra) # 800064de <release>
}
    800027c6:	60e2                	ld	ra,24(sp)
    800027c8:	6442                	ld	s0,16(sp)
    800027ca:	64a2                	ld	s1,8(sp)
    800027cc:	6902                	ld	s2,0(sp)
    800027ce:	6105                	addi	sp,sp,32
    800027d0:	8082                	ret
  if (!holdingsleep(&b->lock)) panic("brelse");
    800027d2:	00006517          	auipc	a0,0x6
    800027d6:	c9650513          	addi	a0,a0,-874 # 80008468 <syscalls+0xe0>
    800027da:	00003097          	auipc	ra,0x3
    800027de:	714080e7          	jalr	1812(ra) # 80005eee <panic>

00000000800027e2 <bpin>:

void bpin(struct buf *b) {
    800027e2:	1101                	addi	sp,sp,-32
    800027e4:	ec06                	sd	ra,24(sp)
    800027e6:	e822                	sd	s0,16(sp)
    800027e8:	e426                	sd	s1,8(sp)
    800027ea:	1000                	addi	s0,sp,32
    800027ec:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800027ee:	0002c517          	auipc	a0,0x2c
    800027f2:	efa50513          	addi	a0,a0,-262 # 8002e6e8 <bcache>
    800027f6:	00004097          	auipc	ra,0x4
    800027fa:	c34080e7          	jalr	-972(ra) # 8000642a <acquire>
  b->refcnt++;
    800027fe:	40bc                	lw	a5,64(s1)
    80002800:	2785                	addiw	a5,a5,1
    80002802:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002804:	0002c517          	auipc	a0,0x2c
    80002808:	ee450513          	addi	a0,a0,-284 # 8002e6e8 <bcache>
    8000280c:	00004097          	auipc	ra,0x4
    80002810:	cd2080e7          	jalr	-814(ra) # 800064de <release>
}
    80002814:	60e2                	ld	ra,24(sp)
    80002816:	6442                	ld	s0,16(sp)
    80002818:	64a2                	ld	s1,8(sp)
    8000281a:	6105                	addi	sp,sp,32
    8000281c:	8082                	ret

000000008000281e <bunpin>:

void bunpin(struct buf *b) {
    8000281e:	1101                	addi	sp,sp,-32
    80002820:	ec06                	sd	ra,24(sp)
    80002822:	e822                	sd	s0,16(sp)
    80002824:	e426                	sd	s1,8(sp)
    80002826:	1000                	addi	s0,sp,32
    80002828:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000282a:	0002c517          	auipc	a0,0x2c
    8000282e:	ebe50513          	addi	a0,a0,-322 # 8002e6e8 <bcache>
    80002832:	00004097          	auipc	ra,0x4
    80002836:	bf8080e7          	jalr	-1032(ra) # 8000642a <acquire>
  b->refcnt--;
    8000283a:	40bc                	lw	a5,64(s1)
    8000283c:	37fd                	addiw	a5,a5,-1
    8000283e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002840:	0002c517          	auipc	a0,0x2c
    80002844:	ea850513          	addi	a0,a0,-344 # 8002e6e8 <bcache>
    80002848:	00004097          	auipc	ra,0x4
    8000284c:	c96080e7          	jalr	-874(ra) # 800064de <release>
}
    80002850:	60e2                	ld	ra,24(sp)
    80002852:	6442                	ld	s0,16(sp)
    80002854:	64a2                	ld	s1,8(sp)
    80002856:	6105                	addi	sp,sp,32
    80002858:	8082                	ret

000000008000285a <bfree>:
  printf("balloc: out of blocks\n");
  return 0;
}

// Free a disk block.
static void bfree(int dev, uint b) {
    8000285a:	1101                	addi	sp,sp,-32
    8000285c:	ec06                	sd	ra,24(sp)
    8000285e:	e822                	sd	s0,16(sp)
    80002860:	e426                	sd	s1,8(sp)
    80002862:	e04a                	sd	s2,0(sp)
    80002864:	1000                	addi	s0,sp,32
    80002866:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002868:	00d5d59b          	srliw	a1,a1,0xd
    8000286c:	00034797          	auipc	a5,0x34
    80002870:	5587a783          	lw	a5,1368(a5) # 80036dc4 <sb+0x1c>
    80002874:	9dbd                	addw	a1,a1,a5
    80002876:	00000097          	auipc	ra,0x0
    8000287a:	d9e080e7          	jalr	-610(ra) # 80002614 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000287e:	0074f713          	andi	a4,s1,7
    80002882:	4785                	li	a5,1
    80002884:	00e797bb          	sllw	a5,a5,a4
  if ((bp->data[bi / 8] & m) == 0) panic("freeing free block");
    80002888:	14ce                	slli	s1,s1,0x33
    8000288a:	90d9                	srli	s1,s1,0x36
    8000288c:	00950733          	add	a4,a0,s1
    80002890:	05874703          	lbu	a4,88(a4)
    80002894:	00e7f6b3          	and	a3,a5,a4
    80002898:	c69d                	beqz	a3,800028c6 <bfree+0x6c>
    8000289a:	892a                	mv	s2,a0
  bp->data[bi / 8] &= ~m;
    8000289c:	94aa                	add	s1,s1,a0
    8000289e:	fff7c793          	not	a5,a5
    800028a2:	8ff9                	and	a5,a5,a4
    800028a4:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800028a8:	00001097          	auipc	ra,0x1
    800028ac:	120080e7          	jalr	288(ra) # 800039c8 <log_write>
  brelse(bp);
    800028b0:	854a                	mv	a0,s2
    800028b2:	00000097          	auipc	ra,0x0
    800028b6:	e92080e7          	jalr	-366(ra) # 80002744 <brelse>
}
    800028ba:	60e2                	ld	ra,24(sp)
    800028bc:	6442                	ld	s0,16(sp)
    800028be:	64a2                	ld	s1,8(sp)
    800028c0:	6902                	ld	s2,0(sp)
    800028c2:	6105                	addi	sp,sp,32
    800028c4:	8082                	ret
  if ((bp->data[bi / 8] & m) == 0) panic("freeing free block");
    800028c6:	00006517          	auipc	a0,0x6
    800028ca:	baa50513          	addi	a0,a0,-1110 # 80008470 <syscalls+0xe8>
    800028ce:	00003097          	auipc	ra,0x3
    800028d2:	620080e7          	jalr	1568(ra) # 80005eee <panic>

00000000800028d6 <balloc>:
static uint balloc(uint dev) {
    800028d6:	711d                	addi	sp,sp,-96
    800028d8:	ec86                	sd	ra,88(sp)
    800028da:	e8a2                	sd	s0,80(sp)
    800028dc:	e4a6                	sd	s1,72(sp)
    800028de:	e0ca                	sd	s2,64(sp)
    800028e0:	fc4e                	sd	s3,56(sp)
    800028e2:	f852                	sd	s4,48(sp)
    800028e4:	f456                	sd	s5,40(sp)
    800028e6:	f05a                	sd	s6,32(sp)
    800028e8:	ec5e                	sd	s7,24(sp)
    800028ea:	e862                	sd	s8,16(sp)
    800028ec:	e466                	sd	s9,8(sp)
    800028ee:	1080                	addi	s0,sp,96
  for (b = 0; b < sb.size; b += BPB) {
    800028f0:	00034797          	auipc	a5,0x34
    800028f4:	4bc7a783          	lw	a5,1212(a5) # 80036dac <sb+0x4>
    800028f8:	10078163          	beqz	a5,800029fa <balloc+0x124>
    800028fc:	8baa                	mv	s7,a0
    800028fe:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002900:	00034b17          	auipc	s6,0x34
    80002904:	4a8b0b13          	addi	s6,s6,1192 # 80036da8 <sb>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002908:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000290a:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    8000290c:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB) {
    8000290e:	6c89                	lui	s9,0x2
    80002910:	a061                	j	80002998 <balloc+0xc2>
        bp->data[bi / 8] |= m;            // Mark block in use.
    80002912:	974a                	add	a4,a4,s2
    80002914:	8fd5                	or	a5,a5,a3
    80002916:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000291a:	854a                	mv	a0,s2
    8000291c:	00001097          	auipc	ra,0x1
    80002920:	0ac080e7          	jalr	172(ra) # 800039c8 <log_write>
        brelse(bp);
    80002924:	854a                	mv	a0,s2
    80002926:	00000097          	auipc	ra,0x0
    8000292a:	e1e080e7          	jalr	-482(ra) # 80002744 <brelse>
  bp = bread(dev, bno);
    8000292e:	85a6                	mv	a1,s1
    80002930:	855e                	mv	a0,s7
    80002932:	00000097          	auipc	ra,0x0
    80002936:	ce2080e7          	jalr	-798(ra) # 80002614 <bread>
    8000293a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000293c:	40000613          	li	a2,1024
    80002940:	4581                	li	a1,0
    80002942:	05850513          	addi	a0,a0,88
    80002946:	ffffe097          	auipc	ra,0xffffe
    8000294a:	95c080e7          	jalr	-1700(ra) # 800002a2 <memset>
  log_write(bp);
    8000294e:	854a                	mv	a0,s2
    80002950:	00001097          	auipc	ra,0x1
    80002954:	078080e7          	jalr	120(ra) # 800039c8 <log_write>
  brelse(bp);
    80002958:	854a                	mv	a0,s2
    8000295a:	00000097          	auipc	ra,0x0
    8000295e:	dea080e7          	jalr	-534(ra) # 80002744 <brelse>
}
    80002962:	8526                	mv	a0,s1
    80002964:	60e6                	ld	ra,88(sp)
    80002966:	6446                	ld	s0,80(sp)
    80002968:	64a6                	ld	s1,72(sp)
    8000296a:	6906                	ld	s2,64(sp)
    8000296c:	79e2                	ld	s3,56(sp)
    8000296e:	7a42                	ld	s4,48(sp)
    80002970:	7aa2                	ld	s5,40(sp)
    80002972:	7b02                	ld	s6,32(sp)
    80002974:	6be2                	ld	s7,24(sp)
    80002976:	6c42                	ld	s8,16(sp)
    80002978:	6ca2                	ld	s9,8(sp)
    8000297a:	6125                	addi	sp,sp,96
    8000297c:	8082                	ret
    brelse(bp);
    8000297e:	854a                	mv	a0,s2
    80002980:	00000097          	auipc	ra,0x0
    80002984:	dc4080e7          	jalr	-572(ra) # 80002744 <brelse>
  for (b = 0; b < sb.size; b += BPB) {
    80002988:	015c87bb          	addw	a5,s9,s5
    8000298c:	00078a9b          	sext.w	s5,a5
    80002990:	004b2703          	lw	a4,4(s6)
    80002994:	06eaf363          	bgeu	s5,a4,800029fa <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    80002998:	41fad79b          	sraiw	a5,s5,0x1f
    8000299c:	0137d79b          	srliw	a5,a5,0x13
    800029a0:	015787bb          	addw	a5,a5,s5
    800029a4:	40d7d79b          	sraiw	a5,a5,0xd
    800029a8:	01cb2583          	lw	a1,28(s6)
    800029ac:	9dbd                	addw	a1,a1,a5
    800029ae:	855e                	mv	a0,s7
    800029b0:	00000097          	auipc	ra,0x0
    800029b4:	c64080e7          	jalr	-924(ra) # 80002614 <bread>
    800029b8:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800029ba:	004b2503          	lw	a0,4(s6)
    800029be:	000a849b          	sext.w	s1,s5
    800029c2:	8662                	mv	a2,s8
    800029c4:	faa4fde3          	bgeu	s1,a0,8000297e <balloc+0xa8>
      m = 1 << (bi % 8);
    800029c8:	41f6579b          	sraiw	a5,a2,0x1f
    800029cc:	01d7d69b          	srliw	a3,a5,0x1d
    800029d0:	00c6873b          	addw	a4,a3,a2
    800029d4:	00777793          	andi	a5,a4,7
    800029d8:	9f95                	subw	a5,a5,a3
    800029da:	00f997bb          	sllw	a5,s3,a5
      if ((bp->data[bi / 8] & m) == 0) {  // Is block free?
    800029de:	4037571b          	sraiw	a4,a4,0x3
    800029e2:	00e906b3          	add	a3,s2,a4
    800029e6:	0586c683          	lbu	a3,88(a3)
    800029ea:	00d7f5b3          	and	a1,a5,a3
    800029ee:	d195                	beqz	a1,80002912 <balloc+0x3c>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800029f0:	2605                	addiw	a2,a2,1
    800029f2:	2485                	addiw	s1,s1,1
    800029f4:	fd4618e3          	bne	a2,s4,800029c4 <balloc+0xee>
    800029f8:	b759                	j	8000297e <balloc+0xa8>
  printf("balloc: out of blocks\n");
    800029fa:	00006517          	auipc	a0,0x6
    800029fe:	a8e50513          	addi	a0,a0,-1394 # 80008488 <syscalls+0x100>
    80002a02:	00003097          	auipc	ra,0x3
    80002a06:	536080e7          	jalr	1334(ra) # 80005f38 <printf>
  return 0;
    80002a0a:	4481                	li	s1,0
    80002a0c:	bf99                	j	80002962 <balloc+0x8c>

0000000080002a0e <bmap>:
// listed in block ip->addrs[NDIRECT].

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint bmap(struct inode *ip, uint bn) {
    80002a0e:	7179                	addi	sp,sp,-48
    80002a10:	f406                	sd	ra,40(sp)
    80002a12:	f022                	sd	s0,32(sp)
    80002a14:	ec26                	sd	s1,24(sp)
    80002a16:	e84a                	sd	s2,16(sp)
    80002a18:	e44e                	sd	s3,8(sp)
    80002a1a:	e052                	sd	s4,0(sp)
    80002a1c:	1800                	addi	s0,sp,48
    80002a1e:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT) {
    80002a20:	47ad                	li	a5,11
    80002a22:	02b7e763          	bltu	a5,a1,80002a50 <bmap+0x42>
    if ((addr = ip->addrs[bn]) == 0) {
    80002a26:	02059493          	slli	s1,a1,0x20
    80002a2a:	9081                	srli	s1,s1,0x20
    80002a2c:	048a                	slli	s1,s1,0x2
    80002a2e:	94aa                	add	s1,s1,a0
    80002a30:	0504a903          	lw	s2,80(s1)
    80002a34:	06091e63          	bnez	s2,80002ab0 <bmap+0xa2>
      addr = balloc(ip->dev);
    80002a38:	4108                	lw	a0,0(a0)
    80002a3a:	00000097          	auipc	ra,0x0
    80002a3e:	e9c080e7          	jalr	-356(ra) # 800028d6 <balloc>
    80002a42:	0005091b          	sext.w	s2,a0
      if (addr == 0) return 0;
    80002a46:	06090563          	beqz	s2,80002ab0 <bmap+0xa2>
      ip->addrs[bn] = addr;
    80002a4a:	0524a823          	sw	s2,80(s1)
    80002a4e:	a08d                	j	80002ab0 <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002a50:	ff45849b          	addiw	s1,a1,-12
    80002a54:	0004871b          	sext.w	a4,s1

  if (bn < NINDIRECT) {
    80002a58:	0ff00793          	li	a5,255
    80002a5c:	08e7e563          	bltu	a5,a4,80002ae6 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0) {
    80002a60:	08052903          	lw	s2,128(a0)
    80002a64:	00091d63          	bnez	s2,80002a7e <bmap+0x70>
      addr = balloc(ip->dev);
    80002a68:	4108                	lw	a0,0(a0)
    80002a6a:	00000097          	auipc	ra,0x0
    80002a6e:	e6c080e7          	jalr	-404(ra) # 800028d6 <balloc>
    80002a72:	0005091b          	sext.w	s2,a0
      if (addr == 0) return 0;
    80002a76:	02090d63          	beqz	s2,80002ab0 <bmap+0xa2>
      ip->addrs[NDIRECT] = addr;
    80002a7a:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002a7e:	85ca                	mv	a1,s2
    80002a80:	0009a503          	lw	a0,0(s3)
    80002a84:	00000097          	auipc	ra,0x0
    80002a88:	b90080e7          	jalr	-1136(ra) # 80002614 <bread>
    80002a8c:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    80002a8e:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0) {
    80002a92:	02049593          	slli	a1,s1,0x20
    80002a96:	9181                	srli	a1,a1,0x20
    80002a98:	058a                	slli	a1,a1,0x2
    80002a9a:	00b784b3          	add	s1,a5,a1
    80002a9e:	0004a903          	lw	s2,0(s1)
    80002aa2:	02090063          	beqz	s2,80002ac2 <bmap+0xb4>
      if (addr) {
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002aa6:	8552                	mv	a0,s4
    80002aa8:	00000097          	auipc	ra,0x0
    80002aac:	c9c080e7          	jalr	-868(ra) # 80002744 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002ab0:	854a                	mv	a0,s2
    80002ab2:	70a2                	ld	ra,40(sp)
    80002ab4:	7402                	ld	s0,32(sp)
    80002ab6:	64e2                	ld	s1,24(sp)
    80002ab8:	6942                	ld	s2,16(sp)
    80002aba:	69a2                	ld	s3,8(sp)
    80002abc:	6a02                	ld	s4,0(sp)
    80002abe:	6145                	addi	sp,sp,48
    80002ac0:	8082                	ret
      addr = balloc(ip->dev);
    80002ac2:	0009a503          	lw	a0,0(s3)
    80002ac6:	00000097          	auipc	ra,0x0
    80002aca:	e10080e7          	jalr	-496(ra) # 800028d6 <balloc>
    80002ace:	0005091b          	sext.w	s2,a0
      if (addr) {
    80002ad2:	fc090ae3          	beqz	s2,80002aa6 <bmap+0x98>
        a[bn] = addr;
    80002ad6:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002ada:	8552                	mv	a0,s4
    80002adc:	00001097          	auipc	ra,0x1
    80002ae0:	eec080e7          	jalr	-276(ra) # 800039c8 <log_write>
    80002ae4:	b7c9                	j	80002aa6 <bmap+0x98>
  panic("bmap: out of range");
    80002ae6:	00006517          	auipc	a0,0x6
    80002aea:	9ba50513          	addi	a0,a0,-1606 # 800084a0 <syscalls+0x118>
    80002aee:	00003097          	auipc	ra,0x3
    80002af2:	400080e7          	jalr	1024(ra) # 80005eee <panic>

0000000080002af6 <iget>:
static struct inode *iget(uint dev, uint inum) {
    80002af6:	7179                	addi	sp,sp,-48
    80002af8:	f406                	sd	ra,40(sp)
    80002afa:	f022                	sd	s0,32(sp)
    80002afc:	ec26                	sd	s1,24(sp)
    80002afe:	e84a                	sd	s2,16(sp)
    80002b00:	e44e                	sd	s3,8(sp)
    80002b02:	e052                	sd	s4,0(sp)
    80002b04:	1800                	addi	s0,sp,48
    80002b06:	89aa                	mv	s3,a0
    80002b08:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002b0a:	00034517          	auipc	a0,0x34
    80002b0e:	2be50513          	addi	a0,a0,702 # 80036dc8 <itable>
    80002b12:	00004097          	auipc	ra,0x4
    80002b16:	918080e7          	jalr	-1768(ra) # 8000642a <acquire>
  empty = 0;
    80002b1a:	4901                	li	s2,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80002b1c:	00034497          	auipc	s1,0x34
    80002b20:	2c448493          	addi	s1,s1,708 # 80036de0 <itable+0x18>
    80002b24:	00036697          	auipc	a3,0x36
    80002b28:	d4c68693          	addi	a3,a3,-692 # 80038870 <log>
    80002b2c:	a039                	j	80002b3a <iget+0x44>
    if (empty == 0 && ip->ref == 0)  // Remember empty slot.
    80002b2e:	02090b63          	beqz	s2,80002b64 <iget+0x6e>
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80002b32:	08848493          	addi	s1,s1,136
    80002b36:	02d48a63          	beq	s1,a3,80002b6a <iget+0x74>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    80002b3a:	449c                	lw	a5,8(s1)
    80002b3c:	fef059e3          	blez	a5,80002b2e <iget+0x38>
    80002b40:	4098                	lw	a4,0(s1)
    80002b42:	ff3716e3          	bne	a4,s3,80002b2e <iget+0x38>
    80002b46:	40d8                	lw	a4,4(s1)
    80002b48:	ff4713e3          	bne	a4,s4,80002b2e <iget+0x38>
      ip->ref++;
    80002b4c:	2785                	addiw	a5,a5,1
    80002b4e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002b50:	00034517          	auipc	a0,0x34
    80002b54:	27850513          	addi	a0,a0,632 # 80036dc8 <itable>
    80002b58:	00004097          	auipc	ra,0x4
    80002b5c:	986080e7          	jalr	-1658(ra) # 800064de <release>
      return ip;
    80002b60:	8926                	mv	s2,s1
    80002b62:	a03d                	j	80002b90 <iget+0x9a>
    if (empty == 0 && ip->ref == 0)  // Remember empty slot.
    80002b64:	f7f9                	bnez	a5,80002b32 <iget+0x3c>
    80002b66:	8926                	mv	s2,s1
    80002b68:	b7e9                	j	80002b32 <iget+0x3c>
  if (empty == 0) panic("iget: no inodes");
    80002b6a:	02090c63          	beqz	s2,80002ba2 <iget+0xac>
  ip->dev = dev;
    80002b6e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002b72:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002b76:	4785                	li	a5,1
    80002b78:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002b7c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002b80:	00034517          	auipc	a0,0x34
    80002b84:	24850513          	addi	a0,a0,584 # 80036dc8 <itable>
    80002b88:	00004097          	auipc	ra,0x4
    80002b8c:	956080e7          	jalr	-1706(ra) # 800064de <release>
}
    80002b90:	854a                	mv	a0,s2
    80002b92:	70a2                	ld	ra,40(sp)
    80002b94:	7402                	ld	s0,32(sp)
    80002b96:	64e2                	ld	s1,24(sp)
    80002b98:	6942                	ld	s2,16(sp)
    80002b9a:	69a2                	ld	s3,8(sp)
    80002b9c:	6a02                	ld	s4,0(sp)
    80002b9e:	6145                	addi	sp,sp,48
    80002ba0:	8082                	ret
  if (empty == 0) panic("iget: no inodes");
    80002ba2:	00006517          	auipc	a0,0x6
    80002ba6:	91650513          	addi	a0,a0,-1770 # 800084b8 <syscalls+0x130>
    80002baa:	00003097          	auipc	ra,0x3
    80002bae:	344080e7          	jalr	836(ra) # 80005eee <panic>

0000000080002bb2 <fsinit>:
void fsinit(int dev) {
    80002bb2:	7179                	addi	sp,sp,-48
    80002bb4:	f406                	sd	ra,40(sp)
    80002bb6:	f022                	sd	s0,32(sp)
    80002bb8:	ec26                	sd	s1,24(sp)
    80002bba:	e84a                	sd	s2,16(sp)
    80002bbc:	e44e                	sd	s3,8(sp)
    80002bbe:	1800                	addi	s0,sp,48
    80002bc0:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002bc2:	4585                	li	a1,1
    80002bc4:	00000097          	auipc	ra,0x0
    80002bc8:	a50080e7          	jalr	-1456(ra) # 80002614 <bread>
    80002bcc:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002bce:	00034997          	auipc	s3,0x34
    80002bd2:	1da98993          	addi	s3,s3,474 # 80036da8 <sb>
    80002bd6:	02000613          	li	a2,32
    80002bda:	05850593          	addi	a1,a0,88
    80002bde:	854e                	mv	a0,s3
    80002be0:	ffffd097          	auipc	ra,0xffffd
    80002be4:	71e080e7          	jalr	1822(ra) # 800002fe <memmove>
  brelse(bp);
    80002be8:	8526                	mv	a0,s1
    80002bea:	00000097          	auipc	ra,0x0
    80002bee:	b5a080e7          	jalr	-1190(ra) # 80002744 <brelse>
  if (sb.magic != FSMAGIC) panic("invalid file system");
    80002bf2:	0009a703          	lw	a4,0(s3)
    80002bf6:	102037b7          	lui	a5,0x10203
    80002bfa:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002bfe:	02f71263          	bne	a4,a5,80002c22 <fsinit+0x70>
  initlog(dev, &sb);
    80002c02:	00034597          	auipc	a1,0x34
    80002c06:	1a658593          	addi	a1,a1,422 # 80036da8 <sb>
    80002c0a:	854a                	mv	a0,s2
    80002c0c:	00001097          	auipc	ra,0x1
    80002c10:	b40080e7          	jalr	-1216(ra) # 8000374c <initlog>
}
    80002c14:	70a2                	ld	ra,40(sp)
    80002c16:	7402                	ld	s0,32(sp)
    80002c18:	64e2                	ld	s1,24(sp)
    80002c1a:	6942                	ld	s2,16(sp)
    80002c1c:	69a2                	ld	s3,8(sp)
    80002c1e:	6145                	addi	sp,sp,48
    80002c20:	8082                	ret
  if (sb.magic != FSMAGIC) panic("invalid file system");
    80002c22:	00006517          	auipc	a0,0x6
    80002c26:	8a650513          	addi	a0,a0,-1882 # 800084c8 <syscalls+0x140>
    80002c2a:	00003097          	auipc	ra,0x3
    80002c2e:	2c4080e7          	jalr	708(ra) # 80005eee <panic>

0000000080002c32 <iinit>:
void iinit() {
    80002c32:	7179                	addi	sp,sp,-48
    80002c34:	f406                	sd	ra,40(sp)
    80002c36:	f022                	sd	s0,32(sp)
    80002c38:	ec26                	sd	s1,24(sp)
    80002c3a:	e84a                	sd	s2,16(sp)
    80002c3c:	e44e                	sd	s3,8(sp)
    80002c3e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002c40:	00006597          	auipc	a1,0x6
    80002c44:	8a058593          	addi	a1,a1,-1888 # 800084e0 <syscalls+0x158>
    80002c48:	00034517          	auipc	a0,0x34
    80002c4c:	18050513          	addi	a0,a0,384 # 80036dc8 <itable>
    80002c50:	00003097          	auipc	ra,0x3
    80002c54:	74a080e7          	jalr	1866(ra) # 8000639a <initlock>
  for (i = 0; i < NINODE; i++) {
    80002c58:	00034497          	auipc	s1,0x34
    80002c5c:	19848493          	addi	s1,s1,408 # 80036df0 <itable+0x28>
    80002c60:	00036997          	auipc	s3,0x36
    80002c64:	c2098993          	addi	s3,s3,-992 # 80038880 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002c68:	00006917          	auipc	s2,0x6
    80002c6c:	88090913          	addi	s2,s2,-1920 # 800084e8 <syscalls+0x160>
    80002c70:	85ca                	mv	a1,s2
    80002c72:	8526                	mv	a0,s1
    80002c74:	00001097          	auipc	ra,0x1
    80002c78:	e3a080e7          	jalr	-454(ra) # 80003aae <initsleeplock>
  for (i = 0; i < NINODE; i++) {
    80002c7c:	08848493          	addi	s1,s1,136
    80002c80:	ff3498e3          	bne	s1,s3,80002c70 <iinit+0x3e>
}
    80002c84:	70a2                	ld	ra,40(sp)
    80002c86:	7402                	ld	s0,32(sp)
    80002c88:	64e2                	ld	s1,24(sp)
    80002c8a:	6942                	ld	s2,16(sp)
    80002c8c:	69a2                	ld	s3,8(sp)
    80002c8e:	6145                	addi	sp,sp,48
    80002c90:	8082                	ret

0000000080002c92 <ialloc>:
struct inode *ialloc(uint dev, short type) {
    80002c92:	715d                	addi	sp,sp,-80
    80002c94:	e486                	sd	ra,72(sp)
    80002c96:	e0a2                	sd	s0,64(sp)
    80002c98:	fc26                	sd	s1,56(sp)
    80002c9a:	f84a                	sd	s2,48(sp)
    80002c9c:	f44e                	sd	s3,40(sp)
    80002c9e:	f052                	sd	s4,32(sp)
    80002ca0:	ec56                	sd	s5,24(sp)
    80002ca2:	e85a                	sd	s6,16(sp)
    80002ca4:	e45e                	sd	s7,8(sp)
    80002ca6:	0880                	addi	s0,sp,80
  for (inum = 1; inum < sb.ninodes; inum++) {
    80002ca8:	00034717          	auipc	a4,0x34
    80002cac:	10c72703          	lw	a4,268(a4) # 80036db4 <sb+0xc>
    80002cb0:	4785                	li	a5,1
    80002cb2:	04e7fa63          	bgeu	a5,a4,80002d06 <ialloc+0x74>
    80002cb6:	8aaa                	mv	s5,a0
    80002cb8:	8bae                	mv	s7,a1
    80002cba:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002cbc:	00034a17          	auipc	s4,0x34
    80002cc0:	0eca0a13          	addi	s4,s4,236 # 80036da8 <sb>
    80002cc4:	00048b1b          	sext.w	s6,s1
    80002cc8:	0044d793          	srli	a5,s1,0x4
    80002ccc:	018a2583          	lw	a1,24(s4)
    80002cd0:	9dbd                	addw	a1,a1,a5
    80002cd2:	8556                	mv	a0,s5
    80002cd4:	00000097          	auipc	ra,0x0
    80002cd8:	940080e7          	jalr	-1728(ra) # 80002614 <bread>
    80002cdc:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    80002cde:	05850993          	addi	s3,a0,88
    80002ce2:	00f4f793          	andi	a5,s1,15
    80002ce6:	079a                	slli	a5,a5,0x6
    80002ce8:	99be                	add	s3,s3,a5
    if (dip->type == 0) {  // a free inode
    80002cea:	00099783          	lh	a5,0(s3)
    80002cee:	c3a1                	beqz	a5,80002d2e <ialloc+0x9c>
    brelse(bp);
    80002cf0:	00000097          	auipc	ra,0x0
    80002cf4:	a54080e7          	jalr	-1452(ra) # 80002744 <brelse>
  for (inum = 1; inum < sb.ninodes; inum++) {
    80002cf8:	0485                	addi	s1,s1,1
    80002cfa:	00ca2703          	lw	a4,12(s4)
    80002cfe:	0004879b          	sext.w	a5,s1
    80002d02:	fce7e1e3          	bltu	a5,a4,80002cc4 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002d06:	00005517          	auipc	a0,0x5
    80002d0a:	7ea50513          	addi	a0,a0,2026 # 800084f0 <syscalls+0x168>
    80002d0e:	00003097          	auipc	ra,0x3
    80002d12:	22a080e7          	jalr	554(ra) # 80005f38 <printf>
  return 0;
    80002d16:	4501                	li	a0,0
}
    80002d18:	60a6                	ld	ra,72(sp)
    80002d1a:	6406                	ld	s0,64(sp)
    80002d1c:	74e2                	ld	s1,56(sp)
    80002d1e:	7942                	ld	s2,48(sp)
    80002d20:	79a2                	ld	s3,40(sp)
    80002d22:	7a02                	ld	s4,32(sp)
    80002d24:	6ae2                	ld	s5,24(sp)
    80002d26:	6b42                	ld	s6,16(sp)
    80002d28:	6ba2                	ld	s7,8(sp)
    80002d2a:	6161                	addi	sp,sp,80
    80002d2c:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002d2e:	04000613          	li	a2,64
    80002d32:	4581                	li	a1,0
    80002d34:	854e                	mv	a0,s3
    80002d36:	ffffd097          	auipc	ra,0xffffd
    80002d3a:	56c080e7          	jalr	1388(ra) # 800002a2 <memset>
      dip->type = type;
    80002d3e:	01799023          	sh	s7,0(s3)
      log_write(bp);  // mark it allocated on the disk
    80002d42:	854a                	mv	a0,s2
    80002d44:	00001097          	auipc	ra,0x1
    80002d48:	c84080e7          	jalr	-892(ra) # 800039c8 <log_write>
      brelse(bp);
    80002d4c:	854a                	mv	a0,s2
    80002d4e:	00000097          	auipc	ra,0x0
    80002d52:	9f6080e7          	jalr	-1546(ra) # 80002744 <brelse>
      return iget(dev, inum);
    80002d56:	85da                	mv	a1,s6
    80002d58:	8556                	mv	a0,s5
    80002d5a:	00000097          	auipc	ra,0x0
    80002d5e:	d9c080e7          	jalr	-612(ra) # 80002af6 <iget>
    80002d62:	bf5d                	j	80002d18 <ialloc+0x86>

0000000080002d64 <iupdate>:
void iupdate(struct inode *ip) {
    80002d64:	1101                	addi	sp,sp,-32
    80002d66:	ec06                	sd	ra,24(sp)
    80002d68:	e822                	sd	s0,16(sp)
    80002d6a:	e426                	sd	s1,8(sp)
    80002d6c:	e04a                	sd	s2,0(sp)
    80002d6e:	1000                	addi	s0,sp,32
    80002d70:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d72:	415c                	lw	a5,4(a0)
    80002d74:	0047d79b          	srliw	a5,a5,0x4
    80002d78:	00034597          	auipc	a1,0x34
    80002d7c:	0485a583          	lw	a1,72(a1) # 80036dc0 <sb+0x18>
    80002d80:	9dbd                	addw	a1,a1,a5
    80002d82:	4108                	lw	a0,0(a0)
    80002d84:	00000097          	auipc	ra,0x0
    80002d88:	890080e7          	jalr	-1904(ra) # 80002614 <bread>
    80002d8c:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002d8e:	05850793          	addi	a5,a0,88
    80002d92:	40c8                	lw	a0,4(s1)
    80002d94:	893d                	andi	a0,a0,15
    80002d96:	051a                	slli	a0,a0,0x6
    80002d98:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002d9a:	04449703          	lh	a4,68(s1)
    80002d9e:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002da2:	04649703          	lh	a4,70(s1)
    80002da6:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002daa:	04849703          	lh	a4,72(s1)
    80002dae:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002db2:	04a49703          	lh	a4,74(s1)
    80002db6:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002dba:	44f8                	lw	a4,76(s1)
    80002dbc:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002dbe:	03400613          	li	a2,52
    80002dc2:	05048593          	addi	a1,s1,80
    80002dc6:	0531                	addi	a0,a0,12
    80002dc8:	ffffd097          	auipc	ra,0xffffd
    80002dcc:	536080e7          	jalr	1334(ra) # 800002fe <memmove>
  log_write(bp);
    80002dd0:	854a                	mv	a0,s2
    80002dd2:	00001097          	auipc	ra,0x1
    80002dd6:	bf6080e7          	jalr	-1034(ra) # 800039c8 <log_write>
  brelse(bp);
    80002dda:	854a                	mv	a0,s2
    80002ddc:	00000097          	auipc	ra,0x0
    80002de0:	968080e7          	jalr	-1688(ra) # 80002744 <brelse>
}
    80002de4:	60e2                	ld	ra,24(sp)
    80002de6:	6442                	ld	s0,16(sp)
    80002de8:	64a2                	ld	s1,8(sp)
    80002dea:	6902                	ld	s2,0(sp)
    80002dec:	6105                	addi	sp,sp,32
    80002dee:	8082                	ret

0000000080002df0 <idup>:
struct inode *idup(struct inode *ip) {
    80002df0:	1101                	addi	sp,sp,-32
    80002df2:	ec06                	sd	ra,24(sp)
    80002df4:	e822                	sd	s0,16(sp)
    80002df6:	e426                	sd	s1,8(sp)
    80002df8:	1000                	addi	s0,sp,32
    80002dfa:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dfc:	00034517          	auipc	a0,0x34
    80002e00:	fcc50513          	addi	a0,a0,-52 # 80036dc8 <itable>
    80002e04:	00003097          	auipc	ra,0x3
    80002e08:	626080e7          	jalr	1574(ra) # 8000642a <acquire>
  ip->ref++;
    80002e0c:	449c                	lw	a5,8(s1)
    80002e0e:	2785                	addiw	a5,a5,1
    80002e10:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e12:	00034517          	auipc	a0,0x34
    80002e16:	fb650513          	addi	a0,a0,-74 # 80036dc8 <itable>
    80002e1a:	00003097          	auipc	ra,0x3
    80002e1e:	6c4080e7          	jalr	1732(ra) # 800064de <release>
}
    80002e22:	8526                	mv	a0,s1
    80002e24:	60e2                	ld	ra,24(sp)
    80002e26:	6442                	ld	s0,16(sp)
    80002e28:	64a2                	ld	s1,8(sp)
    80002e2a:	6105                	addi	sp,sp,32
    80002e2c:	8082                	ret

0000000080002e2e <ilock>:
void ilock(struct inode *ip) {
    80002e2e:	1101                	addi	sp,sp,-32
    80002e30:	ec06                	sd	ra,24(sp)
    80002e32:	e822                	sd	s0,16(sp)
    80002e34:	e426                	sd	s1,8(sp)
    80002e36:	e04a                	sd	s2,0(sp)
    80002e38:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1) panic("ilock");
    80002e3a:	c115                	beqz	a0,80002e5e <ilock+0x30>
    80002e3c:	84aa                	mv	s1,a0
    80002e3e:	451c                	lw	a5,8(a0)
    80002e40:	00f05f63          	blez	a5,80002e5e <ilock+0x30>
  acquiresleep(&ip->lock);
    80002e44:	0541                	addi	a0,a0,16
    80002e46:	00001097          	auipc	ra,0x1
    80002e4a:	ca2080e7          	jalr	-862(ra) # 80003ae8 <acquiresleep>
  if (ip->valid == 0) {
    80002e4e:	40bc                	lw	a5,64(s1)
    80002e50:	cf99                	beqz	a5,80002e6e <ilock+0x40>
}
    80002e52:	60e2                	ld	ra,24(sp)
    80002e54:	6442                	ld	s0,16(sp)
    80002e56:	64a2                	ld	s1,8(sp)
    80002e58:	6902                	ld	s2,0(sp)
    80002e5a:	6105                	addi	sp,sp,32
    80002e5c:	8082                	ret
  if (ip == 0 || ip->ref < 1) panic("ilock");
    80002e5e:	00005517          	auipc	a0,0x5
    80002e62:	6aa50513          	addi	a0,a0,1706 # 80008508 <syscalls+0x180>
    80002e66:	00003097          	auipc	ra,0x3
    80002e6a:	088080e7          	jalr	136(ra) # 80005eee <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002e6e:	40dc                	lw	a5,4(s1)
    80002e70:	0047d79b          	srliw	a5,a5,0x4
    80002e74:	00034597          	auipc	a1,0x34
    80002e78:	f4c5a583          	lw	a1,-180(a1) # 80036dc0 <sb+0x18>
    80002e7c:	9dbd                	addw	a1,a1,a5
    80002e7e:	4088                	lw	a0,0(s1)
    80002e80:	fffff097          	auipc	ra,0xfffff
    80002e84:	794080e7          	jalr	1940(ra) # 80002614 <bread>
    80002e88:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002e8a:	05850593          	addi	a1,a0,88
    80002e8e:	40dc                	lw	a5,4(s1)
    80002e90:	8bbd                	andi	a5,a5,15
    80002e92:	079a                	slli	a5,a5,0x6
    80002e94:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002e96:	00059783          	lh	a5,0(a1)
    80002e9a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002e9e:	00259783          	lh	a5,2(a1)
    80002ea2:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002ea6:	00459783          	lh	a5,4(a1)
    80002eaa:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002eae:	00659783          	lh	a5,6(a1)
    80002eb2:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002eb6:	459c                	lw	a5,8(a1)
    80002eb8:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002eba:	03400613          	li	a2,52
    80002ebe:	05b1                	addi	a1,a1,12
    80002ec0:	05048513          	addi	a0,s1,80
    80002ec4:	ffffd097          	auipc	ra,0xffffd
    80002ec8:	43a080e7          	jalr	1082(ra) # 800002fe <memmove>
    brelse(bp);
    80002ecc:	854a                	mv	a0,s2
    80002ece:	00000097          	auipc	ra,0x0
    80002ed2:	876080e7          	jalr	-1930(ra) # 80002744 <brelse>
    ip->valid = 1;
    80002ed6:	4785                	li	a5,1
    80002ed8:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0) panic("ilock: no type");
    80002eda:	04449783          	lh	a5,68(s1)
    80002ede:	fbb5                	bnez	a5,80002e52 <ilock+0x24>
    80002ee0:	00005517          	auipc	a0,0x5
    80002ee4:	63050513          	addi	a0,a0,1584 # 80008510 <syscalls+0x188>
    80002ee8:	00003097          	auipc	ra,0x3
    80002eec:	006080e7          	jalr	6(ra) # 80005eee <panic>

0000000080002ef0 <iunlock>:
void iunlock(struct inode *ip) {
    80002ef0:	1101                	addi	sp,sp,-32
    80002ef2:	ec06                	sd	ra,24(sp)
    80002ef4:	e822                	sd	s0,16(sp)
    80002ef6:	e426                	sd	s1,8(sp)
    80002ef8:	e04a                	sd	s2,0(sp)
    80002efa:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) panic("iunlock");
    80002efc:	c905                	beqz	a0,80002f2c <iunlock+0x3c>
    80002efe:	84aa                	mv	s1,a0
    80002f00:	01050913          	addi	s2,a0,16
    80002f04:	854a                	mv	a0,s2
    80002f06:	00001097          	auipc	ra,0x1
    80002f0a:	c7c080e7          	jalr	-900(ra) # 80003b82 <holdingsleep>
    80002f0e:	cd19                	beqz	a0,80002f2c <iunlock+0x3c>
    80002f10:	449c                	lw	a5,8(s1)
    80002f12:	00f05d63          	blez	a5,80002f2c <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002f16:	854a                	mv	a0,s2
    80002f18:	00001097          	auipc	ra,0x1
    80002f1c:	c26080e7          	jalr	-986(ra) # 80003b3e <releasesleep>
}
    80002f20:	60e2                	ld	ra,24(sp)
    80002f22:	6442                	ld	s0,16(sp)
    80002f24:	64a2                	ld	s1,8(sp)
    80002f26:	6902                	ld	s2,0(sp)
    80002f28:	6105                	addi	sp,sp,32
    80002f2a:	8082                	ret
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) panic("iunlock");
    80002f2c:	00005517          	auipc	a0,0x5
    80002f30:	5f450513          	addi	a0,a0,1524 # 80008520 <syscalls+0x198>
    80002f34:	00003097          	auipc	ra,0x3
    80002f38:	fba080e7          	jalr	-70(ra) # 80005eee <panic>

0000000080002f3c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void itrunc(struct inode *ip) {
    80002f3c:	7179                	addi	sp,sp,-48
    80002f3e:	f406                	sd	ra,40(sp)
    80002f40:	f022                	sd	s0,32(sp)
    80002f42:	ec26                	sd	s1,24(sp)
    80002f44:	e84a                	sd	s2,16(sp)
    80002f46:	e44e                	sd	s3,8(sp)
    80002f48:	e052                	sd	s4,0(sp)
    80002f4a:	1800                	addi	s0,sp,48
    80002f4c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++) {
    80002f4e:	05050493          	addi	s1,a0,80
    80002f52:	08050913          	addi	s2,a0,128
    80002f56:	a021                	j	80002f5e <itrunc+0x22>
    80002f58:	0491                	addi	s1,s1,4
    80002f5a:	01248d63          	beq	s1,s2,80002f74 <itrunc+0x38>
    if (ip->addrs[i]) {
    80002f5e:	408c                	lw	a1,0(s1)
    80002f60:	dde5                	beqz	a1,80002f58 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002f62:	0009a503          	lw	a0,0(s3)
    80002f66:	00000097          	auipc	ra,0x0
    80002f6a:	8f4080e7          	jalr	-1804(ra) # 8000285a <bfree>
      ip->addrs[i] = 0;
    80002f6e:	0004a023          	sw	zero,0(s1)
    80002f72:	b7dd                	j	80002f58 <itrunc+0x1c>
    }
  }

  if (ip->addrs[NDIRECT]) {
    80002f74:	0809a583          	lw	a1,128(s3)
    80002f78:	e185                	bnez	a1,80002f98 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002f7a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002f7e:	854e                	mv	a0,s3
    80002f80:	00000097          	auipc	ra,0x0
    80002f84:	de4080e7          	jalr	-540(ra) # 80002d64 <iupdate>
}
    80002f88:	70a2                	ld	ra,40(sp)
    80002f8a:	7402                	ld	s0,32(sp)
    80002f8c:	64e2                	ld	s1,24(sp)
    80002f8e:	6942                	ld	s2,16(sp)
    80002f90:	69a2                	ld	s3,8(sp)
    80002f92:	6a02                	ld	s4,0(sp)
    80002f94:	6145                	addi	sp,sp,48
    80002f96:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002f98:	0009a503          	lw	a0,0(s3)
    80002f9c:	fffff097          	auipc	ra,0xfffff
    80002fa0:	678080e7          	jalr	1656(ra) # 80002614 <bread>
    80002fa4:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++) {
    80002fa6:	05850493          	addi	s1,a0,88
    80002faa:	45850913          	addi	s2,a0,1112
    80002fae:	a021                	j	80002fb6 <itrunc+0x7a>
    80002fb0:	0491                	addi	s1,s1,4
    80002fb2:	01248b63          	beq	s1,s2,80002fc8 <itrunc+0x8c>
      if (a[j]) bfree(ip->dev, a[j]);
    80002fb6:	408c                	lw	a1,0(s1)
    80002fb8:	dde5                	beqz	a1,80002fb0 <itrunc+0x74>
    80002fba:	0009a503          	lw	a0,0(s3)
    80002fbe:	00000097          	auipc	ra,0x0
    80002fc2:	89c080e7          	jalr	-1892(ra) # 8000285a <bfree>
    80002fc6:	b7ed                	j	80002fb0 <itrunc+0x74>
    brelse(bp);
    80002fc8:	8552                	mv	a0,s4
    80002fca:	fffff097          	auipc	ra,0xfffff
    80002fce:	77a080e7          	jalr	1914(ra) # 80002744 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002fd2:	0809a583          	lw	a1,128(s3)
    80002fd6:	0009a503          	lw	a0,0(s3)
    80002fda:	00000097          	auipc	ra,0x0
    80002fde:	880080e7          	jalr	-1920(ra) # 8000285a <bfree>
    ip->addrs[NDIRECT] = 0;
    80002fe2:	0809a023          	sw	zero,128(s3)
    80002fe6:	bf51                	j	80002f7a <itrunc+0x3e>

0000000080002fe8 <iput>:
void iput(struct inode *ip) {
    80002fe8:	1101                	addi	sp,sp,-32
    80002fea:	ec06                	sd	ra,24(sp)
    80002fec:	e822                	sd	s0,16(sp)
    80002fee:	e426                	sd	s1,8(sp)
    80002ff0:	e04a                	sd	s2,0(sp)
    80002ff2:	1000                	addi	s0,sp,32
    80002ff4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ff6:	00034517          	auipc	a0,0x34
    80002ffa:	dd250513          	addi	a0,a0,-558 # 80036dc8 <itable>
    80002ffe:	00003097          	auipc	ra,0x3
    80003002:	42c080e7          	jalr	1068(ra) # 8000642a <acquire>
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80003006:	4498                	lw	a4,8(s1)
    80003008:	4785                	li	a5,1
    8000300a:	02f70363          	beq	a4,a5,80003030 <iput+0x48>
  ip->ref--;
    8000300e:	449c                	lw	a5,8(s1)
    80003010:	37fd                	addiw	a5,a5,-1
    80003012:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003014:	00034517          	auipc	a0,0x34
    80003018:	db450513          	addi	a0,a0,-588 # 80036dc8 <itable>
    8000301c:	00003097          	auipc	ra,0x3
    80003020:	4c2080e7          	jalr	1218(ra) # 800064de <release>
}
    80003024:	60e2                	ld	ra,24(sp)
    80003026:	6442                	ld	s0,16(sp)
    80003028:	64a2                	ld	s1,8(sp)
    8000302a:	6902                	ld	s2,0(sp)
    8000302c:	6105                	addi	sp,sp,32
    8000302e:	8082                	ret
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80003030:	40bc                	lw	a5,64(s1)
    80003032:	dff1                	beqz	a5,8000300e <iput+0x26>
    80003034:	04a49783          	lh	a5,74(s1)
    80003038:	fbf9                	bnez	a5,8000300e <iput+0x26>
    acquiresleep(&ip->lock);
    8000303a:	01048913          	addi	s2,s1,16
    8000303e:	854a                	mv	a0,s2
    80003040:	00001097          	auipc	ra,0x1
    80003044:	aa8080e7          	jalr	-1368(ra) # 80003ae8 <acquiresleep>
    release(&itable.lock);
    80003048:	00034517          	auipc	a0,0x34
    8000304c:	d8050513          	addi	a0,a0,-640 # 80036dc8 <itable>
    80003050:	00003097          	auipc	ra,0x3
    80003054:	48e080e7          	jalr	1166(ra) # 800064de <release>
    itrunc(ip);
    80003058:	8526                	mv	a0,s1
    8000305a:	00000097          	auipc	ra,0x0
    8000305e:	ee2080e7          	jalr	-286(ra) # 80002f3c <itrunc>
    ip->type = 0;
    80003062:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003066:	8526                	mv	a0,s1
    80003068:	00000097          	auipc	ra,0x0
    8000306c:	cfc080e7          	jalr	-772(ra) # 80002d64 <iupdate>
    ip->valid = 0;
    80003070:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003074:	854a                	mv	a0,s2
    80003076:	00001097          	auipc	ra,0x1
    8000307a:	ac8080e7          	jalr	-1336(ra) # 80003b3e <releasesleep>
    acquire(&itable.lock);
    8000307e:	00034517          	auipc	a0,0x34
    80003082:	d4a50513          	addi	a0,a0,-694 # 80036dc8 <itable>
    80003086:	00003097          	auipc	ra,0x3
    8000308a:	3a4080e7          	jalr	932(ra) # 8000642a <acquire>
    8000308e:	b741                	j	8000300e <iput+0x26>

0000000080003090 <iunlockput>:
void iunlockput(struct inode *ip) {
    80003090:	1101                	addi	sp,sp,-32
    80003092:	ec06                	sd	ra,24(sp)
    80003094:	e822                	sd	s0,16(sp)
    80003096:	e426                	sd	s1,8(sp)
    80003098:	1000                	addi	s0,sp,32
    8000309a:	84aa                	mv	s1,a0
  iunlock(ip);
    8000309c:	00000097          	auipc	ra,0x0
    800030a0:	e54080e7          	jalr	-428(ra) # 80002ef0 <iunlock>
  iput(ip);
    800030a4:	8526                	mv	a0,s1
    800030a6:	00000097          	auipc	ra,0x0
    800030aa:	f42080e7          	jalr	-190(ra) # 80002fe8 <iput>
}
    800030ae:	60e2                	ld	ra,24(sp)
    800030b0:	6442                	ld	s0,16(sp)
    800030b2:	64a2                	ld	s1,8(sp)
    800030b4:	6105                	addi	sp,sp,32
    800030b6:	8082                	ret

00000000800030b8 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st) {
    800030b8:	1141                	addi	sp,sp,-16
    800030ba:	e422                	sd	s0,8(sp)
    800030bc:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800030be:	411c                	lw	a5,0(a0)
    800030c0:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800030c2:	415c                	lw	a5,4(a0)
    800030c4:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800030c6:	04451783          	lh	a5,68(a0)
    800030ca:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800030ce:	04a51783          	lh	a5,74(a0)
    800030d2:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800030d6:	04c56783          	lwu	a5,76(a0)
    800030da:	e99c                	sd	a5,16(a1)
}
    800030dc:	6422                	ld	s0,8(sp)
    800030de:	0141                	addi	sp,sp,16
    800030e0:	8082                	ret

00000000800030e2 <readi>:
// otherwise, dst is a kernel address.
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n) {
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off) return 0;
    800030e2:	457c                	lw	a5,76(a0)
    800030e4:	0ed7e963          	bltu	a5,a3,800031d6 <readi+0xf4>
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n) {
    800030e8:	7159                	addi	sp,sp,-112
    800030ea:	f486                	sd	ra,104(sp)
    800030ec:	f0a2                	sd	s0,96(sp)
    800030ee:	eca6                	sd	s1,88(sp)
    800030f0:	e8ca                	sd	s2,80(sp)
    800030f2:	e4ce                	sd	s3,72(sp)
    800030f4:	e0d2                	sd	s4,64(sp)
    800030f6:	fc56                	sd	s5,56(sp)
    800030f8:	f85a                	sd	s6,48(sp)
    800030fa:	f45e                	sd	s7,40(sp)
    800030fc:	f062                	sd	s8,32(sp)
    800030fe:	ec66                	sd	s9,24(sp)
    80003100:	e86a                	sd	s10,16(sp)
    80003102:	e46e                	sd	s11,8(sp)
    80003104:	1880                	addi	s0,sp,112
    80003106:	8b2a                	mv	s6,a0
    80003108:	8bae                	mv	s7,a1
    8000310a:	8a32                	mv	s4,a2
    8000310c:	84b6                	mv	s1,a3
    8000310e:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off) return 0;
    80003110:	9f35                	addw	a4,a4,a3
    80003112:	4501                	li	a0,0
    80003114:	0ad76063          	bltu	a4,a3,800031b4 <readi+0xd2>
  if (off + n > ip->size) n = ip->size - off;
    80003118:	00e7f463          	bgeu	a5,a4,80003120 <readi+0x3e>
    8000311c:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80003120:	0a0a8963          	beqz	s5,800031d2 <readi+0xf0>
    80003124:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0) break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80003126:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000312a:	5c7d                	li	s8,-1
    8000312c:	a82d                	j	80003166 <readi+0x84>
    8000312e:	020d1d93          	slli	s11,s10,0x20
    80003132:	020ddd93          	srli	s11,s11,0x20
    80003136:	05890793          	addi	a5,s2,88
    8000313a:	86ee                	mv	a3,s11
    8000313c:	963e                	add	a2,a2,a5
    8000313e:	85d2                	mv	a1,s4
    80003140:	855e                	mv	a0,s7
    80003142:	fffff097          	auipc	ra,0xfffff
    80003146:	ad6080e7          	jalr	-1322(ra) # 80001c18 <either_copyout>
    8000314a:	05850d63          	beq	a0,s8,800031a4 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000314e:	854a                	mv	a0,s2
    80003150:	fffff097          	auipc	ra,0xfffff
    80003154:	5f4080e7          	jalr	1524(ra) # 80002744 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80003158:	013d09bb          	addw	s3,s10,s3
    8000315c:	009d04bb          	addw	s1,s10,s1
    80003160:	9a6e                	add	s4,s4,s11
    80003162:	0559f763          	bgeu	s3,s5,800031b0 <readi+0xce>
    uint addr = bmap(ip, off / BSIZE);
    80003166:	00a4d59b          	srliw	a1,s1,0xa
    8000316a:	855a                	mv	a0,s6
    8000316c:	00000097          	auipc	ra,0x0
    80003170:	8a2080e7          	jalr	-1886(ra) # 80002a0e <bmap>
    80003174:	0005059b          	sext.w	a1,a0
    if (addr == 0) break;
    80003178:	cd85                	beqz	a1,800031b0 <readi+0xce>
    bp = bread(ip->dev, addr);
    8000317a:	000b2503          	lw	a0,0(s6)
    8000317e:	fffff097          	auipc	ra,0xfffff
    80003182:	496080e7          	jalr	1174(ra) # 80002614 <bread>
    80003186:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80003188:	3ff4f613          	andi	a2,s1,1023
    8000318c:	40cc87bb          	subw	a5,s9,a2
    80003190:	413a873b          	subw	a4,s5,s3
    80003194:	8d3e                	mv	s10,a5
    80003196:	2781                	sext.w	a5,a5
    80003198:	0007069b          	sext.w	a3,a4
    8000319c:	f8f6f9e3          	bgeu	a3,a5,8000312e <readi+0x4c>
    800031a0:	8d3a                	mv	s10,a4
    800031a2:	b771                	j	8000312e <readi+0x4c>
      brelse(bp);
    800031a4:	854a                	mv	a0,s2
    800031a6:	fffff097          	auipc	ra,0xfffff
    800031aa:	59e080e7          	jalr	1438(ra) # 80002744 <brelse>
      tot = -1;
    800031ae:	59fd                	li	s3,-1
  }
  return tot;
    800031b0:	0009851b          	sext.w	a0,s3
}
    800031b4:	70a6                	ld	ra,104(sp)
    800031b6:	7406                	ld	s0,96(sp)
    800031b8:	64e6                	ld	s1,88(sp)
    800031ba:	6946                	ld	s2,80(sp)
    800031bc:	69a6                	ld	s3,72(sp)
    800031be:	6a06                	ld	s4,64(sp)
    800031c0:	7ae2                	ld	s5,56(sp)
    800031c2:	7b42                	ld	s6,48(sp)
    800031c4:	7ba2                	ld	s7,40(sp)
    800031c6:	7c02                	ld	s8,32(sp)
    800031c8:	6ce2                	ld	s9,24(sp)
    800031ca:	6d42                	ld	s10,16(sp)
    800031cc:	6da2                	ld	s11,8(sp)
    800031ce:	6165                	addi	sp,sp,112
    800031d0:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    800031d2:	89d6                	mv	s3,s5
    800031d4:	bff1                	j	800031b0 <readi+0xce>
  if (off > ip->size || off + n < off) return 0;
    800031d6:	4501                	li	a0,0
}
    800031d8:	8082                	ret

00000000800031da <writei>:
// there was an error of some kind.
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n) {
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off) return -1;
    800031da:	457c                	lw	a5,76(a0)
    800031dc:	10d7e863          	bltu	a5,a3,800032ec <writei+0x112>
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n) {
    800031e0:	7159                	addi	sp,sp,-112
    800031e2:	f486                	sd	ra,104(sp)
    800031e4:	f0a2                	sd	s0,96(sp)
    800031e6:	eca6                	sd	s1,88(sp)
    800031e8:	e8ca                	sd	s2,80(sp)
    800031ea:	e4ce                	sd	s3,72(sp)
    800031ec:	e0d2                	sd	s4,64(sp)
    800031ee:	fc56                	sd	s5,56(sp)
    800031f0:	f85a                	sd	s6,48(sp)
    800031f2:	f45e                	sd	s7,40(sp)
    800031f4:	f062                	sd	s8,32(sp)
    800031f6:	ec66                	sd	s9,24(sp)
    800031f8:	e86a                	sd	s10,16(sp)
    800031fa:	e46e                	sd	s11,8(sp)
    800031fc:	1880                	addi	s0,sp,112
    800031fe:	8aaa                	mv	s5,a0
    80003200:	8bae                	mv	s7,a1
    80003202:	8a32                	mv	s4,a2
    80003204:	8936                	mv	s2,a3
    80003206:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off) return -1;
    80003208:	00e687bb          	addw	a5,a3,a4
    8000320c:	0ed7e263          	bltu	a5,a3,800032f0 <writei+0x116>
  if (off + n > MAXFILE * BSIZE) return -1;
    80003210:	00043737          	lui	a4,0x43
    80003214:	0ef76063          	bltu	a4,a5,800032f4 <writei+0x11a>

  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003218:	0c0b0863          	beqz	s6,800032e8 <writei+0x10e>
    8000321c:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0) break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    8000321e:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003222:	5c7d                	li	s8,-1
    80003224:	a091                	j	80003268 <writei+0x8e>
    80003226:	020d1d93          	slli	s11,s10,0x20
    8000322a:	020ddd93          	srli	s11,s11,0x20
    8000322e:	05848793          	addi	a5,s1,88
    80003232:	86ee                	mv	a3,s11
    80003234:	8652                	mv	a2,s4
    80003236:	85de                	mv	a1,s7
    80003238:	953e                	add	a0,a0,a5
    8000323a:	fffff097          	auipc	ra,0xfffff
    8000323e:	a34080e7          	jalr	-1484(ra) # 80001c6e <either_copyin>
    80003242:	07850263          	beq	a0,s8,800032a6 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003246:	8526                	mv	a0,s1
    80003248:	00000097          	auipc	ra,0x0
    8000324c:	780080e7          	jalr	1920(ra) # 800039c8 <log_write>
    brelse(bp);
    80003250:	8526                	mv	a0,s1
    80003252:	fffff097          	auipc	ra,0xfffff
    80003256:	4f2080e7          	jalr	1266(ra) # 80002744 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    8000325a:	013d09bb          	addw	s3,s10,s3
    8000325e:	012d093b          	addw	s2,s10,s2
    80003262:	9a6e                	add	s4,s4,s11
    80003264:	0569f663          	bgeu	s3,s6,800032b0 <writei+0xd6>
    uint addr = bmap(ip, off / BSIZE);
    80003268:	00a9559b          	srliw	a1,s2,0xa
    8000326c:	8556                	mv	a0,s5
    8000326e:	fffff097          	auipc	ra,0xfffff
    80003272:	7a0080e7          	jalr	1952(ra) # 80002a0e <bmap>
    80003276:	0005059b          	sext.w	a1,a0
    if (addr == 0) break;
    8000327a:	c99d                	beqz	a1,800032b0 <writei+0xd6>
    bp = bread(ip->dev, addr);
    8000327c:	000aa503          	lw	a0,0(s5)
    80003280:	fffff097          	auipc	ra,0xfffff
    80003284:	394080e7          	jalr	916(ra) # 80002614 <bread>
    80003288:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    8000328a:	3ff97513          	andi	a0,s2,1023
    8000328e:	40ac87bb          	subw	a5,s9,a0
    80003292:	413b073b          	subw	a4,s6,s3
    80003296:	8d3e                	mv	s10,a5
    80003298:	2781                	sext.w	a5,a5
    8000329a:	0007069b          	sext.w	a3,a4
    8000329e:	f8f6f4e3          	bgeu	a3,a5,80003226 <writei+0x4c>
    800032a2:	8d3a                	mv	s10,a4
    800032a4:	b749                	j	80003226 <writei+0x4c>
      brelse(bp);
    800032a6:	8526                	mv	a0,s1
    800032a8:	fffff097          	auipc	ra,0xfffff
    800032ac:	49c080e7          	jalr	1180(ra) # 80002744 <brelse>
  }

  if (off > ip->size) ip->size = off;
    800032b0:	04caa783          	lw	a5,76(s5)
    800032b4:	0127f463          	bgeu	a5,s2,800032bc <writei+0xe2>
    800032b8:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800032bc:	8556                	mv	a0,s5
    800032be:	00000097          	auipc	ra,0x0
    800032c2:	aa6080e7          	jalr	-1370(ra) # 80002d64 <iupdate>

  return tot;
    800032c6:	0009851b          	sext.w	a0,s3
}
    800032ca:	70a6                	ld	ra,104(sp)
    800032cc:	7406                	ld	s0,96(sp)
    800032ce:	64e6                	ld	s1,88(sp)
    800032d0:	6946                	ld	s2,80(sp)
    800032d2:	69a6                	ld	s3,72(sp)
    800032d4:	6a06                	ld	s4,64(sp)
    800032d6:	7ae2                	ld	s5,56(sp)
    800032d8:	7b42                	ld	s6,48(sp)
    800032da:	7ba2                	ld	s7,40(sp)
    800032dc:	7c02                	ld	s8,32(sp)
    800032de:	6ce2                	ld	s9,24(sp)
    800032e0:	6d42                	ld	s10,16(sp)
    800032e2:	6da2                	ld	s11,8(sp)
    800032e4:	6165                	addi	sp,sp,112
    800032e6:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    800032e8:	89da                	mv	s3,s6
    800032ea:	bfc9                	j	800032bc <writei+0xe2>
  if (off > ip->size || off + n < off) return -1;
    800032ec:	557d                	li	a0,-1
}
    800032ee:	8082                	ret
  if (off > ip->size || off + n < off) return -1;
    800032f0:	557d                	li	a0,-1
    800032f2:	bfe1                	j	800032ca <writei+0xf0>
  if (off + n > MAXFILE * BSIZE) return -1;
    800032f4:	557d                	li	a0,-1
    800032f6:	bfd1                	j	800032ca <writei+0xf0>

00000000800032f8 <namecmp>:

// Directories

int namecmp(const char *s, const char *t) { return strncmp(s, t, DIRSIZ); }
    800032f8:	1141                	addi	sp,sp,-16
    800032fa:	e406                	sd	ra,8(sp)
    800032fc:	e022                	sd	s0,0(sp)
    800032fe:	0800                	addi	s0,sp,16
    80003300:	4639                	li	a2,14
    80003302:	ffffd097          	auipc	ra,0xffffd
    80003306:	070080e7          	jalr	112(ra) # 80000372 <strncmp>
    8000330a:	60a2                	ld	ra,8(sp)
    8000330c:	6402                	ld	s0,0(sp)
    8000330e:	0141                	addi	sp,sp,16
    80003310:	8082                	ret

0000000080003312 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *dirlookup(struct inode *dp, char *name, uint *poff) {
    80003312:	7139                	addi	sp,sp,-64
    80003314:	fc06                	sd	ra,56(sp)
    80003316:	f822                	sd	s0,48(sp)
    80003318:	f426                	sd	s1,40(sp)
    8000331a:	f04a                	sd	s2,32(sp)
    8000331c:	ec4e                	sd	s3,24(sp)
    8000331e:	e852                	sd	s4,16(sp)
    80003320:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR) panic("dirlookup not DIR");
    80003322:	04451703          	lh	a4,68(a0)
    80003326:	4785                	li	a5,1
    80003328:	00f71a63          	bne	a4,a5,8000333c <dirlookup+0x2a>
    8000332c:	892a                	mv	s2,a0
    8000332e:	89ae                	mv	s3,a1
    80003330:	8a32                	mv	s4,a2

  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003332:	457c                	lw	a5,76(a0)
    80003334:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003336:	4501                	li	a0,0
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003338:	e79d                	bnez	a5,80003366 <dirlookup+0x54>
    8000333a:	a8a5                	j	800033b2 <dirlookup+0xa0>
  if (dp->type != T_DIR) panic("dirlookup not DIR");
    8000333c:	00005517          	auipc	a0,0x5
    80003340:	1ec50513          	addi	a0,a0,492 # 80008528 <syscalls+0x1a0>
    80003344:	00003097          	auipc	ra,0x3
    80003348:	baa080e7          	jalr	-1110(ra) # 80005eee <panic>
      panic("dirlookup read");
    8000334c:	00005517          	auipc	a0,0x5
    80003350:	1f450513          	addi	a0,a0,500 # 80008540 <syscalls+0x1b8>
    80003354:	00003097          	auipc	ra,0x3
    80003358:	b9a080e7          	jalr	-1126(ra) # 80005eee <panic>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    8000335c:	24c1                	addiw	s1,s1,16
    8000335e:	04c92783          	lw	a5,76(s2)
    80003362:	04f4f763          	bgeu	s1,a5,800033b0 <dirlookup+0x9e>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003366:	4741                	li	a4,16
    80003368:	86a6                	mv	a3,s1
    8000336a:	fc040613          	addi	a2,s0,-64
    8000336e:	4581                	li	a1,0
    80003370:	854a                	mv	a0,s2
    80003372:	00000097          	auipc	ra,0x0
    80003376:	d70080e7          	jalr	-656(ra) # 800030e2 <readi>
    8000337a:	47c1                	li	a5,16
    8000337c:	fcf518e3          	bne	a0,a5,8000334c <dirlookup+0x3a>
    if (de.inum == 0) continue;
    80003380:	fc045783          	lhu	a5,-64(s0)
    80003384:	dfe1                	beqz	a5,8000335c <dirlookup+0x4a>
    if (namecmp(name, de.name) == 0) {
    80003386:	fc240593          	addi	a1,s0,-62
    8000338a:	854e                	mv	a0,s3
    8000338c:	00000097          	auipc	ra,0x0
    80003390:	f6c080e7          	jalr	-148(ra) # 800032f8 <namecmp>
    80003394:	f561                	bnez	a0,8000335c <dirlookup+0x4a>
      if (poff) *poff = off;
    80003396:	000a0463          	beqz	s4,8000339e <dirlookup+0x8c>
    8000339a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000339e:	fc045583          	lhu	a1,-64(s0)
    800033a2:	00092503          	lw	a0,0(s2)
    800033a6:	fffff097          	auipc	ra,0xfffff
    800033aa:	750080e7          	jalr	1872(ra) # 80002af6 <iget>
    800033ae:	a011                	j	800033b2 <dirlookup+0xa0>
  return 0;
    800033b0:	4501                	li	a0,0
}
    800033b2:	70e2                	ld	ra,56(sp)
    800033b4:	7442                	ld	s0,48(sp)
    800033b6:	74a2                	ld	s1,40(sp)
    800033b8:	7902                	ld	s2,32(sp)
    800033ba:	69e2                	ld	s3,24(sp)
    800033bc:	6a42                	ld	s4,16(sp)
    800033be:	6121                	addi	sp,sp,64
    800033c0:	8082                	ret

00000000800033c2 <namex>:

// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *namex(char *path, int nameiparent, char *name) {
    800033c2:	711d                	addi	sp,sp,-96
    800033c4:	ec86                	sd	ra,88(sp)
    800033c6:	e8a2                	sd	s0,80(sp)
    800033c8:	e4a6                	sd	s1,72(sp)
    800033ca:	e0ca                	sd	s2,64(sp)
    800033cc:	fc4e                	sd	s3,56(sp)
    800033ce:	f852                	sd	s4,48(sp)
    800033d0:	f456                	sd	s5,40(sp)
    800033d2:	f05a                	sd	s6,32(sp)
    800033d4:	ec5e                	sd	s7,24(sp)
    800033d6:	e862                	sd	s8,16(sp)
    800033d8:	e466                	sd	s9,8(sp)
    800033da:	1080                	addi	s0,sp,96
    800033dc:	84aa                	mv	s1,a0
    800033de:	8aae                	mv	s5,a1
    800033e0:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if (*path == '/')
    800033e2:	00054703          	lbu	a4,0(a0)
    800033e6:	02f00793          	li	a5,47
    800033ea:	02f70363          	beq	a4,a5,80003410 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800033ee:	ffffe097          	auipc	ra,0xffffe
    800033f2:	d76080e7          	jalr	-650(ra) # 80001164 <myproc>
    800033f6:	15053503          	ld	a0,336(a0)
    800033fa:	00000097          	auipc	ra,0x0
    800033fe:	9f6080e7          	jalr	-1546(ra) # 80002df0 <idup>
    80003402:	89aa                	mv	s3,a0
  while (*path == '/') path++;
    80003404:	02f00913          	li	s2,47
  len = path - s;
    80003408:	4b01                	li	s6,0
  if (len >= DIRSIZ)
    8000340a:	4c35                	li	s8,13

  while ((path = skipelem(path, name)) != 0) {
    ilock(ip);
    if (ip->type != T_DIR) {
    8000340c:	4b85                	li	s7,1
    8000340e:	a865                	j	800034c6 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003410:	4585                	li	a1,1
    80003412:	4505                	li	a0,1
    80003414:	fffff097          	auipc	ra,0xfffff
    80003418:	6e2080e7          	jalr	1762(ra) # 80002af6 <iget>
    8000341c:	89aa                	mv	s3,a0
    8000341e:	b7dd                	j	80003404 <namex+0x42>
      iunlockput(ip);
    80003420:	854e                	mv	a0,s3
    80003422:	00000097          	auipc	ra,0x0
    80003426:	c6e080e7          	jalr	-914(ra) # 80003090 <iunlockput>
      return 0;
    8000342a:	4981                	li	s3,0
  if (nameiparent) {
    iput(ip);
    return 0;
  }
  return ip;
}
    8000342c:	854e                	mv	a0,s3
    8000342e:	60e6                	ld	ra,88(sp)
    80003430:	6446                	ld	s0,80(sp)
    80003432:	64a6                	ld	s1,72(sp)
    80003434:	6906                	ld	s2,64(sp)
    80003436:	79e2                	ld	s3,56(sp)
    80003438:	7a42                	ld	s4,48(sp)
    8000343a:	7aa2                	ld	s5,40(sp)
    8000343c:	7b02                	ld	s6,32(sp)
    8000343e:	6be2                	ld	s7,24(sp)
    80003440:	6c42                	ld	s8,16(sp)
    80003442:	6ca2                	ld	s9,8(sp)
    80003444:	6125                	addi	sp,sp,96
    80003446:	8082                	ret
      iunlock(ip);
    80003448:	854e                	mv	a0,s3
    8000344a:	00000097          	auipc	ra,0x0
    8000344e:	aa6080e7          	jalr	-1370(ra) # 80002ef0 <iunlock>
      return ip;
    80003452:	bfe9                	j	8000342c <namex+0x6a>
      iunlockput(ip);
    80003454:	854e                	mv	a0,s3
    80003456:	00000097          	auipc	ra,0x0
    8000345a:	c3a080e7          	jalr	-966(ra) # 80003090 <iunlockput>
      return 0;
    8000345e:	89e6                	mv	s3,s9
    80003460:	b7f1                	j	8000342c <namex+0x6a>
  len = path - s;
    80003462:	40b48633          	sub	a2,s1,a1
    80003466:	00060c9b          	sext.w	s9,a2
  if (len >= DIRSIZ)
    8000346a:	099c5463          	bge	s8,s9,800034f2 <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000346e:	4639                	li	a2,14
    80003470:	8552                	mv	a0,s4
    80003472:	ffffd097          	auipc	ra,0xffffd
    80003476:	e8c080e7          	jalr	-372(ra) # 800002fe <memmove>
  while (*path == '/') path++;
    8000347a:	0004c783          	lbu	a5,0(s1)
    8000347e:	01279763          	bne	a5,s2,8000348c <namex+0xca>
    80003482:	0485                	addi	s1,s1,1
    80003484:	0004c783          	lbu	a5,0(s1)
    80003488:	ff278de3          	beq	a5,s2,80003482 <namex+0xc0>
    ilock(ip);
    8000348c:	854e                	mv	a0,s3
    8000348e:	00000097          	auipc	ra,0x0
    80003492:	9a0080e7          	jalr	-1632(ra) # 80002e2e <ilock>
    if (ip->type != T_DIR) {
    80003496:	04499783          	lh	a5,68(s3)
    8000349a:	f97793e3          	bne	a5,s7,80003420 <namex+0x5e>
    if (nameiparent && *path == '\0') {
    8000349e:	000a8563          	beqz	s5,800034a8 <namex+0xe6>
    800034a2:	0004c783          	lbu	a5,0(s1)
    800034a6:	d3cd                	beqz	a5,80003448 <namex+0x86>
    if ((next = dirlookup(ip, name, 0)) == 0) {
    800034a8:	865a                	mv	a2,s6
    800034aa:	85d2                	mv	a1,s4
    800034ac:	854e                	mv	a0,s3
    800034ae:	00000097          	auipc	ra,0x0
    800034b2:	e64080e7          	jalr	-412(ra) # 80003312 <dirlookup>
    800034b6:	8caa                	mv	s9,a0
    800034b8:	dd51                	beqz	a0,80003454 <namex+0x92>
    iunlockput(ip);
    800034ba:	854e                	mv	a0,s3
    800034bc:	00000097          	auipc	ra,0x0
    800034c0:	bd4080e7          	jalr	-1068(ra) # 80003090 <iunlockput>
    ip = next;
    800034c4:	89e6                	mv	s3,s9
  while (*path == '/') path++;
    800034c6:	0004c783          	lbu	a5,0(s1)
    800034ca:	05279763          	bne	a5,s2,80003518 <namex+0x156>
    800034ce:	0485                	addi	s1,s1,1
    800034d0:	0004c783          	lbu	a5,0(s1)
    800034d4:	ff278de3          	beq	a5,s2,800034ce <namex+0x10c>
  if (*path == 0) return 0;
    800034d8:	c79d                	beqz	a5,80003506 <namex+0x144>
  while (*path == '/') path++;
    800034da:	85a6                	mv	a1,s1
  len = path - s;
    800034dc:	8cda                	mv	s9,s6
    800034de:	865a                	mv	a2,s6
  while (*path != '/' && *path != 0) path++;
    800034e0:	01278963          	beq	a5,s2,800034f2 <namex+0x130>
    800034e4:	dfbd                	beqz	a5,80003462 <namex+0xa0>
    800034e6:	0485                	addi	s1,s1,1
    800034e8:	0004c783          	lbu	a5,0(s1)
    800034ec:	ff279ce3          	bne	a5,s2,800034e4 <namex+0x122>
    800034f0:	bf8d                	j	80003462 <namex+0xa0>
    memmove(name, s, len);
    800034f2:	2601                	sext.w	a2,a2
    800034f4:	8552                	mv	a0,s4
    800034f6:	ffffd097          	auipc	ra,0xffffd
    800034fa:	e08080e7          	jalr	-504(ra) # 800002fe <memmove>
    name[len] = 0;
    800034fe:	9cd2                	add	s9,s9,s4
    80003500:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003504:	bf9d                	j	8000347a <namex+0xb8>
  if (nameiparent) {
    80003506:	f20a83e3          	beqz	s5,8000342c <namex+0x6a>
    iput(ip);
    8000350a:	854e                	mv	a0,s3
    8000350c:	00000097          	auipc	ra,0x0
    80003510:	adc080e7          	jalr	-1316(ra) # 80002fe8 <iput>
    return 0;
    80003514:	4981                	li	s3,0
    80003516:	bf19                	j	8000342c <namex+0x6a>
  if (*path == 0) return 0;
    80003518:	d7fd                	beqz	a5,80003506 <namex+0x144>
  while (*path != '/' && *path != 0) path++;
    8000351a:	0004c783          	lbu	a5,0(s1)
    8000351e:	85a6                	mv	a1,s1
    80003520:	b7d1                	j	800034e4 <namex+0x122>

0000000080003522 <dirlink>:
int dirlink(struct inode *dp, char *name, uint inum) {
    80003522:	7139                	addi	sp,sp,-64
    80003524:	fc06                	sd	ra,56(sp)
    80003526:	f822                	sd	s0,48(sp)
    80003528:	f426                	sd	s1,40(sp)
    8000352a:	f04a                	sd	s2,32(sp)
    8000352c:	ec4e                	sd	s3,24(sp)
    8000352e:	e852                	sd	s4,16(sp)
    80003530:	0080                	addi	s0,sp,64
    80003532:	892a                	mv	s2,a0
    80003534:	8a2e                	mv	s4,a1
    80003536:	89b2                	mv	s3,a2
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80003538:	4601                	li	a2,0
    8000353a:	00000097          	auipc	ra,0x0
    8000353e:	dd8080e7          	jalr	-552(ra) # 80003312 <dirlookup>
    80003542:	e93d                	bnez	a0,800035b8 <dirlink+0x96>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003544:	04c92483          	lw	s1,76(s2)
    80003548:	c49d                	beqz	s1,80003576 <dirlink+0x54>
    8000354a:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000354c:	4741                	li	a4,16
    8000354e:	86a6                	mv	a3,s1
    80003550:	fc040613          	addi	a2,s0,-64
    80003554:	4581                	li	a1,0
    80003556:	854a                	mv	a0,s2
    80003558:	00000097          	auipc	ra,0x0
    8000355c:	b8a080e7          	jalr	-1142(ra) # 800030e2 <readi>
    80003560:	47c1                	li	a5,16
    80003562:	06f51163          	bne	a0,a5,800035c4 <dirlink+0xa2>
    if (de.inum == 0) break;
    80003566:	fc045783          	lhu	a5,-64(s0)
    8000356a:	c791                	beqz	a5,80003576 <dirlink+0x54>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    8000356c:	24c1                	addiw	s1,s1,16
    8000356e:	04c92783          	lw	a5,76(s2)
    80003572:	fcf4ede3          	bltu	s1,a5,8000354c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003576:	4639                	li	a2,14
    80003578:	85d2                	mv	a1,s4
    8000357a:	fc240513          	addi	a0,s0,-62
    8000357e:	ffffd097          	auipc	ra,0xffffd
    80003582:	e30080e7          	jalr	-464(ra) # 800003ae <strncpy>
  de.inum = inum;
    80003586:	fd341023          	sh	s3,-64(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de)) return -1;
    8000358a:	4741                	li	a4,16
    8000358c:	86a6                	mv	a3,s1
    8000358e:	fc040613          	addi	a2,s0,-64
    80003592:	4581                	li	a1,0
    80003594:	854a                	mv	a0,s2
    80003596:	00000097          	auipc	ra,0x0
    8000359a:	c44080e7          	jalr	-956(ra) # 800031da <writei>
    8000359e:	1541                	addi	a0,a0,-16
    800035a0:	00a03533          	snez	a0,a0
    800035a4:	40a00533          	neg	a0,a0
}
    800035a8:	70e2                	ld	ra,56(sp)
    800035aa:	7442                	ld	s0,48(sp)
    800035ac:	74a2                	ld	s1,40(sp)
    800035ae:	7902                	ld	s2,32(sp)
    800035b0:	69e2                	ld	s3,24(sp)
    800035b2:	6a42                	ld	s4,16(sp)
    800035b4:	6121                	addi	sp,sp,64
    800035b6:	8082                	ret
    iput(ip);
    800035b8:	00000097          	auipc	ra,0x0
    800035bc:	a30080e7          	jalr	-1488(ra) # 80002fe8 <iput>
    return -1;
    800035c0:	557d                	li	a0,-1
    800035c2:	b7dd                	j	800035a8 <dirlink+0x86>
      panic("dirlink read");
    800035c4:	00005517          	auipc	a0,0x5
    800035c8:	f8c50513          	addi	a0,a0,-116 # 80008550 <syscalls+0x1c8>
    800035cc:	00003097          	auipc	ra,0x3
    800035d0:	922080e7          	jalr	-1758(ra) # 80005eee <panic>

00000000800035d4 <namei>:

struct inode *namei(char *path) {
    800035d4:	1101                	addi	sp,sp,-32
    800035d6:	ec06                	sd	ra,24(sp)
    800035d8:	e822                	sd	s0,16(sp)
    800035da:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800035dc:	fe040613          	addi	a2,s0,-32
    800035e0:	4581                	li	a1,0
    800035e2:	00000097          	auipc	ra,0x0
    800035e6:	de0080e7          	jalr	-544(ra) # 800033c2 <namex>
}
    800035ea:	60e2                	ld	ra,24(sp)
    800035ec:	6442                	ld	s0,16(sp)
    800035ee:	6105                	addi	sp,sp,32
    800035f0:	8082                	ret

00000000800035f2 <nameiparent>:

struct inode *nameiparent(char *path, char *name) {
    800035f2:	1141                	addi	sp,sp,-16
    800035f4:	e406                	sd	ra,8(sp)
    800035f6:	e022                	sd	s0,0(sp)
    800035f8:	0800                	addi	s0,sp,16
    800035fa:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800035fc:	4585                	li	a1,1
    800035fe:	00000097          	auipc	ra,0x0
    80003602:	dc4080e7          	jalr	-572(ra) # 800033c2 <namex>
}
    80003606:	60a2                	ld	ra,8(sp)
    80003608:	6402                	ld	s0,0(sp)
    8000360a:	0141                	addi	sp,sp,16
    8000360c:	8082                	ret

000000008000360e <write_head>:
}

// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void write_head(void) {
    8000360e:	1101                	addi	sp,sp,-32
    80003610:	ec06                	sd	ra,24(sp)
    80003612:	e822                	sd	s0,16(sp)
    80003614:	e426                	sd	s1,8(sp)
    80003616:	e04a                	sd	s2,0(sp)
    80003618:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000361a:	00035917          	auipc	s2,0x35
    8000361e:	25690913          	addi	s2,s2,598 # 80038870 <log>
    80003622:	01892583          	lw	a1,24(s2)
    80003626:	02892503          	lw	a0,40(s2)
    8000362a:	fffff097          	auipc	ra,0xfffff
    8000362e:	fea080e7          	jalr	-22(ra) # 80002614 <bread>
    80003632:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *)(buf->data);
  int i;
  hb->n = log.lh.n;
    80003634:	02c92683          	lw	a3,44(s2)
    80003638:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000363a:	02d05763          	blez	a3,80003668 <write_head+0x5a>
    8000363e:	00035797          	auipc	a5,0x35
    80003642:	26278793          	addi	a5,a5,610 # 800388a0 <log+0x30>
    80003646:	05c50713          	addi	a4,a0,92
    8000364a:	36fd                	addiw	a3,a3,-1
    8000364c:	1682                	slli	a3,a3,0x20
    8000364e:	9281                	srli	a3,a3,0x20
    80003650:	068a                	slli	a3,a3,0x2
    80003652:	00035617          	auipc	a2,0x35
    80003656:	25260613          	addi	a2,a2,594 # 800388a4 <log+0x34>
    8000365a:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000365c:	4390                	lw	a2,0(a5)
    8000365e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003660:	0791                	addi	a5,a5,4
    80003662:	0711                	addi	a4,a4,4
    80003664:	fed79ce3          	bne	a5,a3,8000365c <write_head+0x4e>
  }
  bwrite(buf);
    80003668:	8526                	mv	a0,s1
    8000366a:	fffff097          	auipc	ra,0xfffff
    8000366e:	09c080e7          	jalr	156(ra) # 80002706 <bwrite>
  brelse(buf);
    80003672:	8526                	mv	a0,s1
    80003674:	fffff097          	auipc	ra,0xfffff
    80003678:	0d0080e7          	jalr	208(ra) # 80002744 <brelse>
}
    8000367c:	60e2                	ld	ra,24(sp)
    8000367e:	6442                	ld	s0,16(sp)
    80003680:	64a2                	ld	s1,8(sp)
    80003682:	6902                	ld	s2,0(sp)
    80003684:	6105                	addi	sp,sp,32
    80003686:	8082                	ret

0000000080003688 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003688:	00035797          	auipc	a5,0x35
    8000368c:	2147a783          	lw	a5,532(a5) # 8003889c <log+0x2c>
    80003690:	0af05d63          	blez	a5,8000374a <install_trans+0xc2>
static void install_trans(int recovering) {
    80003694:	7139                	addi	sp,sp,-64
    80003696:	fc06                	sd	ra,56(sp)
    80003698:	f822                	sd	s0,48(sp)
    8000369a:	f426                	sd	s1,40(sp)
    8000369c:	f04a                	sd	s2,32(sp)
    8000369e:	ec4e                	sd	s3,24(sp)
    800036a0:	e852                	sd	s4,16(sp)
    800036a2:	e456                	sd	s5,8(sp)
    800036a4:	e05a                	sd	s6,0(sp)
    800036a6:	0080                	addi	s0,sp,64
    800036a8:	8b2a                	mv	s6,a0
    800036aa:	00035a97          	auipc	s5,0x35
    800036ae:	1f6a8a93          	addi	s5,s5,502 # 800388a0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036b2:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start + tail + 1);  // read log block
    800036b4:	00035997          	auipc	s3,0x35
    800036b8:	1bc98993          	addi	s3,s3,444 # 80038870 <log>
    800036bc:	a00d                	j	800036de <install_trans+0x56>
    brelse(lbuf);
    800036be:	854a                	mv	a0,s2
    800036c0:	fffff097          	auipc	ra,0xfffff
    800036c4:	084080e7          	jalr	132(ra) # 80002744 <brelse>
    brelse(dbuf);
    800036c8:	8526                	mv	a0,s1
    800036ca:	fffff097          	auipc	ra,0xfffff
    800036ce:	07a080e7          	jalr	122(ra) # 80002744 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036d2:	2a05                	addiw	s4,s4,1
    800036d4:	0a91                	addi	s5,s5,4
    800036d6:	02c9a783          	lw	a5,44(s3)
    800036da:	04fa5e63          	bge	s4,a5,80003736 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1);  // read log block
    800036de:	0189a583          	lw	a1,24(s3)
    800036e2:	014585bb          	addw	a1,a1,s4
    800036e6:	2585                	addiw	a1,a1,1
    800036e8:	0289a503          	lw	a0,40(s3)
    800036ec:	fffff097          	auipc	ra,0xfffff
    800036f0:	f28080e7          	jalr	-216(ra) # 80002614 <bread>
    800036f4:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);    // read dst
    800036f6:	000aa583          	lw	a1,0(s5)
    800036fa:	0289a503          	lw	a0,40(s3)
    800036fe:	fffff097          	auipc	ra,0xfffff
    80003702:	f16080e7          	jalr	-234(ra) # 80002614 <bread>
    80003706:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003708:	40000613          	li	a2,1024
    8000370c:	05890593          	addi	a1,s2,88
    80003710:	05850513          	addi	a0,a0,88
    80003714:	ffffd097          	auipc	ra,0xffffd
    80003718:	bea080e7          	jalr	-1046(ra) # 800002fe <memmove>
    bwrite(dbuf);                            // write dst to disk
    8000371c:	8526                	mv	a0,s1
    8000371e:	fffff097          	auipc	ra,0xfffff
    80003722:	fe8080e7          	jalr	-24(ra) # 80002706 <bwrite>
    if (recovering == 0) bunpin(dbuf);
    80003726:	f80b1ce3          	bnez	s6,800036be <install_trans+0x36>
    8000372a:	8526                	mv	a0,s1
    8000372c:	fffff097          	auipc	ra,0xfffff
    80003730:	0f2080e7          	jalr	242(ra) # 8000281e <bunpin>
    80003734:	b769                	j	800036be <install_trans+0x36>
}
    80003736:	70e2                	ld	ra,56(sp)
    80003738:	7442                	ld	s0,48(sp)
    8000373a:	74a2                	ld	s1,40(sp)
    8000373c:	7902                	ld	s2,32(sp)
    8000373e:	69e2                	ld	s3,24(sp)
    80003740:	6a42                	ld	s4,16(sp)
    80003742:	6aa2                	ld	s5,8(sp)
    80003744:	6b02                	ld	s6,0(sp)
    80003746:	6121                	addi	sp,sp,64
    80003748:	8082                	ret
    8000374a:	8082                	ret

000000008000374c <initlog>:
void initlog(int dev, struct superblock *sb) {
    8000374c:	7179                	addi	sp,sp,-48
    8000374e:	f406                	sd	ra,40(sp)
    80003750:	f022                	sd	s0,32(sp)
    80003752:	ec26                	sd	s1,24(sp)
    80003754:	e84a                	sd	s2,16(sp)
    80003756:	e44e                	sd	s3,8(sp)
    80003758:	1800                	addi	s0,sp,48
    8000375a:	892a                	mv	s2,a0
    8000375c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000375e:	00035497          	auipc	s1,0x35
    80003762:	11248493          	addi	s1,s1,274 # 80038870 <log>
    80003766:	00005597          	auipc	a1,0x5
    8000376a:	dfa58593          	addi	a1,a1,-518 # 80008560 <syscalls+0x1d8>
    8000376e:	8526                	mv	a0,s1
    80003770:	00003097          	auipc	ra,0x3
    80003774:	c2a080e7          	jalr	-982(ra) # 8000639a <initlock>
  log.start = sb->logstart;
    80003778:	0149a583          	lw	a1,20(s3)
    8000377c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000377e:	0109a783          	lw	a5,16(s3)
    80003782:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003784:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003788:	854a                	mv	a0,s2
    8000378a:	fffff097          	auipc	ra,0xfffff
    8000378e:	e8a080e7          	jalr	-374(ra) # 80002614 <bread>
  log.lh.n = lh->n;
    80003792:	4d34                	lw	a3,88(a0)
    80003794:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003796:	02d05563          	blez	a3,800037c0 <initlog+0x74>
    8000379a:	05c50793          	addi	a5,a0,92
    8000379e:	00035717          	auipc	a4,0x35
    800037a2:	10270713          	addi	a4,a4,258 # 800388a0 <log+0x30>
    800037a6:	36fd                	addiw	a3,a3,-1
    800037a8:	1682                	slli	a3,a3,0x20
    800037aa:	9281                	srli	a3,a3,0x20
    800037ac:	068a                	slli	a3,a3,0x2
    800037ae:	06050613          	addi	a2,a0,96
    800037b2:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800037b4:	4390                	lw	a2,0(a5)
    800037b6:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800037b8:	0791                	addi	a5,a5,4
    800037ba:	0711                	addi	a4,a4,4
    800037bc:	fed79ce3          	bne	a5,a3,800037b4 <initlog+0x68>
  brelse(buf);
    800037c0:	fffff097          	auipc	ra,0xfffff
    800037c4:	f84080e7          	jalr	-124(ra) # 80002744 <brelse>

static void recover_from_log(void) {
  read_head();
  install_trans(1);  // if committed, copy from log to disk
    800037c8:	4505                	li	a0,1
    800037ca:	00000097          	auipc	ra,0x0
    800037ce:	ebe080e7          	jalr	-322(ra) # 80003688 <install_trans>
  log.lh.n = 0;
    800037d2:	00035797          	auipc	a5,0x35
    800037d6:	0c07a523          	sw	zero,202(a5) # 8003889c <log+0x2c>
  write_head();  // clear the log
    800037da:	00000097          	auipc	ra,0x0
    800037de:	e34080e7          	jalr	-460(ra) # 8000360e <write_head>
}
    800037e2:	70a2                	ld	ra,40(sp)
    800037e4:	7402                	ld	s0,32(sp)
    800037e6:	64e2                	ld	s1,24(sp)
    800037e8:	6942                	ld	s2,16(sp)
    800037ea:	69a2                	ld	s3,8(sp)
    800037ec:	6145                	addi	sp,sp,48
    800037ee:	8082                	ret

00000000800037f0 <begin_op>:
}

// called at the start of each FS system call.
void begin_op(void) {
    800037f0:	1101                	addi	sp,sp,-32
    800037f2:	ec06                	sd	ra,24(sp)
    800037f4:	e822                	sd	s0,16(sp)
    800037f6:	e426                	sd	s1,8(sp)
    800037f8:	e04a                	sd	s2,0(sp)
    800037fa:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800037fc:	00035517          	auipc	a0,0x35
    80003800:	07450513          	addi	a0,a0,116 # 80038870 <log>
    80003804:	00003097          	auipc	ra,0x3
    80003808:	c26080e7          	jalr	-986(ra) # 8000642a <acquire>
  while (1) {
    if (log.committing) {
    8000380c:	00035497          	auipc	s1,0x35
    80003810:	06448493          	addi	s1,s1,100 # 80038870 <log>
      sleep(&log, &log.lock);
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
    80003814:	4979                	li	s2,30
    80003816:	a039                	j	80003824 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003818:	85a6                	mv	a1,s1
    8000381a:	8526                	mv	a0,s1
    8000381c:	ffffe097          	auipc	ra,0xffffe
    80003820:	ff4080e7          	jalr	-12(ra) # 80001810 <sleep>
    if (log.committing) {
    80003824:	50dc                	lw	a5,36(s1)
    80003826:	fbed                	bnez	a5,80003818 <begin_op+0x28>
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
    80003828:	509c                	lw	a5,32(s1)
    8000382a:	0017871b          	addiw	a4,a5,1
    8000382e:	0007069b          	sext.w	a3,a4
    80003832:	0027179b          	slliw	a5,a4,0x2
    80003836:	9fb9                	addw	a5,a5,a4
    80003838:	0017979b          	slliw	a5,a5,0x1
    8000383c:	54d8                	lw	a4,44(s1)
    8000383e:	9fb9                	addw	a5,a5,a4
    80003840:	00f95963          	bge	s2,a5,80003852 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003844:	85a6                	mv	a1,s1
    80003846:	8526                	mv	a0,s1
    80003848:	ffffe097          	auipc	ra,0xffffe
    8000384c:	fc8080e7          	jalr	-56(ra) # 80001810 <sleep>
    80003850:	bfd1                	j	80003824 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003852:	00035517          	auipc	a0,0x35
    80003856:	01e50513          	addi	a0,a0,30 # 80038870 <log>
    8000385a:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000385c:	00003097          	auipc	ra,0x3
    80003860:	c82080e7          	jalr	-894(ra) # 800064de <release>
      break;
    }
  }
}
    80003864:	60e2                	ld	ra,24(sp)
    80003866:	6442                	ld	s0,16(sp)
    80003868:	64a2                	ld	s1,8(sp)
    8000386a:	6902                	ld	s2,0(sp)
    8000386c:	6105                	addi	sp,sp,32
    8000386e:	8082                	ret

0000000080003870 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void end_op(void) {
    80003870:	7139                	addi	sp,sp,-64
    80003872:	fc06                	sd	ra,56(sp)
    80003874:	f822                	sd	s0,48(sp)
    80003876:	f426                	sd	s1,40(sp)
    80003878:	f04a                	sd	s2,32(sp)
    8000387a:	ec4e                	sd	s3,24(sp)
    8000387c:	e852                	sd	s4,16(sp)
    8000387e:	e456                	sd	s5,8(sp)
    80003880:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003882:	00035497          	auipc	s1,0x35
    80003886:	fee48493          	addi	s1,s1,-18 # 80038870 <log>
    8000388a:	8526                	mv	a0,s1
    8000388c:	00003097          	auipc	ra,0x3
    80003890:	b9e080e7          	jalr	-1122(ra) # 8000642a <acquire>
  log.outstanding -= 1;
    80003894:	509c                	lw	a5,32(s1)
    80003896:	37fd                	addiw	a5,a5,-1
    80003898:	0007891b          	sext.w	s2,a5
    8000389c:	d09c                	sw	a5,32(s1)
  if (log.committing) panic("log.committing");
    8000389e:	50dc                	lw	a5,36(s1)
    800038a0:	e7b9                	bnez	a5,800038ee <end_op+0x7e>
  if (log.outstanding == 0) {
    800038a2:	04091e63          	bnez	s2,800038fe <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800038a6:	00035497          	auipc	s1,0x35
    800038aa:	fca48493          	addi	s1,s1,-54 # 80038870 <log>
    800038ae:	4785                	li	a5,1
    800038b0:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800038b2:	8526                	mv	a0,s1
    800038b4:	00003097          	auipc	ra,0x3
    800038b8:	c2a080e7          	jalr	-982(ra) # 800064de <release>
    brelse(to);
  }
}

static void commit() {
  if (log.lh.n > 0) {
    800038bc:	54dc                	lw	a5,44(s1)
    800038be:	06f04763          	bgtz	a5,8000392c <end_op+0xbc>
    acquire(&log.lock);
    800038c2:	00035497          	auipc	s1,0x35
    800038c6:	fae48493          	addi	s1,s1,-82 # 80038870 <log>
    800038ca:	8526                	mv	a0,s1
    800038cc:	00003097          	auipc	ra,0x3
    800038d0:	b5e080e7          	jalr	-1186(ra) # 8000642a <acquire>
    log.committing = 0;
    800038d4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800038d8:	8526                	mv	a0,s1
    800038da:	ffffe097          	auipc	ra,0xffffe
    800038de:	f9a080e7          	jalr	-102(ra) # 80001874 <wakeup>
    release(&log.lock);
    800038e2:	8526                	mv	a0,s1
    800038e4:	00003097          	auipc	ra,0x3
    800038e8:	bfa080e7          	jalr	-1030(ra) # 800064de <release>
}
    800038ec:	a03d                	j	8000391a <end_op+0xaa>
  if (log.committing) panic("log.committing");
    800038ee:	00005517          	auipc	a0,0x5
    800038f2:	c7a50513          	addi	a0,a0,-902 # 80008568 <syscalls+0x1e0>
    800038f6:	00002097          	auipc	ra,0x2
    800038fa:	5f8080e7          	jalr	1528(ra) # 80005eee <panic>
    wakeup(&log);
    800038fe:	00035497          	auipc	s1,0x35
    80003902:	f7248493          	addi	s1,s1,-142 # 80038870 <log>
    80003906:	8526                	mv	a0,s1
    80003908:	ffffe097          	auipc	ra,0xffffe
    8000390c:	f6c080e7          	jalr	-148(ra) # 80001874 <wakeup>
  release(&log.lock);
    80003910:	8526                	mv	a0,s1
    80003912:	00003097          	auipc	ra,0x3
    80003916:	bcc080e7          	jalr	-1076(ra) # 800064de <release>
}
    8000391a:	70e2                	ld	ra,56(sp)
    8000391c:	7442                	ld	s0,48(sp)
    8000391e:	74a2                	ld	s1,40(sp)
    80003920:	7902                	ld	s2,32(sp)
    80003922:	69e2                	ld	s3,24(sp)
    80003924:	6a42                	ld	s4,16(sp)
    80003926:	6aa2                	ld	s5,8(sp)
    80003928:	6121                	addi	sp,sp,64
    8000392a:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    8000392c:	00035a97          	auipc	s5,0x35
    80003930:	f74a8a93          	addi	s5,s5,-140 # 800388a0 <log+0x30>
    struct buf *to = bread(log.dev, log.start + tail + 1);  // log block
    80003934:	00035a17          	auipc	s4,0x35
    80003938:	f3ca0a13          	addi	s4,s4,-196 # 80038870 <log>
    8000393c:	018a2583          	lw	a1,24(s4)
    80003940:	012585bb          	addw	a1,a1,s2
    80003944:	2585                	addiw	a1,a1,1
    80003946:	028a2503          	lw	a0,40(s4)
    8000394a:	fffff097          	auipc	ra,0xfffff
    8000394e:	cca080e7          	jalr	-822(ra) # 80002614 <bread>
    80003952:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]);  // cache block
    80003954:	000aa583          	lw	a1,0(s5)
    80003958:	028a2503          	lw	a0,40(s4)
    8000395c:	fffff097          	auipc	ra,0xfffff
    80003960:	cb8080e7          	jalr	-840(ra) # 80002614 <bread>
    80003964:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003966:	40000613          	li	a2,1024
    8000396a:	05850593          	addi	a1,a0,88
    8000396e:	05848513          	addi	a0,s1,88
    80003972:	ffffd097          	auipc	ra,0xffffd
    80003976:	98c080e7          	jalr	-1652(ra) # 800002fe <memmove>
    bwrite(to);  // write the log
    8000397a:	8526                	mv	a0,s1
    8000397c:	fffff097          	auipc	ra,0xfffff
    80003980:	d8a080e7          	jalr	-630(ra) # 80002706 <bwrite>
    brelse(from);
    80003984:	854e                	mv	a0,s3
    80003986:	fffff097          	auipc	ra,0xfffff
    8000398a:	dbe080e7          	jalr	-578(ra) # 80002744 <brelse>
    brelse(to);
    8000398e:	8526                	mv	a0,s1
    80003990:	fffff097          	auipc	ra,0xfffff
    80003994:	db4080e7          	jalr	-588(ra) # 80002744 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003998:	2905                	addiw	s2,s2,1
    8000399a:	0a91                	addi	s5,s5,4
    8000399c:	02ca2783          	lw	a5,44(s4)
    800039a0:	f8f94ee3          	blt	s2,a5,8000393c <end_op+0xcc>
    write_log();       // Write modified blocks from cache to log
    write_head();      // Write header to disk -- the real commit
    800039a4:	00000097          	auipc	ra,0x0
    800039a8:	c6a080e7          	jalr	-918(ra) # 8000360e <write_head>
    install_trans(0);  // Now install writes to home locations
    800039ac:	4501                	li	a0,0
    800039ae:	00000097          	auipc	ra,0x0
    800039b2:	cda080e7          	jalr	-806(ra) # 80003688 <install_trans>
    log.lh.n = 0;
    800039b6:	00035797          	auipc	a5,0x35
    800039ba:	ee07a323          	sw	zero,-282(a5) # 8003889c <log+0x2c>
    write_head();  // Erase the transaction from the log
    800039be:	00000097          	auipc	ra,0x0
    800039c2:	c50080e7          	jalr	-944(ra) # 8000360e <write_head>
    800039c6:	bdf5                	j	800038c2 <end_op+0x52>

00000000800039c8 <log_write>:
// log_write() replaces bwrite(); a typical use is:
//   bp = bread(...)
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void log_write(struct buf *b) {
    800039c8:	1101                	addi	sp,sp,-32
    800039ca:	ec06                	sd	ra,24(sp)
    800039cc:	e822                	sd	s0,16(sp)
    800039ce:	e426                	sd	s1,8(sp)
    800039d0:	e04a                	sd	s2,0(sp)
    800039d2:	1000                	addi	s0,sp,32
    800039d4:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800039d6:	00035917          	auipc	s2,0x35
    800039da:	e9a90913          	addi	s2,s2,-358 # 80038870 <log>
    800039de:	854a                	mv	a0,s2
    800039e0:	00003097          	auipc	ra,0x3
    800039e4:	a4a080e7          	jalr	-1462(ra) # 8000642a <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800039e8:	02c92603          	lw	a2,44(s2)
    800039ec:	47f5                	li	a5,29
    800039ee:	06c7c563          	blt	a5,a2,80003a58 <log_write+0x90>
    800039f2:	00035797          	auipc	a5,0x35
    800039f6:	e9a7a783          	lw	a5,-358(a5) # 8003888c <log+0x1c>
    800039fa:	37fd                	addiw	a5,a5,-1
    800039fc:	04f65e63          	bge	a2,a5,80003a58 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1) panic("log_write outside of trans");
    80003a00:	00035797          	auipc	a5,0x35
    80003a04:	e907a783          	lw	a5,-368(a5) # 80038890 <log+0x20>
    80003a08:	06f05063          	blez	a5,80003a68 <log_write+0xa0>

  for (i = 0; i < log.lh.n; i++) {
    80003a0c:	4781                	li	a5,0
    80003a0e:	06c05563          	blez	a2,80003a78 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)  // log absorption
    80003a12:	44cc                	lw	a1,12(s1)
    80003a14:	00035717          	auipc	a4,0x35
    80003a18:	e8c70713          	addi	a4,a4,-372 # 800388a0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003a1c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)  // log absorption
    80003a1e:	4314                	lw	a3,0(a4)
    80003a20:	04b68c63          	beq	a3,a1,80003a78 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003a24:	2785                	addiw	a5,a5,1
    80003a26:	0711                	addi	a4,a4,4
    80003a28:	fef61be3          	bne	a2,a5,80003a1e <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003a2c:	0621                	addi	a2,a2,8
    80003a2e:	060a                	slli	a2,a2,0x2
    80003a30:	00035797          	auipc	a5,0x35
    80003a34:	e4078793          	addi	a5,a5,-448 # 80038870 <log>
    80003a38:	963e                	add	a2,a2,a5
    80003a3a:	44dc                	lw	a5,12(s1)
    80003a3c:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003a3e:	8526                	mv	a0,s1
    80003a40:	fffff097          	auipc	ra,0xfffff
    80003a44:	da2080e7          	jalr	-606(ra) # 800027e2 <bpin>
    log.lh.n++;
    80003a48:	00035717          	auipc	a4,0x35
    80003a4c:	e2870713          	addi	a4,a4,-472 # 80038870 <log>
    80003a50:	575c                	lw	a5,44(a4)
    80003a52:	2785                	addiw	a5,a5,1
    80003a54:	d75c                	sw	a5,44(a4)
    80003a56:	a835                	j	80003a92 <log_write+0xca>
    panic("too big a transaction");
    80003a58:	00005517          	auipc	a0,0x5
    80003a5c:	b2050513          	addi	a0,a0,-1248 # 80008578 <syscalls+0x1f0>
    80003a60:	00002097          	auipc	ra,0x2
    80003a64:	48e080e7          	jalr	1166(ra) # 80005eee <panic>
  if (log.outstanding < 1) panic("log_write outside of trans");
    80003a68:	00005517          	auipc	a0,0x5
    80003a6c:	b2850513          	addi	a0,a0,-1240 # 80008590 <syscalls+0x208>
    80003a70:	00002097          	auipc	ra,0x2
    80003a74:	47e080e7          	jalr	1150(ra) # 80005eee <panic>
  log.lh.block[i] = b->blockno;
    80003a78:	00878713          	addi	a4,a5,8
    80003a7c:	00271693          	slli	a3,a4,0x2
    80003a80:	00035717          	auipc	a4,0x35
    80003a84:	df070713          	addi	a4,a4,-528 # 80038870 <log>
    80003a88:	9736                	add	a4,a4,a3
    80003a8a:	44d4                	lw	a3,12(s1)
    80003a8c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003a8e:	faf608e3          	beq	a2,a5,80003a3e <log_write+0x76>
  }
  release(&log.lock);
    80003a92:	00035517          	auipc	a0,0x35
    80003a96:	dde50513          	addi	a0,a0,-546 # 80038870 <log>
    80003a9a:	00003097          	auipc	ra,0x3
    80003a9e:	a44080e7          	jalr	-1468(ra) # 800064de <release>
}
    80003aa2:	60e2                	ld	ra,24(sp)
    80003aa4:	6442                	ld	s0,16(sp)
    80003aa6:	64a2                	ld	s1,8(sp)
    80003aa8:	6902                	ld	s2,0(sp)
    80003aaa:	6105                	addi	sp,sp,32
    80003aac:	8082                	ret

0000000080003aae <initsleeplock>:
#include "sleeplock.h"

#include "defs.h"
#include "proc.h"

void initsleeplock(struct sleeplock *lk, char *name) {
    80003aae:	1101                	addi	sp,sp,-32
    80003ab0:	ec06                	sd	ra,24(sp)
    80003ab2:	e822                	sd	s0,16(sp)
    80003ab4:	e426                	sd	s1,8(sp)
    80003ab6:	e04a                	sd	s2,0(sp)
    80003ab8:	1000                	addi	s0,sp,32
    80003aba:	84aa                	mv	s1,a0
    80003abc:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003abe:	00005597          	auipc	a1,0x5
    80003ac2:	af258593          	addi	a1,a1,-1294 # 800085b0 <syscalls+0x228>
    80003ac6:	0521                	addi	a0,a0,8
    80003ac8:	00003097          	auipc	ra,0x3
    80003acc:	8d2080e7          	jalr	-1838(ra) # 8000639a <initlock>
  lk->name = name;
    80003ad0:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003ad4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003ad8:	0204a423          	sw	zero,40(s1)
}
    80003adc:	60e2                	ld	ra,24(sp)
    80003ade:	6442                	ld	s0,16(sp)
    80003ae0:	64a2                	ld	s1,8(sp)
    80003ae2:	6902                	ld	s2,0(sp)
    80003ae4:	6105                	addi	sp,sp,32
    80003ae6:	8082                	ret

0000000080003ae8 <acquiresleep>:

void acquiresleep(struct sleeplock *lk) {
    80003ae8:	1101                	addi	sp,sp,-32
    80003aea:	ec06                	sd	ra,24(sp)
    80003aec:	e822                	sd	s0,16(sp)
    80003aee:	e426                	sd	s1,8(sp)
    80003af0:	e04a                	sd	s2,0(sp)
    80003af2:	1000                	addi	s0,sp,32
    80003af4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003af6:	00850913          	addi	s2,a0,8
    80003afa:	854a                	mv	a0,s2
    80003afc:	00003097          	auipc	ra,0x3
    80003b00:	92e080e7          	jalr	-1746(ra) # 8000642a <acquire>
  while (lk->locked) {
    80003b04:	409c                	lw	a5,0(s1)
    80003b06:	cb89                	beqz	a5,80003b18 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003b08:	85ca                	mv	a1,s2
    80003b0a:	8526                	mv	a0,s1
    80003b0c:	ffffe097          	auipc	ra,0xffffe
    80003b10:	d04080e7          	jalr	-764(ra) # 80001810 <sleep>
  while (lk->locked) {
    80003b14:	409c                	lw	a5,0(s1)
    80003b16:	fbed                	bnez	a5,80003b08 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003b18:	4785                	li	a5,1
    80003b1a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003b1c:	ffffd097          	auipc	ra,0xffffd
    80003b20:	648080e7          	jalr	1608(ra) # 80001164 <myproc>
    80003b24:	591c                	lw	a5,48(a0)
    80003b26:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003b28:	854a                	mv	a0,s2
    80003b2a:	00003097          	auipc	ra,0x3
    80003b2e:	9b4080e7          	jalr	-1612(ra) # 800064de <release>
}
    80003b32:	60e2                	ld	ra,24(sp)
    80003b34:	6442                	ld	s0,16(sp)
    80003b36:	64a2                	ld	s1,8(sp)
    80003b38:	6902                	ld	s2,0(sp)
    80003b3a:	6105                	addi	sp,sp,32
    80003b3c:	8082                	ret

0000000080003b3e <releasesleep>:

void releasesleep(struct sleeplock *lk) {
    80003b3e:	1101                	addi	sp,sp,-32
    80003b40:	ec06                	sd	ra,24(sp)
    80003b42:	e822                	sd	s0,16(sp)
    80003b44:	e426                	sd	s1,8(sp)
    80003b46:	e04a                	sd	s2,0(sp)
    80003b48:	1000                	addi	s0,sp,32
    80003b4a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b4c:	00850913          	addi	s2,a0,8
    80003b50:	854a                	mv	a0,s2
    80003b52:	00003097          	auipc	ra,0x3
    80003b56:	8d8080e7          	jalr	-1832(ra) # 8000642a <acquire>
  lk->locked = 0;
    80003b5a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b5e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003b62:	8526                	mv	a0,s1
    80003b64:	ffffe097          	auipc	ra,0xffffe
    80003b68:	d10080e7          	jalr	-752(ra) # 80001874 <wakeup>
  release(&lk->lk);
    80003b6c:	854a                	mv	a0,s2
    80003b6e:	00003097          	auipc	ra,0x3
    80003b72:	970080e7          	jalr	-1680(ra) # 800064de <release>
}
    80003b76:	60e2                	ld	ra,24(sp)
    80003b78:	6442                	ld	s0,16(sp)
    80003b7a:	64a2                	ld	s1,8(sp)
    80003b7c:	6902                	ld	s2,0(sp)
    80003b7e:	6105                	addi	sp,sp,32
    80003b80:	8082                	ret

0000000080003b82 <holdingsleep>:

int holdingsleep(struct sleeplock *lk) {
    80003b82:	7179                	addi	sp,sp,-48
    80003b84:	f406                	sd	ra,40(sp)
    80003b86:	f022                	sd	s0,32(sp)
    80003b88:	ec26                	sd	s1,24(sp)
    80003b8a:	e84a                	sd	s2,16(sp)
    80003b8c:	e44e                	sd	s3,8(sp)
    80003b8e:	1800                	addi	s0,sp,48
    80003b90:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    80003b92:	00850913          	addi	s2,a0,8
    80003b96:	854a                	mv	a0,s2
    80003b98:	00003097          	auipc	ra,0x3
    80003b9c:	892080e7          	jalr	-1902(ra) # 8000642a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ba0:	409c                	lw	a5,0(s1)
    80003ba2:	ef99                	bnez	a5,80003bc0 <holdingsleep+0x3e>
    80003ba4:	4481                	li	s1,0
  release(&lk->lk);
    80003ba6:	854a                	mv	a0,s2
    80003ba8:	00003097          	auipc	ra,0x3
    80003bac:	936080e7          	jalr	-1738(ra) # 800064de <release>
  return r;
}
    80003bb0:	8526                	mv	a0,s1
    80003bb2:	70a2                	ld	ra,40(sp)
    80003bb4:	7402                	ld	s0,32(sp)
    80003bb6:	64e2                	ld	s1,24(sp)
    80003bb8:	6942                	ld	s2,16(sp)
    80003bba:	69a2                	ld	s3,8(sp)
    80003bbc:	6145                	addi	sp,sp,48
    80003bbe:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003bc0:	0284a983          	lw	s3,40(s1)
    80003bc4:	ffffd097          	auipc	ra,0xffffd
    80003bc8:	5a0080e7          	jalr	1440(ra) # 80001164 <myproc>
    80003bcc:	5904                	lw	s1,48(a0)
    80003bce:	413484b3          	sub	s1,s1,s3
    80003bd2:	0014b493          	seqz	s1,s1
    80003bd6:	bfc1                	j	80003ba6 <holdingsleep+0x24>

0000000080003bd8 <fileinit>:
struct {
  struct spinlock lock;
  struct file file[NFILE];
} ftable;

void fileinit(void) { initlock(&ftable.lock, "ftable"); }
    80003bd8:	1141                	addi	sp,sp,-16
    80003bda:	e406                	sd	ra,8(sp)
    80003bdc:	e022                	sd	s0,0(sp)
    80003bde:	0800                	addi	s0,sp,16
    80003be0:	00005597          	auipc	a1,0x5
    80003be4:	9e058593          	addi	a1,a1,-1568 # 800085c0 <syscalls+0x238>
    80003be8:	00035517          	auipc	a0,0x35
    80003bec:	dd050513          	addi	a0,a0,-560 # 800389b8 <ftable>
    80003bf0:	00002097          	auipc	ra,0x2
    80003bf4:	7aa080e7          	jalr	1962(ra) # 8000639a <initlock>
    80003bf8:	60a2                	ld	ra,8(sp)
    80003bfa:	6402                	ld	s0,0(sp)
    80003bfc:	0141                	addi	sp,sp,16
    80003bfe:	8082                	ret

0000000080003c00 <filealloc>:

// Allocate a file structure.
struct file *filealloc(void) {
    80003c00:	1101                	addi	sp,sp,-32
    80003c02:	ec06                	sd	ra,24(sp)
    80003c04:	e822                	sd	s0,16(sp)
    80003c06:	e426                	sd	s1,8(sp)
    80003c08:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003c0a:	00035517          	auipc	a0,0x35
    80003c0e:	dae50513          	addi	a0,a0,-594 # 800389b8 <ftable>
    80003c12:	00003097          	auipc	ra,0x3
    80003c16:	818080e7          	jalr	-2024(ra) # 8000642a <acquire>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80003c1a:	00035497          	auipc	s1,0x35
    80003c1e:	db648493          	addi	s1,s1,-586 # 800389d0 <ftable+0x18>
    80003c22:	00036717          	auipc	a4,0x36
    80003c26:	d4e70713          	addi	a4,a4,-690 # 80039970 <disk>
    if (f->ref == 0) {
    80003c2a:	40dc                	lw	a5,4(s1)
    80003c2c:	cf99                	beqz	a5,80003c4a <filealloc+0x4a>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80003c2e:	02848493          	addi	s1,s1,40
    80003c32:	fee49ce3          	bne	s1,a4,80003c2a <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003c36:	00035517          	auipc	a0,0x35
    80003c3a:	d8250513          	addi	a0,a0,-638 # 800389b8 <ftable>
    80003c3e:	00003097          	auipc	ra,0x3
    80003c42:	8a0080e7          	jalr	-1888(ra) # 800064de <release>
  return 0;
    80003c46:	4481                	li	s1,0
    80003c48:	a819                	j	80003c5e <filealloc+0x5e>
      f->ref = 1;
    80003c4a:	4785                	li	a5,1
    80003c4c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003c4e:	00035517          	auipc	a0,0x35
    80003c52:	d6a50513          	addi	a0,a0,-662 # 800389b8 <ftable>
    80003c56:	00003097          	auipc	ra,0x3
    80003c5a:	888080e7          	jalr	-1912(ra) # 800064de <release>
}
    80003c5e:	8526                	mv	a0,s1
    80003c60:	60e2                	ld	ra,24(sp)
    80003c62:	6442                	ld	s0,16(sp)
    80003c64:	64a2                	ld	s1,8(sp)
    80003c66:	6105                	addi	sp,sp,32
    80003c68:	8082                	ret

0000000080003c6a <filedup>:

// Increment ref count for file f.
struct file *filedup(struct file *f) {
    80003c6a:	1101                	addi	sp,sp,-32
    80003c6c:	ec06                	sd	ra,24(sp)
    80003c6e:	e822                	sd	s0,16(sp)
    80003c70:	e426                	sd	s1,8(sp)
    80003c72:	1000                	addi	s0,sp,32
    80003c74:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003c76:	00035517          	auipc	a0,0x35
    80003c7a:	d4250513          	addi	a0,a0,-702 # 800389b8 <ftable>
    80003c7e:	00002097          	auipc	ra,0x2
    80003c82:	7ac080e7          	jalr	1964(ra) # 8000642a <acquire>
  if (f->ref < 1) panic("filedup");
    80003c86:	40dc                	lw	a5,4(s1)
    80003c88:	02f05263          	blez	a5,80003cac <filedup+0x42>
  f->ref++;
    80003c8c:	2785                	addiw	a5,a5,1
    80003c8e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003c90:	00035517          	auipc	a0,0x35
    80003c94:	d2850513          	addi	a0,a0,-728 # 800389b8 <ftable>
    80003c98:	00003097          	auipc	ra,0x3
    80003c9c:	846080e7          	jalr	-1978(ra) # 800064de <release>
  return f;
}
    80003ca0:	8526                	mv	a0,s1
    80003ca2:	60e2                	ld	ra,24(sp)
    80003ca4:	6442                	ld	s0,16(sp)
    80003ca6:	64a2                	ld	s1,8(sp)
    80003ca8:	6105                	addi	sp,sp,32
    80003caa:	8082                	ret
  if (f->ref < 1) panic("filedup");
    80003cac:	00005517          	auipc	a0,0x5
    80003cb0:	91c50513          	addi	a0,a0,-1764 # 800085c8 <syscalls+0x240>
    80003cb4:	00002097          	auipc	ra,0x2
    80003cb8:	23a080e7          	jalr	570(ra) # 80005eee <panic>

0000000080003cbc <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f) {
    80003cbc:	7139                	addi	sp,sp,-64
    80003cbe:	fc06                	sd	ra,56(sp)
    80003cc0:	f822                	sd	s0,48(sp)
    80003cc2:	f426                	sd	s1,40(sp)
    80003cc4:	f04a                	sd	s2,32(sp)
    80003cc6:	ec4e                	sd	s3,24(sp)
    80003cc8:	e852                	sd	s4,16(sp)
    80003cca:	e456                	sd	s5,8(sp)
    80003ccc:	0080                	addi	s0,sp,64
    80003cce:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003cd0:	00035517          	auipc	a0,0x35
    80003cd4:	ce850513          	addi	a0,a0,-792 # 800389b8 <ftable>
    80003cd8:	00002097          	auipc	ra,0x2
    80003cdc:	752080e7          	jalr	1874(ra) # 8000642a <acquire>
  if (f->ref < 1) panic("fileclose");
    80003ce0:	40dc                	lw	a5,4(s1)
    80003ce2:	06f05163          	blez	a5,80003d44 <fileclose+0x88>
  if (--f->ref > 0) {
    80003ce6:	37fd                	addiw	a5,a5,-1
    80003ce8:	0007871b          	sext.w	a4,a5
    80003cec:	c0dc                	sw	a5,4(s1)
    80003cee:	06e04363          	bgtz	a4,80003d54 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003cf2:	0004a903          	lw	s2,0(s1)
    80003cf6:	0094ca83          	lbu	s5,9(s1)
    80003cfa:	0104ba03          	ld	s4,16(s1)
    80003cfe:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003d02:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003d06:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003d0a:	00035517          	auipc	a0,0x35
    80003d0e:	cae50513          	addi	a0,a0,-850 # 800389b8 <ftable>
    80003d12:	00002097          	auipc	ra,0x2
    80003d16:	7cc080e7          	jalr	1996(ra) # 800064de <release>

  if (ff.type == FD_PIPE) {
    80003d1a:	4785                	li	a5,1
    80003d1c:	04f90d63          	beq	s2,a5,80003d76 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if (ff.type == FD_INODE || ff.type == FD_DEVICE) {
    80003d20:	3979                	addiw	s2,s2,-2
    80003d22:	4785                	li	a5,1
    80003d24:	0527e063          	bltu	a5,s2,80003d64 <fileclose+0xa8>
    begin_op();
    80003d28:	00000097          	auipc	ra,0x0
    80003d2c:	ac8080e7          	jalr	-1336(ra) # 800037f0 <begin_op>
    iput(ff.ip);
    80003d30:	854e                	mv	a0,s3
    80003d32:	fffff097          	auipc	ra,0xfffff
    80003d36:	2b6080e7          	jalr	694(ra) # 80002fe8 <iput>
    end_op();
    80003d3a:	00000097          	auipc	ra,0x0
    80003d3e:	b36080e7          	jalr	-1226(ra) # 80003870 <end_op>
    80003d42:	a00d                	j	80003d64 <fileclose+0xa8>
  if (f->ref < 1) panic("fileclose");
    80003d44:	00005517          	auipc	a0,0x5
    80003d48:	88c50513          	addi	a0,a0,-1908 # 800085d0 <syscalls+0x248>
    80003d4c:	00002097          	auipc	ra,0x2
    80003d50:	1a2080e7          	jalr	418(ra) # 80005eee <panic>
    release(&ftable.lock);
    80003d54:	00035517          	auipc	a0,0x35
    80003d58:	c6450513          	addi	a0,a0,-924 # 800389b8 <ftable>
    80003d5c:	00002097          	auipc	ra,0x2
    80003d60:	782080e7          	jalr	1922(ra) # 800064de <release>
  }
}
    80003d64:	70e2                	ld	ra,56(sp)
    80003d66:	7442                	ld	s0,48(sp)
    80003d68:	74a2                	ld	s1,40(sp)
    80003d6a:	7902                	ld	s2,32(sp)
    80003d6c:	69e2                	ld	s3,24(sp)
    80003d6e:	6a42                	ld	s4,16(sp)
    80003d70:	6aa2                	ld	s5,8(sp)
    80003d72:	6121                	addi	sp,sp,64
    80003d74:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003d76:	85d6                	mv	a1,s5
    80003d78:	8552                	mv	a0,s4
    80003d7a:	00000097          	auipc	ra,0x0
    80003d7e:	34c080e7          	jalr	844(ra) # 800040c6 <pipeclose>
    80003d82:	b7cd                	j	80003d64 <fileclose+0xa8>

0000000080003d84 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int filestat(struct file *f, uint64 addr) {
    80003d84:	715d                	addi	sp,sp,-80
    80003d86:	e486                	sd	ra,72(sp)
    80003d88:	e0a2                	sd	s0,64(sp)
    80003d8a:	fc26                	sd	s1,56(sp)
    80003d8c:	f84a                	sd	s2,48(sp)
    80003d8e:	f44e                	sd	s3,40(sp)
    80003d90:	0880                	addi	s0,sp,80
    80003d92:	84aa                	mv	s1,a0
    80003d94:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003d96:	ffffd097          	auipc	ra,0xffffd
    80003d9a:	3ce080e7          	jalr	974(ra) # 80001164 <myproc>
  struct stat st;

  if (f->type == FD_INODE || f->type == FD_DEVICE) {
    80003d9e:	409c                	lw	a5,0(s1)
    80003da0:	37f9                	addiw	a5,a5,-2
    80003da2:	4705                	li	a4,1
    80003da4:	04f76763          	bltu	a4,a5,80003df2 <filestat+0x6e>
    80003da8:	892a                	mv	s2,a0
    ilock(f->ip);
    80003daa:	6c88                	ld	a0,24(s1)
    80003dac:	fffff097          	auipc	ra,0xfffff
    80003db0:	082080e7          	jalr	130(ra) # 80002e2e <ilock>
    stati(f->ip, &st);
    80003db4:	fb840593          	addi	a1,s0,-72
    80003db8:	6c88                	ld	a0,24(s1)
    80003dba:	fffff097          	auipc	ra,0xfffff
    80003dbe:	2fe080e7          	jalr	766(ra) # 800030b8 <stati>
    iunlock(f->ip);
    80003dc2:	6c88                	ld	a0,24(s1)
    80003dc4:	fffff097          	auipc	ra,0xfffff
    80003dc8:	12c080e7          	jalr	300(ra) # 80002ef0 <iunlock>
    if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0) return -1;
    80003dcc:	46e1                	li	a3,24
    80003dce:	fb840613          	addi	a2,s0,-72
    80003dd2:	85ce                	mv	a1,s3
    80003dd4:	05093503          	ld	a0,80(s2)
    80003dd8:	ffffd097          	auipc	ra,0xffffd
    80003ddc:	ed4080e7          	jalr	-300(ra) # 80000cac <copyout>
    80003de0:	41f5551b          	sraiw	a0,a0,0x1f
    return 0;
  }
  return -1;
}
    80003de4:	60a6                	ld	ra,72(sp)
    80003de6:	6406                	ld	s0,64(sp)
    80003de8:	74e2                	ld	s1,56(sp)
    80003dea:	7942                	ld	s2,48(sp)
    80003dec:	79a2                	ld	s3,40(sp)
    80003dee:	6161                	addi	sp,sp,80
    80003df0:	8082                	ret
  return -1;
    80003df2:	557d                	li	a0,-1
    80003df4:	bfc5                	j	80003de4 <filestat+0x60>

0000000080003df6 <fileread>:

// Read from file f.
// addr is a user virtual address.
int fileread(struct file *f, uint64 addr, int n) {
    80003df6:	7179                	addi	sp,sp,-48
    80003df8:	f406                	sd	ra,40(sp)
    80003dfa:	f022                	sd	s0,32(sp)
    80003dfc:	ec26                	sd	s1,24(sp)
    80003dfe:	e84a                	sd	s2,16(sp)
    80003e00:	e44e                	sd	s3,8(sp)
    80003e02:	1800                	addi	s0,sp,48
  int r = 0;

  if (f->readable == 0) return -1;
    80003e04:	00854783          	lbu	a5,8(a0)
    80003e08:	c3d5                	beqz	a5,80003eac <fileread+0xb6>
    80003e0a:	84aa                	mv	s1,a0
    80003e0c:	89ae                	mv	s3,a1
    80003e0e:	8932                	mv	s2,a2

  if (f->type == FD_PIPE) {
    80003e10:	411c                	lw	a5,0(a0)
    80003e12:	4705                	li	a4,1
    80003e14:	04e78963          	beq	a5,a4,80003e66 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80003e18:	470d                	li	a4,3
    80003e1a:	04e78d63          	beq	a5,a4,80003e74 <fileread+0x7e>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if (f->type == FD_INODE) {
    80003e1e:	4709                	li	a4,2
    80003e20:	06e79e63          	bne	a5,a4,80003e9c <fileread+0xa6>
    ilock(f->ip);
    80003e24:	6d08                	ld	a0,24(a0)
    80003e26:	fffff097          	auipc	ra,0xfffff
    80003e2a:	008080e7          	jalr	8(ra) # 80002e2e <ilock>
    if ((r = readi(f->ip, 1, addr, f->off, n)) > 0) f->off += r;
    80003e2e:	874a                	mv	a4,s2
    80003e30:	5094                	lw	a3,32(s1)
    80003e32:	864e                	mv	a2,s3
    80003e34:	4585                	li	a1,1
    80003e36:	6c88                	ld	a0,24(s1)
    80003e38:	fffff097          	auipc	ra,0xfffff
    80003e3c:	2aa080e7          	jalr	682(ra) # 800030e2 <readi>
    80003e40:	892a                	mv	s2,a0
    80003e42:	00a05563          	blez	a0,80003e4c <fileread+0x56>
    80003e46:	509c                	lw	a5,32(s1)
    80003e48:	9fa9                	addw	a5,a5,a0
    80003e4a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003e4c:	6c88                	ld	a0,24(s1)
    80003e4e:	fffff097          	auipc	ra,0xfffff
    80003e52:	0a2080e7          	jalr	162(ra) # 80002ef0 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003e56:	854a                	mv	a0,s2
    80003e58:	70a2                	ld	ra,40(sp)
    80003e5a:	7402                	ld	s0,32(sp)
    80003e5c:	64e2                	ld	s1,24(sp)
    80003e5e:	6942                	ld	s2,16(sp)
    80003e60:	69a2                	ld	s3,8(sp)
    80003e62:	6145                	addi	sp,sp,48
    80003e64:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003e66:	6908                	ld	a0,16(a0)
    80003e68:	00000097          	auipc	ra,0x0
    80003e6c:	3c6080e7          	jalr	966(ra) # 8000422e <piperead>
    80003e70:	892a                	mv	s2,a0
    80003e72:	b7d5                	j	80003e56 <fileread+0x60>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    80003e74:	02451783          	lh	a5,36(a0)
    80003e78:	03079693          	slli	a3,a5,0x30
    80003e7c:	92c1                	srli	a3,a3,0x30
    80003e7e:	4725                	li	a4,9
    80003e80:	02d76863          	bltu	a4,a3,80003eb0 <fileread+0xba>
    80003e84:	0792                	slli	a5,a5,0x4
    80003e86:	00035717          	auipc	a4,0x35
    80003e8a:	a9270713          	addi	a4,a4,-1390 # 80038918 <devsw>
    80003e8e:	97ba                	add	a5,a5,a4
    80003e90:	639c                	ld	a5,0(a5)
    80003e92:	c38d                	beqz	a5,80003eb4 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003e94:	4505                	li	a0,1
    80003e96:	9782                	jalr	a5
    80003e98:	892a                	mv	s2,a0
    80003e9a:	bf75                	j	80003e56 <fileread+0x60>
    panic("fileread");
    80003e9c:	00004517          	auipc	a0,0x4
    80003ea0:	74450513          	addi	a0,a0,1860 # 800085e0 <syscalls+0x258>
    80003ea4:	00002097          	auipc	ra,0x2
    80003ea8:	04a080e7          	jalr	74(ra) # 80005eee <panic>
  if (f->readable == 0) return -1;
    80003eac:	597d                	li	s2,-1
    80003eae:	b765                	j	80003e56 <fileread+0x60>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    80003eb0:	597d                	li	s2,-1
    80003eb2:	b755                	j	80003e56 <fileread+0x60>
    80003eb4:	597d                	li	s2,-1
    80003eb6:	b745                	j	80003e56 <fileread+0x60>

0000000080003eb8 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int filewrite(struct file *f, uint64 addr, int n) {
    80003eb8:	715d                	addi	sp,sp,-80
    80003eba:	e486                	sd	ra,72(sp)
    80003ebc:	e0a2                	sd	s0,64(sp)
    80003ebe:	fc26                	sd	s1,56(sp)
    80003ec0:	f84a                	sd	s2,48(sp)
    80003ec2:	f44e                	sd	s3,40(sp)
    80003ec4:	f052                	sd	s4,32(sp)
    80003ec6:	ec56                	sd	s5,24(sp)
    80003ec8:	e85a                	sd	s6,16(sp)
    80003eca:	e45e                	sd	s7,8(sp)
    80003ecc:	e062                	sd	s8,0(sp)
    80003ece:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if (f->writable == 0) return -1;
    80003ed0:	00954783          	lbu	a5,9(a0)
    80003ed4:	10078663          	beqz	a5,80003fe0 <filewrite+0x128>
    80003ed8:	892a                	mv	s2,a0
    80003eda:	8aae                	mv	s5,a1
    80003edc:	8a32                	mv	s4,a2

  if (f->type == FD_PIPE) {
    80003ede:	411c                	lw	a5,0(a0)
    80003ee0:	4705                	li	a4,1
    80003ee2:	02e78263          	beq	a5,a4,80003f06 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80003ee6:	470d                	li	a4,3
    80003ee8:	02e78663          	beq	a5,a4,80003f14 <filewrite+0x5c>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if (f->type == FD_INODE) {
    80003eec:	4709                	li	a4,2
    80003eee:	0ee79163          	bne	a5,a4,80003fd0 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    int i = 0;
    while (i < n) {
    80003ef2:	0ac05d63          	blez	a2,80003fac <filewrite+0xf4>
    int i = 0;
    80003ef6:	4981                	li	s3,0
    80003ef8:	6b05                	lui	s6,0x1
    80003efa:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003efe:	6b85                	lui	s7,0x1
    80003f00:	c00b8b9b          	addiw	s7,s7,-1024
    80003f04:	a861                	j	80003f9c <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003f06:	6908                	ld	a0,16(a0)
    80003f08:	00000097          	auipc	ra,0x0
    80003f0c:	22e080e7          	jalr	558(ra) # 80004136 <pipewrite>
    80003f10:	8a2a                	mv	s4,a0
    80003f12:	a045                	j	80003fb2 <filewrite+0xfa>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) return -1;
    80003f14:	02451783          	lh	a5,36(a0)
    80003f18:	03079693          	slli	a3,a5,0x30
    80003f1c:	92c1                	srli	a3,a3,0x30
    80003f1e:	4725                	li	a4,9
    80003f20:	0cd76263          	bltu	a4,a3,80003fe4 <filewrite+0x12c>
    80003f24:	0792                	slli	a5,a5,0x4
    80003f26:	00035717          	auipc	a4,0x35
    80003f2a:	9f270713          	addi	a4,a4,-1550 # 80038918 <devsw>
    80003f2e:	97ba                	add	a5,a5,a4
    80003f30:	679c                	ld	a5,8(a5)
    80003f32:	cbdd                	beqz	a5,80003fe8 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003f34:	4505                	li	a0,1
    80003f36:	9782                	jalr	a5
    80003f38:	8a2a                	mv	s4,a0
    80003f3a:	a8a5                	j	80003fb2 <filewrite+0xfa>
    80003f3c:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if (n1 > max) n1 = max;

      begin_op();
    80003f40:	00000097          	auipc	ra,0x0
    80003f44:	8b0080e7          	jalr	-1872(ra) # 800037f0 <begin_op>
      ilock(f->ip);
    80003f48:	01893503          	ld	a0,24(s2)
    80003f4c:	fffff097          	auipc	ra,0xfffff
    80003f50:	ee2080e7          	jalr	-286(ra) # 80002e2e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0) f->off += r;
    80003f54:	8762                	mv	a4,s8
    80003f56:	02092683          	lw	a3,32(s2)
    80003f5a:	01598633          	add	a2,s3,s5
    80003f5e:	4585                	li	a1,1
    80003f60:	01893503          	ld	a0,24(s2)
    80003f64:	fffff097          	auipc	ra,0xfffff
    80003f68:	276080e7          	jalr	630(ra) # 800031da <writei>
    80003f6c:	84aa                	mv	s1,a0
    80003f6e:	00a05763          	blez	a0,80003f7c <filewrite+0xc4>
    80003f72:	02092783          	lw	a5,32(s2)
    80003f76:	9fa9                	addw	a5,a5,a0
    80003f78:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003f7c:	01893503          	ld	a0,24(s2)
    80003f80:	fffff097          	auipc	ra,0xfffff
    80003f84:	f70080e7          	jalr	-144(ra) # 80002ef0 <iunlock>
      end_op();
    80003f88:	00000097          	auipc	ra,0x0
    80003f8c:	8e8080e7          	jalr	-1816(ra) # 80003870 <end_op>

      if (r != n1) {
    80003f90:	009c1f63          	bne	s8,s1,80003fae <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003f94:	013489bb          	addw	s3,s1,s3
    while (i < n) {
    80003f98:	0149db63          	bge	s3,s4,80003fae <filewrite+0xf6>
      int n1 = n - i;
    80003f9c:	413a07bb          	subw	a5,s4,s3
      if (n1 > max) n1 = max;
    80003fa0:	84be                	mv	s1,a5
    80003fa2:	2781                	sext.w	a5,a5
    80003fa4:	f8fb5ce3          	bge	s6,a5,80003f3c <filewrite+0x84>
    80003fa8:	84de                	mv	s1,s7
    80003faa:	bf49                	j	80003f3c <filewrite+0x84>
    int i = 0;
    80003fac:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003fae:	013a1f63          	bne	s4,s3,80003fcc <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003fb2:	8552                	mv	a0,s4
    80003fb4:	60a6                	ld	ra,72(sp)
    80003fb6:	6406                	ld	s0,64(sp)
    80003fb8:	74e2                	ld	s1,56(sp)
    80003fba:	7942                	ld	s2,48(sp)
    80003fbc:	79a2                	ld	s3,40(sp)
    80003fbe:	7a02                	ld	s4,32(sp)
    80003fc0:	6ae2                	ld	s5,24(sp)
    80003fc2:	6b42                	ld	s6,16(sp)
    80003fc4:	6ba2                	ld	s7,8(sp)
    80003fc6:	6c02                	ld	s8,0(sp)
    80003fc8:	6161                	addi	sp,sp,80
    80003fca:	8082                	ret
    ret = (i == n ? n : -1);
    80003fcc:	5a7d                	li	s4,-1
    80003fce:	b7d5                	j	80003fb2 <filewrite+0xfa>
    panic("filewrite");
    80003fd0:	00004517          	auipc	a0,0x4
    80003fd4:	62050513          	addi	a0,a0,1568 # 800085f0 <syscalls+0x268>
    80003fd8:	00002097          	auipc	ra,0x2
    80003fdc:	f16080e7          	jalr	-234(ra) # 80005eee <panic>
  if (f->writable == 0) return -1;
    80003fe0:	5a7d                	li	s4,-1
    80003fe2:	bfc1                	j	80003fb2 <filewrite+0xfa>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) return -1;
    80003fe4:	5a7d                	li	s4,-1
    80003fe6:	b7f1                	j	80003fb2 <filewrite+0xfa>
    80003fe8:	5a7d                	li	s4,-1
    80003fea:	b7e1                	j	80003fb2 <filewrite+0xfa>

0000000080003fec <pipealloc>:
  uint nwrite;    // number of bytes written
  int readopen;   // read fd is still open
  int writeopen;  // write fd is still open
};

int pipealloc(struct file **f0, struct file **f1) {
    80003fec:	7179                	addi	sp,sp,-48
    80003fee:	f406                	sd	ra,40(sp)
    80003ff0:	f022                	sd	s0,32(sp)
    80003ff2:	ec26                	sd	s1,24(sp)
    80003ff4:	e84a                	sd	s2,16(sp)
    80003ff6:	e44e                	sd	s3,8(sp)
    80003ff8:	e052                	sd	s4,0(sp)
    80003ffa:	1800                	addi	s0,sp,48
    80003ffc:	84aa                	mv	s1,a0
    80003ffe:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004000:	0005b023          	sd	zero,0(a1)
    80004004:	00053023          	sd	zero,0(a0)
  if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0) goto bad;
    80004008:	00000097          	auipc	ra,0x0
    8000400c:	bf8080e7          	jalr	-1032(ra) # 80003c00 <filealloc>
    80004010:	e088                	sd	a0,0(s1)
    80004012:	c551                	beqz	a0,8000409e <pipealloc+0xb2>
    80004014:	00000097          	auipc	ra,0x0
    80004018:	bec080e7          	jalr	-1044(ra) # 80003c00 <filealloc>
    8000401c:	00aa3023          	sd	a0,0(s4)
    80004020:	c92d                	beqz	a0,80004092 <pipealloc+0xa6>
  if ((pi = (struct pipe *)kalloc()) == 0) goto bad;
    80004022:	ffffc097          	auipc	ra,0xffffc
    80004026:	20a080e7          	jalr	522(ra) # 8000022c <kalloc>
    8000402a:	892a                	mv	s2,a0
    8000402c:	c125                	beqz	a0,8000408c <pipealloc+0xa0>
  pi->readopen = 1;
    8000402e:	4985                	li	s3,1
    80004030:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004034:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004038:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000403c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004040:	00004597          	auipc	a1,0x4
    80004044:	5c058593          	addi	a1,a1,1472 # 80008600 <syscalls+0x278>
    80004048:	00002097          	auipc	ra,0x2
    8000404c:	352080e7          	jalr	850(ra) # 8000639a <initlock>
  (*f0)->type = FD_PIPE;
    80004050:	609c                	ld	a5,0(s1)
    80004052:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004056:	609c                	ld	a5,0(s1)
    80004058:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000405c:	609c                	ld	a5,0(s1)
    8000405e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004062:	609c                	ld	a5,0(s1)
    80004064:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004068:	000a3783          	ld	a5,0(s4)
    8000406c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004070:	000a3783          	ld	a5,0(s4)
    80004074:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004078:	000a3783          	ld	a5,0(s4)
    8000407c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004080:	000a3783          	ld	a5,0(s4)
    80004084:	0127b823          	sd	s2,16(a5)
  return 0;
    80004088:	4501                	li	a0,0
    8000408a:	a025                	j	800040b2 <pipealloc+0xc6>

bad:
  if (pi) kfree((char *)pi);
  if (*f0) fileclose(*f0);
    8000408c:	6088                	ld	a0,0(s1)
    8000408e:	e501                	bnez	a0,80004096 <pipealloc+0xaa>
    80004090:	a039                	j	8000409e <pipealloc+0xb2>
    80004092:	6088                	ld	a0,0(s1)
    80004094:	c51d                	beqz	a0,800040c2 <pipealloc+0xd6>
    80004096:	00000097          	auipc	ra,0x0
    8000409a:	c26080e7          	jalr	-986(ra) # 80003cbc <fileclose>
  if (*f1) fileclose(*f1);
    8000409e:	000a3783          	ld	a5,0(s4)
  return -1;
    800040a2:	557d                	li	a0,-1
  if (*f1) fileclose(*f1);
    800040a4:	c799                	beqz	a5,800040b2 <pipealloc+0xc6>
    800040a6:	853e                	mv	a0,a5
    800040a8:	00000097          	auipc	ra,0x0
    800040ac:	c14080e7          	jalr	-1004(ra) # 80003cbc <fileclose>
  return -1;
    800040b0:	557d                	li	a0,-1
}
    800040b2:	70a2                	ld	ra,40(sp)
    800040b4:	7402                	ld	s0,32(sp)
    800040b6:	64e2                	ld	s1,24(sp)
    800040b8:	6942                	ld	s2,16(sp)
    800040ba:	69a2                	ld	s3,8(sp)
    800040bc:	6a02                	ld	s4,0(sp)
    800040be:	6145                	addi	sp,sp,48
    800040c0:	8082                	ret
  return -1;
    800040c2:	557d                	li	a0,-1
    800040c4:	b7fd                	j	800040b2 <pipealloc+0xc6>

00000000800040c6 <pipeclose>:

void pipeclose(struct pipe *pi, int writable) {
    800040c6:	1101                	addi	sp,sp,-32
    800040c8:	ec06                	sd	ra,24(sp)
    800040ca:	e822                	sd	s0,16(sp)
    800040cc:	e426                	sd	s1,8(sp)
    800040ce:	e04a                	sd	s2,0(sp)
    800040d0:	1000                	addi	s0,sp,32
    800040d2:	84aa                	mv	s1,a0
    800040d4:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800040d6:	00002097          	auipc	ra,0x2
    800040da:	354080e7          	jalr	852(ra) # 8000642a <acquire>
  if (writable) {
    800040de:	02090d63          	beqz	s2,80004118 <pipeclose+0x52>
    pi->writeopen = 0;
    800040e2:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800040e6:	21848513          	addi	a0,s1,536
    800040ea:	ffffd097          	auipc	ra,0xffffd
    800040ee:	78a080e7          	jalr	1930(ra) # 80001874 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if (pi->readopen == 0 && pi->writeopen == 0) {
    800040f2:	2204b783          	ld	a5,544(s1)
    800040f6:	eb95                	bnez	a5,8000412a <pipeclose+0x64>
    release(&pi->lock);
    800040f8:	8526                	mv	a0,s1
    800040fa:	00002097          	auipc	ra,0x2
    800040fe:	3e4080e7          	jalr	996(ra) # 800064de <release>
    kfree((char *)pi);
    80004102:	8526                	mv	a0,s1
    80004104:	ffffc097          	auipc	ra,0xffffc
    80004108:	020080e7          	jalr	32(ra) # 80000124 <kfree>
  } else
    release(&pi->lock);
}
    8000410c:	60e2                	ld	ra,24(sp)
    8000410e:	6442                	ld	s0,16(sp)
    80004110:	64a2                	ld	s1,8(sp)
    80004112:	6902                	ld	s2,0(sp)
    80004114:	6105                	addi	sp,sp,32
    80004116:	8082                	ret
    pi->readopen = 0;
    80004118:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000411c:	21c48513          	addi	a0,s1,540
    80004120:	ffffd097          	auipc	ra,0xffffd
    80004124:	754080e7          	jalr	1876(ra) # 80001874 <wakeup>
    80004128:	b7e9                	j	800040f2 <pipeclose+0x2c>
    release(&pi->lock);
    8000412a:	8526                	mv	a0,s1
    8000412c:	00002097          	auipc	ra,0x2
    80004130:	3b2080e7          	jalr	946(ra) # 800064de <release>
}
    80004134:	bfe1                	j	8000410c <pipeclose+0x46>

0000000080004136 <pipewrite>:

int pipewrite(struct pipe *pi, uint64 addr, int n) {
    80004136:	711d                	addi	sp,sp,-96
    80004138:	ec86                	sd	ra,88(sp)
    8000413a:	e8a2                	sd	s0,80(sp)
    8000413c:	e4a6                	sd	s1,72(sp)
    8000413e:	e0ca                	sd	s2,64(sp)
    80004140:	fc4e                	sd	s3,56(sp)
    80004142:	f852                	sd	s4,48(sp)
    80004144:	f456                	sd	s5,40(sp)
    80004146:	f05a                	sd	s6,32(sp)
    80004148:	ec5e                	sd	s7,24(sp)
    8000414a:	e862                	sd	s8,16(sp)
    8000414c:	1080                	addi	s0,sp,96
    8000414e:	84aa                	mv	s1,a0
    80004150:	8aae                	mv	s5,a1
    80004152:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004154:	ffffd097          	auipc	ra,0xffffd
    80004158:	010080e7          	jalr	16(ra) # 80001164 <myproc>
    8000415c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000415e:	8526                	mv	a0,s1
    80004160:	00002097          	auipc	ra,0x2
    80004164:	2ca080e7          	jalr	714(ra) # 8000642a <acquire>
  while (i < n) {
    80004168:	0b405663          	blez	s4,80004214 <pipewrite+0xde>
  int i = 0;
    8000416c:	4901                	li	s2,0
    if (pi->nwrite == pi->nread + PIPESIZE) {  // DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1) break;
    8000416e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004170:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004174:	21c48b93          	addi	s7,s1,540
    80004178:	a089                	j	800041ba <pipewrite+0x84>
      release(&pi->lock);
    8000417a:	8526                	mv	a0,s1
    8000417c:	00002097          	auipc	ra,0x2
    80004180:	362080e7          	jalr	866(ra) # 800064de <release>
      return -1;
    80004184:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004186:	854a                	mv	a0,s2
    80004188:	60e6                	ld	ra,88(sp)
    8000418a:	6446                	ld	s0,80(sp)
    8000418c:	64a6                	ld	s1,72(sp)
    8000418e:	6906                	ld	s2,64(sp)
    80004190:	79e2                	ld	s3,56(sp)
    80004192:	7a42                	ld	s4,48(sp)
    80004194:	7aa2                	ld	s5,40(sp)
    80004196:	7b02                	ld	s6,32(sp)
    80004198:	6be2                	ld	s7,24(sp)
    8000419a:	6c42                	ld	s8,16(sp)
    8000419c:	6125                	addi	sp,sp,96
    8000419e:	8082                	ret
      wakeup(&pi->nread);
    800041a0:	8562                	mv	a0,s8
    800041a2:	ffffd097          	auipc	ra,0xffffd
    800041a6:	6d2080e7          	jalr	1746(ra) # 80001874 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800041aa:	85a6                	mv	a1,s1
    800041ac:	855e                	mv	a0,s7
    800041ae:	ffffd097          	auipc	ra,0xffffd
    800041b2:	662080e7          	jalr	1634(ra) # 80001810 <sleep>
  while (i < n) {
    800041b6:	07495063          	bge	s2,s4,80004216 <pipewrite+0xe0>
    if (pi->readopen == 0 || killed(pr)) {
    800041ba:	2204a783          	lw	a5,544(s1)
    800041be:	dfd5                	beqz	a5,8000417a <pipewrite+0x44>
    800041c0:	854e                	mv	a0,s3
    800041c2:	ffffe097          	auipc	ra,0xffffe
    800041c6:	8f6080e7          	jalr	-1802(ra) # 80001ab8 <killed>
    800041ca:	f945                	bnez	a0,8000417a <pipewrite+0x44>
    if (pi->nwrite == pi->nread + PIPESIZE) {  // DOC: pipewrite-full
    800041cc:	2184a783          	lw	a5,536(s1)
    800041d0:	21c4a703          	lw	a4,540(s1)
    800041d4:	2007879b          	addiw	a5,a5,512
    800041d8:	fcf704e3          	beq	a4,a5,800041a0 <pipewrite+0x6a>
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1) break;
    800041dc:	4685                	li	a3,1
    800041de:	01590633          	add	a2,s2,s5
    800041e2:	faf40593          	addi	a1,s0,-81
    800041e6:	0509b503          	ld	a0,80(s3)
    800041ea:	ffffd097          	auipc	ra,0xffffd
    800041ee:	bde080e7          	jalr	-1058(ra) # 80000dc8 <copyin>
    800041f2:	03650263          	beq	a0,s6,80004216 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800041f6:	21c4a783          	lw	a5,540(s1)
    800041fa:	0017871b          	addiw	a4,a5,1
    800041fe:	20e4ae23          	sw	a4,540(s1)
    80004202:	1ff7f793          	andi	a5,a5,511
    80004206:	97a6                	add	a5,a5,s1
    80004208:	faf44703          	lbu	a4,-81(s0)
    8000420c:	00e78c23          	sb	a4,24(a5)
      i++;
    80004210:	2905                	addiw	s2,s2,1
    80004212:	b755                	j	800041b6 <pipewrite+0x80>
  int i = 0;
    80004214:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004216:	21848513          	addi	a0,s1,536
    8000421a:	ffffd097          	auipc	ra,0xffffd
    8000421e:	65a080e7          	jalr	1626(ra) # 80001874 <wakeup>
  release(&pi->lock);
    80004222:	8526                	mv	a0,s1
    80004224:	00002097          	auipc	ra,0x2
    80004228:	2ba080e7          	jalr	698(ra) # 800064de <release>
  return i;
    8000422c:	bfa9                	j	80004186 <pipewrite+0x50>

000000008000422e <piperead>:

int piperead(struct pipe *pi, uint64 addr, int n) {
    8000422e:	715d                	addi	sp,sp,-80
    80004230:	e486                	sd	ra,72(sp)
    80004232:	e0a2                	sd	s0,64(sp)
    80004234:	fc26                	sd	s1,56(sp)
    80004236:	f84a                	sd	s2,48(sp)
    80004238:	f44e                	sd	s3,40(sp)
    8000423a:	f052                	sd	s4,32(sp)
    8000423c:	ec56                	sd	s5,24(sp)
    8000423e:	e85a                	sd	s6,16(sp)
    80004240:	0880                	addi	s0,sp,80
    80004242:	84aa                	mv	s1,a0
    80004244:	892e                	mv	s2,a1
    80004246:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004248:	ffffd097          	auipc	ra,0xffffd
    8000424c:	f1c080e7          	jalr	-228(ra) # 80001164 <myproc>
    80004250:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004252:	8526                	mv	a0,s1
    80004254:	00002097          	auipc	ra,0x2
    80004258:	1d6080e7          	jalr	470(ra) # 8000642a <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    8000425c:	2184a703          	lw	a4,536(s1)
    80004260:	21c4a783          	lw	a5,540(s1)
    if (killed(pr)) {
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock);  // DOC: piperead-sleep
    80004264:	21848993          	addi	s3,s1,536
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    80004268:	02f71763          	bne	a4,a5,80004296 <piperead+0x68>
    8000426c:	2244a783          	lw	a5,548(s1)
    80004270:	c39d                	beqz	a5,80004296 <piperead+0x68>
    if (killed(pr)) {
    80004272:	8552                	mv	a0,s4
    80004274:	ffffe097          	auipc	ra,0xffffe
    80004278:	844080e7          	jalr	-1980(ra) # 80001ab8 <killed>
    8000427c:	e941                	bnez	a0,8000430c <piperead+0xde>
    sleep(&pi->nread, &pi->lock);  // DOC: piperead-sleep
    8000427e:	85a6                	mv	a1,s1
    80004280:	854e                	mv	a0,s3
    80004282:	ffffd097          	auipc	ra,0xffffd
    80004286:	58e080e7          	jalr	1422(ra) # 80001810 <sleep>
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    8000428a:	2184a703          	lw	a4,536(s1)
    8000428e:	21c4a783          	lw	a5,540(s1)
    80004292:	fcf70de3          	beq	a4,a5,8000426c <piperead+0x3e>
  }
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    80004296:	4981                	li	s3,0
    if (pi->nread == pi->nwrite) break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1) break;
    80004298:	5b7d                	li	s6,-1
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    8000429a:	05505363          	blez	s5,800042e0 <piperead+0xb2>
    if (pi->nread == pi->nwrite) break;
    8000429e:	2184a783          	lw	a5,536(s1)
    800042a2:	21c4a703          	lw	a4,540(s1)
    800042a6:	02f70d63          	beq	a4,a5,800042e0 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800042aa:	0017871b          	addiw	a4,a5,1
    800042ae:	20e4ac23          	sw	a4,536(s1)
    800042b2:	1ff7f793          	andi	a5,a5,511
    800042b6:	97a6                	add	a5,a5,s1
    800042b8:	0187c783          	lbu	a5,24(a5)
    800042bc:	faf40fa3          	sb	a5,-65(s0)
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1) break;
    800042c0:	4685                	li	a3,1
    800042c2:	fbf40613          	addi	a2,s0,-65
    800042c6:	85ca                	mv	a1,s2
    800042c8:	050a3503          	ld	a0,80(s4)
    800042cc:	ffffd097          	auipc	ra,0xffffd
    800042d0:	9e0080e7          	jalr	-1568(ra) # 80000cac <copyout>
    800042d4:	01650663          	beq	a0,s6,800042e0 <piperead+0xb2>
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    800042d8:	2985                	addiw	s3,s3,1
    800042da:	0905                	addi	s2,s2,1
    800042dc:	fd3a91e3          	bne	s5,s3,8000429e <piperead+0x70>
  }
  wakeup(&pi->nwrite);  // DOC: piperead-wakeup
    800042e0:	21c48513          	addi	a0,s1,540
    800042e4:	ffffd097          	auipc	ra,0xffffd
    800042e8:	590080e7          	jalr	1424(ra) # 80001874 <wakeup>
  release(&pi->lock);
    800042ec:	8526                	mv	a0,s1
    800042ee:	00002097          	auipc	ra,0x2
    800042f2:	1f0080e7          	jalr	496(ra) # 800064de <release>
  return i;
}
    800042f6:	854e                	mv	a0,s3
    800042f8:	60a6                	ld	ra,72(sp)
    800042fa:	6406                	ld	s0,64(sp)
    800042fc:	74e2                	ld	s1,56(sp)
    800042fe:	7942                	ld	s2,48(sp)
    80004300:	79a2                	ld	s3,40(sp)
    80004302:	7a02                	ld	s4,32(sp)
    80004304:	6ae2                	ld	s5,24(sp)
    80004306:	6b42                	ld	s6,16(sp)
    80004308:	6161                	addi	sp,sp,80
    8000430a:	8082                	ret
      release(&pi->lock);
    8000430c:	8526                	mv	a0,s1
    8000430e:	00002097          	auipc	ra,0x2
    80004312:	1d0080e7          	jalr	464(ra) # 800064de <release>
      return -1;
    80004316:	59fd                	li	s3,-1
    80004318:	bff9                	j	800042f6 <piperead+0xc8>

000000008000431a <flags2perm>:
#include "riscv.h"
#include "types.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags) {
    8000431a:	1141                	addi	sp,sp,-16
    8000431c:	e422                	sd	s0,8(sp)
    8000431e:	0800                	addi	s0,sp,16
    80004320:	87aa                	mv	a5,a0
  int perm = 0;
  if (flags & 0x1) perm = PTE_X;
    80004322:	8905                	andi	a0,a0,1
    80004324:	c111                	beqz	a0,80004328 <flags2perm+0xe>
    80004326:	4521                	li	a0,8
  if (flags & 0x2) perm |= PTE_W;
    80004328:	8b89                	andi	a5,a5,2
    8000432a:	c399                	beqz	a5,80004330 <flags2perm+0x16>
    8000432c:	00456513          	ori	a0,a0,4
  return perm;
}
    80004330:	6422                	ld	s0,8(sp)
    80004332:	0141                	addi	sp,sp,16
    80004334:	8082                	ret

0000000080004336 <exec>:

int exec(char *path, char **argv) {
    80004336:	de010113          	addi	sp,sp,-544
    8000433a:	20113c23          	sd	ra,536(sp)
    8000433e:	20813823          	sd	s0,528(sp)
    80004342:	20913423          	sd	s1,520(sp)
    80004346:	21213023          	sd	s2,512(sp)
    8000434a:	ffce                	sd	s3,504(sp)
    8000434c:	fbd2                	sd	s4,496(sp)
    8000434e:	f7d6                	sd	s5,488(sp)
    80004350:	f3da                	sd	s6,480(sp)
    80004352:	efde                	sd	s7,472(sp)
    80004354:	ebe2                	sd	s8,464(sp)
    80004356:	e7e6                	sd	s9,456(sp)
    80004358:	e3ea                	sd	s10,448(sp)
    8000435a:	ff6e                	sd	s11,440(sp)
    8000435c:	1400                	addi	s0,sp,544
    8000435e:	892a                	mv	s2,a0
    80004360:	dea43423          	sd	a0,-536(s0)
    80004364:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004368:	ffffd097          	auipc	ra,0xffffd
    8000436c:	dfc080e7          	jalr	-516(ra) # 80001164 <myproc>
    80004370:	84aa                	mv	s1,a0

  begin_op();
    80004372:	fffff097          	auipc	ra,0xfffff
    80004376:	47e080e7          	jalr	1150(ra) # 800037f0 <begin_op>

  if ((ip = namei(path)) == 0) {
    8000437a:	854a                	mv	a0,s2
    8000437c:	fffff097          	auipc	ra,0xfffff
    80004380:	258080e7          	jalr	600(ra) # 800035d4 <namei>
    80004384:	c93d                	beqz	a0,800043fa <exec+0xc4>
    80004386:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004388:	fffff097          	auipc	ra,0xfffff
    8000438c:	aa6080e7          	jalr	-1370(ra) # 80002e2e <ilock>

  // Check ELF header
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf)) goto bad;
    80004390:	04000713          	li	a4,64
    80004394:	4681                	li	a3,0
    80004396:	e5040613          	addi	a2,s0,-432
    8000439a:	4581                	li	a1,0
    8000439c:	8556                	mv	a0,s5
    8000439e:	fffff097          	auipc	ra,0xfffff
    800043a2:	d44080e7          	jalr	-700(ra) # 800030e2 <readi>
    800043a6:	04000793          	li	a5,64
    800043aa:	00f51a63          	bne	a0,a5,800043be <exec+0x88>

  if (elf.magic != ELF_MAGIC) goto bad;
    800043ae:	e5042703          	lw	a4,-432(s0)
    800043b2:	464c47b7          	lui	a5,0x464c4
    800043b6:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800043ba:	04f70663          	beq	a4,a5,80004406 <exec+0xd0>
  return argc;  // this ends up in a0, the first argument to main(argc, argv)

bad:
  if (pagetable) proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    800043be:	8556                	mv	a0,s5
    800043c0:	fffff097          	auipc	ra,0xfffff
    800043c4:	cd0080e7          	jalr	-816(ra) # 80003090 <iunlockput>
    end_op();
    800043c8:	fffff097          	auipc	ra,0xfffff
    800043cc:	4a8080e7          	jalr	1192(ra) # 80003870 <end_op>
  }
  return -1;
    800043d0:	557d                	li	a0,-1
}
    800043d2:	21813083          	ld	ra,536(sp)
    800043d6:	21013403          	ld	s0,528(sp)
    800043da:	20813483          	ld	s1,520(sp)
    800043de:	20013903          	ld	s2,512(sp)
    800043e2:	79fe                	ld	s3,504(sp)
    800043e4:	7a5e                	ld	s4,496(sp)
    800043e6:	7abe                	ld	s5,488(sp)
    800043e8:	7b1e                	ld	s6,480(sp)
    800043ea:	6bfe                	ld	s7,472(sp)
    800043ec:	6c5e                	ld	s8,464(sp)
    800043ee:	6cbe                	ld	s9,456(sp)
    800043f0:	6d1e                	ld	s10,448(sp)
    800043f2:	7dfa                	ld	s11,440(sp)
    800043f4:	22010113          	addi	sp,sp,544
    800043f8:	8082                	ret
    end_op();
    800043fa:	fffff097          	auipc	ra,0xfffff
    800043fe:	476080e7          	jalr	1142(ra) # 80003870 <end_op>
    return -1;
    80004402:	557d                	li	a0,-1
    80004404:	b7f9                	j	800043d2 <exec+0x9c>
  if ((pagetable = proc_pagetable(p)) == 0) goto bad;
    80004406:	8526                	mv	a0,s1
    80004408:	ffffd097          	auipc	ra,0xffffd
    8000440c:	e24080e7          	jalr	-476(ra) # 8000122c <proc_pagetable>
    80004410:	8b2a                	mv	s6,a0
    80004412:	d555                	beqz	a0,800043be <exec+0x88>
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004414:	e7042783          	lw	a5,-400(s0)
    80004418:	e8845703          	lhu	a4,-376(s0)
    8000441c:	c735                	beqz	a4,80004488 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000441e:	4901                	li	s2,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004420:	e0043423          	sd	zero,-504(s0)
    if (ph.vaddr % PGSIZE != 0) goto bad;
    80004424:	6a05                	lui	s4,0x1
    80004426:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    8000442a:	dee43023          	sd	a4,-544(s0)
static int loadseg(pagetable_t pagetable, uint64 va, struct inode *ip,
                   uint offset, uint sz) {
  uint i, n;
  uint64 pa;

  for (i = 0; i < sz; i += PGSIZE) {
    8000442e:	6d85                	lui	s11,0x1
    80004430:	7d7d                	lui	s10,0xfffff
    80004432:	aca9                	j	8000468c <exec+0x356>
    pa = walkaddr(pagetable, va + i);
    if (pa == 0) panic("loadseg: address should exist");
    80004434:	00004517          	auipc	a0,0x4
    80004438:	1d450513          	addi	a0,a0,468 # 80008608 <syscalls+0x280>
    8000443c:	00002097          	auipc	ra,0x2
    80004440:	ab2080e7          	jalr	-1358(ra) # 80005eee <panic>
    if (sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n) return -1;
    80004444:	874a                	mv	a4,s2
    80004446:	009c86bb          	addw	a3,s9,s1
    8000444a:	4581                	li	a1,0
    8000444c:	8556                	mv	a0,s5
    8000444e:	fffff097          	auipc	ra,0xfffff
    80004452:	c94080e7          	jalr	-876(ra) # 800030e2 <readi>
    80004456:	2501                	sext.w	a0,a0
    80004458:	1ca91763          	bne	s2,a0,80004626 <exec+0x2f0>
  for (i = 0; i < sz; i += PGSIZE) {
    8000445c:	009d84bb          	addw	s1,s11,s1
    80004460:	013d09bb          	addw	s3,s10,s3
    80004464:	2174f463          	bgeu	s1,s7,8000466c <exec+0x336>
    pa = walkaddr(pagetable, va + i);
    80004468:	02049593          	slli	a1,s1,0x20
    8000446c:	9181                	srli	a1,a1,0x20
    8000446e:	95e2                	add	a1,a1,s8
    80004470:	855a                	mv	a0,s6
    80004472:	ffffc097          	auipc	ra,0xffffc
    80004476:	1ba080e7          	jalr	442(ra) # 8000062c <walkaddr>
    8000447a:	862a                	mv	a2,a0
    if (pa == 0) panic("loadseg: address should exist");
    8000447c:	dd45                	beqz	a0,80004434 <exec+0xfe>
      n = PGSIZE;
    8000447e:	8952                	mv	s2,s4
    if (sz - i < PGSIZE)
    80004480:	fd49f2e3          	bgeu	s3,s4,80004444 <exec+0x10e>
      n = sz - i;
    80004484:	894e                	mv	s2,s3
    80004486:	bf7d                	j	80004444 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004488:	4901                	li	s2,0
  iunlockput(ip);
    8000448a:	8556                	mv	a0,s5
    8000448c:	fffff097          	auipc	ra,0xfffff
    80004490:	c04080e7          	jalr	-1020(ra) # 80003090 <iunlockput>
  end_op();
    80004494:	fffff097          	auipc	ra,0xfffff
    80004498:	3dc080e7          	jalr	988(ra) # 80003870 <end_op>
  p = myproc();
    8000449c:	ffffd097          	auipc	ra,0xffffd
    800044a0:	cc8080e7          	jalr	-824(ra) # 80001164 <myproc>
    800044a4:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800044a6:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800044aa:	6785                	lui	a5,0x1
    800044ac:	17fd                	addi	a5,a5,-1
    800044ae:	993e                	add	s2,s2,a5
    800044b0:	77fd                	lui	a5,0xfffff
    800044b2:	00f977b3          	and	a5,s2,a5
    800044b6:	def43c23          	sd	a5,-520(s0)
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE, PTE_W)) == 0) goto bad;
    800044ba:	4691                	li	a3,4
    800044bc:	6609                	lui	a2,0x2
    800044be:	963e                	add	a2,a2,a5
    800044c0:	85be                	mv	a1,a5
    800044c2:	855a                	mv	a0,s6
    800044c4:	ffffc097          	auipc	ra,0xffffc
    800044c8:	4e4080e7          	jalr	1252(ra) # 800009a8 <uvmalloc>
    800044cc:	8c2a                	mv	s8,a0
  ip = 0;
    800044ce:	4a81                	li	s5,0
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE, PTE_W)) == 0) goto bad;
    800044d0:	14050b63          	beqz	a0,80004626 <exec+0x2f0>
  uvmclear(pagetable, sz - 2 * PGSIZE);
    800044d4:	75f9                	lui	a1,0xffffe
    800044d6:	95aa                	add	a1,a1,a0
    800044d8:	855a                	mv	a0,s6
    800044da:	ffffc097          	auipc	ra,0xffffc
    800044de:	7a0080e7          	jalr	1952(ra) # 80000c7a <uvmclear>
  stackbase = sp - PGSIZE;
    800044e2:	7afd                	lui	s5,0xfffff
    800044e4:	9ae2                	add	s5,s5,s8
  for (argc = 0; argv[argc]; argc++) {
    800044e6:	df043783          	ld	a5,-528(s0)
    800044ea:	6388                	ld	a0,0(a5)
    800044ec:	c925                	beqz	a0,8000455c <exec+0x226>
    800044ee:	e9040993          	addi	s3,s0,-368
    800044f2:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800044f6:	8962                	mv	s2,s8
  for (argc = 0; argv[argc]; argc++) {
    800044f8:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800044fa:	ffffc097          	auipc	ra,0xffffc
    800044fe:	f24080e7          	jalr	-220(ra) # 8000041e <strlen>
    80004502:	0015079b          	addiw	a5,a0,1
    80004506:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16;  // riscv sp must be 16-byte aligned
    8000450a:	ff097913          	andi	s2,s2,-16
    if (sp < stackbase) goto bad;
    8000450e:	15596363          	bltu	s2,s5,80004654 <exec+0x31e>
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004512:	df043d83          	ld	s11,-528(s0)
    80004516:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    8000451a:	8552                	mv	a0,s4
    8000451c:	ffffc097          	auipc	ra,0xffffc
    80004520:	f02080e7          	jalr	-254(ra) # 8000041e <strlen>
    80004524:	0015069b          	addiw	a3,a0,1
    80004528:	8652                	mv	a2,s4
    8000452a:	85ca                	mv	a1,s2
    8000452c:	855a                	mv	a0,s6
    8000452e:	ffffc097          	auipc	ra,0xffffc
    80004532:	77e080e7          	jalr	1918(ra) # 80000cac <copyout>
    80004536:	12054363          	bltz	a0,8000465c <exec+0x326>
    ustack[argc] = sp;
    8000453a:	0129b023          	sd	s2,0(s3)
  for (argc = 0; argv[argc]; argc++) {
    8000453e:	0485                	addi	s1,s1,1
    80004540:	008d8793          	addi	a5,s11,8
    80004544:	def43823          	sd	a5,-528(s0)
    80004548:	008db503          	ld	a0,8(s11)
    8000454c:	c911                	beqz	a0,80004560 <exec+0x22a>
    if (argc >= MAXARG) goto bad;
    8000454e:	09a1                	addi	s3,s3,8
    80004550:	fb3c95e3          	bne	s9,s3,800044fa <exec+0x1c4>
  sz = sz1;
    80004554:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004558:	4a81                	li	s5,0
    8000455a:	a0f1                	j	80004626 <exec+0x2f0>
  sp = sz;
    8000455c:	8962                	mv	s2,s8
  for (argc = 0; argv[argc]; argc++) {
    8000455e:	4481                	li	s1,0
  ustack[argc] = 0;
    80004560:	00349793          	slli	a5,s1,0x3
    80004564:	f9040713          	addi	a4,s0,-112
    80004568:	97ba                	add	a5,a5,a4
    8000456a:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffbd210>
  sp -= (argc + 1) * sizeof(uint64);
    8000456e:	00148693          	addi	a3,s1,1
    80004572:	068e                	slli	a3,a3,0x3
    80004574:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004578:	ff097913          	andi	s2,s2,-16
  if (sp < stackbase) goto bad;
    8000457c:	01597663          	bgeu	s2,s5,80004588 <exec+0x252>
  sz = sz1;
    80004580:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004584:	4a81                	li	s5,0
    80004586:	a045                	j	80004626 <exec+0x2f0>
  if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    80004588:	e9040613          	addi	a2,s0,-368
    8000458c:	85ca                	mv	a1,s2
    8000458e:	855a                	mv	a0,s6
    80004590:	ffffc097          	auipc	ra,0xffffc
    80004594:	71c080e7          	jalr	1820(ra) # 80000cac <copyout>
    80004598:	0c054663          	bltz	a0,80004664 <exec+0x32e>
  p->trapframe->a1 = sp;
    8000459c:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    800045a0:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    800045a4:	de843783          	ld	a5,-536(s0)
    800045a8:	0007c703          	lbu	a4,0(a5)
    800045ac:	cf11                	beqz	a4,800045c8 <exec+0x292>
    800045ae:	0785                	addi	a5,a5,1
    if (*s == '/') last = s + 1;
    800045b0:	02f00693          	li	a3,47
    800045b4:	a039                	j	800045c2 <exec+0x28c>
    800045b6:	def43423          	sd	a5,-536(s0)
  for (last = s = path; *s; s++)
    800045ba:	0785                	addi	a5,a5,1
    800045bc:	fff7c703          	lbu	a4,-1(a5)
    800045c0:	c701                	beqz	a4,800045c8 <exec+0x292>
    if (*s == '/') last = s + 1;
    800045c2:	fed71ce3          	bne	a4,a3,800045ba <exec+0x284>
    800045c6:	bfc5                	j	800045b6 <exec+0x280>
  safestrcpy(p->name, last, sizeof(p->name));
    800045c8:	4641                	li	a2,16
    800045ca:	de843583          	ld	a1,-536(s0)
    800045ce:	158b8513          	addi	a0,s7,344
    800045d2:	ffffc097          	auipc	ra,0xffffc
    800045d6:	e1a080e7          	jalr	-486(ra) # 800003ec <safestrcpy>
  oldpagetable = p->pagetable;
    800045da:	050bb983          	ld	s3,80(s7)
  p->pagetable = pagetable;
    800045de:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    800045e2:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800045e6:	058bb783          	ld	a5,88(s7)
    800045ea:	e6843703          	ld	a4,-408(s0)
    800045ee:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;          // initial stack pointer
    800045f0:	058bb783          	ld	a5,88(s7)
    800045f4:	0327b823          	sd	s2,48(a5)
  if (p->pid == 1) {
    800045f8:	030ba703          	lw	a4,48(s7)
    800045fc:	4785                	li	a5,1
    800045fe:	00f70b63          	beq	a4,a5,80004614 <exec+0x2de>
  proc_freepagetable(oldpagetable, oldsz);
    80004602:	85ea                	mv	a1,s10
    80004604:	854e                	mv	a0,s3
    80004606:	ffffd097          	auipc	ra,0xffffd
    8000460a:	cc2080e7          	jalr	-830(ra) # 800012c8 <proc_freepagetable>
  return argc;  // this ends up in a0, the first argument to main(argc, argv)
    8000460e:	0004851b          	sext.w	a0,s1
    80004612:	b3c1                	j	800043d2 <exec+0x9c>
    vmprint(p->pagetable);
    80004614:	050bb503          	ld	a0,80(s7)
    80004618:	ffffd097          	auipc	ra,0xffffd
    8000461c:	9a2080e7          	jalr	-1630(ra) # 80000fba <vmprint>
    80004620:	b7cd                	j	80004602 <exec+0x2cc>
    80004622:	df243c23          	sd	s2,-520(s0)
  if (pagetable) proc_freepagetable(pagetable, sz);
    80004626:	df843583          	ld	a1,-520(s0)
    8000462a:	855a                	mv	a0,s6
    8000462c:	ffffd097          	auipc	ra,0xffffd
    80004630:	c9c080e7          	jalr	-868(ra) # 800012c8 <proc_freepagetable>
  if (ip) {
    80004634:	d80a95e3          	bnez	s5,800043be <exec+0x88>
  return -1;
    80004638:	557d                	li	a0,-1
    8000463a:	bb61                	j	800043d2 <exec+0x9c>
    8000463c:	df243c23          	sd	s2,-520(s0)
    80004640:	b7dd                	j	80004626 <exec+0x2f0>
    80004642:	df243c23          	sd	s2,-520(s0)
    80004646:	b7c5                	j	80004626 <exec+0x2f0>
    80004648:	df243c23          	sd	s2,-520(s0)
    8000464c:	bfe9                	j	80004626 <exec+0x2f0>
    8000464e:	df243c23          	sd	s2,-520(s0)
    80004652:	bfd1                	j	80004626 <exec+0x2f0>
  sz = sz1;
    80004654:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004658:	4a81                	li	s5,0
    8000465a:	b7f1                	j	80004626 <exec+0x2f0>
  sz = sz1;
    8000465c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004660:	4a81                	li	s5,0
    80004662:	b7d1                	j	80004626 <exec+0x2f0>
  sz = sz1;
    80004664:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004668:	4a81                	li	s5,0
    8000466a:	bf75                	j	80004626 <exec+0x2f0>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    8000466c:	df843903          	ld	s2,-520(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004670:	e0843783          	ld	a5,-504(s0)
    80004674:	0017869b          	addiw	a3,a5,1
    80004678:	e0d43423          	sd	a3,-504(s0)
    8000467c:	e0043783          	ld	a5,-512(s0)
    80004680:	0387879b          	addiw	a5,a5,56
    80004684:	e8845703          	lhu	a4,-376(s0)
    80004688:	e0e6d1e3          	bge	a3,a4,8000448a <exec+0x154>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph)) goto bad;
    8000468c:	2781                	sext.w	a5,a5
    8000468e:	e0f43023          	sd	a5,-512(s0)
    80004692:	03800713          	li	a4,56
    80004696:	86be                	mv	a3,a5
    80004698:	e1840613          	addi	a2,s0,-488
    8000469c:	4581                	li	a1,0
    8000469e:	8556                	mv	a0,s5
    800046a0:	fffff097          	auipc	ra,0xfffff
    800046a4:	a42080e7          	jalr	-1470(ra) # 800030e2 <readi>
    800046a8:	03800793          	li	a5,56
    800046ac:	f6f51be3          	bne	a0,a5,80004622 <exec+0x2ec>
    if (ph.type != ELF_PROG_LOAD) continue;
    800046b0:	e1842783          	lw	a5,-488(s0)
    800046b4:	4705                	li	a4,1
    800046b6:	fae79de3          	bne	a5,a4,80004670 <exec+0x33a>
    if (ph.memsz < ph.filesz) goto bad;
    800046ba:	e4043483          	ld	s1,-448(s0)
    800046be:	e3843783          	ld	a5,-456(s0)
    800046c2:	f6f4ede3          	bltu	s1,a5,8000463c <exec+0x306>
    if (ph.vaddr + ph.memsz < ph.vaddr) goto bad;
    800046c6:	e2843783          	ld	a5,-472(s0)
    800046ca:	94be                	add	s1,s1,a5
    800046cc:	f6f4ebe3          	bltu	s1,a5,80004642 <exec+0x30c>
    if (ph.vaddr % PGSIZE != 0) goto bad;
    800046d0:	de043703          	ld	a4,-544(s0)
    800046d4:	8ff9                	and	a5,a5,a4
    800046d6:	fbad                	bnez	a5,80004648 <exec+0x312>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    800046d8:	e1c42503          	lw	a0,-484(s0)
    800046dc:	00000097          	auipc	ra,0x0
    800046e0:	c3e080e7          	jalr	-962(ra) # 8000431a <flags2perm>
    800046e4:	86aa                	mv	a3,a0
    800046e6:	8626                	mv	a2,s1
    800046e8:	85ca                	mv	a1,s2
    800046ea:	855a                	mv	a0,s6
    800046ec:	ffffc097          	auipc	ra,0xffffc
    800046f0:	2bc080e7          	jalr	700(ra) # 800009a8 <uvmalloc>
    800046f4:	dea43c23          	sd	a0,-520(s0)
    800046f8:	d939                	beqz	a0,8000464e <exec+0x318>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0) goto bad;
    800046fa:	e2843c03          	ld	s8,-472(s0)
    800046fe:	e2042c83          	lw	s9,-480(s0)
    80004702:	e3842b83          	lw	s7,-456(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    80004706:	f60b83e3          	beqz	s7,8000466c <exec+0x336>
    8000470a:	89de                	mv	s3,s7
    8000470c:	4481                	li	s1,0
    8000470e:	bba9                	j	80004468 <exec+0x132>

0000000080004710 <argfd>:
#include "stat.h"
#include "types.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int argfd(int n, int *pfd, struct file **pf) {
    80004710:	7179                	addi	sp,sp,-48
    80004712:	f406                	sd	ra,40(sp)
    80004714:	f022                	sd	s0,32(sp)
    80004716:	ec26                	sd	s1,24(sp)
    80004718:	e84a                	sd	s2,16(sp)
    8000471a:	1800                	addi	s0,sp,48
    8000471c:	892e                	mv	s2,a1
    8000471e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004720:	fdc40593          	addi	a1,s0,-36
    80004724:	ffffe097          	auipc	ra,0xffffe
    80004728:	b90080e7          	jalr	-1136(ra) # 800022b4 <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) return -1;
    8000472c:	fdc42703          	lw	a4,-36(s0)
    80004730:	47bd                	li	a5,15
    80004732:	02e7eb63          	bltu	a5,a4,80004768 <argfd+0x58>
    80004736:	ffffd097          	auipc	ra,0xffffd
    8000473a:	a2e080e7          	jalr	-1490(ra) # 80001164 <myproc>
    8000473e:	fdc42703          	lw	a4,-36(s0)
    80004742:	01a70793          	addi	a5,a4,26
    80004746:	078e                	slli	a5,a5,0x3
    80004748:	953e                	add	a0,a0,a5
    8000474a:	611c                	ld	a5,0(a0)
    8000474c:	c385                	beqz	a5,8000476c <argfd+0x5c>
  if (pfd) *pfd = fd;
    8000474e:	00090463          	beqz	s2,80004756 <argfd+0x46>
    80004752:	00e92023          	sw	a4,0(s2)
  if (pf) *pf = f;
  return 0;
    80004756:	4501                	li	a0,0
  if (pf) *pf = f;
    80004758:	c091                	beqz	s1,8000475c <argfd+0x4c>
    8000475a:	e09c                	sd	a5,0(s1)
}
    8000475c:	70a2                	ld	ra,40(sp)
    8000475e:	7402                	ld	s0,32(sp)
    80004760:	64e2                	ld	s1,24(sp)
    80004762:	6942                	ld	s2,16(sp)
    80004764:	6145                	addi	sp,sp,48
    80004766:	8082                	ret
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) return -1;
    80004768:	557d                	li	a0,-1
    8000476a:	bfcd                	j	8000475c <argfd+0x4c>
    8000476c:	557d                	li	a0,-1
    8000476e:	b7fd                	j	8000475c <argfd+0x4c>

0000000080004770 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int fdalloc(struct file *f) {
    80004770:	1101                	addi	sp,sp,-32
    80004772:	ec06                	sd	ra,24(sp)
    80004774:	e822                	sd	s0,16(sp)
    80004776:	e426                	sd	s1,8(sp)
    80004778:	1000                	addi	s0,sp,32
    8000477a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000477c:	ffffd097          	auipc	ra,0xffffd
    80004780:	9e8080e7          	jalr	-1560(ra) # 80001164 <myproc>
    80004784:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++) {
    80004786:	0d050793          	addi	a5,a0,208
    8000478a:	4501                	li	a0,0
    8000478c:	46c1                	li	a3,16
    if (p->ofile[fd] == 0) {
    8000478e:	6398                	ld	a4,0(a5)
    80004790:	cb19                	beqz	a4,800047a6 <fdalloc+0x36>
  for (fd = 0; fd < NOFILE; fd++) {
    80004792:	2505                	addiw	a0,a0,1
    80004794:	07a1                	addi	a5,a5,8
    80004796:	fed51ce3          	bne	a0,a3,8000478e <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000479a:	557d                	li	a0,-1
}
    8000479c:	60e2                	ld	ra,24(sp)
    8000479e:	6442                	ld	s0,16(sp)
    800047a0:	64a2                	ld	s1,8(sp)
    800047a2:	6105                	addi	sp,sp,32
    800047a4:	8082                	ret
      p->ofile[fd] = f;
    800047a6:	01a50793          	addi	a5,a0,26
    800047aa:	078e                	slli	a5,a5,0x3
    800047ac:	963e                	add	a2,a2,a5
    800047ae:	e204                	sd	s1,0(a2)
      return fd;
    800047b0:	b7f5                	j	8000479c <fdalloc+0x2c>

00000000800047b2 <create>:
  iunlockput(dp);
  end_op();
  return -1;
}

static struct inode *create(char *path, short type, short major, short minor) {
    800047b2:	715d                	addi	sp,sp,-80
    800047b4:	e486                	sd	ra,72(sp)
    800047b6:	e0a2                	sd	s0,64(sp)
    800047b8:	fc26                	sd	s1,56(sp)
    800047ba:	f84a                	sd	s2,48(sp)
    800047bc:	f44e                	sd	s3,40(sp)
    800047be:	f052                	sd	s4,32(sp)
    800047c0:	ec56                	sd	s5,24(sp)
    800047c2:	e85a                	sd	s6,16(sp)
    800047c4:	0880                	addi	s0,sp,80
    800047c6:	8b2e                	mv	s6,a1
    800047c8:	89b2                	mv	s3,a2
    800047ca:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0) return 0;
    800047cc:	fb040593          	addi	a1,s0,-80
    800047d0:	fffff097          	auipc	ra,0xfffff
    800047d4:	e22080e7          	jalr	-478(ra) # 800035f2 <nameiparent>
    800047d8:	84aa                	mv	s1,a0
    800047da:	14050f63          	beqz	a0,80004938 <create+0x186>

  ilock(dp);
    800047de:	ffffe097          	auipc	ra,0xffffe
    800047e2:	650080e7          	jalr	1616(ra) # 80002e2e <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0) {
    800047e6:	4601                	li	a2,0
    800047e8:	fb040593          	addi	a1,s0,-80
    800047ec:	8526                	mv	a0,s1
    800047ee:	fffff097          	auipc	ra,0xfffff
    800047f2:	b24080e7          	jalr	-1244(ra) # 80003312 <dirlookup>
    800047f6:	8aaa                	mv	s5,a0
    800047f8:	c931                	beqz	a0,8000484c <create+0x9a>
    iunlockput(dp);
    800047fa:	8526                	mv	a0,s1
    800047fc:	fffff097          	auipc	ra,0xfffff
    80004800:	894080e7          	jalr	-1900(ra) # 80003090 <iunlockput>
    ilock(ip);
    80004804:	8556                	mv	a0,s5
    80004806:	ffffe097          	auipc	ra,0xffffe
    8000480a:	628080e7          	jalr	1576(ra) # 80002e2e <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000480e:	000b059b          	sext.w	a1,s6
    80004812:	4789                	li	a5,2
    80004814:	02f59563          	bne	a1,a5,8000483e <create+0x8c>
    80004818:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffbd354>
    8000481c:	37f9                	addiw	a5,a5,-2
    8000481e:	17c2                	slli	a5,a5,0x30
    80004820:	93c1                	srli	a5,a5,0x30
    80004822:	4705                	li	a4,1
    80004824:	00f76d63          	bltu	a4,a5,8000483e <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004828:	8556                	mv	a0,s5
    8000482a:	60a6                	ld	ra,72(sp)
    8000482c:	6406                	ld	s0,64(sp)
    8000482e:	74e2                	ld	s1,56(sp)
    80004830:	7942                	ld	s2,48(sp)
    80004832:	79a2                	ld	s3,40(sp)
    80004834:	7a02                	ld	s4,32(sp)
    80004836:	6ae2                	ld	s5,24(sp)
    80004838:	6b42                	ld	s6,16(sp)
    8000483a:	6161                	addi	sp,sp,80
    8000483c:	8082                	ret
    iunlockput(ip);
    8000483e:	8556                	mv	a0,s5
    80004840:	fffff097          	auipc	ra,0xfffff
    80004844:	850080e7          	jalr	-1968(ra) # 80003090 <iunlockput>
    return 0;
    80004848:	4a81                	li	s5,0
    8000484a:	bff9                	j	80004828 <create+0x76>
  if ((ip = ialloc(dp->dev, type)) == 0) {
    8000484c:	85da                	mv	a1,s6
    8000484e:	4088                	lw	a0,0(s1)
    80004850:	ffffe097          	auipc	ra,0xffffe
    80004854:	442080e7          	jalr	1090(ra) # 80002c92 <ialloc>
    80004858:	8a2a                	mv	s4,a0
    8000485a:	c539                	beqz	a0,800048a8 <create+0xf6>
  ilock(ip);
    8000485c:	ffffe097          	auipc	ra,0xffffe
    80004860:	5d2080e7          	jalr	1490(ra) # 80002e2e <ilock>
  ip->major = major;
    80004864:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004868:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000486c:	4905                	li	s2,1
    8000486e:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004872:	8552                	mv	a0,s4
    80004874:	ffffe097          	auipc	ra,0xffffe
    80004878:	4f0080e7          	jalr	1264(ra) # 80002d64 <iupdate>
  if (type == T_DIR) {  // Create . and .. entries.
    8000487c:	000b059b          	sext.w	a1,s6
    80004880:	03258b63          	beq	a1,s2,800048b6 <create+0x104>
  if (dirlink(dp, name, ip->inum) < 0) goto fail;
    80004884:	004a2603          	lw	a2,4(s4)
    80004888:	fb040593          	addi	a1,s0,-80
    8000488c:	8526                	mv	a0,s1
    8000488e:	fffff097          	auipc	ra,0xfffff
    80004892:	c94080e7          	jalr	-876(ra) # 80003522 <dirlink>
    80004896:	06054f63          	bltz	a0,80004914 <create+0x162>
  iunlockput(dp);
    8000489a:	8526                	mv	a0,s1
    8000489c:	ffffe097          	auipc	ra,0xffffe
    800048a0:	7f4080e7          	jalr	2036(ra) # 80003090 <iunlockput>
  return ip;
    800048a4:	8ad2                	mv	s5,s4
    800048a6:	b749                	j	80004828 <create+0x76>
    iunlockput(dp);
    800048a8:	8526                	mv	a0,s1
    800048aa:	ffffe097          	auipc	ra,0xffffe
    800048ae:	7e6080e7          	jalr	2022(ra) # 80003090 <iunlockput>
    return 0;
    800048b2:	8ad2                	mv	s5,s4
    800048b4:	bf95                	j	80004828 <create+0x76>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800048b6:	004a2603          	lw	a2,4(s4)
    800048ba:	00004597          	auipc	a1,0x4
    800048be:	d6e58593          	addi	a1,a1,-658 # 80008628 <syscalls+0x2a0>
    800048c2:	8552                	mv	a0,s4
    800048c4:	fffff097          	auipc	ra,0xfffff
    800048c8:	c5e080e7          	jalr	-930(ra) # 80003522 <dirlink>
    800048cc:	04054463          	bltz	a0,80004914 <create+0x162>
    800048d0:	40d0                	lw	a2,4(s1)
    800048d2:	00004597          	auipc	a1,0x4
    800048d6:	d5e58593          	addi	a1,a1,-674 # 80008630 <syscalls+0x2a8>
    800048da:	8552                	mv	a0,s4
    800048dc:	fffff097          	auipc	ra,0xfffff
    800048e0:	c46080e7          	jalr	-954(ra) # 80003522 <dirlink>
    800048e4:	02054863          	bltz	a0,80004914 <create+0x162>
  if (dirlink(dp, name, ip->inum) < 0) goto fail;
    800048e8:	004a2603          	lw	a2,4(s4)
    800048ec:	fb040593          	addi	a1,s0,-80
    800048f0:	8526                	mv	a0,s1
    800048f2:	fffff097          	auipc	ra,0xfffff
    800048f6:	c30080e7          	jalr	-976(ra) # 80003522 <dirlink>
    800048fa:	00054d63          	bltz	a0,80004914 <create+0x162>
    dp->nlink++;  // for ".."
    800048fe:	04a4d783          	lhu	a5,74(s1)
    80004902:	2785                	addiw	a5,a5,1
    80004904:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004908:	8526                	mv	a0,s1
    8000490a:	ffffe097          	auipc	ra,0xffffe
    8000490e:	45a080e7          	jalr	1114(ra) # 80002d64 <iupdate>
    80004912:	b761                	j	8000489a <create+0xe8>
  ip->nlink = 0;
    80004914:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004918:	8552                	mv	a0,s4
    8000491a:	ffffe097          	auipc	ra,0xffffe
    8000491e:	44a080e7          	jalr	1098(ra) # 80002d64 <iupdate>
  iunlockput(ip);
    80004922:	8552                	mv	a0,s4
    80004924:	ffffe097          	auipc	ra,0xffffe
    80004928:	76c080e7          	jalr	1900(ra) # 80003090 <iunlockput>
  iunlockput(dp);
    8000492c:	8526                	mv	a0,s1
    8000492e:	ffffe097          	auipc	ra,0xffffe
    80004932:	762080e7          	jalr	1890(ra) # 80003090 <iunlockput>
  return 0;
    80004936:	bdcd                	j	80004828 <create+0x76>
  if ((dp = nameiparent(path, name)) == 0) return 0;
    80004938:	8aaa                	mv	s5,a0
    8000493a:	b5fd                	j	80004828 <create+0x76>

000000008000493c <sys_dup>:
uint64 sys_dup(void) {
    8000493c:	7179                	addi	sp,sp,-48
    8000493e:	f406                	sd	ra,40(sp)
    80004940:	f022                	sd	s0,32(sp)
    80004942:	ec26                	sd	s1,24(sp)
    80004944:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0) return -1;
    80004946:	fd840613          	addi	a2,s0,-40
    8000494a:	4581                	li	a1,0
    8000494c:	4501                	li	a0,0
    8000494e:	00000097          	auipc	ra,0x0
    80004952:	dc2080e7          	jalr	-574(ra) # 80004710 <argfd>
    80004956:	57fd                	li	a5,-1
    80004958:	02054363          	bltz	a0,8000497e <sys_dup+0x42>
  if ((fd = fdalloc(f)) < 0) return -1;
    8000495c:	fd843503          	ld	a0,-40(s0)
    80004960:	00000097          	auipc	ra,0x0
    80004964:	e10080e7          	jalr	-496(ra) # 80004770 <fdalloc>
    80004968:	84aa                	mv	s1,a0
    8000496a:	57fd                	li	a5,-1
    8000496c:	00054963          	bltz	a0,8000497e <sys_dup+0x42>
  filedup(f);
    80004970:	fd843503          	ld	a0,-40(s0)
    80004974:	fffff097          	auipc	ra,0xfffff
    80004978:	2f6080e7          	jalr	758(ra) # 80003c6a <filedup>
  return fd;
    8000497c:	87a6                	mv	a5,s1
}
    8000497e:	853e                	mv	a0,a5
    80004980:	70a2                	ld	ra,40(sp)
    80004982:	7402                	ld	s0,32(sp)
    80004984:	64e2                	ld	s1,24(sp)
    80004986:	6145                	addi	sp,sp,48
    80004988:	8082                	ret

000000008000498a <sys_read>:
uint64 sys_read(void) {
    8000498a:	7179                	addi	sp,sp,-48
    8000498c:	f406                	sd	ra,40(sp)
    8000498e:	f022                	sd	s0,32(sp)
    80004990:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004992:	fd840593          	addi	a1,s0,-40
    80004996:	4505                	li	a0,1
    80004998:	ffffe097          	auipc	ra,0xffffe
    8000499c:	93c080e7          	jalr	-1732(ra) # 800022d4 <argaddr>
  argint(2, &n);
    800049a0:	fe440593          	addi	a1,s0,-28
    800049a4:	4509                	li	a0,2
    800049a6:	ffffe097          	auipc	ra,0xffffe
    800049aa:	90e080e7          	jalr	-1778(ra) # 800022b4 <argint>
  if (argfd(0, 0, &f) < 0) return -1;
    800049ae:	fe840613          	addi	a2,s0,-24
    800049b2:	4581                	li	a1,0
    800049b4:	4501                	li	a0,0
    800049b6:	00000097          	auipc	ra,0x0
    800049ba:	d5a080e7          	jalr	-678(ra) # 80004710 <argfd>
    800049be:	87aa                	mv	a5,a0
    800049c0:	557d                	li	a0,-1
    800049c2:	0007cc63          	bltz	a5,800049da <sys_read+0x50>
  return fileread(f, p, n);
    800049c6:	fe442603          	lw	a2,-28(s0)
    800049ca:	fd843583          	ld	a1,-40(s0)
    800049ce:	fe843503          	ld	a0,-24(s0)
    800049d2:	fffff097          	auipc	ra,0xfffff
    800049d6:	424080e7          	jalr	1060(ra) # 80003df6 <fileread>
}
    800049da:	70a2                	ld	ra,40(sp)
    800049dc:	7402                	ld	s0,32(sp)
    800049de:	6145                	addi	sp,sp,48
    800049e0:	8082                	ret

00000000800049e2 <sys_write>:
uint64 sys_write(void) {
    800049e2:	7179                	addi	sp,sp,-48
    800049e4:	f406                	sd	ra,40(sp)
    800049e6:	f022                	sd	s0,32(sp)
    800049e8:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800049ea:	fd840593          	addi	a1,s0,-40
    800049ee:	4505                	li	a0,1
    800049f0:	ffffe097          	auipc	ra,0xffffe
    800049f4:	8e4080e7          	jalr	-1820(ra) # 800022d4 <argaddr>
  argint(2, &n);
    800049f8:	fe440593          	addi	a1,s0,-28
    800049fc:	4509                	li	a0,2
    800049fe:	ffffe097          	auipc	ra,0xffffe
    80004a02:	8b6080e7          	jalr	-1866(ra) # 800022b4 <argint>
  if (argfd(0, 0, &f) < 0) return -1;
    80004a06:	fe840613          	addi	a2,s0,-24
    80004a0a:	4581                	li	a1,0
    80004a0c:	4501                	li	a0,0
    80004a0e:	00000097          	auipc	ra,0x0
    80004a12:	d02080e7          	jalr	-766(ra) # 80004710 <argfd>
    80004a16:	87aa                	mv	a5,a0
    80004a18:	557d                	li	a0,-1
    80004a1a:	0007cc63          	bltz	a5,80004a32 <sys_write+0x50>
  return filewrite(f, p, n);
    80004a1e:	fe442603          	lw	a2,-28(s0)
    80004a22:	fd843583          	ld	a1,-40(s0)
    80004a26:	fe843503          	ld	a0,-24(s0)
    80004a2a:	fffff097          	auipc	ra,0xfffff
    80004a2e:	48e080e7          	jalr	1166(ra) # 80003eb8 <filewrite>
}
    80004a32:	70a2                	ld	ra,40(sp)
    80004a34:	7402                	ld	s0,32(sp)
    80004a36:	6145                	addi	sp,sp,48
    80004a38:	8082                	ret

0000000080004a3a <sys_close>:
uint64 sys_close(void) {
    80004a3a:	1101                	addi	sp,sp,-32
    80004a3c:	ec06                	sd	ra,24(sp)
    80004a3e:	e822                	sd	s0,16(sp)
    80004a40:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0) return -1;
    80004a42:	fe040613          	addi	a2,s0,-32
    80004a46:	fec40593          	addi	a1,s0,-20
    80004a4a:	4501                	li	a0,0
    80004a4c:	00000097          	auipc	ra,0x0
    80004a50:	cc4080e7          	jalr	-828(ra) # 80004710 <argfd>
    80004a54:	57fd                	li	a5,-1
    80004a56:	02054463          	bltz	a0,80004a7e <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004a5a:	ffffc097          	auipc	ra,0xffffc
    80004a5e:	70a080e7          	jalr	1802(ra) # 80001164 <myproc>
    80004a62:	fec42783          	lw	a5,-20(s0)
    80004a66:	07e9                	addi	a5,a5,26
    80004a68:	078e                	slli	a5,a5,0x3
    80004a6a:	97aa                	add	a5,a5,a0
    80004a6c:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004a70:	fe043503          	ld	a0,-32(s0)
    80004a74:	fffff097          	auipc	ra,0xfffff
    80004a78:	248080e7          	jalr	584(ra) # 80003cbc <fileclose>
  return 0;
    80004a7c:	4781                	li	a5,0
}
    80004a7e:	853e                	mv	a0,a5
    80004a80:	60e2                	ld	ra,24(sp)
    80004a82:	6442                	ld	s0,16(sp)
    80004a84:	6105                	addi	sp,sp,32
    80004a86:	8082                	ret

0000000080004a88 <sys_fstat>:
uint64 sys_fstat(void) {
    80004a88:	1101                	addi	sp,sp,-32
    80004a8a:	ec06                	sd	ra,24(sp)
    80004a8c:	e822                	sd	s0,16(sp)
    80004a8e:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004a90:	fe040593          	addi	a1,s0,-32
    80004a94:	4505                	li	a0,1
    80004a96:	ffffe097          	auipc	ra,0xffffe
    80004a9a:	83e080e7          	jalr	-1986(ra) # 800022d4 <argaddr>
  if (argfd(0, 0, &f) < 0) return -1;
    80004a9e:	fe840613          	addi	a2,s0,-24
    80004aa2:	4581                	li	a1,0
    80004aa4:	4501                	li	a0,0
    80004aa6:	00000097          	auipc	ra,0x0
    80004aaa:	c6a080e7          	jalr	-918(ra) # 80004710 <argfd>
    80004aae:	87aa                	mv	a5,a0
    80004ab0:	557d                	li	a0,-1
    80004ab2:	0007ca63          	bltz	a5,80004ac6 <sys_fstat+0x3e>
  return filestat(f, st);
    80004ab6:	fe043583          	ld	a1,-32(s0)
    80004aba:	fe843503          	ld	a0,-24(s0)
    80004abe:	fffff097          	auipc	ra,0xfffff
    80004ac2:	2c6080e7          	jalr	710(ra) # 80003d84 <filestat>
}
    80004ac6:	60e2                	ld	ra,24(sp)
    80004ac8:	6442                	ld	s0,16(sp)
    80004aca:	6105                	addi	sp,sp,32
    80004acc:	8082                	ret

0000000080004ace <sys_link>:
uint64 sys_link(void) {
    80004ace:	7169                	addi	sp,sp,-304
    80004ad0:	f606                	sd	ra,296(sp)
    80004ad2:	f222                	sd	s0,288(sp)
    80004ad4:	ee26                	sd	s1,280(sp)
    80004ad6:	ea4a                	sd	s2,272(sp)
    80004ad8:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0) return -1;
    80004ada:	08000613          	li	a2,128
    80004ade:	ed040593          	addi	a1,s0,-304
    80004ae2:	4501                	li	a0,0
    80004ae4:	ffffe097          	auipc	ra,0xffffe
    80004ae8:	810080e7          	jalr	-2032(ra) # 800022f4 <argstr>
    80004aec:	57fd                	li	a5,-1
    80004aee:	10054e63          	bltz	a0,80004c0a <sys_link+0x13c>
    80004af2:	08000613          	li	a2,128
    80004af6:	f5040593          	addi	a1,s0,-176
    80004afa:	4505                	li	a0,1
    80004afc:	ffffd097          	auipc	ra,0xffffd
    80004b00:	7f8080e7          	jalr	2040(ra) # 800022f4 <argstr>
    80004b04:	57fd                	li	a5,-1
    80004b06:	10054263          	bltz	a0,80004c0a <sys_link+0x13c>
  begin_op();
    80004b0a:	fffff097          	auipc	ra,0xfffff
    80004b0e:	ce6080e7          	jalr	-794(ra) # 800037f0 <begin_op>
  if ((ip = namei(old)) == 0) {
    80004b12:	ed040513          	addi	a0,s0,-304
    80004b16:	fffff097          	auipc	ra,0xfffff
    80004b1a:	abe080e7          	jalr	-1346(ra) # 800035d4 <namei>
    80004b1e:	84aa                	mv	s1,a0
    80004b20:	c551                	beqz	a0,80004bac <sys_link+0xde>
  ilock(ip);
    80004b22:	ffffe097          	auipc	ra,0xffffe
    80004b26:	30c080e7          	jalr	780(ra) # 80002e2e <ilock>
  if (ip->type == T_DIR) {
    80004b2a:	04449703          	lh	a4,68(s1)
    80004b2e:	4785                	li	a5,1
    80004b30:	08f70463          	beq	a4,a5,80004bb8 <sys_link+0xea>
  ip->nlink++;
    80004b34:	04a4d783          	lhu	a5,74(s1)
    80004b38:	2785                	addiw	a5,a5,1
    80004b3a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b3e:	8526                	mv	a0,s1
    80004b40:	ffffe097          	auipc	ra,0xffffe
    80004b44:	224080e7          	jalr	548(ra) # 80002d64 <iupdate>
  iunlock(ip);
    80004b48:	8526                	mv	a0,s1
    80004b4a:	ffffe097          	auipc	ra,0xffffe
    80004b4e:	3a6080e7          	jalr	934(ra) # 80002ef0 <iunlock>
  if ((dp = nameiparent(new, name)) == 0) goto bad;
    80004b52:	fd040593          	addi	a1,s0,-48
    80004b56:	f5040513          	addi	a0,s0,-176
    80004b5a:	fffff097          	auipc	ra,0xfffff
    80004b5e:	a98080e7          	jalr	-1384(ra) # 800035f2 <nameiparent>
    80004b62:	892a                	mv	s2,a0
    80004b64:	c935                	beqz	a0,80004bd8 <sys_link+0x10a>
  ilock(dp);
    80004b66:	ffffe097          	auipc	ra,0xffffe
    80004b6a:	2c8080e7          	jalr	712(ra) # 80002e2e <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    80004b6e:	00092703          	lw	a4,0(s2)
    80004b72:	409c                	lw	a5,0(s1)
    80004b74:	04f71d63          	bne	a4,a5,80004bce <sys_link+0x100>
    80004b78:	40d0                	lw	a2,4(s1)
    80004b7a:	fd040593          	addi	a1,s0,-48
    80004b7e:	854a                	mv	a0,s2
    80004b80:	fffff097          	auipc	ra,0xfffff
    80004b84:	9a2080e7          	jalr	-1630(ra) # 80003522 <dirlink>
    80004b88:	04054363          	bltz	a0,80004bce <sys_link+0x100>
  iunlockput(dp);
    80004b8c:	854a                	mv	a0,s2
    80004b8e:	ffffe097          	auipc	ra,0xffffe
    80004b92:	502080e7          	jalr	1282(ra) # 80003090 <iunlockput>
  iput(ip);
    80004b96:	8526                	mv	a0,s1
    80004b98:	ffffe097          	auipc	ra,0xffffe
    80004b9c:	450080e7          	jalr	1104(ra) # 80002fe8 <iput>
  end_op();
    80004ba0:	fffff097          	auipc	ra,0xfffff
    80004ba4:	cd0080e7          	jalr	-816(ra) # 80003870 <end_op>
  return 0;
    80004ba8:	4781                	li	a5,0
    80004baa:	a085                	j	80004c0a <sys_link+0x13c>
    end_op();
    80004bac:	fffff097          	auipc	ra,0xfffff
    80004bb0:	cc4080e7          	jalr	-828(ra) # 80003870 <end_op>
    return -1;
    80004bb4:	57fd                	li	a5,-1
    80004bb6:	a891                	j	80004c0a <sys_link+0x13c>
    iunlockput(ip);
    80004bb8:	8526                	mv	a0,s1
    80004bba:	ffffe097          	auipc	ra,0xffffe
    80004bbe:	4d6080e7          	jalr	1238(ra) # 80003090 <iunlockput>
    end_op();
    80004bc2:	fffff097          	auipc	ra,0xfffff
    80004bc6:	cae080e7          	jalr	-850(ra) # 80003870 <end_op>
    return -1;
    80004bca:	57fd                	li	a5,-1
    80004bcc:	a83d                	j	80004c0a <sys_link+0x13c>
    iunlockput(dp);
    80004bce:	854a                	mv	a0,s2
    80004bd0:	ffffe097          	auipc	ra,0xffffe
    80004bd4:	4c0080e7          	jalr	1216(ra) # 80003090 <iunlockput>
  ilock(ip);
    80004bd8:	8526                	mv	a0,s1
    80004bda:	ffffe097          	auipc	ra,0xffffe
    80004bde:	254080e7          	jalr	596(ra) # 80002e2e <ilock>
  ip->nlink--;
    80004be2:	04a4d783          	lhu	a5,74(s1)
    80004be6:	37fd                	addiw	a5,a5,-1
    80004be8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004bec:	8526                	mv	a0,s1
    80004bee:	ffffe097          	auipc	ra,0xffffe
    80004bf2:	176080e7          	jalr	374(ra) # 80002d64 <iupdate>
  iunlockput(ip);
    80004bf6:	8526                	mv	a0,s1
    80004bf8:	ffffe097          	auipc	ra,0xffffe
    80004bfc:	498080e7          	jalr	1176(ra) # 80003090 <iunlockput>
  end_op();
    80004c00:	fffff097          	auipc	ra,0xfffff
    80004c04:	c70080e7          	jalr	-912(ra) # 80003870 <end_op>
  return -1;
    80004c08:	57fd                	li	a5,-1
}
    80004c0a:	853e                	mv	a0,a5
    80004c0c:	70b2                	ld	ra,296(sp)
    80004c0e:	7412                	ld	s0,288(sp)
    80004c10:	64f2                	ld	s1,280(sp)
    80004c12:	6952                	ld	s2,272(sp)
    80004c14:	6155                	addi	sp,sp,304
    80004c16:	8082                	ret

0000000080004c18 <sys_unlink>:
uint64 sys_unlink(void) {
    80004c18:	7151                	addi	sp,sp,-240
    80004c1a:	f586                	sd	ra,232(sp)
    80004c1c:	f1a2                	sd	s0,224(sp)
    80004c1e:	eda6                	sd	s1,216(sp)
    80004c20:	e9ca                	sd	s2,208(sp)
    80004c22:	e5ce                	sd	s3,200(sp)
    80004c24:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0) return -1;
    80004c26:	08000613          	li	a2,128
    80004c2a:	f3040593          	addi	a1,s0,-208
    80004c2e:	4501                	li	a0,0
    80004c30:	ffffd097          	auipc	ra,0xffffd
    80004c34:	6c4080e7          	jalr	1732(ra) # 800022f4 <argstr>
    80004c38:	18054163          	bltz	a0,80004dba <sys_unlink+0x1a2>
  begin_op();
    80004c3c:	fffff097          	auipc	ra,0xfffff
    80004c40:	bb4080e7          	jalr	-1100(ra) # 800037f0 <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
    80004c44:	fb040593          	addi	a1,s0,-80
    80004c48:	f3040513          	addi	a0,s0,-208
    80004c4c:	fffff097          	auipc	ra,0xfffff
    80004c50:	9a6080e7          	jalr	-1626(ra) # 800035f2 <nameiparent>
    80004c54:	84aa                	mv	s1,a0
    80004c56:	c979                	beqz	a0,80004d2c <sys_unlink+0x114>
  ilock(dp);
    80004c58:	ffffe097          	auipc	ra,0xffffe
    80004c5c:	1d6080e7          	jalr	470(ra) # 80002e2e <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0) goto bad;
    80004c60:	00004597          	auipc	a1,0x4
    80004c64:	9c858593          	addi	a1,a1,-1592 # 80008628 <syscalls+0x2a0>
    80004c68:	fb040513          	addi	a0,s0,-80
    80004c6c:	ffffe097          	auipc	ra,0xffffe
    80004c70:	68c080e7          	jalr	1676(ra) # 800032f8 <namecmp>
    80004c74:	14050a63          	beqz	a0,80004dc8 <sys_unlink+0x1b0>
    80004c78:	00004597          	auipc	a1,0x4
    80004c7c:	9b858593          	addi	a1,a1,-1608 # 80008630 <syscalls+0x2a8>
    80004c80:	fb040513          	addi	a0,s0,-80
    80004c84:	ffffe097          	auipc	ra,0xffffe
    80004c88:	674080e7          	jalr	1652(ra) # 800032f8 <namecmp>
    80004c8c:	12050e63          	beqz	a0,80004dc8 <sys_unlink+0x1b0>
  if ((ip = dirlookup(dp, name, &off)) == 0) goto bad;
    80004c90:	f2c40613          	addi	a2,s0,-212
    80004c94:	fb040593          	addi	a1,s0,-80
    80004c98:	8526                	mv	a0,s1
    80004c9a:	ffffe097          	auipc	ra,0xffffe
    80004c9e:	678080e7          	jalr	1656(ra) # 80003312 <dirlookup>
    80004ca2:	892a                	mv	s2,a0
    80004ca4:	12050263          	beqz	a0,80004dc8 <sys_unlink+0x1b0>
  ilock(ip);
    80004ca8:	ffffe097          	auipc	ra,0xffffe
    80004cac:	186080e7          	jalr	390(ra) # 80002e2e <ilock>
  if (ip->nlink < 1) panic("unlink: nlink < 1");
    80004cb0:	04a91783          	lh	a5,74(s2)
    80004cb4:	08f05263          	blez	a5,80004d38 <sys_unlink+0x120>
  if (ip->type == T_DIR && !isdirempty(ip)) {
    80004cb8:	04491703          	lh	a4,68(s2)
    80004cbc:	4785                	li	a5,1
    80004cbe:	08f70563          	beq	a4,a5,80004d48 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004cc2:	4641                	li	a2,16
    80004cc4:	4581                	li	a1,0
    80004cc6:	fc040513          	addi	a0,s0,-64
    80004cca:	ffffb097          	auipc	ra,0xffffb
    80004cce:	5d8080e7          	jalr	1496(ra) # 800002a2 <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004cd2:	4741                	li	a4,16
    80004cd4:	f2c42683          	lw	a3,-212(s0)
    80004cd8:	fc040613          	addi	a2,s0,-64
    80004cdc:	4581                	li	a1,0
    80004cde:	8526                	mv	a0,s1
    80004ce0:	ffffe097          	auipc	ra,0xffffe
    80004ce4:	4fa080e7          	jalr	1274(ra) # 800031da <writei>
    80004ce8:	47c1                	li	a5,16
    80004cea:	0af51563          	bne	a0,a5,80004d94 <sys_unlink+0x17c>
  if (ip->type == T_DIR) {
    80004cee:	04491703          	lh	a4,68(s2)
    80004cf2:	4785                	li	a5,1
    80004cf4:	0af70863          	beq	a4,a5,80004da4 <sys_unlink+0x18c>
  iunlockput(dp);
    80004cf8:	8526                	mv	a0,s1
    80004cfa:	ffffe097          	auipc	ra,0xffffe
    80004cfe:	396080e7          	jalr	918(ra) # 80003090 <iunlockput>
  ip->nlink--;
    80004d02:	04a95783          	lhu	a5,74(s2)
    80004d06:	37fd                	addiw	a5,a5,-1
    80004d08:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004d0c:	854a                	mv	a0,s2
    80004d0e:	ffffe097          	auipc	ra,0xffffe
    80004d12:	056080e7          	jalr	86(ra) # 80002d64 <iupdate>
  iunlockput(ip);
    80004d16:	854a                	mv	a0,s2
    80004d18:	ffffe097          	auipc	ra,0xffffe
    80004d1c:	378080e7          	jalr	888(ra) # 80003090 <iunlockput>
  end_op();
    80004d20:	fffff097          	auipc	ra,0xfffff
    80004d24:	b50080e7          	jalr	-1200(ra) # 80003870 <end_op>
  return 0;
    80004d28:	4501                	li	a0,0
    80004d2a:	a84d                	j	80004ddc <sys_unlink+0x1c4>
    end_op();
    80004d2c:	fffff097          	auipc	ra,0xfffff
    80004d30:	b44080e7          	jalr	-1212(ra) # 80003870 <end_op>
    return -1;
    80004d34:	557d                	li	a0,-1
    80004d36:	a05d                	j	80004ddc <sys_unlink+0x1c4>
  if (ip->nlink < 1) panic("unlink: nlink < 1");
    80004d38:	00004517          	auipc	a0,0x4
    80004d3c:	90050513          	addi	a0,a0,-1792 # 80008638 <syscalls+0x2b0>
    80004d40:	00001097          	auipc	ra,0x1
    80004d44:	1ae080e7          	jalr	430(ra) # 80005eee <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004d48:	04c92703          	lw	a4,76(s2)
    80004d4c:	02000793          	li	a5,32
    80004d50:	f6e7f9e3          	bgeu	a5,a4,80004cc2 <sys_unlink+0xaa>
    80004d54:	02000993          	li	s3,32
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d58:	4741                	li	a4,16
    80004d5a:	86ce                	mv	a3,s3
    80004d5c:	f1840613          	addi	a2,s0,-232
    80004d60:	4581                	li	a1,0
    80004d62:	854a                	mv	a0,s2
    80004d64:	ffffe097          	auipc	ra,0xffffe
    80004d68:	37e080e7          	jalr	894(ra) # 800030e2 <readi>
    80004d6c:	47c1                	li	a5,16
    80004d6e:	00f51b63          	bne	a0,a5,80004d84 <sys_unlink+0x16c>
    if (de.inum != 0) return 0;
    80004d72:	f1845783          	lhu	a5,-232(s0)
    80004d76:	e7a1                	bnez	a5,80004dbe <sys_unlink+0x1a6>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004d78:	29c1                	addiw	s3,s3,16
    80004d7a:	04c92783          	lw	a5,76(s2)
    80004d7e:	fcf9ede3          	bltu	s3,a5,80004d58 <sys_unlink+0x140>
    80004d82:	b781                	j	80004cc2 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004d84:	00004517          	auipc	a0,0x4
    80004d88:	8cc50513          	addi	a0,a0,-1844 # 80008650 <syscalls+0x2c8>
    80004d8c:	00001097          	auipc	ra,0x1
    80004d90:	162080e7          	jalr	354(ra) # 80005eee <panic>
    panic("unlink: writei");
    80004d94:	00004517          	auipc	a0,0x4
    80004d98:	8d450513          	addi	a0,a0,-1836 # 80008668 <syscalls+0x2e0>
    80004d9c:	00001097          	auipc	ra,0x1
    80004da0:	152080e7          	jalr	338(ra) # 80005eee <panic>
    dp->nlink--;
    80004da4:	04a4d783          	lhu	a5,74(s1)
    80004da8:	37fd                	addiw	a5,a5,-1
    80004daa:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004dae:	8526                	mv	a0,s1
    80004db0:	ffffe097          	auipc	ra,0xffffe
    80004db4:	fb4080e7          	jalr	-76(ra) # 80002d64 <iupdate>
    80004db8:	b781                	j	80004cf8 <sys_unlink+0xe0>
  if (argstr(0, path, MAXPATH) < 0) return -1;
    80004dba:	557d                	li	a0,-1
    80004dbc:	a005                	j	80004ddc <sys_unlink+0x1c4>
    iunlockput(ip);
    80004dbe:	854a                	mv	a0,s2
    80004dc0:	ffffe097          	auipc	ra,0xffffe
    80004dc4:	2d0080e7          	jalr	720(ra) # 80003090 <iunlockput>
  iunlockput(dp);
    80004dc8:	8526                	mv	a0,s1
    80004dca:	ffffe097          	auipc	ra,0xffffe
    80004dce:	2c6080e7          	jalr	710(ra) # 80003090 <iunlockput>
  end_op();
    80004dd2:	fffff097          	auipc	ra,0xfffff
    80004dd6:	a9e080e7          	jalr	-1378(ra) # 80003870 <end_op>
  return -1;
    80004dda:	557d                	li	a0,-1
}
    80004ddc:	70ae                	ld	ra,232(sp)
    80004dde:	740e                	ld	s0,224(sp)
    80004de0:	64ee                	ld	s1,216(sp)
    80004de2:	694e                	ld	s2,208(sp)
    80004de4:	69ae                	ld	s3,200(sp)
    80004de6:	616d                	addi	sp,sp,240
    80004de8:	8082                	ret

0000000080004dea <sys_open>:

uint64 sys_open(void) {
    80004dea:	7131                	addi	sp,sp,-192
    80004dec:	fd06                	sd	ra,184(sp)
    80004dee:	f922                	sd	s0,176(sp)
    80004df0:	f526                	sd	s1,168(sp)
    80004df2:	f14a                	sd	s2,160(sp)
    80004df4:	ed4e                	sd	s3,152(sp)
    80004df6:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004df8:	f4c40593          	addi	a1,s0,-180
    80004dfc:	4505                	li	a0,1
    80004dfe:	ffffd097          	auipc	ra,0xffffd
    80004e02:	4b6080e7          	jalr	1206(ra) # 800022b4 <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0) return -1;
    80004e06:	08000613          	li	a2,128
    80004e0a:	f5040593          	addi	a1,s0,-176
    80004e0e:	4501                	li	a0,0
    80004e10:	ffffd097          	auipc	ra,0xffffd
    80004e14:	4e4080e7          	jalr	1252(ra) # 800022f4 <argstr>
    80004e18:	87aa                	mv	a5,a0
    80004e1a:	557d                	li	a0,-1
    80004e1c:	0a07c963          	bltz	a5,80004ece <sys_open+0xe4>

  begin_op();
    80004e20:	fffff097          	auipc	ra,0xfffff
    80004e24:	9d0080e7          	jalr	-1584(ra) # 800037f0 <begin_op>

  if (omode & O_CREATE) {
    80004e28:	f4c42783          	lw	a5,-180(s0)
    80004e2c:	2007f793          	andi	a5,a5,512
    80004e30:	cfc5                	beqz	a5,80004ee8 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004e32:	4681                	li	a3,0
    80004e34:	4601                	li	a2,0
    80004e36:	4589                	li	a1,2
    80004e38:	f5040513          	addi	a0,s0,-176
    80004e3c:	00000097          	auipc	ra,0x0
    80004e40:	976080e7          	jalr	-1674(ra) # 800047b2 <create>
    80004e44:	84aa                	mv	s1,a0
    if (ip == 0) {
    80004e46:	c959                	beqz	a0,80004edc <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    80004e48:	04449703          	lh	a4,68(s1)
    80004e4c:	478d                	li	a5,3
    80004e4e:	00f71763          	bne	a4,a5,80004e5c <sys_open+0x72>
    80004e52:	0464d703          	lhu	a4,70(s1)
    80004e56:	47a5                	li	a5,9
    80004e58:	0ce7ed63          	bltu	a5,a4,80004f32 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80004e5c:	fffff097          	auipc	ra,0xfffff
    80004e60:	da4080e7          	jalr	-604(ra) # 80003c00 <filealloc>
    80004e64:	89aa                	mv	s3,a0
    80004e66:	10050363          	beqz	a0,80004f6c <sys_open+0x182>
    80004e6a:	00000097          	auipc	ra,0x0
    80004e6e:	906080e7          	jalr	-1786(ra) # 80004770 <fdalloc>
    80004e72:	892a                	mv	s2,a0
    80004e74:	0e054763          	bltz	a0,80004f62 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE) {
    80004e78:	04449703          	lh	a4,68(s1)
    80004e7c:	478d                	li	a5,3
    80004e7e:	0cf70563          	beq	a4,a5,80004f48 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004e82:	4789                	li	a5,2
    80004e84:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004e88:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004e8c:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004e90:	f4c42783          	lw	a5,-180(s0)
    80004e94:	0017c713          	xori	a4,a5,1
    80004e98:	8b05                	andi	a4,a4,1
    80004e9a:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e9e:	0037f713          	andi	a4,a5,3
    80004ea2:	00e03733          	snez	a4,a4
    80004ea6:	00e984a3          	sb	a4,9(s3)

  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    80004eaa:	4007f793          	andi	a5,a5,1024
    80004eae:	c791                	beqz	a5,80004eba <sys_open+0xd0>
    80004eb0:	04449703          	lh	a4,68(s1)
    80004eb4:	4789                	li	a5,2
    80004eb6:	0af70063          	beq	a4,a5,80004f56 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004eba:	8526                	mv	a0,s1
    80004ebc:	ffffe097          	auipc	ra,0xffffe
    80004ec0:	034080e7          	jalr	52(ra) # 80002ef0 <iunlock>
  end_op();
    80004ec4:	fffff097          	auipc	ra,0xfffff
    80004ec8:	9ac080e7          	jalr	-1620(ra) # 80003870 <end_op>

  return fd;
    80004ecc:	854a                	mv	a0,s2
}
    80004ece:	70ea                	ld	ra,184(sp)
    80004ed0:	744a                	ld	s0,176(sp)
    80004ed2:	74aa                	ld	s1,168(sp)
    80004ed4:	790a                	ld	s2,160(sp)
    80004ed6:	69ea                	ld	s3,152(sp)
    80004ed8:	6129                	addi	sp,sp,192
    80004eda:	8082                	ret
      end_op();
    80004edc:	fffff097          	auipc	ra,0xfffff
    80004ee0:	994080e7          	jalr	-1644(ra) # 80003870 <end_op>
      return -1;
    80004ee4:	557d                	li	a0,-1
    80004ee6:	b7e5                	j	80004ece <sys_open+0xe4>
    if ((ip = namei(path)) == 0) {
    80004ee8:	f5040513          	addi	a0,s0,-176
    80004eec:	ffffe097          	auipc	ra,0xffffe
    80004ef0:	6e8080e7          	jalr	1768(ra) # 800035d4 <namei>
    80004ef4:	84aa                	mv	s1,a0
    80004ef6:	c905                	beqz	a0,80004f26 <sys_open+0x13c>
    ilock(ip);
    80004ef8:	ffffe097          	auipc	ra,0xffffe
    80004efc:	f36080e7          	jalr	-202(ra) # 80002e2e <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY) {
    80004f00:	04449703          	lh	a4,68(s1)
    80004f04:	4785                	li	a5,1
    80004f06:	f4f711e3          	bne	a4,a5,80004e48 <sys_open+0x5e>
    80004f0a:	f4c42783          	lw	a5,-180(s0)
    80004f0e:	d7b9                	beqz	a5,80004e5c <sys_open+0x72>
      iunlockput(ip);
    80004f10:	8526                	mv	a0,s1
    80004f12:	ffffe097          	auipc	ra,0xffffe
    80004f16:	17e080e7          	jalr	382(ra) # 80003090 <iunlockput>
      end_op();
    80004f1a:	fffff097          	auipc	ra,0xfffff
    80004f1e:	956080e7          	jalr	-1706(ra) # 80003870 <end_op>
      return -1;
    80004f22:	557d                	li	a0,-1
    80004f24:	b76d                	j	80004ece <sys_open+0xe4>
      end_op();
    80004f26:	fffff097          	auipc	ra,0xfffff
    80004f2a:	94a080e7          	jalr	-1718(ra) # 80003870 <end_op>
      return -1;
    80004f2e:	557d                	li	a0,-1
    80004f30:	bf79                	j	80004ece <sys_open+0xe4>
    iunlockput(ip);
    80004f32:	8526                	mv	a0,s1
    80004f34:	ffffe097          	auipc	ra,0xffffe
    80004f38:	15c080e7          	jalr	348(ra) # 80003090 <iunlockput>
    end_op();
    80004f3c:	fffff097          	auipc	ra,0xfffff
    80004f40:	934080e7          	jalr	-1740(ra) # 80003870 <end_op>
    return -1;
    80004f44:	557d                	li	a0,-1
    80004f46:	b761                	j	80004ece <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004f48:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004f4c:	04649783          	lh	a5,70(s1)
    80004f50:	02f99223          	sh	a5,36(s3)
    80004f54:	bf25                	j	80004e8c <sys_open+0xa2>
    itrunc(ip);
    80004f56:	8526                	mv	a0,s1
    80004f58:	ffffe097          	auipc	ra,0xffffe
    80004f5c:	fe4080e7          	jalr	-28(ra) # 80002f3c <itrunc>
    80004f60:	bfa9                	j	80004eba <sys_open+0xd0>
    if (f) fileclose(f);
    80004f62:	854e                	mv	a0,s3
    80004f64:	fffff097          	auipc	ra,0xfffff
    80004f68:	d58080e7          	jalr	-680(ra) # 80003cbc <fileclose>
    iunlockput(ip);
    80004f6c:	8526                	mv	a0,s1
    80004f6e:	ffffe097          	auipc	ra,0xffffe
    80004f72:	122080e7          	jalr	290(ra) # 80003090 <iunlockput>
    end_op();
    80004f76:	fffff097          	auipc	ra,0xfffff
    80004f7a:	8fa080e7          	jalr	-1798(ra) # 80003870 <end_op>
    return -1;
    80004f7e:	557d                	li	a0,-1
    80004f80:	b7b9                	j	80004ece <sys_open+0xe4>

0000000080004f82 <sys_mkdir>:

uint64 sys_mkdir(void) {
    80004f82:	7175                	addi	sp,sp,-144
    80004f84:	e506                	sd	ra,136(sp)
    80004f86:	e122                	sd	s0,128(sp)
    80004f88:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004f8a:	fffff097          	auipc	ra,0xfffff
    80004f8e:	866080e7          	jalr	-1946(ra) # 800037f0 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    80004f92:	08000613          	li	a2,128
    80004f96:	f7040593          	addi	a1,s0,-144
    80004f9a:	4501                	li	a0,0
    80004f9c:	ffffd097          	auipc	ra,0xffffd
    80004fa0:	358080e7          	jalr	856(ra) # 800022f4 <argstr>
    80004fa4:	02054963          	bltz	a0,80004fd6 <sys_mkdir+0x54>
    80004fa8:	4681                	li	a3,0
    80004faa:	4601                	li	a2,0
    80004fac:	4585                	li	a1,1
    80004fae:	f7040513          	addi	a0,s0,-144
    80004fb2:	00000097          	auipc	ra,0x0
    80004fb6:	800080e7          	jalr	-2048(ra) # 800047b2 <create>
    80004fba:	cd11                	beqz	a0,80004fd6 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004fbc:	ffffe097          	auipc	ra,0xffffe
    80004fc0:	0d4080e7          	jalr	212(ra) # 80003090 <iunlockput>
  end_op();
    80004fc4:	fffff097          	auipc	ra,0xfffff
    80004fc8:	8ac080e7          	jalr	-1876(ra) # 80003870 <end_op>
  return 0;
    80004fcc:	4501                	li	a0,0
}
    80004fce:	60aa                	ld	ra,136(sp)
    80004fd0:	640a                	ld	s0,128(sp)
    80004fd2:	6149                	addi	sp,sp,144
    80004fd4:	8082                	ret
    end_op();
    80004fd6:	fffff097          	auipc	ra,0xfffff
    80004fda:	89a080e7          	jalr	-1894(ra) # 80003870 <end_op>
    return -1;
    80004fde:	557d                	li	a0,-1
    80004fe0:	b7fd                	j	80004fce <sys_mkdir+0x4c>

0000000080004fe2 <sys_mknod>:

uint64 sys_mknod(void) {
    80004fe2:	7135                	addi	sp,sp,-160
    80004fe4:	ed06                	sd	ra,152(sp)
    80004fe6:	e922                	sd	s0,144(sp)
    80004fe8:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004fea:	fffff097          	auipc	ra,0xfffff
    80004fee:	806080e7          	jalr	-2042(ra) # 800037f0 <begin_op>
  argint(1, &major);
    80004ff2:	f6c40593          	addi	a1,s0,-148
    80004ff6:	4505                	li	a0,1
    80004ff8:	ffffd097          	auipc	ra,0xffffd
    80004ffc:	2bc080e7          	jalr	700(ra) # 800022b4 <argint>
  argint(2, &minor);
    80005000:	f6840593          	addi	a1,s0,-152
    80005004:	4509                	li	a0,2
    80005006:	ffffd097          	auipc	ra,0xffffd
    8000500a:	2ae080e7          	jalr	686(ra) # 800022b4 <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    8000500e:	08000613          	li	a2,128
    80005012:	f7040593          	addi	a1,s0,-144
    80005016:	4501                	li	a0,0
    80005018:	ffffd097          	auipc	ra,0xffffd
    8000501c:	2dc080e7          	jalr	732(ra) # 800022f4 <argstr>
    80005020:	02054b63          	bltz	a0,80005056 <sys_mknod+0x74>
      (ip = create(path, T_DEVICE, major, minor)) == 0) {
    80005024:	f6841683          	lh	a3,-152(s0)
    80005028:	f6c41603          	lh	a2,-148(s0)
    8000502c:	458d                	li	a1,3
    8000502e:	f7040513          	addi	a0,s0,-144
    80005032:	fffff097          	auipc	ra,0xfffff
    80005036:	780080e7          	jalr	1920(ra) # 800047b2 <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    8000503a:	cd11                	beqz	a0,80005056 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000503c:	ffffe097          	auipc	ra,0xffffe
    80005040:	054080e7          	jalr	84(ra) # 80003090 <iunlockput>
  end_op();
    80005044:	fffff097          	auipc	ra,0xfffff
    80005048:	82c080e7          	jalr	-2004(ra) # 80003870 <end_op>
  return 0;
    8000504c:	4501                	li	a0,0
}
    8000504e:	60ea                	ld	ra,152(sp)
    80005050:	644a                	ld	s0,144(sp)
    80005052:	610d                	addi	sp,sp,160
    80005054:	8082                	ret
    end_op();
    80005056:	fffff097          	auipc	ra,0xfffff
    8000505a:	81a080e7          	jalr	-2022(ra) # 80003870 <end_op>
    return -1;
    8000505e:	557d                	li	a0,-1
    80005060:	b7fd                	j	8000504e <sys_mknod+0x6c>

0000000080005062 <sys_chdir>:

uint64 sys_chdir(void) {
    80005062:	7135                	addi	sp,sp,-160
    80005064:	ed06                	sd	ra,152(sp)
    80005066:	e922                	sd	s0,144(sp)
    80005068:	e526                	sd	s1,136(sp)
    8000506a:	e14a                	sd	s2,128(sp)
    8000506c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000506e:	ffffc097          	auipc	ra,0xffffc
    80005072:	0f6080e7          	jalr	246(ra) # 80001164 <myproc>
    80005076:	892a                	mv	s2,a0

  begin_op();
    80005078:	ffffe097          	auipc	ra,0xffffe
    8000507c:	778080e7          	jalr	1912(ra) # 800037f0 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    80005080:	08000613          	li	a2,128
    80005084:	f6040593          	addi	a1,s0,-160
    80005088:	4501                	li	a0,0
    8000508a:	ffffd097          	auipc	ra,0xffffd
    8000508e:	26a080e7          	jalr	618(ra) # 800022f4 <argstr>
    80005092:	04054b63          	bltz	a0,800050e8 <sys_chdir+0x86>
    80005096:	f6040513          	addi	a0,s0,-160
    8000509a:	ffffe097          	auipc	ra,0xffffe
    8000509e:	53a080e7          	jalr	1338(ra) # 800035d4 <namei>
    800050a2:	84aa                	mv	s1,a0
    800050a4:	c131                	beqz	a0,800050e8 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    800050a6:	ffffe097          	auipc	ra,0xffffe
    800050aa:	d88080e7          	jalr	-632(ra) # 80002e2e <ilock>
  if (ip->type != T_DIR) {
    800050ae:	04449703          	lh	a4,68(s1)
    800050b2:	4785                	li	a5,1
    800050b4:	04f71063          	bne	a4,a5,800050f4 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800050b8:	8526                	mv	a0,s1
    800050ba:	ffffe097          	auipc	ra,0xffffe
    800050be:	e36080e7          	jalr	-458(ra) # 80002ef0 <iunlock>
  iput(p->cwd);
    800050c2:	15093503          	ld	a0,336(s2)
    800050c6:	ffffe097          	auipc	ra,0xffffe
    800050ca:	f22080e7          	jalr	-222(ra) # 80002fe8 <iput>
  end_op();
    800050ce:	ffffe097          	auipc	ra,0xffffe
    800050d2:	7a2080e7          	jalr	1954(ra) # 80003870 <end_op>
  p->cwd = ip;
    800050d6:	14993823          	sd	s1,336(s2)
  return 0;
    800050da:	4501                	li	a0,0
}
    800050dc:	60ea                	ld	ra,152(sp)
    800050de:	644a                	ld	s0,144(sp)
    800050e0:	64aa                	ld	s1,136(sp)
    800050e2:	690a                	ld	s2,128(sp)
    800050e4:	610d                	addi	sp,sp,160
    800050e6:	8082                	ret
    end_op();
    800050e8:	ffffe097          	auipc	ra,0xffffe
    800050ec:	788080e7          	jalr	1928(ra) # 80003870 <end_op>
    return -1;
    800050f0:	557d                	li	a0,-1
    800050f2:	b7ed                	j	800050dc <sys_chdir+0x7a>
    iunlockput(ip);
    800050f4:	8526                	mv	a0,s1
    800050f6:	ffffe097          	auipc	ra,0xffffe
    800050fa:	f9a080e7          	jalr	-102(ra) # 80003090 <iunlockput>
    end_op();
    800050fe:	ffffe097          	auipc	ra,0xffffe
    80005102:	772080e7          	jalr	1906(ra) # 80003870 <end_op>
    return -1;
    80005106:	557d                	li	a0,-1
    80005108:	bfd1                	j	800050dc <sys_chdir+0x7a>

000000008000510a <sys_exec>:

uint64 sys_exec(void) {
    8000510a:	7145                	addi	sp,sp,-464
    8000510c:	e786                	sd	ra,456(sp)
    8000510e:	e3a2                	sd	s0,448(sp)
    80005110:	ff26                	sd	s1,440(sp)
    80005112:	fb4a                	sd	s2,432(sp)
    80005114:	f74e                	sd	s3,424(sp)
    80005116:	f352                	sd	s4,416(sp)
    80005118:	ef56                	sd	s5,408(sp)
    8000511a:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000511c:	e3840593          	addi	a1,s0,-456
    80005120:	4505                	li	a0,1
    80005122:	ffffd097          	auipc	ra,0xffffd
    80005126:	1b2080e7          	jalr	434(ra) # 800022d4 <argaddr>
  if (argstr(0, path, MAXPATH) < 0) {
    8000512a:	08000613          	li	a2,128
    8000512e:	f4040593          	addi	a1,s0,-192
    80005132:	4501                	li	a0,0
    80005134:	ffffd097          	auipc	ra,0xffffd
    80005138:	1c0080e7          	jalr	448(ra) # 800022f4 <argstr>
    8000513c:	87aa                	mv	a5,a0
    return -1;
    8000513e:	557d                	li	a0,-1
  if (argstr(0, path, MAXPATH) < 0) {
    80005140:	0c07c263          	bltz	a5,80005204 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005144:	10000613          	li	a2,256
    80005148:	4581                	li	a1,0
    8000514a:	e4040513          	addi	a0,s0,-448
    8000514e:	ffffb097          	auipc	ra,0xffffb
    80005152:	154080e7          	jalr	340(ra) # 800002a2 <memset>
  for (i = 0;; i++) {
    if (i >= NELEM(argv)) {
    80005156:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    8000515a:	89a6                	mv	s3,s1
    8000515c:	4901                	li	s2,0
    if (i >= NELEM(argv)) {
    8000515e:	02000a13          	li	s4,32
    80005162:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    80005166:	00391793          	slli	a5,s2,0x3
    8000516a:	e3040593          	addi	a1,s0,-464
    8000516e:	e3843503          	ld	a0,-456(s0)
    80005172:	953e                	add	a0,a0,a5
    80005174:	ffffd097          	auipc	ra,0xffffd
    80005178:	0a2080e7          	jalr	162(ra) # 80002216 <fetchaddr>
    8000517c:	02054a63          	bltz	a0,800051b0 <sys_exec+0xa6>
      goto bad;
    }
    if (uarg == 0) {
    80005180:	e3043783          	ld	a5,-464(s0)
    80005184:	c3b9                	beqz	a5,800051ca <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005186:	ffffb097          	auipc	ra,0xffffb
    8000518a:	0a6080e7          	jalr	166(ra) # 8000022c <kalloc>
    8000518e:	85aa                	mv	a1,a0
    80005190:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0) goto bad;
    80005194:	cd11                	beqz	a0,800051b0 <sys_exec+0xa6>
    if (fetchstr(uarg, argv[i], PGSIZE) < 0) goto bad;
    80005196:	6605                	lui	a2,0x1
    80005198:	e3043503          	ld	a0,-464(s0)
    8000519c:	ffffd097          	auipc	ra,0xffffd
    800051a0:	0cc080e7          	jalr	204(ra) # 80002268 <fetchstr>
    800051a4:	00054663          	bltz	a0,800051b0 <sys_exec+0xa6>
    if (i >= NELEM(argv)) {
    800051a8:	0905                	addi	s2,s2,1
    800051aa:	09a1                	addi	s3,s3,8
    800051ac:	fb491be3          	bne	s2,s4,80005162 <sys_exec+0x58>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);
    800051b0:	10048913          	addi	s2,s1,256
    800051b4:	6088                	ld	a0,0(s1)
    800051b6:	c531                	beqz	a0,80005202 <sys_exec+0xf8>
    800051b8:	ffffb097          	auipc	ra,0xffffb
    800051bc:	f6c080e7          	jalr	-148(ra) # 80000124 <kfree>
    800051c0:	04a1                	addi	s1,s1,8
    800051c2:	ff2499e3          	bne	s1,s2,800051b4 <sys_exec+0xaa>
  return -1;
    800051c6:	557d                	li	a0,-1
    800051c8:	a835                	j	80005204 <sys_exec+0xfa>
      argv[i] = 0;
    800051ca:	0a8e                	slli	s5,s5,0x3
    800051cc:	fc040793          	addi	a5,s0,-64
    800051d0:	9abe                	add	s5,s5,a5
    800051d2:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800051d6:	e4040593          	addi	a1,s0,-448
    800051da:	f4040513          	addi	a0,s0,-192
    800051de:	fffff097          	auipc	ra,0xfffff
    800051e2:	158080e7          	jalr	344(ra) # 80004336 <exec>
    800051e6:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);
    800051e8:	10048993          	addi	s3,s1,256
    800051ec:	6088                	ld	a0,0(s1)
    800051ee:	c901                	beqz	a0,800051fe <sys_exec+0xf4>
    800051f0:	ffffb097          	auipc	ra,0xffffb
    800051f4:	f34080e7          	jalr	-204(ra) # 80000124 <kfree>
    800051f8:	04a1                	addi	s1,s1,8
    800051fa:	ff3499e3          	bne	s1,s3,800051ec <sys_exec+0xe2>
  return ret;
    800051fe:	854a                	mv	a0,s2
    80005200:	a011                	j	80005204 <sys_exec+0xfa>
  return -1;
    80005202:	557d                	li	a0,-1
}
    80005204:	60be                	ld	ra,456(sp)
    80005206:	641e                	ld	s0,448(sp)
    80005208:	74fa                	ld	s1,440(sp)
    8000520a:	795a                	ld	s2,432(sp)
    8000520c:	79ba                	ld	s3,424(sp)
    8000520e:	7a1a                	ld	s4,416(sp)
    80005210:	6afa                	ld	s5,408(sp)
    80005212:	6179                	addi	sp,sp,464
    80005214:	8082                	ret

0000000080005216 <sys_pipe>:

uint64 sys_pipe(void) {
    80005216:	7139                	addi	sp,sp,-64
    80005218:	fc06                	sd	ra,56(sp)
    8000521a:	f822                	sd	s0,48(sp)
    8000521c:	f426                	sd	s1,40(sp)
    8000521e:	0080                	addi	s0,sp,64
  uint64 fdarray;  // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005220:	ffffc097          	auipc	ra,0xffffc
    80005224:	f44080e7          	jalr	-188(ra) # 80001164 <myproc>
    80005228:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000522a:	fd840593          	addi	a1,s0,-40
    8000522e:	4501                	li	a0,0
    80005230:	ffffd097          	auipc	ra,0xffffd
    80005234:	0a4080e7          	jalr	164(ra) # 800022d4 <argaddr>
  if (pipealloc(&rf, &wf) < 0) return -1;
    80005238:	fc840593          	addi	a1,s0,-56
    8000523c:	fd040513          	addi	a0,s0,-48
    80005240:	fffff097          	auipc	ra,0xfffff
    80005244:	dac080e7          	jalr	-596(ra) # 80003fec <pipealloc>
    80005248:	57fd                	li	a5,-1
    8000524a:	0c054463          	bltz	a0,80005312 <sys_pipe+0xfc>
  fd0 = -1;
    8000524e:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    80005252:	fd043503          	ld	a0,-48(s0)
    80005256:	fffff097          	auipc	ra,0xfffff
    8000525a:	51a080e7          	jalr	1306(ra) # 80004770 <fdalloc>
    8000525e:	fca42223          	sw	a0,-60(s0)
    80005262:	08054b63          	bltz	a0,800052f8 <sys_pipe+0xe2>
    80005266:	fc843503          	ld	a0,-56(s0)
    8000526a:	fffff097          	auipc	ra,0xfffff
    8000526e:	506080e7          	jalr	1286(ra) # 80004770 <fdalloc>
    80005272:	fca42023          	sw	a0,-64(s0)
    80005276:	06054863          	bltz	a0,800052e6 <sys_pipe+0xd0>
    if (fd0 >= 0) p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    8000527a:	4691                	li	a3,4
    8000527c:	fc440613          	addi	a2,s0,-60
    80005280:	fd843583          	ld	a1,-40(s0)
    80005284:	68a8                	ld	a0,80(s1)
    80005286:	ffffc097          	auipc	ra,0xffffc
    8000528a:	a26080e7          	jalr	-1498(ra) # 80000cac <copyout>
    8000528e:	02054063          	bltz	a0,800052ae <sys_pipe+0x98>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) <
    80005292:	4691                	li	a3,4
    80005294:	fc040613          	addi	a2,s0,-64
    80005298:	fd843583          	ld	a1,-40(s0)
    8000529c:	0591                	addi	a1,a1,4
    8000529e:	68a8                	ld	a0,80(s1)
    800052a0:	ffffc097          	auipc	ra,0xffffc
    800052a4:	a0c080e7          	jalr	-1524(ra) # 80000cac <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800052a8:	4781                	li	a5,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800052aa:	06055463          	bgez	a0,80005312 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800052ae:	fc442783          	lw	a5,-60(s0)
    800052b2:	07e9                	addi	a5,a5,26
    800052b4:	078e                	slli	a5,a5,0x3
    800052b6:	97a6                	add	a5,a5,s1
    800052b8:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800052bc:	fc042503          	lw	a0,-64(s0)
    800052c0:	0569                	addi	a0,a0,26
    800052c2:	050e                	slli	a0,a0,0x3
    800052c4:	94aa                	add	s1,s1,a0
    800052c6:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800052ca:	fd043503          	ld	a0,-48(s0)
    800052ce:	fffff097          	auipc	ra,0xfffff
    800052d2:	9ee080e7          	jalr	-1554(ra) # 80003cbc <fileclose>
    fileclose(wf);
    800052d6:	fc843503          	ld	a0,-56(s0)
    800052da:	fffff097          	auipc	ra,0xfffff
    800052de:	9e2080e7          	jalr	-1566(ra) # 80003cbc <fileclose>
    return -1;
    800052e2:	57fd                	li	a5,-1
    800052e4:	a03d                	j	80005312 <sys_pipe+0xfc>
    if (fd0 >= 0) p->ofile[fd0] = 0;
    800052e6:	fc442783          	lw	a5,-60(s0)
    800052ea:	0007c763          	bltz	a5,800052f8 <sys_pipe+0xe2>
    800052ee:	07e9                	addi	a5,a5,26
    800052f0:	078e                	slli	a5,a5,0x3
    800052f2:	94be                	add	s1,s1,a5
    800052f4:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800052f8:	fd043503          	ld	a0,-48(s0)
    800052fc:	fffff097          	auipc	ra,0xfffff
    80005300:	9c0080e7          	jalr	-1600(ra) # 80003cbc <fileclose>
    fileclose(wf);
    80005304:	fc843503          	ld	a0,-56(s0)
    80005308:	fffff097          	auipc	ra,0xfffff
    8000530c:	9b4080e7          	jalr	-1612(ra) # 80003cbc <fileclose>
    return -1;
    80005310:	57fd                	li	a5,-1
}
    80005312:	853e                	mv	a0,a5
    80005314:	70e2                	ld	ra,56(sp)
    80005316:	7442                	ld	s0,48(sp)
    80005318:	74a2                	ld	s1,40(sp)
    8000531a:	6121                	addi	sp,sp,64
    8000531c:	8082                	ret
	...

0000000080005320 <kernelvec>:
    80005320:	7111                	addi	sp,sp,-256
    80005322:	e006                	sd	ra,0(sp)
    80005324:	e40a                	sd	sp,8(sp)
    80005326:	e80e                	sd	gp,16(sp)
    80005328:	ec12                	sd	tp,24(sp)
    8000532a:	f016                	sd	t0,32(sp)
    8000532c:	f41a                	sd	t1,40(sp)
    8000532e:	f81e                	sd	t2,48(sp)
    80005330:	fc22                	sd	s0,56(sp)
    80005332:	e0a6                	sd	s1,64(sp)
    80005334:	e4aa                	sd	a0,72(sp)
    80005336:	e8ae                	sd	a1,80(sp)
    80005338:	ecb2                	sd	a2,88(sp)
    8000533a:	f0b6                	sd	a3,96(sp)
    8000533c:	f4ba                	sd	a4,104(sp)
    8000533e:	f8be                	sd	a5,112(sp)
    80005340:	fcc2                	sd	a6,120(sp)
    80005342:	e146                	sd	a7,128(sp)
    80005344:	e54a                	sd	s2,136(sp)
    80005346:	e94e                	sd	s3,144(sp)
    80005348:	ed52                	sd	s4,152(sp)
    8000534a:	f156                	sd	s5,160(sp)
    8000534c:	f55a                	sd	s6,168(sp)
    8000534e:	f95e                	sd	s7,176(sp)
    80005350:	fd62                	sd	s8,184(sp)
    80005352:	e1e6                	sd	s9,192(sp)
    80005354:	e5ea                	sd	s10,200(sp)
    80005356:	e9ee                	sd	s11,208(sp)
    80005358:	edf2                	sd	t3,216(sp)
    8000535a:	f1f6                	sd	t4,224(sp)
    8000535c:	f5fa                	sd	t5,232(sp)
    8000535e:	f9fe                	sd	t6,240(sp)
    80005360:	d83fc0ef          	jal	ra,800020e2 <kerneltrap>
    80005364:	6082                	ld	ra,0(sp)
    80005366:	6122                	ld	sp,8(sp)
    80005368:	61c2                	ld	gp,16(sp)
    8000536a:	7282                	ld	t0,32(sp)
    8000536c:	7322                	ld	t1,40(sp)
    8000536e:	73c2                	ld	t2,48(sp)
    80005370:	7462                	ld	s0,56(sp)
    80005372:	6486                	ld	s1,64(sp)
    80005374:	6526                	ld	a0,72(sp)
    80005376:	65c6                	ld	a1,80(sp)
    80005378:	6666                	ld	a2,88(sp)
    8000537a:	7686                	ld	a3,96(sp)
    8000537c:	7726                	ld	a4,104(sp)
    8000537e:	77c6                	ld	a5,112(sp)
    80005380:	7866                	ld	a6,120(sp)
    80005382:	688a                	ld	a7,128(sp)
    80005384:	692a                	ld	s2,136(sp)
    80005386:	69ca                	ld	s3,144(sp)
    80005388:	6a6a                	ld	s4,152(sp)
    8000538a:	7a8a                	ld	s5,160(sp)
    8000538c:	7b2a                	ld	s6,168(sp)
    8000538e:	7bca                	ld	s7,176(sp)
    80005390:	7c6a                	ld	s8,184(sp)
    80005392:	6c8e                	ld	s9,192(sp)
    80005394:	6d2e                	ld	s10,200(sp)
    80005396:	6dce                	ld	s11,208(sp)
    80005398:	6e6e                	ld	t3,216(sp)
    8000539a:	7e8e                	ld	t4,224(sp)
    8000539c:	7f2e                	ld	t5,232(sp)
    8000539e:	7fce                	ld	t6,240(sp)
    800053a0:	6111                	addi	sp,sp,256
    800053a2:	10200073          	sret
    800053a6:	00000013          	nop
    800053aa:	00000013          	nop
    800053ae:	0001                	nop

00000000800053b0 <timervec>:
    800053b0:	34051573          	csrrw	a0,mscratch,a0
    800053b4:	e10c                	sd	a1,0(a0)
    800053b6:	e510                	sd	a2,8(a0)
    800053b8:	e914                	sd	a3,16(a0)
    800053ba:	6d0c                	ld	a1,24(a0)
    800053bc:	7110                	ld	a2,32(a0)
    800053be:	6194                	ld	a3,0(a1)
    800053c0:	96b2                	add	a3,a3,a2
    800053c2:	e194                	sd	a3,0(a1)
    800053c4:	4589                	li	a1,2
    800053c6:	14459073          	csrw	sip,a1
    800053ca:	6914                	ld	a3,16(a0)
    800053cc:	6510                	ld	a2,8(a0)
    800053ce:	610c                	ld	a1,0(a0)
    800053d0:	34051573          	csrrw	a0,mscratch,a0
    800053d4:	30200073          	mret
	...

00000000800053da <plicinit>:

//
// the riscv Platform Level Interrupt Controller (PLIC).
//

void plicinit(void) {
    800053da:	1141                	addi	sp,sp,-16
    800053dc:	e422                	sd	s0,8(sp)
    800053de:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ * 4) = 1;
    800053e0:	0c0007b7          	lui	a5,0xc000
    800053e4:	4705                	li	a4,1
    800053e6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ * 4) = 1;
    800053e8:	c3d8                	sw	a4,4(a5)
}
    800053ea:	6422                	ld	s0,8(sp)
    800053ec:	0141                	addi	sp,sp,16
    800053ee:	8082                	ret

00000000800053f0 <plicinithart>:

void plicinithart(void) {
    800053f0:	1141                	addi	sp,sp,-16
    800053f2:	e406                	sd	ra,8(sp)
    800053f4:	e022                	sd	s0,0(sp)
    800053f6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053f8:	ffffc097          	auipc	ra,0xffffc
    800053fc:	d40080e7          	jalr	-704(ra) # 80001138 <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005400:	0085171b          	slliw	a4,a0,0x8
    80005404:	0c0027b7          	lui	a5,0xc002
    80005408:	97ba                	add	a5,a5,a4
    8000540a:	40200713          	li	a4,1026
    8000540e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005412:	00d5151b          	slliw	a0,a0,0xd
    80005416:	0c2017b7          	lui	a5,0xc201
    8000541a:	953e                	add	a0,a0,a5
    8000541c:	00052023          	sw	zero,0(a0)
}
    80005420:	60a2                	ld	ra,8(sp)
    80005422:	6402                	ld	s0,0(sp)
    80005424:	0141                	addi	sp,sp,16
    80005426:	8082                	ret

0000000080005428 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int plic_claim(void) {
    80005428:	1141                	addi	sp,sp,-16
    8000542a:	e406                	sd	ra,8(sp)
    8000542c:	e022                	sd	s0,0(sp)
    8000542e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005430:	ffffc097          	auipc	ra,0xffffc
    80005434:	d08080e7          	jalr	-760(ra) # 80001138 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005438:	00d5179b          	slliw	a5,a0,0xd
    8000543c:	0c201537          	lui	a0,0xc201
    80005440:	953e                	add	a0,a0,a5
  return irq;
}
    80005442:	4148                	lw	a0,4(a0)
    80005444:	60a2                	ld	ra,8(sp)
    80005446:	6402                	ld	s0,0(sp)
    80005448:	0141                	addi	sp,sp,16
    8000544a:	8082                	ret

000000008000544c <plic_complete>:

// tell the PLIC we've served this IRQ.
void plic_complete(int irq) {
    8000544c:	1101                	addi	sp,sp,-32
    8000544e:	ec06                	sd	ra,24(sp)
    80005450:	e822                	sd	s0,16(sp)
    80005452:	e426                	sd	s1,8(sp)
    80005454:	1000                	addi	s0,sp,32
    80005456:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005458:	ffffc097          	auipc	ra,0xffffc
    8000545c:	ce0080e7          	jalr	-800(ra) # 80001138 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005460:	00d5151b          	slliw	a0,a0,0xd
    80005464:	0c2017b7          	lui	a5,0xc201
    80005468:	97aa                	add	a5,a5,a0
    8000546a:	c3c4                	sw	s1,4(a5)
}
    8000546c:	60e2                	ld	ra,24(sp)
    8000546e:	6442                	ld	s0,16(sp)
    80005470:	64a2                	ld	s1,8(sp)
    80005472:	6105                	addi	sp,sp,32
    80005474:	8082                	ret

0000000080005476 <free_desc>:
  }
  return -1;
}

// mark a descriptor as free.
static void free_desc(int i) {
    80005476:	1141                	addi	sp,sp,-16
    80005478:	e406                	sd	ra,8(sp)
    8000547a:	e022                	sd	s0,0(sp)
    8000547c:	0800                	addi	s0,sp,16
  if (i >= NUM) panic("free_desc 1");
    8000547e:	479d                	li	a5,7
    80005480:	04a7cc63          	blt	a5,a0,800054d8 <free_desc+0x62>
  if (disk.free[i]) panic("free_desc 2");
    80005484:	00034797          	auipc	a5,0x34
    80005488:	4ec78793          	addi	a5,a5,1260 # 80039970 <disk>
    8000548c:	97aa                	add	a5,a5,a0
    8000548e:	0187c783          	lbu	a5,24(a5)
    80005492:	ebb9                	bnez	a5,800054e8 <free_desc+0x72>
  disk.desc[i].addr = 0;
    80005494:	00451613          	slli	a2,a0,0x4
    80005498:	00034797          	auipc	a5,0x34
    8000549c:	4d878793          	addi	a5,a5,1240 # 80039970 <disk>
    800054a0:	6394                	ld	a3,0(a5)
    800054a2:	96b2                	add	a3,a3,a2
    800054a4:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800054a8:	6398                	ld	a4,0(a5)
    800054aa:	9732                	add	a4,a4,a2
    800054ac:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800054b0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800054b4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800054b8:	953e                	add	a0,a0,a5
    800054ba:	4785                	li	a5,1
    800054bc:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    800054c0:	00034517          	auipc	a0,0x34
    800054c4:	4c850513          	addi	a0,a0,1224 # 80039988 <disk+0x18>
    800054c8:	ffffc097          	auipc	ra,0xffffc
    800054cc:	3ac080e7          	jalr	940(ra) # 80001874 <wakeup>
}
    800054d0:	60a2                	ld	ra,8(sp)
    800054d2:	6402                	ld	s0,0(sp)
    800054d4:	0141                	addi	sp,sp,16
    800054d6:	8082                	ret
  if (i >= NUM) panic("free_desc 1");
    800054d8:	00003517          	auipc	a0,0x3
    800054dc:	1a050513          	addi	a0,a0,416 # 80008678 <syscalls+0x2f0>
    800054e0:	00001097          	auipc	ra,0x1
    800054e4:	a0e080e7          	jalr	-1522(ra) # 80005eee <panic>
  if (disk.free[i]) panic("free_desc 2");
    800054e8:	00003517          	auipc	a0,0x3
    800054ec:	1a050513          	addi	a0,a0,416 # 80008688 <syscalls+0x300>
    800054f0:	00001097          	auipc	ra,0x1
    800054f4:	9fe080e7          	jalr	-1538(ra) # 80005eee <panic>

00000000800054f8 <virtio_disk_init>:
void virtio_disk_init(void) {
    800054f8:	1101                	addi	sp,sp,-32
    800054fa:	ec06                	sd	ra,24(sp)
    800054fc:	e822                	sd	s0,16(sp)
    800054fe:	e426                	sd	s1,8(sp)
    80005500:	e04a                	sd	s2,0(sp)
    80005502:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005504:	00003597          	auipc	a1,0x3
    80005508:	19458593          	addi	a1,a1,404 # 80008698 <syscalls+0x310>
    8000550c:	00034517          	auipc	a0,0x34
    80005510:	58c50513          	addi	a0,a0,1420 # 80039a98 <disk+0x128>
    80005514:	00001097          	auipc	ra,0x1
    80005518:	e86080e7          	jalr	-378(ra) # 8000639a <initlock>
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000551c:	100017b7          	lui	a5,0x10001
    80005520:	4398                	lw	a4,0(a5)
    80005522:	2701                	sext.w	a4,a4
    80005524:	747277b7          	lui	a5,0x74727
    80005528:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000552c:	14f71c63          	bne	a4,a5,80005684 <virtio_disk_init+0x18c>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005530:	100017b7          	lui	a5,0x10001
    80005534:	43dc                	lw	a5,4(a5)
    80005536:	2781                	sext.w	a5,a5
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005538:	4709                	li	a4,2
    8000553a:	14e79563          	bne	a5,a4,80005684 <virtio_disk_init+0x18c>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000553e:	100017b7          	lui	a5,0x10001
    80005542:	479c                	lw	a5,8(a5)
    80005544:	2781                	sext.w	a5,a5
    80005546:	12e79f63          	bne	a5,a4,80005684 <virtio_disk_init+0x18c>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    8000554a:	100017b7          	lui	a5,0x10001
    8000554e:	47d8                	lw	a4,12(a5)
    80005550:	2701                	sext.w	a4,a4
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005552:	554d47b7          	lui	a5,0x554d4
    80005556:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000555a:	12f71563          	bne	a4,a5,80005684 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000555e:	100017b7          	lui	a5,0x10001
    80005562:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005566:	4705                	li	a4,1
    80005568:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000556a:	470d                	li	a4,3
    8000556c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000556e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005570:	c7ffe737          	lui	a4,0xc7ffe
    80005574:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fbca6f>
    80005578:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000557a:	2701                	sext.w	a4,a4
    8000557c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000557e:	472d                	li	a4,11
    80005580:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005582:	5bbc                	lw	a5,112(a5)
    80005584:	0007891b          	sext.w	s2,a5
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005588:	8ba1                	andi	a5,a5,8
    8000558a:	10078563          	beqz	a5,80005694 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000558e:	100017b7          	lui	a5,0x10001
    80005592:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if (*R(VIRTIO_MMIO_QUEUE_READY)) panic("virtio disk should not be ready");
    80005596:	43fc                	lw	a5,68(a5)
    80005598:	2781                	sext.w	a5,a5
    8000559a:	10079563          	bnez	a5,800056a4 <virtio_disk_init+0x1ac>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000559e:	100017b7          	lui	a5,0x10001
    800055a2:	5bdc                	lw	a5,52(a5)
    800055a4:	2781                	sext.w	a5,a5
  if (max == 0) panic("virtio disk has no queue 0");
    800055a6:	10078763          	beqz	a5,800056b4 <virtio_disk_init+0x1bc>
  if (max < NUM) panic("virtio disk max queue too short");
    800055aa:	471d                	li	a4,7
    800055ac:	10f77c63          	bgeu	a4,a5,800056c4 <virtio_disk_init+0x1cc>
  disk.desc = kalloc();
    800055b0:	ffffb097          	auipc	ra,0xffffb
    800055b4:	c7c080e7          	jalr	-900(ra) # 8000022c <kalloc>
    800055b8:	00034497          	auipc	s1,0x34
    800055bc:	3b848493          	addi	s1,s1,952 # 80039970 <disk>
    800055c0:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800055c2:	ffffb097          	auipc	ra,0xffffb
    800055c6:	c6a080e7          	jalr	-918(ra) # 8000022c <kalloc>
    800055ca:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800055cc:	ffffb097          	auipc	ra,0xffffb
    800055d0:	c60080e7          	jalr	-928(ra) # 8000022c <kalloc>
    800055d4:	87aa                	mv	a5,a0
    800055d6:	e888                	sd	a0,16(s1)
  if (!disk.desc || !disk.avail || !disk.used) panic("virtio disk kalloc");
    800055d8:	6088                	ld	a0,0(s1)
    800055da:	cd6d                	beqz	a0,800056d4 <virtio_disk_init+0x1dc>
    800055dc:	00034717          	auipc	a4,0x34
    800055e0:	39c73703          	ld	a4,924(a4) # 80039978 <disk+0x8>
    800055e4:	cb65                	beqz	a4,800056d4 <virtio_disk_init+0x1dc>
    800055e6:	c7fd                	beqz	a5,800056d4 <virtio_disk_init+0x1dc>
  memset(disk.desc, 0, PGSIZE);
    800055e8:	6605                	lui	a2,0x1
    800055ea:	4581                	li	a1,0
    800055ec:	ffffb097          	auipc	ra,0xffffb
    800055f0:	cb6080e7          	jalr	-842(ra) # 800002a2 <memset>
  memset(disk.avail, 0, PGSIZE);
    800055f4:	00034497          	auipc	s1,0x34
    800055f8:	37c48493          	addi	s1,s1,892 # 80039970 <disk>
    800055fc:	6605                	lui	a2,0x1
    800055fe:	4581                	li	a1,0
    80005600:	6488                	ld	a0,8(s1)
    80005602:	ffffb097          	auipc	ra,0xffffb
    80005606:	ca0080e7          	jalr	-864(ra) # 800002a2 <memset>
  memset(disk.used, 0, PGSIZE);
    8000560a:	6605                	lui	a2,0x1
    8000560c:	4581                	li	a1,0
    8000560e:	6888                	ld	a0,16(s1)
    80005610:	ffffb097          	auipc	ra,0xffffb
    80005614:	c92080e7          	jalr	-878(ra) # 800002a2 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005618:	100017b7          	lui	a5,0x10001
    8000561c:	4721                	li	a4,8
    8000561e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005620:	4098                	lw	a4,0(s1)
    80005622:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005626:	40d8                	lw	a4,4(s1)
    80005628:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000562c:	6498                	ld	a4,8(s1)
    8000562e:	0007069b          	sext.w	a3,a4
    80005632:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005636:	9701                	srai	a4,a4,0x20
    80005638:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000563c:	6898                	ld	a4,16(s1)
    8000563e:	0007069b          	sext.w	a3,a4
    80005642:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005646:	9701                	srai	a4,a4,0x20
    80005648:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000564c:	4705                	li	a4,1
    8000564e:	c3f8                	sw	a4,68(a5)
  for (int i = 0; i < NUM; i++) disk.free[i] = 1;
    80005650:	00e48c23          	sb	a4,24(s1)
    80005654:	00e48ca3          	sb	a4,25(s1)
    80005658:	00e48d23          	sb	a4,26(s1)
    8000565c:	00e48da3          	sb	a4,27(s1)
    80005660:	00e48e23          	sb	a4,28(s1)
    80005664:	00e48ea3          	sb	a4,29(s1)
    80005668:	00e48f23          	sb	a4,30(s1)
    8000566c:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005670:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005674:	0727a823          	sw	s2,112(a5)
}
    80005678:	60e2                	ld	ra,24(sp)
    8000567a:	6442                	ld	s0,16(sp)
    8000567c:	64a2                	ld	s1,8(sp)
    8000567e:	6902                	ld	s2,0(sp)
    80005680:	6105                	addi	sp,sp,32
    80005682:	8082                	ret
    panic("could not find virtio disk");
    80005684:	00003517          	auipc	a0,0x3
    80005688:	02450513          	addi	a0,a0,36 # 800086a8 <syscalls+0x320>
    8000568c:	00001097          	auipc	ra,0x1
    80005690:	862080e7          	jalr	-1950(ra) # 80005eee <panic>
    panic("virtio disk FEATURES_OK unset");
    80005694:	00003517          	auipc	a0,0x3
    80005698:	03450513          	addi	a0,a0,52 # 800086c8 <syscalls+0x340>
    8000569c:	00001097          	auipc	ra,0x1
    800056a0:	852080e7          	jalr	-1966(ra) # 80005eee <panic>
  if (*R(VIRTIO_MMIO_QUEUE_READY)) panic("virtio disk should not be ready");
    800056a4:	00003517          	auipc	a0,0x3
    800056a8:	04450513          	addi	a0,a0,68 # 800086e8 <syscalls+0x360>
    800056ac:	00001097          	auipc	ra,0x1
    800056b0:	842080e7          	jalr	-1982(ra) # 80005eee <panic>
  if (max == 0) panic("virtio disk has no queue 0");
    800056b4:	00003517          	auipc	a0,0x3
    800056b8:	05450513          	addi	a0,a0,84 # 80008708 <syscalls+0x380>
    800056bc:	00001097          	auipc	ra,0x1
    800056c0:	832080e7          	jalr	-1998(ra) # 80005eee <panic>
  if (max < NUM) panic("virtio disk max queue too short");
    800056c4:	00003517          	auipc	a0,0x3
    800056c8:	06450513          	addi	a0,a0,100 # 80008728 <syscalls+0x3a0>
    800056cc:	00001097          	auipc	ra,0x1
    800056d0:	822080e7          	jalr	-2014(ra) # 80005eee <panic>
  if (!disk.desc || !disk.avail || !disk.used) panic("virtio disk kalloc");
    800056d4:	00003517          	auipc	a0,0x3
    800056d8:	07450513          	addi	a0,a0,116 # 80008748 <syscalls+0x3c0>
    800056dc:	00001097          	auipc	ra,0x1
    800056e0:	812080e7          	jalr	-2030(ra) # 80005eee <panic>

00000000800056e4 <virtio_disk_rw>:
    }
  }
  return 0;
}

void virtio_disk_rw(struct buf *b, int write) {
    800056e4:	7119                	addi	sp,sp,-128
    800056e6:	fc86                	sd	ra,120(sp)
    800056e8:	f8a2                	sd	s0,112(sp)
    800056ea:	f4a6                	sd	s1,104(sp)
    800056ec:	f0ca                	sd	s2,96(sp)
    800056ee:	ecce                	sd	s3,88(sp)
    800056f0:	e8d2                	sd	s4,80(sp)
    800056f2:	e4d6                	sd	s5,72(sp)
    800056f4:	e0da                	sd	s6,64(sp)
    800056f6:	fc5e                	sd	s7,56(sp)
    800056f8:	f862                	sd	s8,48(sp)
    800056fa:	f466                	sd	s9,40(sp)
    800056fc:	f06a                	sd	s10,32(sp)
    800056fe:	ec6e                	sd	s11,24(sp)
    80005700:	0100                	addi	s0,sp,128
    80005702:	8aaa                	mv	s5,a0
    80005704:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005706:	00c52d03          	lw	s10,12(a0)
    8000570a:	001d1d1b          	slliw	s10,s10,0x1
    8000570e:	1d02                	slli	s10,s10,0x20
    80005710:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80005714:	00034517          	auipc	a0,0x34
    80005718:	38450513          	addi	a0,a0,900 # 80039a98 <disk+0x128>
    8000571c:	00001097          	auipc	ra,0x1
    80005720:	d0e080e7          	jalr	-754(ra) # 8000642a <acquire>
  for (int i = 0; i < 3; i++) {
    80005724:	4981                	li	s3,0
  for (int i = 0; i < NUM; i++) {
    80005726:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005728:	00034b97          	auipc	s7,0x34
    8000572c:	248b8b93          	addi	s7,s7,584 # 80039970 <disk>
  for (int i = 0; i < 3; i++) {
    80005730:	4b0d                	li	s6,3
  int idx[3];
  while (1) {
    if (alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005732:	00034c97          	auipc	s9,0x34
    80005736:	366c8c93          	addi	s9,s9,870 # 80039a98 <disk+0x128>
    8000573a:	a08d                	j	8000579c <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000573c:	00fb8733          	add	a4,s7,a5
    80005740:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005744:	c19c                	sw	a5,0(a1)
    if (idx[i] < 0) {
    80005746:	0207c563          	bltz	a5,80005770 <virtio_disk_rw+0x8c>
  for (int i = 0; i < 3; i++) {
    8000574a:	2905                	addiw	s2,s2,1
    8000574c:	0611                	addi	a2,a2,4
    8000574e:	05690c63          	beq	s2,s6,800057a6 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80005752:	85b2                	mv	a1,a2
  for (int i = 0; i < NUM; i++) {
    80005754:	00034717          	auipc	a4,0x34
    80005758:	21c70713          	addi	a4,a4,540 # 80039970 <disk>
    8000575c:	87ce                	mv	a5,s3
    if (disk.free[i]) {
    8000575e:	01874683          	lbu	a3,24(a4)
    80005762:	fee9                	bnez	a3,8000573c <virtio_disk_rw+0x58>
  for (int i = 0; i < NUM; i++) {
    80005764:	2785                	addiw	a5,a5,1
    80005766:	0705                	addi	a4,a4,1
    80005768:	fe979be3          	bne	a5,s1,8000575e <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    8000576c:	57fd                	li	a5,-1
    8000576e:	c19c                	sw	a5,0(a1)
      for (int j = 0; j < i; j++) free_desc(idx[j]);
    80005770:	01205d63          	blez	s2,8000578a <virtio_disk_rw+0xa6>
    80005774:	8dce                	mv	s11,s3
    80005776:	000a2503          	lw	a0,0(s4)
    8000577a:	00000097          	auipc	ra,0x0
    8000577e:	cfc080e7          	jalr	-772(ra) # 80005476 <free_desc>
    80005782:	2d85                	addiw	s11,s11,1
    80005784:	0a11                	addi	s4,s4,4
    80005786:	ffb918e3          	bne	s2,s11,80005776 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000578a:	85e6                	mv	a1,s9
    8000578c:	00034517          	auipc	a0,0x34
    80005790:	1fc50513          	addi	a0,a0,508 # 80039988 <disk+0x18>
    80005794:	ffffc097          	auipc	ra,0xffffc
    80005798:	07c080e7          	jalr	124(ra) # 80001810 <sleep>
  for (int i = 0; i < 3; i++) {
    8000579c:	f8040a13          	addi	s4,s0,-128
void virtio_disk_rw(struct buf *b, int write) {
    800057a0:	8652                	mv	a2,s4
  for (int i = 0; i < 3; i++) {
    800057a2:	894e                	mv	s2,s3
    800057a4:	b77d                	j	80005752 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057a6:	f8042583          	lw	a1,-128(s0)
    800057aa:	00a58793          	addi	a5,a1,10
    800057ae:	0792                	slli	a5,a5,0x4

  if (write)
    800057b0:	00034617          	auipc	a2,0x34
    800057b4:	1c060613          	addi	a2,a2,448 # 80039970 <disk>
    800057b8:	00f60733          	add	a4,a2,a5
    800057bc:	018036b3          	snez	a3,s8
    800057c0:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT;  // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN;  // read the disk
  buf0->reserved = 0;
    800057c2:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800057c6:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64)buf0;
    800057ca:	f6078693          	addi	a3,a5,-160
    800057ce:	6218                	ld	a4,0(a2)
    800057d0:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057d2:	00878513          	addi	a0,a5,8
    800057d6:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64)buf0;
    800057d8:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800057da:	6208                	ld	a0,0(a2)
    800057dc:	96aa                	add	a3,a3,a0
    800057de:	4741                	li	a4,16
    800057e0:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800057e2:	4705                	li	a4,1
    800057e4:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    800057e8:	f8442703          	lw	a4,-124(s0)
    800057ec:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64)b->data;
    800057f0:	0712                	slli	a4,a4,0x4
    800057f2:	953a                	add	a0,a0,a4
    800057f4:	058a8693          	addi	a3,s5,88
    800057f8:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    800057fa:	6208                	ld	a0,0(a2)
    800057fc:	972a                	add	a4,a4,a0
    800057fe:	40000693          	li	a3,1024
    80005802:	c714                	sw	a3,8(a4)
  if (write)
    disk.desc[idx[1]].flags = 0;  // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE;  // device writes b->data
    80005804:	001c3c13          	seqz	s8,s8
    80005808:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000580a:	001c6c13          	ori	s8,s8,1
    8000580e:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005812:	f8842603          	lw	a2,-120(s0)
    80005816:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff;  // device writes 0 on success
    8000581a:	00034697          	auipc	a3,0x34
    8000581e:	15668693          	addi	a3,a3,342 # 80039970 <disk>
    80005822:	00258713          	addi	a4,a1,2
    80005826:	0712                	slli	a4,a4,0x4
    80005828:	9736                	add	a4,a4,a3
    8000582a:	587d                	li	a6,-1
    8000582c:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    80005830:	0612                	slli	a2,a2,0x4
    80005832:	9532                	add	a0,a0,a2
    80005834:	f9078793          	addi	a5,a5,-112
    80005838:	97b6                	add	a5,a5,a3
    8000583a:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    8000583c:	629c                	ld	a5,0(a3)
    8000583e:	97b2                	add	a5,a5,a2
    80005840:	4605                	li	a2,1
    80005842:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE;  // device writes the status
    80005844:	4509                	li	a0,2
    80005846:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    8000584a:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000584e:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80005852:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005856:	6698                	ld	a4,8(a3)
    80005858:	00275783          	lhu	a5,2(a4)
    8000585c:	8b9d                	andi	a5,a5,7
    8000585e:	0786                	slli	a5,a5,0x1
    80005860:	97ba                	add	a5,a5,a4
    80005862:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005866:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1;  // not % NUM ...
    8000586a:	6698                	ld	a4,8(a3)
    8000586c:	00275783          	lhu	a5,2(a4)
    80005870:	2785                	addiw	a5,a5,1
    80005872:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005876:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0;  // value is queue number
    8000587a:	100017b7          	lui	a5,0x10001
    8000587e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while (b->disk == 1) {
    80005882:	004aa783          	lw	a5,4(s5)
    80005886:	02c79163          	bne	a5,a2,800058a8 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    8000588a:	00034917          	auipc	s2,0x34
    8000588e:	20e90913          	addi	s2,s2,526 # 80039a98 <disk+0x128>
  while (b->disk == 1) {
    80005892:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005894:	85ca                	mv	a1,s2
    80005896:	8556                	mv	a0,s5
    80005898:	ffffc097          	auipc	ra,0xffffc
    8000589c:	f78080e7          	jalr	-136(ra) # 80001810 <sleep>
  while (b->disk == 1) {
    800058a0:	004aa783          	lw	a5,4(s5)
    800058a4:	fe9788e3          	beq	a5,s1,80005894 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800058a8:	f8042903          	lw	s2,-128(s0)
    800058ac:	00290793          	addi	a5,s2,2
    800058b0:	00479713          	slli	a4,a5,0x4
    800058b4:	00034797          	auipc	a5,0x34
    800058b8:	0bc78793          	addi	a5,a5,188 # 80039970 <disk>
    800058bc:	97ba                	add	a5,a5,a4
    800058be:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800058c2:	00034997          	auipc	s3,0x34
    800058c6:	0ae98993          	addi	s3,s3,174 # 80039970 <disk>
    800058ca:	00491713          	slli	a4,s2,0x4
    800058ce:	0009b783          	ld	a5,0(s3)
    800058d2:	97ba                	add	a5,a5,a4
    800058d4:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800058d8:	854a                	mv	a0,s2
    800058da:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800058de:	00000097          	auipc	ra,0x0
    800058e2:	b98080e7          	jalr	-1128(ra) # 80005476 <free_desc>
    if (flag & VRING_DESC_F_NEXT)
    800058e6:	8885                	andi	s1,s1,1
    800058e8:	f0ed                	bnez	s1,800058ca <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800058ea:	00034517          	auipc	a0,0x34
    800058ee:	1ae50513          	addi	a0,a0,430 # 80039a98 <disk+0x128>
    800058f2:	00001097          	auipc	ra,0x1
    800058f6:	bec080e7          	jalr	-1044(ra) # 800064de <release>
}
    800058fa:	70e6                	ld	ra,120(sp)
    800058fc:	7446                	ld	s0,112(sp)
    800058fe:	74a6                	ld	s1,104(sp)
    80005900:	7906                	ld	s2,96(sp)
    80005902:	69e6                	ld	s3,88(sp)
    80005904:	6a46                	ld	s4,80(sp)
    80005906:	6aa6                	ld	s5,72(sp)
    80005908:	6b06                	ld	s6,64(sp)
    8000590a:	7be2                	ld	s7,56(sp)
    8000590c:	7c42                	ld	s8,48(sp)
    8000590e:	7ca2                	ld	s9,40(sp)
    80005910:	7d02                	ld	s10,32(sp)
    80005912:	6de2                	ld	s11,24(sp)
    80005914:	6109                	addi	sp,sp,128
    80005916:	8082                	ret

0000000080005918 <virtio_disk_intr>:

void virtio_disk_intr() {
    80005918:	1101                	addi	sp,sp,-32
    8000591a:	ec06                	sd	ra,24(sp)
    8000591c:	e822                	sd	s0,16(sp)
    8000591e:	e426                	sd	s1,8(sp)
    80005920:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005922:	00034497          	auipc	s1,0x34
    80005926:	04e48493          	addi	s1,s1,78 # 80039970 <disk>
    8000592a:	00034517          	auipc	a0,0x34
    8000592e:	16e50513          	addi	a0,a0,366 # 80039a98 <disk+0x128>
    80005932:	00001097          	auipc	ra,0x1
    80005936:	af8080e7          	jalr	-1288(ra) # 8000642a <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000593a:	10001737          	lui	a4,0x10001
    8000593e:	533c                	lw	a5,96(a4)
    80005940:	8b8d                	andi	a5,a5,3
    80005942:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005944:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while (disk.used_idx != disk.used->idx) {
    80005948:	689c                	ld	a5,16(s1)
    8000594a:	0204d703          	lhu	a4,32(s1)
    8000594e:	0027d783          	lhu	a5,2(a5)
    80005952:	04f70863          	beq	a4,a5,800059a2 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005956:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000595a:	6898                	ld	a4,16(s1)
    8000595c:	0204d783          	lhu	a5,32(s1)
    80005960:	8b9d                	andi	a5,a5,7
    80005962:	078e                	slli	a5,a5,0x3
    80005964:	97ba                	add	a5,a5,a4
    80005966:	43dc                	lw	a5,4(a5)

    if (disk.info[id].status != 0) panic("virtio_disk_intr status");
    80005968:	00278713          	addi	a4,a5,2
    8000596c:	0712                	slli	a4,a4,0x4
    8000596e:	9726                	add	a4,a4,s1
    80005970:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005974:	e721                	bnez	a4,800059bc <virtio_disk_intr+0xa4>

    struct buf *b = disk.info[id].b;
    80005976:	0789                	addi	a5,a5,2
    80005978:	0792                	slli	a5,a5,0x4
    8000597a:	97a6                	add	a5,a5,s1
    8000597c:	6788                	ld	a0,8(a5)
    b->disk = 0;  // disk is done with buf
    8000597e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005982:	ffffc097          	auipc	ra,0xffffc
    80005986:	ef2080e7          	jalr	-270(ra) # 80001874 <wakeup>

    disk.used_idx += 1;
    8000598a:	0204d783          	lhu	a5,32(s1)
    8000598e:	2785                	addiw	a5,a5,1
    80005990:	17c2                	slli	a5,a5,0x30
    80005992:	93c1                	srli	a5,a5,0x30
    80005994:	02f49023          	sh	a5,32(s1)
  while (disk.used_idx != disk.used->idx) {
    80005998:	6898                	ld	a4,16(s1)
    8000599a:	00275703          	lhu	a4,2(a4)
    8000599e:	faf71ce3          	bne	a4,a5,80005956 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800059a2:	00034517          	auipc	a0,0x34
    800059a6:	0f650513          	addi	a0,a0,246 # 80039a98 <disk+0x128>
    800059aa:	00001097          	auipc	ra,0x1
    800059ae:	b34080e7          	jalr	-1228(ra) # 800064de <release>
}
    800059b2:	60e2                	ld	ra,24(sp)
    800059b4:	6442                	ld	s0,16(sp)
    800059b6:	64a2                	ld	s1,8(sp)
    800059b8:	6105                	addi	sp,sp,32
    800059ba:	8082                	ret
    if (disk.info[id].status != 0) panic("virtio_disk_intr status");
    800059bc:	00003517          	auipc	a0,0x3
    800059c0:	da450513          	addi	a0,a0,-604 # 80008760 <syscalls+0x3d8>
    800059c4:	00000097          	auipc	ra,0x0
    800059c8:	52a080e7          	jalr	1322(ra) # 80005eee <panic>

00000000800059cc <timerinit>:
// arrange to receive timer interrupts.
// they will arrive in machine mode at
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void timerinit() {
    800059cc:	1141                	addi	sp,sp,-16
    800059ce:	e422                	sd	s0,8(sp)
    800059d0:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r"(x));
    800059d2:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800059d6:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000;  // cycles; about 1/10th second in qemu.
  *(uint64 *)CLINT_MTIMECMP(id) = *(uint64 *)CLINT_MTIME + interval;
    800059da:	0037979b          	slliw	a5,a5,0x3
    800059de:	02004737          	lui	a4,0x2004
    800059e2:	97ba                	add	a5,a5,a4
    800059e4:	0200c737          	lui	a4,0x200c
    800059e8:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800059ec:	000f4637          	lui	a2,0xf4
    800059f0:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800059f4:	95b2                	add	a1,a1,a2
    800059f6:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800059f8:	00269713          	slli	a4,a3,0x2
    800059fc:	9736                	add	a4,a4,a3
    800059fe:	00371693          	slli	a3,a4,0x3
    80005a02:	00034717          	auipc	a4,0x34
    80005a06:	0ae70713          	addi	a4,a4,174 # 80039ab0 <timer_scratch>
    80005a0a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005a0c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005a0e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r"(x));
    80005a10:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r"(x));
    80005a14:	00000797          	auipc	a5,0x0
    80005a18:	99c78793          	addi	a5,a5,-1636 # 800053b0 <timervec>
    80005a1c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r"(x));
    80005a20:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005a24:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80005a28:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r"(x));
    80005a2c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005a30:	0807e793          	ori	a5,a5,128
static inline void w_mie(uint64 x) { asm volatile("csrw mie, %0" : : "r"(x)); }
    80005a34:	30479073          	csrw	mie,a5
}
    80005a38:	6422                	ld	s0,8(sp)
    80005a3a:	0141                	addi	sp,sp,16
    80005a3c:	8082                	ret

0000000080005a3e <start>:
void start() {
    80005a3e:	1141                	addi	sp,sp,-16
    80005a40:	e406                	sd	ra,8(sp)
    80005a42:	e022                	sd	s0,0(sp)
    80005a44:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r"(x));
    80005a46:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005a4a:	7779                	lui	a4,0xffffe
    80005a4c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffbcb0f>
    80005a50:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005a52:	6705                	lui	a4,0x1
    80005a54:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005a58:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80005a5a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    80005a5e:	ffffb797          	auipc	a5,0xffffb
    80005a62:	9ea78793          	addi	a5,a5,-1558 # 80000448 <main>
    80005a66:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r"(x));
    80005a6a:	4781                	li	a5,0
    80005a6c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r"(x));
    80005a70:	67c1                	lui	a5,0x10
    80005a72:	17fd                	addi	a5,a5,-1
    80005a74:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r"(x));
    80005a78:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r"(x));
    80005a7c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005a80:	2227e793          	ori	a5,a5,546
static inline void w_sie(uint64 x) { asm volatile("csrw sie, %0" : : "r"(x)); }
    80005a84:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    80005a88:	57fd                	li	a5,-1
    80005a8a:	83a9                	srli	a5,a5,0xa
    80005a8c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    80005a90:	47bd                	li	a5,15
    80005a92:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005a96:	00000097          	auipc	ra,0x0
    80005a9a:	f36080e7          	jalr	-202(ra) # 800059cc <timerinit>
  asm volatile("csrr %0, mhartid" : "=r"(x));
    80005a9e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005aa2:	2781                	sext.w	a5,a5
static inline void w_tp(uint64 x) { asm volatile("mv tp, %0" : : "r"(x)); }
    80005aa4:	823e                	mv	tp,a5
  asm volatile("mret");
    80005aa6:	30200073          	mret
}
    80005aaa:	60a2                	ld	ra,8(sp)
    80005aac:	6402                	ld	s0,0(sp)
    80005aae:	0141                	addi	sp,sp,16
    80005ab0:	8082                	ret

0000000080005ab2 <consolewrite>:
} cons;

//
// user write()s to the console go here.
//
int consolewrite(int user_src, uint64 src, int n) {
    80005ab2:	715d                	addi	sp,sp,-80
    80005ab4:	e486                	sd	ra,72(sp)
    80005ab6:	e0a2                	sd	s0,64(sp)
    80005ab8:	fc26                	sd	s1,56(sp)
    80005aba:	f84a                	sd	s2,48(sp)
    80005abc:	f44e                	sd	s3,40(sp)
    80005abe:	f052                	sd	s4,32(sp)
    80005ac0:	ec56                	sd	s5,24(sp)
    80005ac2:	0880                	addi	s0,sp,80
  int i;

  for (i = 0; i < n; i++) {
    80005ac4:	04c05663          	blez	a2,80005b10 <consolewrite+0x5e>
    80005ac8:	8a2a                	mv	s4,a0
    80005aca:	84ae                	mv	s1,a1
    80005acc:	89b2                	mv	s3,a2
    80005ace:	4901                	li	s2,0
    char c;
    if (either_copyin(&c, user_src, src + i, 1) == -1) break;
    80005ad0:	5afd                	li	s5,-1
    80005ad2:	4685                	li	a3,1
    80005ad4:	8626                	mv	a2,s1
    80005ad6:	85d2                	mv	a1,s4
    80005ad8:	fbf40513          	addi	a0,s0,-65
    80005adc:	ffffc097          	auipc	ra,0xffffc
    80005ae0:	192080e7          	jalr	402(ra) # 80001c6e <either_copyin>
    80005ae4:	01550c63          	beq	a0,s5,80005afc <consolewrite+0x4a>
    uartputc(c);
    80005ae8:	fbf44503          	lbu	a0,-65(s0)
    80005aec:	00000097          	auipc	ra,0x0
    80005af0:	780080e7          	jalr	1920(ra) # 8000626c <uartputc>
  for (i = 0; i < n; i++) {
    80005af4:	2905                	addiw	s2,s2,1
    80005af6:	0485                	addi	s1,s1,1
    80005af8:	fd299de3          	bne	s3,s2,80005ad2 <consolewrite+0x20>
  }

  return i;
}
    80005afc:	854a                	mv	a0,s2
    80005afe:	60a6                	ld	ra,72(sp)
    80005b00:	6406                	ld	s0,64(sp)
    80005b02:	74e2                	ld	s1,56(sp)
    80005b04:	7942                	ld	s2,48(sp)
    80005b06:	79a2                	ld	s3,40(sp)
    80005b08:	7a02                	ld	s4,32(sp)
    80005b0a:	6ae2                	ld	s5,24(sp)
    80005b0c:	6161                	addi	sp,sp,80
    80005b0e:	8082                	ret
  for (i = 0; i < n; i++) {
    80005b10:	4901                	li	s2,0
    80005b12:	b7ed                	j	80005afc <consolewrite+0x4a>

0000000080005b14 <consoleread>:
// user read()s from the console go here.
// copy (up to) a whole input line to dst.
// user_dist indicates whether dst is a user
// or kernel address.
//
int consoleread(int user_dst, uint64 dst, int n) {
    80005b14:	7159                	addi	sp,sp,-112
    80005b16:	f486                	sd	ra,104(sp)
    80005b18:	f0a2                	sd	s0,96(sp)
    80005b1a:	eca6                	sd	s1,88(sp)
    80005b1c:	e8ca                	sd	s2,80(sp)
    80005b1e:	e4ce                	sd	s3,72(sp)
    80005b20:	e0d2                	sd	s4,64(sp)
    80005b22:	fc56                	sd	s5,56(sp)
    80005b24:	f85a                	sd	s6,48(sp)
    80005b26:	f45e                	sd	s7,40(sp)
    80005b28:	f062                	sd	s8,32(sp)
    80005b2a:	ec66                	sd	s9,24(sp)
    80005b2c:	e86a                	sd	s10,16(sp)
    80005b2e:	1880                	addi	s0,sp,112
    80005b30:	8aaa                	mv	s5,a0
    80005b32:	8a2e                	mv	s4,a1
    80005b34:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005b36:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005b3a:	0003c517          	auipc	a0,0x3c
    80005b3e:	0b650513          	addi	a0,a0,182 # 80041bf0 <cons>
    80005b42:	00001097          	auipc	ra,0x1
    80005b46:	8e8080e7          	jalr	-1816(ra) # 8000642a <acquire>
  while (n > 0) {
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while (cons.r == cons.w) {
    80005b4a:	0003c497          	auipc	s1,0x3c
    80005b4e:	0a648493          	addi	s1,s1,166 # 80041bf0 <cons>
      if (killed(myproc())) {
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005b52:	0003c917          	auipc	s2,0x3c
    80005b56:	13690913          	addi	s2,s2,310 # 80041c88 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if (c == C('D')) {  // end-of-file
    80005b5a:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1) break;
    80005b5c:	5c7d                	li	s8,-1

    dst++;
    --n;

    if (c == '\n') {
    80005b5e:	4ca9                	li	s9,10
  while (n > 0) {
    80005b60:	07305b63          	blez	s3,80005bd6 <consoleread+0xc2>
    while (cons.r == cons.w) {
    80005b64:	0984a783          	lw	a5,152(s1)
    80005b68:	09c4a703          	lw	a4,156(s1)
    80005b6c:	02f71763          	bne	a4,a5,80005b9a <consoleread+0x86>
      if (killed(myproc())) {
    80005b70:	ffffb097          	auipc	ra,0xffffb
    80005b74:	5f4080e7          	jalr	1524(ra) # 80001164 <myproc>
    80005b78:	ffffc097          	auipc	ra,0xffffc
    80005b7c:	f40080e7          	jalr	-192(ra) # 80001ab8 <killed>
    80005b80:	e535                	bnez	a0,80005bec <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    80005b82:	85a6                	mv	a1,s1
    80005b84:	854a                	mv	a0,s2
    80005b86:	ffffc097          	auipc	ra,0xffffc
    80005b8a:	c8a080e7          	jalr	-886(ra) # 80001810 <sleep>
    while (cons.r == cons.w) {
    80005b8e:	0984a783          	lw	a5,152(s1)
    80005b92:	09c4a703          	lw	a4,156(s1)
    80005b96:	fcf70de3          	beq	a4,a5,80005b70 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005b9a:	0017871b          	addiw	a4,a5,1
    80005b9e:	08e4ac23          	sw	a4,152(s1)
    80005ba2:	07f7f713          	andi	a4,a5,127
    80005ba6:	9726                	add	a4,a4,s1
    80005ba8:	01874703          	lbu	a4,24(a4)
    80005bac:	00070d1b          	sext.w	s10,a4
    if (c == C('D')) {  // end-of-file
    80005bb0:	077d0563          	beq	s10,s7,80005c1a <consoleread+0x106>
    cbuf = c;
    80005bb4:	f8e40fa3          	sb	a4,-97(s0)
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1) break;
    80005bb8:	4685                	li	a3,1
    80005bba:	f9f40613          	addi	a2,s0,-97
    80005bbe:	85d2                	mv	a1,s4
    80005bc0:	8556                	mv	a0,s5
    80005bc2:	ffffc097          	auipc	ra,0xffffc
    80005bc6:	056080e7          	jalr	86(ra) # 80001c18 <either_copyout>
    80005bca:	01850663          	beq	a0,s8,80005bd6 <consoleread+0xc2>
    dst++;
    80005bce:	0a05                	addi	s4,s4,1
    --n;
    80005bd0:	39fd                	addiw	s3,s3,-1
    if (c == '\n') {
    80005bd2:	f99d17e3          	bne	s10,s9,80005b60 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005bd6:	0003c517          	auipc	a0,0x3c
    80005bda:	01a50513          	addi	a0,a0,26 # 80041bf0 <cons>
    80005bde:	00001097          	auipc	ra,0x1
    80005be2:	900080e7          	jalr	-1792(ra) # 800064de <release>

  return target - n;
    80005be6:	413b053b          	subw	a0,s6,s3
    80005bea:	a811                	j	80005bfe <consoleread+0xea>
        release(&cons.lock);
    80005bec:	0003c517          	auipc	a0,0x3c
    80005bf0:	00450513          	addi	a0,a0,4 # 80041bf0 <cons>
    80005bf4:	00001097          	auipc	ra,0x1
    80005bf8:	8ea080e7          	jalr	-1814(ra) # 800064de <release>
        return -1;
    80005bfc:	557d                	li	a0,-1
}
    80005bfe:	70a6                	ld	ra,104(sp)
    80005c00:	7406                	ld	s0,96(sp)
    80005c02:	64e6                	ld	s1,88(sp)
    80005c04:	6946                	ld	s2,80(sp)
    80005c06:	69a6                	ld	s3,72(sp)
    80005c08:	6a06                	ld	s4,64(sp)
    80005c0a:	7ae2                	ld	s5,56(sp)
    80005c0c:	7b42                	ld	s6,48(sp)
    80005c0e:	7ba2                	ld	s7,40(sp)
    80005c10:	7c02                	ld	s8,32(sp)
    80005c12:	6ce2                	ld	s9,24(sp)
    80005c14:	6d42                	ld	s10,16(sp)
    80005c16:	6165                	addi	sp,sp,112
    80005c18:	8082                	ret
      if (n < target) {
    80005c1a:	0009871b          	sext.w	a4,s3
    80005c1e:	fb677ce3          	bgeu	a4,s6,80005bd6 <consoleread+0xc2>
        cons.r--;
    80005c22:	0003c717          	auipc	a4,0x3c
    80005c26:	06f72323          	sw	a5,102(a4) # 80041c88 <cons+0x98>
    80005c2a:	b775                	j	80005bd6 <consoleread+0xc2>

0000000080005c2c <consputc>:
void consputc(int c) {
    80005c2c:	1141                	addi	sp,sp,-16
    80005c2e:	e406                	sd	ra,8(sp)
    80005c30:	e022                	sd	s0,0(sp)
    80005c32:	0800                	addi	s0,sp,16
  if (c == BACKSPACE) {
    80005c34:	10000793          	li	a5,256
    80005c38:	00f50a63          	beq	a0,a5,80005c4c <consputc+0x20>
    uartputc_sync(c);
    80005c3c:	00000097          	auipc	ra,0x0
    80005c40:	55e080e7          	jalr	1374(ra) # 8000619a <uartputc_sync>
}
    80005c44:	60a2                	ld	ra,8(sp)
    80005c46:	6402                	ld	s0,0(sp)
    80005c48:	0141                	addi	sp,sp,16
    80005c4a:	8082                	ret
    uartputc_sync('\b');
    80005c4c:	4521                	li	a0,8
    80005c4e:	00000097          	auipc	ra,0x0
    80005c52:	54c080e7          	jalr	1356(ra) # 8000619a <uartputc_sync>
    uartputc_sync(' ');
    80005c56:	02000513          	li	a0,32
    80005c5a:	00000097          	auipc	ra,0x0
    80005c5e:	540080e7          	jalr	1344(ra) # 8000619a <uartputc_sync>
    uartputc_sync('\b');
    80005c62:	4521                	li	a0,8
    80005c64:	00000097          	auipc	ra,0x0
    80005c68:	536080e7          	jalr	1334(ra) # 8000619a <uartputc_sync>
    80005c6c:	bfe1                	j	80005c44 <consputc+0x18>

0000000080005c6e <consoleintr>:
// the console input interrupt handler.
// uartintr() calls this for input character.
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void consoleintr(int c) {
    80005c6e:	1101                	addi	sp,sp,-32
    80005c70:	ec06                	sd	ra,24(sp)
    80005c72:	e822                	sd	s0,16(sp)
    80005c74:	e426                	sd	s1,8(sp)
    80005c76:	e04a                	sd	s2,0(sp)
    80005c78:	1000                	addi	s0,sp,32
    80005c7a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005c7c:	0003c517          	auipc	a0,0x3c
    80005c80:	f7450513          	addi	a0,a0,-140 # 80041bf0 <cons>
    80005c84:	00000097          	auipc	ra,0x0
    80005c88:	7a6080e7          	jalr	1958(ra) # 8000642a <acquire>

  switch (c) {
    80005c8c:	47d5                	li	a5,21
    80005c8e:	0af48663          	beq	s1,a5,80005d3a <consoleintr+0xcc>
    80005c92:	0297ca63          	blt	a5,s1,80005cc6 <consoleintr+0x58>
    80005c96:	47a1                	li	a5,8
    80005c98:	0ef48763          	beq	s1,a5,80005d86 <consoleintr+0x118>
    80005c9c:	47c1                	li	a5,16
    80005c9e:	10f49a63          	bne	s1,a5,80005db2 <consoleintr+0x144>
    case C('P'):  // Print process list.
      procdump();
    80005ca2:	ffffc097          	auipc	ra,0xffffc
    80005ca6:	022080e7          	jalr	34(ra) # 80001cc4 <procdump>
        }
      }
      break;
  }

  release(&cons.lock);
    80005caa:	0003c517          	auipc	a0,0x3c
    80005cae:	f4650513          	addi	a0,a0,-186 # 80041bf0 <cons>
    80005cb2:	00001097          	auipc	ra,0x1
    80005cb6:	82c080e7          	jalr	-2004(ra) # 800064de <release>
}
    80005cba:	60e2                	ld	ra,24(sp)
    80005cbc:	6442                	ld	s0,16(sp)
    80005cbe:	64a2                	ld	s1,8(sp)
    80005cc0:	6902                	ld	s2,0(sp)
    80005cc2:	6105                	addi	sp,sp,32
    80005cc4:	8082                	ret
  switch (c) {
    80005cc6:	07f00793          	li	a5,127
    80005cca:	0af48e63          	beq	s1,a5,80005d86 <consoleintr+0x118>
      if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    80005cce:	0003c717          	auipc	a4,0x3c
    80005cd2:	f2270713          	addi	a4,a4,-222 # 80041bf0 <cons>
    80005cd6:	0a072783          	lw	a5,160(a4)
    80005cda:	09872703          	lw	a4,152(a4)
    80005cde:	9f99                	subw	a5,a5,a4
    80005ce0:	07f00713          	li	a4,127
    80005ce4:	fcf763e3          	bltu	a4,a5,80005caa <consoleintr+0x3c>
        c = (c == '\r') ? '\n' : c;
    80005ce8:	47b5                	li	a5,13
    80005cea:	0cf48763          	beq	s1,a5,80005db8 <consoleintr+0x14a>
        consputc(c);
    80005cee:	8526                	mv	a0,s1
    80005cf0:	00000097          	auipc	ra,0x0
    80005cf4:	f3c080e7          	jalr	-196(ra) # 80005c2c <consputc>
        cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005cf8:	0003c797          	auipc	a5,0x3c
    80005cfc:	ef878793          	addi	a5,a5,-264 # 80041bf0 <cons>
    80005d00:	0a07a683          	lw	a3,160(a5)
    80005d04:	0016871b          	addiw	a4,a3,1
    80005d08:	0007061b          	sext.w	a2,a4
    80005d0c:	0ae7a023          	sw	a4,160(a5)
    80005d10:	07f6f693          	andi	a3,a3,127
    80005d14:	97b6                	add	a5,a5,a3
    80005d16:	00978c23          	sb	s1,24(a5)
        if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE) {
    80005d1a:	47a9                	li	a5,10
    80005d1c:	0cf48563          	beq	s1,a5,80005de6 <consoleintr+0x178>
    80005d20:	4791                	li	a5,4
    80005d22:	0cf48263          	beq	s1,a5,80005de6 <consoleintr+0x178>
    80005d26:	0003c797          	auipc	a5,0x3c
    80005d2a:	f627a783          	lw	a5,-158(a5) # 80041c88 <cons+0x98>
    80005d2e:	9f1d                	subw	a4,a4,a5
    80005d30:	08000793          	li	a5,128
    80005d34:	f6f71be3          	bne	a4,a5,80005caa <consoleintr+0x3c>
    80005d38:	a07d                	j	80005de6 <consoleintr+0x178>
      while (cons.e != cons.w &&
    80005d3a:	0003c717          	auipc	a4,0x3c
    80005d3e:	eb670713          	addi	a4,a4,-330 # 80041bf0 <cons>
    80005d42:	0a072783          	lw	a5,160(a4)
    80005d46:	09c72703          	lw	a4,156(a4)
             cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80005d4a:	0003c497          	auipc	s1,0x3c
    80005d4e:	ea648493          	addi	s1,s1,-346 # 80041bf0 <cons>
      while (cons.e != cons.w &&
    80005d52:	4929                	li	s2,10
    80005d54:	f4f70be3          	beq	a4,a5,80005caa <consoleintr+0x3c>
             cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80005d58:	37fd                	addiw	a5,a5,-1
    80005d5a:	07f7f713          	andi	a4,a5,127
    80005d5e:	9726                	add	a4,a4,s1
      while (cons.e != cons.w &&
    80005d60:	01874703          	lbu	a4,24(a4)
    80005d64:	f52703e3          	beq	a4,s2,80005caa <consoleintr+0x3c>
        cons.e--;
    80005d68:	0af4a023          	sw	a5,160(s1)
        consputc(BACKSPACE);
    80005d6c:	10000513          	li	a0,256
    80005d70:	00000097          	auipc	ra,0x0
    80005d74:	ebc080e7          	jalr	-324(ra) # 80005c2c <consputc>
      while (cons.e != cons.w &&
    80005d78:	0a04a783          	lw	a5,160(s1)
    80005d7c:	09c4a703          	lw	a4,156(s1)
    80005d80:	fcf71ce3          	bne	a4,a5,80005d58 <consoleintr+0xea>
    80005d84:	b71d                	j	80005caa <consoleintr+0x3c>
      if (cons.e != cons.w) {
    80005d86:	0003c717          	auipc	a4,0x3c
    80005d8a:	e6a70713          	addi	a4,a4,-406 # 80041bf0 <cons>
    80005d8e:	0a072783          	lw	a5,160(a4)
    80005d92:	09c72703          	lw	a4,156(a4)
    80005d96:	f0f70ae3          	beq	a4,a5,80005caa <consoleintr+0x3c>
        cons.e--;
    80005d9a:	37fd                	addiw	a5,a5,-1
    80005d9c:	0003c717          	auipc	a4,0x3c
    80005da0:	eef72a23          	sw	a5,-268(a4) # 80041c90 <cons+0xa0>
        consputc(BACKSPACE);
    80005da4:	10000513          	li	a0,256
    80005da8:	00000097          	auipc	ra,0x0
    80005dac:	e84080e7          	jalr	-380(ra) # 80005c2c <consputc>
    80005db0:	bded                	j	80005caa <consoleintr+0x3c>
      if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    80005db2:	ee048ce3          	beqz	s1,80005caa <consoleintr+0x3c>
    80005db6:	bf21                	j	80005cce <consoleintr+0x60>
        consputc(c);
    80005db8:	4529                	li	a0,10
    80005dba:	00000097          	auipc	ra,0x0
    80005dbe:	e72080e7          	jalr	-398(ra) # 80005c2c <consputc>
        cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005dc2:	0003c797          	auipc	a5,0x3c
    80005dc6:	e2e78793          	addi	a5,a5,-466 # 80041bf0 <cons>
    80005dca:	0a07a703          	lw	a4,160(a5)
    80005dce:	0017069b          	addiw	a3,a4,1
    80005dd2:	0006861b          	sext.w	a2,a3
    80005dd6:	0ad7a023          	sw	a3,160(a5)
    80005dda:	07f77713          	andi	a4,a4,127
    80005dde:	97ba                	add	a5,a5,a4
    80005de0:	4729                	li	a4,10
    80005de2:	00e78c23          	sb	a4,24(a5)
          cons.w = cons.e;
    80005de6:	0003c797          	auipc	a5,0x3c
    80005dea:	eac7a323          	sw	a2,-346(a5) # 80041c8c <cons+0x9c>
          wakeup(&cons.r);
    80005dee:	0003c517          	auipc	a0,0x3c
    80005df2:	e9a50513          	addi	a0,a0,-358 # 80041c88 <cons+0x98>
    80005df6:	ffffc097          	auipc	ra,0xffffc
    80005dfa:	a7e080e7          	jalr	-1410(ra) # 80001874 <wakeup>
    80005dfe:	b575                	j	80005caa <consoleintr+0x3c>

0000000080005e00 <consoleinit>:

void consoleinit(void) {
    80005e00:	1141                	addi	sp,sp,-16
    80005e02:	e406                	sd	ra,8(sp)
    80005e04:	e022                	sd	s0,0(sp)
    80005e06:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005e08:	00003597          	auipc	a1,0x3
    80005e0c:	97058593          	addi	a1,a1,-1680 # 80008778 <syscalls+0x3f0>
    80005e10:	0003c517          	auipc	a0,0x3c
    80005e14:	de050513          	addi	a0,a0,-544 # 80041bf0 <cons>
    80005e18:	00000097          	auipc	ra,0x0
    80005e1c:	582080e7          	jalr	1410(ra) # 8000639a <initlock>

  uartinit();
    80005e20:	00000097          	auipc	ra,0x0
    80005e24:	32a080e7          	jalr	810(ra) # 8000614a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005e28:	00033797          	auipc	a5,0x33
    80005e2c:	af078793          	addi	a5,a5,-1296 # 80038918 <devsw>
    80005e30:	00000717          	auipc	a4,0x0
    80005e34:	ce470713          	addi	a4,a4,-796 # 80005b14 <consoleread>
    80005e38:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005e3a:	00000717          	auipc	a4,0x0
    80005e3e:	c7870713          	addi	a4,a4,-904 # 80005ab2 <consolewrite>
    80005e42:	ef98                	sd	a4,24(a5)
}
    80005e44:	60a2                	ld	ra,8(sp)
    80005e46:	6402                	ld	s0,0(sp)
    80005e48:	0141                	addi	sp,sp,16
    80005e4a:	8082                	ret

0000000080005e4c <printint>:
  int locking;
} pr;

static char digits[] = "0123456789abcdef";

static void printint(int xx, int base, int sign) {
    80005e4c:	7179                	addi	sp,sp,-48
    80005e4e:	f406                	sd	ra,40(sp)
    80005e50:	f022                	sd	s0,32(sp)
    80005e52:	ec26                	sd	s1,24(sp)
    80005e54:	e84a                	sd	s2,16(sp)
    80005e56:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if (sign && (sign = xx < 0))
    80005e58:	c219                	beqz	a2,80005e5e <printint+0x12>
    80005e5a:	08054663          	bltz	a0,80005ee6 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005e5e:	2501                	sext.w	a0,a0
    80005e60:	4881                	li	a7,0
    80005e62:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005e66:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005e68:	2581                	sext.w	a1,a1
    80005e6a:	00003617          	auipc	a2,0x3
    80005e6e:	93e60613          	addi	a2,a2,-1730 # 800087a8 <digits>
    80005e72:	883a                	mv	a6,a4
    80005e74:	2705                	addiw	a4,a4,1
    80005e76:	02b577bb          	remuw	a5,a0,a1
    80005e7a:	1782                	slli	a5,a5,0x20
    80005e7c:	9381                	srli	a5,a5,0x20
    80005e7e:	97b2                	add	a5,a5,a2
    80005e80:	0007c783          	lbu	a5,0(a5)
    80005e84:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    80005e88:	0005079b          	sext.w	a5,a0
    80005e8c:	02b5553b          	divuw	a0,a0,a1
    80005e90:	0685                	addi	a3,a3,1
    80005e92:	feb7f0e3          	bgeu	a5,a1,80005e72 <printint+0x26>

  if (sign) buf[i++] = '-';
    80005e96:	00088b63          	beqz	a7,80005eac <printint+0x60>
    80005e9a:	fe040793          	addi	a5,s0,-32
    80005e9e:	973e                	add	a4,a4,a5
    80005ea0:	02d00793          	li	a5,45
    80005ea4:	fef70823          	sb	a5,-16(a4)
    80005ea8:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) consputc(buf[i]);
    80005eac:	02e05763          	blez	a4,80005eda <printint+0x8e>
    80005eb0:	fd040793          	addi	a5,s0,-48
    80005eb4:	00e784b3          	add	s1,a5,a4
    80005eb8:	fff78913          	addi	s2,a5,-1
    80005ebc:	993a                	add	s2,s2,a4
    80005ebe:	377d                	addiw	a4,a4,-1
    80005ec0:	1702                	slli	a4,a4,0x20
    80005ec2:	9301                	srli	a4,a4,0x20
    80005ec4:	40e90933          	sub	s2,s2,a4
    80005ec8:	fff4c503          	lbu	a0,-1(s1)
    80005ecc:	00000097          	auipc	ra,0x0
    80005ed0:	d60080e7          	jalr	-672(ra) # 80005c2c <consputc>
    80005ed4:	14fd                	addi	s1,s1,-1
    80005ed6:	ff2499e3          	bne	s1,s2,80005ec8 <printint+0x7c>
}
    80005eda:	70a2                	ld	ra,40(sp)
    80005edc:	7402                	ld	s0,32(sp)
    80005ede:	64e2                	ld	s1,24(sp)
    80005ee0:	6942                	ld	s2,16(sp)
    80005ee2:	6145                	addi	sp,sp,48
    80005ee4:	8082                	ret
    x = -xx;
    80005ee6:	40a0053b          	negw	a0,a0
  if (sign && (sign = xx < 0))
    80005eea:	4885                	li	a7,1
    x = -xx;
    80005eec:	bf9d                	j	80005e62 <printint+0x16>

0000000080005eee <panic>:
  va_end(ap);

  if (locking) release(&pr.lock);
}

void panic(char *s) {
    80005eee:	1101                	addi	sp,sp,-32
    80005ef0:	ec06                	sd	ra,24(sp)
    80005ef2:	e822                	sd	s0,16(sp)
    80005ef4:	e426                	sd	s1,8(sp)
    80005ef6:	1000                	addi	s0,sp,32
    80005ef8:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005efa:	0003c797          	auipc	a5,0x3c
    80005efe:	da07ab23          	sw	zero,-586(a5) # 80041cb0 <pr+0x18>
  printf("panic: ");
    80005f02:	00003517          	auipc	a0,0x3
    80005f06:	87e50513          	addi	a0,a0,-1922 # 80008780 <syscalls+0x3f8>
    80005f0a:	00000097          	auipc	ra,0x0
    80005f0e:	02e080e7          	jalr	46(ra) # 80005f38 <printf>
  printf(s);
    80005f12:	8526                	mv	a0,s1
    80005f14:	00000097          	auipc	ra,0x0
    80005f18:	024080e7          	jalr	36(ra) # 80005f38 <printf>
  printf("\n");
    80005f1c:	00002517          	auipc	a0,0x2
    80005f20:	12c50513          	addi	a0,a0,300 # 80008048 <etext+0x48>
    80005f24:	00000097          	auipc	ra,0x0
    80005f28:	014080e7          	jalr	20(ra) # 80005f38 <printf>
  panicked = 1;  // freeze uart output from other CPUs
    80005f2c:	4785                	li	a5,1
    80005f2e:	00003717          	auipc	a4,0x3
    80005f32:	92f72f23          	sw	a5,-1730(a4) # 8000886c <panicked>
  for (;;)
    80005f36:	a001                	j	80005f36 <panic+0x48>

0000000080005f38 <printf>:
void printf(char *fmt, ...) {
    80005f38:	7131                	addi	sp,sp,-192
    80005f3a:	fc86                	sd	ra,120(sp)
    80005f3c:	f8a2                	sd	s0,112(sp)
    80005f3e:	f4a6                	sd	s1,104(sp)
    80005f40:	f0ca                	sd	s2,96(sp)
    80005f42:	ecce                	sd	s3,88(sp)
    80005f44:	e8d2                	sd	s4,80(sp)
    80005f46:	e4d6                	sd	s5,72(sp)
    80005f48:	e0da                	sd	s6,64(sp)
    80005f4a:	fc5e                	sd	s7,56(sp)
    80005f4c:	f862                	sd	s8,48(sp)
    80005f4e:	f466                	sd	s9,40(sp)
    80005f50:	f06a                	sd	s10,32(sp)
    80005f52:	ec6e                	sd	s11,24(sp)
    80005f54:	0100                	addi	s0,sp,128
    80005f56:	8a2a                	mv	s4,a0
    80005f58:	e40c                	sd	a1,8(s0)
    80005f5a:	e810                	sd	a2,16(s0)
    80005f5c:	ec14                	sd	a3,24(s0)
    80005f5e:	f018                	sd	a4,32(s0)
    80005f60:	f41c                	sd	a5,40(s0)
    80005f62:	03043823          	sd	a6,48(s0)
    80005f66:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005f6a:	0003cd97          	auipc	s11,0x3c
    80005f6e:	d46dad83          	lw	s11,-698(s11) # 80041cb0 <pr+0x18>
  if (locking) acquire(&pr.lock);
    80005f72:	020d9b63          	bnez	s11,80005fa8 <printf+0x70>
  if (fmt == 0) panic("null fmt");
    80005f76:	040a0263          	beqz	s4,80005fba <printf+0x82>
  va_start(ap, fmt);
    80005f7a:	00840793          	addi	a5,s0,8
    80005f7e:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80005f82:	000a4503          	lbu	a0,0(s4)
    80005f86:	14050f63          	beqz	a0,800060e4 <printf+0x1ac>
    80005f8a:	4981                	li	s3,0
    if (c != '%') {
    80005f8c:	02500a93          	li	s5,37
    switch (c) {
    80005f90:	07000b93          	li	s7,112
  consputc('x');
    80005f94:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f96:	00003b17          	auipc	s6,0x3
    80005f9a:	812b0b13          	addi	s6,s6,-2030 # 800087a8 <digits>
    switch (c) {
    80005f9e:	07300c93          	li	s9,115
    80005fa2:	06400c13          	li	s8,100
    80005fa6:	a82d                	j	80005fe0 <printf+0xa8>
  if (locking) acquire(&pr.lock);
    80005fa8:	0003c517          	auipc	a0,0x3c
    80005fac:	cf050513          	addi	a0,a0,-784 # 80041c98 <pr>
    80005fb0:	00000097          	auipc	ra,0x0
    80005fb4:	47a080e7          	jalr	1146(ra) # 8000642a <acquire>
    80005fb8:	bf7d                	j	80005f76 <printf+0x3e>
  if (fmt == 0) panic("null fmt");
    80005fba:	00002517          	auipc	a0,0x2
    80005fbe:	7d650513          	addi	a0,a0,2006 # 80008790 <syscalls+0x408>
    80005fc2:	00000097          	auipc	ra,0x0
    80005fc6:	f2c080e7          	jalr	-212(ra) # 80005eee <panic>
      consputc(c);
    80005fca:	00000097          	auipc	ra,0x0
    80005fce:	c62080e7          	jalr	-926(ra) # 80005c2c <consputc>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80005fd2:	2985                	addiw	s3,s3,1
    80005fd4:	013a07b3          	add	a5,s4,s3
    80005fd8:	0007c503          	lbu	a0,0(a5)
    80005fdc:	10050463          	beqz	a0,800060e4 <printf+0x1ac>
    if (c != '%') {
    80005fe0:	ff5515e3          	bne	a0,s5,80005fca <printf+0x92>
    c = fmt[++i] & 0xff;
    80005fe4:	2985                	addiw	s3,s3,1
    80005fe6:	013a07b3          	add	a5,s4,s3
    80005fea:	0007c783          	lbu	a5,0(a5)
    80005fee:	0007849b          	sext.w	s1,a5
    if (c == 0) break;
    80005ff2:	cbed                	beqz	a5,800060e4 <printf+0x1ac>
    switch (c) {
    80005ff4:	05778a63          	beq	a5,s7,80006048 <printf+0x110>
    80005ff8:	02fbf663          	bgeu	s7,a5,80006024 <printf+0xec>
    80005ffc:	09978863          	beq	a5,s9,8000608c <printf+0x154>
    80006000:	07800713          	li	a4,120
    80006004:	0ce79563          	bne	a5,a4,800060ce <printf+0x196>
        printint(va_arg(ap, int), 16, 1);
    80006008:	f8843783          	ld	a5,-120(s0)
    8000600c:	00878713          	addi	a4,a5,8
    80006010:	f8e43423          	sd	a4,-120(s0)
    80006014:	4605                	li	a2,1
    80006016:	85ea                	mv	a1,s10
    80006018:	4388                	lw	a0,0(a5)
    8000601a:	00000097          	auipc	ra,0x0
    8000601e:	e32080e7          	jalr	-462(ra) # 80005e4c <printint>
        break;
    80006022:	bf45                	j	80005fd2 <printf+0x9a>
    switch (c) {
    80006024:	09578f63          	beq	a5,s5,800060c2 <printf+0x18a>
    80006028:	0b879363          	bne	a5,s8,800060ce <printf+0x196>
        printint(va_arg(ap, int), 10, 1);
    8000602c:	f8843783          	ld	a5,-120(s0)
    80006030:	00878713          	addi	a4,a5,8
    80006034:	f8e43423          	sd	a4,-120(s0)
    80006038:	4605                	li	a2,1
    8000603a:	45a9                	li	a1,10
    8000603c:	4388                	lw	a0,0(a5)
    8000603e:	00000097          	auipc	ra,0x0
    80006042:	e0e080e7          	jalr	-498(ra) # 80005e4c <printint>
        break;
    80006046:	b771                	j	80005fd2 <printf+0x9a>
        printptr(va_arg(ap, uint64));
    80006048:	f8843783          	ld	a5,-120(s0)
    8000604c:	00878713          	addi	a4,a5,8
    80006050:	f8e43423          	sd	a4,-120(s0)
    80006054:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80006058:	03000513          	li	a0,48
    8000605c:	00000097          	auipc	ra,0x0
    80006060:	bd0080e7          	jalr	-1072(ra) # 80005c2c <consputc>
  consputc('x');
    80006064:	07800513          	li	a0,120
    80006068:	00000097          	auipc	ra,0x0
    8000606c:	bc4080e7          	jalr	-1084(ra) # 80005c2c <consputc>
    80006070:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006072:	03c95793          	srli	a5,s2,0x3c
    80006076:	97da                	add	a5,a5,s6
    80006078:	0007c503          	lbu	a0,0(a5)
    8000607c:	00000097          	auipc	ra,0x0
    80006080:	bb0080e7          	jalr	-1104(ra) # 80005c2c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006084:	0912                	slli	s2,s2,0x4
    80006086:	34fd                	addiw	s1,s1,-1
    80006088:	f4ed                	bnez	s1,80006072 <printf+0x13a>
    8000608a:	b7a1                	j	80005fd2 <printf+0x9a>
        if ((s = va_arg(ap, char *)) == 0) s = "(null)";
    8000608c:	f8843783          	ld	a5,-120(s0)
    80006090:	00878713          	addi	a4,a5,8
    80006094:	f8e43423          	sd	a4,-120(s0)
    80006098:	6384                	ld	s1,0(a5)
    8000609a:	cc89                	beqz	s1,800060b4 <printf+0x17c>
        for (; *s; s++) consputc(*s);
    8000609c:	0004c503          	lbu	a0,0(s1)
    800060a0:	d90d                	beqz	a0,80005fd2 <printf+0x9a>
    800060a2:	00000097          	auipc	ra,0x0
    800060a6:	b8a080e7          	jalr	-1142(ra) # 80005c2c <consputc>
    800060aa:	0485                	addi	s1,s1,1
    800060ac:	0004c503          	lbu	a0,0(s1)
    800060b0:	f96d                	bnez	a0,800060a2 <printf+0x16a>
    800060b2:	b705                	j	80005fd2 <printf+0x9a>
        if ((s = va_arg(ap, char *)) == 0) s = "(null)";
    800060b4:	00002497          	auipc	s1,0x2
    800060b8:	6d448493          	addi	s1,s1,1748 # 80008788 <syscalls+0x400>
        for (; *s; s++) consputc(*s);
    800060bc:	02800513          	li	a0,40
    800060c0:	b7cd                	j	800060a2 <printf+0x16a>
        consputc('%');
    800060c2:	8556                	mv	a0,s5
    800060c4:	00000097          	auipc	ra,0x0
    800060c8:	b68080e7          	jalr	-1176(ra) # 80005c2c <consputc>
        break;
    800060cc:	b719                	j	80005fd2 <printf+0x9a>
        consputc('%');
    800060ce:	8556                	mv	a0,s5
    800060d0:	00000097          	auipc	ra,0x0
    800060d4:	b5c080e7          	jalr	-1188(ra) # 80005c2c <consputc>
        consputc(c);
    800060d8:	8526                	mv	a0,s1
    800060da:	00000097          	auipc	ra,0x0
    800060de:	b52080e7          	jalr	-1198(ra) # 80005c2c <consputc>
        break;
    800060e2:	bdc5                	j	80005fd2 <printf+0x9a>
  if (locking) release(&pr.lock);
    800060e4:	020d9163          	bnez	s11,80006106 <printf+0x1ce>
}
    800060e8:	70e6                	ld	ra,120(sp)
    800060ea:	7446                	ld	s0,112(sp)
    800060ec:	74a6                	ld	s1,104(sp)
    800060ee:	7906                	ld	s2,96(sp)
    800060f0:	69e6                	ld	s3,88(sp)
    800060f2:	6a46                	ld	s4,80(sp)
    800060f4:	6aa6                	ld	s5,72(sp)
    800060f6:	6b06                	ld	s6,64(sp)
    800060f8:	7be2                	ld	s7,56(sp)
    800060fa:	7c42                	ld	s8,48(sp)
    800060fc:	7ca2                	ld	s9,40(sp)
    800060fe:	7d02                	ld	s10,32(sp)
    80006100:	6de2                	ld	s11,24(sp)
    80006102:	6129                	addi	sp,sp,192
    80006104:	8082                	ret
  if (locking) release(&pr.lock);
    80006106:	0003c517          	auipc	a0,0x3c
    8000610a:	b9250513          	addi	a0,a0,-1134 # 80041c98 <pr>
    8000610e:	00000097          	auipc	ra,0x0
    80006112:	3d0080e7          	jalr	976(ra) # 800064de <release>
}
    80006116:	bfc9                	j	800060e8 <printf+0x1b0>

0000000080006118 <printfinit>:
    ;
}

void printfinit(void) {
    80006118:	1101                	addi	sp,sp,-32
    8000611a:	ec06                	sd	ra,24(sp)
    8000611c:	e822                	sd	s0,16(sp)
    8000611e:	e426                	sd	s1,8(sp)
    80006120:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006122:	0003c497          	auipc	s1,0x3c
    80006126:	b7648493          	addi	s1,s1,-1162 # 80041c98 <pr>
    8000612a:	00002597          	auipc	a1,0x2
    8000612e:	67658593          	addi	a1,a1,1654 # 800087a0 <syscalls+0x418>
    80006132:	8526                	mv	a0,s1
    80006134:	00000097          	auipc	ra,0x0
    80006138:	266080e7          	jalr	614(ra) # 8000639a <initlock>
  pr.locking = 1;
    8000613c:	4785                	li	a5,1
    8000613e:	cc9c                	sw	a5,24(s1)
}
    80006140:	60e2                	ld	ra,24(sp)
    80006142:	6442                	ld	s0,16(sp)
    80006144:	64a2                	ld	s1,8(sp)
    80006146:	6105                	addi	sp,sp,32
    80006148:	8082                	ret

000000008000614a <uartinit>:

extern volatile int panicked;  // from printf.c

void uartstart();

void uartinit(void) {
    8000614a:	1141                	addi	sp,sp,-16
    8000614c:	e406                	sd	ra,8(sp)
    8000614e:	e022                	sd	s0,0(sp)
    80006150:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006152:	100007b7          	lui	a5,0x10000
    80006156:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000615a:	f8000713          	li	a4,-128
    8000615e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006162:	470d                	li	a4,3
    80006164:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006168:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000616c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006170:	469d                	li	a3,7
    80006172:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006176:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000617a:	00002597          	auipc	a1,0x2
    8000617e:	64658593          	addi	a1,a1,1606 # 800087c0 <digits+0x18>
    80006182:	0003c517          	auipc	a0,0x3c
    80006186:	b3650513          	addi	a0,a0,-1226 # 80041cb8 <uart_tx_lock>
    8000618a:	00000097          	auipc	ra,0x0
    8000618e:	210080e7          	jalr	528(ra) # 8000639a <initlock>
}
    80006192:	60a2                	ld	ra,8(sp)
    80006194:	6402                	ld	s0,0(sp)
    80006196:	0141                	addi	sp,sp,16
    80006198:	8082                	ret

000000008000619a <uartputc_sync>:

// alternate version of uartputc() that doesn't
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void uartputc_sync(int c) {
    8000619a:	1101                	addi	sp,sp,-32
    8000619c:	ec06                	sd	ra,24(sp)
    8000619e:	e822                	sd	s0,16(sp)
    800061a0:	e426                	sd	s1,8(sp)
    800061a2:	1000                	addi	s0,sp,32
    800061a4:	84aa                	mv	s1,a0
  push_off();
    800061a6:	00000097          	auipc	ra,0x0
    800061aa:	238080e7          	jalr	568(ra) # 800063de <push_off>

  if (panicked) {
    800061ae:	00002797          	auipc	a5,0x2
    800061b2:	6be7a783          	lw	a5,1726(a5) # 8000886c <panicked>
    for (;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800061b6:	10000737          	lui	a4,0x10000
  if (panicked) {
    800061ba:	c391                	beqz	a5,800061be <uartputc_sync+0x24>
    for (;;)
    800061bc:	a001                	j	800061bc <uartputc_sync+0x22>
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800061be:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800061c2:	0207f793          	andi	a5,a5,32
    800061c6:	dfe5                	beqz	a5,800061be <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800061c8:	0ff4f513          	andi	a0,s1,255
    800061cc:	100007b7          	lui	a5,0x10000
    800061d0:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800061d4:	00000097          	auipc	ra,0x0
    800061d8:	2aa080e7          	jalr	682(ra) # 8000647e <pop_off>
}
    800061dc:	60e2                	ld	ra,24(sp)
    800061de:	6442                	ld	s0,16(sp)
    800061e0:	64a2                	ld	s1,8(sp)
    800061e2:	6105                	addi	sp,sp,32
    800061e4:	8082                	ret

00000000800061e6 <uartstart>:
// in the transmit buffer, send it.
// caller must hold uart_tx_lock.
// called from both the top- and bottom-half.
void uartstart() {
  while (1) {
    if (uart_tx_w == uart_tx_r) {
    800061e6:	00002797          	auipc	a5,0x2
    800061ea:	68a7b783          	ld	a5,1674(a5) # 80008870 <uart_tx_r>
    800061ee:	00002717          	auipc	a4,0x2
    800061f2:	68a73703          	ld	a4,1674(a4) # 80008878 <uart_tx_w>
    800061f6:	06f70a63          	beq	a4,a5,8000626a <uartstart+0x84>
void uartstart() {
    800061fa:	7139                	addi	sp,sp,-64
    800061fc:	fc06                	sd	ra,56(sp)
    800061fe:	f822                	sd	s0,48(sp)
    80006200:	f426                	sd	s1,40(sp)
    80006202:	f04a                	sd	s2,32(sp)
    80006204:	ec4e                	sd	s3,24(sp)
    80006206:	e852                	sd	s4,16(sp)
    80006208:	e456                	sd	s5,8(sp)
    8000620a:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }

    if ((ReadReg(LSR) & LSR_TX_IDLE) == 0) {
    8000620c:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }

    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006210:	0003ca17          	auipc	s4,0x3c
    80006214:	aa8a0a13          	addi	s4,s4,-1368 # 80041cb8 <uart_tx_lock>
    uart_tx_r += 1;
    80006218:	00002497          	auipc	s1,0x2
    8000621c:	65848493          	addi	s1,s1,1624 # 80008870 <uart_tx_r>
    if (uart_tx_w == uart_tx_r) {
    80006220:	00002997          	auipc	s3,0x2
    80006224:	65898993          	addi	s3,s3,1624 # 80008878 <uart_tx_w>
    if ((ReadReg(LSR) & LSR_TX_IDLE) == 0) {
    80006228:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000622c:	02077713          	andi	a4,a4,32
    80006230:	c705                	beqz	a4,80006258 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006232:	01f7f713          	andi	a4,a5,31
    80006236:	9752                	add	a4,a4,s4
    80006238:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000623c:	0785                	addi	a5,a5,1
    8000623e:	e09c                	sd	a5,0(s1)

    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006240:	8526                	mv	a0,s1
    80006242:	ffffb097          	auipc	ra,0xffffb
    80006246:	632080e7          	jalr	1586(ra) # 80001874 <wakeup>

    WriteReg(THR, c);
    8000624a:	01590023          	sb	s5,0(s2)
    if (uart_tx_w == uart_tx_r) {
    8000624e:	609c                	ld	a5,0(s1)
    80006250:	0009b703          	ld	a4,0(s3)
    80006254:	fcf71ae3          	bne	a4,a5,80006228 <uartstart+0x42>
  }
}
    80006258:	70e2                	ld	ra,56(sp)
    8000625a:	7442                	ld	s0,48(sp)
    8000625c:	74a2                	ld	s1,40(sp)
    8000625e:	7902                	ld	s2,32(sp)
    80006260:	69e2                	ld	s3,24(sp)
    80006262:	6a42                	ld	s4,16(sp)
    80006264:	6aa2                	ld	s5,8(sp)
    80006266:	6121                	addi	sp,sp,64
    80006268:	8082                	ret
    8000626a:	8082                	ret

000000008000626c <uartputc>:
void uartputc(int c) {
    8000626c:	7179                	addi	sp,sp,-48
    8000626e:	f406                	sd	ra,40(sp)
    80006270:	f022                	sd	s0,32(sp)
    80006272:	ec26                	sd	s1,24(sp)
    80006274:	e84a                	sd	s2,16(sp)
    80006276:	e44e                	sd	s3,8(sp)
    80006278:	e052                	sd	s4,0(sp)
    8000627a:	1800                	addi	s0,sp,48
    8000627c:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000627e:	0003c517          	auipc	a0,0x3c
    80006282:	a3a50513          	addi	a0,a0,-1478 # 80041cb8 <uart_tx_lock>
    80006286:	00000097          	auipc	ra,0x0
    8000628a:	1a4080e7          	jalr	420(ra) # 8000642a <acquire>
  if (panicked) {
    8000628e:	00002797          	auipc	a5,0x2
    80006292:	5de7a783          	lw	a5,1502(a5) # 8000886c <panicked>
    80006296:	e7c9                	bnez	a5,80006320 <uartputc+0xb4>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    80006298:	00002717          	auipc	a4,0x2
    8000629c:	5e073703          	ld	a4,1504(a4) # 80008878 <uart_tx_w>
    800062a0:	00002797          	auipc	a5,0x2
    800062a4:	5d07b783          	ld	a5,1488(a5) # 80008870 <uart_tx_r>
    800062a8:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800062ac:	0003c997          	auipc	s3,0x3c
    800062b0:	a0c98993          	addi	s3,s3,-1524 # 80041cb8 <uart_tx_lock>
    800062b4:	00002497          	auipc	s1,0x2
    800062b8:	5bc48493          	addi	s1,s1,1468 # 80008870 <uart_tx_r>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    800062bc:	00002917          	auipc	s2,0x2
    800062c0:	5bc90913          	addi	s2,s2,1468 # 80008878 <uart_tx_w>
    800062c4:	00e79f63          	bne	a5,a4,800062e2 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    800062c8:	85ce                	mv	a1,s3
    800062ca:	8526                	mv	a0,s1
    800062cc:	ffffb097          	auipc	ra,0xffffb
    800062d0:	544080e7          	jalr	1348(ra) # 80001810 <sleep>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    800062d4:	00093703          	ld	a4,0(s2)
    800062d8:	609c                	ld	a5,0(s1)
    800062da:	02078793          	addi	a5,a5,32
    800062de:	fee785e3          	beq	a5,a4,800062c8 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800062e2:	0003c497          	auipc	s1,0x3c
    800062e6:	9d648493          	addi	s1,s1,-1578 # 80041cb8 <uart_tx_lock>
    800062ea:	01f77793          	andi	a5,a4,31
    800062ee:	97a6                	add	a5,a5,s1
    800062f0:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800062f4:	0705                	addi	a4,a4,1
    800062f6:	00002797          	auipc	a5,0x2
    800062fa:	58e7b123          	sd	a4,1410(a5) # 80008878 <uart_tx_w>
  uartstart();
    800062fe:	00000097          	auipc	ra,0x0
    80006302:	ee8080e7          	jalr	-280(ra) # 800061e6 <uartstart>
  release(&uart_tx_lock);
    80006306:	8526                	mv	a0,s1
    80006308:	00000097          	auipc	ra,0x0
    8000630c:	1d6080e7          	jalr	470(ra) # 800064de <release>
}
    80006310:	70a2                	ld	ra,40(sp)
    80006312:	7402                	ld	s0,32(sp)
    80006314:	64e2                	ld	s1,24(sp)
    80006316:	6942                	ld	s2,16(sp)
    80006318:	69a2                	ld	s3,8(sp)
    8000631a:	6a02                	ld	s4,0(sp)
    8000631c:	6145                	addi	sp,sp,48
    8000631e:	8082                	ret
    for (;;)
    80006320:	a001                	j	80006320 <uartputc+0xb4>

0000000080006322 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int uartgetc(void) {
    80006322:	1141                	addi	sp,sp,-16
    80006324:	e422                	sd	s0,8(sp)
    80006326:	0800                	addi	s0,sp,16
  if (ReadReg(LSR) & 0x01) {
    80006328:	100007b7          	lui	a5,0x10000
    8000632c:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006330:	8b85                	andi	a5,a5,1
    80006332:	cb91                	beqz	a5,80006346 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006334:	100007b7          	lui	a5,0x10000
    80006338:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000633c:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006340:	6422                	ld	s0,8(sp)
    80006342:	0141                	addi	sp,sp,16
    80006344:	8082                	ret
    return -1;
    80006346:	557d                	li	a0,-1
    80006348:	bfe5                	j	80006340 <uartgetc+0x1e>

000000008000634a <uartintr>:

// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void uartintr(void) {
    8000634a:	1101                	addi	sp,sp,-32
    8000634c:	ec06                	sd	ra,24(sp)
    8000634e:	e822                	sd	s0,16(sp)
    80006350:	e426                	sd	s1,8(sp)
    80006352:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while (1) {
    int c = uartgetc();
    if (c == -1) break;
    80006354:	54fd                	li	s1,-1
    80006356:	a029                	j	80006360 <uartintr+0x16>
    consoleintr(c);
    80006358:	00000097          	auipc	ra,0x0
    8000635c:	916080e7          	jalr	-1770(ra) # 80005c6e <consoleintr>
    int c = uartgetc();
    80006360:	00000097          	auipc	ra,0x0
    80006364:	fc2080e7          	jalr	-62(ra) # 80006322 <uartgetc>
    if (c == -1) break;
    80006368:	fe9518e3          	bne	a0,s1,80006358 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000636c:	0003c497          	auipc	s1,0x3c
    80006370:	94c48493          	addi	s1,s1,-1716 # 80041cb8 <uart_tx_lock>
    80006374:	8526                	mv	a0,s1
    80006376:	00000097          	auipc	ra,0x0
    8000637a:	0b4080e7          	jalr	180(ra) # 8000642a <acquire>
  uartstart();
    8000637e:	00000097          	auipc	ra,0x0
    80006382:	e68080e7          	jalr	-408(ra) # 800061e6 <uartstart>
  release(&uart_tx_lock);
    80006386:	8526                	mv	a0,s1
    80006388:	00000097          	auipc	ra,0x0
    8000638c:	156080e7          	jalr	342(ra) # 800064de <release>
}
    80006390:	60e2                	ld	ra,24(sp)
    80006392:	6442                	ld	s0,16(sp)
    80006394:	64a2                	ld	s1,8(sp)
    80006396:	6105                	addi	sp,sp,32
    80006398:	8082                	ret

000000008000639a <initlock>:

#include "defs.h"
#include "proc.h"
#include "riscv.h"

void initlock(struct spinlock *lk, char *name) {
    8000639a:	1141                	addi	sp,sp,-16
    8000639c:	e422                	sd	s0,8(sp)
    8000639e:	0800                	addi	s0,sp,16
  lk->name = name;
    800063a0:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800063a2:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800063a6:	00053823          	sd	zero,16(a0)
}
    800063aa:	6422                	ld	s0,8(sp)
    800063ac:	0141                	addi	sp,sp,16
    800063ae:	8082                	ret

00000000800063b0 <holding>:

// Check whether this cpu is holding the lock.
// Interrupts must be off.
int holding(struct spinlock *lk) {
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800063b0:	411c                	lw	a5,0(a0)
    800063b2:	e399                	bnez	a5,800063b8 <holding+0x8>
    800063b4:	4501                	li	a0,0
  return r;
}
    800063b6:	8082                	ret
int holding(struct spinlock *lk) {
    800063b8:	1101                	addi	sp,sp,-32
    800063ba:	ec06                	sd	ra,24(sp)
    800063bc:	e822                	sd	s0,16(sp)
    800063be:	e426                	sd	s1,8(sp)
    800063c0:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800063c2:	6904                	ld	s1,16(a0)
    800063c4:	ffffb097          	auipc	ra,0xffffb
    800063c8:	d84080e7          	jalr	-636(ra) # 80001148 <mycpu>
    800063cc:	40a48533          	sub	a0,s1,a0
    800063d0:	00153513          	seqz	a0,a0
}
    800063d4:	60e2                	ld	ra,24(sp)
    800063d6:	6442                	ld	s0,16(sp)
    800063d8:	64a2                	ld	s1,8(sp)
    800063da:	6105                	addi	sp,sp,32
    800063dc:	8082                	ret

00000000800063de <push_off>:

// push_off/pop_off are like intr_off()/intr_on() except that they are matched:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void push_off(void) {
    800063de:	1101                	addi	sp,sp,-32
    800063e0:	ec06                	sd	ra,24(sp)
    800063e2:	e822                	sd	s0,16(sp)
    800063e4:	e426                	sd	s1,8(sp)
    800063e6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800063e8:	100024f3          	csrr	s1,sstatus
    800063ec:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    800063f0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800063f2:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if (mycpu()->noff == 0) mycpu()->intena = old;
    800063f6:	ffffb097          	auipc	ra,0xffffb
    800063fa:	d52080e7          	jalr	-686(ra) # 80001148 <mycpu>
    800063fe:	5d3c                	lw	a5,120(a0)
    80006400:	cf89                	beqz	a5,8000641a <push_off+0x3c>
  mycpu()->noff += 1;
    80006402:	ffffb097          	auipc	ra,0xffffb
    80006406:	d46080e7          	jalr	-698(ra) # 80001148 <mycpu>
    8000640a:	5d3c                	lw	a5,120(a0)
    8000640c:	2785                	addiw	a5,a5,1
    8000640e:	dd3c                	sw	a5,120(a0)
}
    80006410:	60e2                	ld	ra,24(sp)
    80006412:	6442                	ld	s0,16(sp)
    80006414:	64a2                	ld	s1,8(sp)
    80006416:	6105                	addi	sp,sp,32
    80006418:	8082                	ret
  if (mycpu()->noff == 0) mycpu()->intena = old;
    8000641a:	ffffb097          	auipc	ra,0xffffb
    8000641e:	d2e080e7          	jalr	-722(ra) # 80001148 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006422:	8085                	srli	s1,s1,0x1
    80006424:	8885                	andi	s1,s1,1
    80006426:	dd64                	sw	s1,124(a0)
    80006428:	bfe9                	j	80006402 <push_off+0x24>

000000008000642a <acquire>:
void acquire(struct spinlock *lk) {
    8000642a:	1101                	addi	sp,sp,-32
    8000642c:	ec06                	sd	ra,24(sp)
    8000642e:	e822                	sd	s0,16(sp)
    80006430:	e426                	sd	s1,8(sp)
    80006432:	1000                	addi	s0,sp,32
    80006434:	84aa                	mv	s1,a0
  push_off();  // disable interrupts to avoid deadlock.
    80006436:	00000097          	auipc	ra,0x0
    8000643a:	fa8080e7          	jalr	-88(ra) # 800063de <push_off>
  if (holding(lk)) panic("acquire");
    8000643e:	8526                	mv	a0,s1
    80006440:	00000097          	auipc	ra,0x0
    80006444:	f70080e7          	jalr	-144(ra) # 800063b0 <holding>
  while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006448:	4705                	li	a4,1
  if (holding(lk)) panic("acquire");
    8000644a:	e115                	bnez	a0,8000646e <acquire+0x44>
  while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000644c:	87ba                	mv	a5,a4
    8000644e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006452:	2781                	sext.w	a5,a5
    80006454:	ffe5                	bnez	a5,8000644c <acquire+0x22>
  __sync_synchronize();
    80006456:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000645a:	ffffb097          	auipc	ra,0xffffb
    8000645e:	cee080e7          	jalr	-786(ra) # 80001148 <mycpu>
    80006462:	e888                	sd	a0,16(s1)
}
    80006464:	60e2                	ld	ra,24(sp)
    80006466:	6442                	ld	s0,16(sp)
    80006468:	64a2                	ld	s1,8(sp)
    8000646a:	6105                	addi	sp,sp,32
    8000646c:	8082                	ret
  if (holding(lk)) panic("acquire");
    8000646e:	00002517          	auipc	a0,0x2
    80006472:	35a50513          	addi	a0,a0,858 # 800087c8 <digits+0x20>
    80006476:	00000097          	auipc	ra,0x0
    8000647a:	a78080e7          	jalr	-1416(ra) # 80005eee <panic>

000000008000647e <pop_off>:

void pop_off(void) {
    8000647e:	1141                	addi	sp,sp,-16
    80006480:	e406                	sd	ra,8(sp)
    80006482:	e022                	sd	s0,0(sp)
    80006484:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006486:	ffffb097          	auipc	ra,0xffffb
    8000648a:	cc2080e7          	jalr	-830(ra) # 80001148 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000648e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006492:	8b89                	andi	a5,a5,2
  if (intr_get()) panic("pop_off - interruptible");
    80006494:	e78d                	bnez	a5,800064be <pop_off+0x40>
  if (c->noff < 1) panic("pop_off");
    80006496:	5d3c                	lw	a5,120(a0)
    80006498:	02f05b63          	blez	a5,800064ce <pop_off+0x50>
  c->noff -= 1;
    8000649c:	37fd                	addiw	a5,a5,-1
    8000649e:	0007871b          	sext.w	a4,a5
    800064a2:	dd3c                	sw	a5,120(a0)
  if (c->noff == 0 && c->intena) intr_on();
    800064a4:	eb09                	bnez	a4,800064b6 <pop_off+0x38>
    800064a6:	5d7c                	lw	a5,124(a0)
    800064a8:	c799                	beqz	a5,800064b6 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800064aa:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    800064ae:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800064b2:	10079073          	csrw	sstatus,a5
}
    800064b6:	60a2                	ld	ra,8(sp)
    800064b8:	6402                	ld	s0,0(sp)
    800064ba:	0141                	addi	sp,sp,16
    800064bc:	8082                	ret
  if (intr_get()) panic("pop_off - interruptible");
    800064be:	00002517          	auipc	a0,0x2
    800064c2:	31250513          	addi	a0,a0,786 # 800087d0 <digits+0x28>
    800064c6:	00000097          	auipc	ra,0x0
    800064ca:	a28080e7          	jalr	-1496(ra) # 80005eee <panic>
  if (c->noff < 1) panic("pop_off");
    800064ce:	00002517          	auipc	a0,0x2
    800064d2:	31a50513          	addi	a0,a0,794 # 800087e8 <digits+0x40>
    800064d6:	00000097          	auipc	ra,0x0
    800064da:	a18080e7          	jalr	-1512(ra) # 80005eee <panic>

00000000800064de <release>:
void release(struct spinlock *lk) {
    800064de:	1101                	addi	sp,sp,-32
    800064e0:	ec06                	sd	ra,24(sp)
    800064e2:	e822                	sd	s0,16(sp)
    800064e4:	e426                	sd	s1,8(sp)
    800064e6:	1000                	addi	s0,sp,32
    800064e8:	84aa                	mv	s1,a0
  if (!holding(lk)) panic("release");
    800064ea:	00000097          	auipc	ra,0x0
    800064ee:	ec6080e7          	jalr	-314(ra) # 800063b0 <holding>
    800064f2:	c115                	beqz	a0,80006516 <release+0x38>
  lk->cpu = 0;
    800064f4:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800064f8:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800064fc:	0f50000f          	fence	iorw,ow
    80006500:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006504:	00000097          	auipc	ra,0x0
    80006508:	f7a080e7          	jalr	-134(ra) # 8000647e <pop_off>
}
    8000650c:	60e2                	ld	ra,24(sp)
    8000650e:	6442                	ld	s0,16(sp)
    80006510:	64a2                	ld	s1,8(sp)
    80006512:	6105                	addi	sp,sp,32
    80006514:	8082                	ret
  if (!holding(lk)) panic("release");
    80006516:	00002517          	auipc	a0,0x2
    8000651a:	2da50513          	addi	a0,a0,730 # 800087f0 <digits+0x48>
    8000651e:	00000097          	auipc	ra,0x0
    80006522:	9d0080e7          	jalr	-1584(ra) # 80005eee <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
