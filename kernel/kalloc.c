// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "constants.h"
#include "defs.h"
#include "memlayout.h"
#include "spinlock.h"
#include "types.h"

void freerange(void *pa_start, void *pa_end);

extern char end[];  // first address after kernel.
                    // defined by kernel.ld.

struct run {
  struct run *next;
};
uint64 pg_num(uint64 pa) { return (PGROUNDDOWN(pa) - KERNBASE) / PGSIZE; }

struct {
  struct spinlock lock;
  struct run *freelist;
  int ref_count[(PGROUNDDOWN(PHYSTOP) - KERNBASE) / PGSIZE];
} kmem;

void kinit() {
  initlock(&kmem.lock, "kmem");
  freerange(end, (void *)PHYSTOP);
}

void freerange(void *pa_start, void *pa_end) {
  char *p;
  p = (char *)PGROUNDUP((uint64)pa_start);
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE) kfree(p);
}

int getref(uint64 pa) {
  int res;
  acquire(&kmem.lock);
  res = kmem.ref_count[pg_num((uint64)pa)];
  release(&kmem.lock);
  return res;
}

int increase_ref(void *pa) {
  acquire(&kmem.lock);
  int ret = ++kmem.ref_count[pg_num((uint64)pa)];
  release(&kmem.lock);
  return ret;
}

int decrease_ref(void *pa) {
  acquire(&kmem.lock);
  int ret = --kmem.ref_count[pg_num((uint64)pa)];
  release(&kmem.lock);
  return ret;
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa) {
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  int ref_cnt = decrease_ref(pa);
  if (ref_cnt > 0) return;
  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run *)pa;

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *kalloc(void) {
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if (r) {
    kmem.ref_count[pg_num((uint64)r)] = 1;
    kmem.freelist = r->next;
  }
  release(&kmem.lock);

  if (r) memset((char *)r, 5, PGSIZE);  // fill with junk
  return (void *)r;
}
