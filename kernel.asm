
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 50 9e 11 80       	mov    $0x80119e50,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 70 44 10 80       	mov    $0x80104470,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 c5 10 80       	mov    $0x8010c554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 20 92 10 80       	push   $0x80109220
80100051:	68 20 c5 10 80       	push   $0x8010c520
80100056:	e8 25 5f 00 00       	call   80105f80 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c 0c 11 80       	mov    $0x80110c1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c 0c 11 80 1c 	movl   $0x80110c1c,0x80110c6c
8010006a:	0c 11 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 0c 11 80 1c 	movl   $0x80110c1c,0x80110c70
80100074:	0c 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c 0c 11 80 	movl   $0x80110c1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 92 10 80       	push   $0x80109227
80100097:	50                   	push   %eax
80100098:	e8 b3 5d 00 00       	call   80105e50 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 0c 11 80       	mov    0x80110c70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 0c 11 80    	mov    %ebx,0x80110c70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 09 11 80    	cmp    $0x801109c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 c5 10 80       	push   $0x8010c520
801000e4:	e8 67 60 00 00       	call   80106150 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 0c 11 80    	mov    0x80110c70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c 0c 11 80    	mov    0x80110c6c,%ebx
80100126:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 c5 10 80       	push   $0x8010c520
80100162:	e8 89 5f 00 00       	call   801060f0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 1e 5d 00 00       	call   80105e90 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 5f 35 00 00       	call   801036f0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 2e 92 10 80       	push   $0x8010922e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 6d 5d 00 00       	call   80105f30 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 17 35 00 00       	jmp    801036f0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 3f 92 10 80       	push   $0x8010923f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 2c 5d 00 00       	call   80105f30 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 dc 5c 00 00       	call   80105ef0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010021b:	e8 30 5f 00 00       	call   80106150 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 0c 11 80       	mov    0x80110c70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c 0c 11 80 	movl   $0x80110c1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 0c 11 80       	mov    0x80110c70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 0c 11 80    	mov    %ebx,0x80110c70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 c5 10 80 	movl   $0x8010c520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 7f 5e 00 00       	jmp    801060f0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 46 92 10 80       	push   $0x80109246
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 d7 29 00 00       	call   80102c70 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 80 16 11 80 	movl   $0x80111680,(%esp)
801002a0:	e8 ab 5e 00 00       	call   80106150 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 c0 15 11 80       	mov    0x801115c0,%eax
801002b5:	3b 05 c4 15 11 80    	cmp    0x801115c4,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 80 16 11 80       	push   $0x80111680
801002c8:	68 c0 15 11 80       	push   $0x801115c0
801002cd:	e8 8e 56 00 00       	call   80105960 <sleep>
    while(input.r == input.w){
801002d2:	a1 c0 15 11 80       	mov    0x801115c0,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 c4 15 11 80    	cmp    0x801115c4,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 e9 4c 00 00       	call   80104fd0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 80 16 11 80       	push   $0x80111680
801002f6:	e8 f5 5d 00 00       	call   801060f0 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 8c 28 00 00       	call   80102b90 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 c0 15 11 80    	mov    %edx,0x801115c0
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 40 15 11 80 	movsbl -0x7feeeac0(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 80 16 11 80       	push   $0x80111680
8010034c:	e8 9f 5d 00 00       	call   801060f0 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 36 28 00 00       	call   80102b90 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 c0 15 11 80       	mov    %eax,0x801115c0
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 b4 16 11 80 00 	movl   $0x0,0x801116b4
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 62 39 00 00       	call   80103d00 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 4d 92 10 80       	push   $0x8010924d
801003a7:	e8 54 03 00 00       	call   80100700 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 4b 03 00 00       	call   80100700 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 51 9b 10 80 	movl   $0x80109b51,(%esp)
801003bc:	e8 3f 03 00 00       	call   80100700 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 d3 5b 00 00       	call   80105fa0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 61 92 10 80       	push   $0x80109261
801003dd:	e8 1e 03 00 00       	call   80100700 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 b8 16 11 80 01 	movl   $0x1,0x801116b8
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 4a 01 00 00    	je     80100560 <consputc.part.0+0x160>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 11 79 00 00       	call   80107d30 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n'){
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 f2 00 00 00    	je     80100548 <consputc.part.0+0x148>
  for(int i = pos-1; i < pos + num_of_left_pressed; i++){
80100456:	8b 3d c4 16 11 80    	mov    0x801116c4,%edi
8010045c:	8d 34 38             	lea    (%eax,%edi,1),%esi
  else if(c == BACKSPACE){
8010045f:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100465:	0f 84 9d 00 00 00    	je     80100508 <consputc.part.0+0x108>
  for(int i = pos + num_of_left_pressed; i > pos; i--){
8010046b:	39 f0                	cmp    %esi,%eax
8010046d:	7d 1f                	jge    8010048e <consputc.part.0+0x8e>
8010046f:	8d 94 36 fe 7f 0b 80 	lea    -0x7ff48002(%esi,%esi,1),%edx
80100476:	8d b4 00 fe 7f 0b 80 	lea    -0x7ff48002(%eax,%eax,1),%esi
8010047d:	8d 76 00             	lea    0x0(%esi),%esi
    crt[i] = crt[i-1];
80100480:	0f b7 0a             	movzwl (%edx),%ecx
  for(int i = pos + num_of_left_pressed; i > pos; i--){
80100483:	83 ea 02             	sub    $0x2,%edx
    crt[i] = crt[i-1];
80100486:	66 89 4a 04          	mov    %cx,0x4(%edx)
  for(int i = pos + num_of_left_pressed; i > pos; i--){
8010048a:	39 d6                	cmp    %edx,%esi
8010048c:	75 f2                	jne    80100480 <consputc.part.0+0x80>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010048e:	0f b6 db             	movzbl %bl,%ebx
80100491:	8d 48 01             	lea    0x1(%eax),%ecx
80100494:	80 cf 07             	or     $0x7,%bh
80100497:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010049e:	80 
  if(pos < 0 || pos > 25*80)
8010049f:	81 f9 d0 07 00 00    	cmp    $0x7d0,%ecx
801004a5:	0f 8f 35 01 00 00    	jg     801005e0 <consputc.part.0+0x1e0>
  if((pos/80) >= 24){  // Scroll up.
801004ab:	81 f9 7f 07 00 00    	cmp    $0x77f,%ecx
801004b1:	0f 8f d9 00 00 00    	jg     80100590 <consputc.part.0+0x190>
  outb(CRTPORT+1, pos>>8);
801004b7:	0f b6 c5             	movzbl %ch,%eax
  crt[pos + num_of_left_pressed] = ' ' | 0x0700;
801004ba:	8b 3d c4 16 11 80    	mov    0x801116c4,%edi
  outb(CRTPORT+1, pos);
801004c0:	89 ce                	mov    %ecx,%esi
  outb(CRTPORT+1, pos>>8);
801004c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  crt[pos + num_of_left_pressed] = ' ' | 0x0700;
801004c5:	01 cf                	add    %ecx,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004c7:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004cc:	b8 0e 00 00 00       	mov    $0xe,%eax
801004d1:	89 da                	mov    %ebx,%edx
801004d3:	ee                   	out    %al,(%dx)
801004d4:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004d9:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
801004dd:	89 ca                	mov    %ecx,%edx
801004df:	ee                   	out    %al,(%dx)
801004e0:	b8 0f 00 00 00       	mov    $0xf,%eax
801004e5:	89 da                	mov    %ebx,%edx
801004e7:	ee                   	out    %al,(%dx)
801004e8:	89 f0                	mov    %esi,%eax
801004ea:	89 ca                	mov    %ecx,%edx
801004ec:	ee                   	out    %al,(%dx)
801004ed:	b8 20 07 00 00       	mov    $0x720,%eax
801004f2:	66 89 84 3f 00 80 0b 	mov    %ax,-0x7ff48000(%edi,%edi,1)
801004f9:	80 
}
801004fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004fd:	5b                   	pop    %ebx
801004fe:	5e                   	pop    %esi
801004ff:	5f                   	pop    %edi
80100500:	5d                   	pop    %ebp
80100501:	c3                   	ret    
80100502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(int i = pos-1; i < pos + num_of_left_pressed; i++){
80100508:	8d 48 ff             	lea    -0x1(%eax),%ecx
8010050b:	8d 94 00 00 80 0b 80 	lea    -0x7ff48000(%eax,%eax,1),%edx
80100512:	89 cb                	mov    %ecx,%ebx
80100514:	85 ff                	test   %edi,%edi
80100516:	78 1c                	js     80100534 <consputc.part.0+0x134>
80100518:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010051b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010051f:	90                   	nop
    crt[i] = crt[i + 1];
80100520:	0f b7 02             	movzwl (%edx),%eax
  for(int i = pos-1; i < pos + num_of_left_pressed; i++){
80100523:	83 c3 01             	add    $0x1,%ebx
80100526:	83 c2 02             	add    $0x2,%edx
    crt[i] = crt[i + 1];
80100529:	66 89 42 fc          	mov    %ax,-0x4(%edx)
  for(int i = pos-1; i < pos + num_of_left_pressed; i++){
8010052d:	39 f3                	cmp    %esi,%ebx
8010052f:	7c ef                	jl     80100520 <consputc.part.0+0x120>
80100531:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if(pos > 0) --pos;
80100534:	85 c0                	test   %eax,%eax
80100536:	0f 85 63 ff ff ff    	jne    8010049f <consputc.part.0+0x9f>
8010053c:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
80100540:	31 f6                	xor    %esi,%esi
80100542:	eb 83                	jmp    801004c7 <consputc.part.0+0xc7>
80100544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
80100548:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
8010054d:	f7 e2                	mul    %edx
8010054f:	c1 ea 06             	shr    $0x6,%edx
80100552:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100555:	c1 e0 04             	shl    $0x4,%eax
80100558:	8d 48 50             	lea    0x50(%eax),%ecx
8010055b:	e9 3f ff ff ff       	jmp    8010049f <consputc.part.0+0x9f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100560:	83 ec 0c             	sub    $0xc,%esp
80100563:	6a 08                	push   $0x8
80100565:	e8 c6 77 00 00       	call   80107d30 <uartputc>
8010056a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100571:	e8 ba 77 00 00       	call   80107d30 <uartputc>
80100576:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010057d:	e8 ae 77 00 00       	call   80107d30 <uartputc>
80100582:	83 c4 10             	add    $0x10,%esp
80100585:	e9 98 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100590:	83 ec 04             	sub    $0x4,%esp
80100593:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80100596:	68 60 0e 00 00       	push   $0xe60
8010059b:	68 a0 80 0b 80       	push   $0x800b80a0
801005a0:	68 00 80 0b 80       	push   $0x800b8000
801005a5:	e8 06 5d 00 00       	call   801062b0 <memmove>
    pos -= 80;
801005aa:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801005ad:	b8 80 07 00 00       	mov    $0x780,%eax
801005b2:	83 c4 0c             	add    $0xc,%esp
    pos -= 80;
801005b5:	8d 79 b0             	lea    -0x50(%ecx),%edi
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801005b8:	29 f8                	sub    %edi,%eax
  outb(CRTPORT+1, pos);
801005ba:	89 fe                	mov    %edi,%esi
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801005bc:	01 c0                	add    %eax,%eax
801005be:	50                   	push   %eax
801005bf:	8d 84 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%eax
801005c6:	6a 00                	push   $0x0
801005c8:	50                   	push   %eax
801005c9:	e8 42 5c 00 00       	call   80106210 <memset>
  crt[pos + num_of_left_pressed] = ' ' | 0x0700;
801005ce:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
801005d2:	03 3d c4 16 11 80    	add    0x801116c4,%edi
801005d8:	83 c4 10             	add    $0x10,%esp
801005db:	e9 e7 fe ff ff       	jmp    801004c7 <consputc.part.0+0xc7>
    panic("pos under/overflow");
801005e0:	83 ec 0c             	sub    $0xc,%esp
801005e3:	68 65 92 10 80       	push   $0x80109265
801005e8:	e8 93 fd ff ff       	call   80100380 <panic>
801005ed:	8d 76 00             	lea    0x0(%esi),%esi

801005f0 <consolewrite>:
int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
801005f9:	ff 75 08             	push   0x8(%ebp)
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
801005ff:	e8 6c 26 00 00       	call   80102c70 <iunlock>
  acquire(&cons.lock);
80100604:	c7 04 24 80 16 11 80 	movl   $0x80111680,(%esp)
8010060b:	e8 40 5b 00 00       	call   80106150 <acquire>
  for(i = 0; i < n; i++)
80100610:	83 c4 10             	add    $0x10,%esp
80100613:	85 f6                	test   %esi,%esi
80100615:	7e 25                	jle    8010063c <consolewrite+0x4c>
80100617:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010061a:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
8010061d:	8b 15 b8 16 11 80    	mov    0x801116b8,%edx
    consputc(buf[i] & 0xff);
80100623:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
80100626:	85 d2                	test   %edx,%edx
80100628:	74 06                	je     80100630 <consolewrite+0x40>
  asm volatile("cli");
8010062a:	fa                   	cli    
    for(;;)
8010062b:	eb fe                	jmp    8010062b <consolewrite+0x3b>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
80100630:	e8 cb fd ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
80100635:	83 c3 01             	add    $0x1,%ebx
80100638:	39 df                	cmp    %ebx,%edi
8010063a:	75 e1                	jne    8010061d <consolewrite+0x2d>
  release(&cons.lock);
8010063c:	83 ec 0c             	sub    $0xc,%esp
8010063f:	68 80 16 11 80       	push   $0x80111680
80100644:	e8 a7 5a 00 00       	call   801060f0 <release>
  ilock(ip);
80100649:	58                   	pop    %eax
8010064a:	ff 75 08             	push   0x8(%ebp)
8010064d:	e8 3e 25 00 00       	call   80102b90 <ilock>
  return n;
}
80100652:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100655:	89 f0                	mov    %esi,%eax
80100657:	5b                   	pop    %ebx
80100658:	5e                   	pop    %esi
80100659:	5f                   	pop    %edi
8010065a:	5d                   	pop    %ebp
8010065b:	c3                   	ret    
8010065c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100660 <printint>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 2c             	sub    $0x2c,%esp
80100669:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010066c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010066f:	85 c9                	test   %ecx,%ecx
80100671:	74 04                	je     80100677 <printint+0x17>
80100673:	85 c0                	test   %eax,%eax
80100675:	78 6d                	js     801006e4 <printint+0x84>
    x = xx;
80100677:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010067e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100680:	31 db                	xor    %ebx,%ebx
80100682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100688:	89 c8                	mov    %ecx,%eax
8010068a:	31 d2                	xor    %edx,%edx
8010068c:	89 de                	mov    %ebx,%esi
8010068e:	89 cf                	mov    %ecx,%edi
80100690:	f7 75 d4             	divl   -0x2c(%ebp)
80100693:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100696:	0f b6 92 dc 92 10 80 	movzbl -0x7fef6d24(%edx),%edx
  }while((x /= base) != 0);
8010069d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010069f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801006a3:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
801006a6:	73 e0                	jae    80100688 <printint+0x28>
  if(sign)
801006a8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801006ab:	85 c9                	test   %ecx,%ecx
801006ad:	74 0c                	je     801006bb <printint+0x5b>
    buf[i++] = '-';
801006af:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801006b4:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
801006b6:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801006bb:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
801006bf:	0f be c2             	movsbl %dl,%eax
  if(panicked){
801006c2:	8b 15 b8 16 11 80    	mov    0x801116b8,%edx
801006c8:	85 d2                	test   %edx,%edx
801006ca:	74 04                	je     801006d0 <printint+0x70>
801006cc:	fa                   	cli    
    for(;;)
801006cd:	eb fe                	jmp    801006cd <printint+0x6d>
801006cf:	90                   	nop
801006d0:	e8 2b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
801006d5:	8d 45 d7             	lea    -0x29(%ebp),%eax
801006d8:	39 c3                	cmp    %eax,%ebx
801006da:	74 0e                	je     801006ea <printint+0x8a>
    consputc(buf[i]);
801006dc:	0f be 03             	movsbl (%ebx),%eax
801006df:	83 eb 01             	sub    $0x1,%ebx
801006e2:	eb de                	jmp    801006c2 <printint+0x62>
    x = -xx;
801006e4:	f7 d8                	neg    %eax
801006e6:	89 c1                	mov    %eax,%ecx
801006e8:	eb 96                	jmp    80100680 <printint+0x20>
}
801006ea:	83 c4 2c             	add    $0x2c,%esp
801006ed:	5b                   	pop    %ebx
801006ee:	5e                   	pop    %esi
801006ef:	5f                   	pop    %edi
801006f0:	5d                   	pop    %ebp
801006f1:	c3                   	ret    
801006f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100700 <cprintf>:
{
80100700:	55                   	push   %ebp
80100701:	89 e5                	mov    %esp,%ebp
80100703:	57                   	push   %edi
80100704:	56                   	push   %esi
80100705:	53                   	push   %ebx
80100706:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100709:	a1 b4 16 11 80       	mov    0x801116b4,%eax
8010070e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
80100711:	85 c0                	test   %eax,%eax
80100713:	0f 85 27 01 00 00    	jne    80100840 <cprintf+0x140>
  if (fmt == 0)
80100719:	8b 75 08             	mov    0x8(%ebp),%esi
8010071c:	85 f6                	test   %esi,%esi
8010071e:	0f 84 ac 01 00 00    	je     801008d0 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100724:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100727:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010072a:	31 db                	xor    %ebx,%ebx
8010072c:	85 c0                	test   %eax,%eax
8010072e:	74 56                	je     80100786 <cprintf+0x86>
    if(c != '%'){
80100730:	83 f8 25             	cmp    $0x25,%eax
80100733:	0f 85 cf 00 00 00    	jne    80100808 <cprintf+0x108>
    c = fmt[++i] & 0xff;
80100739:	83 c3 01             	add    $0x1,%ebx
8010073c:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
80100740:	85 d2                	test   %edx,%edx
80100742:	74 42                	je     80100786 <cprintf+0x86>
    switch(c){
80100744:	83 fa 70             	cmp    $0x70,%edx
80100747:	0f 84 90 00 00 00    	je     801007dd <cprintf+0xdd>
8010074d:	7f 51                	jg     801007a0 <cprintf+0xa0>
8010074f:	83 fa 25             	cmp    $0x25,%edx
80100752:	0f 84 c0 00 00 00    	je     80100818 <cprintf+0x118>
80100758:	83 fa 64             	cmp    $0x64,%edx
8010075b:	0f 85 f4 00 00 00    	jne    80100855 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100761:	8d 47 04             	lea    0x4(%edi),%eax
80100764:	b9 01 00 00 00       	mov    $0x1,%ecx
80100769:	ba 0a 00 00 00       	mov    $0xa,%edx
8010076e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100771:	8b 07                	mov    (%edi),%eax
80100773:	e8 e8 fe ff ff       	call   80100660 <printint>
80100778:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010077b:	83 c3 01             	add    $0x1,%ebx
8010077e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100782:	85 c0                	test   %eax,%eax
80100784:	75 aa                	jne    80100730 <cprintf+0x30>
  if(locking)
80100786:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100789:	85 c0                	test   %eax,%eax
8010078b:	0f 85 22 01 00 00    	jne    801008b3 <cprintf+0x1b3>
}
80100791:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100794:	5b                   	pop    %ebx
80100795:	5e                   	pop    %esi
80100796:	5f                   	pop    %edi
80100797:	5d                   	pop    %ebp
80100798:	c3                   	ret    
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
801007a0:	83 fa 73             	cmp    $0x73,%edx
801007a3:	75 33                	jne    801007d8 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
801007a5:	8d 47 04             	lea    0x4(%edi),%eax
801007a8:	8b 3f                	mov    (%edi),%edi
801007aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007ad:	85 ff                	test   %edi,%edi
801007af:	0f 84 e3 00 00 00    	je     80100898 <cprintf+0x198>
      for(; *s; s++)
801007b5:	0f be 07             	movsbl (%edi),%eax
801007b8:	84 c0                	test   %al,%al
801007ba:	0f 84 08 01 00 00    	je     801008c8 <cprintf+0x1c8>
  if(panicked){
801007c0:	8b 15 b8 16 11 80    	mov    0x801116b8,%edx
801007c6:	85 d2                	test   %edx,%edx
801007c8:	0f 84 b2 00 00 00    	je     80100880 <cprintf+0x180>
801007ce:	fa                   	cli    
    for(;;)
801007cf:	eb fe                	jmp    801007cf <cprintf+0xcf>
801007d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
801007d8:	83 fa 78             	cmp    $0x78,%edx
801007db:	75 78                	jne    80100855 <cprintf+0x155>
      printint(*argp++, 16, 0);
801007dd:	8d 47 04             	lea    0x4(%edi),%eax
801007e0:	31 c9                	xor    %ecx,%ecx
801007e2:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007e7:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
801007ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007ed:	8b 07                	mov    (%edi),%eax
801007ef:	e8 6c fe ff ff       	call   80100660 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007f4:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
801007f8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007fb:	85 c0                	test   %eax,%eax
801007fd:	0f 85 2d ff ff ff    	jne    80100730 <cprintf+0x30>
80100803:	eb 81                	jmp    80100786 <cprintf+0x86>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100808:	8b 0d b8 16 11 80    	mov    0x801116b8,%ecx
8010080e:	85 c9                	test   %ecx,%ecx
80100810:	74 14                	je     80100826 <cprintf+0x126>
80100812:	fa                   	cli    
    for(;;)
80100813:	eb fe                	jmp    80100813 <cprintf+0x113>
80100815:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100818:	a1 b8 16 11 80       	mov    0x801116b8,%eax
8010081d:	85 c0                	test   %eax,%eax
8010081f:	75 6c                	jne    8010088d <cprintf+0x18d>
80100821:	b8 25 00 00 00       	mov    $0x25,%eax
80100826:	e8 d5 fb ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010082b:	83 c3 01             	add    $0x1,%ebx
8010082e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100832:	85 c0                	test   %eax,%eax
80100834:	0f 85 f6 fe ff ff    	jne    80100730 <cprintf+0x30>
8010083a:	e9 47 ff ff ff       	jmp    80100786 <cprintf+0x86>
8010083f:	90                   	nop
    acquire(&cons.lock);
80100840:	83 ec 0c             	sub    $0xc,%esp
80100843:	68 80 16 11 80       	push   $0x80111680
80100848:	e8 03 59 00 00       	call   80106150 <acquire>
8010084d:	83 c4 10             	add    $0x10,%esp
80100850:	e9 c4 fe ff ff       	jmp    80100719 <cprintf+0x19>
  if(panicked){
80100855:	8b 0d b8 16 11 80    	mov    0x801116b8,%ecx
8010085b:	85 c9                	test   %ecx,%ecx
8010085d:	75 31                	jne    80100890 <cprintf+0x190>
8010085f:	b8 25 00 00 00       	mov    $0x25,%eax
80100864:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100867:	e8 94 fb ff ff       	call   80100400 <consputc.part.0>
8010086c:	8b 15 b8 16 11 80    	mov    0x801116b8,%edx
80100872:	85 d2                	test   %edx,%edx
80100874:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100877:	74 2e                	je     801008a7 <cprintf+0x1a7>
80100879:	fa                   	cli    
    for(;;)
8010087a:	eb fe                	jmp    8010087a <cprintf+0x17a>
8010087c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100880:	e8 7b fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100885:	83 c7 01             	add    $0x1,%edi
80100888:	e9 28 ff ff ff       	jmp    801007b5 <cprintf+0xb5>
8010088d:	fa                   	cli    
    for(;;)
8010088e:	eb fe                	jmp    8010088e <cprintf+0x18e>
80100890:	fa                   	cli    
80100891:	eb fe                	jmp    80100891 <cprintf+0x191>
80100893:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100897:	90                   	nop
        s = "(null)";
80100898:	bf 78 92 10 80       	mov    $0x80109278,%edi
      for(; *s; s++)
8010089d:	b8 28 00 00 00       	mov    $0x28,%eax
801008a2:	e9 19 ff ff ff       	jmp    801007c0 <cprintf+0xc0>
801008a7:	89 d0                	mov    %edx,%eax
801008a9:	e8 52 fb ff ff       	call   80100400 <consputc.part.0>
801008ae:	e9 c8 fe ff ff       	jmp    8010077b <cprintf+0x7b>
    release(&cons.lock);
801008b3:	83 ec 0c             	sub    $0xc,%esp
801008b6:	68 80 16 11 80       	push   $0x80111680
801008bb:	e8 30 58 00 00       	call   801060f0 <release>
801008c0:	83 c4 10             	add    $0x10,%esp
}
801008c3:	e9 c9 fe ff ff       	jmp    80100791 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
801008c8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801008cb:	e9 ab fe ff ff       	jmp    8010077b <cprintf+0x7b>
    panic("null fmt");
801008d0:	83 ec 0c             	sub    $0xc,%esp
801008d3:	68 7f 92 10 80       	push   $0x8010927f
801008d8:	e8 a3 fa ff ff       	call   80100380 <panic>
801008dd:	8d 76 00             	lea    0x0(%esi),%esi

801008e0 <shift_back>:
void shift_back(int pos){
801008e0:	55                   	push   %ebp
  for(int i = pos-1; i < pos + num_of_left_pressed; i++){
801008e1:	8b 0d c4 16 11 80    	mov    0x801116c4,%ecx
void shift_back(int pos){
801008e7:	89 e5                	mov    %esp,%ebp
801008e9:	53                   	push   %ebx
801008ea:	8b 45 08             	mov    0x8(%ebp),%eax
  for(int i = pos-1; i < pos + num_of_left_pressed; i++){
801008ed:	8d 1c 08             	lea    (%eax,%ecx,1),%ebx
801008f0:	85 c9                	test   %ecx,%ecx
801008f2:	78 1d                	js     80100911 <shift_back+0x31>
801008f4:	8d 50 ff             	lea    -0x1(%eax),%edx
801008f7:	8d 84 00 00 80 0b 80 	lea    -0x7ff48000(%eax,%eax,1),%eax
801008fe:	66 90                	xchg   %ax,%ax
    crt[i] = crt[i + 1];
80100900:	0f b7 08             	movzwl (%eax),%ecx
  for(int i = pos-1; i < pos + num_of_left_pressed; i++){
80100903:	83 c2 01             	add    $0x1,%edx
80100906:	83 c0 02             	add    $0x2,%eax
    crt[i] = crt[i + 1];
80100909:	66 89 48 fc          	mov    %cx,-0x4(%eax)
  for(int i = pos-1; i < pos + num_of_left_pressed; i++){
8010090d:	39 da                	cmp    %ebx,%edx
8010090f:	7c ef                	jl     80100900 <shift_back+0x20>
}
80100911:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100914:	c9                   	leave  
80100915:	c3                   	ret    
80100916:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010091d:	8d 76 00             	lea    0x0(%esi),%esi

80100920 <push_right>:
void push_right(int pos){
80100920:	55                   	push   %ebp
  for(int i = pos + num_of_left_pressed; i > pos; i--){
80100921:	a1 c4 16 11 80       	mov    0x801116c4,%eax
void push_right(int pos){
80100926:	89 e5                	mov    %esp,%ebp
80100928:	8b 55 08             	mov    0x8(%ebp),%edx
  for(int i = pos + num_of_left_pressed; i > pos; i--){
8010092b:	01 d0                	add    %edx,%eax
8010092d:	39 c2                	cmp    %eax,%edx
8010092f:	7d 1d                	jge    8010094e <push_right+0x2e>
80100931:	8d 84 00 fe 7f 0b 80 	lea    -0x7ff48002(%eax,%eax,1),%eax
80100938:	8d 8c 12 fe 7f 0b 80 	lea    -0x7ff48002(%edx,%edx,1),%ecx
8010093f:	90                   	nop
    crt[i] = crt[i-1];
80100940:	0f b7 10             	movzwl (%eax),%edx
  for(int i = pos + num_of_left_pressed; i > pos; i--){
80100943:	83 e8 02             	sub    $0x2,%eax
    crt[i] = crt[i-1];
80100946:	66 89 50 04          	mov    %dx,0x4(%eax)
  for(int i = pos + num_of_left_pressed; i > pos; i--){
8010094a:	39 c8                	cmp    %ecx,%eax
8010094c:	75 f2                	jne    80100940 <push_right+0x20>
}
8010094e:	5d                   	pop    %ebp
8010094f:	c3                   	ret    

80100950 <show_current_history>:
void show_current_history(int temp){
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	57                   	push   %edi
80100954:	56                   	push   %esi
80100955:	53                   	push   %ebx
80100956:	83 ec 0c             	sub    $0xc,%esp
80100959:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for(int i = temp; i > 0; i--){
8010095c:	85 db                	test   %ebx,%ebx
8010095e:	7e 41                	jle    801009a1 <show_current_history+0x51>
80100960:	ba 98 14 11 80       	mov    $0x80111498,%edx
    if(input.buf[i - 1] != '\n'){
80100965:	83 eb 01             	sub    $0x1,%ebx
80100968:	80 bb 40 15 11 80 0a 	cmpb   $0xa,-0x7feeeac0(%ebx)
8010096f:	74 1e                	je     8010098f <show_current_history+0x3f>
  if(panicked){
80100971:	8b 0d b8 16 11 80    	mov    0x801116b8,%ecx
80100977:	85 c9                	test   %ecx,%ecx
80100979:	74 05                	je     80100980 <show_current_history+0x30>
8010097b:	fa                   	cli    
    for(;;)
8010097c:	eb fe                	jmp    8010097c <show_current_history+0x2c>
8010097e:	66 90                	xchg   %ax,%ax
80100980:	b8 00 01 00 00       	mov    $0x100,%eax
80100985:	e8 76 fa ff ff       	call   80100400 <consputc.part.0>
8010098a:	ba 98 14 11 80       	mov    $0x80111498,%edx
  input = history_cmnd.current_command;
8010098f:	b9 23 00 00 00       	mov    $0x23,%ecx
80100994:	bf 40 15 11 80       	mov    $0x80111540,%edi
80100999:	89 d6                	mov    %edx,%esi
8010099b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(int i = temp; i > 0; i--){
8010099d:	85 db                	test   %ebx,%ebx
8010099f:	75 c4                	jne    80100965 <show_current_history+0x15>
  for(int j = input.w; j < input.e; j++){
801009a1:	8b 1d c4 15 11 80    	mov    0x801115c4,%ebx
801009a7:	3b 1d c8 15 11 80    	cmp    0x801115c8,%ebx
801009ad:	73 29                	jae    801009d8 <show_current_history+0x88>
  if(panicked){
801009af:	8b 15 b8 16 11 80    	mov    0x801116b8,%edx
        consputc(input.buf[j]);
801009b5:	0f be 83 40 15 11 80 	movsbl -0x7feeeac0(%ebx),%eax
  if(panicked){
801009bc:	85 d2                	test   %edx,%edx
801009be:	74 08                	je     801009c8 <show_current_history+0x78>
801009c0:	fa                   	cli    
    for(;;)
801009c1:	eb fe                	jmp    801009c1 <show_current_history+0x71>
801009c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801009c7:	90                   	nop
801009c8:	e8 33 fa ff ff       	call   80100400 <consputc.part.0>
  for(int j = input.w; j < input.e; j++){
801009cd:	83 c3 01             	add    $0x1,%ebx
801009d0:	39 1d c8 15 11 80    	cmp    %ebx,0x801115c8
801009d6:	77 d7                	ja     801009af <show_current_history+0x5f>
}
801009d8:	83 c4 0c             	add    $0xc,%esp
801009db:	5b                   	pop    %ebx
801009dc:	5e                   	pop    %esi
801009dd:	5f                   	pop    %edi
801009de:	5d                   	pop    %ebp
801009df:	c3                   	ret    

801009e0 <is_history>:
int is_history(char* command){
801009e0:	55                   	push   %ebp
    if(command[i] != input.buf[i + input.w]){
801009e1:	8b 15 c4 15 11 80    	mov    0x801115c4,%edx
  for(int i = 0; i < 8; i++){
801009e7:	31 c0                	xor    %eax,%eax
int is_history(char* command){
801009e9:	89 e5                	mov    %esp,%ebp
801009eb:	53                   	push   %ebx
801009ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
801009ef:	90                   	nop
    if(command[i] != input.buf[i + input.w]){
801009f0:	0f b6 9c 02 40 15 11 	movzbl -0x7feeeac0(%edx,%eax,1),%ebx
801009f7:	80 
801009f8:	38 1c 01             	cmp    %bl,(%ecx,%eax,1)
801009fb:	75 13                	jne    80100a10 <is_history+0x30>
  for(int i = 0; i < 8; i++){
801009fd:	83 c0 01             	add    $0x1,%eax
80100a00:	83 f8 08             	cmp    $0x8,%eax
80100a03:	75 eb                	jne    801009f0 <is_history+0x10>
}
80100a05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 1;
80100a08:	b8 01 00 00 00       	mov    $0x1,%eax
}
80100a0d:	c9                   	leave  
80100a0e:	c3                   	ret    
80100a0f:	90                   	nop
80100a10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80100a13:	31 c0                	xor    %eax,%eax
}
80100a15:	c9                   	leave  
80100a16:	c3                   	ret    
80100a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a1e:	66 90                	xchg   %ax,%ax

80100a20 <print_history>:
void print_history(){
80100a20:	55                   	push   %ebp
80100a21:	89 e5                	mov    %esp,%ebp
80100a23:	57                   	push   %edi
80100a24:	56                   	push   %esi
80100a25:	53                   	push   %ebx
80100a26:	83 ec 28             	sub    $0x28,%esp
  release(&cons.lock);
80100a29:	68 80 16 11 80       	push   $0x80111680
80100a2e:	e8 bd 56 00 00       	call   801060f0 <release>
  for(int i = 0; i < history_cmnd.num_of_cmnd; i++){
80100a33:	8b 0d 24 15 11 80    	mov    0x80111524,%ecx
80100a39:	83 c4 10             	add    $0x10,%esp
80100a3c:	85 c9                	test   %ecx,%ecx
80100a3e:	7e 6a                	jle    80100aaa <print_history+0x8a>
80100a40:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100a47:	bb 20 0f 11 80       	mov    $0x80110f20,%ebx
80100a4c:	ba 40 15 11 80       	mov    $0x80111540,%edx
      input = history_cmnd.hist[i];
80100a51:	b9 23 00 00 00       	mov    $0x23,%ecx
80100a56:	89 d7                	mov    %edx,%edi
80100a58:	89 de                	mov    %ebx,%esi
80100a5a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
      for(int j = history_cmnd.hist[i].w; j < history_cmnd.hist[i].e; j++){
80100a5c:	8b b3 84 00 00 00    	mov    0x84(%ebx),%esi
80100a62:	3b b3 88 00 00 00    	cmp    0x88(%ebx),%esi
80100a68:	73 2b                	jae    80100a95 <print_history+0x75>
  if(panicked){
80100a6a:	8b 15 b8 16 11 80    	mov    0x801116b8,%edx
        consputc(input.buf[j]);
80100a70:	0f be 86 40 15 11 80 	movsbl -0x7feeeac0(%esi),%eax
  if(panicked){
80100a77:	85 d2                	test   %edx,%edx
80100a79:	74 05                	je     80100a80 <print_history+0x60>
80100a7b:	fa                   	cli    
    for(;;)
80100a7c:	eb fe                	jmp    80100a7c <print_history+0x5c>
80100a7e:	66 90                	xchg   %ax,%ax
80100a80:	e8 7b f9 ff ff       	call   80100400 <consputc.part.0>
      for(int j = history_cmnd.hist[i].w; j < history_cmnd.hist[i].e; j++){
80100a85:	83 c6 01             	add    $0x1,%esi
80100a88:	39 b3 88 00 00 00    	cmp    %esi,0x88(%ebx)
80100a8e:	ba 40 15 11 80       	mov    $0x80111540,%edx
80100a93:	77 d5                	ja     80100a6a <print_history+0x4a>
  for(int i = 0; i < history_cmnd.num_of_cmnd; i++){
80100a95:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100a99:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80100a9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100aa2:	39 05 24 15 11 80    	cmp    %eax,0x80111524
80100aa8:	7f a7                	jg     80100a51 <print_history+0x31>
  acquire(&cons.lock);
80100aaa:	83 ec 0c             	sub    $0xc,%esp
80100aad:	68 80 16 11 80       	push   $0x80111680
80100ab2:	e8 99 56 00 00       	call   80106150 <acquire>
}
80100ab7:	83 c4 10             	add    $0x10,%esp
80100aba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100abd:	5b                   	pop    %ebx
80100abe:	5e                   	pop    %esi
80100abf:	5f                   	pop    %edi
80100ac0:	5d                   	pop    %ebp
80100ac1:	c3                   	ret    
80100ac2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ad0 <handle_shifting>:
void handle_shifting(int length, int cursor_pos){
80100ad0:	55                   	push   %ebp
  for (int i = input.e - 1; i >= cursor_pos; i--)
80100ad1:	a1 c8 15 11 80       	mov    0x801115c8,%eax
80100ad6:	83 e8 01             	sub    $0x1,%eax
void handle_shifting(int length, int cursor_pos){
80100ad9:	89 e5                	mov    %esp,%ebp
80100adb:	53                   	push   %ebx
80100adc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100adf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for (int i = input.e - 1; i >= cursor_pos; i--)
80100ae2:	39 c8                	cmp    %ecx,%eax
80100ae4:	7c 1f                	jl     80100b05 <handle_shifting+0x35>
80100ae6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aed:	8d 76 00             	lea    0x0(%esi),%esi
    input.buf[i + length] = input.buf[i];
80100af0:	0f b6 90 40 15 11 80 	movzbl -0x7feeeac0(%eax),%edx
80100af7:	88 94 03 40 15 11 80 	mov    %dl,-0x7feeeac0(%ebx,%eax,1)
  for (int i = input.e - 1; i >= cursor_pos; i--)
80100afe:	83 e8 01             	sub    $0x1,%eax
80100b01:	39 c1                	cmp    %eax,%ecx
80100b03:	7e eb                	jle    80100af0 <handle_shifting+0x20>
}
80100b05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100b08:	c9                   	leave  
80100b09:	c3                   	ret    
80100b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100b10 <print_copied_command>:
void print_copied_command(){
80100b10:	55                   	push   %ebp
80100b11:	89 e5                	mov    %esp,%ebp
80100b13:	57                   	push   %edi
80100b14:	56                   	push   %esi
80100b15:	53                   	push   %ebx
80100b16:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < cur_index; i++){
80100b19:	a1 d4 15 11 80       	mov    0x801115d4,%eax
80100b1e:	85 c0                	test   %eax,%eax
80100b20:	7e 2f                	jle    80100b51 <print_copied_command+0x41>
80100b22:	31 db                	xor    %ebx,%ebx
  if(panicked){
80100b24:	8b 15 b8 16 11 80    	mov    0x801116b8,%edx
    consputc(coppied_input[i]);
80100b2a:	0f be 83 e0 15 11 80 	movsbl -0x7feeea20(%ebx),%eax
  if(panicked){
80100b31:	85 d2                	test   %edx,%edx
80100b33:	74 0b                	je     80100b40 <print_copied_command+0x30>
80100b35:	fa                   	cli    
    for(;;)
80100b36:	eb fe                	jmp    80100b36 <print_copied_command+0x26>
80100b38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b3f:	90                   	nop
80100b40:	e8 bb f8 ff ff       	call   80100400 <consputc.part.0>
  for(int i = 0; i < cur_index; i++){
80100b45:	a1 d4 15 11 80       	mov    0x801115d4,%eax
80100b4a:	83 c3 01             	add    $0x1,%ebx
80100b4d:	39 d8                	cmp    %ebx,%eax
80100b4f:	7f d3                	jg     80100b24 <print_copied_command+0x14>
  if(num_of_left_pressed > 0){
80100b51:	8b 35 c4 16 11 80    	mov    0x801116c4,%esi
    handle_shifting(cur_index, input.e - num_of_left_pressed);
80100b57:	8b 1d c8 15 11 80    	mov    0x801115c8,%ebx
  if(num_of_left_pressed > 0){
80100b5d:	85 f6                	test   %esi,%esi
80100b5f:	7f 3d                	jg     80100b9e <print_copied_command+0x8e>
  for(int i = 0; coppied_input[i] != '\0'; i++){
80100b61:	0f b6 15 e0 15 11 80 	movzbl 0x801115e0,%edx
    input.buf[x - num_of_left_pressed + i] = coppied_input[i];
80100b68:	89 df                	mov    %ebx,%edi
  for(int i = 0; coppied_input[i] != '\0'; i++){
80100b6a:	31 c0                	xor    %eax,%eax
80100b6c:	83 c3 01             	add    $0x1,%ebx
    input.buf[x - num_of_left_pressed + i] = coppied_input[i];
80100b6f:	29 f7                	sub    %esi,%edi
  for(int i = 0; coppied_input[i] != '\0'; i++){
80100b71:	84 d2                	test   %dl,%dl
80100b73:	74 21                	je     80100b96 <print_copied_command+0x86>
80100b75:	8d 76 00             	lea    0x0(%esi),%esi
    input.buf[x - num_of_left_pressed + i] = coppied_input[i];
80100b78:	88 94 07 40 15 11 80 	mov    %dl,-0x7feeeac0(%edi,%eax,1)
    input.e++;
80100b7f:	8d 0c 03             	lea    (%ebx,%eax,1),%ecx
  for(int i = 0; coppied_input[i] != '\0'; i++){
80100b82:	83 c0 01             	add    $0x1,%eax
80100b85:	0f b6 90 e0 15 11 80 	movzbl -0x7feeea20(%eax),%edx
80100b8c:	84 d2                	test   %dl,%dl
80100b8e:	75 e8                	jne    80100b78 <print_copied_command+0x68>
80100b90:	89 0d c8 15 11 80    	mov    %ecx,0x801115c8
}
80100b96:	83 c4 0c             	add    $0xc,%esp
80100b99:	5b                   	pop    %ebx
80100b9a:	5e                   	pop    %esi
80100b9b:	5f                   	pop    %edi
80100b9c:	5d                   	pop    %ebp
80100b9d:	c3                   	ret    
    handle_shifting(cur_index, input.e - num_of_left_pressed);
80100b9e:	89 df                	mov    %ebx,%edi
  for (int i = input.e - 1; i >= cursor_pos; i--)
80100ba0:	8d 53 ff             	lea    -0x1(%ebx),%edx
    handle_shifting(cur_index, input.e - num_of_left_pressed);
80100ba3:	29 f7                	sub    %esi,%edi
  for (int i = input.e - 1; i >= cursor_pos; i--)
80100ba5:	39 d7                	cmp    %edx,%edi
80100ba7:	7f b8                	jg     80100b61 <print_copied_command+0x51>
    input.buf[i + length] = input.buf[i];
80100ba9:	0f b6 8a 40 15 11 80 	movzbl -0x7feeeac0(%edx),%ecx
80100bb0:	88 8c 10 40 15 11 80 	mov    %cl,-0x7feeeac0(%eax,%edx,1)
  for (int i = input.e - 1; i >= cursor_pos; i--)
80100bb7:	83 ea 01             	sub    $0x1,%edx
80100bba:	39 d7                	cmp    %edx,%edi
80100bbc:	7e eb                	jle    80100ba9 <print_copied_command+0x99>
80100bbe:	eb a1                	jmp    80100b61 <print_copied_command+0x51>

80100bc0 <handle_ctrl_s>:
void handle_ctrl_s(){
80100bc0:	55                   	push   %ebp
80100bc1:	89 e5                	mov    %esp,%ebp
80100bc3:	83 ec 0c             	sub    $0xc,%esp
  start_ctrl_s = input.e;
80100bc6:	a1 c8 15 11 80       	mov    0x801115c8,%eax
  memset(coppied_input, '\0', sizeof(coppied_input));
80100bcb:	68 80 00 00 00       	push   $0x80
80100bd0:	6a 00                	push   $0x0
80100bd2:	68 e0 15 11 80       	push   $0x801115e0
  start_ctrl_s = input.e;
80100bd7:	a3 bc 16 11 80       	mov    %eax,0x801116bc
  memset(coppied_input, '\0', sizeof(coppied_input));
80100bdc:	e8 2f 56 00 00       	call   80106210 <memset>
}
80100be1:	83 c4 10             	add    $0x10,%esp
80100be4:	c9                   	leave  
80100be5:	c3                   	ret    
80100be6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bed:	8d 76 00             	lea    0x0(%esi),%esi

80100bf0 <handle_ctrl_f>:
  if(ctrl_s_pressed){
80100bf0:	a1 c0 16 11 80       	mov    0x801116c0,%eax
80100bf5:	85 c0                	test   %eax,%eax
80100bf7:	75 07                	jne    80100c00 <handle_ctrl_f+0x10>
}
80100bf9:	c3                   	ret    
80100bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    print_copied_command();
80100c00:	e9 0b ff ff ff       	jmp    80100b10 <print_copied_command>
80100c05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100c10 <update_coppied_commands>:
void update_coppied_commands(){
80100c10:	55                   	push   %ebp
  for(int i = start_ctrl_s; i < input.e; i++){
80100c11:	8b 0d c8 15 11 80    	mov    0x801115c8,%ecx
void update_coppied_commands(){
80100c17:	89 e5                	mov    %esp,%ebp
80100c19:	57                   	push   %edi
80100c1a:	56                   	push   %esi
80100c1b:	53                   	push   %ebx
  for(int i = start_ctrl_s; i < input.e; i++){
80100c1c:	8b 1d bc 16 11 80    	mov    0x801116bc,%ebx
80100c22:	39 d9                	cmp    %ebx,%ecx
80100c24:	76 41                	jbe    80100c67 <update_coppied_commands+0x57>
80100c26:	89 cf                	mov    %ecx,%edi
80100c28:	8b 15 08 0f 11 80    	mov    0x80110f08,%edx
80100c2e:	31 c0                	xor    %eax,%eax
80100c30:	31 f6                	xor    %esi,%esi
80100c32:	29 df                	sub    %ebx,%edi
80100c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(copied_command.e < INPUT_BUF){
80100c38:	83 fa 7f             	cmp    $0x7f,%edx
80100c3b:	77 17                	ja     80100c54 <update_coppied_commands+0x44>
      copied_command.buf[copied_command.e + (i - start_ctrl_s)] = input.buf[i];
80100c3d:	0f b6 8c 03 40 15 11 	movzbl -0x7feeeac0(%ebx,%eax,1),%ecx
80100c44:	80 
      copied_command.e++;
80100c45:	be 01 00 00 00       	mov    $0x1,%esi
      copied_command.buf[copied_command.e + (i - start_ctrl_s)] = input.buf[i];
80100c4a:	88 8c 10 80 0e 11 80 	mov    %cl,-0x7feef180(%eax,%edx,1)
      copied_command.e++;
80100c51:	83 c2 01             	add    $0x1,%edx
  for(int i = start_ctrl_s; i < input.e; i++){
80100c54:	83 c0 01             	add    $0x1,%eax
80100c57:	39 f8                	cmp    %edi,%eax
80100c59:	75 dd                	jne    80100c38 <update_coppied_commands+0x28>
80100c5b:	89 f0                	mov    %esi,%eax
80100c5d:	84 c0                	test   %al,%al
80100c5f:	74 06                	je     80100c67 <update_coppied_commands+0x57>
80100c61:	89 15 08 0f 11 80    	mov    %edx,0x80110f08
}
80100c67:	5b                   	pop    %ebx
80100c68:	5e                   	pop    %esi
80100c69:	5f                   	pop    %edi
80100c6a:	5d                   	pop    %ebp
80100c6b:	c3                   	ret    
80100c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100c70 <convert_char_to_int>:
int convert_char_to_int(char* digits, int size_of_number){
80100c70:	55                   	push   %ebp
80100c71:	89 e5                	mov    %esp,%ebp
80100c73:	57                   	push   %edi
  int result = 0;
80100c74:	31 ff                	xor    %edi,%edi
  for(int i = 0; i < size_of_number; i++){
80100c76:	8b 45 0c             	mov    0xc(%ebp),%eax
int convert_char_to_int(char* digits, int size_of_number){
80100c79:	56                   	push   %esi
80100c7a:	53                   	push   %ebx
  for(int i = 0; i < size_of_number; i++){
80100c7b:	85 c0                	test   %eax,%eax
80100c7d:	7e 41                	jle    80100cc0 <convert_char_to_int+0x50>
80100c7f:	31 f6                	xor    %esi,%esi
80100c81:	b8 01 00 00 00       	mov    $0x1,%eax
80100c86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c8d:	8d 76 00             	lea    0x0(%esi),%esi
    result += ((int)digits[i] - 48) * power_10;
80100c90:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100c93:	0f be 14 33          	movsbl (%ebx,%esi,1),%edx
80100c97:	89 f3                	mov    %esi,%ebx
  for(int i = 0; i < size_of_number; i++){
80100c99:	83 c6 01             	add    $0x1,%esi
    result += ((int)digits[i] - 48) * power_10;
80100c9c:	83 ea 30             	sub    $0x30,%edx
80100c9f:	0f af c2             	imul   %edx,%eax
80100ca2:	01 c7                	add    %eax,%edi
  for(int i = 0; i < size_of_number; i++){
80100ca4:	39 75 0c             	cmp    %esi,0xc(%ebp)
80100ca7:	74 17                	je     80100cc0 <convert_char_to_int+0x50>
    for(int j = 0; j < i; j++){
80100ca9:	31 d2                	xor    %edx,%edx
    int power_10 = 1;
80100cab:	b8 01 00 00 00       	mov    $0x1,%eax
      power_10 *= 10;
80100cb0:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100cb3:	89 d1                	mov    %edx,%ecx
    for(int j = 0; j < i; j++){
80100cb5:	83 c2 01             	add    $0x1,%edx
      power_10 *= 10;
80100cb8:	01 c0                	add    %eax,%eax
    for(int j = 0; j < i; j++){
80100cba:	39 cb                	cmp    %ecx,%ebx
80100cbc:	75 f2                	jne    80100cb0 <convert_char_to_int+0x40>
80100cbe:	eb d0                	jmp    80100c90 <convert_char_to_int+0x20>
}
80100cc0:	5b                   	pop    %ebx
80100cc1:	89 f8                	mov    %edi,%eax
80100cc3:	5e                   	pop    %esi
80100cc4:	5f                   	pop    %edi
80100cc5:	5d                   	pop    %ebp
80100cc6:	c3                   	ret    
80100cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100cce:	66 90                	xchg   %ax,%ax

80100cd0 <int_to_string>:
int int_to_string(float num, char * string){
80100cd0:	55                   	push   %ebp
  if((int)(num * 10) % 10 != 0){
80100cd1:	ba 67 66 66 66       	mov    $0x66666667,%edx
int int_to_string(float num, char * string){
80100cd6:	89 e5                	mov    %esp,%ebp
80100cd8:	57                   	push   %edi
80100cd9:	56                   	push   %esi
80100cda:	53                   	push   %ebx
80100cdb:	83 ec 08             	sub    $0x8,%esp
80100cde:	d9 45 08             	flds   0x8(%ebp)
80100ce1:	8b 75 0c             	mov    0xc(%ebp),%esi
  int num1 = num;
80100ce4:	d9 7d f2             	fnstcw -0xe(%ebp)
80100ce7:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
80100ceb:	80 cc 0c             	or     $0xc,%ah
80100cee:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
80100cf2:	d9 6d f0             	fldcw  -0x10(%ebp)
80100cf5:	db 55 ec             	fistl  -0x14(%ebp)
80100cf8:	d9 6d f2             	fldcw  -0xe(%ebp)
  if((int)(num * 10) % 10 != 0){
80100cfb:	d8 0d f0 92 10 80    	fmuls  0x801092f0
  int num1 = num;
80100d01:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  if((int)(num * 10) % 10 != 0){
80100d04:	d9 6d f0             	fldcw  -0x10(%ebp)
80100d07:	db 5d ec             	fistpl -0x14(%ebp)
80100d0a:	d9 6d f2             	fldcw  -0xe(%ebp)
80100d0d:	8b 7d ec             	mov    -0x14(%ebp),%edi
80100d10:	89 f8                	mov    %edi,%eax
80100d12:	f7 ea                	imul   %edx
80100d14:	89 f8                	mov    %edi,%eax
80100d16:	c1 f8 1f             	sar    $0x1f,%eax
80100d19:	c1 fa 02             	sar    $0x2,%edx
80100d1c:	89 d1                	mov    %edx,%ecx
80100d1e:	29 c1                	sub    %eax,%ecx
80100d20:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
80100d23:	89 f9                	mov    %edi,%ecx
80100d25:	01 c0                	add    %eax,%eax
80100d27:	29 c1                	sub    %eax,%ecx
80100d29:	74 0e                	je     80100d39 <int_to_string+0x69>
    string[i] = '.';
80100d2b:	c6 46 01 2e          	movb   $0x2e,0x1(%esi)
    string[i] = ((int)(num * 10) % 10) + '0';
80100d2f:	83 c1 30             	add    $0x30,%ecx
80100d32:	88 0e                	mov    %cl,(%esi)
    i++;
80100d34:	b9 02 00 00 00       	mov    $0x2,%ecx
  while(num1 > 0){
80100d39:	85 db                	test   %ebx,%ebx
80100d3b:	7e 28                	jle    80100d65 <int_to_string+0x95>
80100d3d:	8d 76 00             	lea    0x0(%esi),%esi
    int temp  = num1 % 10;
80100d40:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
80100d45:	f7 e3                	mul    %ebx
80100d47:	89 d8                	mov    %ebx,%eax
80100d49:	c1 ea 03             	shr    $0x3,%edx
80100d4c:	8d 3c 92             	lea    (%edx,%edx,4),%edi
80100d4f:	01 ff                	add    %edi,%edi
80100d51:	29 f8                	sub    %edi,%eax
    string[i] = temp + '0';
80100d53:	83 c0 30             	add    $0x30,%eax
80100d56:	88 04 0e             	mov    %al,(%esi,%ecx,1)
    i++;
80100d59:	89 d8                	mov    %ebx,%eax
80100d5b:	83 c1 01             	add    $0x1,%ecx
    num1 /= 10;
80100d5e:	89 d3                	mov    %edx,%ebx
  while(num1 > 0){
80100d60:	83 f8 09             	cmp    $0x9,%eax
80100d63:	7f db                	jg     80100d40 <int_to_string+0x70>
}
80100d65:	83 c4 08             	add    $0x8,%esp
80100d68:	89 c8                	mov    %ecx,%eax
80100d6a:	5b                   	pop    %ebx
80100d6b:	5e                   	pop    %esi
80100d6c:	5f                   	pop    %edi
80100d6d:	5d                   	pop    %ebp
80100d6e:	c3                   	ret    
80100d6f:	90                   	nop

80100d70 <change_cursor_position>:
change_cursor_position(int direction){
80100d70:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100d71:	b8 0e 00 00 00       	mov    $0xe,%eax
80100d76:	89 e5                	mov    %esp,%ebp
80100d78:	57                   	push   %edi
80100d79:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100d7e:	56                   	push   %esi
80100d7f:	89 fa                	mov    %edi,%edx
80100d81:	53                   	push   %ebx
80100d82:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100d85:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100d86:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100d8b:	89 ca                	mov    %ecx,%edx
80100d8d:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100d8e:	0f b6 f0             	movzbl %al,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100d91:	89 fa                	mov    %edi,%edx
80100d93:	b8 0f 00 00 00       	mov    $0xf,%eax
80100d98:	c1 e6 08             	shl    $0x8,%esi
80100d9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100d9c:	89 ca                	mov    %ecx,%edx
80100d9e:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100d9f:	0f b6 c8             	movzbl %al,%ecx
80100da2:	09 f1                	or     %esi,%ecx
  switch(direction){
80100da4:	85 db                	test   %ebx,%ebx
80100da6:	74 38                	je     80100de0 <change_cursor_position+0x70>
      pos += 1;
80100da8:	31 c0                	xor    %eax,%eax
80100daa:	83 fb 01             	cmp    $0x1,%ebx
80100dad:	0f 94 c0             	sete   %al
80100db0:	01 c1                	add    %eax,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100db2:	be d4 03 00 00       	mov    $0x3d4,%esi
80100db7:	b8 0e 00 00 00       	mov    $0xe,%eax
80100dbc:	89 f2                	mov    %esi,%edx
80100dbe:	ee                   	out    %al,(%dx)
80100dbf:	bb d5 03 00 00       	mov    $0x3d5,%ebx
  outb(CRTPORT+1, pos>>8);
80100dc4:	89 c8                	mov    %ecx,%eax
80100dc6:	c1 f8 08             	sar    $0x8,%eax
80100dc9:	89 da                	mov    %ebx,%edx
80100dcb:	ee                   	out    %al,(%dx)
80100dcc:	b8 0f 00 00 00       	mov    $0xf,%eax
80100dd1:	89 f2                	mov    %esi,%edx
80100dd3:	ee                   	out    %al,(%dx)
80100dd4:	89 c8                	mov    %ecx,%eax
80100dd6:	89 da                	mov    %ebx,%edx
80100dd8:	ee                   	out    %al,(%dx)
}
80100dd9:	5b                   	pop    %ebx
80100dda:	5e                   	pop    %esi
80100ddb:	5f                   	pop    %edi
80100ddc:	5d                   	pop    %ebp
80100ddd:	c3                   	ret    
80100dde:	66 90                	xchg   %ax,%ax
      pos -= 1;
80100de0:	83 e9 01             	sub    $0x1,%ecx
      break;
80100de3:	eb cd                	jmp    80100db2 <change_cursor_position+0x42>
80100de5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100df0 <show_result>:
void show_result(int offset, char* result){
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	57                   	push   %edi
80100df4:	56                   	push   %esi
80100df5:	53                   	push   %ebx
80100df6:	83 ec 1c             	sub    $0x1c,%esp
  for(int i = input.e - num_of_left_pressed; i <= index_question_mark; i++){
80100df9:	a1 c8 15 11 80       	mov    0x801115c8,%eax
80100dfe:	8b 35 64 16 11 80    	mov    0x80111664,%esi
80100e04:	89 c7                	mov    %eax,%edi
80100e06:	2b 3d c4 16 11 80    	sub    0x801116c4,%edi
80100e0c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80100e0f:	39 fe                	cmp    %edi,%esi
80100e11:	7c 67                	jl     80100e7a <show_result+0x8a>
80100e13:	83 e8 01             	sub    $0x1,%eax
80100e16:	be d4 03 00 00       	mov    $0x3d4,%esi
80100e1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100e1e:	66 90                	xchg   %ax,%ax
80100e20:	b8 0e 00 00 00       	mov    $0xe,%eax
80100e25:	89 f2                	mov    %esi,%edx
80100e27:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100e28:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100e2d:	89 da                	mov    %ebx,%edx
80100e2f:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100e30:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100e33:	89 f2                	mov    %esi,%edx
80100e35:	b8 0f 00 00 00       	mov    $0xf,%eax
80100e3a:	c1 e1 08             	shl    $0x8,%ecx
80100e3d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100e3e:	89 da                	mov    %ebx,%edx
80100e40:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100e41:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100e44:	89 f2                	mov    %esi,%edx
80100e46:	09 c1                	or     %eax,%ecx
80100e48:	b8 0e 00 00 00       	mov    $0xe,%eax
      pos += 1;
80100e4d:	83 c1 01             	add    $0x1,%ecx
80100e50:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
80100e51:	89 ca                	mov    %ecx,%edx
80100e53:	c1 fa 08             	sar    $0x8,%edx
80100e56:	89 d0                	mov    %edx,%eax
80100e58:	89 da                	mov    %ebx,%edx
80100e5a:	ee                   	out    %al,(%dx)
80100e5b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100e60:	89 f2                	mov    %esi,%edx
80100e62:	ee                   	out    %al,(%dx)
80100e63:	89 c8                	mov    %ecx,%eax
80100e65:	89 da                	mov    %ebx,%edx
80100e67:	ee                   	out    %al,(%dx)
    num_of_left_pressed--;
80100e68:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e6b:	29 f8                	sub    %edi,%eax
  for(int i = input.e - num_of_left_pressed; i <= index_question_mark; i++){
80100e6d:	83 c7 01             	add    $0x1,%edi
80100e70:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80100e73:	7d ab                	jge    80100e20 <show_result+0x30>
80100e75:	a3 c4 16 11 80       	mov    %eax,0x801116c4
void show_result(int offset, char* result){
80100e7a:	bb 05 00 00 00       	mov    $0x5,%ebx
  if(panicked){
80100e7f:	8b 0d b8 16 11 80    	mov    0x801116b8,%ecx
80100e85:	85 c9                	test   %ecx,%ecx
80100e87:	74 07                	je     80100e90 <show_result+0xa0>
  asm volatile("cli");
80100e89:	fa                   	cli    
    for(;;)
80100e8a:	eb fe                	jmp    80100e8a <show_result+0x9a>
80100e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e90:	b8 00 01 00 00       	mov    $0x100,%eax
80100e95:	e8 66 f5 ff ff       	call   80100400 <consputc.part.0>
    input.e--;
80100e9a:	a1 c8 15 11 80       	mov    0x801115c8,%eax
80100e9f:	8d 48 ff             	lea    -0x1(%eax),%ecx
80100ea2:	89 0d c8 15 11 80    	mov    %ecx,0x801115c8
  for(int i = 0; i < 5; i++){
80100ea8:	83 eb 01             	sub    $0x1,%ebx
80100eab:	75 d2                	jne    80100e7f <show_result+0x8f>
    for(int j = index_question_mark + 1; j <= temp_e - 1; j++){
80100ead:	a1 64 16 11 80       	mov    0x80111664,%eax
80100eb2:	bb 05 00 00 00       	mov    $0x5,%ebx
80100eb7:	8d 70 01             	lea    0x1(%eax),%esi
80100eba:	89 f0                	mov    %esi,%eax
80100ebc:	39 f1                	cmp    %esi,%ecx
80100ebe:	7e 14                	jle    80100ed4 <show_result+0xe4>
      input.buf[j - 1] = input.buf[j];
80100ec0:	0f b6 90 40 15 11 80 	movzbl -0x7feeeac0(%eax),%edx
    for(int j = index_question_mark + 1; j <= temp_e - 1; j++){
80100ec7:	83 c0 01             	add    $0x1,%eax
      input.buf[j - 1] = input.buf[j];
80100eca:	88 90 3e 15 11 80    	mov    %dl,-0x7feeeac2(%eax)
    for(int j = index_question_mark + 1; j <= temp_e - 1; j++){
80100ed0:	39 c1                	cmp    %eax,%ecx
80100ed2:	75 ec                	jne    80100ec0 <show_result+0xd0>
  for(int i = 0; i < 5; i++){
80100ed4:	83 eb 01             	sub    $0x1,%ebx
80100ed7:	75 e1                	jne    80100eba <show_result+0xca>
  for(int j = offset - 1; j >= 0; j--){
80100ed9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100edc:	83 eb 01             	sub    $0x1,%ebx
80100edf:	78 37                	js     80100f18 <show_result+0x128>
    input.buf[input.e] = result[j];
80100ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(panicked){
80100ee4:	8b 15 b8 16 11 80    	mov    0x801116b8,%edx
    input.buf[input.e] = result[j];
80100eea:	0f be 04 18          	movsbl (%eax,%ebx,1),%eax
80100eee:	88 81 40 15 11 80    	mov    %al,-0x7feeeac0(%ecx)
  if(panicked){
80100ef4:	85 d2                	test   %edx,%edx
80100ef6:	74 08                	je     80100f00 <show_result+0x110>
80100ef8:	fa                   	cli    
    for(;;)
80100ef9:	eb fe                	jmp    80100ef9 <show_result+0x109>
80100efb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100eff:	90                   	nop
80100f00:	e8 fb f4 ff ff       	call   80100400 <consputc.part.0>
    input.e++;
80100f05:	a1 c8 15 11 80       	mov    0x801115c8,%eax
80100f0a:	8d 48 01             	lea    0x1(%eax),%ecx
80100f0d:	89 0d c8 15 11 80    	mov    %ecx,0x801115c8
  for(int j = offset - 1; j >= 0; j--){
80100f13:	83 eb 01             	sub    $0x1,%ebx
80100f16:	73 c9                	jae    80100ee1 <show_result+0xf1>
}
80100f18:	83 c4 1c             	add    $0x1c,%esp
80100f1b:	5b                   	pop    %ebx
80100f1c:	5e                   	pop    %esi
80100f1d:	5f                   	pop    %edi
80100f1e:	5d                   	pop    %ebp
80100f1f:	c3                   	ret    

80100f20 <do_operation>:
void do_operation(){
80100f20:	55                   	push   %ebp
80100f21:	89 e5                	mov    %esp,%ebp
80100f23:	57                   	push   %edi
80100f24:	56                   	push   %esi
80100f25:	53                   	push   %ebx
80100f26:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  int second_num = second_digit - '0';
80100f2c:	0f be 15 6d 16 11 80 	movsbl 0x8011166d,%edx
  switch (operand)
80100f33:	0f b6 05 6c 16 11 80 	movzbl 0x8011166c,%eax
  int second_num = second_digit - '0';
80100f3a:	83 ea 30             	sub    $0x30,%edx
    result = (float)second_num + (float)first_num;
80100f3d:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  int first_num = first_digit - '0';
80100f43:	0f be 15 6e 16 11 80 	movsbl 0x8011166e,%edx
    result = (float)second_num + (float)first_num;
80100f4a:	db 85 60 ff ff ff    	fildl  -0xa0(%ebp)
  int first_num = first_digit - '0';
80100f50:	83 ea 30             	sub    $0x30,%edx
    result = (float)second_num + (float)first_num;
80100f53:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
80100f59:	db 85 60 ff ff ff    	fildl  -0xa0(%ebp)
  switch (operand)
80100f5f:	3c 2d                	cmp    $0x2d,%al
80100f61:	0f 84 01 01 00 00    	je     80101068 <do_operation+0x148>
80100f67:	3c 2f                	cmp    $0x2f,%al
80100f69:	0f 84 11 01 00 00    	je     80101080 <do_operation+0x160>
80100f6f:	3c 2a                	cmp    $0x2a,%al
80100f71:	0f 84 f9 00 00 00    	je     80101070 <do_operation+0x150>
    result = (float)second_num + (float)first_num;
80100f77:	de c1                	faddp  %st,%st(1)
  memset(result_as_string, '\0', sizeof(result_as_string));
80100f79:	83 ec 04             	sub    $0x4,%esp
80100f7c:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80100f82:	d9 9d 60 ff ff ff    	fstps  -0xa0(%ebp)
80100f88:	68 80 00 00 00       	push   $0x80
80100f8d:	6a 00                	push   $0x0
80100f8f:	56                   	push   %esi
80100f90:	e8 7b 52 00 00       	call   80106210 <memset>
  int num1 = num;
80100f95:	d9 85 60 ff ff ff    	flds   -0xa0(%ebp)
  if((int)(num * 10) % 10 != 0){
80100f9b:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100fa0:	83 c4 10             	add    $0x10,%esp
  int num1 = num;
80100fa3:	d9 bd 66 ff ff ff    	fnstcw -0x9a(%ebp)
80100fa9:	0f b7 85 66 ff ff ff 	movzwl -0x9a(%ebp),%eax
80100fb0:	80 cc 0c             	or     $0xc,%ah
80100fb3:	66 89 85 64 ff ff ff 	mov    %ax,-0x9c(%ebp)
80100fba:	d9 ad 64 ff ff ff    	fldcw  -0x9c(%ebp)
80100fc0:	db 95 60 ff ff ff    	fistl  -0xa0(%ebp)
80100fc6:	d9 ad 66 ff ff ff    	fldcw  -0x9a(%ebp)
  if((int)(num * 10) % 10 != 0){
80100fcc:	d8 0d f0 92 10 80    	fmuls  0x801092f0
  int num1 = num;
80100fd2:	8b 9d 60 ff ff ff    	mov    -0xa0(%ebp),%ebx
  if((int)(num * 10) % 10 != 0){
80100fd8:	d9 ad 64 ff ff ff    	fldcw  -0x9c(%ebp)
80100fde:	db 9d 60 ff ff ff    	fistpl -0xa0(%ebp)
80100fe4:	d9 ad 66 ff ff ff    	fldcw  -0x9a(%ebp)
80100fea:	8b bd 60 ff ff ff    	mov    -0xa0(%ebp),%edi
80100ff0:	89 f8                	mov    %edi,%eax
80100ff2:	f7 ea                	imul   %edx
80100ff4:	89 f8                	mov    %edi,%eax
80100ff6:	c1 f8 1f             	sar    $0x1f,%eax
80100ff9:	c1 fa 02             	sar    $0x2,%edx
80100ffc:	89 d1                	mov    %edx,%ecx
80100ffe:	29 c1                	sub    %eax,%ecx
80101000:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
80101003:	89 f9                	mov    %edi,%ecx
80101005:	01 c0                	add    %eax,%eax
80101007:	29 c1                	sub    %eax,%ecx
80101009:	74 15                	je     80101020 <do_operation+0x100>
    string[i] = '.';
8010100b:	c6 85 69 ff ff ff 2e 	movb   $0x2e,-0x97(%ebp)
    string[i] = ((int)(num * 10) % 10) + '0';
80101012:	83 c1 30             	add    $0x30,%ecx
80101015:	88 8d 68 ff ff ff    	mov    %cl,-0x98(%ebp)
    i++;
8010101b:	b9 02 00 00 00       	mov    $0x2,%ecx
  while(num1 > 0){
80101020:	85 db                	test   %ebx,%ebx
80101022:	7e 29                	jle    8010104d <do_operation+0x12d>
80101024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    int temp  = num1 % 10;
80101028:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
8010102d:	f7 e3                	mul    %ebx
8010102f:	89 d8                	mov    %ebx,%eax
80101031:	c1 ea 03             	shr    $0x3,%edx
80101034:	8d 3c 92             	lea    (%edx,%edx,4),%edi
80101037:	01 ff                	add    %edi,%edi
80101039:	29 f8                	sub    %edi,%eax
    string[i] = temp + '0';
8010103b:	83 c0 30             	add    $0x30,%eax
8010103e:	88 04 0e             	mov    %al,(%esi,%ecx,1)
    i++;
80101041:	89 d8                	mov    %ebx,%eax
80101043:	83 c1 01             	add    $0x1,%ecx
    num1 /= 10;
80101046:	89 d3                	mov    %edx,%ebx
  while(num1 > 0){
80101048:	83 f8 09             	cmp    $0x9,%eax
8010104b:	7f db                	jg     80101028 <do_operation+0x108>
  show_result(num_res_digits, result_as_string);
8010104d:	83 ec 08             	sub    $0x8,%esp
80101050:	56                   	push   %esi
80101051:	51                   	push   %ecx
80101052:	e8 99 fd ff ff       	call   80100df0 <show_result>
}
80101057:	83 c4 10             	add    $0x10,%esp
8010105a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010105d:	5b                   	pop    %ebx
8010105e:	5e                   	pop    %esi
8010105f:	5f                   	pop    %edi
80101060:	5d                   	pop    %ebp
80101061:	c3                   	ret    
80101062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    result = (float)second_num - (float)first_num;
80101068:	de e9                	fsubrp %st,%st(1)
    break;
8010106a:	e9 0a ff ff ff       	jmp    80100f79 <do_operation+0x59>
8010106f:	90                   	nop
    result = (float)second_num * (float)first_num;
80101070:	de c9                	fmulp  %st,%st(1)
    break;
80101072:	e9 02 ff ff ff       	jmp    80100f79 <do_operation+0x59>
80101077:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010107e:	66 90                	xchg   %ax,%ax
    result = (float)second_num / (float)first_num;
80101080:	de f9                	fdivrp %st,%st(1)
    break;
80101082:	e9 f2 fe ff ff       	jmp    80100f79 <do_operation+0x59>
80101087:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010108e:	66 90                	xchg   %ax,%ax

80101090 <is_digit>:
int is_digit(char c){
80101090:	55                   	push   %ebp
80101091:	89 e5                	mov    %esp,%ebp
  return c >= '0' && c <= '9';
80101093:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}
80101097:	5d                   	pop    %ebp
  return c >= '0' && c <= '9';
80101098:	83 e8 30             	sub    $0x30,%eax
8010109b:	3c 09                	cmp    $0x9,%al
8010109d:	0f 96 c0             	setbe  %al
801010a0:	0f b6 c0             	movzbl %al,%eax
}
801010a3:	c3                   	ret    
801010a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801010af:	90                   	nop

801010b0 <is_operand>:
int is_operand(char c){
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
801010b7:	8d 48 d6             	lea    -0x2a(%eax),%ecx
801010ba:	80 f9 05             	cmp    $0x5,%cl
801010bd:	77 11                	ja     801010d0 <is_operand+0x20>
801010bf:	b8 2b 00 00 00       	mov    $0x2b,%eax
}
801010c4:	5d                   	pop    %ebp
801010c5:	d3 e8                	shr    %cl,%eax
801010c7:	83 e0 01             	and    $0x1,%eax
801010ca:	c3                   	ret    
801010cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801010cf:	90                   	nop
int is_operand(char c){
801010d0:	31 c0                	xor    %eax,%eax
}
801010d2:	5d                   	pop    %ebp
801010d3:	c3                   	ret    
801010d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801010df:	90                   	nop

801010e0 <is_equal_mark>:
int is_equal_mark(char c){
801010e0:	55                   	push   %ebp
  return c == '=';
801010e1:	31 c0                	xor    %eax,%eax
int is_equal_mark(char c){
801010e3:	89 e5                	mov    %esp,%ebp
  return c == '=';
801010e5:	80 7d 08 3d          	cmpb   $0x3d,0x8(%ebp)
}
801010e9:	5d                   	pop    %ebp
  return c == '=';
801010ea:	0f 94 c0             	sete   %al
}
801010ed:	c3                   	ret    
801010ee:	66 90                	xchg   %ax,%ax

801010f0 <is_question_mark>:
int is_question_mark(char c){
801010f0:	55                   	push   %ebp
  return c == '?';
801010f1:	31 c0                	xor    %eax,%eax
int is_question_mark(char c){
801010f3:	89 e5                	mov    %esp,%ebp
  return c == '?';
801010f5:	80 7d 08 3f          	cmpb   $0x3f,0x8(%ebp)
}
801010f9:	5d                   	pop    %ebp
  return c == '?';
801010fa:	0f 94 c0             	sete   %al
}
801010fd:	c3                   	ret    
801010fe:	66 90                	xchg   %ax,%ax

80101100 <there_is_question_mark>:
  for(int i = input.w; i < input.e; i++){
80101100:	a1 c4 15 11 80       	mov    0x801115c4,%eax
80101105:	8b 15 c8 15 11 80    	mov    0x801115c8,%edx
8010110b:	39 d0                	cmp    %edx,%eax
8010110d:	72 10                	jb     8010111f <there_is_question_mark+0x1f>
8010110f:	eb 1f                	jmp    80101130 <there_is_question_mark+0x30>
80101111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101118:	83 c0 01             	add    $0x1,%eax
8010111b:	39 d0                	cmp    %edx,%eax
8010111d:	73 11                	jae    80101130 <there_is_question_mark+0x30>
    if(input.buf[i] == '?'){
8010111f:	80 b8 40 15 11 80 3f 	cmpb   $0x3f,-0x7feeeac0(%eax)
80101126:	75 f0                	jne    80101118 <there_is_question_mark+0x18>
      return 1;
80101128:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010112d:	c3                   	ret    
8010112e:	66 90                	xchg   %ax,%ax
  return 0;
80101130:	31 c0                	xor    %eax,%eax
80101132:	c3                   	ret    
80101133:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010113a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101140 <find_question_mark_index>:
  for(int i = input.w; i < input.e; i++){
80101140:	a1 c4 15 11 80       	mov    0x801115c4,%eax
80101145:	8b 15 c8 15 11 80    	mov    0x801115c8,%edx
8010114b:	39 d0                	cmp    %edx,%eax
8010114d:	72 10                	jb     8010115f <find_question_mark_index+0x1f>
8010114f:	eb 1f                	jmp    80101170 <find_question_mark_index+0x30>
80101151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101158:	83 c0 01             	add    $0x1,%eax
8010115b:	39 d0                	cmp    %edx,%eax
8010115d:	73 11                	jae    80101170 <find_question_mark_index+0x30>
    if(input.buf[i] == '?'){
8010115f:	80 b8 40 15 11 80 3f 	cmpb   $0x3f,-0x7feeeac0(%eax)
80101166:	75 f0                	jne    80101158 <find_question_mark_index+0x18>
}
80101168:	c3                   	ret    
80101169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
80101170:	31 c0                	xor    %eax,%eax
}
80101172:	c3                   	ret    
80101173:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010117a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101180 <handle_up_and_down_arrow>:
void handle_up_and_down_arrow(enum Direction dir){
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 0c             	sub    $0xc,%esp
  for(int i = input.e; i > input.w; i--){
80101189:	8b 1d c8 15 11 80    	mov    0x801115c8,%ebx
8010118f:	3b 1d c4 15 11 80    	cmp    0x801115c4,%ebx
80101195:	76 2b                	jbe    801011c2 <handle_up_and_down_arrow+0x42>
    if(input.buf[i - 1] != '\n'){
80101197:	83 eb 01             	sub    $0x1,%ebx
8010119a:	80 bb 40 15 11 80 0a 	cmpb   $0xa,-0x7feeeac0(%ebx)
801011a1:	74 17                	je     801011ba <handle_up_and_down_arrow+0x3a>
  if(panicked){
801011a3:	8b 35 b8 16 11 80    	mov    0x801116b8,%esi
801011a9:	85 f6                	test   %esi,%esi
801011ab:	74 03                	je     801011b0 <handle_up_and_down_arrow+0x30>
801011ad:	fa                   	cli    
    for(;;)
801011ae:	eb fe                	jmp    801011ae <handle_up_and_down_arrow+0x2e>
801011b0:	b8 00 01 00 00       	mov    $0x100,%eax
801011b5:	e8 46 f2 ff ff       	call   80100400 <consputc.part.0>
  for(int i = input.e; i > input.w; i--){
801011ba:	39 1d c4 15 11 80    	cmp    %ebx,0x801115c4
801011c0:	72 d5                	jb     80101197 <handle_up_and_down_arrow+0x17>
  if(dir == UP){
801011c2:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
801011c6:	74 0c                	je     801011d4 <handle_up_and_down_arrow+0x54>
  if(dir == DOWN){
801011c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(int i = input.w; i < input.e; i++){
801011cb:	a1 c8 15 11 80       	mov    0x801115c8,%eax
  if(dir == DOWN){
801011d0:	85 c9                	test   %ecx,%ecx
801011d2:	75 33                	jne    80101207 <handle_up_and_down_arrow+0x87>
    input = history_cmnd.hist[history_cmnd.num_of_cmnd - history_cmnd.num_of_press];
801011d4:	a1 24 15 11 80       	mov    0x80111524,%eax
801011d9:	ba 40 15 11 80       	mov    $0x80111540,%edx
801011de:	b9 23 00 00 00       	mov    $0x23,%ecx
801011e3:	2b 05 2c 15 11 80    	sub    0x8011152c,%eax
801011e9:	69 c0 8c 00 00 00    	imul   $0x8c,%eax,%eax
801011ef:	89 d7                	mov    %edx,%edi
801011f1:	05 20 0f 11 80       	add    $0x80110f20,%eax
801011f6:	89 c6                	mov    %eax,%esi
801011f8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    input.e--;
801011fa:	a1 c8 15 11 80       	mov    0x801115c8,%eax
801011ff:	83 e8 01             	sub    $0x1,%eax
80101202:	a3 c8 15 11 80       	mov    %eax,0x801115c8
  for(int i = input.w; i < input.e; i++){
80101207:	8b 1d c4 15 11 80    	mov    0x801115c4,%ebx
8010120d:	39 c3                	cmp    %eax,%ebx
8010120f:	73 27                	jae    80101238 <handle_up_and_down_arrow+0xb8>
  if(panicked){
80101211:	8b 15 b8 16 11 80    	mov    0x801116b8,%edx
    consputc(input.buf[i]);
80101217:	0f be 83 40 15 11 80 	movsbl -0x7feeeac0(%ebx),%eax
  if(panicked){
8010121e:	85 d2                	test   %edx,%edx
80101220:	74 06                	je     80101228 <handle_up_and_down_arrow+0xa8>
80101222:	fa                   	cli    
    for(;;)
80101223:	eb fe                	jmp    80101223 <handle_up_and_down_arrow+0xa3>
80101225:	8d 76 00             	lea    0x0(%esi),%esi
80101228:	e8 d3 f1 ff ff       	call   80100400 <consputc.part.0>
  for(int i = input.w; i < input.e; i++){
8010122d:	83 c3 01             	add    $0x1,%ebx
80101230:	39 1d c8 15 11 80    	cmp    %ebx,0x801115c8
80101236:	77 d9                	ja     80101211 <handle_up_and_down_arrow+0x91>
}
80101238:	83 c4 0c             	add    $0xc,%esp
8010123b:	5b                   	pop    %ebx
8010123c:	5e                   	pop    %esi
8010123d:	5f                   	pop    %edi
8010123e:	5d                   	pop    %ebp
8010123f:	c3                   	ret    

80101240 <check_states_question_mark>:
void check_states_question_mark(char c){
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	83 ec 08             	sub    $0x8,%esp
  switch (state_of_question_mark)
80101246:	a1 68 16 11 80       	mov    0x80111668,%eax
void check_states_question_mark(char c){
8010124b:	8b 55 08             	mov    0x8(%ebp),%edx
  switch (state_of_question_mark)
8010124e:	83 f8 02             	cmp    $0x2,%eax
80101251:	74 65                	je     801012b8 <check_states_question_mark+0x78>
80101253:	7f 2b                	jg     80101280 <check_states_question_mark+0x40>
80101255:	85 c0                	test   %eax,%eax
80101257:	74 47                	je     801012a0 <check_states_question_mark+0x60>
80101259:	83 f8 01             	cmp    $0x1,%eax
8010125c:	75 2e                	jne    8010128c <check_states_question_mark+0x4c>
  return c >= '0' && c <= '9';
8010125e:	8d 42 d0             	lea    -0x30(%edx),%eax
    if(is_digit(c)){
80101261:	3c 09                	cmp    $0x9,%al
80101263:	77 27                	ja     8010128c <check_states_question_mark+0x4c>
      first_digit = c;
80101265:	88 15 6e 16 11 80    	mov    %dl,0x8011166e
      state_of_question_mark = 2;
8010126b:	c7 05 68 16 11 80 02 	movl   $0x2,0x80111668
80101272:	00 00 00 
}
80101275:	c9                   	leave  
80101276:	c3                   	ret    
80101277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010127e:	66 90                	xchg   %ax,%ax
  switch (state_of_question_mark)
80101280:	83 f8 03             	cmp    $0x3,%eax
80101283:	75 07                	jne    8010128c <check_states_question_mark+0x4c>
  return c >= '0' && c <= '9';
80101285:	8d 42 d0             	lea    -0x30(%edx),%eax
    if(is_digit(c)){
80101288:	3c 09                	cmp    $0x9,%al
8010128a:	76 54                	jbe    801012e0 <check_states_question_mark+0xa0>
      state_of_question_mark = 0;
8010128c:	c7 05 68 16 11 80 00 	movl   $0x0,0x80111668
80101293:	00 00 00 
}
80101296:	c9                   	leave  
80101297:	c3                   	ret    
80101298:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010129f:	90                   	nop
    if(!is_equal_mark(c)){
801012a0:	80 fa 3d             	cmp    $0x3d,%dl
801012a3:	75 d0                	jne    80101275 <check_states_question_mark+0x35>
      state_of_question_mark = 1;
801012a5:	c7 05 68 16 11 80 01 	movl   $0x1,0x80111668
801012ac:	00 00 00 
}
801012af:	c9                   	leave  
801012b0:	c3                   	ret    
801012b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(is_operand(c)){
801012b8:	8d 42 d6             	lea    -0x2a(%edx),%eax
801012bb:	3c 05                	cmp    $0x5,%al
801012bd:	77 cd                	ja     8010128c <check_states_question_mark+0x4c>
801012bf:	b9 2b 00 00 00       	mov    $0x2b,%ecx
801012c4:	0f a3 c1             	bt     %eax,%ecx
801012c7:	73 c3                	jae    8010128c <check_states_question_mark+0x4c>
      state_of_question_mark = 3;
801012c9:	c7 05 68 16 11 80 03 	movl   $0x3,0x80111668
801012d0:	00 00 00 
      operand = c;
801012d3:	88 15 6c 16 11 80    	mov    %dl,0x8011166c
}
801012d9:	c9                   	leave  
801012da:	c3                   	ret    
801012db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012df:	90                   	nop
      second_digit = c;
801012e0:	88 15 6d 16 11 80    	mov    %dl,0x8011166d
      do_operation();
801012e6:	e8 35 fc ff ff       	call   80100f20 <do_operation>
801012eb:	eb 9f                	jmp    8010128c <check_states_question_mark+0x4c>
801012ed:	8d 76 00             	lea    0x0(%esi),%esi

801012f0 <search_for_NON>:
void search_for_NON(int qm_index){
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	56                   	push   %esi
801012f4:	8b 75 08             	mov    0x8(%ebp),%esi
801012f7:	53                   	push   %ebx
  index_question_mark = qm_index;
801012f8:	bb 04 00 00 00       	mov    $0x4,%ebx
801012fd:	89 35 64 16 11 80    	mov    %esi,0x80111664
    check_states_question_mark(input.buf[qm_index - i]);
80101303:	0f be 84 1e 3b 15 11 	movsbl -0x7feeeac5(%esi,%ebx,1),%eax
8010130a:	80 
8010130b:	83 ec 0c             	sub    $0xc,%esp
8010130e:	50                   	push   %eax
8010130f:	e8 2c ff ff ff       	call   80101240 <check_states_question_mark>
  for(int i = 1;i <= 4; i++){
80101314:	83 c4 10             	add    $0x10,%esp
80101317:	83 eb 01             	sub    $0x1,%ebx
8010131a:	75 e7                	jne    80101303 <search_for_NON+0x13>
}
8010131c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010131f:	5b                   	pop    %ebx
80101320:	5e                   	pop    %esi
80101321:	5d                   	pop    %ebp
80101322:	c3                   	ret    
80101323:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010132a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101330 <update_history_memory>:
  if((input.e - input.w) > 1){
80101330:	a1 c8 15 11 80       	mov    0x801115c8,%eax
80101335:	2b 05 c4 15 11 80    	sub    0x801115c4,%eax
8010133b:	83 f8 01             	cmp    $0x1,%eax
8010133e:	76 78                	jbe    801013b8 <update_history_memory+0x88>
void update_history_memory(){
80101340:	55                   	push   %ebp
80101341:	ba 40 15 11 80       	mov    $0x80111540,%edx
80101346:	89 e5                	mov    %esp,%ebp
80101348:	57                   	push   %edi
80101349:	56                   	push   %esi
8010134a:	53                   	push   %ebx
    if(history_cmnd.num_of_cmnd < 10){
8010134b:	8b 1d 24 15 11 80    	mov    0x80111524,%ebx
80101351:	83 fb 09             	cmp    $0x9,%ebx
80101354:	7e 3a                	jle    80101390 <update_history_memory+0x60>
80101356:	b8 20 0f 11 80       	mov    $0x80110f20,%eax
8010135b:	bb 0c 14 11 80       	mov    $0x8011140c,%ebx
          history_cmnd.hist[i] = history_cmnd.hist[i + 1];
80101360:	8d b0 8c 00 00 00    	lea    0x8c(%eax),%esi
80101366:	89 c7                	mov    %eax,%edi
      for(int i = 0; i < 9; i++){
80101368:	05 8c 00 00 00       	add    $0x8c,%eax
          history_cmnd.hist[i] = history_cmnd.hist[i + 1];
8010136d:	b9 23 00 00 00       	mov    $0x23,%ecx
80101372:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
      for(int i = 0; i < 9; i++){
80101374:	3d 0c 14 11 80       	cmp    $0x8011140c,%eax
80101379:	75 e5                	jne    80101360 <update_history_memory+0x30>
      history_cmnd.hist[NUM_OF_HISTORY_COMMAND - 1] = input;
8010137b:	89 df                	mov    %ebx,%edi
8010137d:	b9 23 00 00 00       	mov    $0x23,%ecx
80101382:	89 d6                	mov    %edx,%esi
80101384:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
} 
80101386:	5b                   	pop    %ebx
80101387:	5e                   	pop    %esi
80101388:	5f                   	pop    %edi
80101389:	5d                   	pop    %ebp
8010138a:	c3                   	ret    
8010138b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010138f:	90                   	nop
      history_cmnd.hist[history_cmnd.num_of_cmnd] = input;
80101390:	69 c3 8c 00 00 00    	imul   $0x8c,%ebx,%eax
80101396:	b9 23 00 00 00       	mov    $0x23,%ecx
8010139b:	89 d6                	mov    %edx,%esi
      history_cmnd.num_of_cmnd++;
8010139d:	83 c3 01             	add    $0x1,%ebx
801013a0:	89 1d 24 15 11 80    	mov    %ebx,0x80111524
      history_cmnd.hist[history_cmnd.num_of_cmnd] = input;
801013a6:	05 20 0f 11 80       	add    $0x80110f20,%eax
801013ab:	89 c7                	mov    %eax,%edi
801013ad:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
} 
801013af:	5b                   	pop    %ebx
801013b0:	5e                   	pop    %esi
801013b1:	5f                   	pop    %edi
801013b2:	5d                   	pop    %ebp
801013b3:	c3                   	ret    
801013b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013b8:	c3                   	ret    
801013b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801013c0 <handle_deletion>:
void handle_deletion(){
801013c0:	55                   	push   %ebp
801013c1:	89 e5                	mov    %esp,%ebp
801013c3:	56                   	push   %esi
  for(int i = input.e - num_of_left_pressed - 1; i < input.e; i++){
801013c4:	8b 35 c8 15 11 80    	mov    0x801115c8,%esi
void handle_deletion(){
801013ca:	53                   	push   %ebx
  for(int i = input.e - num_of_left_pressed - 1; i < input.e; i++){
801013cb:	8d 56 ff             	lea    -0x1(%esi),%edx
801013ce:	2b 15 c4 16 11 80    	sub    0x801116c4,%edx
801013d4:	39 d6                	cmp    %edx,%esi
801013d6:	76 3d                	jbe    80101415 <handle_deletion+0x55>
801013d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013df:	90                   	nop
    input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
801013e0:	89 d0                	mov    %edx,%eax
801013e2:	83 c2 01             	add    $0x1,%edx
801013e5:	89 d3                	mov    %edx,%ebx
801013e7:	c1 fb 1f             	sar    $0x1f,%ebx
801013ea:	c1 eb 19             	shr    $0x19,%ebx
801013ed:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
801013f0:	83 e1 7f             	and    $0x7f,%ecx
801013f3:	29 d9                	sub    %ebx,%ecx
801013f5:	0f b6 99 40 15 11 80 	movzbl -0x7feeeac0(%ecx),%ebx
801013fc:	89 c1                	mov    %eax,%ecx
801013fe:	c1 f9 1f             	sar    $0x1f,%ecx
80101401:	c1 e9 19             	shr    $0x19,%ecx
80101404:	01 c8                	add    %ecx,%eax
80101406:	83 e0 7f             	and    $0x7f,%eax
80101409:	29 c8                	sub    %ecx,%eax
8010140b:	88 98 40 15 11 80    	mov    %bl,-0x7feeeac0(%eax)
  for(int i = input.e - num_of_left_pressed - 1; i < input.e; i++){
80101411:	39 f2                	cmp    %esi,%edx
80101413:	75 cb                	jne    801013e0 <handle_deletion+0x20>
}
80101415:	5b                   	pop    %ebx
80101416:	5e                   	pop    %esi
80101417:	5d                   	pop    %ebp
80101418:	c3                   	ret    
80101419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101420 <handle_copy_delete>:
void handle_copy_delete(){
80101420:	55                   	push   %ebp
80101421:	89 e5                	mov    %esp,%ebp
80101423:	56                   	push   %esi
  for(int i = cur_index - num_of_left_copy - 1; i < cur_index; i++){
80101424:	8b 35 d4 15 11 80    	mov    0x801115d4,%esi
void handle_copy_delete(){
8010142a:	53                   	push   %ebx
  for(int i = cur_index - num_of_left_copy - 1; i < cur_index; i++){
8010142b:	89 f2                	mov    %esi,%edx
8010142d:	2b 15 d0 15 11 80    	sub    0x801115d0,%edx
80101433:	83 ea 01             	sub    $0x1,%edx
80101436:	39 d6                	cmp    %edx,%esi
80101438:	7e 3b                	jle    80101475 <handle_copy_delete+0x55>
8010143a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    coppied_input[i % INPUT_BUF] = coppied_input[(i + 1) % INPUT_BUF];
80101440:	89 d0                	mov    %edx,%eax
80101442:	83 c2 01             	add    $0x1,%edx
80101445:	89 d3                	mov    %edx,%ebx
80101447:	c1 fb 1f             	sar    $0x1f,%ebx
8010144a:	c1 eb 19             	shr    $0x19,%ebx
8010144d:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80101450:	83 e1 7f             	and    $0x7f,%ecx
80101453:	29 d9                	sub    %ebx,%ecx
80101455:	0f b6 99 e0 15 11 80 	movzbl -0x7feeea20(%ecx),%ebx
8010145c:	89 c1                	mov    %eax,%ecx
8010145e:	c1 f9 1f             	sar    $0x1f,%ecx
80101461:	c1 e9 19             	shr    $0x19,%ecx
80101464:	01 c8                	add    %ecx,%eax
80101466:	83 e0 7f             	and    $0x7f,%eax
80101469:	29 c8                	sub    %ecx,%eax
8010146b:	88 98 e0 15 11 80    	mov    %bl,-0x7feeea20(%eax)
  for(int i = cur_index - num_of_left_copy - 1; i < cur_index; i++){
80101471:	39 d6                	cmp    %edx,%esi
80101473:	75 cb                	jne    80101440 <handle_copy_delete+0x20>
}
80101475:	5b                   	pop    %ebx
80101476:	5e                   	pop    %esi
80101477:	5d                   	pop    %ebp
80101478:	c3                   	ret    
80101479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101480 <handle_writing>:
void handle_writing(){
80101480:	55                   	push   %ebp
  int init = input.e - 1;
80101481:	a1 c8 15 11 80       	mov    0x801115c8,%eax
80101486:	8d 50 ff             	lea    -0x1(%eax),%edx
void handle_writing(){
80101489:	89 e5                	mov    %esp,%ebp
8010148b:	56                   	push   %esi
  int limit = input.e - num_of_left_pressed - 1;
8010148c:	89 d6                	mov    %edx,%esi
8010148e:	2b 35 c4 16 11 80    	sub    0x801116c4,%esi
void handle_writing(){
80101494:	53                   	push   %ebx
  for(int i = init; i > limit; i--){
80101495:	39 f2                	cmp    %esi,%edx
80101497:	7e 3d                	jle    801014d6 <handle_writing+0x56>
80101499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
801014a0:	89 d1                	mov    %edx,%ecx
801014a2:	c1 f9 1f             	sar    $0x1f,%ecx
801014a5:	c1 e9 19             	shr    $0x19,%ecx
801014a8:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
801014ab:	83 e0 7f             	and    $0x7f,%eax
801014ae:	29 c8                	sub    %ecx,%eax
801014b0:	0f b6 98 40 15 11 80 	movzbl -0x7feeeac0(%eax),%ebx
801014b7:	8d 42 01             	lea    0x1(%edx),%eax
  for(int i = init; i > limit; i--){
801014ba:	83 ea 01             	sub    $0x1,%edx
    input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
801014bd:	89 c1                	mov    %eax,%ecx
801014bf:	c1 f9 1f             	sar    $0x1f,%ecx
801014c2:	c1 e9 19             	shr    $0x19,%ecx
801014c5:	01 c8                	add    %ecx,%eax
801014c7:	83 e0 7f             	and    $0x7f,%eax
801014ca:	29 c8                	sub    %ecx,%eax
801014cc:	88 98 40 15 11 80    	mov    %bl,-0x7feeeac0(%eax)
  for(int i = init; i > limit; i--){
801014d2:	39 d6                	cmp    %edx,%esi
801014d4:	7c ca                	jl     801014a0 <handle_writing+0x20>
}
801014d6:	5b                   	pop    %ebx
801014d7:	5e                   	pop    %esi
801014d8:	5d                   	pop    %ebp
801014d9:	c3                   	ret    
801014da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801014e0 <handle_copying>:
void handle_copying(){
801014e0:	55                   	push   %ebp
  int init = cur_index - 1;
801014e1:	a1 d4 15 11 80       	mov    0x801115d4,%eax
801014e6:	8d 50 ff             	lea    -0x1(%eax),%edx
void handle_copying(){
801014e9:	89 e5                	mov    %esp,%ebp
801014eb:	56                   	push   %esi
  int limit = cur_index - 1 - num_of_left_copy;
801014ec:	89 d6                	mov    %edx,%esi
801014ee:	2b 35 d0 15 11 80    	sub    0x801115d0,%esi
void handle_copying(){
801014f4:	53                   	push   %ebx
  for(int i = init; i > limit; i--){
801014f5:	39 f2                	cmp    %esi,%edx
801014f7:	7e 3d                	jle    80101536 <handle_copying+0x56>
801014f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    coppied_input[(i + 1) % INPUT_BUF] = coppied_input[i % INPUT_BUF];
80101500:	89 d1                	mov    %edx,%ecx
80101502:	c1 f9 1f             	sar    $0x1f,%ecx
80101505:	c1 e9 19             	shr    $0x19,%ecx
80101508:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
8010150b:	83 e0 7f             	and    $0x7f,%eax
8010150e:	29 c8                	sub    %ecx,%eax
80101510:	0f b6 98 e0 15 11 80 	movzbl -0x7feeea20(%eax),%ebx
80101517:	8d 42 01             	lea    0x1(%edx),%eax
  for(int i = init; i > limit; i--){
8010151a:	83 ea 01             	sub    $0x1,%edx
    coppied_input[(i + 1) % INPUT_BUF] = coppied_input[i % INPUT_BUF];
8010151d:	89 c1                	mov    %eax,%ecx
8010151f:	c1 f9 1f             	sar    $0x1f,%ecx
80101522:	c1 e9 19             	shr    $0x19,%ecx
80101525:	01 c8                	add    %ecx,%eax
80101527:	83 e0 7f             	and    $0x7f,%eax
8010152a:	29 c8                	sub    %ecx,%eax
8010152c:	88 98 e0 15 11 80    	mov    %bl,-0x7feeea20(%eax)
  for(int i = init; i > limit; i--){
80101532:	39 d6                	cmp    %edx,%esi
80101534:	75 ca                	jne    80101500 <handle_copying+0x20>
}
80101536:	5b                   	pop    %ebx
80101537:	5e                   	pop    %esi
80101538:	5d                   	pop    %ebp
80101539:	c3                   	ret    
8010153a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101540 <consoleintr>:
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	57                   	push   %edi
80101544:	56                   	push   %esi
80101545:	53                   	push   %ebx
80101546:	83 ec 38             	sub    $0x38,%esp
80101549:	8b 45 08             	mov    0x8(%ebp),%eax
  acquire(&cons.lock);
8010154c:	68 80 16 11 80       	push   $0x80111680
{
80101551:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  acquire(&cons.lock);
80101554:	e8 f7 4b 00 00       	call   80106150 <acquire>
  int c, doprocdump = 0;
80101559:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  while((c = getc()) >= 0){
80101560:	83 c4 10             	add    $0x10,%esp
80101563:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101566:	ff d0                	call   *%eax
80101568:	89 c3                	mov    %eax,%ebx
8010156a:	85 c0                	test   %eax,%eax
8010156c:	0f 88 ae 00 00 00    	js     80101620 <consoleintr+0xe0>
    switch(c){
80101572:	83 fb 7f             	cmp    $0x7f,%ebx
80101575:	0f 84 b5 01 00 00    	je     80101730 <consoleintr+0x1f0>
8010157b:	7f 53                	jg     801015d0 <consoleintr+0x90>
8010157d:	8d 43 fa             	lea    -0x6(%ebx),%eax
80101580:	83 f8 0f             	cmp    $0xf,%eax
80101583:	0f 87 87 06 00 00    	ja     80101c10 <consoleintr+0x6d0>
80101589:	ff 24 85 9c 92 10 80 	jmp    *-0x7fef6d64(,%eax,4)
80101590:	b8 00 01 00 00       	mov    $0x100,%eax
80101595:	e8 66 ee ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
8010159a:	a1 c8 15 11 80       	mov    0x801115c8,%eax
8010159f:	3b 05 c4 15 11 80    	cmp    0x801115c4,%eax
801015a5:	74 bc                	je     80101563 <consoleintr+0x23>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801015a7:	83 e8 01             	sub    $0x1,%eax
801015aa:	89 c2                	mov    %eax,%edx
801015ac:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801015af:	80 ba 40 15 11 80 0a 	cmpb   $0xa,-0x7feeeac0(%edx)
801015b6:	74 ab                	je     80101563 <consoleintr+0x23>
  if(panicked){
801015b8:	8b 0d b8 16 11 80    	mov    0x801116b8,%ecx
        input.e--;
801015be:	a3 c8 15 11 80       	mov    %eax,0x801115c8
  if(panicked){
801015c3:	85 c9                	test   %ecx,%ecx
801015c5:	74 c9                	je     80101590 <consoleintr+0x50>
801015c7:	fa                   	cli    
    for(;;)
801015c8:	eb fe                	jmp    801015c8 <consoleintr+0x88>
801015ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
801015d0:	81 fb e4 00 00 00    	cmp    $0xe4,%ebx
801015d6:	0f 84 94 02 00 00    	je     80101870 <consoleintr+0x330>
801015dc:	7e 6a                	jle    80101648 <consoleintr+0x108>
801015de:	81 fb e5 00 00 00    	cmp    $0xe5,%ebx
801015e4:	0f 85 06 04 00 00    	jne    801019f0 <consoleintr+0x4b0>
      if(num_of_left_pressed > 0){
801015ea:	8b 1d c4 16 11 80    	mov    0x801116c4,%ebx
801015f0:	85 db                	test   %ebx,%ebx
801015f2:	0f 8f e8 04 00 00    	jg     80101ae0 <consoleintr+0x5a0>
      if(num_of_left_copy > 0)
801015f8:	a1 d0 15 11 80       	mov    0x801115d0,%eax
801015fd:	85 c0                	test   %eax,%eax
801015ff:	0f 8e 5e ff ff ff    	jle    80101563 <consoleintr+0x23>
        num_of_left_copy--;
80101605:	83 e8 01             	sub    $0x1,%eax
80101608:	a3 d0 15 11 80       	mov    %eax,0x801115d0
  while((c = getc()) >= 0){
8010160d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101610:	ff d0                	call   *%eax
80101612:	89 c3                	mov    %eax,%ebx
80101614:	85 c0                	test   %eax,%eax
80101616:	0f 89 56 ff ff ff    	jns    80101572 <consoleintr+0x32>
8010161c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80101620:	83 ec 0c             	sub    $0xc,%esp
80101623:	68 80 16 11 80       	push   $0x80111680
80101628:	e8 c3 4a 00 00       	call   801060f0 <release>
  if(doprocdump) {
8010162d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101630:	83 c4 10             	add    $0x10,%esp
80101633:	85 c0                	test   %eax,%eax
80101635:	0f 85 02 05 00 00    	jne    80101b3d <consoleintr+0x5fd>
}
8010163b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010163e:	5b                   	pop    %ebx
8010163f:	5e                   	pop    %esi
80101640:	5f                   	pop    %edi
80101641:	5d                   	pop    %ebp
80101642:	c3                   	ret    
80101643:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101647:	90                   	nop
    switch(c){
80101648:	81 fb e2 00 00 00    	cmp    $0xe2,%ebx
8010164e:	0f 84 cc 02 00 00    	je     80101920 <consoleintr+0x3e0>
80101654:	81 fb e3 00 00 00    	cmp    $0xe3,%ebx
8010165a:	0f 85 90 03 00 00    	jne    801019f0 <consoleintr+0x4b0>
      for(int i = 0; i < num_of_left_pressed; i++)
80101660:	a1 c4 16 11 80       	mov    0x801116c4,%eax
80101665:	31 ff                	xor    %edi,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101667:	be d4 03 00 00       	mov    $0x3d4,%esi
8010166c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010166f:	85 c0                	test   %eax,%eax
80101671:	7e 55                	jle    801016c8 <consoleintr+0x188>
80101673:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101677:	90                   	nop
80101678:	b8 0e 00 00 00       	mov    $0xe,%eax
8010167d:	89 f2                	mov    %esi,%edx
8010167f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101680:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80101685:	89 da                	mov    %ebx,%edx
80101687:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80101688:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010168b:	89 f2                	mov    %esi,%edx
8010168d:	b8 0f 00 00 00       	mov    $0xf,%eax
80101692:	c1 e1 08             	shl    $0x8,%ecx
80101695:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101696:	89 da                	mov    %ebx,%edx
80101698:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80101699:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010169c:	89 f2                	mov    %esi,%edx
8010169e:	09 c1                	or     %eax,%ecx
801016a0:	b8 0e 00 00 00       	mov    $0xe,%eax
      pos += 1;
801016a5:	83 c1 01             	add    $0x1,%ecx
801016a8:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
801016a9:	89 ca                	mov    %ecx,%edx
801016ab:	c1 fa 08             	sar    $0x8,%edx
801016ae:	89 d0                	mov    %edx,%eax
801016b0:	89 da                	mov    %ebx,%edx
801016b2:	ee                   	out    %al,(%dx)
801016b3:	b8 0f 00 00 00       	mov    $0xf,%eax
801016b8:	89 f2                	mov    %esi,%edx
801016ba:	ee                   	out    %al,(%dx)
801016bb:	89 c8                	mov    %ecx,%eax
801016bd:	89 da                	mov    %ebx,%edx
801016bf:	ee                   	out    %al,(%dx)
      for(int i = 0; i < num_of_left_pressed; i++)
801016c0:	83 c7 01             	add    $0x1,%edi
801016c3:	3b 7d e0             	cmp    -0x20(%ebp),%edi
801016c6:	75 b0                	jne    80101678 <consoleintr+0x138>
      if(history_cmnd.num_of_cmnd != 0 && history_cmnd.num_of_press > 1){
801016c8:	8b 1d 24 15 11 80    	mov    0x80111524,%ebx
801016ce:	a1 2c 15 11 80       	mov    0x8011152c,%eax
      num_of_left_pressed = 0;
801016d3:	c7 05 c4 16 11 80 00 	movl   $0x0,0x801116c4
801016da:	00 00 00 
      if(history_cmnd.num_of_cmnd != 0 && history_cmnd.num_of_press > 1){
801016dd:	85 db                	test   %ebx,%ebx
801016df:	74 09                	je     801016ea <consoleintr+0x1aa>
801016e1:	83 f8 01             	cmp    $0x1,%eax
801016e4:	0f 8f 76 04 00 00    	jg     80101b60 <consoleintr+0x620>
      else if(history_cmnd.num_of_press == 1){
801016ea:	83 f8 01             	cmp    $0x1,%eax
801016ed:	0f 85 70 fe ff ff    	jne    80101563 <consoleintr+0x23>
        int temp = input.e - input.w + 1;
801016f3:	a1 c8 15 11 80       	mov    0x801115c8,%eax
        show_current_history(temp);
801016f8:	83 ec 0c             	sub    $0xc,%esp
        history_cmnd.num_of_press = 0;
801016fb:	c7 05 2c 15 11 80 00 	movl   $0x0,0x8011152c
80101702:	00 00 00 
        int temp = input.e - input.w + 1;
80101705:	83 c0 01             	add    $0x1,%eax
80101708:	2b 05 c4 15 11 80    	sub    0x801115c4,%eax
        show_current_history(temp);
8010170e:	50                   	push   %eax
8010170f:	e8 3c f2 ff ff       	call   80100950 <show_current_history>
        currecnt_com = 0;
80101714:	83 c4 10             	add    $0x10,%esp
80101717:	c7 05 60 16 11 80 00 	movl   $0x0,0x80111660
8010171e:	00 00 00 
80101721:	e9 3d fe ff ff       	jmp    80101563 <consoleintr+0x23>
80101726:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010172d:	8d 76 00             	lea    0x0(%esi),%esi
      if(input.e != input.w){
80101730:	a1 c8 15 11 80       	mov    0x801115c8,%eax
80101735:	8b 0d c4 15 11 80    	mov    0x801115c4,%ecx
8010173b:	39 c8                	cmp    %ecx,%eax
8010173d:	0f 84 20 fe ff ff    	je     80101563 <consoleintr+0x23>
        if(ctrl_s_pressed){
80101743:	8b 15 c0 16 11 80    	mov    0x801116c0,%edx
80101749:	85 d2                	test   %edx,%edx
8010174b:	74 27                	je     80101774 <consoleintr+0x234>
            coppied_input[cur_index - 1] = '\0';
8010174d:	8b 3d d4 15 11 80    	mov    0x801115d4,%edi
          if(num_of_left_copy == 0){
80101753:	8b 15 d0 15 11 80    	mov    0x801115d0,%edx
            coppied_input[cur_index - 1] = '\0';
80101759:	89 7d e0             	mov    %edi,-0x20(%ebp)
          if(num_of_left_copy == 0){
8010175c:	85 d2                	test   %edx,%edx
8010175e:	0f 85 8c 04 00 00    	jne    80101bf0 <consoleintr+0x6b0>
            coppied_input[cur_index - 1] = '\0';
80101764:	83 ef 01             	sub    $0x1,%edi
80101767:	c6 87 e0 15 11 80 00 	movb   $0x0,-0x7feeea20(%edi)
            cur_index--;
8010176e:	89 3d d4 15 11 80    	mov    %edi,0x801115d4
        if(num_of_left_pressed == 0){
80101774:	8b 15 c4 16 11 80    	mov    0x801116c4,%edx
8010177a:	85 d2                	test   %edx,%edx
8010177c:	0f 84 c7 03 00 00    	je     80101b49 <consoleintr+0x609>
        else if(num_of_left_pressed < input.e - input.w){
80101782:	89 c3                	mov    %eax,%ebx
80101784:	29 cb                	sub    %ecx,%ebx
80101786:	39 d3                	cmp    %edx,%ebx
80101788:	0f 86 d5 fd ff ff    	jbe    80101563 <consoleintr+0x23>
  for(int i = input.e - num_of_left_pressed - 1; i < input.e; i++){
8010178e:	8d 78 ff             	lea    -0x1(%eax),%edi
80101791:	89 c6                	mov    %eax,%esi
80101793:	89 f9                	mov    %edi,%ecx
80101795:	29 d1                	sub    %edx,%ecx
80101797:	39 c8                	cmp    %ecx,%eax
80101799:	76 3a                	jbe    801017d5 <consoleintr+0x295>
8010179b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010179f:	90                   	nop
    input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
801017a0:	89 ca                	mov    %ecx,%edx
801017a2:	83 c1 01             	add    $0x1,%ecx
801017a5:	89 cb                	mov    %ecx,%ebx
801017a7:	c1 fb 1f             	sar    $0x1f,%ebx
801017aa:	c1 eb 19             	shr    $0x19,%ebx
801017ad:	8d 04 19             	lea    (%ecx,%ebx,1),%eax
801017b0:	83 e0 7f             	and    $0x7f,%eax
801017b3:	29 d8                	sub    %ebx,%eax
801017b5:	89 d3                	mov    %edx,%ebx
801017b7:	c1 fb 1f             	sar    $0x1f,%ebx
801017ba:	0f b6 80 40 15 11 80 	movzbl -0x7feeeac0(%eax),%eax
801017c1:	c1 eb 19             	shr    $0x19,%ebx
801017c4:	01 da                	add    %ebx,%edx
801017c6:	83 e2 7f             	and    $0x7f,%edx
801017c9:	29 da                	sub    %ebx,%edx
801017cb:	88 82 40 15 11 80    	mov    %al,-0x7feeeac0(%edx)
  for(int i = input.e - num_of_left_pressed - 1; i < input.e; i++){
801017d1:	39 f1                	cmp    %esi,%ecx
801017d3:	75 cb                	jne    801017a0 <consoleintr+0x260>
  if(panicked){
801017d5:	a1 b8 16 11 80       	mov    0x801116b8,%eax
          input.e--;
801017da:	89 3d c8 15 11 80    	mov    %edi,0x801115c8
  if(panicked){
801017e0:	85 c0                	test   %eax,%eax
801017e2:	0f 84 92 03 00 00    	je     80101b7a <consoleintr+0x63a>
  asm volatile("cli");
801017e8:	fa                   	cli    
    for(;;)
801017e9:	eb fe                	jmp    801017e9 <consoleintr+0x2a9>
801017eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017ef:	90                   	nop
  memset(coppied_input, '\0', sizeof(coppied_input));
801017f0:	83 ec 04             	sub    $0x4,%esp
      ctrl_s_start = input.e - input.w;
801017f3:	a1 c8 15 11 80       	mov    0x801115c8,%eax
      cur_index = 0;
801017f8:	c7 05 d4 15 11 80 00 	movl   $0x0,0x801115d4
801017ff:	00 00 00 
  memset(coppied_input, '\0', sizeof(coppied_input));
80101802:	68 80 00 00 00       	push   $0x80
80101807:	6a 00                	push   $0x0
      ctrl_s_start = input.e - input.w;
80101809:	89 c2                	mov    %eax,%edx
8010180b:	2b 15 c4 15 11 80    	sub    0x801115c4,%edx
  memset(coppied_input, '\0', sizeof(coppied_input));
80101811:	68 e0 15 11 80       	push   $0x801115e0
      ctrl_s_pressed = 1;
80101816:	c7 05 c0 16 11 80 01 	movl   $0x1,0x801116c0
8010181d:	00 00 00 
      ctrl_s_start = input.e - input.w;
80101820:	89 15 cc 15 11 80    	mov    %edx,0x801115cc
  start_ctrl_s = input.e;
80101826:	a3 bc 16 11 80       	mov    %eax,0x801116bc
  memset(coppied_input, '\0', sizeof(coppied_input));
8010182b:	e8 e0 49 00 00       	call   80106210 <memset>
}
80101830:	83 c4 10             	add    $0x10,%esp
80101833:	e9 2b fd ff ff       	jmp    80101563 <consoleintr+0x23>
80101838:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183f:	90                   	nop
  if(ctrl_s_pressed){
80101840:	8b 0d c0 16 11 80    	mov    0x801116c0,%ecx
80101846:	85 c9                	test   %ecx,%ecx
80101848:	0f 84 15 fd ff ff    	je     80101563 <consoleintr+0x23>
    print_copied_command();
8010184e:	e8 bd f2 ff ff       	call   80100b10 <print_copied_command>
80101853:	e9 0b fd ff ff       	jmp    80101563 <consoleintr+0x23>
80101858:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop
    switch(c){
80101860:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
80101867:	e9 f7 fc ff ff       	jmp    80101563 <consoleintr+0x23>
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((input.e - num_of_left_pressed) > input.w){
80101870:	8b 0d c4 16 11 80    	mov    0x801116c4,%ecx
80101876:	a1 c8 15 11 80       	mov    0x801115c8,%eax
8010187b:	29 c8                	sub    %ecx,%eax
8010187d:	3b 05 c4 15 11 80    	cmp    0x801115c4,%eax
80101883:	0f 86 da fc ff ff    	jbe    80101563 <consoleintr+0x23>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101889:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010188e:	b8 0e 00 00 00       	mov    $0xe,%eax
80101893:	89 fa                	mov    %edi,%edx
80101895:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101896:	be d5 03 00 00       	mov    $0x3d5,%esi
8010189b:	89 f2                	mov    %esi,%edx
8010189d:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
8010189e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801018a1:	89 fa                	mov    %edi,%edx
801018a3:	89 c3                	mov    %eax,%ebx
801018a5:	b8 0f 00 00 00       	mov    $0xf,%eax
801018aa:	c1 e3 08             	shl    $0x8,%ebx
801018ad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801018ae:	89 f2                	mov    %esi,%edx
801018b0:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
801018b1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801018b4:	89 fa                	mov    %edi,%edx
801018b6:	09 c3                	or     %eax,%ebx
801018b8:	b8 0e 00 00 00       	mov    $0xe,%eax
      pos -= 1;
801018bd:	83 eb 01             	sub    $0x1,%ebx
801018c0:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
801018c1:	89 da                	mov    %ebx,%edx
801018c3:	c1 fa 08             	sar    $0x8,%edx
801018c6:	89 d0                	mov    %edx,%eax
801018c8:	89 f2                	mov    %esi,%edx
801018ca:	ee                   	out    %al,(%dx)
801018cb:	b8 0f 00 00 00       	mov    $0xf,%eax
801018d0:	89 fa                	mov    %edi,%edx
801018d2:	ee                   	out    %al,(%dx)
801018d3:	89 d8                	mov    %ebx,%eax
801018d5:	89 f2                	mov    %esi,%edx
801018d7:	ee                   	out    %al,(%dx)
        if(ctrl_s_pressed && cur_index > 0 && num_of_left_copy < cur_index)
801018d8:	8b 3d c0 16 11 80    	mov    0x801116c0,%edi
        num_of_left_pressed++;
801018de:	83 c1 01             	add    $0x1,%ecx
801018e1:	89 0d c4 16 11 80    	mov    %ecx,0x801116c4
        if(ctrl_s_pressed && cur_index > 0 && num_of_left_copy < cur_index)
801018e7:	85 ff                	test   %edi,%edi
801018e9:	0f 84 74 fc ff ff    	je     80101563 <consoleintr+0x23>
801018ef:	8b 15 d4 15 11 80    	mov    0x801115d4,%edx
801018f5:	85 d2                	test   %edx,%edx
801018f7:	0f 8e 66 fc ff ff    	jle    80101563 <consoleintr+0x23>
801018fd:	a1 d0 15 11 80       	mov    0x801115d0,%eax
80101902:	39 c2                	cmp    %eax,%edx
80101904:	0f 8e 59 fc ff ff    	jle    80101563 <consoleintr+0x23>
          num_of_left_copy++;
8010190a:	83 c0 01             	add    $0x1,%eax
8010190d:	a3 d0 15 11 80       	mov    %eax,0x801115d0
80101912:	e9 4c fc ff ff       	jmp    80101563 <consoleintr+0x23>
80101917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010191e:	66 90                	xchg   %ax,%ax
      for(int i = 0; i < num_of_left_pressed; i++)
80101920:	a1 c4 16 11 80       	mov    0x801116c4,%eax
80101925:	31 ff                	xor    %edi,%edi
80101927:	be d4 03 00 00       	mov    $0x3d4,%esi
8010192c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010192f:	85 c0                	test   %eax,%eax
80101931:	7e 55                	jle    80101988 <consoleintr+0x448>
80101933:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101937:	90                   	nop
80101938:	b8 0e 00 00 00       	mov    $0xe,%eax
8010193d:	89 f2                	mov    %esi,%edx
8010193f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101940:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80101945:	89 da                	mov    %ebx,%edx
80101947:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80101948:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010194b:	89 f2                	mov    %esi,%edx
8010194d:	b8 0f 00 00 00       	mov    $0xf,%eax
80101952:	c1 e1 08             	shl    $0x8,%ecx
80101955:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101956:	89 da                	mov    %ebx,%edx
80101958:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80101959:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010195c:	89 f2                	mov    %esi,%edx
8010195e:	09 c1                	or     %eax,%ecx
80101960:	b8 0e 00 00 00       	mov    $0xe,%eax
      pos += 1;
80101965:	83 c1 01             	add    $0x1,%ecx
80101968:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
80101969:	89 ca                	mov    %ecx,%edx
8010196b:	c1 fa 08             	sar    $0x8,%edx
8010196e:	89 d0                	mov    %edx,%eax
80101970:	89 da                	mov    %ebx,%edx
80101972:	ee                   	out    %al,(%dx)
80101973:	b8 0f 00 00 00       	mov    $0xf,%eax
80101978:	89 f2                	mov    %esi,%edx
8010197a:	ee                   	out    %al,(%dx)
8010197b:	89 c8                	mov    %ecx,%eax
8010197d:	89 da                	mov    %ebx,%edx
8010197f:	ee                   	out    %al,(%dx)
      for(int i = 0; i < num_of_left_pressed; i++)
80101980:	83 c7 01             	add    $0x1,%edi
80101983:	39 7d e0             	cmp    %edi,-0x20(%ebp)
80101986:	75 b0                	jne    80101938 <consoleintr+0x3f8>
      if(currecnt_com == 0){
80101988:	8b 35 60 16 11 80    	mov    0x80111660,%esi
      num_of_left_pressed = 0;
8010198e:	c7 05 c4 16 11 80 00 	movl   $0x0,0x801116c4
80101995:	00 00 00 
      if(currecnt_com == 0){
80101998:	85 f6                	test   %esi,%esi
8010199a:	75 1d                	jne    801019b9 <consoleintr+0x479>
        history_cmnd.current_command = input;
8010199c:	b8 98 14 11 80       	mov    $0x80111498,%eax
801019a1:	be 40 15 11 80       	mov    $0x80111540,%esi
801019a6:	b9 23 00 00 00       	mov    $0x23,%ecx
        currecnt_com = 1;
801019ab:	c7 05 60 16 11 80 01 	movl   $0x1,0x80111660
801019b2:	00 00 00 
        history_cmnd.current_command = input;
801019b5:	89 c7                	mov    %eax,%edi
801019b7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
      if(history_cmnd.num_of_cmnd != 0 && history_cmnd.num_of_press < history_cmnd.num_of_cmnd){
801019b9:	a1 24 15 11 80       	mov    0x80111524,%eax
801019be:	85 c0                	test   %eax,%eax
801019c0:	0f 84 9d fb ff ff    	je     80101563 <consoleintr+0x23>
801019c6:	8b 15 2c 15 11 80    	mov    0x8011152c,%edx
801019cc:	39 d0                	cmp    %edx,%eax
801019ce:	0f 8e 8f fb ff ff    	jle    80101563 <consoleintr+0x23>
        handle_up_and_down_arrow(UP);
801019d4:	83 ec 0c             	sub    $0xc,%esp
        history_cmnd.num_of_press++;
801019d7:	83 c2 01             	add    $0x1,%edx
        handle_up_and_down_arrow(UP);
801019da:	6a 01                	push   $0x1
        history_cmnd.num_of_press++;
801019dc:	89 15 2c 15 11 80    	mov    %edx,0x8011152c
        handle_up_and_down_arrow(UP);
801019e2:	e8 99 f7 ff ff       	call   80101180 <handle_up_and_down_arrow>
801019e7:	83 c4 10             	add    $0x10,%esp
801019ea:	e9 74 fb ff ff       	jmp    80101563 <consoleintr+0x23>
801019ef:	90                   	nop
  for(int i = input.w; i < input.e; i++){
801019f0:	8b 35 c4 15 11 80    	mov    0x801115c4,%esi
801019f6:	a1 c8 15 11 80       	mov    0x801115c8,%eax
801019fb:	39 f0                	cmp    %esi,%eax
801019fd:	76 66                	jbe    80101a65 <consoleintr+0x525>
      for(int i = 0; i < num_of_left_pressed; i++)
801019ff:	89 f2                	mov    %esi,%edx
80101a01:	eb 0c                	jmp    80101a0f <consoleintr+0x4cf>
80101a03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a07:	90                   	nop
  for(int i = input.w; i < input.e; i++){
80101a08:	83 c2 01             	add    $0x1,%edx
80101a0b:	39 c2                	cmp    %eax,%edx
80101a0d:	73 49                	jae    80101a58 <consoleintr+0x518>
    if(input.buf[i] == '?'){
80101a0f:	80 ba 40 15 11 80 3f 	cmpb   $0x3f,-0x7feeeac0(%edx)
80101a16:	75 f0                	jne    80101a08 <consoleintr+0x4c8>
80101a18:	eb 11                	jmp    80101a2b <consoleintr+0x4eb>
80101a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(int i = input.w; i < input.e; i++){
80101a20:	83 c6 01             	add    $0x1,%esi
80101a23:	39 f0                	cmp    %esi,%eax
80101a25:	0f 86 de 01 00 00    	jbe    80101c09 <consoleintr+0x6c9>
    if(input.buf[i] == '?'){
80101a2b:	80 be 40 15 11 80 3f 	cmpb   $0x3f,-0x7feeeac0(%esi)
80101a32:	75 ec                	jne    80101a20 <consoleintr+0x4e0>
  index_question_mark = qm_index;
80101a34:	89 35 64 16 11 80    	mov    %esi,0x80111664
80101a3a:	bf 04 00 00 00       	mov    $0x4,%edi
    check_states_question_mark(input.buf[qm_index - i]);
80101a3f:	0f be 84 3e 3b 15 11 	movsbl -0x7feeeac5(%esi,%edi,1),%eax
80101a46:	80 
80101a47:	83 ec 0c             	sub    $0xc,%esp
80101a4a:	50                   	push   %eax
80101a4b:	e8 f0 f7 ff ff       	call   80101240 <check_states_question_mark>
  for(int i = 1;i <= 4; i++){
80101a50:	83 c4 10             	add    $0x10,%esp
80101a53:	83 ef 01             	sub    $0x1,%edi
80101a56:	75 e7                	jne    80101a3f <consoleintr+0x4ff>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80101a58:	a1 c8 15 11 80       	mov    0x801115c8,%eax
80101a5d:	85 db                	test   %ebx,%ebx
80101a5f:	0f 84 fe fa ff ff    	je     80101563 <consoleintr+0x23>
80101a65:	89 c2                	mov    %eax,%edx
80101a67:	2b 15 c0 15 11 80    	sub    0x801115c0,%edx
80101a6d:	83 fa 7f             	cmp    $0x7f,%edx
80101a70:	0f 87 ed fa ff ff    	ja     80101563 <consoleintr+0x23>
        if(ctrl_s_pressed){
80101a76:	8b 15 c0 16 11 80    	mov    0x801116c0,%edx
        c = (c == '\r') ? '\n' : c;
80101a7c:	83 fb 0d             	cmp    $0xd,%ebx
80101a7f:	0f 84 6f 02 00 00    	je     80101cf4 <consoleintr+0x7b4>
        if(num_of_left_pressed == 0 || c == '\n'){
80101a85:	83 fb 0a             	cmp    $0xa,%ebx
            coppied_input[cur_index] = c;
80101a88:	88 5d e0             	mov    %bl,-0x20(%ebp)
        if(num_of_left_pressed == 0 || c == '\n'){
80101a8b:	0f 94 45 d8          	sete   -0x28(%ebp)
        if(ctrl_s_pressed){
80101a8f:	85 d2                	test   %edx,%edx
80101a91:	0f 85 ff 00 00 00    	jne    80101b96 <consoleintr+0x656>
          if(num_of_left_pressed == 0){
80101a97:	8b 3d c4 16 11 80    	mov    0x801116c4,%edi
80101a9d:	89 7d d4             	mov    %edi,-0x2c(%ebp)
        if(num_of_left_pressed == 0 || c == '\n'){
80101aa0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80101aa3:	85 d2                	test   %edx,%edx
80101aa5:	0f 94 c2             	sete   %dl
80101aa8:	0a 55 d8             	or     -0x28(%ebp),%dl
80101aab:	0f 84 5d 02 00 00    	je     80101d0e <consoleintr+0x7ce>
          input.buf[input.e++ % INPUT_BUF] = c;
80101ab1:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
80101ab5:	8d 50 01             	lea    0x1(%eax),%edx
80101ab8:	83 e0 7f             	and    $0x7f,%eax
80101abb:	89 15 c8 15 11 80    	mov    %edx,0x801115c8
80101ac1:	88 88 40 15 11 80    	mov    %cl,-0x7feeeac0(%eax)
  if(panicked){
80101ac7:	8b 35 b8 16 11 80    	mov    0x801116b8,%esi
80101acd:	85 f6                	test   %esi,%esi
80101acf:	0f 84 83 01 00 00    	je     80101c58 <consoleintr+0x718>
  asm volatile("cli");
80101ad5:	fa                   	cli    
    for(;;)
80101ad6:	eb fe                	jmp    80101ad6 <consoleintr+0x596>
80101ad8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101adf:	90                   	nop
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101ae0:	bf d4 03 00 00       	mov    $0x3d4,%edi
80101ae5:	b8 0e 00 00 00       	mov    $0xe,%eax
80101aea:	89 fa                	mov    %edi,%edx
80101aec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101aed:	be d5 03 00 00       	mov    $0x3d5,%esi
80101af2:	89 f2                	mov    %esi,%edx
80101af4:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80101af5:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101af8:	89 fa                	mov    %edi,%edx
80101afa:	89 c1                	mov    %eax,%ecx
80101afc:	b8 0f 00 00 00       	mov    $0xf,%eax
80101b01:	c1 e1 08             	shl    $0x8,%ecx
80101b04:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101b05:	89 f2                	mov    %esi,%edx
80101b07:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80101b08:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101b0b:	89 fa                	mov    %edi,%edx
80101b0d:	09 c1                	or     %eax,%ecx
80101b0f:	b8 0e 00 00 00       	mov    $0xe,%eax
      pos += 1;
80101b14:	83 c1 01             	add    $0x1,%ecx
80101b17:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
80101b18:	89 ca                	mov    %ecx,%edx
80101b1a:	c1 fa 08             	sar    $0x8,%edx
80101b1d:	89 d0                	mov    %edx,%eax
80101b1f:	89 f2                	mov    %esi,%edx
80101b21:	ee                   	out    %al,(%dx)
80101b22:	b8 0f 00 00 00       	mov    $0xf,%eax
80101b27:	89 fa                	mov    %edi,%edx
80101b29:	ee                   	out    %al,(%dx)
80101b2a:	89 c8                	mov    %ecx,%eax
80101b2c:	89 f2                	mov    %esi,%edx
80101b2e:	ee                   	out    %al,(%dx)
        num_of_left_pressed--;
80101b2f:	83 eb 01             	sub    $0x1,%ebx
80101b32:	89 1d c4 16 11 80    	mov    %ebx,0x801116c4
80101b38:	e9 bb fa ff ff       	jmp    801015f8 <consoleintr+0xb8>
}
80101b3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b40:	5b                   	pop    %ebx
80101b41:	5e                   	pop    %esi
80101b42:	5f                   	pop    %edi
80101b43:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80101b44:	e9 b7 3f 00 00       	jmp    80105b00 <procdump>
        input.e--;
80101b49:	83 e8 01             	sub    $0x1,%eax
80101b4c:	a3 c8 15 11 80       	mov    %eax,0x801115c8
  if(panicked){
80101b51:	a1 b8 16 11 80       	mov    0x801116b8,%eax
80101b56:	85 c0                	test   %eax,%eax
80101b58:	74 20                	je     80101b7a <consoleintr+0x63a>
  asm volatile("cli");
80101b5a:	fa                   	cli    
    for(;;)
80101b5b:	eb fe                	jmp    80101b5b <consoleintr+0x61b>
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
        handle_up_and_down_arrow(DOWN);
80101b60:	83 ec 0c             	sub    $0xc,%esp
        history_cmnd.num_of_press--;
80101b63:	83 e8 01             	sub    $0x1,%eax
        handle_up_and_down_arrow(DOWN);
80101b66:	6a 00                	push   $0x0
        history_cmnd.num_of_press--;
80101b68:	a3 2c 15 11 80       	mov    %eax,0x8011152c
        handle_up_and_down_arrow(DOWN);
80101b6d:	e8 0e f6 ff ff       	call   80101180 <handle_up_and_down_arrow>
80101b72:	83 c4 10             	add    $0x10,%esp
80101b75:	e9 e9 f9 ff ff       	jmp    80101563 <consoleintr+0x23>
80101b7a:	b8 00 01 00 00       	mov    $0x100,%eax
80101b7f:	e8 7c e8 ff ff       	call   80100400 <consputc.part.0>
80101b84:	e9 da f9 ff ff       	jmp    80101563 <consoleintr+0x23>
        if(ctrl_s_pressed){
80101b89:	c6 45 d8 01          	movb   $0x1,-0x28(%ebp)
        c = (c == '\r') ? '\n' : c;
80101b8d:	bb 0a 00 00 00       	mov    $0xa,%ebx
        if(ctrl_s_pressed){
80101b92:	c6 45 e0 0a          	movb   $0xa,-0x20(%ebp)
          if(num_of_left_pressed == 0){
80101b96:	8b 35 c4 16 11 80    	mov    0x801116c4,%esi
            coppied_input[cur_index] = c;
80101b9c:	8b 3d d4 15 11 80    	mov    0x801115d4,%edi
          if(num_of_left_pressed == 0){
80101ba2:	89 75 d4             	mov    %esi,-0x2c(%ebp)
80101ba5:	85 f6                	test   %esi,%esi
80101ba7:	0f 84 93 00 00 00    	je     80101c40 <consoleintr+0x700>
  int limit = cur_index - 1 - num_of_left_copy;
80101bad:	8b 15 d0 15 11 80    	mov    0x801115d0,%edx
80101bb3:	89 55 cc             	mov    %edx,-0x34(%ebp)
            if(cur_index - num_of_left_pressed >= 0){
80101bb6:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80101bb9:	0f 8d 21 02 00 00    	jge    80101de0 <consoleintr+0x8a0>
            else if(num_of_left_copy > 0 && num_of_left_copy != cur_index){
80101bbf:	8b 75 cc             	mov    -0x34(%ebp),%esi
80101bc2:	39 fe                	cmp    %edi,%esi
80101bc4:	0f 84 d6 fe ff ff    	je     80101aa0 <consoleintr+0x560>
80101bca:	85 f6                	test   %esi,%esi
80101bcc:	0f 8e ce fe ff ff    	jle    80101aa0 <consoleintr+0x560>
              coppied_input[cur_index - num_of_left_copy] = c;
80101bd2:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
80101bd6:	89 fa                	mov    %edi,%edx
80101bd8:	29 f2                	sub    %esi,%edx
80101bda:	88 8a e0 15 11 80    	mov    %cl,-0x7feeea20(%edx)
              cur_index++;
80101be0:	8d 57 01             	lea    0x1(%edi),%edx
80101be3:	89 15 d4 15 11 80    	mov    %edx,0x801115d4
80101be9:	e9 b2 fe ff ff       	jmp    80101aa0 <consoleintr+0x560>
80101bee:	66 90                	xchg   %ax,%ax
          else if(num_of_left_copy > 0 && num_of_left_copy != cur_index){
80101bf0:	7e 3e                	jle    80101c30 <consoleintr+0x6f0>
80101bf2:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bf5:	39 fa                	cmp    %edi,%edx
80101bf7:	0f 85 86 01 00 00    	jne    80101d83 <consoleintr+0x843>
            ctrl_s_start--;
80101bfd:	83 2d cc 15 11 80 01 	subl   $0x1,0x801115cc
80101c04:	e9 6b fb ff ff       	jmp    80101774 <consoleintr+0x234>
  return 0;
80101c09:	31 f6                	xor    %esi,%esi
80101c0b:	e9 24 fe ff ff       	jmp    80101a34 <consoleintr+0x4f4>
  for(int i = input.w; i < input.e; i++){
80101c10:	8b 35 c4 15 11 80    	mov    0x801115c4,%esi
80101c16:	a1 c8 15 11 80       	mov    0x801115c8,%eax
80101c1b:	39 c6                	cmp    %eax,%esi
80101c1d:	0f 82 dc fd ff ff    	jb     801019ff <consoleintr+0x4bf>
80101c23:	e9 30 fe ff ff       	jmp    80101a58 <consoleintr+0x518>
80101c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c2f:	90                   	nop
          else if(num_of_left_copy == cur_index){
80101c30:	3b 55 e0             	cmp    -0x20(%ebp),%edx
80101c33:	0f 85 3b fb ff ff    	jne    80101774 <consoleintr+0x234>
80101c39:	eb c2                	jmp    80101bfd <consoleintr+0x6bd>
80101c3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c3f:	90                   	nop
            coppied_input[cur_index] = c;
80101c40:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
            cur_index++;
80101c44:	8d 57 01             	lea    0x1(%edi),%edx
80101c47:	89 15 d4 15 11 80    	mov    %edx,0x801115d4
            coppied_input[cur_index] = c;
80101c4d:	88 8f e0 15 11 80    	mov    %cl,-0x7feeea20(%edi)
        if(num_of_left_pressed == 0 || c == '\n'){
80101c53:	e9 59 fe ff ff       	jmp    80101ab1 <consoleintr+0x571>
80101c58:	89 d8                	mov    %ebx,%eax
80101c5a:	e8 a1 e7 ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80101c5f:	83 fb 04             	cmp    $0x4,%ebx
80101c62:	74 1a                	je     80101c7e <consoleintr+0x73e>
80101c64:	80 7d d8 00          	cmpb   $0x0,-0x28(%ebp)
80101c68:	75 14                	jne    80101c7e <consoleintr+0x73e>
80101c6a:	a1 c0 15 11 80       	mov    0x801115c0,%eax
80101c6f:	83 e8 80             	sub    $0xffffff80,%eax
80101c72:	39 05 c8 15 11 80    	cmp    %eax,0x801115c8
80101c78:	0f 85 e5 f8 ff ff    	jne    80101563 <consoleintr+0x23>
          num_of_left_pressed = 0;
80101c7e:	c7 05 c4 16 11 80 00 	movl   $0x0,0x801116c4
80101c85:	00 00 00 
          num_of_left_copy = 0;
80101c88:	c7 05 d0 15 11 80 00 	movl   $0x0,0x801115d0
80101c8f:	00 00 00 
          history_cmnd.num_of_press = 0;
80101c92:	c7 05 2c 15 11 80 00 	movl   $0x0,0x8011152c
80101c99:	00 00 00 
          update_history_memory();
80101c9c:	e8 8f f6 ff ff       	call   80101330 <update_history_memory>
          if(is_history(hist)){
80101ca1:	8b 15 00 a0 10 80    	mov    0x8010a000,%edx
    if(command[i] != input.buf[i + input.w]){
80101ca7:	a1 c4 15 11 80       	mov    0x801115c4,%eax
80101cac:	0f b6 8c 30 40 15 11 	movzbl -0x7feeeac0(%eax,%esi,1),%ecx
80101cb3:	80 
80101cb4:	38 0c 32             	cmp    %cl,(%edx,%esi,1)
80101cb7:	75 0d                	jne    80101cc6 <consoleintr+0x786>
  for(int i = 0; i < 8; i++){
80101cb9:	83 c6 01             	add    $0x1,%esi
80101cbc:	83 fe 08             	cmp    $0x8,%esi
80101cbf:	75 eb                	jne    80101cac <consoleintr+0x76c>
            print_history();
80101cc1:	e8 5a ed ff ff       	call   80100a20 <print_history>
          update_coppied_commands();
80101cc6:	e8 45 ef ff ff       	call   80100c10 <update_coppied_commands>
          wakeup(&input.r);
80101ccb:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80101cce:	a1 c8 15 11 80       	mov    0x801115c8,%eax
          currecnt_com = 0;
80101cd3:	c7 05 60 16 11 80 00 	movl   $0x0,0x80111660
80101cda:	00 00 00 
          wakeup(&input.r);
80101cdd:	68 c0 15 11 80       	push   $0x801115c0
          input.w = input.e;
80101ce2:	a3 c4 15 11 80       	mov    %eax,0x801115c4
          wakeup(&input.r);
80101ce7:	e8 34 3d 00 00       	call   80105a20 <wakeup>
80101cec:	83 c4 10             	add    $0x10,%esp
80101cef:	e9 6f f8 ff ff       	jmp    80101563 <consoleintr+0x23>
        if(ctrl_s_pressed){
80101cf4:	85 d2                	test   %edx,%edx
80101cf6:	0f 85 8d fe ff ff    	jne    80101b89 <consoleintr+0x649>
80101cfc:	c6 45 e0 0a          	movb   $0xa,-0x20(%ebp)
        c = (c == '\r') ? '\n' : c;
80101d00:	bb 0a 00 00 00       	mov    $0xa,%ebx
        if(num_of_left_pressed == 0 || c == '\n'){
80101d05:	c6 45 d8 01          	movb   $0x1,-0x28(%ebp)
80101d09:	e9 a3 fd ff ff       	jmp    80101ab1 <consoleintr+0x571>
  int limit = input.e - num_of_left_pressed - 1;
80101d0e:	89 c7                	mov    %eax,%edi
80101d10:	2b 7d d4             	sub    -0x2c(%ebp),%edi
  int init = input.e - 1;
80101d13:	8d 48 ff             	lea    -0x1(%eax),%ecx
  int limit = input.e - num_of_left_pressed - 1;
80101d16:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101d19:	83 ef 01             	sub    $0x1,%edi
  for(int i = init; i > limit; i--){
80101d1c:	39 f9                	cmp    %edi,%ecx
80101d1e:	7e 42                	jle    80101d62 <consoleintr+0x822>
80101d20:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
80101d23:	89 fb                	mov    %edi,%ebx
80101d25:	89 c7                	mov    %eax,%edi
    input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
80101d27:	89 ca                	mov    %ecx,%edx
80101d29:	c1 fa 1f             	sar    $0x1f,%edx
80101d2c:	c1 ea 19             	shr    $0x19,%edx
80101d2f:	8d 04 11             	lea    (%ecx,%edx,1),%eax
80101d32:	83 e0 7f             	and    $0x7f,%eax
80101d35:	29 d0                	sub    %edx,%eax
80101d37:	8d 51 01             	lea    0x1(%ecx),%edx
  for(int i = init; i > limit; i--){
80101d3a:	83 e9 01             	sub    $0x1,%ecx
    input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
80101d3d:	89 d6                	mov    %edx,%esi
80101d3f:	0f b6 80 40 15 11 80 	movzbl -0x7feeeac0(%eax),%eax
80101d46:	c1 fe 1f             	sar    $0x1f,%esi
80101d49:	c1 ee 19             	shr    $0x19,%esi
80101d4c:	01 f2                	add    %esi,%edx
80101d4e:	83 e2 7f             	and    $0x7f,%edx
80101d51:	29 f2                	sub    %esi,%edx
80101d53:	88 82 40 15 11 80    	mov    %al,-0x7feeeac0(%edx)
  for(int i = init; i > limit; i--){
80101d59:	39 cb                	cmp    %ecx,%ebx
80101d5b:	7c ca                	jl     80101d27 <consoleintr+0x7e7>
80101d5d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
80101d60:	89 f8                	mov    %edi,%eax
          input.buf[(input.e - num_of_left_pressed) % INPUT_BUF] = c;
80101d62:	8b 55 d8             	mov    -0x28(%ebp),%edx
80101d65:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
          input.e++;
80101d69:	83 c0 01             	add    $0x1,%eax
        if(num_of_left_pressed == 0 || c == '\n'){
80101d6c:	c6 45 d8 00          	movb   $0x0,-0x28(%ebp)
          input.e++;
80101d70:	a3 c8 15 11 80       	mov    %eax,0x801115c8
          input.buf[(input.e - num_of_left_pressed) % INPUT_BUF] = c;
80101d75:	83 e2 7f             	and    $0x7f,%edx
80101d78:	88 8a 40 15 11 80    	mov    %cl,-0x7feeeac0(%edx)
          input.e++;
80101d7e:	e9 44 fd ff ff       	jmp    80101ac7 <consoleintr+0x587>
  for(int i = cur_index - num_of_left_copy - 1; i < cur_index; i++){
80101d83:	89 fb                	mov    %edi,%ebx
80101d85:	29 d3                	sub    %edx,%ebx
80101d87:	83 eb 01             	sub    $0x1,%ebx
80101d8a:	39 fb                	cmp    %edi,%ebx
80101d8c:	7d 3a                	jge    80101dc8 <consoleintr+0x888>
80101d8e:	89 c7                	mov    %eax,%edi
    coppied_input[i % INPUT_BUF] = coppied_input[(i + 1) % INPUT_BUF];
80101d90:	89 da                	mov    %ebx,%edx
80101d92:	83 c3 01             	add    $0x1,%ebx
80101d95:	89 de                	mov    %ebx,%esi
80101d97:	c1 fe 1f             	sar    $0x1f,%esi
80101d9a:	c1 ee 19             	shr    $0x19,%esi
80101d9d:	8d 04 33             	lea    (%ebx,%esi,1),%eax
80101da0:	83 e0 7f             	and    $0x7f,%eax
80101da3:	29 f0                	sub    %esi,%eax
80101da5:	89 d6                	mov    %edx,%esi
80101da7:	c1 fe 1f             	sar    $0x1f,%esi
80101daa:	0f b6 80 e0 15 11 80 	movzbl -0x7feeea20(%eax),%eax
80101db1:	c1 ee 19             	shr    $0x19,%esi
80101db4:	01 f2                	add    %esi,%edx
80101db6:	83 e2 7f             	and    $0x7f,%edx
80101db9:	29 f2                	sub    %esi,%edx
80101dbb:	88 82 e0 15 11 80    	mov    %al,-0x7feeea20(%edx)
  for(int i = cur_index - num_of_left_copy - 1; i < cur_index; i++){
80101dc1:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
80101dc4:	75 ca                	jne    80101d90 <consoleintr+0x850>
80101dc6:	89 f8                	mov    %edi,%eax
            coppied_input[cur_index - 1] = '\0';
80101dc8:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101dcb:	c6 82 df 15 11 80 00 	movb   $0x0,-0x7feeea21(%edx)
80101dd2:	83 ea 01             	sub    $0x1,%edx
            cur_index--;
80101dd5:	89 15 d4 15 11 80    	mov    %edx,0x801115d4
80101ddb:	e9 94 f9 ff ff       	jmp    80101774 <consoleintr+0x234>
  int init = cur_index - 1;
80101de0:	8d 4f ff             	lea    -0x1(%edi),%ecx
  int limit = cur_index - 1 - num_of_left_copy;
80101de3:	89 ce                	mov    %ecx,%esi
80101de5:	29 d6                	sub    %edx,%esi
80101de7:	89 75 d0             	mov    %esi,-0x30(%ebp)
  for(int i = init; i > limit; i--){
80101dea:	39 f1                	cmp    %esi,%ecx
80101dec:	7e 41                	jle    80101e2f <consoleintr+0x8ef>
80101dee:	89 5d c8             	mov    %ebx,-0x38(%ebp)
80101df1:	89 c6                	mov    %eax,%esi
    coppied_input[(i + 1) % INPUT_BUF] = coppied_input[i % INPUT_BUF];
80101df3:	89 ca                	mov    %ecx,%edx
80101df5:	c1 fa 1f             	sar    $0x1f,%edx
80101df8:	c1 ea 19             	shr    $0x19,%edx
80101dfb:	8d 04 11             	lea    (%ecx,%edx,1),%eax
80101dfe:	83 e0 7f             	and    $0x7f,%eax
80101e01:	29 d0                	sub    %edx,%eax
80101e03:	8d 51 01             	lea    0x1(%ecx),%edx
  for(int i = init; i > limit; i--){
80101e06:	83 e9 01             	sub    $0x1,%ecx
    coppied_input[(i + 1) % INPUT_BUF] = coppied_input[i % INPUT_BUF];
80101e09:	89 d3                	mov    %edx,%ebx
80101e0b:	0f b6 80 e0 15 11 80 	movzbl -0x7feeea20(%eax),%eax
80101e12:	c1 fb 1f             	sar    $0x1f,%ebx
80101e15:	c1 eb 19             	shr    $0x19,%ebx
80101e18:	01 da                	add    %ebx,%edx
80101e1a:	83 e2 7f             	and    $0x7f,%edx
80101e1d:	29 da                	sub    %ebx,%edx
80101e1f:	88 82 e0 15 11 80    	mov    %al,-0x7feeea20(%edx)
  for(int i = init; i > limit; i--){
80101e25:	39 4d d0             	cmp    %ecx,-0x30(%ebp)
80101e28:	75 c9                	jne    80101df3 <consoleintr+0x8b3>
80101e2a:	8b 5d c8             	mov    -0x38(%ebp),%ebx
80101e2d:	89 f0                	mov    %esi,%eax
              coppied_input[cur_index - num_of_left_copy] = c;
80101e2f:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
80101e33:	89 fa                	mov    %edi,%edx
80101e35:	2b 55 cc             	sub    -0x34(%ebp),%edx
80101e38:	88 8a e0 15 11 80    	mov    %cl,-0x7feeea20(%edx)
              cur_index++;
80101e3e:	8d 57 01             	lea    0x1(%edi),%edx
80101e41:	89 15 d4 15 11 80    	mov    %edx,0x801115d4
80101e47:	e9 54 fc ff ff       	jmp    80101aa0 <consoleintr+0x560>
80101e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e50 <consoleinit>:

void
consoleinit(void)
{
80101e50:	55                   	push   %ebp
80101e51:	89 e5                	mov    %esp,%ebp
80101e53:	83 ec 10             	sub    $0x10,%esp

  history_cmnd.num_of_cmnd = 0;
80101e56:	c7 05 24 15 11 80 00 	movl   $0x0,0x80111524
80101e5d:	00 00 00 
  history_cmnd.start_index = 0;
  history_cmnd.num_of_press = 0;

  initlock(&cons.lock, "console");
80101e60:	68 88 92 10 80       	push   $0x80109288
80101e65:	68 80 16 11 80       	push   $0x80111680
  history_cmnd.start_index = 0;
80101e6a:	c7 05 28 15 11 80 00 	movl   $0x0,0x80111528
80101e71:	00 00 00 
  history_cmnd.num_of_press = 0;
80101e74:	c7 05 2c 15 11 80 00 	movl   $0x0,0x8011152c
80101e7b:	00 00 00 
  initlock(&cons.lock, "console");
80101e7e:	e8 fd 40 00 00       	call   80105f80 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80101e83:	58                   	pop    %eax
80101e84:	5a                   	pop    %edx
80101e85:	6a 00                	push   $0x0
80101e87:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80101e89:	c7 05 8c 20 11 80 f0 	movl   $0x801005f0,0x8011208c
80101e90:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80101e93:	c7 05 88 20 11 80 80 	movl   $0x80100280,0x80112088
80101e9a:	02 10 80 
  cons.locking = 1;
80101e9d:	c7 05 b4 16 11 80 01 	movl   $0x1,0x801116b4
80101ea4:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80101ea7:	e8 e4 19 00 00       	call   80103890 <ioapicenable>
}
80101eac:	83 c4 10             	add    $0x10,%esp
80101eaf:	c9                   	leave  
80101eb0:	c3                   	ret    
80101eb1:	66 90                	xchg   %ax,%ax
80101eb3:	66 90                	xchg   %ax,%ax
80101eb5:	66 90                	xchg   %ax,%ax
80101eb7:	66 90                	xchg   %ax,%ax
80101eb9:	66 90                	xchg   %ax,%ax
80101ebb:	66 90                	xchg   %ax,%ax
80101ebd:	66 90                	xchg   %ax,%ax
80101ebf:	90                   	nop

80101ec0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80101ec0:	55                   	push   %ebp
80101ec1:	89 e5                	mov    %esp,%ebp
80101ec3:	57                   	push   %edi
80101ec4:	56                   	push   %esi
80101ec5:	53                   	push   %ebx
80101ec6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80101ecc:	e8 ff 30 00 00       	call   80104fd0 <myproc>
80101ed1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  begin_op();
80101ed7:	e8 94 22 00 00       	call   80104170 <begin_op>

  if((ip = namei(path)) == 0){
80101edc:	83 ec 0c             	sub    $0xc,%esp
80101edf:	ff 75 08             	push   0x8(%ebp)
80101ee2:	e8 c9 15 00 00       	call   801034b0 <namei>
80101ee7:	83 c4 10             	add    $0x10,%esp
80101eea:	85 c0                	test   %eax,%eax
80101eec:	0f 84 02 03 00 00    	je     801021f4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80101ef2:	83 ec 0c             	sub    $0xc,%esp
80101ef5:	89 c3                	mov    %eax,%ebx
80101ef7:	50                   	push   %eax
80101ef8:	e8 93 0c 00 00       	call   80102b90 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80101efd:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80101f03:	6a 34                	push   $0x34
80101f05:	6a 00                	push   $0x0
80101f07:	50                   	push   %eax
80101f08:	53                   	push   %ebx
80101f09:	e8 92 0f 00 00       	call   80102ea0 <readi>
80101f0e:	83 c4 20             	add    $0x20,%esp
80101f11:	83 f8 34             	cmp    $0x34,%eax
80101f14:	74 22                	je     80101f38 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80101f16:	83 ec 0c             	sub    $0xc,%esp
80101f19:	53                   	push   %ebx
80101f1a:	e8 01 0f 00 00       	call   80102e20 <iunlockput>
    end_op();
80101f1f:	e8 bc 22 00 00       	call   801041e0 <end_op>
80101f24:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80101f27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101f2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f2f:	5b                   	pop    %ebx
80101f30:	5e                   	pop    %esi
80101f31:	5f                   	pop    %edi
80101f32:	5d                   	pop    %ebp
80101f33:	c3                   	ret    
80101f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80101f38:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80101f3f:	45 4c 46 
80101f42:	75 d2                	jne    80101f16 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80101f44:	e8 77 6f 00 00       	call   80108ec0 <setupkvm>
80101f49:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80101f4f:	85 c0                	test   %eax,%eax
80101f51:	74 c3                	je     80101f16 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101f53:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80101f5a:	00 
80101f5b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80101f61:	0f 84 ac 02 00 00    	je     80102213 <exec+0x353>
  sz = 0;
80101f67:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80101f6e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101f71:	31 ff                	xor    %edi,%edi
80101f73:	e9 8e 00 00 00       	jmp    80102006 <exec+0x146>
80101f78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f7f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80101f80:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80101f87:	75 6c                	jne    80101ff5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80101f89:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80101f8f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80101f95:	0f 82 87 00 00 00    	jb     80102022 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80101f9b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80101fa1:	72 7f                	jb     80102022 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80101fa3:	83 ec 04             	sub    $0x4,%esp
80101fa6:	50                   	push   %eax
80101fa7:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80101fad:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101fb3:	e8 28 6d 00 00       	call   80108ce0 <allocuvm>
80101fb8:	83 c4 10             	add    $0x10,%esp
80101fbb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101fc1:	85 c0                	test   %eax,%eax
80101fc3:	74 5d                	je     80102022 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80101fc5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80101fcb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101fd0:	75 50                	jne    80102022 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80101fd2:	83 ec 0c             	sub    $0xc,%esp
80101fd5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80101fdb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80101fe1:	53                   	push   %ebx
80101fe2:	50                   	push   %eax
80101fe3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101fe9:	e8 02 6c 00 00       	call   80108bf0 <loaduvm>
80101fee:	83 c4 20             	add    $0x20,%esp
80101ff1:	85 c0                	test   %eax,%eax
80101ff3:	78 2d                	js     80102022 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101ff5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80101ffc:	83 c7 01             	add    $0x1,%edi
80101fff:	83 c6 20             	add    $0x20,%esi
80102002:	39 f8                	cmp    %edi,%eax
80102004:	7e 3a                	jle    80102040 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80102006:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
8010200c:	6a 20                	push   $0x20
8010200e:	56                   	push   %esi
8010200f:	50                   	push   %eax
80102010:	53                   	push   %ebx
80102011:	e8 8a 0e 00 00       	call   80102ea0 <readi>
80102016:	83 c4 10             	add    $0x10,%esp
80102019:	83 f8 20             	cmp    $0x20,%eax
8010201c:	0f 84 5e ff ff ff    	je     80101f80 <exec+0xc0>
    freevm(pgdir);
80102022:	83 ec 0c             	sub    $0xc,%esp
80102025:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
8010202b:	e8 10 6e 00 00       	call   80108e40 <freevm>
  if(ip){
80102030:	83 c4 10             	add    $0x10,%esp
80102033:	e9 de fe ff ff       	jmp    80101f16 <exec+0x56>
80102038:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010203f:	90                   	nop
  sz = PGROUNDUP(sz);
80102040:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80102046:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
8010204c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80102052:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80102058:	83 ec 0c             	sub    $0xc,%esp
8010205b:	53                   	push   %ebx
8010205c:	e8 bf 0d 00 00       	call   80102e20 <iunlockput>
  end_op();
80102061:	e8 7a 21 00 00       	call   801041e0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80102066:	83 c4 0c             	add    $0xc,%esp
80102069:	56                   	push   %esi
8010206a:	57                   	push   %edi
8010206b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80102071:	57                   	push   %edi
80102072:	e8 69 6c 00 00       	call   80108ce0 <allocuvm>
80102077:	83 c4 10             	add    $0x10,%esp
8010207a:	89 c6                	mov    %eax,%esi
8010207c:	85 c0                	test   %eax,%eax
8010207e:	0f 84 94 00 00 00    	je     80102118 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80102084:	83 ec 08             	sub    $0x8,%esp
80102087:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
8010208d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010208f:	50                   	push   %eax
80102090:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80102091:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80102093:	e8 c8 6e 00 00       	call   80108f60 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80102098:	8b 45 0c             	mov    0xc(%ebp),%eax
8010209b:	83 c4 10             	add    $0x10,%esp
8010209e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
801020a4:	8b 00                	mov    (%eax),%eax
801020a6:	85 c0                	test   %eax,%eax
801020a8:	0f 84 8b 00 00 00    	je     80102139 <exec+0x279>
801020ae:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
801020b4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
801020ba:	eb 23                	jmp    801020df <exec+0x21f>
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020c0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
801020c3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
801020ca:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
801020cd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
801020d3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
801020d6:	85 c0                	test   %eax,%eax
801020d8:	74 59                	je     80102133 <exec+0x273>
    if(argc >= MAXARG)
801020da:	83 ff 20             	cmp    $0x20,%edi
801020dd:	74 39                	je     80102118 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801020df:	83 ec 0c             	sub    $0xc,%esp
801020e2:	50                   	push   %eax
801020e3:	e8 28 43 00 00       	call   80106410 <strlen>
801020e8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801020ea:	58                   	pop    %eax
801020eb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801020ee:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801020f1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801020f4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801020f7:	e8 14 43 00 00       	call   80106410 <strlen>
801020fc:	83 c0 01             	add    $0x1,%eax
801020ff:	50                   	push   %eax
80102100:	8b 45 0c             	mov    0xc(%ebp),%eax
80102103:	ff 34 b8             	push   (%eax,%edi,4)
80102106:	53                   	push   %ebx
80102107:	56                   	push   %esi
80102108:	e8 23 70 00 00       	call   80109130 <copyout>
8010210d:	83 c4 20             	add    $0x20,%esp
80102110:	85 c0                	test   %eax,%eax
80102112:	79 ac                	jns    801020c0 <exec+0x200>
80102114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80102118:	83 ec 0c             	sub    $0xc,%esp
8010211b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80102121:	e8 1a 6d 00 00       	call   80108e40 <freevm>
80102126:	83 c4 10             	add    $0x10,%esp
  return -1;
80102129:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010212e:	e9 f9 fd ff ff       	jmp    80101f2c <exec+0x6c>
80102133:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80102139:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80102140:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80102142:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80102149:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010214d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
8010214f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80102152:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80102158:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
8010215a:	50                   	push   %eax
8010215b:	52                   	push   %edx
8010215c:	53                   	push   %ebx
8010215d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80102163:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
8010216a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010216d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80102173:	e8 b8 6f 00 00       	call   80109130 <copyout>
80102178:	83 c4 10             	add    $0x10,%esp
8010217b:	85 c0                	test   %eax,%eax
8010217d:	78 99                	js     80102118 <exec+0x258>
  for(last=s=path; *s; s++)
8010217f:	8b 45 08             	mov    0x8(%ebp),%eax
80102182:	8b 55 08             	mov    0x8(%ebp),%edx
80102185:	0f b6 00             	movzbl (%eax),%eax
80102188:	84 c0                	test   %al,%al
8010218a:	74 13                	je     8010219f <exec+0x2df>
8010218c:	89 d1                	mov    %edx,%ecx
8010218e:	66 90                	xchg   %ax,%ax
      last = s+1;
80102190:	83 c1 01             	add    $0x1,%ecx
80102193:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80102195:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80102198:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
8010219b:	84 c0                	test   %al,%al
8010219d:	75 f1                	jne    80102190 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
8010219f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
801021a5:	83 ec 04             	sub    $0x4,%esp
801021a8:	6a 10                	push   $0x10
801021aa:	89 f8                	mov    %edi,%eax
801021ac:	52                   	push   %edx
801021ad:	83 c0 6c             	add    $0x6c,%eax
801021b0:	50                   	push   %eax
801021b1:	e8 1a 42 00 00       	call   801063d0 <safestrcpy>
  curproc->pgdir = pgdir;
801021b6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
801021bc:	89 f8                	mov    %edi,%eax
801021be:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
801021c1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
801021c3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
801021c6:	89 c1                	mov    %eax,%ecx
801021c8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
801021ce:	8b 40 18             	mov    0x18(%eax),%eax
801021d1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
801021d4:	8b 41 18             	mov    0x18(%ecx),%eax
801021d7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
801021da:	89 0c 24             	mov    %ecx,(%esp)
801021dd:	e8 7e 68 00 00       	call   80108a60 <switchuvm>
  freevm(oldpgdir);
801021e2:	89 3c 24             	mov    %edi,(%esp)
801021e5:	e8 56 6c 00 00       	call   80108e40 <freevm>
  return 0;
801021ea:	83 c4 10             	add    $0x10,%esp
801021ed:	31 c0                	xor    %eax,%eax
801021ef:	e9 38 fd ff ff       	jmp    80101f2c <exec+0x6c>
    end_op();
801021f4:	e8 e7 1f 00 00       	call   801041e0 <end_op>
    cprintf("exec: fail\n");
801021f9:	83 ec 0c             	sub    $0xc,%esp
801021fc:	68 f4 92 10 80       	push   $0x801092f4
80102201:	e8 fa e4 ff ff       	call   80100700 <cprintf>
    return -1;
80102206:	83 c4 10             	add    $0x10,%esp
80102209:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010220e:	e9 19 fd ff ff       	jmp    80101f2c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80102213:	be 00 20 00 00       	mov    $0x2000,%esi
80102218:	31 ff                	xor    %edi,%edi
8010221a:	e9 39 fe ff ff       	jmp    80102058 <exec+0x198>
8010221f:	90                   	nop

80102220 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80102220:	55                   	push   %ebp
80102221:	89 e5                	mov    %esp,%ebp
80102223:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80102226:	68 00 93 10 80       	push   $0x80109300
8010222b:	68 e0 16 11 80       	push   $0x801116e0
80102230:	e8 4b 3d 00 00       	call   80105f80 <initlock>
}
80102235:	83 c4 10             	add    $0x10,%esp
80102238:	c9                   	leave  
80102239:	c3                   	ret    
8010223a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102240 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80102244:	bb 14 17 11 80       	mov    $0x80111714,%ebx
{
80102249:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
8010224c:	68 e0 16 11 80       	push   $0x801116e0
80102251:	e8 fa 3e 00 00       	call   80106150 <acquire>
80102256:	83 c4 10             	add    $0x10,%esp
80102259:	eb 10                	jmp    8010226b <filealloc+0x2b>
8010225b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010225f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80102260:	83 c3 18             	add    $0x18,%ebx
80102263:	81 fb 74 20 11 80    	cmp    $0x80112074,%ebx
80102269:	74 25                	je     80102290 <filealloc+0x50>
    if(f->ref == 0){
8010226b:	8b 43 04             	mov    0x4(%ebx),%eax
8010226e:	85 c0                	test   %eax,%eax
80102270:	75 ee                	jne    80102260 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80102272:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80102275:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010227c:	68 e0 16 11 80       	push   $0x801116e0
80102281:	e8 6a 3e 00 00       	call   801060f0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80102286:	89 d8                	mov    %ebx,%eax
      return f;
80102288:	83 c4 10             	add    $0x10,%esp
}
8010228b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010228e:	c9                   	leave  
8010228f:	c3                   	ret    
  release(&ftable.lock);
80102290:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80102293:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80102295:	68 e0 16 11 80       	push   $0x801116e0
8010229a:	e8 51 3e 00 00       	call   801060f0 <release>
}
8010229f:	89 d8                	mov    %ebx,%eax
  return 0;
801022a1:	83 c4 10             	add    $0x10,%esp
}
801022a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801022a7:	c9                   	leave  
801022a8:	c3                   	ret    
801022a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801022b0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801022b0:	55                   	push   %ebp
801022b1:	89 e5                	mov    %esp,%ebp
801022b3:	53                   	push   %ebx
801022b4:	83 ec 10             	sub    $0x10,%esp
801022b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
801022ba:	68 e0 16 11 80       	push   $0x801116e0
801022bf:	e8 8c 3e 00 00       	call   80106150 <acquire>
  if(f->ref < 1)
801022c4:	8b 43 04             	mov    0x4(%ebx),%eax
801022c7:	83 c4 10             	add    $0x10,%esp
801022ca:	85 c0                	test   %eax,%eax
801022cc:	7e 1a                	jle    801022e8 <filedup+0x38>
    panic("filedup");
  f->ref++;
801022ce:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
801022d1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
801022d4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
801022d7:	68 e0 16 11 80       	push   $0x801116e0
801022dc:	e8 0f 3e 00 00       	call   801060f0 <release>
  return f;
}
801022e1:	89 d8                	mov    %ebx,%eax
801022e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801022e6:	c9                   	leave  
801022e7:	c3                   	ret    
    panic("filedup");
801022e8:	83 ec 0c             	sub    $0xc,%esp
801022eb:	68 07 93 10 80       	push   $0x80109307
801022f0:	e8 8b e0 ff ff       	call   80100380 <panic>
801022f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102300 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80102300:	55                   	push   %ebp
80102301:	89 e5                	mov    %esp,%ebp
80102303:	57                   	push   %edi
80102304:	56                   	push   %esi
80102305:	53                   	push   %ebx
80102306:	83 ec 28             	sub    $0x28,%esp
80102309:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010230c:	68 e0 16 11 80       	push   $0x801116e0
80102311:	e8 3a 3e 00 00       	call   80106150 <acquire>
  if(f->ref < 1)
80102316:	8b 53 04             	mov    0x4(%ebx),%edx
80102319:	83 c4 10             	add    $0x10,%esp
8010231c:	85 d2                	test   %edx,%edx
8010231e:	0f 8e a5 00 00 00    	jle    801023c9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80102324:	83 ea 01             	sub    $0x1,%edx
80102327:	89 53 04             	mov    %edx,0x4(%ebx)
8010232a:	75 44                	jne    80102370 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010232c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80102330:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80102333:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80102335:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010233b:	8b 73 0c             	mov    0xc(%ebx),%esi
8010233e:	88 45 e7             	mov    %al,-0x19(%ebp)
80102341:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80102344:	68 e0 16 11 80       	push   $0x801116e0
  ff = *f;
80102349:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
8010234c:	e8 9f 3d 00 00       	call   801060f0 <release>

  if(ff.type == FD_PIPE)
80102351:	83 c4 10             	add    $0x10,%esp
80102354:	83 ff 01             	cmp    $0x1,%edi
80102357:	74 57                	je     801023b0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80102359:	83 ff 02             	cmp    $0x2,%edi
8010235c:	74 2a                	je     80102388 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010235e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102361:	5b                   	pop    %ebx
80102362:	5e                   	pop    %esi
80102363:	5f                   	pop    %edi
80102364:	5d                   	pop    %ebp
80102365:	c3                   	ret    
80102366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010236d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80102370:	c7 45 08 e0 16 11 80 	movl   $0x801116e0,0x8(%ebp)
}
80102377:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010237a:	5b                   	pop    %ebx
8010237b:	5e                   	pop    %esi
8010237c:	5f                   	pop    %edi
8010237d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010237e:	e9 6d 3d 00 00       	jmp    801060f0 <release>
80102383:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102387:	90                   	nop
    begin_op();
80102388:	e8 e3 1d 00 00       	call   80104170 <begin_op>
    iput(ff.ip);
8010238d:	83 ec 0c             	sub    $0xc,%esp
80102390:	ff 75 e0             	push   -0x20(%ebp)
80102393:	e8 28 09 00 00       	call   80102cc0 <iput>
    end_op();
80102398:	83 c4 10             	add    $0x10,%esp
}
8010239b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010239e:	5b                   	pop    %ebx
8010239f:	5e                   	pop    %esi
801023a0:	5f                   	pop    %edi
801023a1:	5d                   	pop    %ebp
    end_op();
801023a2:	e9 39 1e 00 00       	jmp    801041e0 <end_op>
801023a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023ae:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
801023b0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801023b4:	83 ec 08             	sub    $0x8,%esp
801023b7:	53                   	push   %ebx
801023b8:	56                   	push   %esi
801023b9:	e8 82 25 00 00       	call   80104940 <pipeclose>
801023be:	83 c4 10             	add    $0x10,%esp
}
801023c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023c4:	5b                   	pop    %ebx
801023c5:	5e                   	pop    %esi
801023c6:	5f                   	pop    %edi
801023c7:	5d                   	pop    %ebp
801023c8:	c3                   	ret    
    panic("fileclose");
801023c9:	83 ec 0c             	sub    $0xc,%esp
801023cc:	68 0f 93 10 80       	push   $0x8010930f
801023d1:	e8 aa df ff ff       	call   80100380 <panic>
801023d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023dd:	8d 76 00             	lea    0x0(%esi),%esi

801023e0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	53                   	push   %ebx
801023e4:	83 ec 04             	sub    $0x4,%esp
801023e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801023ea:	83 3b 02             	cmpl   $0x2,(%ebx)
801023ed:	75 31                	jne    80102420 <filestat+0x40>
    ilock(f->ip);
801023ef:	83 ec 0c             	sub    $0xc,%esp
801023f2:	ff 73 10             	push   0x10(%ebx)
801023f5:	e8 96 07 00 00       	call   80102b90 <ilock>
    stati(f->ip, st);
801023fa:	58                   	pop    %eax
801023fb:	5a                   	pop    %edx
801023fc:	ff 75 0c             	push   0xc(%ebp)
801023ff:	ff 73 10             	push   0x10(%ebx)
80102402:	e8 69 0a 00 00       	call   80102e70 <stati>
    iunlock(f->ip);
80102407:	59                   	pop    %ecx
80102408:	ff 73 10             	push   0x10(%ebx)
8010240b:	e8 60 08 00 00       	call   80102c70 <iunlock>
    return 0;
  }
  return -1;
}
80102410:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80102413:	83 c4 10             	add    $0x10,%esp
80102416:	31 c0                	xor    %eax,%eax
}
80102418:	c9                   	leave  
80102419:	c3                   	ret    
8010241a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102420:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80102423:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102428:	c9                   	leave  
80102429:	c3                   	ret    
8010242a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102430 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	57                   	push   %edi
80102434:	56                   	push   %esi
80102435:	53                   	push   %ebx
80102436:	83 ec 0c             	sub    $0xc,%esp
80102439:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010243c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010243f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80102442:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80102446:	74 60                	je     801024a8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80102448:	8b 03                	mov    (%ebx),%eax
8010244a:	83 f8 01             	cmp    $0x1,%eax
8010244d:	74 41                	je     80102490 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010244f:	83 f8 02             	cmp    $0x2,%eax
80102452:	75 5b                	jne    801024af <fileread+0x7f>
    ilock(f->ip);
80102454:	83 ec 0c             	sub    $0xc,%esp
80102457:	ff 73 10             	push   0x10(%ebx)
8010245a:	e8 31 07 00 00       	call   80102b90 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010245f:	57                   	push   %edi
80102460:	ff 73 14             	push   0x14(%ebx)
80102463:	56                   	push   %esi
80102464:	ff 73 10             	push   0x10(%ebx)
80102467:	e8 34 0a 00 00       	call   80102ea0 <readi>
8010246c:	83 c4 20             	add    $0x20,%esp
8010246f:	89 c6                	mov    %eax,%esi
80102471:	85 c0                	test   %eax,%eax
80102473:	7e 03                	jle    80102478 <fileread+0x48>
      f->off += r;
80102475:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80102478:	83 ec 0c             	sub    $0xc,%esp
8010247b:	ff 73 10             	push   0x10(%ebx)
8010247e:	e8 ed 07 00 00       	call   80102c70 <iunlock>
    return r;
80102483:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80102486:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102489:	89 f0                	mov    %esi,%eax
8010248b:	5b                   	pop    %ebx
8010248c:	5e                   	pop    %esi
8010248d:	5f                   	pop    %edi
8010248e:	5d                   	pop    %ebp
8010248f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80102490:	8b 43 0c             	mov    0xc(%ebx),%eax
80102493:	89 45 08             	mov    %eax,0x8(%ebp)
}
80102496:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102499:	5b                   	pop    %ebx
8010249a:	5e                   	pop    %esi
8010249b:	5f                   	pop    %edi
8010249c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010249d:	e9 3e 26 00 00       	jmp    80104ae0 <piperead>
801024a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801024a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801024ad:	eb d7                	jmp    80102486 <fileread+0x56>
  panic("fileread");
801024af:	83 ec 0c             	sub    $0xc,%esp
801024b2:	68 19 93 10 80       	push   $0x80109319
801024b7:	e8 c4 de ff ff       	call   80100380 <panic>
801024bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801024c0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	57                   	push   %edi
801024c4:	56                   	push   %esi
801024c5:	53                   	push   %ebx
801024c6:	83 ec 1c             	sub    $0x1c,%esp
801024c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801024cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801024cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801024d2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801024d5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801024d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801024dc:	0f 84 bd 00 00 00    	je     8010259f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801024e2:	8b 03                	mov    (%ebx),%eax
801024e4:	83 f8 01             	cmp    $0x1,%eax
801024e7:	0f 84 bf 00 00 00    	je     801025ac <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801024ed:	83 f8 02             	cmp    $0x2,%eax
801024f0:	0f 85 c8 00 00 00    	jne    801025be <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801024f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801024f9:	31 f6                	xor    %esi,%esi
    while(i < n){
801024fb:	85 c0                	test   %eax,%eax
801024fd:	7f 30                	jg     8010252f <filewrite+0x6f>
801024ff:	e9 94 00 00 00       	jmp    80102598 <filewrite+0xd8>
80102504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80102508:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010250b:	83 ec 0c             	sub    $0xc,%esp
8010250e:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80102511:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80102514:	e8 57 07 00 00       	call   80102c70 <iunlock>
      end_op();
80102519:	e8 c2 1c 00 00       	call   801041e0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010251e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102521:	83 c4 10             	add    $0x10,%esp
80102524:	39 c7                	cmp    %eax,%edi
80102526:	75 5c                	jne    80102584 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80102528:	01 fe                	add    %edi,%esi
    while(i < n){
8010252a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010252d:	7e 69                	jle    80102598 <filewrite+0xd8>
      int n1 = n - i;
8010252f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80102532:	b8 00 06 00 00       	mov    $0x600,%eax
80102537:	29 f7                	sub    %esi,%edi
80102539:	39 c7                	cmp    %eax,%edi
8010253b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010253e:	e8 2d 1c 00 00       	call   80104170 <begin_op>
      ilock(f->ip);
80102543:	83 ec 0c             	sub    $0xc,%esp
80102546:	ff 73 10             	push   0x10(%ebx)
80102549:	e8 42 06 00 00       	call   80102b90 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010254e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102551:	57                   	push   %edi
80102552:	ff 73 14             	push   0x14(%ebx)
80102555:	01 f0                	add    %esi,%eax
80102557:	50                   	push   %eax
80102558:	ff 73 10             	push   0x10(%ebx)
8010255b:	e8 40 0a 00 00       	call   80102fa0 <writei>
80102560:	83 c4 20             	add    $0x20,%esp
80102563:	85 c0                	test   %eax,%eax
80102565:	7f a1                	jg     80102508 <filewrite+0x48>
      iunlock(f->ip);
80102567:	83 ec 0c             	sub    $0xc,%esp
8010256a:	ff 73 10             	push   0x10(%ebx)
8010256d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102570:	e8 fb 06 00 00       	call   80102c70 <iunlock>
      end_op();
80102575:	e8 66 1c 00 00       	call   801041e0 <end_op>
      if(r < 0)
8010257a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010257d:	83 c4 10             	add    $0x10,%esp
80102580:	85 c0                	test   %eax,%eax
80102582:	75 1b                	jne    8010259f <filewrite+0xdf>
        panic("short filewrite");
80102584:	83 ec 0c             	sub    $0xc,%esp
80102587:	68 22 93 10 80       	push   $0x80109322
8010258c:	e8 ef dd ff ff       	call   80100380 <panic>
80102591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80102598:	89 f0                	mov    %esi,%eax
8010259a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010259d:	74 05                	je     801025a4 <filewrite+0xe4>
8010259f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801025a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025a7:	5b                   	pop    %ebx
801025a8:	5e                   	pop    %esi
801025a9:	5f                   	pop    %edi
801025aa:	5d                   	pop    %ebp
801025ab:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801025ac:	8b 43 0c             	mov    0xc(%ebx),%eax
801025af:	89 45 08             	mov    %eax,0x8(%ebp)
}
801025b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025b5:	5b                   	pop    %ebx
801025b6:	5e                   	pop    %esi
801025b7:	5f                   	pop    %edi
801025b8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801025b9:	e9 22 24 00 00       	jmp    801049e0 <pipewrite>
  panic("filewrite");
801025be:	83 ec 0c             	sub    $0xc,%esp
801025c1:	68 28 93 10 80       	push   $0x80109328
801025c6:	e8 b5 dd ff ff       	call   80100380 <panic>
801025cb:	66 90                	xchg   %ax,%ax
801025cd:	66 90                	xchg   %ax,%ax
801025cf:	90                   	nop

801025d0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801025d0:	55                   	push   %ebp
801025d1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801025d3:	89 d0                	mov    %edx,%eax
801025d5:	c1 e8 0c             	shr    $0xc,%eax
801025d8:	03 05 4c 3d 11 80    	add    0x80113d4c,%eax
{
801025de:	89 e5                	mov    %esp,%ebp
801025e0:	56                   	push   %esi
801025e1:	53                   	push   %ebx
801025e2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801025e4:	83 ec 08             	sub    $0x8,%esp
801025e7:	50                   	push   %eax
801025e8:	51                   	push   %ecx
801025e9:	e8 e2 da ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801025ee:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801025f0:	c1 fb 03             	sar    $0x3,%ebx
801025f3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801025f6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801025f8:	83 e1 07             	and    $0x7,%ecx
801025fb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80102600:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80102606:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80102608:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010260d:	85 c1                	test   %eax,%ecx
8010260f:	74 23                	je     80102634 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80102611:	f7 d0                	not    %eax
  log_write(bp);
80102613:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80102616:	21 c8                	and    %ecx,%eax
80102618:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010261c:	56                   	push   %esi
8010261d:	e8 2e 1d 00 00       	call   80104350 <log_write>
  brelse(bp);
80102622:	89 34 24             	mov    %esi,(%esp)
80102625:	e8 c6 db ff ff       	call   801001f0 <brelse>
}
8010262a:	83 c4 10             	add    $0x10,%esp
8010262d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102630:	5b                   	pop    %ebx
80102631:	5e                   	pop    %esi
80102632:	5d                   	pop    %ebp
80102633:	c3                   	ret    
    panic("freeing free block");
80102634:	83 ec 0c             	sub    $0xc,%esp
80102637:	68 32 93 10 80       	push   $0x80109332
8010263c:	e8 3f dd ff ff       	call   80100380 <panic>
80102641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102648:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010264f:	90                   	nop

80102650 <balloc>:
{
80102650:	55                   	push   %ebp
80102651:	89 e5                	mov    %esp,%ebp
80102653:	57                   	push   %edi
80102654:	56                   	push   %esi
80102655:	53                   	push   %ebx
80102656:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80102659:	8b 0d 34 3d 11 80    	mov    0x80113d34,%ecx
{
8010265f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80102662:	85 c9                	test   %ecx,%ecx
80102664:	0f 84 87 00 00 00    	je     801026f1 <balloc+0xa1>
8010266a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80102671:	8b 75 dc             	mov    -0x24(%ebp),%esi
80102674:	83 ec 08             	sub    $0x8,%esp
80102677:	89 f0                	mov    %esi,%eax
80102679:	c1 f8 0c             	sar    $0xc,%eax
8010267c:	03 05 4c 3d 11 80    	add    0x80113d4c,%eax
80102682:	50                   	push   %eax
80102683:	ff 75 d8             	push   -0x28(%ebp)
80102686:	e8 45 da ff ff       	call   801000d0 <bread>
8010268b:	83 c4 10             	add    $0x10,%esp
8010268e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80102691:	a1 34 3d 11 80       	mov    0x80113d34,%eax
80102696:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102699:	31 c0                	xor    %eax,%eax
8010269b:	eb 2f                	jmp    801026cc <balloc+0x7c>
8010269d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801026a0:	89 c1                	mov    %eax,%ecx
801026a2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801026a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801026aa:	83 e1 07             	and    $0x7,%ecx
801026ad:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801026af:	89 c1                	mov    %eax,%ecx
801026b1:	c1 f9 03             	sar    $0x3,%ecx
801026b4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801026b9:	89 fa                	mov    %edi,%edx
801026bb:	85 df                	test   %ebx,%edi
801026bd:	74 41                	je     80102700 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801026bf:	83 c0 01             	add    $0x1,%eax
801026c2:	83 c6 01             	add    $0x1,%esi
801026c5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801026ca:	74 05                	je     801026d1 <balloc+0x81>
801026cc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801026cf:	77 cf                	ja     801026a0 <balloc+0x50>
    brelse(bp);
801026d1:	83 ec 0c             	sub    $0xc,%esp
801026d4:	ff 75 e4             	push   -0x1c(%ebp)
801026d7:	e8 14 db ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801026dc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801026e3:	83 c4 10             	add    $0x10,%esp
801026e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801026e9:	39 05 34 3d 11 80    	cmp    %eax,0x80113d34
801026ef:	77 80                	ja     80102671 <balloc+0x21>
  panic("balloc: out of blocks");
801026f1:	83 ec 0c             	sub    $0xc,%esp
801026f4:	68 45 93 10 80       	push   $0x80109345
801026f9:	e8 82 dc ff ff       	call   80100380 <panic>
801026fe:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80102700:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80102703:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80102706:	09 da                	or     %ebx,%edx
80102708:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010270c:	57                   	push   %edi
8010270d:	e8 3e 1c 00 00       	call   80104350 <log_write>
        brelse(bp);
80102712:	89 3c 24             	mov    %edi,(%esp)
80102715:	e8 d6 da ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010271a:	58                   	pop    %eax
8010271b:	5a                   	pop    %edx
8010271c:	56                   	push   %esi
8010271d:	ff 75 d8             	push   -0x28(%ebp)
80102720:	e8 ab d9 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80102725:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80102728:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010272a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010272d:	68 00 02 00 00       	push   $0x200
80102732:	6a 00                	push   $0x0
80102734:	50                   	push   %eax
80102735:	e8 d6 3a 00 00       	call   80106210 <memset>
  log_write(bp);
8010273a:	89 1c 24             	mov    %ebx,(%esp)
8010273d:	e8 0e 1c 00 00       	call   80104350 <log_write>
  brelse(bp);
80102742:	89 1c 24             	mov    %ebx,(%esp)
80102745:	e8 a6 da ff ff       	call   801001f0 <brelse>
}
8010274a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010274d:	89 f0                	mov    %esi,%eax
8010274f:	5b                   	pop    %ebx
80102750:	5e                   	pop    %esi
80102751:	5f                   	pop    %edi
80102752:	5d                   	pop    %ebp
80102753:	c3                   	ret    
80102754:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010275b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010275f:	90                   	nop

80102760 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80102760:	55                   	push   %ebp
80102761:	89 e5                	mov    %esp,%ebp
80102763:	57                   	push   %edi
80102764:	89 c7                	mov    %eax,%edi
80102766:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80102767:	31 f6                	xor    %esi,%esi
{
80102769:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010276a:	bb 14 21 11 80       	mov    $0x80112114,%ebx
{
8010276f:	83 ec 28             	sub    $0x28,%esp
80102772:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80102775:	68 e0 20 11 80       	push   $0x801120e0
8010277a:	e8 d1 39 00 00       	call   80106150 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010277f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80102782:	83 c4 10             	add    $0x10,%esp
80102785:	eb 1b                	jmp    801027a2 <iget+0x42>
80102787:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010278e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102790:	39 3b                	cmp    %edi,(%ebx)
80102792:	74 6c                	je     80102800 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80102794:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010279a:	81 fb 34 3d 11 80    	cmp    $0x80113d34,%ebx
801027a0:	73 26                	jae    801027c8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801027a2:	8b 43 08             	mov    0x8(%ebx),%eax
801027a5:	85 c0                	test   %eax,%eax
801027a7:	7f e7                	jg     80102790 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801027a9:	85 f6                	test   %esi,%esi
801027ab:	75 e7                	jne    80102794 <iget+0x34>
801027ad:	85 c0                	test   %eax,%eax
801027af:	75 76                	jne    80102827 <iget+0xc7>
801027b1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801027b3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801027b9:	81 fb 34 3d 11 80    	cmp    $0x80113d34,%ebx
801027bf:	72 e1                	jb     801027a2 <iget+0x42>
801027c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801027c8:	85 f6                	test   %esi,%esi
801027ca:	74 79                	je     80102845 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801027cc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801027cf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801027d1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801027d4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801027db:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801027e2:	68 e0 20 11 80       	push   $0x801120e0
801027e7:	e8 04 39 00 00       	call   801060f0 <release>

  return ip;
801027ec:	83 c4 10             	add    $0x10,%esp
}
801027ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801027f2:	89 f0                	mov    %esi,%eax
801027f4:	5b                   	pop    %ebx
801027f5:	5e                   	pop    %esi
801027f6:	5f                   	pop    %edi
801027f7:	5d                   	pop    %ebp
801027f8:	c3                   	ret    
801027f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102800:	39 53 04             	cmp    %edx,0x4(%ebx)
80102803:	75 8f                	jne    80102794 <iget+0x34>
      release(&icache.lock);
80102805:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80102808:	83 c0 01             	add    $0x1,%eax
      return ip;
8010280b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010280d:	68 e0 20 11 80       	push   $0x801120e0
      ip->ref++;
80102812:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80102815:	e8 d6 38 00 00       	call   801060f0 <release>
      return ip;
8010281a:	83 c4 10             	add    $0x10,%esp
}
8010281d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102820:	89 f0                	mov    %esi,%eax
80102822:	5b                   	pop    %ebx
80102823:	5e                   	pop    %esi
80102824:	5f                   	pop    %edi
80102825:	5d                   	pop    %ebp
80102826:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80102827:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010282d:	81 fb 34 3d 11 80    	cmp    $0x80113d34,%ebx
80102833:	73 10                	jae    80102845 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102835:	8b 43 08             	mov    0x8(%ebx),%eax
80102838:	85 c0                	test   %eax,%eax
8010283a:	0f 8f 50 ff ff ff    	jg     80102790 <iget+0x30>
80102840:	e9 68 ff ff ff       	jmp    801027ad <iget+0x4d>
    panic("iget: no inodes");
80102845:	83 ec 0c             	sub    $0xc,%esp
80102848:	68 5b 93 10 80       	push   $0x8010935b
8010284d:	e8 2e db ff ff       	call   80100380 <panic>
80102852:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102860 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80102860:	55                   	push   %ebp
80102861:	89 e5                	mov    %esp,%ebp
80102863:	57                   	push   %edi
80102864:	56                   	push   %esi
80102865:	89 c6                	mov    %eax,%esi
80102867:	53                   	push   %ebx
80102868:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010286b:	83 fa 0b             	cmp    $0xb,%edx
8010286e:	0f 86 8c 00 00 00    	jbe    80102900 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80102874:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80102877:	83 fb 7f             	cmp    $0x7f,%ebx
8010287a:	0f 87 a2 00 00 00    	ja     80102922 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80102880:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80102886:	85 c0                	test   %eax,%eax
80102888:	74 5e                	je     801028e8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010288a:	83 ec 08             	sub    $0x8,%esp
8010288d:	50                   	push   %eax
8010288e:	ff 36                	push   (%esi)
80102890:	e8 3b d8 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80102895:	83 c4 10             	add    $0x10,%esp
80102898:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010289c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010289e:	8b 3b                	mov    (%ebx),%edi
801028a0:	85 ff                	test   %edi,%edi
801028a2:	74 1c                	je     801028c0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801028a4:	83 ec 0c             	sub    $0xc,%esp
801028a7:	52                   	push   %edx
801028a8:	e8 43 d9 ff ff       	call   801001f0 <brelse>
801028ad:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801028b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801028b3:	89 f8                	mov    %edi,%eax
801028b5:	5b                   	pop    %ebx
801028b6:	5e                   	pop    %esi
801028b7:	5f                   	pop    %edi
801028b8:	5d                   	pop    %ebp
801028b9:	c3                   	ret    
801028ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801028c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801028c3:	8b 06                	mov    (%esi),%eax
801028c5:	e8 86 fd ff ff       	call   80102650 <balloc>
      log_write(bp);
801028ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801028cd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801028d0:	89 03                	mov    %eax,(%ebx)
801028d2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801028d4:	52                   	push   %edx
801028d5:	e8 76 1a 00 00       	call   80104350 <log_write>
801028da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801028dd:	83 c4 10             	add    $0x10,%esp
801028e0:	eb c2                	jmp    801028a4 <bmap+0x44>
801028e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801028e8:	8b 06                	mov    (%esi),%eax
801028ea:	e8 61 fd ff ff       	call   80102650 <balloc>
801028ef:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801028f5:	eb 93                	jmp    8010288a <bmap+0x2a>
801028f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028fe:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80102900:	8d 5a 14             	lea    0x14(%edx),%ebx
80102903:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80102907:	85 ff                	test   %edi,%edi
80102909:	75 a5                	jne    801028b0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010290b:	8b 00                	mov    (%eax),%eax
8010290d:	e8 3e fd ff ff       	call   80102650 <balloc>
80102912:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80102916:	89 c7                	mov    %eax,%edi
}
80102918:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010291b:	5b                   	pop    %ebx
8010291c:	89 f8                	mov    %edi,%eax
8010291e:	5e                   	pop    %esi
8010291f:	5f                   	pop    %edi
80102920:	5d                   	pop    %ebp
80102921:	c3                   	ret    
  panic("bmap: out of range");
80102922:	83 ec 0c             	sub    $0xc,%esp
80102925:	68 6b 93 10 80       	push   $0x8010936b
8010292a:	e8 51 da ff ff       	call   80100380 <panic>
8010292f:	90                   	nop

80102930 <readsb>:
{
80102930:	55                   	push   %ebp
80102931:	89 e5                	mov    %esp,%ebp
80102933:	56                   	push   %esi
80102934:	53                   	push   %ebx
80102935:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80102938:	83 ec 08             	sub    $0x8,%esp
8010293b:	6a 01                	push   $0x1
8010293d:	ff 75 08             	push   0x8(%ebp)
80102940:	e8 8b d7 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80102945:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80102948:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010294a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010294d:	6a 1c                	push   $0x1c
8010294f:	50                   	push   %eax
80102950:	56                   	push   %esi
80102951:	e8 5a 39 00 00       	call   801062b0 <memmove>
  brelse(bp);
80102956:	89 5d 08             	mov    %ebx,0x8(%ebp)
80102959:	83 c4 10             	add    $0x10,%esp
}
8010295c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010295f:	5b                   	pop    %ebx
80102960:	5e                   	pop    %esi
80102961:	5d                   	pop    %ebp
  brelse(bp);
80102962:	e9 89 d8 ff ff       	jmp    801001f0 <brelse>
80102967:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010296e:	66 90                	xchg   %ax,%ax

80102970 <iinit>:
{
80102970:	55                   	push   %ebp
80102971:	89 e5                	mov    %esp,%ebp
80102973:	53                   	push   %ebx
80102974:	bb 20 21 11 80       	mov    $0x80112120,%ebx
80102979:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010297c:	68 7e 93 10 80       	push   $0x8010937e
80102981:	68 e0 20 11 80       	push   $0x801120e0
80102986:	e8 f5 35 00 00       	call   80105f80 <initlock>
  for(i = 0; i < NINODE; i++) {
8010298b:	83 c4 10             	add    $0x10,%esp
8010298e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80102990:	83 ec 08             	sub    $0x8,%esp
80102993:	68 85 93 10 80       	push   $0x80109385
80102998:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80102999:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010299f:	e8 ac 34 00 00       	call   80105e50 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801029a4:	83 c4 10             	add    $0x10,%esp
801029a7:	81 fb 40 3d 11 80    	cmp    $0x80113d40,%ebx
801029ad:	75 e1                	jne    80102990 <iinit+0x20>
  bp = bread(dev, 1);
801029af:	83 ec 08             	sub    $0x8,%esp
801029b2:	6a 01                	push   $0x1
801029b4:	ff 75 08             	push   0x8(%ebp)
801029b7:	e8 14 d7 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801029bc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801029bf:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801029c1:	8d 40 5c             	lea    0x5c(%eax),%eax
801029c4:	6a 1c                	push   $0x1c
801029c6:	50                   	push   %eax
801029c7:	68 34 3d 11 80       	push   $0x80113d34
801029cc:	e8 df 38 00 00       	call   801062b0 <memmove>
  brelse(bp);
801029d1:	89 1c 24             	mov    %ebx,(%esp)
801029d4:	e8 17 d8 ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801029d9:	ff 35 4c 3d 11 80    	push   0x80113d4c
801029df:	ff 35 48 3d 11 80    	push   0x80113d48
801029e5:	ff 35 44 3d 11 80    	push   0x80113d44
801029eb:	ff 35 40 3d 11 80    	push   0x80113d40
801029f1:	ff 35 3c 3d 11 80    	push   0x80113d3c
801029f7:	ff 35 38 3d 11 80    	push   0x80113d38
801029fd:	ff 35 34 3d 11 80    	push   0x80113d34
80102a03:	68 e8 93 10 80       	push   $0x801093e8
80102a08:	e8 f3 dc ff ff       	call   80100700 <cprintf>
}
80102a0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a10:	83 c4 30             	add    $0x30,%esp
80102a13:	c9                   	leave  
80102a14:	c3                   	ret    
80102a15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102a20 <ialloc>:
{
80102a20:	55                   	push   %ebp
80102a21:	89 e5                	mov    %esp,%ebp
80102a23:	57                   	push   %edi
80102a24:	56                   	push   %esi
80102a25:	53                   	push   %ebx
80102a26:	83 ec 1c             	sub    $0x1c,%esp
80102a29:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80102a2c:	83 3d 3c 3d 11 80 01 	cmpl   $0x1,0x80113d3c
{
80102a33:	8b 75 08             	mov    0x8(%ebp),%esi
80102a36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80102a39:	0f 86 91 00 00 00    	jbe    80102ad0 <ialloc+0xb0>
80102a3f:	bf 01 00 00 00       	mov    $0x1,%edi
80102a44:	eb 21                	jmp    80102a67 <ialloc+0x47>
80102a46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a4d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80102a50:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80102a53:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80102a56:	53                   	push   %ebx
80102a57:	e8 94 d7 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80102a5c:	83 c4 10             	add    $0x10,%esp
80102a5f:	3b 3d 3c 3d 11 80    	cmp    0x80113d3c,%edi
80102a65:	73 69                	jae    80102ad0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80102a67:	89 f8                	mov    %edi,%eax
80102a69:	83 ec 08             	sub    $0x8,%esp
80102a6c:	c1 e8 03             	shr    $0x3,%eax
80102a6f:	03 05 48 3d 11 80    	add    0x80113d48,%eax
80102a75:	50                   	push   %eax
80102a76:	56                   	push   %esi
80102a77:	e8 54 d6 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80102a7c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80102a7f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80102a81:	89 f8                	mov    %edi,%eax
80102a83:	83 e0 07             	and    $0x7,%eax
80102a86:	c1 e0 06             	shl    $0x6,%eax
80102a89:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80102a8d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80102a91:	75 bd                	jne    80102a50 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80102a93:	83 ec 04             	sub    $0x4,%esp
80102a96:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80102a99:	6a 40                	push   $0x40
80102a9b:	6a 00                	push   $0x0
80102a9d:	51                   	push   %ecx
80102a9e:	e8 6d 37 00 00       	call   80106210 <memset>
      dip->type = type;
80102aa3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80102aa7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80102aaa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80102aad:	89 1c 24             	mov    %ebx,(%esp)
80102ab0:	e8 9b 18 00 00       	call   80104350 <log_write>
      brelse(bp);
80102ab5:	89 1c 24             	mov    %ebx,(%esp)
80102ab8:	e8 33 d7 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80102abd:	83 c4 10             	add    $0x10,%esp
}
80102ac0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80102ac3:	89 fa                	mov    %edi,%edx
}
80102ac5:	5b                   	pop    %ebx
      return iget(dev, inum);
80102ac6:	89 f0                	mov    %esi,%eax
}
80102ac8:	5e                   	pop    %esi
80102ac9:	5f                   	pop    %edi
80102aca:	5d                   	pop    %ebp
      return iget(dev, inum);
80102acb:	e9 90 fc ff ff       	jmp    80102760 <iget>
  panic("ialloc: no inodes");
80102ad0:	83 ec 0c             	sub    $0xc,%esp
80102ad3:	68 8b 93 10 80       	push   $0x8010938b
80102ad8:	e8 a3 d8 ff ff       	call   80100380 <panic>
80102add:	8d 76 00             	lea    0x0(%esi),%esi

80102ae0 <iupdate>:
{
80102ae0:	55                   	push   %ebp
80102ae1:	89 e5                	mov    %esp,%ebp
80102ae3:	56                   	push   %esi
80102ae4:	53                   	push   %ebx
80102ae5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102ae8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102aeb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102aee:	83 ec 08             	sub    $0x8,%esp
80102af1:	c1 e8 03             	shr    $0x3,%eax
80102af4:	03 05 48 3d 11 80    	add    0x80113d48,%eax
80102afa:	50                   	push   %eax
80102afb:	ff 73 a4             	push   -0x5c(%ebx)
80102afe:	e8 cd d5 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80102b03:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102b07:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102b0a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80102b0c:	8b 43 a8             	mov    -0x58(%ebx),%eax
80102b0f:	83 e0 07             	and    $0x7,%eax
80102b12:	c1 e0 06             	shl    $0x6,%eax
80102b15:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80102b19:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80102b1c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102b20:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80102b23:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80102b27:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80102b2b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80102b2f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80102b33:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80102b37:	8b 53 fc             	mov    -0x4(%ebx),%edx
80102b3a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102b3d:	6a 34                	push   $0x34
80102b3f:	53                   	push   %ebx
80102b40:	50                   	push   %eax
80102b41:	e8 6a 37 00 00       	call   801062b0 <memmove>
  log_write(bp);
80102b46:	89 34 24             	mov    %esi,(%esp)
80102b49:	e8 02 18 00 00       	call   80104350 <log_write>
  brelse(bp);
80102b4e:	89 75 08             	mov    %esi,0x8(%ebp)
80102b51:	83 c4 10             	add    $0x10,%esp
}
80102b54:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b57:	5b                   	pop    %ebx
80102b58:	5e                   	pop    %esi
80102b59:	5d                   	pop    %ebp
  brelse(bp);
80102b5a:	e9 91 d6 ff ff       	jmp    801001f0 <brelse>
80102b5f:	90                   	nop

80102b60 <idup>:
{
80102b60:	55                   	push   %ebp
80102b61:	89 e5                	mov    %esp,%ebp
80102b63:	53                   	push   %ebx
80102b64:	83 ec 10             	sub    $0x10,%esp
80102b67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80102b6a:	68 e0 20 11 80       	push   $0x801120e0
80102b6f:	e8 dc 35 00 00       	call   80106150 <acquire>
  ip->ref++;
80102b74:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80102b78:	c7 04 24 e0 20 11 80 	movl   $0x801120e0,(%esp)
80102b7f:	e8 6c 35 00 00       	call   801060f0 <release>
}
80102b84:	89 d8                	mov    %ebx,%eax
80102b86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b89:	c9                   	leave  
80102b8a:	c3                   	ret    
80102b8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b8f:	90                   	nop

80102b90 <ilock>:
{
80102b90:	55                   	push   %ebp
80102b91:	89 e5                	mov    %esp,%ebp
80102b93:	56                   	push   %esi
80102b94:	53                   	push   %ebx
80102b95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80102b98:	85 db                	test   %ebx,%ebx
80102b9a:	0f 84 b7 00 00 00    	je     80102c57 <ilock+0xc7>
80102ba0:	8b 53 08             	mov    0x8(%ebx),%edx
80102ba3:	85 d2                	test   %edx,%edx
80102ba5:	0f 8e ac 00 00 00    	jle    80102c57 <ilock+0xc7>
  acquiresleep(&ip->lock);
80102bab:	83 ec 0c             	sub    $0xc,%esp
80102bae:	8d 43 0c             	lea    0xc(%ebx),%eax
80102bb1:	50                   	push   %eax
80102bb2:	e8 d9 32 00 00       	call   80105e90 <acquiresleep>
  if(ip->valid == 0){
80102bb7:	8b 43 4c             	mov    0x4c(%ebx),%eax
80102bba:	83 c4 10             	add    $0x10,%esp
80102bbd:	85 c0                	test   %eax,%eax
80102bbf:	74 0f                	je     80102bd0 <ilock+0x40>
}
80102bc1:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102bc4:	5b                   	pop    %ebx
80102bc5:	5e                   	pop    %esi
80102bc6:	5d                   	pop    %ebp
80102bc7:	c3                   	ret    
80102bc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bcf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102bd0:	8b 43 04             	mov    0x4(%ebx),%eax
80102bd3:	83 ec 08             	sub    $0x8,%esp
80102bd6:	c1 e8 03             	shr    $0x3,%eax
80102bd9:	03 05 48 3d 11 80    	add    0x80113d48,%eax
80102bdf:	50                   	push   %eax
80102be0:	ff 33                	push   (%ebx)
80102be2:	e8 e9 d4 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102be7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102bea:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80102bec:	8b 43 04             	mov    0x4(%ebx),%eax
80102bef:	83 e0 07             	and    $0x7,%eax
80102bf2:	c1 e0 06             	shl    $0x6,%eax
80102bf5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80102bf9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102bfc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80102bff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80102c03:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80102c07:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80102c0b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80102c0f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80102c13:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80102c17:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80102c1b:	8b 50 fc             	mov    -0x4(%eax),%edx
80102c1e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102c21:	6a 34                	push   $0x34
80102c23:	50                   	push   %eax
80102c24:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c27:	50                   	push   %eax
80102c28:	e8 83 36 00 00       	call   801062b0 <memmove>
    brelse(bp);
80102c2d:	89 34 24             	mov    %esi,(%esp)
80102c30:	e8 bb d5 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80102c35:	83 c4 10             	add    $0x10,%esp
80102c38:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80102c3d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80102c44:	0f 85 77 ff ff ff    	jne    80102bc1 <ilock+0x31>
      panic("ilock: no type");
80102c4a:	83 ec 0c             	sub    $0xc,%esp
80102c4d:	68 a3 93 10 80       	push   $0x801093a3
80102c52:	e8 29 d7 ff ff       	call   80100380 <panic>
    panic("ilock");
80102c57:	83 ec 0c             	sub    $0xc,%esp
80102c5a:	68 9d 93 10 80       	push   $0x8010939d
80102c5f:	e8 1c d7 ff ff       	call   80100380 <panic>
80102c64:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c6f:	90                   	nop

80102c70 <iunlock>:
{
80102c70:	55                   	push   %ebp
80102c71:	89 e5                	mov    %esp,%ebp
80102c73:	56                   	push   %esi
80102c74:	53                   	push   %ebx
80102c75:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102c78:	85 db                	test   %ebx,%ebx
80102c7a:	74 28                	je     80102ca4 <iunlock+0x34>
80102c7c:	83 ec 0c             	sub    $0xc,%esp
80102c7f:	8d 73 0c             	lea    0xc(%ebx),%esi
80102c82:	56                   	push   %esi
80102c83:	e8 a8 32 00 00       	call   80105f30 <holdingsleep>
80102c88:	83 c4 10             	add    $0x10,%esp
80102c8b:	85 c0                	test   %eax,%eax
80102c8d:	74 15                	je     80102ca4 <iunlock+0x34>
80102c8f:	8b 43 08             	mov    0x8(%ebx),%eax
80102c92:	85 c0                	test   %eax,%eax
80102c94:	7e 0e                	jle    80102ca4 <iunlock+0x34>
  releasesleep(&ip->lock);
80102c96:	89 75 08             	mov    %esi,0x8(%ebp)
}
80102c99:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c9c:	5b                   	pop    %ebx
80102c9d:	5e                   	pop    %esi
80102c9e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80102c9f:	e9 4c 32 00 00       	jmp    80105ef0 <releasesleep>
    panic("iunlock");
80102ca4:	83 ec 0c             	sub    $0xc,%esp
80102ca7:	68 b2 93 10 80       	push   $0x801093b2
80102cac:	e8 cf d6 ff ff       	call   80100380 <panic>
80102cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cbf:	90                   	nop

80102cc0 <iput>:
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	57                   	push   %edi
80102cc4:	56                   	push   %esi
80102cc5:	53                   	push   %ebx
80102cc6:	83 ec 28             	sub    $0x28,%esp
80102cc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80102ccc:	8d 7b 0c             	lea    0xc(%ebx),%edi
80102ccf:	57                   	push   %edi
80102cd0:	e8 bb 31 00 00       	call   80105e90 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80102cd5:	8b 53 4c             	mov    0x4c(%ebx),%edx
80102cd8:	83 c4 10             	add    $0x10,%esp
80102cdb:	85 d2                	test   %edx,%edx
80102cdd:	74 07                	je     80102ce6 <iput+0x26>
80102cdf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80102ce4:	74 32                	je     80102d18 <iput+0x58>
  releasesleep(&ip->lock);
80102ce6:	83 ec 0c             	sub    $0xc,%esp
80102ce9:	57                   	push   %edi
80102cea:	e8 01 32 00 00       	call   80105ef0 <releasesleep>
  acquire(&icache.lock);
80102cef:	c7 04 24 e0 20 11 80 	movl   $0x801120e0,(%esp)
80102cf6:	e8 55 34 00 00       	call   80106150 <acquire>
  ip->ref--;
80102cfb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80102cff:	83 c4 10             	add    $0x10,%esp
80102d02:	c7 45 08 e0 20 11 80 	movl   $0x801120e0,0x8(%ebp)
}
80102d09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d0c:	5b                   	pop    %ebx
80102d0d:	5e                   	pop    %esi
80102d0e:	5f                   	pop    %edi
80102d0f:	5d                   	pop    %ebp
  release(&icache.lock);
80102d10:	e9 db 33 00 00       	jmp    801060f0 <release>
80102d15:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80102d18:	83 ec 0c             	sub    $0xc,%esp
80102d1b:	68 e0 20 11 80       	push   $0x801120e0
80102d20:	e8 2b 34 00 00       	call   80106150 <acquire>
    int r = ip->ref;
80102d25:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80102d28:	c7 04 24 e0 20 11 80 	movl   $0x801120e0,(%esp)
80102d2f:	e8 bc 33 00 00       	call   801060f0 <release>
    if(r == 1){
80102d34:	83 c4 10             	add    $0x10,%esp
80102d37:	83 fe 01             	cmp    $0x1,%esi
80102d3a:	75 aa                	jne    80102ce6 <iput+0x26>
80102d3c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80102d42:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80102d45:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102d48:	89 cf                	mov    %ecx,%edi
80102d4a:	eb 0b                	jmp    80102d57 <iput+0x97>
80102d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80102d50:	83 c6 04             	add    $0x4,%esi
80102d53:	39 fe                	cmp    %edi,%esi
80102d55:	74 19                	je     80102d70 <iput+0xb0>
    if(ip->addrs[i]){
80102d57:	8b 16                	mov    (%esi),%edx
80102d59:	85 d2                	test   %edx,%edx
80102d5b:	74 f3                	je     80102d50 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80102d5d:	8b 03                	mov    (%ebx),%eax
80102d5f:	e8 6c f8 ff ff       	call   801025d0 <bfree>
      ip->addrs[i] = 0;
80102d64:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102d6a:	eb e4                	jmp    80102d50 <iput+0x90>
80102d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80102d70:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80102d76:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80102d79:	85 c0                	test   %eax,%eax
80102d7b:	75 2d                	jne    80102daa <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80102d7d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80102d80:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80102d87:	53                   	push   %ebx
80102d88:	e8 53 fd ff ff       	call   80102ae0 <iupdate>
      ip->type = 0;
80102d8d:	31 c0                	xor    %eax,%eax
80102d8f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80102d93:	89 1c 24             	mov    %ebx,(%esp)
80102d96:	e8 45 fd ff ff       	call   80102ae0 <iupdate>
      ip->valid = 0;
80102d9b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80102da2:	83 c4 10             	add    $0x10,%esp
80102da5:	e9 3c ff ff ff       	jmp    80102ce6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80102daa:	83 ec 08             	sub    $0x8,%esp
80102dad:	50                   	push   %eax
80102dae:	ff 33                	push   (%ebx)
80102db0:	e8 1b d3 ff ff       	call   801000d0 <bread>
80102db5:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102db8:	83 c4 10             	add    $0x10,%esp
80102dbb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80102dc1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80102dc4:	8d 70 5c             	lea    0x5c(%eax),%esi
80102dc7:	89 cf                	mov    %ecx,%edi
80102dc9:	eb 0c                	jmp    80102dd7 <iput+0x117>
80102dcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102dcf:	90                   	nop
80102dd0:	83 c6 04             	add    $0x4,%esi
80102dd3:	39 f7                	cmp    %esi,%edi
80102dd5:	74 0f                	je     80102de6 <iput+0x126>
      if(a[j])
80102dd7:	8b 16                	mov    (%esi),%edx
80102dd9:	85 d2                	test   %edx,%edx
80102ddb:	74 f3                	je     80102dd0 <iput+0x110>
        bfree(ip->dev, a[j]);
80102ddd:	8b 03                	mov    (%ebx),%eax
80102ddf:	e8 ec f7 ff ff       	call   801025d0 <bfree>
80102de4:	eb ea                	jmp    80102dd0 <iput+0x110>
    brelse(bp);
80102de6:	83 ec 0c             	sub    $0xc,%esp
80102de9:	ff 75 e4             	push   -0x1c(%ebp)
80102dec:	8b 7d e0             	mov    -0x20(%ebp),%edi
80102def:	e8 fc d3 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80102df4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80102dfa:	8b 03                	mov    (%ebx),%eax
80102dfc:	e8 cf f7 ff ff       	call   801025d0 <bfree>
    ip->addrs[NDIRECT] = 0;
80102e01:	83 c4 10             	add    $0x10,%esp
80102e04:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80102e0b:	00 00 00 
80102e0e:	e9 6a ff ff ff       	jmp    80102d7d <iput+0xbd>
80102e13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102e20 <iunlockput>:
{
80102e20:	55                   	push   %ebp
80102e21:	89 e5                	mov    %esp,%ebp
80102e23:	56                   	push   %esi
80102e24:	53                   	push   %ebx
80102e25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102e28:	85 db                	test   %ebx,%ebx
80102e2a:	74 34                	je     80102e60 <iunlockput+0x40>
80102e2c:	83 ec 0c             	sub    $0xc,%esp
80102e2f:	8d 73 0c             	lea    0xc(%ebx),%esi
80102e32:	56                   	push   %esi
80102e33:	e8 f8 30 00 00       	call   80105f30 <holdingsleep>
80102e38:	83 c4 10             	add    $0x10,%esp
80102e3b:	85 c0                	test   %eax,%eax
80102e3d:	74 21                	je     80102e60 <iunlockput+0x40>
80102e3f:	8b 43 08             	mov    0x8(%ebx),%eax
80102e42:	85 c0                	test   %eax,%eax
80102e44:	7e 1a                	jle    80102e60 <iunlockput+0x40>
  releasesleep(&ip->lock);
80102e46:	83 ec 0c             	sub    $0xc,%esp
80102e49:	56                   	push   %esi
80102e4a:	e8 a1 30 00 00       	call   80105ef0 <releasesleep>
  iput(ip);
80102e4f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80102e52:	83 c4 10             	add    $0x10,%esp
}
80102e55:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102e58:	5b                   	pop    %ebx
80102e59:	5e                   	pop    %esi
80102e5a:	5d                   	pop    %ebp
  iput(ip);
80102e5b:	e9 60 fe ff ff       	jmp    80102cc0 <iput>
    panic("iunlock");
80102e60:	83 ec 0c             	sub    $0xc,%esp
80102e63:	68 b2 93 10 80       	push   $0x801093b2
80102e68:	e8 13 d5 ff ff       	call   80100380 <panic>
80102e6d:	8d 76 00             	lea    0x0(%esi),%esi

80102e70 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	8b 55 08             	mov    0x8(%ebp),%edx
80102e76:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80102e79:	8b 0a                	mov    (%edx),%ecx
80102e7b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80102e7e:	8b 4a 04             	mov    0x4(%edx),%ecx
80102e81:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80102e84:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80102e88:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80102e8b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80102e8f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80102e93:	8b 52 58             	mov    0x58(%edx),%edx
80102e96:	89 50 10             	mov    %edx,0x10(%eax)
}
80102e99:	5d                   	pop    %ebp
80102e9a:	c3                   	ret    
80102e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e9f:	90                   	nop

80102ea0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80102ea0:	55                   	push   %ebp
80102ea1:	89 e5                	mov    %esp,%ebp
80102ea3:	57                   	push   %edi
80102ea4:	56                   	push   %esi
80102ea5:	53                   	push   %ebx
80102ea6:	83 ec 1c             	sub    $0x1c,%esp
80102ea9:	8b 7d 0c             	mov    0xc(%ebp),%edi
80102eac:	8b 45 08             	mov    0x8(%ebp),%eax
80102eaf:	8b 75 10             	mov    0x10(%ebp),%esi
80102eb2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102eb5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102eb8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80102ebd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ec0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80102ec3:	0f 84 a7 00 00 00    	je     80102f70 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80102ec9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102ecc:	8b 40 58             	mov    0x58(%eax),%eax
80102ecf:	39 c6                	cmp    %eax,%esi
80102ed1:	0f 87 ba 00 00 00    	ja     80102f91 <readi+0xf1>
80102ed7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80102eda:	31 c9                	xor    %ecx,%ecx
80102edc:	89 da                	mov    %ebx,%edx
80102ede:	01 f2                	add    %esi,%edx
80102ee0:	0f 92 c1             	setb   %cl
80102ee3:	89 cf                	mov    %ecx,%edi
80102ee5:	0f 82 a6 00 00 00    	jb     80102f91 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80102eeb:	89 c1                	mov    %eax,%ecx
80102eed:	29 f1                	sub    %esi,%ecx
80102eef:	39 d0                	cmp    %edx,%eax
80102ef1:	0f 43 cb             	cmovae %ebx,%ecx
80102ef4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102ef7:	85 c9                	test   %ecx,%ecx
80102ef9:	74 67                	je     80102f62 <readi+0xc2>
80102efb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102eff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102f00:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80102f03:	89 f2                	mov    %esi,%edx
80102f05:	c1 ea 09             	shr    $0x9,%edx
80102f08:	89 d8                	mov    %ebx,%eax
80102f0a:	e8 51 f9 ff ff       	call   80102860 <bmap>
80102f0f:	83 ec 08             	sub    $0x8,%esp
80102f12:	50                   	push   %eax
80102f13:	ff 33                	push   (%ebx)
80102f15:	e8 b6 d1 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80102f1a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80102f1d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102f22:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80102f24:	89 f0                	mov    %esi,%eax
80102f26:	25 ff 01 00 00       	and    $0x1ff,%eax
80102f2b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80102f2d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102f30:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80102f32:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102f36:	39 d9                	cmp    %ebx,%ecx
80102f38:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80102f3b:	83 c4 0c             	add    $0xc,%esp
80102f3e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102f3f:	01 df                	add    %ebx,%edi
80102f41:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80102f43:	50                   	push   %eax
80102f44:	ff 75 e0             	push   -0x20(%ebp)
80102f47:	e8 64 33 00 00       	call   801062b0 <memmove>
    brelse(bp);
80102f4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102f4f:	89 14 24             	mov    %edx,(%esp)
80102f52:	e8 99 d2 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102f57:	01 5d e0             	add    %ebx,-0x20(%ebp)
80102f5a:	83 c4 10             	add    $0x10,%esp
80102f5d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80102f60:	77 9e                	ja     80102f00 <readi+0x60>
  }
  return n;
80102f62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80102f65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f68:	5b                   	pop    %ebx
80102f69:	5e                   	pop    %esi
80102f6a:	5f                   	pop    %edi
80102f6b:	5d                   	pop    %ebp
80102f6c:	c3                   	ret    
80102f6d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102f70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102f74:	66 83 f8 09          	cmp    $0x9,%ax
80102f78:	77 17                	ja     80102f91 <readi+0xf1>
80102f7a:	8b 04 c5 80 20 11 80 	mov    -0x7feedf80(,%eax,8),%eax
80102f81:	85 c0                	test   %eax,%eax
80102f83:	74 0c                	je     80102f91 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80102f85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102f88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f8b:	5b                   	pop    %ebx
80102f8c:	5e                   	pop    %esi
80102f8d:	5f                   	pop    %edi
80102f8e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80102f8f:	ff e0                	jmp    *%eax
      return -1;
80102f91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102f96:	eb cd                	jmp    80102f65 <readi+0xc5>
80102f98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f9f:	90                   	nop

80102fa0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102fa0:	55                   	push   %ebp
80102fa1:	89 e5                	mov    %esp,%ebp
80102fa3:	57                   	push   %edi
80102fa4:	56                   	push   %esi
80102fa5:	53                   	push   %ebx
80102fa6:	83 ec 1c             	sub    $0x1c,%esp
80102fa9:	8b 45 08             	mov    0x8(%ebp),%eax
80102fac:	8b 75 0c             	mov    0xc(%ebp),%esi
80102faf:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102fb2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80102fb7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80102fba:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102fbd:	8b 75 10             	mov    0x10(%ebp),%esi
80102fc0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80102fc3:	0f 84 b7 00 00 00    	je     80103080 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80102fc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102fcc:	3b 70 58             	cmp    0x58(%eax),%esi
80102fcf:	0f 87 e7 00 00 00    	ja     801030bc <writei+0x11c>
80102fd5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80102fd8:	31 d2                	xor    %edx,%edx
80102fda:	89 f8                	mov    %edi,%eax
80102fdc:	01 f0                	add    %esi,%eax
80102fde:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80102fe1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102fe6:	0f 87 d0 00 00 00    	ja     801030bc <writei+0x11c>
80102fec:	85 d2                	test   %edx,%edx
80102fee:	0f 85 c8 00 00 00    	jne    801030bc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102ff4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80102ffb:	85 ff                	test   %edi,%edi
80102ffd:	74 72                	je     80103071 <writei+0xd1>
80102fff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80103000:	8b 7d d8             	mov    -0x28(%ebp),%edi
80103003:	89 f2                	mov    %esi,%edx
80103005:	c1 ea 09             	shr    $0x9,%edx
80103008:	89 f8                	mov    %edi,%eax
8010300a:	e8 51 f8 ff ff       	call   80102860 <bmap>
8010300f:	83 ec 08             	sub    $0x8,%esp
80103012:	50                   	push   %eax
80103013:	ff 37                	push   (%edi)
80103015:	e8 b6 d0 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010301a:	b9 00 02 00 00       	mov    $0x200,%ecx
8010301f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80103022:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80103025:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80103027:	89 f0                	mov    %esi,%eax
80103029:	25 ff 01 00 00       	and    $0x1ff,%eax
8010302e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80103030:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80103034:	39 d9                	cmp    %ebx,%ecx
80103036:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80103039:	83 c4 0c             	add    $0xc,%esp
8010303c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010303d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
8010303f:	ff 75 dc             	push   -0x24(%ebp)
80103042:	50                   	push   %eax
80103043:	e8 68 32 00 00       	call   801062b0 <memmove>
    log_write(bp);
80103048:	89 3c 24             	mov    %edi,(%esp)
8010304b:	e8 00 13 00 00       	call   80104350 <log_write>
    brelse(bp);
80103050:	89 3c 24             	mov    %edi,(%esp)
80103053:	e8 98 d1 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80103058:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010305b:	83 c4 10             	add    $0x10,%esp
8010305e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103061:	01 5d dc             	add    %ebx,-0x24(%ebp)
80103064:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80103067:	77 97                	ja     80103000 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80103069:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010306c:	3b 70 58             	cmp    0x58(%eax),%esi
8010306f:	77 37                	ja     801030a8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80103071:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80103074:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103077:	5b                   	pop    %ebx
80103078:	5e                   	pop    %esi
80103079:	5f                   	pop    %edi
8010307a:	5d                   	pop    %ebp
8010307b:	c3                   	ret    
8010307c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80103080:	0f bf 40 52          	movswl 0x52(%eax),%eax
80103084:	66 83 f8 09          	cmp    $0x9,%ax
80103088:	77 32                	ja     801030bc <writei+0x11c>
8010308a:	8b 04 c5 84 20 11 80 	mov    -0x7feedf7c(,%eax,8),%eax
80103091:	85 c0                	test   %eax,%eax
80103093:	74 27                	je     801030bc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80103095:	89 55 10             	mov    %edx,0x10(%ebp)
}
80103098:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010309b:	5b                   	pop    %ebx
8010309c:	5e                   	pop    %esi
8010309d:	5f                   	pop    %edi
8010309e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
8010309f:	ff e0                	jmp    *%eax
801030a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
801030a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
801030ab:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
801030ae:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
801030b1:	50                   	push   %eax
801030b2:	e8 29 fa ff ff       	call   80102ae0 <iupdate>
801030b7:	83 c4 10             	add    $0x10,%esp
801030ba:	eb b5                	jmp    80103071 <writei+0xd1>
      return -1;
801030bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801030c1:	eb b1                	jmp    80103074 <writei+0xd4>
801030c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801030d0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801030d0:	55                   	push   %ebp
801030d1:	89 e5                	mov    %esp,%ebp
801030d3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
801030d6:	6a 0e                	push   $0xe
801030d8:	ff 75 0c             	push   0xc(%ebp)
801030db:	ff 75 08             	push   0x8(%ebp)
801030de:	e8 3d 32 00 00       	call   80106320 <strncmp>
}
801030e3:	c9                   	leave  
801030e4:	c3                   	ret    
801030e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801030f0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801030f0:	55                   	push   %ebp
801030f1:	89 e5                	mov    %esp,%ebp
801030f3:	57                   	push   %edi
801030f4:	56                   	push   %esi
801030f5:	53                   	push   %ebx
801030f6:	83 ec 1c             	sub    $0x1c,%esp
801030f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801030fc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80103101:	0f 85 85 00 00 00    	jne    8010318c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80103107:	8b 53 58             	mov    0x58(%ebx),%edx
8010310a:	31 ff                	xor    %edi,%edi
8010310c:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010310f:	85 d2                	test   %edx,%edx
80103111:	74 3e                	je     80103151 <dirlookup+0x61>
80103113:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103117:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80103118:	6a 10                	push   $0x10
8010311a:	57                   	push   %edi
8010311b:	56                   	push   %esi
8010311c:	53                   	push   %ebx
8010311d:	e8 7e fd ff ff       	call   80102ea0 <readi>
80103122:	83 c4 10             	add    $0x10,%esp
80103125:	83 f8 10             	cmp    $0x10,%eax
80103128:	75 55                	jne    8010317f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
8010312a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010312f:	74 18                	je     80103149 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80103131:	83 ec 04             	sub    $0x4,%esp
80103134:	8d 45 da             	lea    -0x26(%ebp),%eax
80103137:	6a 0e                	push   $0xe
80103139:	50                   	push   %eax
8010313a:	ff 75 0c             	push   0xc(%ebp)
8010313d:	e8 de 31 00 00       	call   80106320 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80103142:	83 c4 10             	add    $0x10,%esp
80103145:	85 c0                	test   %eax,%eax
80103147:	74 17                	je     80103160 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80103149:	83 c7 10             	add    $0x10,%edi
8010314c:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010314f:	72 c7                	jb     80103118 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80103151:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103154:	31 c0                	xor    %eax,%eax
}
80103156:	5b                   	pop    %ebx
80103157:	5e                   	pop    %esi
80103158:	5f                   	pop    %edi
80103159:	5d                   	pop    %ebp
8010315a:	c3                   	ret    
8010315b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010315f:	90                   	nop
      if(poff)
80103160:	8b 45 10             	mov    0x10(%ebp),%eax
80103163:	85 c0                	test   %eax,%eax
80103165:	74 05                	je     8010316c <dirlookup+0x7c>
        *poff = off;
80103167:	8b 45 10             	mov    0x10(%ebp),%eax
8010316a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
8010316c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80103170:	8b 03                	mov    (%ebx),%eax
80103172:	e8 e9 f5 ff ff       	call   80102760 <iget>
}
80103177:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010317a:	5b                   	pop    %ebx
8010317b:	5e                   	pop    %esi
8010317c:	5f                   	pop    %edi
8010317d:	5d                   	pop    %ebp
8010317e:	c3                   	ret    
      panic("dirlookup read");
8010317f:	83 ec 0c             	sub    $0xc,%esp
80103182:	68 cc 93 10 80       	push   $0x801093cc
80103187:	e8 f4 d1 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
8010318c:	83 ec 0c             	sub    $0xc,%esp
8010318f:	68 ba 93 10 80       	push   $0x801093ba
80103194:	e8 e7 d1 ff ff       	call   80100380 <panic>
80103199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801031a0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801031a0:	55                   	push   %ebp
801031a1:	89 e5                	mov    %esp,%ebp
801031a3:	57                   	push   %edi
801031a4:	56                   	push   %esi
801031a5:	53                   	push   %ebx
801031a6:	89 c3                	mov    %eax,%ebx
801031a8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
801031ab:	80 38 2f             	cmpb   $0x2f,(%eax)
{
801031ae:	89 55 dc             	mov    %edx,-0x24(%ebp)
801031b1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
801031b4:	0f 84 64 01 00 00    	je     8010331e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
801031ba:	e8 11 1e 00 00       	call   80104fd0 <myproc>
  acquire(&icache.lock);
801031bf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
801031c2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
801031c5:	68 e0 20 11 80       	push   $0x801120e0
801031ca:	e8 81 2f 00 00       	call   80106150 <acquire>
  ip->ref++;
801031cf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
801031d3:	c7 04 24 e0 20 11 80 	movl   $0x801120e0,(%esp)
801031da:	e8 11 2f 00 00       	call   801060f0 <release>
801031df:	83 c4 10             	add    $0x10,%esp
801031e2:	eb 07                	jmp    801031eb <namex+0x4b>
801031e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801031e8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801031eb:	0f b6 03             	movzbl (%ebx),%eax
801031ee:	3c 2f                	cmp    $0x2f,%al
801031f0:	74 f6                	je     801031e8 <namex+0x48>
  if(*path == 0)
801031f2:	84 c0                	test   %al,%al
801031f4:	0f 84 06 01 00 00    	je     80103300 <namex+0x160>
  while(*path != '/' && *path != 0)
801031fa:	0f b6 03             	movzbl (%ebx),%eax
801031fd:	84 c0                	test   %al,%al
801031ff:	0f 84 10 01 00 00    	je     80103315 <namex+0x175>
80103205:	89 df                	mov    %ebx,%edi
80103207:	3c 2f                	cmp    $0x2f,%al
80103209:	0f 84 06 01 00 00    	je     80103315 <namex+0x175>
8010320f:	90                   	nop
80103210:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80103214:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80103217:	3c 2f                	cmp    $0x2f,%al
80103219:	74 04                	je     8010321f <namex+0x7f>
8010321b:	84 c0                	test   %al,%al
8010321d:	75 f1                	jne    80103210 <namex+0x70>
  len = path - s;
8010321f:	89 f8                	mov    %edi,%eax
80103221:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80103223:	83 f8 0d             	cmp    $0xd,%eax
80103226:	0f 8e ac 00 00 00    	jle    801032d8 <namex+0x138>
    memmove(name, s, DIRSIZ);
8010322c:	83 ec 04             	sub    $0x4,%esp
8010322f:	6a 0e                	push   $0xe
80103231:	53                   	push   %ebx
    path++;
80103232:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80103234:	ff 75 e4             	push   -0x1c(%ebp)
80103237:	e8 74 30 00 00       	call   801062b0 <memmove>
8010323c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
8010323f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80103242:	75 0c                	jne    80103250 <namex+0xb0>
80103244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80103248:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010324b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
8010324e:	74 f8                	je     80103248 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80103250:	83 ec 0c             	sub    $0xc,%esp
80103253:	56                   	push   %esi
80103254:	e8 37 f9 ff ff       	call   80102b90 <ilock>
    if(ip->type != T_DIR){
80103259:	83 c4 10             	add    $0x10,%esp
8010325c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80103261:	0f 85 cd 00 00 00    	jne    80103334 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80103267:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010326a:	85 c0                	test   %eax,%eax
8010326c:	74 09                	je     80103277 <namex+0xd7>
8010326e:	80 3b 00             	cmpb   $0x0,(%ebx)
80103271:	0f 84 22 01 00 00    	je     80103399 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80103277:	83 ec 04             	sub    $0x4,%esp
8010327a:	6a 00                	push   $0x0
8010327c:	ff 75 e4             	push   -0x1c(%ebp)
8010327f:	56                   	push   %esi
80103280:	e8 6b fe ff ff       	call   801030f0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103285:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80103288:	83 c4 10             	add    $0x10,%esp
8010328b:	89 c7                	mov    %eax,%edi
8010328d:	85 c0                	test   %eax,%eax
8010328f:	0f 84 e1 00 00 00    	je     80103376 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103295:	83 ec 0c             	sub    $0xc,%esp
80103298:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010329b:	52                   	push   %edx
8010329c:	e8 8f 2c 00 00       	call   80105f30 <holdingsleep>
801032a1:	83 c4 10             	add    $0x10,%esp
801032a4:	85 c0                	test   %eax,%eax
801032a6:	0f 84 30 01 00 00    	je     801033dc <namex+0x23c>
801032ac:	8b 56 08             	mov    0x8(%esi),%edx
801032af:	85 d2                	test   %edx,%edx
801032b1:	0f 8e 25 01 00 00    	jle    801033dc <namex+0x23c>
  releasesleep(&ip->lock);
801032b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801032ba:	83 ec 0c             	sub    $0xc,%esp
801032bd:	52                   	push   %edx
801032be:	e8 2d 2c 00 00       	call   80105ef0 <releasesleep>
  iput(ip);
801032c3:	89 34 24             	mov    %esi,(%esp)
801032c6:	89 fe                	mov    %edi,%esi
801032c8:	e8 f3 f9 ff ff       	call   80102cc0 <iput>
801032cd:	83 c4 10             	add    $0x10,%esp
801032d0:	e9 16 ff ff ff       	jmp    801031eb <namex+0x4b>
801032d5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
801032d8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801032db:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
801032de:	83 ec 04             	sub    $0x4,%esp
801032e1:	89 55 e0             	mov    %edx,-0x20(%ebp)
801032e4:	50                   	push   %eax
801032e5:	53                   	push   %ebx
    name[len] = 0;
801032e6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
801032e8:	ff 75 e4             	push   -0x1c(%ebp)
801032eb:	e8 c0 2f 00 00       	call   801062b0 <memmove>
    name[len] = 0;
801032f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
801032f3:	83 c4 10             	add    $0x10,%esp
801032f6:	c6 02 00             	movb   $0x0,(%edx)
801032f9:	e9 41 ff ff ff       	jmp    8010323f <namex+0x9f>
801032fe:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80103300:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103303:	85 c0                	test   %eax,%eax
80103305:	0f 85 be 00 00 00    	jne    801033c9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
8010330b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010330e:	89 f0                	mov    %esi,%eax
80103310:	5b                   	pop    %ebx
80103311:	5e                   	pop    %esi
80103312:	5f                   	pop    %edi
80103313:	5d                   	pop    %ebp
80103314:	c3                   	ret    
  while(*path != '/' && *path != 0)
80103315:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103318:	89 df                	mov    %ebx,%edi
8010331a:	31 c0                	xor    %eax,%eax
8010331c:	eb c0                	jmp    801032de <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
8010331e:	ba 01 00 00 00       	mov    $0x1,%edx
80103323:	b8 01 00 00 00       	mov    $0x1,%eax
80103328:	e8 33 f4 ff ff       	call   80102760 <iget>
8010332d:	89 c6                	mov    %eax,%esi
8010332f:	e9 b7 fe ff ff       	jmp    801031eb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103334:	83 ec 0c             	sub    $0xc,%esp
80103337:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010333a:	53                   	push   %ebx
8010333b:	e8 f0 2b 00 00       	call   80105f30 <holdingsleep>
80103340:	83 c4 10             	add    $0x10,%esp
80103343:	85 c0                	test   %eax,%eax
80103345:	0f 84 91 00 00 00    	je     801033dc <namex+0x23c>
8010334b:	8b 46 08             	mov    0x8(%esi),%eax
8010334e:	85 c0                	test   %eax,%eax
80103350:	0f 8e 86 00 00 00    	jle    801033dc <namex+0x23c>
  releasesleep(&ip->lock);
80103356:	83 ec 0c             	sub    $0xc,%esp
80103359:	53                   	push   %ebx
8010335a:	e8 91 2b 00 00       	call   80105ef0 <releasesleep>
  iput(ip);
8010335f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80103362:	31 f6                	xor    %esi,%esi
  iput(ip);
80103364:	e8 57 f9 ff ff       	call   80102cc0 <iput>
      return 0;
80103369:	83 c4 10             	add    $0x10,%esp
}
8010336c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010336f:	89 f0                	mov    %esi,%eax
80103371:	5b                   	pop    %ebx
80103372:	5e                   	pop    %esi
80103373:	5f                   	pop    %edi
80103374:	5d                   	pop    %ebp
80103375:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103376:	83 ec 0c             	sub    $0xc,%esp
80103379:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010337c:	52                   	push   %edx
8010337d:	e8 ae 2b 00 00       	call   80105f30 <holdingsleep>
80103382:	83 c4 10             	add    $0x10,%esp
80103385:	85 c0                	test   %eax,%eax
80103387:	74 53                	je     801033dc <namex+0x23c>
80103389:	8b 4e 08             	mov    0x8(%esi),%ecx
8010338c:	85 c9                	test   %ecx,%ecx
8010338e:	7e 4c                	jle    801033dc <namex+0x23c>
  releasesleep(&ip->lock);
80103390:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103393:	83 ec 0c             	sub    $0xc,%esp
80103396:	52                   	push   %edx
80103397:	eb c1                	jmp    8010335a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103399:	83 ec 0c             	sub    $0xc,%esp
8010339c:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010339f:	53                   	push   %ebx
801033a0:	e8 8b 2b 00 00       	call   80105f30 <holdingsleep>
801033a5:	83 c4 10             	add    $0x10,%esp
801033a8:	85 c0                	test   %eax,%eax
801033aa:	74 30                	je     801033dc <namex+0x23c>
801033ac:	8b 7e 08             	mov    0x8(%esi),%edi
801033af:	85 ff                	test   %edi,%edi
801033b1:	7e 29                	jle    801033dc <namex+0x23c>
  releasesleep(&ip->lock);
801033b3:	83 ec 0c             	sub    $0xc,%esp
801033b6:	53                   	push   %ebx
801033b7:	e8 34 2b 00 00       	call   80105ef0 <releasesleep>
}
801033bc:	83 c4 10             	add    $0x10,%esp
}
801033bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033c2:	89 f0                	mov    %esi,%eax
801033c4:	5b                   	pop    %ebx
801033c5:	5e                   	pop    %esi
801033c6:	5f                   	pop    %edi
801033c7:	5d                   	pop    %ebp
801033c8:	c3                   	ret    
    iput(ip);
801033c9:	83 ec 0c             	sub    $0xc,%esp
801033cc:	56                   	push   %esi
    return 0;
801033cd:	31 f6                	xor    %esi,%esi
    iput(ip);
801033cf:	e8 ec f8 ff ff       	call   80102cc0 <iput>
    return 0;
801033d4:	83 c4 10             	add    $0x10,%esp
801033d7:	e9 2f ff ff ff       	jmp    8010330b <namex+0x16b>
    panic("iunlock");
801033dc:	83 ec 0c             	sub    $0xc,%esp
801033df:	68 b2 93 10 80       	push   $0x801093b2
801033e4:	e8 97 cf ff ff       	call   80100380 <panic>
801033e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801033f0 <dirlink>:
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	57                   	push   %edi
801033f4:	56                   	push   %esi
801033f5:	53                   	push   %ebx
801033f6:	83 ec 20             	sub    $0x20,%esp
801033f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801033fc:	6a 00                	push   $0x0
801033fe:	ff 75 0c             	push   0xc(%ebp)
80103401:	53                   	push   %ebx
80103402:	e8 e9 fc ff ff       	call   801030f0 <dirlookup>
80103407:	83 c4 10             	add    $0x10,%esp
8010340a:	85 c0                	test   %eax,%eax
8010340c:	75 67                	jne    80103475 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010340e:	8b 7b 58             	mov    0x58(%ebx),%edi
80103411:	8d 75 d8             	lea    -0x28(%ebp),%esi
80103414:	85 ff                	test   %edi,%edi
80103416:	74 29                	je     80103441 <dirlink+0x51>
80103418:	31 ff                	xor    %edi,%edi
8010341a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010341d:	eb 09                	jmp    80103428 <dirlink+0x38>
8010341f:	90                   	nop
80103420:	83 c7 10             	add    $0x10,%edi
80103423:	3b 7b 58             	cmp    0x58(%ebx),%edi
80103426:	73 19                	jae    80103441 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80103428:	6a 10                	push   $0x10
8010342a:	57                   	push   %edi
8010342b:	56                   	push   %esi
8010342c:	53                   	push   %ebx
8010342d:	e8 6e fa ff ff       	call   80102ea0 <readi>
80103432:	83 c4 10             	add    $0x10,%esp
80103435:	83 f8 10             	cmp    $0x10,%eax
80103438:	75 4e                	jne    80103488 <dirlink+0x98>
    if(de.inum == 0)
8010343a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010343f:	75 df                	jne    80103420 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80103441:	83 ec 04             	sub    $0x4,%esp
80103444:	8d 45 da             	lea    -0x26(%ebp),%eax
80103447:	6a 0e                	push   $0xe
80103449:	ff 75 0c             	push   0xc(%ebp)
8010344c:	50                   	push   %eax
8010344d:	e8 1e 2f 00 00       	call   80106370 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80103452:	6a 10                	push   $0x10
  de.inum = inum;
80103454:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80103457:	57                   	push   %edi
80103458:	56                   	push   %esi
80103459:	53                   	push   %ebx
  de.inum = inum;
8010345a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010345e:	e8 3d fb ff ff       	call   80102fa0 <writei>
80103463:	83 c4 20             	add    $0x20,%esp
80103466:	83 f8 10             	cmp    $0x10,%eax
80103469:	75 2a                	jne    80103495 <dirlink+0xa5>
  return 0;
8010346b:	31 c0                	xor    %eax,%eax
}
8010346d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103470:	5b                   	pop    %ebx
80103471:	5e                   	pop    %esi
80103472:	5f                   	pop    %edi
80103473:	5d                   	pop    %ebp
80103474:	c3                   	ret    
    iput(ip);
80103475:	83 ec 0c             	sub    $0xc,%esp
80103478:	50                   	push   %eax
80103479:	e8 42 f8 ff ff       	call   80102cc0 <iput>
    return -1;
8010347e:	83 c4 10             	add    $0x10,%esp
80103481:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103486:	eb e5                	jmp    8010346d <dirlink+0x7d>
      panic("dirlink read");
80103488:	83 ec 0c             	sub    $0xc,%esp
8010348b:	68 db 93 10 80       	push   $0x801093db
80103490:	e8 eb ce ff ff       	call   80100380 <panic>
    panic("dirlink");
80103495:	83 ec 0c             	sub    $0xc,%esp
80103498:	68 ba 9a 10 80       	push   $0x80109aba
8010349d:	e8 de ce ff ff       	call   80100380 <panic>
801034a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801034b0 <namei>:

struct inode*
namei(char *path)
{
801034b0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801034b1:	31 d2                	xor    %edx,%edx
{
801034b3:	89 e5                	mov    %esp,%ebp
801034b5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801034b8:	8b 45 08             	mov    0x8(%ebp),%eax
801034bb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801034be:	e8 dd fc ff ff       	call   801031a0 <namex>
}
801034c3:	c9                   	leave  
801034c4:	c3                   	ret    
801034c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801034d0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801034d0:	55                   	push   %ebp
  return namex(path, 1, name);
801034d1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801034d6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801034d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801034db:	8b 45 08             	mov    0x8(%ebp),%eax
}
801034de:	5d                   	pop    %ebp
  return namex(path, 1, name);
801034df:	e9 bc fc ff ff       	jmp    801031a0 <namex>
801034e4:	66 90                	xchg   %ax,%ax
801034e6:	66 90                	xchg   %ax,%ax
801034e8:	66 90                	xchg   %ax,%ax
801034ea:	66 90                	xchg   %ax,%ax
801034ec:	66 90                	xchg   %ax,%ax
801034ee:	66 90                	xchg   %ax,%ax

801034f0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801034f0:	55                   	push   %ebp
801034f1:	89 e5                	mov    %esp,%ebp
801034f3:	57                   	push   %edi
801034f4:	56                   	push   %esi
801034f5:	53                   	push   %ebx
801034f6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801034f9:	85 c0                	test   %eax,%eax
801034fb:	0f 84 b4 00 00 00    	je     801035b5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80103501:	8b 70 08             	mov    0x8(%eax),%esi
80103504:	89 c3                	mov    %eax,%ebx
80103506:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010350c:	0f 87 96 00 00 00    	ja     801035a8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103512:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80103517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010351e:	66 90                	xchg   %ax,%ax
80103520:	89 ca                	mov    %ecx,%edx
80103522:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80103523:	83 e0 c0             	and    $0xffffffc0,%eax
80103526:	3c 40                	cmp    $0x40,%al
80103528:	75 f6                	jne    80103520 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010352a:	31 ff                	xor    %edi,%edi
8010352c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80103531:	89 f8                	mov    %edi,%eax
80103533:	ee                   	out    %al,(%dx)
80103534:	b8 01 00 00 00       	mov    $0x1,%eax
80103539:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010353e:	ee                   	out    %al,(%dx)
8010353f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80103544:	89 f0                	mov    %esi,%eax
80103546:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80103547:	89 f0                	mov    %esi,%eax
80103549:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010354e:	c1 f8 08             	sar    $0x8,%eax
80103551:	ee                   	out    %al,(%dx)
80103552:	ba f5 01 00 00       	mov    $0x1f5,%edx
80103557:	89 f8                	mov    %edi,%eax
80103559:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010355a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010355e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80103563:	c1 e0 04             	shl    $0x4,%eax
80103566:	83 e0 10             	and    $0x10,%eax
80103569:	83 c8 e0             	or     $0xffffffe0,%eax
8010356c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010356d:	f6 03 04             	testb  $0x4,(%ebx)
80103570:	75 16                	jne    80103588 <idestart+0x98>
80103572:	b8 20 00 00 00       	mov    $0x20,%eax
80103577:	89 ca                	mov    %ecx,%edx
80103579:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010357a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010357d:	5b                   	pop    %ebx
8010357e:	5e                   	pop    %esi
8010357f:	5f                   	pop    %edi
80103580:	5d                   	pop    %ebp
80103581:	c3                   	ret    
80103582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103588:	b8 30 00 00 00       	mov    $0x30,%eax
8010358d:	89 ca                	mov    %ecx,%edx
8010358f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80103590:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80103595:	8d 73 5c             	lea    0x5c(%ebx),%esi
80103598:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010359d:	fc                   	cld    
8010359e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801035a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035a3:	5b                   	pop    %ebx
801035a4:	5e                   	pop    %esi
801035a5:	5f                   	pop    %edi
801035a6:	5d                   	pop    %ebp
801035a7:	c3                   	ret    
    panic("incorrect blockno");
801035a8:	83 ec 0c             	sub    $0xc,%esp
801035ab:	68 44 94 10 80       	push   $0x80109444
801035b0:	e8 cb cd ff ff       	call   80100380 <panic>
    panic("idestart");
801035b5:	83 ec 0c             	sub    $0xc,%esp
801035b8:	68 3b 94 10 80       	push   $0x8010943b
801035bd:	e8 be cd ff ff       	call   80100380 <panic>
801035c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801035d0 <ideinit>:
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801035d6:	68 56 94 10 80       	push   $0x80109456
801035db:	68 80 3d 11 80       	push   $0x80113d80
801035e0:	e8 9b 29 00 00       	call   80105f80 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801035e5:	58                   	pop    %eax
801035e6:	a1 04 3f 11 80       	mov    0x80113f04,%eax
801035eb:	5a                   	pop    %edx
801035ec:	83 e8 01             	sub    $0x1,%eax
801035ef:	50                   	push   %eax
801035f0:	6a 0e                	push   $0xe
801035f2:	e8 99 02 00 00       	call   80103890 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801035f7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801035fa:	ba f7 01 00 00       	mov    $0x1f7,%edx
801035ff:	90                   	nop
80103600:	ec                   	in     (%dx),%al
80103601:	83 e0 c0             	and    $0xffffffc0,%eax
80103604:	3c 40                	cmp    $0x40,%al
80103606:	75 f8                	jne    80103600 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103608:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010360d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80103612:	ee                   	out    %al,(%dx)
80103613:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103618:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010361d:	eb 06                	jmp    80103625 <ideinit+0x55>
8010361f:	90                   	nop
  for(i=0; i<1000; i++){
80103620:	83 e9 01             	sub    $0x1,%ecx
80103623:	74 0f                	je     80103634 <ideinit+0x64>
80103625:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80103626:	84 c0                	test   %al,%al
80103628:	74 f6                	je     80103620 <ideinit+0x50>
      havedisk1 = 1;
8010362a:	c7 05 60 3d 11 80 01 	movl   $0x1,0x80113d60
80103631:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103634:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80103639:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010363e:	ee                   	out    %al,(%dx)
}
8010363f:	c9                   	leave  
80103640:	c3                   	ret    
80103641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103648:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010364f:	90                   	nop

80103650 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80103650:	55                   	push   %ebp
80103651:	89 e5                	mov    %esp,%ebp
80103653:	57                   	push   %edi
80103654:	56                   	push   %esi
80103655:	53                   	push   %ebx
80103656:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80103659:	68 80 3d 11 80       	push   $0x80113d80
8010365e:	e8 ed 2a 00 00       	call   80106150 <acquire>

  if((b = idequeue) == 0){
80103663:	8b 1d 64 3d 11 80    	mov    0x80113d64,%ebx
80103669:	83 c4 10             	add    $0x10,%esp
8010366c:	85 db                	test   %ebx,%ebx
8010366e:	74 63                	je     801036d3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80103670:	8b 43 58             	mov    0x58(%ebx),%eax
80103673:	a3 64 3d 11 80       	mov    %eax,0x80113d64

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80103678:	8b 33                	mov    (%ebx),%esi
8010367a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80103680:	75 2f                	jne    801036b1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103682:	ba f7 01 00 00       	mov    $0x1f7,%edx
80103687:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010368e:	66 90                	xchg   %ax,%ax
80103690:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80103691:	89 c1                	mov    %eax,%ecx
80103693:	83 e1 c0             	and    $0xffffffc0,%ecx
80103696:	80 f9 40             	cmp    $0x40,%cl
80103699:	75 f5                	jne    80103690 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010369b:	a8 21                	test   $0x21,%al
8010369d:	75 12                	jne    801036b1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010369f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801036a2:	b9 80 00 00 00       	mov    $0x80,%ecx
801036a7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801036ac:	fc                   	cld    
801036ad:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801036af:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801036b1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801036b4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801036b7:	83 ce 02             	or     $0x2,%esi
801036ba:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801036bc:	53                   	push   %ebx
801036bd:	e8 5e 23 00 00       	call   80105a20 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801036c2:	a1 64 3d 11 80       	mov    0x80113d64,%eax
801036c7:	83 c4 10             	add    $0x10,%esp
801036ca:	85 c0                	test   %eax,%eax
801036cc:	74 05                	je     801036d3 <ideintr+0x83>
    idestart(idequeue);
801036ce:	e8 1d fe ff ff       	call   801034f0 <idestart>
    release(&idelock);
801036d3:	83 ec 0c             	sub    $0xc,%esp
801036d6:	68 80 3d 11 80       	push   $0x80113d80
801036db:	e8 10 2a 00 00       	call   801060f0 <release>

  release(&idelock);
}
801036e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036e3:	5b                   	pop    %ebx
801036e4:	5e                   	pop    %esi
801036e5:	5f                   	pop    %edi
801036e6:	5d                   	pop    %ebp
801036e7:	c3                   	ret    
801036e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036ef:	90                   	nop

801036f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	53                   	push   %ebx
801036f4:	83 ec 10             	sub    $0x10,%esp
801036f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801036fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801036fd:	50                   	push   %eax
801036fe:	e8 2d 28 00 00       	call   80105f30 <holdingsleep>
80103703:	83 c4 10             	add    $0x10,%esp
80103706:	85 c0                	test   %eax,%eax
80103708:	0f 84 c3 00 00 00    	je     801037d1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010370e:	8b 03                	mov    (%ebx),%eax
80103710:	83 e0 06             	and    $0x6,%eax
80103713:	83 f8 02             	cmp    $0x2,%eax
80103716:	0f 84 a8 00 00 00    	je     801037c4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010371c:	8b 53 04             	mov    0x4(%ebx),%edx
8010371f:	85 d2                	test   %edx,%edx
80103721:	74 0d                	je     80103730 <iderw+0x40>
80103723:	a1 60 3d 11 80       	mov    0x80113d60,%eax
80103728:	85 c0                	test   %eax,%eax
8010372a:	0f 84 87 00 00 00    	je     801037b7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80103730:	83 ec 0c             	sub    $0xc,%esp
80103733:	68 80 3d 11 80       	push   $0x80113d80
80103738:	e8 13 2a 00 00       	call   80106150 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010373d:	a1 64 3d 11 80       	mov    0x80113d64,%eax
  b->qnext = 0;
80103742:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80103749:	83 c4 10             	add    $0x10,%esp
8010374c:	85 c0                	test   %eax,%eax
8010374e:	74 60                	je     801037b0 <iderw+0xc0>
80103750:	89 c2                	mov    %eax,%edx
80103752:	8b 40 58             	mov    0x58(%eax),%eax
80103755:	85 c0                	test   %eax,%eax
80103757:	75 f7                	jne    80103750 <iderw+0x60>
80103759:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010375c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010375e:	39 1d 64 3d 11 80    	cmp    %ebx,0x80113d64
80103764:	74 3a                	je     801037a0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80103766:	8b 03                	mov    (%ebx),%eax
80103768:	83 e0 06             	and    $0x6,%eax
8010376b:	83 f8 02             	cmp    $0x2,%eax
8010376e:	74 1b                	je     8010378b <iderw+0x9b>
    sleep(b, &idelock);
80103770:	83 ec 08             	sub    $0x8,%esp
80103773:	68 80 3d 11 80       	push   $0x80113d80
80103778:	53                   	push   %ebx
80103779:	e8 e2 21 00 00       	call   80105960 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010377e:	8b 03                	mov    (%ebx),%eax
80103780:	83 c4 10             	add    $0x10,%esp
80103783:	83 e0 06             	and    $0x6,%eax
80103786:	83 f8 02             	cmp    $0x2,%eax
80103789:	75 e5                	jne    80103770 <iderw+0x80>
  }


  release(&idelock);
8010378b:	c7 45 08 80 3d 11 80 	movl   $0x80113d80,0x8(%ebp)
}
80103792:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103795:	c9                   	leave  
  release(&idelock);
80103796:	e9 55 29 00 00       	jmp    801060f0 <release>
8010379b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010379f:	90                   	nop
    idestart(b);
801037a0:	89 d8                	mov    %ebx,%eax
801037a2:	e8 49 fd ff ff       	call   801034f0 <idestart>
801037a7:	eb bd                	jmp    80103766 <iderw+0x76>
801037a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801037b0:	ba 64 3d 11 80       	mov    $0x80113d64,%edx
801037b5:	eb a5                	jmp    8010375c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801037b7:	83 ec 0c             	sub    $0xc,%esp
801037ba:	68 85 94 10 80       	push   $0x80109485
801037bf:	e8 bc cb ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801037c4:	83 ec 0c             	sub    $0xc,%esp
801037c7:	68 70 94 10 80       	push   $0x80109470
801037cc:	e8 af cb ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801037d1:	83 ec 0c             	sub    $0xc,%esp
801037d4:	68 5a 94 10 80       	push   $0x8010945a
801037d9:	e8 a2 cb ff ff       	call   80100380 <panic>
801037de:	66 90                	xchg   %ax,%ax

801037e0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801037e0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801037e1:	c7 05 b4 3d 11 80 00 	movl   $0xfec00000,0x80113db4
801037e8:	00 c0 fe 
{
801037eb:	89 e5                	mov    %esp,%ebp
801037ed:	56                   	push   %esi
801037ee:	53                   	push   %ebx
  ioapic->reg = reg;
801037ef:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801037f6:	00 00 00 
  return ioapic->data;
801037f9:	8b 15 b4 3d 11 80    	mov    0x80113db4,%edx
801037ff:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80103802:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80103808:	8b 0d b4 3d 11 80    	mov    0x80113db4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010380e:	0f b6 15 00 3f 11 80 	movzbl 0x80113f00,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80103815:	c1 ee 10             	shr    $0x10,%esi
80103818:	89 f0                	mov    %esi,%eax
8010381a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010381d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80103820:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80103823:	39 c2                	cmp    %eax,%edx
80103825:	74 16                	je     8010383d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80103827:	83 ec 0c             	sub    $0xc,%esp
8010382a:	68 a4 94 10 80       	push   $0x801094a4
8010382f:	e8 cc ce ff ff       	call   80100700 <cprintf>
  ioapic->reg = reg;
80103834:	8b 0d b4 3d 11 80    	mov    0x80113db4,%ecx
8010383a:	83 c4 10             	add    $0x10,%esp
8010383d:	83 c6 21             	add    $0x21,%esi
{
80103840:	ba 10 00 00 00       	mov    $0x10,%edx
80103845:	b8 20 00 00 00       	mov    $0x20,%eax
8010384a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80103850:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80103852:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80103854:	8b 0d b4 3d 11 80    	mov    0x80113db4,%ecx
  for(i = 0; i <= maxintr; i++){
8010385a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010385d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80103863:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80103866:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80103869:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010386c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010386e:	8b 0d b4 3d 11 80    	mov    0x80113db4,%ecx
80103874:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010387b:	39 f0                	cmp    %esi,%eax
8010387d:	75 d1                	jne    80103850 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010387f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103882:	5b                   	pop    %ebx
80103883:	5e                   	pop    %esi
80103884:	5d                   	pop    %ebp
80103885:	c3                   	ret    
80103886:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010388d:	8d 76 00             	lea    0x0(%esi),%esi

80103890 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80103890:	55                   	push   %ebp
  ioapic->reg = reg;
80103891:	8b 0d b4 3d 11 80    	mov    0x80113db4,%ecx
{
80103897:	89 e5                	mov    %esp,%ebp
80103899:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010389c:	8d 50 20             	lea    0x20(%eax),%edx
8010389f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801038a3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801038a5:	8b 0d b4 3d 11 80    	mov    0x80113db4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801038ab:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801038ae:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801038b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801038b4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801038b6:	a1 b4 3d 11 80       	mov    0x80113db4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801038bb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801038be:	89 50 10             	mov    %edx,0x10(%eax)
}
801038c1:	5d                   	pop    %ebp
801038c2:	c3                   	ret    
801038c3:	66 90                	xchg   %ax,%ax
801038c5:	66 90                	xchg   %ax,%ax
801038c7:	66 90                	xchg   %ax,%ax
801038c9:	66 90                	xchg   %ax,%ax
801038cb:	66 90                	xchg   %ax,%ax
801038cd:	66 90                	xchg   %ax,%ax
801038cf:	90                   	nop

801038d0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	53                   	push   %ebx
801038d4:	83 ec 04             	sub    $0x4,%esp
801038d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801038da:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801038e0:	75 76                	jne    80103958 <kfree+0x88>
801038e2:	81 fb 50 9e 11 80    	cmp    $0x80119e50,%ebx
801038e8:	72 6e                	jb     80103958 <kfree+0x88>
801038ea:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801038f0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801038f5:	77 61                	ja     80103958 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801038f7:	83 ec 04             	sub    $0x4,%esp
801038fa:	68 00 10 00 00       	push   $0x1000
801038ff:	6a 01                	push   $0x1
80103901:	53                   	push   %ebx
80103902:	e8 09 29 00 00       	call   80106210 <memset>

  if(kmem.use_lock)
80103907:	8b 15 f4 3d 11 80    	mov    0x80113df4,%edx
8010390d:	83 c4 10             	add    $0x10,%esp
80103910:	85 d2                	test   %edx,%edx
80103912:	75 1c                	jne    80103930 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80103914:	a1 f8 3d 11 80       	mov    0x80113df8,%eax
80103919:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010391b:	a1 f4 3d 11 80       	mov    0x80113df4,%eax
  kmem.freelist = r;
80103920:	89 1d f8 3d 11 80    	mov    %ebx,0x80113df8
  if(kmem.use_lock)
80103926:	85 c0                	test   %eax,%eax
80103928:	75 1e                	jne    80103948 <kfree+0x78>
    release(&kmem.lock);
}
8010392a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010392d:	c9                   	leave  
8010392e:	c3                   	ret    
8010392f:	90                   	nop
    acquire(&kmem.lock);
80103930:	83 ec 0c             	sub    $0xc,%esp
80103933:	68 c0 3d 11 80       	push   $0x80113dc0
80103938:	e8 13 28 00 00       	call   80106150 <acquire>
8010393d:	83 c4 10             	add    $0x10,%esp
80103940:	eb d2                	jmp    80103914 <kfree+0x44>
80103942:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80103948:	c7 45 08 c0 3d 11 80 	movl   $0x80113dc0,0x8(%ebp)
}
8010394f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103952:	c9                   	leave  
    release(&kmem.lock);
80103953:	e9 98 27 00 00       	jmp    801060f0 <release>
    panic("kfree");
80103958:	83 ec 0c             	sub    $0xc,%esp
8010395b:	68 d6 94 10 80       	push   $0x801094d6
80103960:	e8 1b ca ff ff       	call   80100380 <panic>
80103965:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010396c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103970 <freerange>:
{
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80103974:	8b 45 08             	mov    0x8(%ebp),%eax
{
80103977:	8b 75 0c             	mov    0xc(%ebp),%esi
8010397a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010397b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80103981:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103987:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010398d:	39 de                	cmp    %ebx,%esi
8010398f:	72 23                	jb     801039b4 <freerange+0x44>
80103991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80103998:	83 ec 0c             	sub    $0xc,%esp
8010399b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801039a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801039a7:	50                   	push   %eax
801039a8:	e8 23 ff ff ff       	call   801038d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801039ad:	83 c4 10             	add    $0x10,%esp
801039b0:	39 f3                	cmp    %esi,%ebx
801039b2:	76 e4                	jbe    80103998 <freerange+0x28>
}
801039b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039b7:	5b                   	pop    %ebx
801039b8:	5e                   	pop    %esi
801039b9:	5d                   	pop    %ebp
801039ba:	c3                   	ret    
801039bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039bf:	90                   	nop

801039c0 <kinit2>:
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801039c4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801039c7:	8b 75 0c             	mov    0xc(%ebp),%esi
801039ca:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801039cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801039d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801039d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801039dd:	39 de                	cmp    %ebx,%esi
801039df:	72 23                	jb     80103a04 <kinit2+0x44>
801039e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801039e8:	83 ec 0c             	sub    $0xc,%esp
801039eb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801039f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801039f7:	50                   	push   %eax
801039f8:	e8 d3 fe ff ff       	call   801038d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801039fd:	83 c4 10             	add    $0x10,%esp
80103a00:	39 de                	cmp    %ebx,%esi
80103a02:	73 e4                	jae    801039e8 <kinit2+0x28>
  kmem.use_lock = 1;
80103a04:	c7 05 f4 3d 11 80 01 	movl   $0x1,0x80113df4
80103a0b:	00 00 00 
}
80103a0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a11:	5b                   	pop    %ebx
80103a12:	5e                   	pop    %esi
80103a13:	5d                   	pop    %ebp
80103a14:	c3                   	ret    
80103a15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a20 <kinit1>:
{
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	56                   	push   %esi
80103a24:	53                   	push   %ebx
80103a25:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80103a28:	83 ec 08             	sub    $0x8,%esp
80103a2b:	68 dc 94 10 80       	push   $0x801094dc
80103a30:	68 c0 3d 11 80       	push   $0x80113dc0
80103a35:	e8 46 25 00 00       	call   80105f80 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80103a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103a3d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80103a40:	c7 05 f4 3d 11 80 00 	movl   $0x0,0x80113df4
80103a47:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80103a4a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80103a50:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103a56:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80103a5c:	39 de                	cmp    %ebx,%esi
80103a5e:	72 1c                	jb     80103a7c <kinit1+0x5c>
    kfree(p);
80103a60:	83 ec 0c             	sub    $0xc,%esp
80103a63:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103a69:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80103a6f:	50                   	push   %eax
80103a70:	e8 5b fe ff ff       	call   801038d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103a75:	83 c4 10             	add    $0x10,%esp
80103a78:	39 de                	cmp    %ebx,%esi
80103a7a:	73 e4                	jae    80103a60 <kinit1+0x40>
}
80103a7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a7f:	5b                   	pop    %ebx
80103a80:	5e                   	pop    %esi
80103a81:	5d                   	pop    %ebp
80103a82:	c3                   	ret    
80103a83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a90 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80103a90:	a1 f4 3d 11 80       	mov    0x80113df4,%eax
80103a95:	85 c0                	test   %eax,%eax
80103a97:	75 1f                	jne    80103ab8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80103a99:	a1 f8 3d 11 80       	mov    0x80113df8,%eax
  if(r)
80103a9e:	85 c0                	test   %eax,%eax
80103aa0:	74 0e                	je     80103ab0 <kalloc+0x20>
    kmem.freelist = r->next;
80103aa2:	8b 10                	mov    (%eax),%edx
80103aa4:	89 15 f8 3d 11 80    	mov    %edx,0x80113df8
  if(kmem.use_lock)
80103aaa:	c3                   	ret    
80103aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103aaf:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80103ab0:	c3                   	ret    
80103ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80103ab8:	55                   	push   %ebp
80103ab9:	89 e5                	mov    %esp,%ebp
80103abb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80103abe:	68 c0 3d 11 80       	push   $0x80113dc0
80103ac3:	e8 88 26 00 00       	call   80106150 <acquire>
  r = kmem.freelist;
80103ac8:	a1 f8 3d 11 80       	mov    0x80113df8,%eax
  if(kmem.use_lock)
80103acd:	8b 15 f4 3d 11 80    	mov    0x80113df4,%edx
  if(r)
80103ad3:	83 c4 10             	add    $0x10,%esp
80103ad6:	85 c0                	test   %eax,%eax
80103ad8:	74 08                	je     80103ae2 <kalloc+0x52>
    kmem.freelist = r->next;
80103ada:	8b 08                	mov    (%eax),%ecx
80103adc:	89 0d f8 3d 11 80    	mov    %ecx,0x80113df8
  if(kmem.use_lock)
80103ae2:	85 d2                	test   %edx,%edx
80103ae4:	74 16                	je     80103afc <kalloc+0x6c>
    release(&kmem.lock);
80103ae6:	83 ec 0c             	sub    $0xc,%esp
80103ae9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103aec:	68 c0 3d 11 80       	push   $0x80113dc0
80103af1:	e8 fa 25 00 00       	call   801060f0 <release>
  return (char*)r;
80103af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80103af9:	83 c4 10             	add    $0x10,%esp
}
80103afc:	c9                   	leave  
80103afd:	c3                   	ret    
80103afe:	66 90                	xchg   %ax,%ax

80103b00 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103b00:	ba 64 00 00 00       	mov    $0x64,%edx
80103b05:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80103b06:	a8 01                	test   $0x1,%al
80103b08:	0f 84 c2 00 00 00    	je     80103bd0 <kbdgetc+0xd0>
{
80103b0e:	55                   	push   %ebp
80103b0f:	ba 60 00 00 00       	mov    $0x60,%edx
80103b14:	89 e5                	mov    %esp,%ebp
80103b16:	53                   	push   %ebx
80103b17:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80103b18:	8b 1d fc 3d 11 80    	mov    0x80113dfc,%ebx
  data = inb(KBDATAP);
80103b1e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80103b21:	3c e0                	cmp    $0xe0,%al
80103b23:	74 5b                	je     80103b80 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80103b25:	89 da                	mov    %ebx,%edx
80103b27:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
80103b2a:	84 c0                	test   %al,%al
80103b2c:	78 62                	js     80103b90 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80103b2e:	85 d2                	test   %edx,%edx
80103b30:	74 09                	je     80103b3b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80103b32:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80103b35:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80103b38:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80103b3b:	0f b6 91 20 96 10 80 	movzbl -0x7fef69e0(%ecx),%edx
  shift ^= togglecode[data];
80103b42:	0f b6 81 20 95 10 80 	movzbl -0x7fef6ae0(%ecx),%eax
  shift |= shiftcode[data];
80103b49:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80103b4b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80103b4d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
80103b4f:	89 15 fc 3d 11 80    	mov    %edx,0x80113dfc
  c = charcode[shift & (CTL | SHIFT)][data];
80103b55:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80103b58:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80103b5b:	8b 04 85 00 95 10 80 	mov    -0x7fef6b00(,%eax,4),%eax
80103b62:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80103b66:	74 0b                	je     80103b73 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80103b68:	8d 50 9f             	lea    -0x61(%eax),%edx
80103b6b:	83 fa 19             	cmp    $0x19,%edx
80103b6e:	77 48                	ja     80103bb8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80103b70:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80103b73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b76:	c9                   	leave  
80103b77:	c3                   	ret    
80103b78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b7f:	90                   	nop
    shift |= E0ESC;
80103b80:	83 cb 40             	or     $0x40,%ebx
    return 0;
80103b83:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80103b85:	89 1d fc 3d 11 80    	mov    %ebx,0x80113dfc
}
80103b8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b8e:	c9                   	leave  
80103b8f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80103b90:	83 e0 7f             	and    $0x7f,%eax
80103b93:	85 d2                	test   %edx,%edx
80103b95:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80103b98:	0f b6 81 20 96 10 80 	movzbl -0x7fef69e0(%ecx),%eax
80103b9f:	83 c8 40             	or     $0x40,%eax
80103ba2:	0f b6 c0             	movzbl %al,%eax
80103ba5:	f7 d0                	not    %eax
80103ba7:	21 d8                	and    %ebx,%eax
}
80103ba9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
80103bac:	a3 fc 3d 11 80       	mov    %eax,0x80113dfc
    return 0;
80103bb1:	31 c0                	xor    %eax,%eax
}
80103bb3:	c9                   	leave  
80103bb4:	c3                   	ret    
80103bb5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80103bb8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80103bbb:	8d 50 20             	lea    0x20(%eax),%edx
}
80103bbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bc1:	c9                   	leave  
      c += 'a' - 'A';
80103bc2:	83 f9 1a             	cmp    $0x1a,%ecx
80103bc5:	0f 42 c2             	cmovb  %edx,%eax
}
80103bc8:	c3                   	ret    
80103bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80103bd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103bd5:	c3                   	ret    
80103bd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bdd:	8d 76 00             	lea    0x0(%esi),%esi

80103be0 <kbdintr>:

void
kbdintr(void)
{
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80103be6:	68 00 3b 10 80       	push   $0x80103b00
80103beb:	e8 50 d9 ff ff       	call   80101540 <consoleintr>
}
80103bf0:	83 c4 10             	add    $0x10,%esp
80103bf3:	c9                   	leave  
80103bf4:	c3                   	ret    
80103bf5:	66 90                	xchg   %ax,%ax
80103bf7:	66 90                	xchg   %ax,%ax
80103bf9:	66 90                	xchg   %ax,%ax
80103bfb:	66 90                	xchg   %ax,%ax
80103bfd:	66 90                	xchg   %ax,%ax
80103bff:	90                   	nop

80103c00 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80103c00:	a1 00 3e 11 80       	mov    0x80113e00,%eax
80103c05:	85 c0                	test   %eax,%eax
80103c07:	0f 84 cb 00 00 00    	je     80103cd8 <lapicinit+0xd8>
  lapic[index] = value;
80103c0d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80103c14:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103c17:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103c1a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80103c21:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103c24:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103c27:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80103c2e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80103c31:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103c34:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80103c3b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80103c3e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103c41:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80103c48:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80103c4b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103c4e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80103c55:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80103c58:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80103c5b:	8b 50 30             	mov    0x30(%eax),%edx
80103c5e:	c1 ea 10             	shr    $0x10,%edx
80103c61:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80103c67:	75 77                	jne    80103ce0 <lapicinit+0xe0>
  lapic[index] = value;
80103c69:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80103c70:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103c73:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103c76:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80103c7d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103c80:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103c83:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80103c8a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103c8d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103c90:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103c97:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103c9a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103c9d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80103ca4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103ca7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103caa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80103cb1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80103cb4:	8b 50 20             	mov    0x20(%eax),%edx
80103cb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cbe:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80103cc0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80103cc6:	80 e6 10             	and    $0x10,%dh
80103cc9:	75 f5                	jne    80103cc0 <lapicinit+0xc0>
  lapic[index] = value;
80103ccb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103cd2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103cd5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103cd8:	c3                   	ret    
80103cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80103ce0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80103ce7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80103cea:	8b 50 20             	mov    0x20(%eax),%edx
}
80103ced:	e9 77 ff ff ff       	jmp    80103c69 <lapicinit+0x69>
80103cf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d00 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80103d00:	a1 00 3e 11 80       	mov    0x80113e00,%eax
80103d05:	85 c0                	test   %eax,%eax
80103d07:	74 07                	je     80103d10 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80103d09:	8b 40 20             	mov    0x20(%eax),%eax
80103d0c:	c1 e8 18             	shr    $0x18,%eax
80103d0f:	c3                   	ret    
    return 0;
80103d10:	31 c0                	xor    %eax,%eax
}
80103d12:	c3                   	ret    
80103d13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d20 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80103d20:	a1 00 3e 11 80       	mov    0x80113e00,%eax
80103d25:	85 c0                	test   %eax,%eax
80103d27:	74 0d                	je     80103d36 <lapiceoi+0x16>
  lapic[index] = value;
80103d29:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103d30:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103d33:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80103d36:	c3                   	ret    
80103d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d3e:	66 90                	xchg   %ax,%ax

80103d40 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80103d40:	c3                   	ret    
80103d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d4f:	90                   	nop

80103d50 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103d50:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d51:	b8 0f 00 00 00       	mov    $0xf,%eax
80103d56:	ba 70 00 00 00       	mov    $0x70,%edx
80103d5b:	89 e5                	mov    %esp,%ebp
80103d5d:	53                   	push   %ebx
80103d5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103d61:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103d64:	ee                   	out    %al,(%dx)
80103d65:	b8 0a 00 00 00       	mov    $0xa,%eax
80103d6a:	ba 71 00 00 00       	mov    $0x71,%edx
80103d6f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80103d70:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103d72:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80103d75:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80103d7b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80103d7d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80103d80:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80103d82:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80103d85:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80103d88:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80103d8e:	a1 00 3e 11 80       	mov    0x80113e00,%eax
80103d93:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103d99:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103d9c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103da3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103da6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103da9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103db0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103db3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103db6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103dbc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103dbf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103dc5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103dc8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103dce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103dd1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103dd7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80103dda:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ddd:	c9                   	leave  
80103dde:	c3                   	ret    
80103ddf:	90                   	nop

80103de0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103de0:	55                   	push   %ebp
80103de1:	b8 0b 00 00 00       	mov    $0xb,%eax
80103de6:	ba 70 00 00 00       	mov    $0x70,%edx
80103deb:	89 e5                	mov    %esp,%ebp
80103ded:	57                   	push   %edi
80103dee:	56                   	push   %esi
80103def:	53                   	push   %ebx
80103df0:	83 ec 4c             	sub    $0x4c,%esp
80103df3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103df4:	ba 71 00 00 00       	mov    $0x71,%edx
80103df9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80103dfa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103dfd:	bb 70 00 00 00       	mov    $0x70,%ebx
80103e02:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103e05:	8d 76 00             	lea    0x0(%esi),%esi
80103e08:	31 c0                	xor    %eax,%eax
80103e0a:	89 da                	mov    %ebx,%edx
80103e0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103e0d:	b9 71 00 00 00       	mov    $0x71,%ecx
80103e12:	89 ca                	mov    %ecx,%edx
80103e14:	ec                   	in     (%dx),%al
80103e15:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e18:	89 da                	mov    %ebx,%edx
80103e1a:	b8 02 00 00 00       	mov    $0x2,%eax
80103e1f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103e20:	89 ca                	mov    %ecx,%edx
80103e22:	ec                   	in     (%dx),%al
80103e23:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e26:	89 da                	mov    %ebx,%edx
80103e28:	b8 04 00 00 00       	mov    $0x4,%eax
80103e2d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103e2e:	89 ca                	mov    %ecx,%edx
80103e30:	ec                   	in     (%dx),%al
80103e31:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e34:	89 da                	mov    %ebx,%edx
80103e36:	b8 07 00 00 00       	mov    $0x7,%eax
80103e3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103e3c:	89 ca                	mov    %ecx,%edx
80103e3e:	ec                   	in     (%dx),%al
80103e3f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e42:	89 da                	mov    %ebx,%edx
80103e44:	b8 08 00 00 00       	mov    $0x8,%eax
80103e49:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103e4a:	89 ca                	mov    %ecx,%edx
80103e4c:	ec                   	in     (%dx),%al
80103e4d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e4f:	89 da                	mov    %ebx,%edx
80103e51:	b8 09 00 00 00       	mov    $0x9,%eax
80103e56:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103e57:	89 ca                	mov    %ecx,%edx
80103e59:	ec                   	in     (%dx),%al
80103e5a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e5c:	89 da                	mov    %ebx,%edx
80103e5e:	b8 0a 00 00 00       	mov    $0xa,%eax
80103e63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103e64:	89 ca                	mov    %ecx,%edx
80103e66:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103e67:	84 c0                	test   %al,%al
80103e69:	78 9d                	js     80103e08 <cmostime+0x28>
  return inb(CMOS_RETURN);
80103e6b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80103e6f:	89 fa                	mov    %edi,%edx
80103e71:	0f b6 fa             	movzbl %dl,%edi
80103e74:	89 f2                	mov    %esi,%edx
80103e76:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103e79:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103e7d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e80:	89 da                	mov    %ebx,%edx
80103e82:	89 7d c8             	mov    %edi,-0x38(%ebp)
80103e85:	89 45 bc             	mov    %eax,-0x44(%ebp)
80103e88:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80103e8c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80103e8f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80103e92:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80103e96:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103e99:	31 c0                	xor    %eax,%eax
80103e9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103e9c:	89 ca                	mov    %ecx,%edx
80103e9e:	ec                   	in     (%dx),%al
80103e9f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103ea2:	89 da                	mov    %ebx,%edx
80103ea4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80103ea7:	b8 02 00 00 00       	mov    $0x2,%eax
80103eac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103ead:	89 ca                	mov    %ecx,%edx
80103eaf:	ec                   	in     (%dx),%al
80103eb0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103eb3:	89 da                	mov    %ebx,%edx
80103eb5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103eb8:	b8 04 00 00 00       	mov    $0x4,%eax
80103ebd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103ebe:	89 ca                	mov    %ecx,%edx
80103ec0:	ec                   	in     (%dx),%al
80103ec1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103ec4:	89 da                	mov    %ebx,%edx
80103ec6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103ec9:	b8 07 00 00 00       	mov    $0x7,%eax
80103ece:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103ecf:	89 ca                	mov    %ecx,%edx
80103ed1:	ec                   	in     (%dx),%al
80103ed2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103ed5:	89 da                	mov    %ebx,%edx
80103ed7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103eda:	b8 08 00 00 00       	mov    $0x8,%eax
80103edf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103ee0:	89 ca                	mov    %ecx,%edx
80103ee2:	ec                   	in     (%dx),%al
80103ee3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103ee6:	89 da                	mov    %ebx,%edx
80103ee8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103eeb:	b8 09 00 00 00       	mov    $0x9,%eax
80103ef0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103ef1:	89 ca                	mov    %ecx,%edx
80103ef3:	ec                   	in     (%dx),%al
80103ef4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103ef7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80103efa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103efd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103f00:	6a 18                	push   $0x18
80103f02:	50                   	push   %eax
80103f03:	8d 45 b8             	lea    -0x48(%ebp),%eax
80103f06:	50                   	push   %eax
80103f07:	e8 54 23 00 00       	call   80106260 <memcmp>
80103f0c:	83 c4 10             	add    $0x10,%esp
80103f0f:	85 c0                	test   %eax,%eax
80103f11:	0f 85 f1 fe ff ff    	jne    80103e08 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80103f17:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80103f1b:	75 78                	jne    80103f95 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103f1d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103f20:	89 c2                	mov    %eax,%edx
80103f22:	83 e0 0f             	and    $0xf,%eax
80103f25:	c1 ea 04             	shr    $0x4,%edx
80103f28:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103f2b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103f2e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103f31:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103f34:	89 c2                	mov    %eax,%edx
80103f36:	83 e0 0f             	and    $0xf,%eax
80103f39:	c1 ea 04             	shr    $0x4,%edx
80103f3c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103f3f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103f42:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80103f45:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103f48:	89 c2                	mov    %eax,%edx
80103f4a:	83 e0 0f             	and    $0xf,%eax
80103f4d:	c1 ea 04             	shr    $0x4,%edx
80103f50:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103f53:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103f56:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103f59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103f5c:	89 c2                	mov    %eax,%edx
80103f5e:	83 e0 0f             	and    $0xf,%eax
80103f61:	c1 ea 04             	shr    $0x4,%edx
80103f64:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103f67:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103f6a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80103f6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103f70:	89 c2                	mov    %eax,%edx
80103f72:	83 e0 0f             	and    $0xf,%eax
80103f75:	c1 ea 04             	shr    $0x4,%edx
80103f78:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103f7b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103f7e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103f81:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103f84:	89 c2                	mov    %eax,%edx
80103f86:	83 e0 0f             	and    $0xf,%eax
80103f89:	c1 ea 04             	shr    $0x4,%edx
80103f8c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103f8f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103f92:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80103f95:	8b 75 08             	mov    0x8(%ebp),%esi
80103f98:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103f9b:	89 06                	mov    %eax,(%esi)
80103f9d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103fa0:	89 46 04             	mov    %eax,0x4(%esi)
80103fa3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103fa6:	89 46 08             	mov    %eax,0x8(%esi)
80103fa9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103fac:	89 46 0c             	mov    %eax,0xc(%esi)
80103faf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103fb2:	89 46 10             	mov    %eax,0x10(%esi)
80103fb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103fb8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80103fbb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80103fc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fc5:	5b                   	pop    %ebx
80103fc6:	5e                   	pop    %esi
80103fc7:	5f                   	pop    %edi
80103fc8:	5d                   	pop    %ebp
80103fc9:	c3                   	ret    
80103fca:	66 90                	xchg   %ax,%ax
80103fcc:	66 90                	xchg   %ax,%ax
80103fce:	66 90                	xchg   %ax,%ax

80103fd0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103fd0:	8b 0d 68 3e 11 80    	mov    0x80113e68,%ecx
80103fd6:	85 c9                	test   %ecx,%ecx
80103fd8:	0f 8e 8a 00 00 00    	jle    80104068 <install_trans+0x98>
{
80103fde:	55                   	push   %ebp
80103fdf:	89 e5                	mov    %esp,%ebp
80103fe1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103fe2:	31 ff                	xor    %edi,%edi
{
80103fe4:	56                   	push   %esi
80103fe5:	53                   	push   %ebx
80103fe6:	83 ec 0c             	sub    $0xc,%esp
80103fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103ff0:	a1 54 3e 11 80       	mov    0x80113e54,%eax
80103ff5:	83 ec 08             	sub    $0x8,%esp
80103ff8:	01 f8                	add    %edi,%eax
80103ffa:	83 c0 01             	add    $0x1,%eax
80103ffd:	50                   	push   %eax
80103ffe:	ff 35 64 3e 11 80    	push   0x80113e64
80104004:	e8 c7 c0 ff ff       	call   801000d0 <bread>
80104009:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010400b:	58                   	pop    %eax
8010400c:	5a                   	pop    %edx
8010400d:	ff 34 bd 6c 3e 11 80 	push   -0x7feec194(,%edi,4)
80104014:	ff 35 64 3e 11 80    	push   0x80113e64
  for (tail = 0; tail < log.lh.n; tail++) {
8010401a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010401d:	e8 ae c0 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80104022:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80104025:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80104027:	8d 46 5c             	lea    0x5c(%esi),%eax
8010402a:	68 00 02 00 00       	push   $0x200
8010402f:	50                   	push   %eax
80104030:	8d 43 5c             	lea    0x5c(%ebx),%eax
80104033:	50                   	push   %eax
80104034:	e8 77 22 00 00       	call   801062b0 <memmove>
    bwrite(dbuf);  // write dst to disk
80104039:	89 1c 24             	mov    %ebx,(%esp)
8010403c:	e8 6f c1 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80104041:	89 34 24             	mov    %esi,(%esp)
80104044:	e8 a7 c1 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80104049:	89 1c 24             	mov    %ebx,(%esp)
8010404c:	e8 9f c1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80104051:	83 c4 10             	add    $0x10,%esp
80104054:	39 3d 68 3e 11 80    	cmp    %edi,0x80113e68
8010405a:	7f 94                	jg     80103ff0 <install_trans+0x20>
  }
}
8010405c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010405f:	5b                   	pop    %ebx
80104060:	5e                   	pop    %esi
80104061:	5f                   	pop    %edi
80104062:	5d                   	pop    %ebp
80104063:	c3                   	ret    
80104064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104068:	c3                   	ret    
80104069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104070 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	53                   	push   %ebx
80104074:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80104077:	ff 35 54 3e 11 80    	push   0x80113e54
8010407d:	ff 35 64 3e 11 80    	push   0x80113e64
80104083:	e8 48 c0 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80104088:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010408b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010408d:	a1 68 3e 11 80       	mov    0x80113e68,%eax
80104092:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80104095:	85 c0                	test   %eax,%eax
80104097:	7e 19                	jle    801040b2 <write_head+0x42>
80104099:	31 d2                	xor    %edx,%edx
8010409b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010409f:	90                   	nop
    hb->block[i] = log.lh.block[i];
801040a0:	8b 0c 95 6c 3e 11 80 	mov    -0x7feec194(,%edx,4),%ecx
801040a7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801040ab:	83 c2 01             	add    $0x1,%edx
801040ae:	39 d0                	cmp    %edx,%eax
801040b0:	75 ee                	jne    801040a0 <write_head+0x30>
  }
  bwrite(buf);
801040b2:	83 ec 0c             	sub    $0xc,%esp
801040b5:	53                   	push   %ebx
801040b6:	e8 f5 c0 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
801040bb:	89 1c 24             	mov    %ebx,(%esp)
801040be:	e8 2d c1 ff ff       	call   801001f0 <brelse>
}
801040c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040c6:	83 c4 10             	add    $0x10,%esp
801040c9:	c9                   	leave  
801040ca:	c3                   	ret    
801040cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040cf:	90                   	nop

801040d0 <initlog>:
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	53                   	push   %ebx
801040d4:	83 ec 2c             	sub    $0x2c,%esp
801040d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801040da:	68 20 97 10 80       	push   $0x80109720
801040df:	68 20 3e 11 80       	push   $0x80113e20
801040e4:	e8 97 1e 00 00       	call   80105f80 <initlock>
  readsb(dev, &sb);
801040e9:	58                   	pop    %eax
801040ea:	8d 45 dc             	lea    -0x24(%ebp),%eax
801040ed:	5a                   	pop    %edx
801040ee:	50                   	push   %eax
801040ef:	53                   	push   %ebx
801040f0:	e8 3b e8 ff ff       	call   80102930 <readsb>
  log.start = sb.logstart;
801040f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
801040f8:	59                   	pop    %ecx
  log.dev = dev;
801040f9:	89 1d 64 3e 11 80    	mov    %ebx,0x80113e64
  log.size = sb.nlog;
801040ff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80104102:	a3 54 3e 11 80       	mov    %eax,0x80113e54
  log.size = sb.nlog;
80104107:	89 15 58 3e 11 80    	mov    %edx,0x80113e58
  struct buf *buf = bread(log.dev, log.start);
8010410d:	5a                   	pop    %edx
8010410e:	50                   	push   %eax
8010410f:	53                   	push   %ebx
80104110:	e8 bb bf ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80104115:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80104118:	8b 58 5c             	mov    0x5c(%eax),%ebx
8010411b:	89 1d 68 3e 11 80    	mov    %ebx,0x80113e68
  for (i = 0; i < log.lh.n; i++) {
80104121:	85 db                	test   %ebx,%ebx
80104123:	7e 1d                	jle    80104142 <initlog+0x72>
80104125:	31 d2                	xor    %edx,%edx
80104127:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010412e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80104130:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80104134:	89 0c 95 6c 3e 11 80 	mov    %ecx,-0x7feec194(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010413b:	83 c2 01             	add    $0x1,%edx
8010413e:	39 d3                	cmp    %edx,%ebx
80104140:	75 ee                	jne    80104130 <initlog+0x60>
  brelse(buf);
80104142:	83 ec 0c             	sub    $0xc,%esp
80104145:	50                   	push   %eax
80104146:	e8 a5 c0 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010414b:	e8 80 fe ff ff       	call   80103fd0 <install_trans>
  log.lh.n = 0;
80104150:	c7 05 68 3e 11 80 00 	movl   $0x0,0x80113e68
80104157:	00 00 00 
  write_head(); // clear the log
8010415a:	e8 11 ff ff ff       	call   80104070 <write_head>
}
8010415f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104162:	83 c4 10             	add    $0x10,%esp
80104165:	c9                   	leave  
80104166:	c3                   	ret    
80104167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010416e:	66 90                	xchg   %ax,%ax

80104170 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80104176:	68 20 3e 11 80       	push   $0x80113e20
8010417b:	e8 d0 1f 00 00       	call   80106150 <acquire>
80104180:	83 c4 10             	add    $0x10,%esp
80104183:	eb 18                	jmp    8010419d <begin_op+0x2d>
80104185:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80104188:	83 ec 08             	sub    $0x8,%esp
8010418b:	68 20 3e 11 80       	push   $0x80113e20
80104190:	68 20 3e 11 80       	push   $0x80113e20
80104195:	e8 c6 17 00 00       	call   80105960 <sleep>
8010419a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010419d:	a1 60 3e 11 80       	mov    0x80113e60,%eax
801041a2:	85 c0                	test   %eax,%eax
801041a4:	75 e2                	jne    80104188 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801041a6:	a1 5c 3e 11 80       	mov    0x80113e5c,%eax
801041ab:	8b 15 68 3e 11 80    	mov    0x80113e68,%edx
801041b1:	83 c0 01             	add    $0x1,%eax
801041b4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801041b7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801041ba:	83 fa 1e             	cmp    $0x1e,%edx
801041bd:	7f c9                	jg     80104188 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801041bf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801041c2:	a3 5c 3e 11 80       	mov    %eax,0x80113e5c
      release(&log.lock);
801041c7:	68 20 3e 11 80       	push   $0x80113e20
801041cc:	e8 1f 1f 00 00       	call   801060f0 <release>
      break;
    }
  }
}
801041d1:	83 c4 10             	add    $0x10,%esp
801041d4:	c9                   	leave  
801041d5:	c3                   	ret    
801041d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041dd:	8d 76 00             	lea    0x0(%esi),%esi

801041e0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	57                   	push   %edi
801041e4:	56                   	push   %esi
801041e5:	53                   	push   %ebx
801041e6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801041e9:	68 20 3e 11 80       	push   $0x80113e20
801041ee:	e8 5d 1f 00 00       	call   80106150 <acquire>
  log.outstanding -= 1;
801041f3:	a1 5c 3e 11 80       	mov    0x80113e5c,%eax
  if(log.committing)
801041f8:	8b 35 60 3e 11 80    	mov    0x80113e60,%esi
801041fe:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80104201:	8d 58 ff             	lea    -0x1(%eax),%ebx
80104204:	89 1d 5c 3e 11 80    	mov    %ebx,0x80113e5c
  if(log.committing)
8010420a:	85 f6                	test   %esi,%esi
8010420c:	0f 85 22 01 00 00    	jne    80104334 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80104212:	85 db                	test   %ebx,%ebx
80104214:	0f 85 f6 00 00 00    	jne    80104310 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010421a:	c7 05 60 3e 11 80 01 	movl   $0x1,0x80113e60
80104221:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80104224:	83 ec 0c             	sub    $0xc,%esp
80104227:	68 20 3e 11 80       	push   $0x80113e20
8010422c:	e8 bf 1e 00 00       	call   801060f0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80104231:	8b 0d 68 3e 11 80    	mov    0x80113e68,%ecx
80104237:	83 c4 10             	add    $0x10,%esp
8010423a:	85 c9                	test   %ecx,%ecx
8010423c:	7f 42                	jg     80104280 <end_op+0xa0>
    acquire(&log.lock);
8010423e:	83 ec 0c             	sub    $0xc,%esp
80104241:	68 20 3e 11 80       	push   $0x80113e20
80104246:	e8 05 1f 00 00       	call   80106150 <acquire>
    wakeup(&log);
8010424b:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
    log.committing = 0;
80104252:	c7 05 60 3e 11 80 00 	movl   $0x0,0x80113e60
80104259:	00 00 00 
    wakeup(&log);
8010425c:	e8 bf 17 00 00       	call   80105a20 <wakeup>
    release(&log.lock);
80104261:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
80104268:	e8 83 1e 00 00       	call   801060f0 <release>
8010426d:	83 c4 10             	add    $0x10,%esp
}
80104270:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104273:	5b                   	pop    %ebx
80104274:	5e                   	pop    %esi
80104275:	5f                   	pop    %edi
80104276:	5d                   	pop    %ebp
80104277:	c3                   	ret    
80104278:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010427f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80104280:	a1 54 3e 11 80       	mov    0x80113e54,%eax
80104285:	83 ec 08             	sub    $0x8,%esp
80104288:	01 d8                	add    %ebx,%eax
8010428a:	83 c0 01             	add    $0x1,%eax
8010428d:	50                   	push   %eax
8010428e:	ff 35 64 3e 11 80    	push   0x80113e64
80104294:	e8 37 be ff ff       	call   801000d0 <bread>
80104299:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010429b:	58                   	pop    %eax
8010429c:	5a                   	pop    %edx
8010429d:	ff 34 9d 6c 3e 11 80 	push   -0x7feec194(,%ebx,4)
801042a4:	ff 35 64 3e 11 80    	push   0x80113e64
  for (tail = 0; tail < log.lh.n; tail++) {
801042aa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801042ad:	e8 1e be ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801042b2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801042b5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801042b7:	8d 40 5c             	lea    0x5c(%eax),%eax
801042ba:	68 00 02 00 00       	push   $0x200
801042bf:	50                   	push   %eax
801042c0:	8d 46 5c             	lea    0x5c(%esi),%eax
801042c3:	50                   	push   %eax
801042c4:	e8 e7 1f 00 00       	call   801062b0 <memmove>
    bwrite(to);  // write the log
801042c9:	89 34 24             	mov    %esi,(%esp)
801042cc:	e8 df be ff ff       	call   801001b0 <bwrite>
    brelse(from);
801042d1:	89 3c 24             	mov    %edi,(%esp)
801042d4:	e8 17 bf ff ff       	call   801001f0 <brelse>
    brelse(to);
801042d9:	89 34 24             	mov    %esi,(%esp)
801042dc:	e8 0f bf ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801042e1:	83 c4 10             	add    $0x10,%esp
801042e4:	3b 1d 68 3e 11 80    	cmp    0x80113e68,%ebx
801042ea:	7c 94                	jl     80104280 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801042ec:	e8 7f fd ff ff       	call   80104070 <write_head>
    install_trans(); // Now install writes to home locations
801042f1:	e8 da fc ff ff       	call   80103fd0 <install_trans>
    log.lh.n = 0;
801042f6:	c7 05 68 3e 11 80 00 	movl   $0x0,0x80113e68
801042fd:	00 00 00 
    write_head();    // Erase the transaction from the log
80104300:	e8 6b fd ff ff       	call   80104070 <write_head>
80104305:	e9 34 ff ff ff       	jmp    8010423e <end_op+0x5e>
8010430a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80104310:	83 ec 0c             	sub    $0xc,%esp
80104313:	68 20 3e 11 80       	push   $0x80113e20
80104318:	e8 03 17 00 00       	call   80105a20 <wakeup>
  release(&log.lock);
8010431d:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
80104324:	e8 c7 1d 00 00       	call   801060f0 <release>
80104329:	83 c4 10             	add    $0x10,%esp
}
8010432c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010432f:	5b                   	pop    %ebx
80104330:	5e                   	pop    %esi
80104331:	5f                   	pop    %edi
80104332:	5d                   	pop    %ebp
80104333:	c3                   	ret    
    panic("log.committing");
80104334:	83 ec 0c             	sub    $0xc,%esp
80104337:	68 24 97 10 80       	push   $0x80109724
8010433c:	e8 3f c0 ff ff       	call   80100380 <panic>
80104341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104348:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010434f:	90                   	nop

80104350 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	53                   	push   %ebx
80104354:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80104357:	8b 15 68 3e 11 80    	mov    0x80113e68,%edx
{
8010435d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80104360:	83 fa 1d             	cmp    $0x1d,%edx
80104363:	0f 8f 85 00 00 00    	jg     801043ee <log_write+0x9e>
80104369:	a1 58 3e 11 80       	mov    0x80113e58,%eax
8010436e:	83 e8 01             	sub    $0x1,%eax
80104371:	39 c2                	cmp    %eax,%edx
80104373:	7d 79                	jge    801043ee <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80104375:	a1 5c 3e 11 80       	mov    0x80113e5c,%eax
8010437a:	85 c0                	test   %eax,%eax
8010437c:	7e 7d                	jle    801043fb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010437e:	83 ec 0c             	sub    $0xc,%esp
80104381:	68 20 3e 11 80       	push   $0x80113e20
80104386:	e8 c5 1d 00 00       	call   80106150 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010438b:	8b 15 68 3e 11 80    	mov    0x80113e68,%edx
80104391:	83 c4 10             	add    $0x10,%esp
80104394:	85 d2                	test   %edx,%edx
80104396:	7e 4a                	jle    801043e2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80104398:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010439b:	31 c0                	xor    %eax,%eax
8010439d:	eb 08                	jmp    801043a7 <log_write+0x57>
8010439f:	90                   	nop
801043a0:	83 c0 01             	add    $0x1,%eax
801043a3:	39 c2                	cmp    %eax,%edx
801043a5:	74 29                	je     801043d0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801043a7:	39 0c 85 6c 3e 11 80 	cmp    %ecx,-0x7feec194(,%eax,4)
801043ae:	75 f0                	jne    801043a0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
801043b0:	89 0c 85 6c 3e 11 80 	mov    %ecx,-0x7feec194(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801043b7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801043ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801043bd:	c7 45 08 20 3e 11 80 	movl   $0x80113e20,0x8(%ebp)
}
801043c4:	c9                   	leave  
  release(&log.lock);
801043c5:	e9 26 1d 00 00       	jmp    801060f0 <release>
801043ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801043d0:	89 0c 95 6c 3e 11 80 	mov    %ecx,-0x7feec194(,%edx,4)
    log.lh.n++;
801043d7:	83 c2 01             	add    $0x1,%edx
801043da:	89 15 68 3e 11 80    	mov    %edx,0x80113e68
801043e0:	eb d5                	jmp    801043b7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
801043e2:	8b 43 08             	mov    0x8(%ebx),%eax
801043e5:	a3 6c 3e 11 80       	mov    %eax,0x80113e6c
  if (i == log.lh.n)
801043ea:	75 cb                	jne    801043b7 <log_write+0x67>
801043ec:	eb e9                	jmp    801043d7 <log_write+0x87>
    panic("too big a transaction");
801043ee:	83 ec 0c             	sub    $0xc,%esp
801043f1:	68 33 97 10 80       	push   $0x80109733
801043f6:	e8 85 bf ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
801043fb:	83 ec 0c             	sub    $0xc,%esp
801043fe:	68 49 97 10 80       	push   $0x80109749
80104403:	e8 78 bf ff ff       	call   80100380 <panic>
80104408:	66 90                	xchg   %ax,%ax
8010440a:	66 90                	xchg   %ax,%ax
8010440c:	66 90                	xchg   %ax,%ax
8010440e:	66 90                	xchg   %ax,%ax

80104410 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	53                   	push   %ebx
80104414:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80104417:	e8 94 0b 00 00       	call   80104fb0 <cpuid>
8010441c:	89 c3                	mov    %eax,%ebx
8010441e:	e8 8d 0b 00 00       	call   80104fb0 <cpuid>
80104423:	83 ec 04             	sub    $0x4,%esp
80104426:	53                   	push   %ebx
80104427:	50                   	push   %eax
80104428:	68 64 97 10 80       	push   $0x80109764
8010442d:	e8 ce c2 ff ff       	call   80100700 <cprintf>
  idtinit();       // load idt register
80104432:	e8 e9 34 00 00       	call   80107920 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80104437:	e8 14 0b 00 00       	call   80104f50 <mycpu>
8010443c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010443e:	b8 01 00 00 00       	mov    $0x1,%eax
80104443:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010444a:	e8 a1 0f 00 00       	call   801053f0 <scheduler>
8010444f:	90                   	nop

80104450 <mpenter>:
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80104456:	e8 f5 45 00 00       	call   80108a50 <switchkvm>
  seginit();
8010445b:	e8 60 45 00 00       	call   801089c0 <seginit>
  lapicinit();
80104460:	e8 9b f7 ff ff       	call   80103c00 <lapicinit>
  mpmain();
80104465:	e8 a6 ff ff ff       	call   80104410 <mpmain>
8010446a:	66 90                	xchg   %ax,%ax
8010446c:	66 90                	xchg   %ax,%ax
8010446e:	66 90                	xchg   %ax,%ax

80104470 <main>:
{
80104470:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80104474:	83 e4 f0             	and    $0xfffffff0,%esp
80104477:	ff 71 fc             	push   -0x4(%ecx)
8010447a:	55                   	push   %ebp
8010447b:	89 e5                	mov    %esp,%ebp
8010447d:	53                   	push   %ebx
8010447e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010447f:	83 ec 08             	sub    $0x8,%esp
80104482:	68 00 00 40 80       	push   $0x80400000
80104487:	68 50 9e 11 80       	push   $0x80119e50
8010448c:	e8 8f f5 ff ff       	call   80103a20 <kinit1>
  kvmalloc();      // kernel page table
80104491:	e8 aa 4a 00 00       	call   80108f40 <kvmalloc>
  mpinit();        // detect other processors
80104496:	e8 85 01 00 00       	call   80104620 <mpinit>
  lapicinit();     // interrupt controller
8010449b:	e8 60 f7 ff ff       	call   80103c00 <lapicinit>
  seginit();       // segment descriptors
801044a0:	e8 1b 45 00 00       	call   801089c0 <seginit>
  picinit();       // disable pic
801044a5:	e8 76 03 00 00       	call   80104820 <picinit>
  ioapicinit();    // another interrupt controller
801044aa:	e8 31 f3 ff ff       	call   801037e0 <ioapicinit>
  consoleinit();   // console hardware
801044af:	e8 9c d9 ff ff       	call   80101e50 <consoleinit>
  uartinit();      // serial port
801044b4:	e8 97 37 00 00       	call   80107c50 <uartinit>
  pinit();         // process table
801044b9:	e8 82 09 00 00       	call   80104e40 <pinit>
  tvinit();        // trap vectors
801044be:	e8 dd 33 00 00       	call   801078a0 <tvinit>
  binit();         // buffer cache
801044c3:	e8 78 bb ff ff       	call   80100040 <binit>
  fileinit();      // file table
801044c8:	e8 53 dd ff ff       	call   80102220 <fileinit>
  ideinit();       // disk 
801044cd:	e8 fe f0 ff ff       	call   801035d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801044d2:	83 c4 0c             	add    $0xc,%esp
801044d5:	68 8a 00 00 00       	push   $0x8a
801044da:	68 8c c4 10 80       	push   $0x8010c48c
801044df:	68 00 70 00 80       	push   $0x80007000
801044e4:	e8 c7 1d 00 00       	call   801062b0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801044e9:	83 c4 10             	add    $0x10,%esp
801044ec:	69 05 04 3f 11 80 b0 	imul   $0xb0,0x80113f04,%eax
801044f3:	00 00 00 
801044f6:	05 20 3f 11 80       	add    $0x80113f20,%eax
801044fb:	3d 20 3f 11 80       	cmp    $0x80113f20,%eax
80104500:	76 7e                	jbe    80104580 <main+0x110>
80104502:	bb 20 3f 11 80       	mov    $0x80113f20,%ebx
80104507:	eb 20                	jmp    80104529 <main+0xb9>
80104509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104510:	69 05 04 3f 11 80 b0 	imul   $0xb0,0x80113f04,%eax
80104517:	00 00 00 
8010451a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80104520:	05 20 3f 11 80       	add    $0x80113f20,%eax
80104525:	39 c3                	cmp    %eax,%ebx
80104527:	73 57                	jae    80104580 <main+0x110>
    if(c == mycpu())  // We've started already.
80104529:	e8 22 0a 00 00       	call   80104f50 <mycpu>
8010452e:	39 c3                	cmp    %eax,%ebx
80104530:	74 de                	je     80104510 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80104532:	e8 59 f5 ff ff       	call   80103a90 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80104537:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010453a:	c7 05 f8 6f 00 80 50 	movl   $0x80104450,0x80006ff8
80104541:	44 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80104544:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
8010454b:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010454e:	05 00 10 00 00       	add    $0x1000,%eax
80104553:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80104558:	0f b6 03             	movzbl (%ebx),%eax
8010455b:	68 00 70 00 00       	push   $0x7000
80104560:	50                   	push   %eax
80104561:	e8 ea f7 ff ff       	call   80103d50 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80104566:	83 c4 10             	add    $0x10,%esp
80104569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104570:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80104576:	85 c0                	test   %eax,%eax
80104578:	74 f6                	je     80104570 <main+0x100>
8010457a:	eb 94                	jmp    80104510 <main+0xa0>
8010457c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80104580:	83 ec 08             	sub    $0x8,%esp
80104583:	68 00 00 00 8e       	push   $0x8e000000
80104588:	68 00 00 40 80       	push   $0x80400000
8010458d:	e8 2e f4 ff ff       	call   801039c0 <kinit2>
  userinit();      // first user process
80104592:	e8 69 0a 00 00       	call   80105000 <userinit>
  mpmain();        // finish this processor's setup
80104597:	e8 74 fe ff ff       	call   80104410 <mpmain>
8010459c:	66 90                	xchg   %ax,%ax
8010459e:	66 90                	xchg   %ax,%ax

801045a0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	57                   	push   %edi
801045a4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801045a5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801045ab:	53                   	push   %ebx
  e = addr+len;
801045ac:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801045af:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801045b2:	39 de                	cmp    %ebx,%esi
801045b4:	72 10                	jb     801045c6 <mpsearch1+0x26>
801045b6:	eb 50                	jmp    80104608 <mpsearch1+0x68>
801045b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045bf:	90                   	nop
801045c0:	89 fe                	mov    %edi,%esi
801045c2:	39 fb                	cmp    %edi,%ebx
801045c4:	76 42                	jbe    80104608 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801045c6:	83 ec 04             	sub    $0x4,%esp
801045c9:	8d 7e 10             	lea    0x10(%esi),%edi
801045cc:	6a 04                	push   $0x4
801045ce:	68 78 97 10 80       	push   $0x80109778
801045d3:	56                   	push   %esi
801045d4:	e8 87 1c 00 00       	call   80106260 <memcmp>
801045d9:	83 c4 10             	add    $0x10,%esp
801045dc:	85 c0                	test   %eax,%eax
801045de:	75 e0                	jne    801045c0 <mpsearch1+0x20>
801045e0:	89 f2                	mov    %esi,%edx
801045e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801045e8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801045eb:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801045ee:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801045f0:	39 fa                	cmp    %edi,%edx
801045f2:	75 f4                	jne    801045e8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801045f4:	84 c0                	test   %al,%al
801045f6:	75 c8                	jne    801045c0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801045f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045fb:	89 f0                	mov    %esi,%eax
801045fd:	5b                   	pop    %ebx
801045fe:	5e                   	pop    %esi
801045ff:	5f                   	pop    %edi
80104600:	5d                   	pop    %ebp
80104601:	c3                   	ret    
80104602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104608:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010460b:	31 f6                	xor    %esi,%esi
}
8010460d:	5b                   	pop    %ebx
8010460e:	89 f0                	mov    %esi,%eax
80104610:	5e                   	pop    %esi
80104611:	5f                   	pop    %edi
80104612:	5d                   	pop    %ebp
80104613:	c3                   	ret    
80104614:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010461b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010461f:	90                   	nop

80104620 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	57                   	push   %edi
80104624:	56                   	push   %esi
80104625:	53                   	push   %ebx
80104626:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80104629:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80104630:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80104637:	c1 e0 08             	shl    $0x8,%eax
8010463a:	09 d0                	or     %edx,%eax
8010463c:	c1 e0 04             	shl    $0x4,%eax
8010463f:	75 1b                	jne    8010465c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80104641:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80104648:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010464f:	c1 e0 08             	shl    $0x8,%eax
80104652:	09 d0                	or     %edx,%eax
80104654:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80104657:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010465c:	ba 00 04 00 00       	mov    $0x400,%edx
80104661:	e8 3a ff ff ff       	call   801045a0 <mpsearch1>
80104666:	89 c3                	mov    %eax,%ebx
80104668:	85 c0                	test   %eax,%eax
8010466a:	0f 84 40 01 00 00    	je     801047b0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80104670:	8b 73 04             	mov    0x4(%ebx),%esi
80104673:	85 f6                	test   %esi,%esi
80104675:	0f 84 25 01 00 00    	je     801047a0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010467b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010467e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80104684:	6a 04                	push   $0x4
80104686:	68 7d 97 10 80       	push   $0x8010977d
8010468b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010468c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010468f:	e8 cc 1b 00 00       	call   80106260 <memcmp>
80104694:	83 c4 10             	add    $0x10,%esp
80104697:	85 c0                	test   %eax,%eax
80104699:	0f 85 01 01 00 00    	jne    801047a0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010469f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801046a6:	3c 01                	cmp    $0x1,%al
801046a8:	74 08                	je     801046b2 <mpinit+0x92>
801046aa:	3c 04                	cmp    $0x4,%al
801046ac:	0f 85 ee 00 00 00    	jne    801047a0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801046b2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801046b9:	66 85 d2             	test   %dx,%dx
801046bc:	74 22                	je     801046e0 <mpinit+0xc0>
801046be:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801046c1:	89 f0                	mov    %esi,%eax
  sum = 0;
801046c3:	31 d2                	xor    %edx,%edx
801046c5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801046c8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801046cf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801046d2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801046d4:	39 c7                	cmp    %eax,%edi
801046d6:	75 f0                	jne    801046c8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801046d8:	84 d2                	test   %dl,%dl
801046da:	0f 85 c0 00 00 00    	jne    801047a0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801046e0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801046e6:	a3 00 3e 11 80       	mov    %eax,0x80113e00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801046eb:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801046f2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801046f8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801046fd:	03 55 e4             	add    -0x1c(%ebp),%edx
80104700:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80104703:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104707:	90                   	nop
80104708:	39 d0                	cmp    %edx,%eax
8010470a:	73 15                	jae    80104721 <mpinit+0x101>
    switch(*p){
8010470c:	0f b6 08             	movzbl (%eax),%ecx
8010470f:	80 f9 02             	cmp    $0x2,%cl
80104712:	74 4c                	je     80104760 <mpinit+0x140>
80104714:	77 3a                	ja     80104750 <mpinit+0x130>
80104716:	84 c9                	test   %cl,%cl
80104718:	74 56                	je     80104770 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010471a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010471d:	39 d0                	cmp    %edx,%eax
8010471f:	72 eb                	jb     8010470c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80104721:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104724:	85 f6                	test   %esi,%esi
80104726:	0f 84 d9 00 00 00    	je     80104805 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010472c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80104730:	74 15                	je     80104747 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104732:	b8 70 00 00 00       	mov    $0x70,%eax
80104737:	ba 22 00 00 00       	mov    $0x22,%edx
8010473c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010473d:	ba 23 00 00 00       	mov    $0x23,%edx
80104742:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80104743:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104746:	ee                   	out    %al,(%dx)
  }
}
80104747:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010474a:	5b                   	pop    %ebx
8010474b:	5e                   	pop    %esi
8010474c:	5f                   	pop    %edi
8010474d:	5d                   	pop    %ebp
8010474e:	c3                   	ret    
8010474f:	90                   	nop
    switch(*p){
80104750:	83 e9 03             	sub    $0x3,%ecx
80104753:	80 f9 01             	cmp    $0x1,%cl
80104756:	76 c2                	jbe    8010471a <mpinit+0xfa>
80104758:	31 f6                	xor    %esi,%esi
8010475a:	eb ac                	jmp    80104708 <mpinit+0xe8>
8010475c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80104760:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80104764:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80104767:	88 0d 00 3f 11 80    	mov    %cl,0x80113f00
      continue;
8010476d:	eb 99                	jmp    80104708 <mpinit+0xe8>
8010476f:	90                   	nop
      if(ncpu < NCPU) {
80104770:	8b 0d 04 3f 11 80    	mov    0x80113f04,%ecx
80104776:	83 f9 07             	cmp    $0x7,%ecx
80104779:	7f 19                	jg     80104794 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010477b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80104781:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80104785:	83 c1 01             	add    $0x1,%ecx
80104788:	89 0d 04 3f 11 80    	mov    %ecx,0x80113f04
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010478e:	88 9f 20 3f 11 80    	mov    %bl,-0x7feec0e0(%edi)
      p += sizeof(struct mpproc);
80104794:	83 c0 14             	add    $0x14,%eax
      continue;
80104797:	e9 6c ff ff ff       	jmp    80104708 <mpinit+0xe8>
8010479c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801047a0:	83 ec 0c             	sub    $0xc,%esp
801047a3:	68 82 97 10 80       	push   $0x80109782
801047a8:	e8 d3 bb ff ff       	call   80100380 <panic>
801047ad:	8d 76 00             	lea    0x0(%esi),%esi
{
801047b0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801047b5:	eb 13                	jmp    801047ca <mpinit+0x1aa>
801047b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047be:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801047c0:	89 f3                	mov    %esi,%ebx
801047c2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801047c8:	74 d6                	je     801047a0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801047ca:	83 ec 04             	sub    $0x4,%esp
801047cd:	8d 73 10             	lea    0x10(%ebx),%esi
801047d0:	6a 04                	push   $0x4
801047d2:	68 78 97 10 80       	push   $0x80109778
801047d7:	53                   	push   %ebx
801047d8:	e8 83 1a 00 00       	call   80106260 <memcmp>
801047dd:	83 c4 10             	add    $0x10,%esp
801047e0:	85 c0                	test   %eax,%eax
801047e2:	75 dc                	jne    801047c0 <mpinit+0x1a0>
801047e4:	89 da                	mov    %ebx,%edx
801047e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ed:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801047f0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801047f3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801047f6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801047f8:	39 d6                	cmp    %edx,%esi
801047fa:	75 f4                	jne    801047f0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801047fc:	84 c0                	test   %al,%al
801047fe:	75 c0                	jne    801047c0 <mpinit+0x1a0>
80104800:	e9 6b fe ff ff       	jmp    80104670 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80104805:	83 ec 0c             	sub    $0xc,%esp
80104808:	68 9c 97 10 80       	push   $0x8010979c
8010480d:	e8 6e bb ff ff       	call   80100380 <panic>
80104812:	66 90                	xchg   %ax,%ax
80104814:	66 90                	xchg   %ax,%ax
80104816:	66 90                	xchg   %ax,%ax
80104818:	66 90                	xchg   %ax,%ax
8010481a:	66 90                	xchg   %ax,%ax
8010481c:	66 90                	xchg   %ax,%ax
8010481e:	66 90                	xchg   %ax,%ax

80104820 <picinit>:
80104820:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104825:	ba 21 00 00 00       	mov    $0x21,%edx
8010482a:	ee                   	out    %al,(%dx)
8010482b:	ba a1 00 00 00       	mov    $0xa1,%edx
80104830:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80104831:	c3                   	ret    
80104832:	66 90                	xchg   %ax,%ax
80104834:	66 90                	xchg   %ax,%ax
80104836:	66 90                	xchg   %ax,%ax
80104838:	66 90                	xchg   %ax,%ax
8010483a:	66 90                	xchg   %ax,%ax
8010483c:	66 90                	xchg   %ax,%ax
8010483e:	66 90                	xchg   %ax,%ax

80104840 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	57                   	push   %edi
80104844:	56                   	push   %esi
80104845:	53                   	push   %ebx
80104846:	83 ec 0c             	sub    $0xc,%esp
80104849:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010484c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010484f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104855:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010485b:	e8 e0 d9 ff ff       	call   80102240 <filealloc>
80104860:	89 03                	mov    %eax,(%ebx)
80104862:	85 c0                	test   %eax,%eax
80104864:	0f 84 a8 00 00 00    	je     80104912 <pipealloc+0xd2>
8010486a:	e8 d1 d9 ff ff       	call   80102240 <filealloc>
8010486f:	89 06                	mov    %eax,(%esi)
80104871:	85 c0                	test   %eax,%eax
80104873:	0f 84 87 00 00 00    	je     80104900 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104879:	e8 12 f2 ff ff       	call   80103a90 <kalloc>
8010487e:	89 c7                	mov    %eax,%edi
80104880:	85 c0                	test   %eax,%eax
80104882:	0f 84 b0 00 00 00    	je     80104938 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80104888:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010488f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80104892:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80104895:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010489c:	00 00 00 
  p->nwrite = 0;
8010489f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801048a6:	00 00 00 
  p->nread = 0;
801048a9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801048b0:	00 00 00 
  initlock(&p->lock, "pipe");
801048b3:	68 bb 97 10 80       	push   $0x801097bb
801048b8:	50                   	push   %eax
801048b9:	e8 c2 16 00 00       	call   80105f80 <initlock>
  (*f0)->type = FD_PIPE;
801048be:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801048c0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801048c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801048c9:	8b 03                	mov    (%ebx),%eax
801048cb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801048cf:	8b 03                	mov    (%ebx),%eax
801048d1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801048d5:	8b 03                	mov    (%ebx),%eax
801048d7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801048da:	8b 06                	mov    (%esi),%eax
801048dc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801048e2:	8b 06                	mov    (%esi),%eax
801048e4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801048e8:	8b 06                	mov    (%esi),%eax
801048ea:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801048ee:	8b 06                	mov    (%esi),%eax
801048f0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801048f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801048f6:	31 c0                	xor    %eax,%eax
}
801048f8:	5b                   	pop    %ebx
801048f9:	5e                   	pop    %esi
801048fa:	5f                   	pop    %edi
801048fb:	5d                   	pop    %ebp
801048fc:	c3                   	ret    
801048fd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80104900:	8b 03                	mov    (%ebx),%eax
80104902:	85 c0                	test   %eax,%eax
80104904:	74 1e                	je     80104924 <pipealloc+0xe4>
    fileclose(*f0);
80104906:	83 ec 0c             	sub    $0xc,%esp
80104909:	50                   	push   %eax
8010490a:	e8 f1 d9 ff ff       	call   80102300 <fileclose>
8010490f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80104912:	8b 06                	mov    (%esi),%eax
80104914:	85 c0                	test   %eax,%eax
80104916:	74 0c                	je     80104924 <pipealloc+0xe4>
    fileclose(*f1);
80104918:	83 ec 0c             	sub    $0xc,%esp
8010491b:	50                   	push   %eax
8010491c:	e8 df d9 ff ff       	call   80102300 <fileclose>
80104921:	83 c4 10             	add    $0x10,%esp
}
80104924:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80104927:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010492c:	5b                   	pop    %ebx
8010492d:	5e                   	pop    %esi
8010492e:	5f                   	pop    %edi
8010492f:	5d                   	pop    %ebp
80104930:	c3                   	ret    
80104931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80104938:	8b 03                	mov    (%ebx),%eax
8010493a:	85 c0                	test   %eax,%eax
8010493c:	75 c8                	jne    80104906 <pipealloc+0xc6>
8010493e:	eb d2                	jmp    80104912 <pipealloc+0xd2>

80104940 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	56                   	push   %esi
80104944:	53                   	push   %ebx
80104945:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104948:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010494b:	83 ec 0c             	sub    $0xc,%esp
8010494e:	53                   	push   %ebx
8010494f:	e8 fc 17 00 00       	call   80106150 <acquire>
  if(writable){
80104954:	83 c4 10             	add    $0x10,%esp
80104957:	85 f6                	test   %esi,%esi
80104959:	74 65                	je     801049c0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010495b:	83 ec 0c             	sub    $0xc,%esp
8010495e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80104964:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010496b:	00 00 00 
    wakeup(&p->nread);
8010496e:	50                   	push   %eax
8010496f:	e8 ac 10 00 00       	call   80105a20 <wakeup>
80104974:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104977:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010497d:	85 d2                	test   %edx,%edx
8010497f:	75 0a                	jne    8010498b <pipeclose+0x4b>
80104981:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80104987:	85 c0                	test   %eax,%eax
80104989:	74 15                	je     801049a0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010498b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010498e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104991:	5b                   	pop    %ebx
80104992:	5e                   	pop    %esi
80104993:	5d                   	pop    %ebp
    release(&p->lock);
80104994:	e9 57 17 00 00       	jmp    801060f0 <release>
80104999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801049a0:	83 ec 0c             	sub    $0xc,%esp
801049a3:	53                   	push   %ebx
801049a4:	e8 47 17 00 00       	call   801060f0 <release>
    kfree((char*)p);
801049a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801049ac:	83 c4 10             	add    $0x10,%esp
}
801049af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049b2:	5b                   	pop    %ebx
801049b3:	5e                   	pop    %esi
801049b4:	5d                   	pop    %ebp
    kfree((char*)p);
801049b5:	e9 16 ef ff ff       	jmp    801038d0 <kfree>
801049ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801049c0:	83 ec 0c             	sub    $0xc,%esp
801049c3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801049c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801049d0:	00 00 00 
    wakeup(&p->nwrite);
801049d3:	50                   	push   %eax
801049d4:	e8 47 10 00 00       	call   80105a20 <wakeup>
801049d9:	83 c4 10             	add    $0x10,%esp
801049dc:	eb 99                	jmp    80104977 <pipeclose+0x37>
801049de:	66 90                	xchg   %ax,%ax

801049e0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	57                   	push   %edi
801049e4:	56                   	push   %esi
801049e5:	53                   	push   %ebx
801049e6:	83 ec 28             	sub    $0x28,%esp
801049e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801049ec:	53                   	push   %ebx
801049ed:	e8 5e 17 00 00       	call   80106150 <acquire>
  for(i = 0; i < n; i++){
801049f2:	8b 45 10             	mov    0x10(%ebp),%eax
801049f5:	83 c4 10             	add    $0x10,%esp
801049f8:	85 c0                	test   %eax,%eax
801049fa:	0f 8e c0 00 00 00    	jle    80104ac0 <pipewrite+0xe0>
80104a00:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104a03:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80104a09:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80104a0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104a12:	03 45 10             	add    0x10(%ebp),%eax
80104a15:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104a18:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104a1e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104a24:	89 ca                	mov    %ecx,%edx
80104a26:	05 00 02 00 00       	add    $0x200,%eax
80104a2b:	39 c1                	cmp    %eax,%ecx
80104a2d:	74 3f                	je     80104a6e <pipewrite+0x8e>
80104a2f:	eb 67                	jmp    80104a98 <pipewrite+0xb8>
80104a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80104a38:	e8 93 05 00 00       	call   80104fd0 <myproc>
80104a3d:	8b 48 24             	mov    0x24(%eax),%ecx
80104a40:	85 c9                	test   %ecx,%ecx
80104a42:	75 34                	jne    80104a78 <pipewrite+0x98>
      wakeup(&p->nread);
80104a44:	83 ec 0c             	sub    $0xc,%esp
80104a47:	57                   	push   %edi
80104a48:	e8 d3 0f 00 00       	call   80105a20 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104a4d:	58                   	pop    %eax
80104a4e:	5a                   	pop    %edx
80104a4f:	53                   	push   %ebx
80104a50:	56                   	push   %esi
80104a51:	e8 0a 0f 00 00       	call   80105960 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104a56:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80104a5c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80104a62:	83 c4 10             	add    $0x10,%esp
80104a65:	05 00 02 00 00       	add    $0x200,%eax
80104a6a:	39 c2                	cmp    %eax,%edx
80104a6c:	75 2a                	jne    80104a98 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80104a6e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80104a74:	85 c0                	test   %eax,%eax
80104a76:	75 c0                	jne    80104a38 <pipewrite+0x58>
        release(&p->lock);
80104a78:	83 ec 0c             	sub    $0xc,%esp
80104a7b:	53                   	push   %ebx
80104a7c:	e8 6f 16 00 00       	call   801060f0 <release>
        return -1;
80104a81:	83 c4 10             	add    $0x10,%esp
80104a84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80104a89:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a8c:	5b                   	pop    %ebx
80104a8d:	5e                   	pop    %esi
80104a8e:	5f                   	pop    %edi
80104a8f:	5d                   	pop    %ebp
80104a90:	c3                   	ret    
80104a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104a98:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80104a9b:	8d 4a 01             	lea    0x1(%edx),%ecx
80104a9e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80104aa4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80104aaa:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
80104aad:	83 c6 01             	add    $0x1,%esi
80104ab0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104ab3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80104ab7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80104aba:	0f 85 58 ff ff ff    	jne    80104a18 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104ac0:	83 ec 0c             	sub    $0xc,%esp
80104ac3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80104ac9:	50                   	push   %eax
80104aca:	e8 51 0f 00 00       	call   80105a20 <wakeup>
  release(&p->lock);
80104acf:	89 1c 24             	mov    %ebx,(%esp)
80104ad2:	e8 19 16 00 00       	call   801060f0 <release>
  return n;
80104ad7:	8b 45 10             	mov    0x10(%ebp),%eax
80104ada:	83 c4 10             	add    $0x10,%esp
80104add:	eb aa                	jmp    80104a89 <pipewrite+0xa9>
80104adf:	90                   	nop

80104ae0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	57                   	push   %edi
80104ae4:	56                   	push   %esi
80104ae5:	53                   	push   %ebx
80104ae6:	83 ec 18             	sub    $0x18,%esp
80104ae9:	8b 75 08             	mov    0x8(%ebp),%esi
80104aec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80104aef:	56                   	push   %esi
80104af0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80104af6:	e8 55 16 00 00       	call   80106150 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104afb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80104b01:	83 c4 10             	add    $0x10,%esp
80104b04:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80104b0a:	74 2f                	je     80104b3b <piperead+0x5b>
80104b0c:	eb 37                	jmp    80104b45 <piperead+0x65>
80104b0e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80104b10:	e8 bb 04 00 00       	call   80104fd0 <myproc>
80104b15:	8b 48 24             	mov    0x24(%eax),%ecx
80104b18:	85 c9                	test   %ecx,%ecx
80104b1a:	0f 85 80 00 00 00    	jne    80104ba0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104b20:	83 ec 08             	sub    $0x8,%esp
80104b23:	56                   	push   %esi
80104b24:	53                   	push   %ebx
80104b25:	e8 36 0e 00 00       	call   80105960 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104b2a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80104b30:	83 c4 10             	add    $0x10,%esp
80104b33:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80104b39:	75 0a                	jne    80104b45 <piperead+0x65>
80104b3b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80104b41:	85 c0                	test   %eax,%eax
80104b43:	75 cb                	jne    80104b10 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104b45:	8b 55 10             	mov    0x10(%ebp),%edx
80104b48:	31 db                	xor    %ebx,%ebx
80104b4a:	85 d2                	test   %edx,%edx
80104b4c:	7f 20                	jg     80104b6e <piperead+0x8e>
80104b4e:	eb 2c                	jmp    80104b7c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104b50:	8d 48 01             	lea    0x1(%eax),%ecx
80104b53:	25 ff 01 00 00       	and    $0x1ff,%eax
80104b58:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80104b5e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80104b63:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104b66:	83 c3 01             	add    $0x1,%ebx
80104b69:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80104b6c:	74 0e                	je     80104b7c <piperead+0x9c>
    if(p->nread == p->nwrite)
80104b6e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80104b74:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80104b7a:	75 d4                	jne    80104b50 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104b7c:	83 ec 0c             	sub    $0xc,%esp
80104b7f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80104b85:	50                   	push   %eax
80104b86:	e8 95 0e 00 00       	call   80105a20 <wakeup>
  release(&p->lock);
80104b8b:	89 34 24             	mov    %esi,(%esp)
80104b8e:	e8 5d 15 00 00       	call   801060f0 <release>
  return i;
80104b93:	83 c4 10             	add    $0x10,%esp
}
80104b96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b99:	89 d8                	mov    %ebx,%eax
80104b9b:	5b                   	pop    %ebx
80104b9c:	5e                   	pop    %esi
80104b9d:	5f                   	pop    %edi
80104b9e:	5d                   	pop    %ebp
80104b9f:	c3                   	ret    
      release(&p->lock);
80104ba0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104ba3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80104ba8:	56                   	push   %esi
80104ba9:	e8 42 15 00 00       	call   801060f0 <release>
      return -1;
80104bae:	83 c4 10             	add    $0x10,%esp
}
80104bb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bb4:	89 d8                	mov    %ebx,%eax
80104bb6:	5b                   	pop    %ebx
80104bb7:	5e                   	pop    %esi
80104bb8:	5f                   	pop    %edi
80104bb9:	5d                   	pop    %ebp
80104bba:	c3                   	ret    
80104bbb:	66 90                	xchg   %ax,%ax
80104bbd:	66 90                	xchg   %ax,%ax
80104bbf:	90                   	nop

80104bc0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104bc4:	bb d4 45 11 80       	mov    $0x801145d4,%ebx
{
80104bc9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80104bcc:	68 a0 45 11 80       	push   $0x801145a0
80104bd1:	e8 7a 15 00 00       	call   80106150 <acquire>
80104bd6:	83 c4 10             	add    $0x10,%esp
80104bd9:	eb 17                	jmp    80104bf2 <allocproc+0x32>
80104bdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bdf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104be0:	81 c3 00 01 00 00    	add    $0x100,%ebx
80104be6:	81 fb d4 85 11 80    	cmp    $0x801185d4,%ebx
80104bec:	0f 84 de 00 00 00    	je     80104cd0 <allocproc+0x110>
    if(p->state == UNUSED)
80104bf2:	8b 43 0c             	mov    0xc(%ebx),%eax
80104bf5:	85 c0                	test   %eax,%eax
80104bf7:	75 e7                	jne    80104be0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80104bf9:	a1 04 c0 10 80       	mov    0x8010c004,%eax

  release(&ptable.lock);
80104bfe:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80104c01:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80104c08:	89 43 10             	mov    %eax,0x10(%ebx)
80104c0b:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80104c0e:	68 a0 45 11 80       	push   $0x801145a0
  p->pid = nextpid++;
80104c13:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
80104c19:	e8 d2 14 00 00       	call   801060f0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104c1e:	e8 6d ee ff ff       	call   80103a90 <kalloc>
80104c23:	83 c4 10             	add    $0x10,%esp
80104c26:	89 43 08             	mov    %eax,0x8(%ebx)
80104c29:	85 c0                	test   %eax,%eax
80104c2b:	0f 84 cb 00 00 00    	je     80104cfc <allocproc+0x13c>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104c31:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80104c37:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80104c3a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80104c3f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80104c42:	c7 40 14 8d 78 10 80 	movl   $0x8010788d,0x14(%eax)
  p->context = (struct context*)sp;
80104c49:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80104c4c:	6a 14                	push   $0x14
80104c4e:	6a 00                	push   $0x0
80104c50:	50                   	push   %eax
80104c51:	e8 ba 15 00 00       	call   80106210 <memset>
  p->context->eip = (uint)forkret;
80104c56:	8b 43 1c             	mov    0x1c(%ebx),%eax
  p->arrival = ticks;
  p->last_exec = p->arrival; 
  p->burst = DEFAULT_BURST;
  p->certainty = DEFAULT_CERTAINTY;

  if((int)p == -2146351660)
80104c59:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104c5c:	c7 40 10 10 4d 10 80 	movl   $0x80104d10,0x10(%eax)
  p->arrival = ticks;
80104c63:	a1 e0 85 11 80       	mov    0x801185e0,%eax
  p->syscall_count = 0;
80104c68:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  p->arrival = ticks;
80104c6f:	89 83 f0 00 00 00    	mov    %eax,0xf0(%ebx)
  p->last_exec = p->arrival; 
80104c75:	89 83 f4 00 00 00    	mov    %eax,0xf4(%ebx)
  p->burst = DEFAULT_BURST;
80104c7b:	c7 83 f8 00 00 00 02 	movl   $0x2,0xf8(%ebx)
80104c82:	00 00 00 
  p->certainty = DEFAULT_CERTAINTY;
80104c85:	c7 83 fc 00 00 00 32 	movl   $0x32,0xfc(%ebx)
80104c8c:	00 00 00 
  if((int)p == -2146351660)
80104c8f:	81 fb d4 45 11 80    	cmp    $0x801145d4,%ebx
80104c95:	74 59                	je     80104cf0 <allocproc+0x130>
  {
    p->level_queue = 0;
  }
  else if((p->parent->pid == 1) || (p->parent->pid == 0))
80104c97:	8b 43 14             	mov    0x14(%ebx),%eax
  {
    p->level_queue = 0;
80104c9a:	83 78 10 01          	cmpl   $0x1,0x10(%eax)
80104c9e:	0f 97 c0             	seta   %al
80104ca1:	0f b6 c0             	movzbl %al,%eax
80104ca4:	89 83 ec 00 00 00    	mov    %eax,0xec(%ebx)
  else
  {
    p->level_queue = 1;
  }
  //set_times
  memset(p->syscall_history, 0, sizeof(p->syscall_history));
80104caa:	83 ec 04             	sub    $0x4,%esp
80104cad:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80104cb3:	6a 6c                	push   $0x6c
80104cb5:	6a 00                	push   $0x0
80104cb7:	50                   	push   %eax
80104cb8:	e8 53 15 00 00       	call   80106210 <memset>
  return p;
}
80104cbd:	89 d8                	mov    %ebx,%eax
  return p;
80104cbf:	83 c4 10             	add    $0x10,%esp
}
80104cc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cc5:	c9                   	leave  
80104cc6:	c3                   	ret    
80104cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cce:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
80104cd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80104cd3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80104cd5:	68 a0 45 11 80       	push   $0x801145a0
80104cda:	e8 11 14 00 00       	call   801060f0 <release>
}
80104cdf:	89 d8                	mov    %ebx,%eax
  return 0;
80104ce1:	83 c4 10             	add    $0x10,%esp
}
80104ce4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ce7:	c9                   	leave  
80104ce8:	c3                   	ret    
80104ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->level_queue = 0;
80104cf0:	c7 05 c0 46 11 80 00 	movl   $0x0,0x801146c0
80104cf7:	00 00 00 
80104cfa:	eb ae                	jmp    80104caa <allocproc+0xea>
    p->state = UNUSED;
80104cfc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80104d03:	31 db                	xor    %ebx,%ebx
}
80104d05:	89 d8                	mov    %ebx,%eax
80104d07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d0a:	c9                   	leave  
80104d0b:	c3                   	ret    
80104d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d10 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104d16:	68 a0 45 11 80       	push   $0x801145a0
80104d1b:	e8 d0 13 00 00       	call   801060f0 <release>

  if (first) {
80104d20:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80104d25:	83 c4 10             	add    $0x10,%esp
80104d28:	85 c0                	test   %eax,%eax
80104d2a:	75 04                	jne    80104d30 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104d2c:	c9                   	leave  
80104d2d:	c3                   	ret    
80104d2e:	66 90                	xchg   %ax,%ax
    first = 0;
80104d30:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
80104d37:	00 00 00 
    iinit(ROOTDEV);
80104d3a:	83 ec 0c             	sub    $0xc,%esp
80104d3d:	6a 01                	push   $0x1
80104d3f:	e8 2c dc ff ff       	call   80102970 <iinit>
    initlog(ROOTDEV);
80104d44:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104d4b:	e8 80 f3 ff ff       	call   801040d0 <initlog>
}
80104d50:	83 c4 10             	add    $0x10,%esp
80104d53:	c9                   	leave  
80104d54:	c3                   	ret    
80104d55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d60 <sort_pcbs_by_burst>:
int sort_pcbs_by_burst(void) {
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	57                   	push   %edi
80104d64:	56                   	push   %esi
80104d65:	53                   	push   %ebx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104d66:	bb d4 45 11 80       	mov    $0x801145d4,%ebx
int sort_pcbs_by_burst(void) {
80104d6b:	83 ec 1c             	sub    $0x1c,%esp
    int count = 0;
80104d6e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104d75:	eb 17                	jmp    80104d8e <sort_pcbs_by_burst+0x2e>
80104d77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d7e:	66 90                	xchg   %ax,%ax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104d80:	81 c3 00 01 00 00    	add    $0x100,%ebx
80104d86:	81 fb d4 85 11 80    	cmp    $0x801185d4,%ebx
80104d8c:	74 42                	je     80104dd0 <sort_pcbs_by_burst+0x70>
        if (p->state == RUNNABLE && p->level_queue == 1) {
80104d8e:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104d92:	75 ec                	jne    80104d80 <sort_pcbs_by_burst+0x20>
80104d94:	83 bb ec 00 00 00 01 	cmpl   $0x1,0xec(%ebx)
80104d9b:	75 e3                	jne    80104d80 <sort_pcbs_by_burst+0x20>
            cprintf("%d is ready\n", p->pid);
80104d9d:	83 ec 08             	sub    $0x8,%esp
80104da0:	ff 73 10             	push   0x10(%ebx)
80104da3:	68 c0 97 10 80       	push   $0x801097c0
80104da8:	e8 53 b9 ff ff       	call   80100700 <cprintf>
            sorted_procs[count++] = p;
80104dad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104db0:	83 c4 10             	add    $0x10,%esp
80104db3:	89 1c 85 a0 44 11 80 	mov    %ebx,-0x7feebb60(,%eax,4)
80104dba:	83 c0 01             	add    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104dbd:	81 c3 00 01 00 00    	add    $0x100,%ebx
            sorted_procs[count++] = p;
80104dc3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104dc6:	81 fb d4 85 11 80    	cmp    $0x801185d4,%ebx
80104dcc:	75 c0                	jne    80104d8e <sort_pcbs_by_burst+0x2e>
80104dce:	66 90                	xchg   %ax,%ax
    for (int i = 1; i < count; i++) {
80104dd0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
80104dd4:	bf 01 00 00 00       	mov    $0x1,%edi
80104dd9:	7e 4b                	jle    80104e26 <sort_pcbs_by_burst+0xc6>
80104ddb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ddf:	90                   	nop
        struct proc *key = sorted_procs[i];
80104de0:	8b 1c bd a0 44 11 80 	mov    -0x7feebb60(,%edi,4),%ebx
        while (j >= 0 && sorted_procs[j]->burst > key->burst) {
80104de7:	89 f8                	mov    %edi,%eax
80104de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104df0:	8b 0c 85 9c 44 11 80 	mov    -0x7feebb64(,%eax,4),%ecx
80104df7:	8b b3 f8 00 00 00    	mov    0xf8(%ebx),%esi
            sorted_procs[j + 1] = sorted_procs[j];
80104dfd:	89 c2                	mov    %eax,%edx
        while (j >= 0 && sorted_procs[j]->burst > key->burst) {
80104dff:	39 b1 f8 00 00 00    	cmp    %esi,0xf8(%ecx)
80104e05:	7e 10                	jle    80104e17 <sort_pcbs_by_burst+0xb7>
            sorted_procs[j + 1] = sorted_procs[j];
80104e07:	89 0c 85 a0 44 11 80 	mov    %ecx,-0x7feebb60(,%eax,4)
        while (j >= 0 && sorted_procs[j]->burst > key->burst) {
80104e0e:	89 d0                	mov    %edx,%eax
80104e10:	83 e8 01             	sub    $0x1,%eax
80104e13:	75 db                	jne    80104df0 <sort_pcbs_by_burst+0x90>
80104e15:	31 d2                	xor    %edx,%edx
        sorted_procs[j + 1] = key;
80104e17:	89 1c 95 a0 44 11 80 	mov    %ebx,-0x7feebb60(,%edx,4)
    for (int i = 1; i < count; i++) {
80104e1e:	83 c7 01             	add    $0x1,%edi
80104e21:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80104e24:	75 ba                	jne    80104de0 <sort_pcbs_by_burst+0x80>
}
80104e26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104e29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e2c:	5b                   	pop    %ebx
80104e2d:	5e                   	pop    %esi
80104e2e:	5f                   	pop    %edi
80104e2f:	5d                   	pop    %ebp
80104e30:	c3                   	ret    
80104e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e3f:	90                   	nop

80104e40 <pinit>:
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80104e46:	68 cd 97 10 80       	push   $0x801097cd
80104e4b:	68 a0 45 11 80       	push   $0x801145a0
80104e50:	e8 2b 11 00 00       	call   80105f80 <initlock>
}
80104e55:	83 c4 10             	add    $0x10,%esp
80104e58:	c9                   	leave  
80104e59:	c3                   	ret    
80104e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e60 <SJF_init>:
int SJF_init(int pid, int burst, int certainty){
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	56                   	push   %esi
80104e64:	8b 75 10             	mov    0x10(%ebp),%esi
80104e67:	53                   	push   %ebx
80104e68:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(certainty > 100 || certainty < 0)
80104e6b:	83 fe 64             	cmp    $0x64,%esi
80104e6e:	77 59                	ja     80104ec9 <SJF_init+0x69>
  acquire(&ptable.lock);
80104e70:	83 ec 0c             	sub    $0xc,%esp
80104e73:	68 a0 45 11 80       	push   $0x801145a0
80104e78:	e8 d3 12 00 00       	call   80106150 <acquire>
80104e7d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e80:	b8 d4 45 11 80       	mov    $0x801145d4,%eax
80104e85:	eb 15                	jmp    80104e9c <SJF_init+0x3c>
80104e87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e8e:	66 90                	xchg   %ax,%ax
80104e90:	05 00 01 00 00       	add    $0x100,%eax
80104e95:	3d d4 85 11 80       	cmp    $0x801185d4,%eax
80104e9a:	74 14                	je     80104eb0 <SJF_init+0x50>
    if(p->pid == pid){
80104e9c:	39 58 10             	cmp    %ebx,0x10(%eax)
80104e9f:	75 ef                	jne    80104e90 <SJF_init+0x30>
      p->burst = burst;
80104ea1:	8b 55 0c             	mov    0xc(%ebp),%edx
      p->certainty = certainty;
80104ea4:	89 b0 fc 00 00 00    	mov    %esi,0xfc(%eax)
      p->burst = burst;
80104eaa:	89 90 f8 00 00 00    	mov    %edx,0xf8(%eax)
  release(&ptable.lock);
80104eb0:	83 ec 0c             	sub    $0xc,%esp
80104eb3:	68 a0 45 11 80       	push   $0x801145a0
80104eb8:	e8 33 12 00 00       	call   801060f0 <release>
  return 0;
80104ebd:	83 c4 10             	add    $0x10,%esp
80104ec0:	31 c0                	xor    %eax,%eax
}
80104ec2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ec5:	5b                   	pop    %ebx
80104ec6:	5e                   	pop    %esi
80104ec7:	5d                   	pop    %ebp
80104ec8:	c3                   	ret    
    return -1;
80104ec9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ece:	eb f2                	jmp    80104ec2 <SJF_init+0x62>

80104ed0 <change_queue>:
void change_queue(int pid , int dest_Q){
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	56                   	push   %esi
80104ed4:	53                   	push   %ebx
80104ed5:	8b 75 0c             	mov    0xc(%ebp),%esi
80104ed8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104edb:	83 ec 0c             	sub    $0xc,%esp
80104ede:	68 a0 45 11 80       	push   $0x801145a0
80104ee3:	e8 68 12 00 00       	call   80106150 <acquire>
80104ee8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104eeb:	b8 d4 45 11 80       	mov    $0x801145d4,%eax
80104ef0:	eb 12                	jmp    80104f04 <change_queue+0x34>
80104ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ef8:	05 00 01 00 00       	add    $0x100,%eax
80104efd:	3d d4 85 11 80       	cmp    $0x801185d4,%eax
80104f02:	74 13                	je     80104f17 <change_queue+0x47>
    if(p->pid == pid){
80104f04:	39 58 10             	cmp    %ebx,0x10(%eax)
80104f07:	75 ef                	jne    80104ef8 <change_queue+0x28>
      if(p->level_queue != dest_Q){
80104f09:	39 b0 ec 00 00 00    	cmp    %esi,0xec(%eax)
80104f0f:	74 1f                	je     80104f30 <change_queue+0x60>
        p->level_queue = dest_Q;
80104f11:	89 b0 ec 00 00 00    	mov    %esi,0xec(%eax)
  release(&ptable.lock);
80104f17:	c7 45 08 a0 45 11 80 	movl   $0x801145a0,0x8(%ebp)
}
80104f1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f21:	5b                   	pop    %ebx
80104f22:	5e                   	pop    %esi
80104f23:	5d                   	pop    %ebp
  release(&ptable.lock);
80104f24:	e9 c7 11 00 00       	jmp    801060f0 <release>
80104f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cprintf("Process is already in queue %d!\n", dest_Q);
80104f30:	83 ec 08             	sub    $0x8,%esp
80104f33:	56                   	push   %esi
80104f34:	68 04 99 10 80       	push   $0x80109904
80104f39:	e8 c2 b7 ff ff       	call   80100700 <cprintf>
80104f3e:	83 c4 10             	add    $0x10,%esp
80104f41:	eb d4                	jmp    80104f17 <change_queue+0x47>
80104f43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f50 <mycpu>:
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	56                   	push   %esi
80104f54:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104f55:	9c                   	pushf  
80104f56:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104f57:	f6 c4 02             	test   $0x2,%ah
80104f5a:	75 46                	jne    80104fa2 <mycpu+0x52>
  apicid = lapicid();
80104f5c:	e8 9f ed ff ff       	call   80103d00 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104f61:	8b 35 04 3f 11 80    	mov    0x80113f04,%esi
80104f67:	85 f6                	test   %esi,%esi
80104f69:	7e 2a                	jle    80104f95 <mycpu+0x45>
80104f6b:	31 d2                	xor    %edx,%edx
80104f6d:	eb 08                	jmp    80104f77 <mycpu+0x27>
80104f6f:	90                   	nop
80104f70:	83 c2 01             	add    $0x1,%edx
80104f73:	39 f2                	cmp    %esi,%edx
80104f75:	74 1e                	je     80104f95 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80104f77:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80104f7d:	0f b6 99 20 3f 11 80 	movzbl -0x7feec0e0(%ecx),%ebx
80104f84:	39 c3                	cmp    %eax,%ebx
80104f86:	75 e8                	jne    80104f70 <mycpu+0x20>
}
80104f88:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80104f8b:	8d 81 20 3f 11 80    	lea    -0x7feec0e0(%ecx),%eax
}
80104f91:	5b                   	pop    %ebx
80104f92:	5e                   	pop    %esi
80104f93:	5d                   	pop    %ebp
80104f94:	c3                   	ret    
  panic("unknown apicid\n");
80104f95:	83 ec 0c             	sub    $0xc,%esp
80104f98:	68 d4 97 10 80       	push   $0x801097d4
80104f9d:	e8 de b3 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80104fa2:	83 ec 0c             	sub    $0xc,%esp
80104fa5:	68 28 99 10 80       	push   $0x80109928
80104faa:	e8 d1 b3 ff ff       	call   80100380 <panic>
80104faf:	90                   	nop

80104fb0 <cpuid>:
cpuid() {
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80104fb6:	e8 95 ff ff ff       	call   80104f50 <mycpu>
}
80104fbb:	c9                   	leave  
  return mycpu()-cpus;
80104fbc:	2d 20 3f 11 80       	sub    $0x80113f20,%eax
80104fc1:	c1 f8 04             	sar    $0x4,%eax
80104fc4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80104fca:	c3                   	ret    
80104fcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fcf:	90                   	nop

80104fd0 <myproc>:
myproc(void) {
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	53                   	push   %ebx
80104fd4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104fd7:	e8 24 10 00 00       	call   80106000 <pushcli>
  c = mycpu();
80104fdc:	e8 6f ff ff ff       	call   80104f50 <mycpu>
  p = c->proc;
80104fe1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104fe7:	e8 64 10 00 00       	call   80106050 <popcli>
}
80104fec:	89 d8                	mov    %ebx,%eax
80104fee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ff1:	c9                   	leave  
80104ff2:	c3                   	ret    
80104ff3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105000 <userinit>:
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	53                   	push   %ebx
80105004:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80105007:	e8 b4 fb ff ff       	call   80104bc0 <allocproc>
8010500c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010500e:	a3 d4 85 11 80       	mov    %eax,0x801185d4
  if((p->pgdir = setupkvm()) == 0)
80105013:	e8 a8 3e 00 00       	call   80108ec0 <setupkvm>
80105018:	89 43 04             	mov    %eax,0x4(%ebx)
8010501b:	85 c0                	test   %eax,%eax
8010501d:	0f 84 ec 00 00 00    	je     8010510f <userinit+0x10f>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80105023:	83 ec 04             	sub    $0x4,%esp
80105026:	68 2c 00 00 00       	push   $0x2c
8010502b:	68 60 c4 10 80       	push   $0x8010c460
80105030:	50                   	push   %eax
80105031:	e8 3a 3b 00 00       	call   80108b70 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80105036:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80105039:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010503f:	6a 4c                	push   $0x4c
80105041:	6a 00                	push   $0x0
80105043:	ff 73 18             	push   0x18(%ebx)
80105046:	e8 c5 11 00 00       	call   80106210 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010504b:	8b 43 18             	mov    0x18(%ebx),%eax
8010504e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80105053:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80105056:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010505b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010505f:	8b 43 18             	mov    0x18(%ebx),%eax
80105062:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80105066:	8b 43 18             	mov    0x18(%ebx),%eax
80105069:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010506d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80105071:	8b 43 18             	mov    0x18(%ebx),%eax
80105074:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80105078:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010507c:	8b 43 18             	mov    0x18(%ebx),%eax
8010507f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80105086:	8b 43 18             	mov    0x18(%ebx),%eax
80105089:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80105090:	8b 43 18             	mov    0x18(%ebx),%eax
80105093:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010509a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010509d:	6a 10                	push   $0x10
8010509f:	68 fd 97 10 80       	push   $0x801097fd
801050a4:	50                   	push   %eax
801050a5:	e8 26 13 00 00       	call   801063d0 <safestrcpy>
  p->cwd = namei("/");
801050aa:	c7 04 24 06 98 10 80 	movl   $0x80109806,(%esp)
801050b1:	e8 fa e3 ff ff       	call   801034b0 <namei>
801050b6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801050b9:	c7 04 24 a0 45 11 80 	movl   $0x801145a0,(%esp)
801050c0:	e8 8b 10 00 00       	call   80106150 <acquire>
  p->arrival = ticks;
801050c5:	a1 e0 85 11 80       	mov    0x801185e0,%eax
  p->state = RUNNABLE;
801050ca:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  p->level_queue = 0;
801050d1:	c7 83 ec 00 00 00 00 	movl   $0x0,0xec(%ebx)
801050d8:	00 00 00 
  p->arrival = ticks;
801050db:	89 83 f0 00 00 00    	mov    %eax,0xf0(%ebx)
  p->last_exec = ticks;
801050e1:	89 83 f4 00 00 00    	mov    %eax,0xf4(%ebx)
  p->burst = DEFAULT_BURST;
801050e7:	c7 83 f8 00 00 00 02 	movl   $0x2,0xf8(%ebx)
801050ee:	00 00 00 
  p->certainty = DEFAULT_CERTAINTY;
801050f1:	c7 83 fc 00 00 00 32 	movl   $0x32,0xfc(%ebx)
801050f8:	00 00 00 
  release(&ptable.lock);
801050fb:	c7 04 24 a0 45 11 80 	movl   $0x801145a0,(%esp)
80105102:	e8 e9 0f 00 00       	call   801060f0 <release>
}
80105107:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010510a:	83 c4 10             	add    $0x10,%esp
8010510d:	c9                   	leave  
8010510e:	c3                   	ret    
    panic("userinit: out of memory?");
8010510f:	83 ec 0c             	sub    $0xc,%esp
80105112:	68 e4 97 10 80       	push   $0x801097e4
80105117:	e8 64 b2 ff ff       	call   80100380 <panic>
8010511c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105120 <growproc>:
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	56                   	push   %esi
80105124:	53                   	push   %ebx
80105125:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80105128:	e8 d3 0e 00 00       	call   80106000 <pushcli>
  c = mycpu();
8010512d:	e8 1e fe ff ff       	call   80104f50 <mycpu>
  p = c->proc;
80105132:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105138:	e8 13 0f 00 00       	call   80106050 <popcli>
  sz = curproc->sz;
8010513d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
8010513f:	85 f6                	test   %esi,%esi
80105141:	7f 1d                	jg     80105160 <growproc+0x40>
  } else if(n < 0){
80105143:	75 3b                	jne    80105180 <growproc+0x60>
  switchuvm(curproc);
80105145:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80105148:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010514a:	53                   	push   %ebx
8010514b:	e8 10 39 00 00       	call   80108a60 <switchuvm>
  return 0;
80105150:	83 c4 10             	add    $0x10,%esp
80105153:	31 c0                	xor    %eax,%eax
}
80105155:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105158:	5b                   	pop    %ebx
80105159:	5e                   	pop    %esi
8010515a:	5d                   	pop    %ebp
8010515b:	c3                   	ret    
8010515c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80105160:	83 ec 04             	sub    $0x4,%esp
80105163:	01 c6                	add    %eax,%esi
80105165:	56                   	push   %esi
80105166:	50                   	push   %eax
80105167:	ff 73 04             	push   0x4(%ebx)
8010516a:	e8 71 3b 00 00       	call   80108ce0 <allocuvm>
8010516f:	83 c4 10             	add    $0x10,%esp
80105172:	85 c0                	test   %eax,%eax
80105174:	75 cf                	jne    80105145 <growproc+0x25>
      return -1;
80105176:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010517b:	eb d8                	jmp    80105155 <growproc+0x35>
8010517d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80105180:	83 ec 04             	sub    $0x4,%esp
80105183:	01 c6                	add    %eax,%esi
80105185:	56                   	push   %esi
80105186:	50                   	push   %eax
80105187:	ff 73 04             	push   0x4(%ebx)
8010518a:	e8 81 3c 00 00       	call   80108e10 <deallocuvm>
8010518f:	83 c4 10             	add    $0x10,%esp
80105192:	85 c0                	test   %eax,%eax
80105194:	75 af                	jne    80105145 <growproc+0x25>
80105196:	eb de                	jmp    80105176 <growproc+0x56>
80105198:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010519f:	90                   	nop

801051a0 <fork>:
{
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	57                   	push   %edi
801051a4:	56                   	push   %esi
801051a5:	53                   	push   %ebx
801051a6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801051a9:	e8 52 0e 00 00       	call   80106000 <pushcli>
  c = mycpu();
801051ae:	e8 9d fd ff ff       	call   80104f50 <mycpu>
  p = c->proc;
801051b3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801051b9:	e8 92 0e 00 00       	call   80106050 <popcli>
  if((np = allocproc()) == 0){
801051be:	e8 fd f9 ff ff       	call   80104bc0 <allocproc>
801051c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801051c6:	85 c0                	test   %eax,%eax
801051c8:	0f 84 c4 00 00 00    	je     80105292 <fork+0xf2>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801051ce:	83 ec 08             	sub    $0x8,%esp
801051d1:	ff 33                	push   (%ebx)
801051d3:	89 c7                	mov    %eax,%edi
801051d5:	ff 73 04             	push   0x4(%ebx)
801051d8:	e8 d3 3d 00 00       	call   80108fb0 <copyuvm>
801051dd:	83 c4 10             	add    $0x10,%esp
801051e0:	89 47 04             	mov    %eax,0x4(%edi)
801051e3:	85 c0                	test   %eax,%eax
801051e5:	0f 84 ae 00 00 00    	je     80105299 <fork+0xf9>
  np->sz = curproc->sz;
801051eb:	8b 03                	mov    (%ebx),%eax
801051ed:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801051f0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
801051f2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
801051f5:	89 c8                	mov    %ecx,%eax
801051f7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801051fa:	b9 13 00 00 00       	mov    $0x13,%ecx
801051ff:	8b 73 18             	mov    0x18(%ebx),%esi
80105202:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80105204:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80105206:	8b 40 18             	mov    0x18(%eax),%eax
80105209:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80105210:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80105214:	85 c0                	test   %eax,%eax
80105216:	74 13                	je     8010522b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80105218:	83 ec 0c             	sub    $0xc,%esp
8010521b:	50                   	push   %eax
8010521c:	e8 8f d0 ff ff       	call   801022b0 <filedup>
80105221:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105224:	83 c4 10             	add    $0x10,%esp
80105227:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010522b:	83 c6 01             	add    $0x1,%esi
8010522e:	83 fe 10             	cmp    $0x10,%esi
80105231:	75 dd                	jne    80105210 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80105233:	83 ec 0c             	sub    $0xc,%esp
80105236:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80105239:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010523c:	e8 1f d9 ff ff       	call   80102b60 <idup>
80105241:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80105244:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80105247:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010524a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010524d:	6a 10                	push   $0x10
8010524f:	53                   	push   %ebx
80105250:	50                   	push   %eax
80105251:	e8 7a 11 00 00       	call   801063d0 <safestrcpy>
  pid = np->pid;
80105256:	8b 5f 10             	mov    0x10(%edi),%ebx
  cprintf("pid %d forked\n", pid);
80105259:	58                   	pop    %eax
8010525a:	5a                   	pop    %edx
8010525b:	53                   	push   %ebx
8010525c:	68 08 98 10 80       	push   $0x80109808
80105261:	e8 9a b4 ff ff       	call   80100700 <cprintf>
  acquire(&ptable.lock);
80105266:	c7 04 24 a0 45 11 80 	movl   $0x801145a0,(%esp)
8010526d:	e8 de 0e 00 00       	call   80106150 <acquire>
  np->state = RUNNABLE;
80105272:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80105279:	c7 04 24 a0 45 11 80 	movl   $0x801145a0,(%esp)
80105280:	e8 6b 0e 00 00       	call   801060f0 <release>
  return pid;
80105285:	83 c4 10             	add    $0x10,%esp
}
80105288:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010528b:	89 d8                	mov    %ebx,%eax
8010528d:	5b                   	pop    %ebx
8010528e:	5e                   	pop    %esi
8010528f:	5f                   	pop    %edi
80105290:	5d                   	pop    %ebp
80105291:	c3                   	ret    
    return -1;
80105292:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105297:	eb ef                	jmp    80105288 <fork+0xe8>
    kfree(np->kstack);
80105299:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010529c:	83 ec 0c             	sub    $0xc,%esp
8010529f:	ff 73 08             	push   0x8(%ebx)
801052a2:	e8 29 e6 ff ff       	call   801038d0 <kfree>
    np->kstack = 0;
801052a7:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
801052ae:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
801052b1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801052b8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801052bd:	eb c9                	jmp    80105288 <fork+0xe8>
801052bf:	90                   	nop

801052c0 <find_min_last_exec>:
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801052c0:	b8 d4 45 11 80       	mov    $0x801145d4,%eax
801052c5:	8d 76 00             	lea    0x0(%esi),%esi
      if((p->level_queue == 0) && (p->pid != 0) && (p->state == RUNNABLE))
801052c8:	8b 88 ec 00 00 00    	mov    0xec(%eax),%ecx
801052ce:	85 c9                	test   %ecx,%ecx
801052d0:	75 0d                	jne    801052df <find_min_last_exec+0x1f>
801052d2:	8b 50 10             	mov    0x10(%eax),%edx
801052d5:	85 d2                	test   %edx,%edx
801052d7:	74 06                	je     801052df <find_min_last_exec+0x1f>
801052d9:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801052dd:	74 50                	je     8010532f <find_min_last_exec+0x6f>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801052df:	05 00 01 00 00       	add    $0x100,%eax
801052e4:	3d d4 85 11 80       	cmp    $0x801185d4,%eax
801052e9:	75 dd                	jne    801052c8 <find_min_last_exec+0x8>
  int min = 0;
801052eb:	31 d2                	xor    %edx,%edx
801052ed:	b8 d4 45 11 80       	mov    $0x801145d4,%eax
801052f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if((p->level_queue == 0) && (p->pid != 0) && (p->state == RUNNABLE))
801052f8:	8b 88 ec 00 00 00    	mov    0xec(%eax),%ecx
801052fe:	85 c9                	test   %ecx,%ecx
80105300:	75 1e                	jne    80105320 <find_min_last_exec+0x60>
80105302:	8b 48 10             	mov    0x10(%eax),%ecx
80105305:	85 c9                	test   %ecx,%ecx
80105307:	74 17                	je     80105320 <find_min_last_exec+0x60>
80105309:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010530d:	75 11                	jne    80105320 <find_min_last_exec+0x60>
        if(p->last_exec < min)
8010530f:	8b 88 f4 00 00 00    	mov    0xf4(%eax),%ecx
80105315:	39 ca                	cmp    %ecx,%edx
80105317:	0f 4f d1             	cmovg  %ecx,%edx
8010531a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105320:	05 00 01 00 00       	add    $0x100,%eax
80105325:	3d d4 85 11 80       	cmp    $0x801185d4,%eax
8010532a:	75 cc                	jne    801052f8 <find_min_last_exec+0x38>
}
8010532c:	89 d0                	mov    %edx,%eax
8010532e:	c3                   	ret    
        min = p->last_exec;
8010532f:	8b 90 f4 00 00 00    	mov    0xf4(%eax),%edx
        break;
80105335:	eb b6                	jmp    801052ed <find_min_last_exec+0x2d>
80105337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010533e:	66 90                	xchg   %ax,%ax

80105340 <find_first_come>:
{
80105340:	55                   	push   %ebp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105341:	b8 d4 45 11 80       	mov    $0x801145d4,%eax
{
80105346:	89 e5                	mov    %esp,%ebp
80105348:	56                   	push   %esi
80105349:	53                   	push   %ebx
8010534a:	eb 10                	jmp    8010535c <find_first_come+0x1c>
8010534c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105350:	05 00 01 00 00       	add    $0x100,%eax
80105355:	3d d4 85 11 80       	cmp    $0x801185d4,%eax
8010535a:	74 1e                	je     8010537a <find_first_come+0x3a>
      if((p->level_queue == 2) && (p->pid != 0) && (p->state == RUNNABLE))
8010535c:	83 b8 ec 00 00 00 02 	cmpl   $0x2,0xec(%eax)
80105363:	75 eb                	jne    80105350 <find_first_come+0x10>
80105365:	8b 48 10             	mov    0x10(%eax),%ecx
80105368:	85 c9                	test   %ecx,%ecx
8010536a:	74 e4                	je     80105350 <find_first_come+0x10>
8010536c:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80105370:	75 de                	jne    80105350 <find_first_come+0x10>
        FC = p->arrival;
80105372:	8b b0 f0 00 00 00    	mov    0xf0(%eax),%esi
        break;
80105378:	eb 07                	jmp    80105381 <find_first_come+0x41>
  int pid = -10;
8010537a:	b9 f6 ff ff ff       	mov    $0xfffffff6,%ecx
  int FC = 0;
8010537f:	31 f6                	xor    %esi,%esi
80105381:	b8 d4 45 11 80       	mov    $0x801145d4,%eax
80105386:	eb 14                	jmp    8010539c <find_first_come+0x5c>
80105388:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010538f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105390:	05 00 01 00 00       	add    $0x100,%eax
80105395:	3d d4 85 11 80       	cmp    $0x801185d4,%eax
8010539a:	74 30                	je     801053cc <find_first_come+0x8c>
      if((p->level_queue == 2) && (p->pid != 0) && (p->state == RUNNABLE))
8010539c:	83 b8 ec 00 00 00 02 	cmpl   $0x2,0xec(%eax)
801053a3:	75 eb                	jne    80105390 <find_first_come+0x50>
801053a5:	8b 50 10             	mov    0x10(%eax),%edx
801053a8:	85 d2                	test   %edx,%edx
801053aa:	74 e4                	je     80105390 <find_first_come+0x50>
801053ac:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801053b0:	75 de                	jne    80105390 <find_first_come+0x50>
        if(p->arrival < FC)
801053b2:	8b 98 f0 00 00 00    	mov    0xf0(%eax),%ebx
801053b8:	39 f3                	cmp    %esi,%ebx
801053ba:	7d d4                	jge    80105390 <find_first_come+0x50>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801053bc:	05 00 01 00 00       	add    $0x100,%eax
        if(p->arrival < FC)
801053c1:	89 d1                	mov    %edx,%ecx
801053c3:	89 de                	mov    %ebx,%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801053c5:	3d d4 85 11 80       	cmp    $0x801185d4,%eax
801053ca:	75 d0                	jne    8010539c <find_first_come+0x5c>
  cprintf("FIRST COME IS %d BY ARRIVAL %d\n", pid, FC);
801053cc:	83 ec 04             	sub    $0x4,%esp
801053cf:	56                   	push   %esi
801053d0:	51                   	push   %ecx
801053d1:	68 50 99 10 80       	push   $0x80109950
801053d6:	e8 25 b3 ff ff       	call   80100700 <cprintf>
}
801053db:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053de:	89 f0                	mov    %esi,%eax
801053e0:	5b                   	pop    %ebx
801053e1:	5e                   	pop    %esi
801053e2:	5d                   	pop    %ebp
801053e3:	c3                   	ret    
801053e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053ef:	90                   	nop

801053f0 <scheduler>:
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	57                   	push   %edi
801053f4:	56                   	push   %esi
801053f5:	53                   	push   %ebx
801053f6:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
801053f9:	e8 52 fb ff ff       	call   80104f50 <mycpu>
  c->proc = 0;
801053fe:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80105405:	00 00 00 
  struct cpu *c = mycpu();
80105408:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  c->proc = 0;
8010540b:	83 c0 04             	add    $0x4,%eax
8010540e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  asm volatile("sti");
80105411:	fb                   	sti    
    acquire(&ptable.lock);
80105412:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105415:	bb d4 45 11 80       	mov    $0x801145d4,%ebx
    acquire(&ptable.lock);
8010541a:	68 a0 45 11 80       	push   $0x801145a0
8010541f:	e8 2c 0d 00 00       	call   80106150 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105424:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80105427:	8b 7d e0             	mov    -0x20(%ebp),%edi
    acquire(&ptable.lock);
8010542a:	83 c4 10             	add    $0x10,%esp
8010542d:	eb 0f                	jmp    8010543e <scheduler+0x4e>
8010542f:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105430:	81 c3 00 01 00 00    	add    $0x100,%ebx
80105436:	81 fb d4 85 11 80    	cmp    $0x801185d4,%ebx
8010543c:	74 6c                	je     801054aa <scheduler+0xba>
      if((p->state != RUNNABLE) || (p->level_queue != 0))
8010543e:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80105442:	75 ec                	jne    80105430 <scheduler+0x40>
80105444:	8b 8b ec 00 00 00    	mov    0xec(%ebx),%ecx
8010544a:	85 c9                	test   %ecx,%ecx
8010544c:	75 e2                	jne    80105430 <scheduler+0x40>
      int min_last_exec = find_min_last_exec();
8010544e:	e8 6d fe ff ff       	call   801052c0 <find_min_last_exec>
      if(p->last_exec == min_last_exec)
80105453:	39 83 f4 00 00 00    	cmp    %eax,0xf4(%ebx)
80105459:	75 d5                	jne    80105430 <scheduler+0x40>
        switchuvm(p);
8010545b:	83 ec 0c             	sub    $0xc,%esp
        c->proc = p;
8010545e:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
        switchuvm(p);
80105464:	53                   	push   %ebx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105465:	81 c3 00 01 00 00    	add    $0x100,%ebx
        switchuvm(p);
8010546b:	e8 f0 35 00 00       	call   80108a60 <switchuvm>
        p->state = RUNNING;
80105470:	c7 83 0c ff ff ff 04 	movl   $0x4,-0xf4(%ebx)
80105477:	00 00 00 
        swtch(&(c->scheduler), p->context);
8010547a:	58                   	pop    %eax
8010547b:	5a                   	pop    %edx
8010547c:	ff b3 1c ff ff ff    	push   -0xe4(%ebx)
80105482:	57                   	push   %edi
80105483:	e8 a3 0f 00 00       	call   8010642b <swtch>
        p->last_exec = ticks;
80105488:	a1 e0 85 11 80       	mov    0x801185e0,%eax
8010548d:	89 43 f4             	mov    %eax,-0xc(%ebx)
        switchkvm();
80105490:	e8 bb 35 00 00       	call   80108a50 <switchkvm>
        c->proc = 0;
80105495:	83 c4 10             	add    $0x10,%esp
80105498:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
8010549f:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801054a2:	81 fb d4 85 11 80    	cmp    $0x801185d4,%ebx
801054a8:	75 94                	jne    8010543e <scheduler+0x4e>
801054aa:	bb 40 00 00 00       	mov    $0x40,%ebx
801054af:	eb 10                	jmp    801054c1 <scheduler+0xd1>
801054b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(int j = 0; j < NPROC; j++){
801054b8:	83 eb 01             	sub    $0x1,%ebx
801054bb:	0f 84 92 00 00 00    	je     80105553 <scheduler+0x163>
      int count = sort_pcbs_by_burst();
801054c1:	e8 9a f8 ff ff       	call   80104d60 <sort_pcbs_by_burst>
801054c6:	89 c1                	mov    %eax,%ecx
      if(count > 0){
801054c8:	85 c0                	test   %eax,%eax
801054ca:	7e ec                	jle    801054b8 <scheduler+0xc8>
      int seed = (ticks * 17) % 100;
801054cc:	a1 e0 85 11 80       	mov    0x801185e0,%eax
        struct proc *p = sorted_procs[count - 1];
801054d1:	8b 3c 8d 9c 44 11 80 	mov    -0x7feebb64(,%ecx,4),%edi
      int seed = (ticks * 17) % 100;
801054d8:	89 c6                	mov    %eax,%esi
801054da:	c1 e6 04             	shl    $0x4,%esi
801054dd:	01 c6                	add    %eax,%esi
801054df:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
801054e4:	f7 e6                	mul    %esi
801054e6:	c1 ea 05             	shr    $0x5,%edx
801054e9:	6b c2 64             	imul   $0x64,%edx,%eax
801054ec:	89 f2                	mov    %esi,%edx
801054ee:	29 c2                	sub    %eax,%edx
        for (int i = 0; i < count; i++) {
801054f0:	31 c0                	xor    %eax,%eax
801054f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            if (sorted_procs[i]->certainty > seed) {
801054f8:	8b 34 85 a0 44 11 80 	mov    -0x7feebb60(,%eax,4),%esi
801054ff:	39 96 fc 00 00 00    	cmp    %edx,0xfc(%esi)
80105505:	0f 8f dd 00 00 00    	jg     801055e8 <scheduler+0x1f8>
        for (int i = 0; i < count; i++) {
8010550b:	83 c0 01             	add    $0x1,%eax
8010550e:	39 c1                	cmp    %eax,%ecx
80105510:	75 e6                	jne    801054f8 <scheduler+0x108>
        c->proc = p;
80105512:	8b 75 e4             	mov    -0x1c(%ebp),%esi
        switchuvm(p);
80105515:	83 ec 0c             	sub    $0xc,%esp
        c->proc = p;
80105518:	89 be ac 00 00 00    	mov    %edi,0xac(%esi)
        switchuvm(p);
8010551e:	57                   	push   %edi
8010551f:	e8 3c 35 00 00       	call   80108a60 <switchuvm>
        p->state = RUNNING;
80105524:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
        swtch(&(c->scheduler), p->context);
8010552b:	59                   	pop    %ecx
8010552c:	58                   	pop    %eax
8010552d:	ff 77 1c             	push   0x1c(%edi)
80105530:	ff 75 e0             	push   -0x20(%ebp)
80105533:	e8 f3 0e 00 00       	call   8010642b <swtch>
        switchkvm();
80105538:	e8 13 35 00 00       	call   80108a50 <switchkvm>
        c->proc = 0;
8010553d:	83 c4 10             	add    $0x10,%esp
80105540:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80105547:	00 00 00 
    for(int j = 0; j < NPROC; j++){
8010554a:	83 eb 01             	sub    $0x1,%ebx
8010554d:	0f 85 6e ff ff ff    	jne    801054c1 <scheduler+0xd1>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105553:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80105556:	8b 7d e0             	mov    -0x20(%ebp),%edi
80105559:	bb d4 45 11 80       	mov    $0x801145d4,%ebx
8010555e:	eb 0e                	jmp    8010556e <scheduler+0x17e>
80105560:	81 c3 00 01 00 00    	add    $0x100,%ebx
80105566:	81 fb d4 85 11 80    	cmp    $0x801185d4,%ebx
8010556c:	74 5e                	je     801055cc <scheduler+0x1dc>
      if((p->state != RUNNABLE) || (p->level_queue != 2))
8010556e:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80105572:	75 ec                	jne    80105560 <scheduler+0x170>
80105574:	83 bb ec 00 00 00 02 	cmpl   $0x2,0xec(%ebx)
8010557b:	75 e3                	jne    80105560 <scheduler+0x170>
      int first_come = find_first_come();
8010557d:	e8 be fd ff ff       	call   80105340 <find_first_come>
      if(p->arrival == first_come)
80105582:	39 83 f0 00 00 00    	cmp    %eax,0xf0(%ebx)
80105588:	75 d6                	jne    80105560 <scheduler+0x170>
        switchuvm(p);
8010558a:	83 ec 0c             	sub    $0xc,%esp
        c->proc = p;
8010558d:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
        switchuvm(p);
80105593:	53                   	push   %ebx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105594:	81 c3 00 01 00 00    	add    $0x100,%ebx
        switchuvm(p);
8010559a:	e8 c1 34 00 00       	call   80108a60 <switchuvm>
        p->state = RUNNING;
8010559f:	c7 83 0c ff ff ff 04 	movl   $0x4,-0xf4(%ebx)
801055a6:	00 00 00 
        swtch(&(c->scheduler), p->context);
801055a9:	58                   	pop    %eax
801055aa:	5a                   	pop    %edx
801055ab:	ff b3 1c ff ff ff    	push   -0xe4(%ebx)
801055b1:	57                   	push   %edi
801055b2:	e8 74 0e 00 00       	call   8010642b <swtch>
        c->proc = 0;
801055b7:	83 c4 10             	add    $0x10,%esp
801055ba:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801055c1:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801055c4:	81 fb d4 85 11 80    	cmp    $0x801185d4,%ebx
801055ca:	75 a2                	jne    8010556e <scheduler+0x17e>
    release(&ptable.lock);
801055cc:	83 ec 0c             	sub    $0xc,%esp
801055cf:	68 a0 45 11 80       	push   $0x801145a0
801055d4:	e8 17 0b 00 00       	call   801060f0 <release>
    sti();
801055d9:	83 c4 10             	add    $0x10,%esp
801055dc:	e9 30 fe ff ff       	jmp    80105411 <scheduler+0x21>
801055e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055e8:	89 f7                	mov    %esi,%edi
801055ea:	e9 23 ff ff ff       	jmp    80105512 <scheduler+0x122>
801055ef:	90                   	nop

801055f0 <sched>:
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	56                   	push   %esi
801055f4:	53                   	push   %ebx
  pushcli();
801055f5:	e8 06 0a 00 00       	call   80106000 <pushcli>
  c = mycpu();
801055fa:	e8 51 f9 ff ff       	call   80104f50 <mycpu>
  p = c->proc;
801055ff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105605:	e8 46 0a 00 00       	call   80106050 <popcli>
  if(!holding(&ptable.lock))
8010560a:	83 ec 0c             	sub    $0xc,%esp
8010560d:	68 a0 45 11 80       	push   $0x801145a0
80105612:	e8 99 0a 00 00       	call   801060b0 <holding>
80105617:	83 c4 10             	add    $0x10,%esp
8010561a:	85 c0                	test   %eax,%eax
8010561c:	74 4f                	je     8010566d <sched+0x7d>
  if(mycpu()->ncli != 1)
8010561e:	e8 2d f9 ff ff       	call   80104f50 <mycpu>
80105623:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010562a:	75 68                	jne    80105694 <sched+0xa4>
  if(p->state == RUNNING)
8010562c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80105630:	74 55                	je     80105687 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105632:	9c                   	pushf  
80105633:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105634:	f6 c4 02             	test   $0x2,%ah
80105637:	75 41                	jne    8010567a <sched+0x8a>
  intena = mycpu()->intena;
80105639:	e8 12 f9 ff ff       	call   80104f50 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010563e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80105641:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80105647:	e8 04 f9 ff ff       	call   80104f50 <mycpu>
8010564c:	83 ec 08             	sub    $0x8,%esp
8010564f:	ff 70 04             	push   0x4(%eax)
80105652:	53                   	push   %ebx
80105653:	e8 d3 0d 00 00       	call   8010642b <swtch>
  mycpu()->intena = intena;
80105658:	e8 f3 f8 ff ff       	call   80104f50 <mycpu>
}
8010565d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80105660:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80105666:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105669:	5b                   	pop    %ebx
8010566a:	5e                   	pop    %esi
8010566b:	5d                   	pop    %ebp
8010566c:	c3                   	ret    
    panic("sched ptable.lock");
8010566d:	83 ec 0c             	sub    $0xc,%esp
80105670:	68 17 98 10 80       	push   $0x80109817
80105675:	e8 06 ad ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010567a:	83 ec 0c             	sub    $0xc,%esp
8010567d:	68 43 98 10 80       	push   $0x80109843
80105682:	e8 f9 ac ff ff       	call   80100380 <panic>
    panic("sched running");
80105687:	83 ec 0c             	sub    $0xc,%esp
8010568a:	68 35 98 10 80       	push   $0x80109835
8010568f:	e8 ec ac ff ff       	call   80100380 <panic>
    panic("sched locks");
80105694:	83 ec 0c             	sub    $0xc,%esp
80105697:	68 29 98 10 80       	push   $0x80109829
8010569c:	e8 df ac ff ff       	call   80100380 <panic>
801056a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056af:	90                   	nop

801056b0 <exit>:
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	57                   	push   %edi
801056b4:	56                   	push   %esi
801056b5:	53                   	push   %ebx
801056b6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
801056b9:	e8 12 f9 ff ff       	call   80104fd0 <myproc>
  if(curproc == initproc)
801056be:	39 05 d4 85 11 80    	cmp    %eax,0x801185d4
801056c4:	0f 84 07 01 00 00    	je     801057d1 <exit+0x121>
801056ca:	89 c3                	mov    %eax,%ebx
801056cc:	8d 70 28             	lea    0x28(%eax),%esi
801056cf:	8d 78 68             	lea    0x68(%eax),%edi
801056d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
801056d8:	8b 06                	mov    (%esi),%eax
801056da:	85 c0                	test   %eax,%eax
801056dc:	74 12                	je     801056f0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
801056de:	83 ec 0c             	sub    $0xc,%esp
801056e1:	50                   	push   %eax
801056e2:	e8 19 cc ff ff       	call   80102300 <fileclose>
      curproc->ofile[fd] = 0;
801056e7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801056ed:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801056f0:	83 c6 04             	add    $0x4,%esi
801056f3:	39 f7                	cmp    %esi,%edi
801056f5:	75 e1                	jne    801056d8 <exit+0x28>
  begin_op();
801056f7:	e8 74 ea ff ff       	call   80104170 <begin_op>
  iput(curproc->cwd);
801056fc:	83 ec 0c             	sub    $0xc,%esp
801056ff:	ff 73 68             	push   0x68(%ebx)
80105702:	e8 b9 d5 ff ff       	call   80102cc0 <iput>
  end_op();
80105707:	e8 d4 ea ff ff       	call   801041e0 <end_op>
  curproc->cwd = 0;
8010570c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80105713:	c7 04 24 a0 45 11 80 	movl   $0x801145a0,(%esp)
8010571a:	e8 31 0a 00 00       	call   80106150 <acquire>
  wakeup1(curproc->parent);
8010571f:	8b 53 14             	mov    0x14(%ebx),%edx
80105722:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105725:	b8 d4 45 11 80       	mov    $0x801145d4,%eax
8010572a:	eb 10                	jmp    8010573c <exit+0x8c>
8010572c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105730:	05 00 01 00 00       	add    $0x100,%eax
80105735:	3d d4 85 11 80       	cmp    $0x801185d4,%eax
8010573a:	74 1e                	je     8010575a <exit+0xaa>
    if(p->state == SLEEPING && p->chan == chan)
8010573c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80105740:	75 ee                	jne    80105730 <exit+0x80>
80105742:	3b 50 20             	cmp    0x20(%eax),%edx
80105745:	75 e9                	jne    80105730 <exit+0x80>
      p->state = RUNNABLE;
80105747:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010574e:	05 00 01 00 00       	add    $0x100,%eax
80105753:	3d d4 85 11 80       	cmp    $0x801185d4,%eax
80105758:	75 e2                	jne    8010573c <exit+0x8c>
      p->parent = initproc;
8010575a:	8b 0d d4 85 11 80    	mov    0x801185d4,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105760:	ba d4 45 11 80       	mov    $0x801145d4,%edx
80105765:	eb 17                	jmp    8010577e <exit+0xce>
80105767:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010576e:	66 90                	xchg   %ax,%ax
80105770:	81 c2 00 01 00 00    	add    $0x100,%edx
80105776:	81 fa d4 85 11 80    	cmp    $0x801185d4,%edx
8010577c:	74 3a                	je     801057b8 <exit+0x108>
    if(p->parent == curproc){
8010577e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80105781:	75 ed                	jne    80105770 <exit+0xc0>
      if(p->state == ZOMBIE)
80105783:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80105787:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010578a:	75 e4                	jne    80105770 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010578c:	b8 d4 45 11 80       	mov    $0x801145d4,%eax
80105791:	eb 11                	jmp    801057a4 <exit+0xf4>
80105793:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105797:	90                   	nop
80105798:	05 00 01 00 00       	add    $0x100,%eax
8010579d:	3d d4 85 11 80       	cmp    $0x801185d4,%eax
801057a2:	74 cc                	je     80105770 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
801057a4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801057a8:	75 ee                	jne    80105798 <exit+0xe8>
801057aa:	3b 48 20             	cmp    0x20(%eax),%ecx
801057ad:	75 e9                	jne    80105798 <exit+0xe8>
      p->state = RUNNABLE;
801057af:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801057b6:	eb e0                	jmp    80105798 <exit+0xe8>
  curproc->state = ZOMBIE;
801057b8:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801057bf:	e8 2c fe ff ff       	call   801055f0 <sched>
  panic("zombie exit");
801057c4:	83 ec 0c             	sub    $0xc,%esp
801057c7:	68 64 98 10 80       	push   $0x80109864
801057cc:	e8 af ab ff ff       	call   80100380 <panic>
    panic("init exiting");
801057d1:	83 ec 0c             	sub    $0xc,%esp
801057d4:	68 57 98 10 80       	push   $0x80109857
801057d9:	e8 a2 ab ff ff       	call   80100380 <panic>
801057de:	66 90                	xchg   %ax,%ax

801057e0 <wait>:
{
801057e0:	55                   	push   %ebp
801057e1:	89 e5                	mov    %esp,%ebp
801057e3:	56                   	push   %esi
801057e4:	53                   	push   %ebx
  pushcli();
801057e5:	e8 16 08 00 00       	call   80106000 <pushcli>
  c = mycpu();
801057ea:	e8 61 f7 ff ff       	call   80104f50 <mycpu>
  p = c->proc;
801057ef:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801057f5:	e8 56 08 00 00       	call   80106050 <popcli>
  acquire(&ptable.lock);
801057fa:	83 ec 0c             	sub    $0xc,%esp
801057fd:	68 a0 45 11 80       	push   $0x801145a0
80105802:	e8 49 09 00 00       	call   80106150 <acquire>
80105807:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010580a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010580c:	bb d4 45 11 80       	mov    $0x801145d4,%ebx
80105811:	eb 13                	jmp    80105826 <wait+0x46>
80105813:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105817:	90                   	nop
80105818:	81 c3 00 01 00 00    	add    $0x100,%ebx
8010581e:	81 fb d4 85 11 80    	cmp    $0x801185d4,%ebx
80105824:	74 1e                	je     80105844 <wait+0x64>
      if(p->parent != curproc)
80105826:	39 73 14             	cmp    %esi,0x14(%ebx)
80105829:	75 ed                	jne    80105818 <wait+0x38>
      if(p->state == ZOMBIE){
8010582b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010582f:	74 5f                	je     80105890 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105831:	81 c3 00 01 00 00    	add    $0x100,%ebx
      havekids = 1;
80105837:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010583c:	81 fb d4 85 11 80    	cmp    $0x801185d4,%ebx
80105842:	75 e2                	jne    80105826 <wait+0x46>
    if(!havekids || curproc->killed){
80105844:	85 c0                	test   %eax,%eax
80105846:	0f 84 9a 00 00 00    	je     801058e6 <wait+0x106>
8010584c:	8b 46 24             	mov    0x24(%esi),%eax
8010584f:	85 c0                	test   %eax,%eax
80105851:	0f 85 8f 00 00 00    	jne    801058e6 <wait+0x106>
  pushcli();
80105857:	e8 a4 07 00 00       	call   80106000 <pushcli>
  c = mycpu();
8010585c:	e8 ef f6 ff ff       	call   80104f50 <mycpu>
  p = c->proc;
80105861:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105867:	e8 e4 07 00 00       	call   80106050 <popcli>
  if(p == 0)
8010586c:	85 db                	test   %ebx,%ebx
8010586e:	0f 84 89 00 00 00    	je     801058fd <wait+0x11d>
  p->chan = chan;
80105874:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80105877:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010587e:	e8 6d fd ff ff       	call   801055f0 <sched>
  p->chan = 0;
80105883:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010588a:	e9 7b ff ff ff       	jmp    8010580a <wait+0x2a>
8010588f:	90                   	nop
        kfree(p->kstack);
80105890:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80105893:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80105896:	ff 73 08             	push   0x8(%ebx)
80105899:	e8 32 e0 ff ff       	call   801038d0 <kfree>
        p->kstack = 0;
8010589e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801058a5:	5a                   	pop    %edx
801058a6:	ff 73 04             	push   0x4(%ebx)
801058a9:	e8 92 35 00 00       	call   80108e40 <freevm>
        p->pid = 0;
801058ae:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801058b5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801058bc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801058c0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801058c7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801058ce:	c7 04 24 a0 45 11 80 	movl   $0x801145a0,(%esp)
801058d5:	e8 16 08 00 00       	call   801060f0 <release>
        return pid;
801058da:	83 c4 10             	add    $0x10,%esp
}
801058dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058e0:	89 f0                	mov    %esi,%eax
801058e2:	5b                   	pop    %ebx
801058e3:	5e                   	pop    %esi
801058e4:	5d                   	pop    %ebp
801058e5:	c3                   	ret    
      release(&ptable.lock);
801058e6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801058e9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801058ee:	68 a0 45 11 80       	push   $0x801145a0
801058f3:	e8 f8 07 00 00       	call   801060f0 <release>
      return -1;
801058f8:	83 c4 10             	add    $0x10,%esp
801058fb:	eb e0                	jmp    801058dd <wait+0xfd>
    panic("sleep");
801058fd:	83 ec 0c             	sub    $0xc,%esp
80105900:	68 70 98 10 80       	push   $0x80109870
80105905:	e8 76 aa ff ff       	call   80100380 <panic>
8010590a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105910 <yield>:
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	53                   	push   %ebx
80105914:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80105917:	68 a0 45 11 80       	push   $0x801145a0
8010591c:	e8 2f 08 00 00       	call   80106150 <acquire>
  pushcli();
80105921:	e8 da 06 00 00       	call   80106000 <pushcli>
  c = mycpu();
80105926:	e8 25 f6 ff ff       	call   80104f50 <mycpu>
  p = c->proc;
8010592b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105931:	e8 1a 07 00 00       	call   80106050 <popcli>
  myproc()->state = RUNNABLE;
80105936:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010593d:	e8 ae fc ff ff       	call   801055f0 <sched>
  release(&ptable.lock);
80105942:	c7 04 24 a0 45 11 80 	movl   $0x801145a0,(%esp)
80105949:	e8 a2 07 00 00       	call   801060f0 <release>
}
8010594e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105951:	83 c4 10             	add    $0x10,%esp
80105954:	c9                   	leave  
80105955:	c3                   	ret    
80105956:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010595d:	8d 76 00             	lea    0x0(%esi),%esi

80105960 <sleep>:
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	57                   	push   %edi
80105964:	56                   	push   %esi
80105965:	53                   	push   %ebx
80105966:	83 ec 0c             	sub    $0xc,%esp
80105969:	8b 7d 08             	mov    0x8(%ebp),%edi
8010596c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010596f:	e8 8c 06 00 00       	call   80106000 <pushcli>
  c = mycpu();
80105974:	e8 d7 f5 ff ff       	call   80104f50 <mycpu>
  p = c->proc;
80105979:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010597f:	e8 cc 06 00 00       	call   80106050 <popcli>
  if(p == 0)
80105984:	85 db                	test   %ebx,%ebx
80105986:	0f 84 87 00 00 00    	je     80105a13 <sleep+0xb3>
  if(lk == 0)
8010598c:	85 f6                	test   %esi,%esi
8010598e:	74 76                	je     80105a06 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80105990:	81 fe a0 45 11 80    	cmp    $0x801145a0,%esi
80105996:	74 50                	je     801059e8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80105998:	83 ec 0c             	sub    $0xc,%esp
8010599b:	68 a0 45 11 80       	push   $0x801145a0
801059a0:	e8 ab 07 00 00       	call   80106150 <acquire>
    release(lk);
801059a5:	89 34 24             	mov    %esi,(%esp)
801059a8:	e8 43 07 00 00       	call   801060f0 <release>
  p->chan = chan;
801059ad:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801059b0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801059b7:	e8 34 fc ff ff       	call   801055f0 <sched>
  p->chan = 0;
801059bc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801059c3:	c7 04 24 a0 45 11 80 	movl   $0x801145a0,(%esp)
801059ca:	e8 21 07 00 00       	call   801060f0 <release>
    acquire(lk);
801059cf:	89 75 08             	mov    %esi,0x8(%ebp)
801059d2:	83 c4 10             	add    $0x10,%esp
}
801059d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059d8:	5b                   	pop    %ebx
801059d9:	5e                   	pop    %esi
801059da:	5f                   	pop    %edi
801059db:	5d                   	pop    %ebp
    acquire(lk);
801059dc:	e9 6f 07 00 00       	jmp    80106150 <acquire>
801059e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801059e8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801059eb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801059f2:	e8 f9 fb ff ff       	call   801055f0 <sched>
  p->chan = 0;
801059f7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801059fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a01:	5b                   	pop    %ebx
80105a02:	5e                   	pop    %esi
80105a03:	5f                   	pop    %edi
80105a04:	5d                   	pop    %ebp
80105a05:	c3                   	ret    
    panic("sleep without lk");
80105a06:	83 ec 0c             	sub    $0xc,%esp
80105a09:	68 76 98 10 80       	push   $0x80109876
80105a0e:	e8 6d a9 ff ff       	call   80100380 <panic>
    panic("sleep");
80105a13:	83 ec 0c             	sub    $0xc,%esp
80105a16:	68 70 98 10 80       	push   $0x80109870
80105a1b:	e8 60 a9 ff ff       	call   80100380 <panic>

80105a20 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	53                   	push   %ebx
80105a24:	83 ec 10             	sub    $0x10,%esp
80105a27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80105a2a:	68 a0 45 11 80       	push   $0x801145a0
80105a2f:	e8 1c 07 00 00       	call   80106150 <acquire>
80105a34:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105a37:	b8 d4 45 11 80       	mov    $0x801145d4,%eax
80105a3c:	eb 0e                	jmp    80105a4c <wakeup+0x2c>
80105a3e:	66 90                	xchg   %ax,%ax
80105a40:	05 00 01 00 00       	add    $0x100,%eax
80105a45:	3d d4 85 11 80       	cmp    $0x801185d4,%eax
80105a4a:	74 1e                	je     80105a6a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
80105a4c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80105a50:	75 ee                	jne    80105a40 <wakeup+0x20>
80105a52:	3b 58 20             	cmp    0x20(%eax),%ebx
80105a55:	75 e9                	jne    80105a40 <wakeup+0x20>
      p->state = RUNNABLE;
80105a57:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105a5e:	05 00 01 00 00       	add    $0x100,%eax
80105a63:	3d d4 85 11 80       	cmp    $0x801185d4,%eax
80105a68:	75 e2                	jne    80105a4c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80105a6a:	c7 45 08 a0 45 11 80 	movl   $0x801145a0,0x8(%ebp)
}
80105a71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a74:	c9                   	leave  
  release(&ptable.lock);
80105a75:	e9 76 06 00 00       	jmp    801060f0 <release>
80105a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105a80 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80105a80:	55                   	push   %ebp
80105a81:	89 e5                	mov    %esp,%ebp
80105a83:	53                   	push   %ebx
80105a84:	83 ec 10             	sub    $0x10,%esp
80105a87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80105a8a:	68 a0 45 11 80       	push   $0x801145a0
80105a8f:	e8 bc 06 00 00       	call   80106150 <acquire>
80105a94:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105a97:	b8 d4 45 11 80       	mov    $0x801145d4,%eax
80105a9c:	eb 0e                	jmp    80105aac <kill+0x2c>
80105a9e:	66 90                	xchg   %ax,%ax
80105aa0:	05 00 01 00 00       	add    $0x100,%eax
80105aa5:	3d d4 85 11 80       	cmp    $0x801185d4,%eax
80105aaa:	74 34                	je     80105ae0 <kill+0x60>
    if(p->pid == pid){
80105aac:	39 58 10             	cmp    %ebx,0x10(%eax)
80105aaf:	75 ef                	jne    80105aa0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80105ab1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80105ab5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80105abc:	75 07                	jne    80105ac5 <kill+0x45>
        p->state = RUNNABLE;
80105abe:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80105ac5:	83 ec 0c             	sub    $0xc,%esp
80105ac8:	68 a0 45 11 80       	push   $0x801145a0
80105acd:	e8 1e 06 00 00       	call   801060f0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80105ad2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80105ad5:	83 c4 10             	add    $0x10,%esp
80105ad8:	31 c0                	xor    %eax,%eax
}
80105ada:	c9                   	leave  
80105adb:	c3                   	ret    
80105adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80105ae0:	83 ec 0c             	sub    $0xc,%esp
80105ae3:	68 a0 45 11 80       	push   $0x801145a0
80105ae8:	e8 03 06 00 00       	call   801060f0 <release>
}
80105aed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80105af0:	83 c4 10             	add    $0x10,%esp
80105af3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105af8:	c9                   	leave  
80105af9:	c3                   	ret    
80105afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b00 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	57                   	push   %edi
80105b04:	56                   	push   %esi
80105b05:	8d 75 e8             	lea    -0x18(%ebp),%esi
80105b08:	53                   	push   %ebx
80105b09:	bb 40 46 11 80       	mov    $0x80114640,%ebx
80105b0e:	83 ec 3c             	sub    $0x3c,%esp
80105b11:	eb 27                	jmp    80105b3a <procdump+0x3a>
80105b13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b17:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80105b18:	83 ec 0c             	sub    $0xc,%esp
80105b1b:	68 51 9b 10 80       	push   $0x80109b51
80105b20:	e8 db ab ff ff       	call   80100700 <cprintf>
80105b25:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105b28:	81 c3 00 01 00 00    	add    $0x100,%ebx
80105b2e:	81 fb 40 86 11 80    	cmp    $0x80118640,%ebx
80105b34:	0f 84 7e 00 00 00    	je     80105bb8 <procdump+0xb8>
    if(p->state == UNUSED)
80105b3a:	8b 43 a0             	mov    -0x60(%ebx),%eax
80105b3d:	85 c0                	test   %eax,%eax
80105b3f:	74 e7                	je     80105b28 <procdump+0x28>
      state = "???";
80105b41:	ba 87 98 10 80       	mov    $0x80109887,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105b46:	83 f8 05             	cmp    $0x5,%eax
80105b49:	77 11                	ja     80105b5c <procdump+0x5c>
80105b4b:	8b 14 85 98 99 10 80 	mov    -0x7fef6668(,%eax,4),%edx
      state = "???";
80105b52:	b8 87 98 10 80       	mov    $0x80109887,%eax
80105b57:	85 d2                	test   %edx,%edx
80105b59:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80105b5c:	53                   	push   %ebx
80105b5d:	52                   	push   %edx
80105b5e:	ff 73 a4             	push   -0x5c(%ebx)
80105b61:	68 8b 98 10 80       	push   $0x8010988b
80105b66:	e8 95 ab ff ff       	call   80100700 <cprintf>
    if(p->state == SLEEPING){
80105b6b:	83 c4 10             	add    $0x10,%esp
80105b6e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80105b72:	75 a4                	jne    80105b18 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105b74:	83 ec 08             	sub    $0x8,%esp
80105b77:	8d 45 c0             	lea    -0x40(%ebp),%eax
80105b7a:	8d 7d c0             	lea    -0x40(%ebp),%edi
80105b7d:	50                   	push   %eax
80105b7e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80105b81:	8b 40 0c             	mov    0xc(%eax),%eax
80105b84:	83 c0 08             	add    $0x8,%eax
80105b87:	50                   	push   %eax
80105b88:	e8 13 04 00 00       	call   80105fa0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80105b8d:	83 c4 10             	add    $0x10,%esp
80105b90:	8b 17                	mov    (%edi),%edx
80105b92:	85 d2                	test   %edx,%edx
80105b94:	74 82                	je     80105b18 <procdump+0x18>
        cprintf(" %p", pc[i]);
80105b96:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80105b99:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
80105b9c:	52                   	push   %edx
80105b9d:	68 61 92 10 80       	push   $0x80109261
80105ba2:	e8 59 ab ff ff       	call   80100700 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80105ba7:	83 c4 10             	add    $0x10,%esp
80105baa:	39 fe                	cmp    %edi,%esi
80105bac:	75 e2                	jne    80105b90 <procdump+0x90>
80105bae:	e9 65 ff ff ff       	jmp    80105b18 <procdump+0x18>
80105bb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bb7:	90                   	nop
  }
}
80105bb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bbb:	5b                   	pop    %ebx
80105bbc:	5e                   	pop    %esi
80105bbd:	5f                   	pop    %edi
80105bbe:	5d                   	pop    %ebp
80105bbf:	c3                   	ret    

80105bc0 <create_palindrome>:


int create_palindrome(int num){
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
80105bc3:	57                   	push   %edi
  int reversed = 0;
  int temp = num;
  int num_of_digits = 0;

  while (temp > 0) 
80105bc4:	8b 45 08             	mov    0x8(%ebp),%eax
int create_palindrome(int num){
80105bc7:	56                   	push   %esi
80105bc8:	53                   	push   %ebx
  while (temp > 0) 
80105bc9:	85 c0                	test   %eax,%eax
80105bcb:	7e 63                	jle    80105c30 <create_palindrome+0x70>
80105bcd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int num_of_digits = 0;
80105bd0:	31 db                	xor    %ebx,%ebx
  int reversed = 0;
80105bd2:	31 c0                	xor    %eax,%eax
80105bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
      reversed = reversed * 10 + (temp % 10);
80105bd8:	8d 34 80             	lea    (%eax,%eax,4),%esi
80105bdb:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
80105be0:	89 cf                	mov    %ecx,%edi
80105be2:	f7 e1                	mul    %ecx
80105be4:	c1 ea 03             	shr    $0x3,%edx
80105be7:	8d 04 92             	lea    (%edx,%edx,4),%eax
80105bea:	01 c0                	add    %eax,%eax
80105bec:	29 c7                	sub    %eax,%edi
80105bee:	8d 04 77             	lea    (%edi,%esi,2),%eax
      temp /= 10;
80105bf1:	89 ce                	mov    %ecx,%esi
80105bf3:	89 d1                	mov    %edx,%ecx
      num_of_digits += 1;
80105bf5:	89 da                	mov    %ebx,%edx
80105bf7:	8d 5b 01             	lea    0x1(%ebx),%ebx
  while (temp > 0) 
80105bfa:	83 fe 09             	cmp    $0x9,%esi
80105bfd:	7f d9                	jg     80105bd8 <create_palindrome+0x18>
  }

  int palindrome = reversed;
  int powers_of_ten = 1;
  for(int i = 0; i < num_of_digits; i++)
80105bff:	31 db                	xor    %ebx,%ebx
  int powers_of_ten = 1;
80105c01:	b9 01 00 00 00       	mov    $0x1,%ecx
80105c06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c0d:	8d 76 00             	lea    0x0(%esi),%esi
  {
      powers_of_ten *= 10;
80105c10:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
80105c13:	89 de                	mov    %ebx,%esi
  for(int i = 0; i < num_of_digits; i++)
80105c15:	83 c3 01             	add    $0x1,%ebx
      powers_of_ten *= 10;
80105c18:	01 c9                	add    %ecx,%ecx
  for(int i = 0; i < num_of_digits; i++)
80105c1a:	39 f2                	cmp    %esi,%edx
80105c1c:	75 f2                	jne    80105c10 <create_palindrome+0x50>
  }
  palindrome += (num * powers_of_ten);
80105c1e:	0f af 4d 08          	imul   0x8(%ebp),%ecx
  return palindrome;
}
80105c22:	5b                   	pop    %ebx
80105c23:	5e                   	pop    %esi
80105c24:	5f                   	pop    %edi
80105c25:	5d                   	pop    %ebp
  palindrome += (num * powers_of_ten);
80105c26:	01 c8                	add    %ecx,%eax
}
80105c28:	c3                   	ret    
80105c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c30:	5b                   	pop    %ebx
  while (temp > 0) 
80105c31:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105c34:	5e                   	pop    %esi
80105c35:	5f                   	pop    %edi
80105c36:	5d                   	pop    %ebp
80105c37:	c3                   	ret    
80105c38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c3f:	90                   	nop

80105c40 <sys_get_most_invoked_syscall>:

int sys_get_most_invoked_syscall(void){
80105c40:	55                   	push   %ebp
80105c41:	89 e5                	mov    %esp,%ebp
80105c43:	56                   	push   %esi
80105c44:	53                   	push   %ebx
  int pid;
  if(argint(0, &pid) < 0){
80105c45:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_get_most_invoked_syscall(void){
80105c48:	83 ec 18             	sub    $0x18,%esp
  if(argint(0, &pid) < 0){
80105c4b:	50                   	push   %eax
80105c4c:	6a 00                	push   $0x0
80105c4e:	e8 7d 08 00 00       	call   801064d0 <argint>
80105c53:	83 c4 10             	add    $0x10,%esp
80105c56:	85 c0                	test   %eax,%eax
80105c58:	0f 88 98 00 00 00    	js     80105cf6 <sys_get_most_invoked_syscall+0xb6>
    return -1;
  }

  struct proc* p;
  acquire(&ptable.lock);
80105c5e:	83 ec 0c             	sub    $0xc,%esp
80105c61:	68 a0 45 11 80       	push   $0x801145a0
80105c66:	e8 e5 04 00 00       	call   80106150 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
80105c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c6e:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105c71:	ba d4 45 11 80       	mov    $0x801145d4,%edx
80105c76:	eb 16                	jmp    80105c8e <sys_get_most_invoked_syscall+0x4e>
80105c78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c7f:	90                   	nop
80105c80:	81 c2 00 01 00 00    	add    $0x100,%edx
80105c86:	81 fa d4 85 11 80    	cmp    $0x801185d4,%edx
80105c8c:	74 4a                	je     80105cd8 <sys_get_most_invoked_syscall+0x98>
    if(p->pid == pid){
80105c8e:	39 42 10             	cmp    %eax,0x10(%edx)
80105c91:	75 ed                	jne    80105c80 <sys_get_most_invoked_syscall+0x40>
      int max = p->syscall_history[0];
80105c93:	8b 9a 80 00 00 00    	mov    0x80(%edx),%ebx
80105c99:	b8 02 00 00 00       	mov    $0x2,%eax
      int index = 1;
80105c9e:	be 01 00 00 00       	mov    $0x1,%esi
80105ca3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ca7:	90                   	nop
      for(int i = 0; i < SYSCALL_NUM; i++){
        if(p->syscall_history[i] > max){
80105ca8:	8b 4c 82 7c          	mov    0x7c(%edx,%eax,4),%ecx
80105cac:	39 d9                	cmp    %ebx,%ecx
80105cae:	7e 04                	jle    80105cb4 <sys_get_most_invoked_syscall+0x74>
          max = p->syscall_history[i];
          index = i + 1;//for array index
80105cb0:	89 c6                	mov    %eax,%esi
80105cb2:	89 cb                	mov    %ecx,%ebx
80105cb4:	83 c0 01             	add    $0x1,%eax
      for(int i = 0; i < SYSCALL_NUM; i++){
80105cb7:	83 f8 1c             	cmp    $0x1c,%eax
80105cba:	75 ec                	jne    80105ca8 <sys_get_most_invoked_syscall+0x68>
        }
      }
      release(&ptable.lock);
80105cbc:	83 ec 0c             	sub    $0xc,%esp
80105cbf:	68 a0 45 11 80       	push   $0x801145a0
80105cc4:	e8 27 04 00 00       	call   801060f0 <release>
      return index;
80105cc9:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ptable.lock);
  return -1;
}
80105ccc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105ccf:	89 f0                	mov    %esi,%eax
80105cd1:	5b                   	pop    %ebx
80105cd2:	5e                   	pop    %esi
80105cd3:	5d                   	pop    %ebp
80105cd4:	c3                   	ret    
80105cd5:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80105cd8:	83 ec 0c             	sub    $0xc,%esp
  return -1;
80105cdb:	be ff ff ff ff       	mov    $0xffffffff,%esi
  release(&ptable.lock);
80105ce0:	68 a0 45 11 80       	push   $0x801145a0
80105ce5:	e8 06 04 00 00       	call   801060f0 <release>
  return -1;
80105cea:	83 c4 10             	add    $0x10,%esp
}
80105ced:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105cf0:	89 f0                	mov    %esi,%eax
80105cf2:	5b                   	pop    %ebx
80105cf3:	5e                   	pop    %esi
80105cf4:	5d                   	pop    %ebp
80105cf5:	c3                   	ret    
    return -1;
80105cf6:	be ff ff ff ff       	mov    $0xffffffff,%esi
80105cfb:	eb cf                	jmp    80105ccc <sys_get_most_invoked_syscall+0x8c>
80105cfd:	8d 76 00             	lea    0x0(%esi),%esi

80105d00 <sys_sort_syscalls>:

int sys_sort_syscalls(void){
80105d00:	55                   	push   %ebp
80105d01:	89 e5                	mov    %esp,%ebp
80105d03:	56                   	push   %esi
80105d04:	53                   	push   %ebx
  int pid;
  if(argint(0, &pid) < 0){
80105d05:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_sort_syscalls(void){
80105d08:	83 ec 18             	sub    $0x18,%esp
  if(argint(0, &pid) < 0){
80105d0b:	50                   	push   %eax
80105d0c:	6a 00                	push   $0x0
80105d0e:	e8 bd 07 00 00       	call   801064d0 <argint>
80105d13:	83 c4 10             	add    $0x10,%esp
80105d16:	85 c0                	test   %eax,%eax
80105d18:	0f 88 ae 00 00 00    	js     80105dcc <sys_sort_syscalls+0xcc>
    return -1;
  }

  struct proc* p;
  acquire(&ptable.lock);
80105d1e:	83 ec 0c             	sub    $0xc,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105d21:	bb d4 45 11 80       	mov    $0x801145d4,%ebx
  acquire(&ptable.lock);
80105d26:	68 a0 45 11 80       	push   $0x801145a0
80105d2b:	e8 20 04 00 00       	call   80106150 <acquire>
    if((p->pid == pid) && (p->pid > 0)){
80105d30:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d33:	83 c4 10             	add    $0x10,%esp
80105d36:	eb 16                	jmp    80105d4e <sys_sort_syscalls+0x4e>
80105d38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d3f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105d40:	81 c3 00 01 00 00    	add    $0x100,%ebx
80105d46:	81 fb d4 85 11 80    	cmp    $0x801185d4,%ebx
80105d4c:	74 62                	je     80105db0 <sys_sort_syscalls+0xb0>
    if((p->pid == pid) && (p->pid > 0)){
80105d4e:	8b 43 10             	mov    0x10(%ebx),%eax
80105d51:	39 d0                	cmp    %edx,%eax
80105d53:	75 eb                	jne    80105d40 <sys_sort_syscalls+0x40>
80105d55:	85 c0                	test   %eax,%eax
80105d57:	7e e7                	jle    80105d40 <sys_sort_syscalls+0x40>
      cprintf("Sorted system calls of %d/frequencies:\n", pid);
80105d59:	83 ec 08             	sub    $0x8,%esp
      for(int i = 0; i < SYSCALL_NUM; i++)
80105d5c:	31 f6                	xor    %esi,%esi
      cprintf("Sorted system calls of %d/frequencies:\n", pid);
80105d5e:	52                   	push   %edx
80105d5f:	68 70 99 10 80       	push   $0x80109970
80105d64:	e8 97 a9 ff ff       	call   80100700 <cprintf>
80105d69:	83 c4 10             	add    $0x10,%esp
80105d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      {
        if(p->syscall_history[i] > 0)
80105d70:	8b 84 b3 80 00 00 00 	mov    0x80(%ebx,%esi,4),%eax
          cprintf("system call %d : %d\n", i + 1, p->syscall_history[i]);
80105d77:	83 c6 01             	add    $0x1,%esi
        if(p->syscall_history[i] > 0)
80105d7a:	85 c0                	test   %eax,%eax
80105d7c:	7e 12                	jle    80105d90 <sys_sort_syscalls+0x90>
          cprintf("system call %d : %d\n", i + 1, p->syscall_history[i]);
80105d7e:	83 ec 04             	sub    $0x4,%esp
80105d81:	50                   	push   %eax
80105d82:	56                   	push   %esi
80105d83:	68 94 98 10 80       	push   $0x80109894
80105d88:	e8 73 a9 ff ff       	call   80100700 <cprintf>
80105d8d:	83 c4 10             	add    $0x10,%esp
      for(int i = 0; i < SYSCALL_NUM; i++)
80105d90:	83 fe 1b             	cmp    $0x1b,%esi
80105d93:	75 db                	jne    80105d70 <sys_sort_syscalls+0x70>
      } 
      release(&ptable.lock);
80105d95:	83 ec 0c             	sub    $0xc,%esp
80105d98:	68 a0 45 11 80       	push   $0x801145a0
80105d9d:	e8 4e 03 00 00       	call   801060f0 <release>
      return 0;
80105da2:	83 c4 10             	add    $0x10,%esp
80105da5:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80105da7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105daa:	5b                   	pop    %ebx
80105dab:	5e                   	pop    %esi
80105dac:	5d                   	pop    %ebp
80105dad:	c3                   	ret    
80105dae:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
80105db0:	83 ec 0c             	sub    $0xc,%esp
80105db3:	68 a0 45 11 80       	push   $0x801145a0
80105db8:	e8 33 03 00 00       	call   801060f0 <release>
  return -1;
80105dbd:	83 c4 10             	add    $0x10,%esp
}
80105dc0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  return -1;
80105dc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105dc8:	5b                   	pop    %ebx
80105dc9:	5e                   	pop    %esi
80105dca:	5d                   	pop    %ebp
80105dcb:	c3                   	ret    
    return -1;
80105dcc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dd1:	eb d4                	jmp    80105da7 <sys_sort_syscalls+0xa7>
80105dd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105de0 <sys_list_all_processes>:

void sys_list_all_processes(void){
80105de0:	55                   	push   %ebp
80105de1:	89 e5                	mov    %esp,%ebp
80105de3:	53                   	push   %ebx
  struct proc* p;
  acquire(&ptable.lock);
  cprintf("Processes Info:\n");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105de4:	bb d4 45 11 80       	mov    $0x801145d4,%ebx
void sys_list_all_processes(void){
80105de9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80105dec:	68 a0 45 11 80       	push   $0x801145a0
80105df1:	e8 5a 03 00 00       	call   80106150 <acquire>
  cprintf("Processes Info:\n");
80105df6:	c7 04 24 a9 98 10 80 	movl   $0x801098a9,(%esp)
80105dfd:	e8 fe a8 ff ff       	call   80100700 <cprintf>
80105e02:	83 c4 10             	add    $0x10,%esp
80105e05:	eb 2b                	jmp    80105e32 <sys_list_all_processes+0x52>
80105e07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e0e:	66 90                	xchg   %ax,%ax
    if(p->pid > 0)
      cprintf("Process %d -> %d systemcalls\n", p->pid, p->syscall_count);
80105e10:	83 ec 04             	sub    $0x4,%esp
80105e13:	ff 73 7c             	push   0x7c(%ebx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105e16:	81 c3 00 01 00 00    	add    $0x100,%ebx
      cprintf("Process %d -> %d systemcalls\n", p->pid, p->syscall_count);
80105e1c:	50                   	push   %eax
80105e1d:	68 ba 98 10 80       	push   $0x801098ba
80105e22:	e8 d9 a8 ff ff       	call   80100700 <cprintf>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105e27:	83 c4 10             	add    $0x10,%esp
80105e2a:	81 fb d4 85 11 80    	cmp    $0x801185d4,%ebx
80105e30:	74 17                	je     80105e49 <sys_list_all_processes+0x69>
    if(p->pid > 0)
80105e32:	8b 43 10             	mov    0x10(%ebx),%eax
80105e35:	85 c0                	test   %eax,%eax
80105e37:	7f d7                	jg     80105e10 <sys_list_all_processes+0x30>
    else
    {
      release(&ptable.lock);
80105e39:	83 ec 0c             	sub    $0xc,%esp
80105e3c:	68 a0 45 11 80       	push   $0x801145a0
80105e41:	e8 aa 02 00 00       	call   801060f0 <release>
      break;
80105e46:	83 c4 10             	add    $0x10,%esp
    }
  }
80105e49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e4c:	c9                   	leave  
80105e4d:	c3                   	ret    
80105e4e:	66 90                	xchg   %ax,%ax

80105e50 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80105e50:	55                   	push   %ebp
80105e51:	89 e5                	mov    %esp,%ebp
80105e53:	53                   	push   %ebx
80105e54:	83 ec 0c             	sub    $0xc,%esp
80105e57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80105e5a:	68 b0 99 10 80       	push   $0x801099b0
80105e5f:	8d 43 04             	lea    0x4(%ebx),%eax
80105e62:	50                   	push   %eax
80105e63:	e8 18 01 00 00       	call   80105f80 <initlock>
  lk->name = name;
80105e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80105e6b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80105e71:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80105e74:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80105e7b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80105e7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e81:	c9                   	leave  
80105e82:	c3                   	ret    
80105e83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e90 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80105e90:	55                   	push   %ebp
80105e91:	89 e5                	mov    %esp,%ebp
80105e93:	56                   	push   %esi
80105e94:	53                   	push   %ebx
80105e95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105e98:	8d 73 04             	lea    0x4(%ebx),%esi
80105e9b:	83 ec 0c             	sub    $0xc,%esp
80105e9e:	56                   	push   %esi
80105e9f:	e8 ac 02 00 00       	call   80106150 <acquire>
  while (lk->locked) {
80105ea4:	8b 13                	mov    (%ebx),%edx
80105ea6:	83 c4 10             	add    $0x10,%esp
80105ea9:	85 d2                	test   %edx,%edx
80105eab:	74 16                	je     80105ec3 <acquiresleep+0x33>
80105ead:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80105eb0:	83 ec 08             	sub    $0x8,%esp
80105eb3:	56                   	push   %esi
80105eb4:	53                   	push   %ebx
80105eb5:	e8 a6 fa ff ff       	call   80105960 <sleep>
  while (lk->locked) {
80105eba:	8b 03                	mov    (%ebx),%eax
80105ebc:	83 c4 10             	add    $0x10,%esp
80105ebf:	85 c0                	test   %eax,%eax
80105ec1:	75 ed                	jne    80105eb0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80105ec3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80105ec9:	e8 02 f1 ff ff       	call   80104fd0 <myproc>
80105ece:	8b 40 10             	mov    0x10(%eax),%eax
80105ed1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80105ed4:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105ed7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105eda:	5b                   	pop    %ebx
80105edb:	5e                   	pop    %esi
80105edc:	5d                   	pop    %ebp
  release(&lk->lk);
80105edd:	e9 0e 02 00 00       	jmp    801060f0 <release>
80105ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ef0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105ef0:	55                   	push   %ebp
80105ef1:	89 e5                	mov    %esp,%ebp
80105ef3:	56                   	push   %esi
80105ef4:	53                   	push   %ebx
80105ef5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105ef8:	8d 73 04             	lea    0x4(%ebx),%esi
80105efb:	83 ec 0c             	sub    $0xc,%esp
80105efe:	56                   	push   %esi
80105eff:	e8 4c 02 00 00       	call   80106150 <acquire>
  lk->locked = 0;
80105f04:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80105f0a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105f11:	89 1c 24             	mov    %ebx,(%esp)
80105f14:	e8 07 fb ff ff       	call   80105a20 <wakeup>
  release(&lk->lk);
80105f19:	89 75 08             	mov    %esi,0x8(%ebp)
80105f1c:	83 c4 10             	add    $0x10,%esp
}
80105f1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f22:	5b                   	pop    %ebx
80105f23:	5e                   	pop    %esi
80105f24:	5d                   	pop    %ebp
  release(&lk->lk);
80105f25:	e9 c6 01 00 00       	jmp    801060f0 <release>
80105f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105f30 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105f30:	55                   	push   %ebp
80105f31:	89 e5                	mov    %esp,%ebp
80105f33:	57                   	push   %edi
80105f34:	31 ff                	xor    %edi,%edi
80105f36:	56                   	push   %esi
80105f37:	53                   	push   %ebx
80105f38:	83 ec 18             	sub    $0x18,%esp
80105f3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80105f3e:	8d 73 04             	lea    0x4(%ebx),%esi
80105f41:	56                   	push   %esi
80105f42:	e8 09 02 00 00       	call   80106150 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80105f47:	8b 03                	mov    (%ebx),%eax
80105f49:	83 c4 10             	add    $0x10,%esp
80105f4c:	85 c0                	test   %eax,%eax
80105f4e:	75 18                	jne    80105f68 <holdingsleep+0x38>
  release(&lk->lk);
80105f50:	83 ec 0c             	sub    $0xc,%esp
80105f53:	56                   	push   %esi
80105f54:	e8 97 01 00 00       	call   801060f0 <release>
  return r;
}
80105f59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f5c:	89 f8                	mov    %edi,%eax
80105f5e:	5b                   	pop    %ebx
80105f5f:	5e                   	pop    %esi
80105f60:	5f                   	pop    %edi
80105f61:	5d                   	pop    %ebp
80105f62:	c3                   	ret    
80105f63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f67:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80105f68:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80105f6b:	e8 60 f0 ff ff       	call   80104fd0 <myproc>
80105f70:	39 58 10             	cmp    %ebx,0x10(%eax)
80105f73:	0f 94 c0             	sete   %al
80105f76:	0f b6 c0             	movzbl %al,%eax
80105f79:	89 c7                	mov    %eax,%edi
80105f7b:	eb d3                	jmp    80105f50 <holdingsleep+0x20>
80105f7d:	66 90                	xchg   %ax,%ax
80105f7f:	90                   	nop

80105f80 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105f80:	55                   	push   %ebp
80105f81:	89 e5                	mov    %esp,%ebp
80105f83:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80105f86:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80105f89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80105f8f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80105f92:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105f99:	5d                   	pop    %ebp
80105f9a:	c3                   	ret    
80105f9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f9f:	90                   	nop

80105fa0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105fa0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105fa1:	31 d2                	xor    %edx,%edx
{
80105fa3:	89 e5                	mov    %esp,%ebp
80105fa5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80105fa6:	8b 45 08             	mov    0x8(%ebp),%eax
{
80105fa9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80105fac:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80105faf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105fb0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80105fb6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80105fbc:	77 1a                	ja     80105fd8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105fbe:	8b 58 04             	mov    0x4(%eax),%ebx
80105fc1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105fc4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105fc7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105fc9:	83 fa 0a             	cmp    $0xa,%edx
80105fcc:	75 e2                	jne    80105fb0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80105fce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105fd1:	c9                   	leave  
80105fd2:	c3                   	ret    
80105fd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fd7:	90                   	nop
  for(; i < 10; i++)
80105fd8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80105fdb:	8d 51 28             	lea    0x28(%ecx),%edx
80105fde:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105fe0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105fe6:	83 c0 04             	add    $0x4,%eax
80105fe9:	39 d0                	cmp    %edx,%eax
80105feb:	75 f3                	jne    80105fe0 <getcallerpcs+0x40>
}
80105fed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ff0:	c9                   	leave  
80105ff1:	c3                   	ret    
80105ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106000 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80106000:	55                   	push   %ebp
80106001:	89 e5                	mov    %esp,%ebp
80106003:	53                   	push   %ebx
80106004:	83 ec 04             	sub    $0x4,%esp
80106007:	9c                   	pushf  
80106008:	5b                   	pop    %ebx
  asm volatile("cli");
80106009:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010600a:	e8 41 ef ff ff       	call   80104f50 <mycpu>
8010600f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80106015:	85 c0                	test   %eax,%eax
80106017:	74 17                	je     80106030 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80106019:	e8 32 ef ff ff       	call   80104f50 <mycpu>
8010601e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80106025:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106028:	c9                   	leave  
80106029:	c3                   	ret    
8010602a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80106030:	e8 1b ef ff ff       	call   80104f50 <mycpu>
80106035:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010603b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80106041:	eb d6                	jmp    80106019 <pushcli+0x19>
80106043:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010604a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106050 <popcli>:

void
popcli(void)
{
80106050:	55                   	push   %ebp
80106051:	89 e5                	mov    %esp,%ebp
80106053:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80106056:	9c                   	pushf  
80106057:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80106058:	f6 c4 02             	test   $0x2,%ah
8010605b:	75 35                	jne    80106092 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010605d:	e8 ee ee ff ff       	call   80104f50 <mycpu>
80106062:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80106069:	78 34                	js     8010609f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010606b:	e8 e0 ee ff ff       	call   80104f50 <mycpu>
80106070:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80106076:	85 d2                	test   %edx,%edx
80106078:	74 06                	je     80106080 <popcli+0x30>
    sti();
}
8010607a:	c9                   	leave  
8010607b:	c3                   	ret    
8010607c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80106080:	e8 cb ee ff ff       	call   80104f50 <mycpu>
80106085:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010608b:	85 c0                	test   %eax,%eax
8010608d:	74 eb                	je     8010607a <popcli+0x2a>
  asm volatile("sti");
8010608f:	fb                   	sti    
}
80106090:	c9                   	leave  
80106091:	c3                   	ret    
    panic("popcli - interruptible");
80106092:	83 ec 0c             	sub    $0xc,%esp
80106095:	68 bb 99 10 80       	push   $0x801099bb
8010609a:	e8 e1 a2 ff ff       	call   80100380 <panic>
    panic("popcli");
8010609f:	83 ec 0c             	sub    $0xc,%esp
801060a2:	68 d2 99 10 80       	push   $0x801099d2
801060a7:	e8 d4 a2 ff ff       	call   80100380 <panic>
801060ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060b0 <holding>:
{
801060b0:	55                   	push   %ebp
801060b1:	89 e5                	mov    %esp,%ebp
801060b3:	56                   	push   %esi
801060b4:	53                   	push   %ebx
801060b5:	8b 75 08             	mov    0x8(%ebp),%esi
801060b8:	31 db                	xor    %ebx,%ebx
  pushcli();
801060ba:	e8 41 ff ff ff       	call   80106000 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801060bf:	8b 06                	mov    (%esi),%eax
801060c1:	85 c0                	test   %eax,%eax
801060c3:	75 0b                	jne    801060d0 <holding+0x20>
  popcli();
801060c5:	e8 86 ff ff ff       	call   80106050 <popcli>
}
801060ca:	89 d8                	mov    %ebx,%eax
801060cc:	5b                   	pop    %ebx
801060cd:	5e                   	pop    %esi
801060ce:	5d                   	pop    %ebp
801060cf:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
801060d0:	8b 5e 08             	mov    0x8(%esi),%ebx
801060d3:	e8 78 ee ff ff       	call   80104f50 <mycpu>
801060d8:	39 c3                	cmp    %eax,%ebx
801060da:	0f 94 c3             	sete   %bl
  popcli();
801060dd:	e8 6e ff ff ff       	call   80106050 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801060e2:	0f b6 db             	movzbl %bl,%ebx
}
801060e5:	89 d8                	mov    %ebx,%eax
801060e7:	5b                   	pop    %ebx
801060e8:	5e                   	pop    %esi
801060e9:	5d                   	pop    %ebp
801060ea:	c3                   	ret    
801060eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801060ef:	90                   	nop

801060f0 <release>:
{
801060f0:	55                   	push   %ebp
801060f1:	89 e5                	mov    %esp,%ebp
801060f3:	56                   	push   %esi
801060f4:	53                   	push   %ebx
801060f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801060f8:	e8 03 ff ff ff       	call   80106000 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801060fd:	8b 03                	mov    (%ebx),%eax
801060ff:	85 c0                	test   %eax,%eax
80106101:	75 15                	jne    80106118 <release+0x28>
  popcli();
80106103:	e8 48 ff ff ff       	call   80106050 <popcli>
    panic("release");
80106108:	83 ec 0c             	sub    $0xc,%esp
8010610b:	68 d9 99 10 80       	push   $0x801099d9
80106110:	e8 6b a2 ff ff       	call   80100380 <panic>
80106115:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80106118:	8b 73 08             	mov    0x8(%ebx),%esi
8010611b:	e8 30 ee ff ff       	call   80104f50 <mycpu>
80106120:	39 c6                	cmp    %eax,%esi
80106122:	75 df                	jne    80106103 <release+0x13>
  popcli();
80106124:	e8 27 ff ff ff       	call   80106050 <popcli>
  lk->pcs[0] = 0;
80106129:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80106130:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80106137:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010613c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80106142:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106145:	5b                   	pop    %ebx
80106146:	5e                   	pop    %esi
80106147:	5d                   	pop    %ebp
  popcli();
80106148:	e9 03 ff ff ff       	jmp    80106050 <popcli>
8010614d:	8d 76 00             	lea    0x0(%esi),%esi

80106150 <acquire>:
{
80106150:	55                   	push   %ebp
80106151:	89 e5                	mov    %esp,%ebp
80106153:	53                   	push   %ebx
80106154:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80106157:	e8 a4 fe ff ff       	call   80106000 <pushcli>
  if(holding(lk))
8010615c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010615f:	e8 9c fe ff ff       	call   80106000 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80106164:	8b 03                	mov    (%ebx),%eax
80106166:	85 c0                	test   %eax,%eax
80106168:	75 7e                	jne    801061e8 <acquire+0x98>
  popcli();
8010616a:	e8 e1 fe ff ff       	call   80106050 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010616f:	b9 01 00 00 00       	mov    $0x1,%ecx
80106174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80106178:	8b 55 08             	mov    0x8(%ebp),%edx
8010617b:	89 c8                	mov    %ecx,%eax
8010617d:	f0 87 02             	lock xchg %eax,(%edx)
80106180:	85 c0                	test   %eax,%eax
80106182:	75 f4                	jne    80106178 <acquire+0x28>
  __sync_synchronize();
80106184:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80106189:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010618c:	e8 bf ed ff ff       	call   80104f50 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80106191:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80106194:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80106196:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80106199:	31 c0                	xor    %eax,%eax
8010619b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010619f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801061a0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801061a6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801061ac:	77 1a                	ja     801061c8 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
801061ae:	8b 5a 04             	mov    0x4(%edx),%ebx
801061b1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801061b5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801061b8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801061ba:	83 f8 0a             	cmp    $0xa,%eax
801061bd:	75 e1                	jne    801061a0 <acquire+0x50>
}
801061bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801061c2:	c9                   	leave  
801061c3:	c3                   	ret    
801061c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801061c8:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
801061cc:	8d 51 34             	lea    0x34(%ecx),%edx
801061cf:	90                   	nop
    pcs[i] = 0;
801061d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801061d6:	83 c0 04             	add    $0x4,%eax
801061d9:	39 c2                	cmp    %eax,%edx
801061db:	75 f3                	jne    801061d0 <acquire+0x80>
}
801061dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801061e0:	c9                   	leave  
801061e1:	c3                   	ret    
801061e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801061e8:	8b 5b 08             	mov    0x8(%ebx),%ebx
801061eb:	e8 60 ed ff ff       	call   80104f50 <mycpu>
801061f0:	39 c3                	cmp    %eax,%ebx
801061f2:	0f 85 72 ff ff ff    	jne    8010616a <acquire+0x1a>
  popcli();
801061f8:	e8 53 fe ff ff       	call   80106050 <popcli>
    panic("acquire");
801061fd:	83 ec 0c             	sub    $0xc,%esp
80106200:	68 e1 99 10 80       	push   $0x801099e1
80106205:	e8 76 a1 ff ff       	call   80100380 <panic>
8010620a:	66 90                	xchg   %ax,%ax
8010620c:	66 90                	xchg   %ax,%ax
8010620e:	66 90                	xchg   %ax,%ax

80106210 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80106210:	55                   	push   %ebp
80106211:	89 e5                	mov    %esp,%ebp
80106213:	57                   	push   %edi
80106214:	8b 55 08             	mov    0x8(%ebp),%edx
80106217:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010621a:	53                   	push   %ebx
8010621b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010621e:	89 d7                	mov    %edx,%edi
80106220:	09 cf                	or     %ecx,%edi
80106222:	83 e7 03             	and    $0x3,%edi
80106225:	75 29                	jne    80106250 <memset+0x40>
    c &= 0xFF;
80106227:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010622a:	c1 e0 18             	shl    $0x18,%eax
8010622d:	89 fb                	mov    %edi,%ebx
8010622f:	c1 e9 02             	shr    $0x2,%ecx
80106232:	c1 e3 10             	shl    $0x10,%ebx
80106235:	09 d8                	or     %ebx,%eax
80106237:	09 f8                	or     %edi,%eax
80106239:	c1 e7 08             	shl    $0x8,%edi
8010623c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010623e:	89 d7                	mov    %edx,%edi
80106240:	fc                   	cld    
80106241:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80106243:	5b                   	pop    %ebx
80106244:	89 d0                	mov    %edx,%eax
80106246:	5f                   	pop    %edi
80106247:	5d                   	pop    %ebp
80106248:	c3                   	ret    
80106249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80106250:	89 d7                	mov    %edx,%edi
80106252:	fc                   	cld    
80106253:	f3 aa                	rep stos %al,%es:(%edi)
80106255:	5b                   	pop    %ebx
80106256:	89 d0                	mov    %edx,%eax
80106258:	5f                   	pop    %edi
80106259:	5d                   	pop    %ebp
8010625a:	c3                   	ret    
8010625b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010625f:	90                   	nop

80106260 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80106260:	55                   	push   %ebp
80106261:	89 e5                	mov    %esp,%ebp
80106263:	56                   	push   %esi
80106264:	8b 75 10             	mov    0x10(%ebp),%esi
80106267:	8b 55 08             	mov    0x8(%ebp),%edx
8010626a:	53                   	push   %ebx
8010626b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010626e:	85 f6                	test   %esi,%esi
80106270:	74 2e                	je     801062a0 <memcmp+0x40>
80106272:	01 c6                	add    %eax,%esi
80106274:	eb 14                	jmp    8010628a <memcmp+0x2a>
80106276:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010627d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80106280:	83 c0 01             	add    $0x1,%eax
80106283:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80106286:	39 f0                	cmp    %esi,%eax
80106288:	74 16                	je     801062a0 <memcmp+0x40>
    if(*s1 != *s2)
8010628a:	0f b6 0a             	movzbl (%edx),%ecx
8010628d:	0f b6 18             	movzbl (%eax),%ebx
80106290:	38 d9                	cmp    %bl,%cl
80106292:	74 ec                	je     80106280 <memcmp+0x20>
      return *s1 - *s2;
80106294:	0f b6 c1             	movzbl %cl,%eax
80106297:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80106299:	5b                   	pop    %ebx
8010629a:	5e                   	pop    %esi
8010629b:	5d                   	pop    %ebp
8010629c:	c3                   	ret    
8010629d:	8d 76 00             	lea    0x0(%esi),%esi
801062a0:	5b                   	pop    %ebx
  return 0;
801062a1:	31 c0                	xor    %eax,%eax
}
801062a3:	5e                   	pop    %esi
801062a4:	5d                   	pop    %ebp
801062a5:	c3                   	ret    
801062a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062ad:	8d 76 00             	lea    0x0(%esi),%esi

801062b0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801062b0:	55                   	push   %ebp
801062b1:	89 e5                	mov    %esp,%ebp
801062b3:	57                   	push   %edi
801062b4:	8b 55 08             	mov    0x8(%ebp),%edx
801062b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801062ba:	56                   	push   %esi
801062bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801062be:	39 d6                	cmp    %edx,%esi
801062c0:	73 26                	jae    801062e8 <memmove+0x38>
801062c2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801062c5:	39 fa                	cmp    %edi,%edx
801062c7:	73 1f                	jae    801062e8 <memmove+0x38>
801062c9:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
801062cc:	85 c9                	test   %ecx,%ecx
801062ce:	74 0c                	je     801062dc <memmove+0x2c>
      *--d = *--s;
801062d0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801062d4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801062d7:	83 e8 01             	sub    $0x1,%eax
801062da:	73 f4                	jae    801062d0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801062dc:	5e                   	pop    %esi
801062dd:	89 d0                	mov    %edx,%eax
801062df:	5f                   	pop    %edi
801062e0:	5d                   	pop    %ebp
801062e1:	c3                   	ret    
801062e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
801062e8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801062eb:	89 d7                	mov    %edx,%edi
801062ed:	85 c9                	test   %ecx,%ecx
801062ef:	74 eb                	je     801062dc <memmove+0x2c>
801062f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801062f8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801062f9:	39 c6                	cmp    %eax,%esi
801062fb:	75 fb                	jne    801062f8 <memmove+0x48>
}
801062fd:	5e                   	pop    %esi
801062fe:	89 d0                	mov    %edx,%eax
80106300:	5f                   	pop    %edi
80106301:	5d                   	pop    %ebp
80106302:	c3                   	ret    
80106303:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010630a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106310 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80106310:	eb 9e                	jmp    801062b0 <memmove>
80106312:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106320 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80106320:	55                   	push   %ebp
80106321:	89 e5                	mov    %esp,%ebp
80106323:	56                   	push   %esi
80106324:	8b 75 10             	mov    0x10(%ebp),%esi
80106327:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010632a:	53                   	push   %ebx
8010632b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
8010632e:	85 f6                	test   %esi,%esi
80106330:	74 2e                	je     80106360 <strncmp+0x40>
80106332:	01 d6                	add    %edx,%esi
80106334:	eb 18                	jmp    8010634e <strncmp+0x2e>
80106336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010633d:	8d 76 00             	lea    0x0(%esi),%esi
80106340:	38 d8                	cmp    %bl,%al
80106342:	75 14                	jne    80106358 <strncmp+0x38>
    n--, p++, q++;
80106344:	83 c2 01             	add    $0x1,%edx
80106347:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010634a:	39 f2                	cmp    %esi,%edx
8010634c:	74 12                	je     80106360 <strncmp+0x40>
8010634e:	0f b6 01             	movzbl (%ecx),%eax
80106351:	0f b6 1a             	movzbl (%edx),%ebx
80106354:	84 c0                	test   %al,%al
80106356:	75 e8                	jne    80106340 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80106358:	29 d8                	sub    %ebx,%eax
}
8010635a:	5b                   	pop    %ebx
8010635b:	5e                   	pop    %esi
8010635c:	5d                   	pop    %ebp
8010635d:	c3                   	ret    
8010635e:	66 90                	xchg   %ax,%ax
80106360:	5b                   	pop    %ebx
    return 0;
80106361:	31 c0                	xor    %eax,%eax
}
80106363:	5e                   	pop    %esi
80106364:	5d                   	pop    %ebp
80106365:	c3                   	ret    
80106366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010636d:	8d 76 00             	lea    0x0(%esi),%esi

80106370 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80106370:	55                   	push   %ebp
80106371:	89 e5                	mov    %esp,%ebp
80106373:	57                   	push   %edi
80106374:	56                   	push   %esi
80106375:	8b 75 08             	mov    0x8(%ebp),%esi
80106378:	53                   	push   %ebx
80106379:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010637c:	89 f0                	mov    %esi,%eax
8010637e:	eb 15                	jmp    80106395 <strncpy+0x25>
80106380:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80106384:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106387:	83 c0 01             	add    $0x1,%eax
8010638a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010638e:	88 50 ff             	mov    %dl,-0x1(%eax)
80106391:	84 d2                	test   %dl,%dl
80106393:	74 09                	je     8010639e <strncpy+0x2e>
80106395:	89 cb                	mov    %ecx,%ebx
80106397:	83 e9 01             	sub    $0x1,%ecx
8010639a:	85 db                	test   %ebx,%ebx
8010639c:	7f e2                	jg     80106380 <strncpy+0x10>
    ;
  while(n-- > 0)
8010639e:	89 c2                	mov    %eax,%edx
801063a0:	85 c9                	test   %ecx,%ecx
801063a2:	7e 17                	jle    801063bb <strncpy+0x4b>
801063a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801063a8:	83 c2 01             	add    $0x1,%edx
801063ab:	89 c1                	mov    %eax,%ecx
801063ad:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
801063b1:	29 d1                	sub    %edx,%ecx
801063b3:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
801063b7:	85 c9                	test   %ecx,%ecx
801063b9:	7f ed                	jg     801063a8 <strncpy+0x38>
  return os;
}
801063bb:	5b                   	pop    %ebx
801063bc:	89 f0                	mov    %esi,%eax
801063be:	5e                   	pop    %esi
801063bf:	5f                   	pop    %edi
801063c0:	5d                   	pop    %ebp
801063c1:	c3                   	ret    
801063c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801063d0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801063d0:	55                   	push   %ebp
801063d1:	89 e5                	mov    %esp,%ebp
801063d3:	56                   	push   %esi
801063d4:	8b 55 10             	mov    0x10(%ebp),%edx
801063d7:	8b 75 08             	mov    0x8(%ebp),%esi
801063da:	53                   	push   %ebx
801063db:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801063de:	85 d2                	test   %edx,%edx
801063e0:	7e 25                	jle    80106407 <safestrcpy+0x37>
801063e2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801063e6:	89 f2                	mov    %esi,%edx
801063e8:	eb 16                	jmp    80106400 <safestrcpy+0x30>
801063ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801063f0:	0f b6 08             	movzbl (%eax),%ecx
801063f3:	83 c0 01             	add    $0x1,%eax
801063f6:	83 c2 01             	add    $0x1,%edx
801063f9:	88 4a ff             	mov    %cl,-0x1(%edx)
801063fc:	84 c9                	test   %cl,%cl
801063fe:	74 04                	je     80106404 <safestrcpy+0x34>
80106400:	39 d8                	cmp    %ebx,%eax
80106402:	75 ec                	jne    801063f0 <safestrcpy+0x20>
    ;
  *s = 0;
80106404:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80106407:	89 f0                	mov    %esi,%eax
80106409:	5b                   	pop    %ebx
8010640a:	5e                   	pop    %esi
8010640b:	5d                   	pop    %ebp
8010640c:	c3                   	ret    
8010640d:	8d 76 00             	lea    0x0(%esi),%esi

80106410 <strlen>:

int
strlen(const char *s)
{
80106410:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80106411:	31 c0                	xor    %eax,%eax
{
80106413:	89 e5                	mov    %esp,%ebp
80106415:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80106418:	80 3a 00             	cmpb   $0x0,(%edx)
8010641b:	74 0c                	je     80106429 <strlen+0x19>
8010641d:	8d 76 00             	lea    0x0(%esi),%esi
80106420:	83 c0 01             	add    $0x1,%eax
80106423:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80106427:	75 f7                	jne    80106420 <strlen+0x10>
    ;
  return n;
}
80106429:	5d                   	pop    %ebp
8010642a:	c3                   	ret    

8010642b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010642b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010642f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80106433:	55                   	push   %ebp
  pushl %ebx
80106434:	53                   	push   %ebx
  pushl %esi
80106435:	56                   	push   %esi
  pushl %edi
80106436:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80106437:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80106439:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010643b:	5f                   	pop    %edi
  popl %esi
8010643c:	5e                   	pop    %esi
  popl %ebx
8010643d:	5b                   	pop    %ebx
  popl %ebp
8010643e:	5d                   	pop    %ebp
  ret
8010643f:	c3                   	ret    

80106440 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80106440:	55                   	push   %ebp
80106441:	89 e5                	mov    %esp,%ebp
80106443:	53                   	push   %ebx
80106444:	83 ec 04             	sub    $0x4,%esp
80106447:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010644a:	e8 81 eb ff ff       	call   80104fd0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010644f:	8b 00                	mov    (%eax),%eax
80106451:	39 d8                	cmp    %ebx,%eax
80106453:	76 1b                	jbe    80106470 <fetchint+0x30>
80106455:	8d 53 04             	lea    0x4(%ebx),%edx
80106458:	39 d0                	cmp    %edx,%eax
8010645a:	72 14                	jb     80106470 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010645c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010645f:	8b 13                	mov    (%ebx),%edx
80106461:	89 10                	mov    %edx,(%eax)
  return 0;
80106463:	31 c0                	xor    %eax,%eax
}
80106465:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106468:	c9                   	leave  
80106469:	c3                   	ret    
8010646a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80106470:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106475:	eb ee                	jmp    80106465 <fetchint+0x25>
80106477:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010647e:	66 90                	xchg   %ax,%ax

80106480 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80106480:	55                   	push   %ebp
80106481:	89 e5                	mov    %esp,%ebp
80106483:	53                   	push   %ebx
80106484:	83 ec 04             	sub    $0x4,%esp
80106487:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010648a:	e8 41 eb ff ff       	call   80104fd0 <myproc>

  if(addr >= curproc->sz)
8010648f:	39 18                	cmp    %ebx,(%eax)
80106491:	76 2d                	jbe    801064c0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80106493:	8b 55 0c             	mov    0xc(%ebp),%edx
80106496:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80106498:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010649a:	39 d3                	cmp    %edx,%ebx
8010649c:	73 22                	jae    801064c0 <fetchstr+0x40>
8010649e:	89 d8                	mov    %ebx,%eax
801064a0:	eb 0d                	jmp    801064af <fetchstr+0x2f>
801064a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801064a8:	83 c0 01             	add    $0x1,%eax
801064ab:	39 c2                	cmp    %eax,%edx
801064ad:	76 11                	jbe    801064c0 <fetchstr+0x40>
    if(*s == 0)
801064af:	80 38 00             	cmpb   $0x0,(%eax)
801064b2:	75 f4                	jne    801064a8 <fetchstr+0x28>
      return s - *pp;
801064b4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801064b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801064b9:	c9                   	leave  
801064ba:	c3                   	ret    
801064bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801064bf:	90                   	nop
801064c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
801064c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064c8:	c9                   	leave  
801064c9:	c3                   	ret    
801064ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801064d0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801064d0:	55                   	push   %ebp
801064d1:	89 e5                	mov    %esp,%ebp
801064d3:	56                   	push   %esi
801064d4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801064d5:	e8 f6 ea ff ff       	call   80104fd0 <myproc>
801064da:	8b 55 08             	mov    0x8(%ebp),%edx
801064dd:	8b 40 18             	mov    0x18(%eax),%eax
801064e0:	8b 40 44             	mov    0x44(%eax),%eax
801064e3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801064e6:	e8 e5 ea ff ff       	call   80104fd0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801064eb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801064ee:	8b 00                	mov    (%eax),%eax
801064f0:	39 c6                	cmp    %eax,%esi
801064f2:	73 1c                	jae    80106510 <argint+0x40>
801064f4:	8d 53 08             	lea    0x8(%ebx),%edx
801064f7:	39 d0                	cmp    %edx,%eax
801064f9:	72 15                	jb     80106510 <argint+0x40>
  *ip = *(int*)(addr);
801064fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801064fe:	8b 53 04             	mov    0x4(%ebx),%edx
80106501:	89 10                	mov    %edx,(%eax)
  return 0;
80106503:	31 c0                	xor    %eax,%eax
}
80106505:	5b                   	pop    %ebx
80106506:	5e                   	pop    %esi
80106507:	5d                   	pop    %ebp
80106508:	c3                   	ret    
80106509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106510:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106515:	eb ee                	jmp    80106505 <argint+0x35>
80106517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010651e:	66 90                	xchg   %ax,%ax

80106520 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80106520:	55                   	push   %ebp
80106521:	89 e5                	mov    %esp,%ebp
80106523:	57                   	push   %edi
80106524:	56                   	push   %esi
80106525:	53                   	push   %ebx
80106526:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80106529:	e8 a2 ea ff ff       	call   80104fd0 <myproc>
8010652e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106530:	e8 9b ea ff ff       	call   80104fd0 <myproc>
80106535:	8b 55 08             	mov    0x8(%ebp),%edx
80106538:	8b 40 18             	mov    0x18(%eax),%eax
8010653b:	8b 40 44             	mov    0x44(%eax),%eax
8010653e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80106541:	e8 8a ea ff ff       	call   80104fd0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106546:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80106549:	8b 00                	mov    (%eax),%eax
8010654b:	39 c7                	cmp    %eax,%edi
8010654d:	73 31                	jae    80106580 <argptr+0x60>
8010654f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80106552:	39 c8                	cmp    %ecx,%eax
80106554:	72 2a                	jb     80106580 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80106556:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80106559:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010655c:	85 d2                	test   %edx,%edx
8010655e:	78 20                	js     80106580 <argptr+0x60>
80106560:	8b 16                	mov    (%esi),%edx
80106562:	39 c2                	cmp    %eax,%edx
80106564:	76 1a                	jbe    80106580 <argptr+0x60>
80106566:	8b 5d 10             	mov    0x10(%ebp),%ebx
80106569:	01 c3                	add    %eax,%ebx
8010656b:	39 da                	cmp    %ebx,%edx
8010656d:	72 11                	jb     80106580 <argptr+0x60>
    return -1;
  *pp = (char*)i;
8010656f:	8b 55 0c             	mov    0xc(%ebp),%edx
80106572:	89 02                	mov    %eax,(%edx)
  return 0;
80106574:	31 c0                	xor    %eax,%eax
}
80106576:	83 c4 0c             	add    $0xc,%esp
80106579:	5b                   	pop    %ebx
8010657a:	5e                   	pop    %esi
8010657b:	5f                   	pop    %edi
8010657c:	5d                   	pop    %ebp
8010657d:	c3                   	ret    
8010657e:	66 90                	xchg   %ax,%ax
    return -1;
80106580:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106585:	eb ef                	jmp    80106576 <argptr+0x56>
80106587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010658e:	66 90                	xchg   %ax,%ax

80106590 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80106590:	55                   	push   %ebp
80106591:	89 e5                	mov    %esp,%ebp
80106593:	56                   	push   %esi
80106594:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106595:	e8 36 ea ff ff       	call   80104fd0 <myproc>
8010659a:	8b 55 08             	mov    0x8(%ebp),%edx
8010659d:	8b 40 18             	mov    0x18(%eax),%eax
801065a0:	8b 40 44             	mov    0x44(%eax),%eax
801065a3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801065a6:	e8 25 ea ff ff       	call   80104fd0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801065ab:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801065ae:	8b 00                	mov    (%eax),%eax
801065b0:	39 c6                	cmp    %eax,%esi
801065b2:	73 44                	jae    801065f8 <argstr+0x68>
801065b4:	8d 53 08             	lea    0x8(%ebx),%edx
801065b7:	39 d0                	cmp    %edx,%eax
801065b9:	72 3d                	jb     801065f8 <argstr+0x68>
  *ip = *(int*)(addr);
801065bb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
801065be:	e8 0d ea ff ff       	call   80104fd0 <myproc>
  if(addr >= curproc->sz)
801065c3:	3b 18                	cmp    (%eax),%ebx
801065c5:	73 31                	jae    801065f8 <argstr+0x68>
  *pp = (char*)addr;
801065c7:	8b 55 0c             	mov    0xc(%ebp),%edx
801065ca:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801065cc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801065ce:	39 d3                	cmp    %edx,%ebx
801065d0:	73 26                	jae    801065f8 <argstr+0x68>
801065d2:	89 d8                	mov    %ebx,%eax
801065d4:	eb 11                	jmp    801065e7 <argstr+0x57>
801065d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065dd:	8d 76 00             	lea    0x0(%esi),%esi
801065e0:	83 c0 01             	add    $0x1,%eax
801065e3:	39 c2                	cmp    %eax,%edx
801065e5:	76 11                	jbe    801065f8 <argstr+0x68>
    if(*s == 0)
801065e7:	80 38 00             	cmpb   $0x0,(%eax)
801065ea:	75 f4                	jne    801065e0 <argstr+0x50>
      return s - *pp;
801065ec:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801065ee:	5b                   	pop    %ebx
801065ef:	5e                   	pop    %esi
801065f0:	5d                   	pop    %ebp
801065f1:	c3                   	ret    
801065f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801065f8:	5b                   	pop    %ebx
    return -1;
801065f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065fe:	5e                   	pop    %esi
801065ff:	5d                   	pop    %ebp
80106600:	c3                   	ret    
80106601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106608:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010660f:	90                   	nop

80106610 <syscall>:
[SYS_change_queue] sys_change_queue,
};

void
syscall(void)
{
80106610:	55                   	push   %ebp
80106611:	89 e5                	mov    %esp,%ebp
80106613:	53                   	push   %ebx
80106614:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80106617:	e8 b4 e9 ff ff       	call   80104fd0 <myproc>
8010661c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010661e:	8b 40 18             	mov    0x18(%eax),%eax
80106621:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106624:	8d 50 ff             	lea    -0x1(%eax),%edx
80106627:	83 fa 1b             	cmp    $0x1b,%edx
8010662a:	77 24                	ja     80106650 <syscall+0x40>
8010662c:	8b 14 85 20 9a 10 80 	mov    -0x7fef65e0(,%eax,4),%edx
80106633:	85 d2                	test   %edx,%edx
80106635:	74 19                	je     80106650 <syscall+0x40>
    curproc->syscall_count++;
80106637:	83 43 7c 01          	addl   $0x1,0x7c(%ebx)
    curproc->syscall_history[num-1]++;
8010663b:	83 44 83 7c 01       	addl   $0x1,0x7c(%ebx,%eax,4)
    curproc->tf->eax = syscalls[num]();
80106640:	ff d2                	call   *%edx
80106642:	89 c2                	mov    %eax,%edx
80106644:	8b 43 18             	mov    0x18(%ebx),%eax
80106647:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010664a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010664d:	c9                   	leave  
8010664e:	c3                   	ret    
8010664f:	90                   	nop
    cprintf("%d %s: unknown sys call %d\n",
80106650:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80106651:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80106654:	50                   	push   %eax
80106655:	ff 73 10             	push   0x10(%ebx)
80106658:	68 e9 99 10 80       	push   $0x801099e9
8010665d:	e8 9e a0 ff ff       	call   80100700 <cprintf>
    curproc->tf->eax = -1;
80106662:	8b 43 18             	mov    0x18(%ebx),%eax
80106665:	83 c4 10             	add    $0x10,%esp
80106668:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010666f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106672:	c9                   	leave  
80106673:	c3                   	ret    
80106674:	66 90                	xchg   %ax,%ax
80106676:	66 90                	xchg   %ax,%ax
80106678:	66 90                	xchg   %ax,%ax
8010667a:	66 90                	xchg   %ax,%ax
8010667c:	66 90                	xchg   %ax,%ax
8010667e:	66 90                	xchg   %ax,%ax

80106680 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80106680:	55                   	push   %ebp
80106681:	89 e5                	mov    %esp,%ebp
80106683:	57                   	push   %edi
80106684:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106685:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80106688:	53                   	push   %ebx
80106689:	83 ec 34             	sub    $0x34,%esp
8010668c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010668f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80106692:	57                   	push   %edi
80106693:	50                   	push   %eax
{
80106694:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80106697:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010669a:	e8 31 ce ff ff       	call   801034d0 <nameiparent>
8010669f:	83 c4 10             	add    $0x10,%esp
801066a2:	85 c0                	test   %eax,%eax
801066a4:	0f 84 46 01 00 00    	je     801067f0 <create+0x170>
    return 0;
  ilock(dp);
801066aa:	83 ec 0c             	sub    $0xc,%esp
801066ad:	89 c3                	mov    %eax,%ebx
801066af:	50                   	push   %eax
801066b0:	e8 db c4 ff ff       	call   80102b90 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801066b5:	83 c4 0c             	add    $0xc,%esp
801066b8:	6a 00                	push   $0x0
801066ba:	57                   	push   %edi
801066bb:	53                   	push   %ebx
801066bc:	e8 2f ca ff ff       	call   801030f0 <dirlookup>
801066c1:	83 c4 10             	add    $0x10,%esp
801066c4:	89 c6                	mov    %eax,%esi
801066c6:	85 c0                	test   %eax,%eax
801066c8:	74 56                	je     80106720 <create+0xa0>
    iunlockput(dp);
801066ca:	83 ec 0c             	sub    $0xc,%esp
801066cd:	53                   	push   %ebx
801066ce:	e8 4d c7 ff ff       	call   80102e20 <iunlockput>
    ilock(ip);
801066d3:	89 34 24             	mov    %esi,(%esp)
801066d6:	e8 b5 c4 ff ff       	call   80102b90 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801066db:	83 c4 10             	add    $0x10,%esp
801066de:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801066e3:	75 1b                	jne    80106700 <create+0x80>
801066e5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801066ea:	75 14                	jne    80106700 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801066ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066ef:	89 f0                	mov    %esi,%eax
801066f1:	5b                   	pop    %ebx
801066f2:	5e                   	pop    %esi
801066f3:	5f                   	pop    %edi
801066f4:	5d                   	pop    %ebp
801066f5:	c3                   	ret    
801066f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066fd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80106700:	83 ec 0c             	sub    $0xc,%esp
80106703:	56                   	push   %esi
    return 0;
80106704:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80106706:	e8 15 c7 ff ff       	call   80102e20 <iunlockput>
    return 0;
8010670b:	83 c4 10             	add    $0x10,%esp
}
8010670e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106711:	89 f0                	mov    %esi,%eax
80106713:	5b                   	pop    %ebx
80106714:	5e                   	pop    %esi
80106715:	5f                   	pop    %edi
80106716:	5d                   	pop    %ebp
80106717:	c3                   	ret    
80106718:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010671f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80106720:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80106724:	83 ec 08             	sub    $0x8,%esp
80106727:	50                   	push   %eax
80106728:	ff 33                	push   (%ebx)
8010672a:	e8 f1 c2 ff ff       	call   80102a20 <ialloc>
8010672f:	83 c4 10             	add    $0x10,%esp
80106732:	89 c6                	mov    %eax,%esi
80106734:	85 c0                	test   %eax,%eax
80106736:	0f 84 cd 00 00 00    	je     80106809 <create+0x189>
  ilock(ip);
8010673c:	83 ec 0c             	sub    $0xc,%esp
8010673f:	50                   	push   %eax
80106740:	e8 4b c4 ff ff       	call   80102b90 <ilock>
  ip->major = major;
80106745:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80106749:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010674d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80106751:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80106755:	b8 01 00 00 00       	mov    $0x1,%eax
8010675a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010675e:	89 34 24             	mov    %esi,(%esp)
80106761:	e8 7a c3 ff ff       	call   80102ae0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80106766:	83 c4 10             	add    $0x10,%esp
80106769:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010676e:	74 30                	je     801067a0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80106770:	83 ec 04             	sub    $0x4,%esp
80106773:	ff 76 04             	push   0x4(%esi)
80106776:	57                   	push   %edi
80106777:	53                   	push   %ebx
80106778:	e8 73 cc ff ff       	call   801033f0 <dirlink>
8010677d:	83 c4 10             	add    $0x10,%esp
80106780:	85 c0                	test   %eax,%eax
80106782:	78 78                	js     801067fc <create+0x17c>
  iunlockput(dp);
80106784:	83 ec 0c             	sub    $0xc,%esp
80106787:	53                   	push   %ebx
80106788:	e8 93 c6 ff ff       	call   80102e20 <iunlockput>
  return ip;
8010678d:	83 c4 10             	add    $0x10,%esp
}
80106790:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106793:	89 f0                	mov    %esi,%eax
80106795:	5b                   	pop    %ebx
80106796:	5e                   	pop    %esi
80106797:	5f                   	pop    %edi
80106798:	5d                   	pop    %ebp
80106799:	c3                   	ret    
8010679a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801067a0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801067a3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801067a8:	53                   	push   %ebx
801067a9:	e8 32 c3 ff ff       	call   80102ae0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801067ae:	83 c4 0c             	add    $0xc,%esp
801067b1:	ff 76 04             	push   0x4(%esi)
801067b4:	68 b0 9a 10 80       	push   $0x80109ab0
801067b9:	56                   	push   %esi
801067ba:	e8 31 cc ff ff       	call   801033f0 <dirlink>
801067bf:	83 c4 10             	add    $0x10,%esp
801067c2:	85 c0                	test   %eax,%eax
801067c4:	78 18                	js     801067de <create+0x15e>
801067c6:	83 ec 04             	sub    $0x4,%esp
801067c9:	ff 73 04             	push   0x4(%ebx)
801067cc:	68 af 9a 10 80       	push   $0x80109aaf
801067d1:	56                   	push   %esi
801067d2:	e8 19 cc ff ff       	call   801033f0 <dirlink>
801067d7:	83 c4 10             	add    $0x10,%esp
801067da:	85 c0                	test   %eax,%eax
801067dc:	79 92                	jns    80106770 <create+0xf0>
      panic("create dots");
801067de:	83 ec 0c             	sub    $0xc,%esp
801067e1:	68 a3 9a 10 80       	push   $0x80109aa3
801067e6:	e8 95 9b ff ff       	call   80100380 <panic>
801067eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801067ef:	90                   	nop
}
801067f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801067f3:	31 f6                	xor    %esi,%esi
}
801067f5:	5b                   	pop    %ebx
801067f6:	89 f0                	mov    %esi,%eax
801067f8:	5e                   	pop    %esi
801067f9:	5f                   	pop    %edi
801067fa:	5d                   	pop    %ebp
801067fb:	c3                   	ret    
    panic("create: dirlink");
801067fc:	83 ec 0c             	sub    $0xc,%esp
801067ff:	68 b2 9a 10 80       	push   $0x80109ab2
80106804:	e8 77 9b ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80106809:	83 ec 0c             	sub    $0xc,%esp
8010680c:	68 94 9a 10 80       	push   $0x80109a94
80106811:	e8 6a 9b ff ff       	call   80100380 <panic>
80106816:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010681d:	8d 76 00             	lea    0x0(%esi),%esi

80106820 <create_full_pathchar>:
void create_full_pathchar(char* full_path, char* dir, char* filename) {
80106820:	55                   	push   %ebp
80106821:	89 e5                	mov    %esp,%ebp
80106823:	56                   	push   %esi
80106824:	8b 45 08             	mov    0x8(%ebp),%eax
80106827:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010682a:	53                   	push   %ebx
8010682b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    while (*dir) {
8010682e:	0f b6 13             	movzbl (%ebx),%edx
80106831:	84 d2                	test   %dl,%dl
80106833:	74 4b                	je     80106880 <create_full_pathchar+0x60>
80106835:	8d 76 00             	lea    0x0(%esi),%esi
        *p++ = *dir++;
80106838:	83 c3 01             	add    $0x1,%ebx
8010683b:	89 d6                	mov    %edx,%esi
8010683d:	88 10                	mov    %dl,(%eax)
8010683f:	83 c0 01             	add    $0x1,%eax
    while (*dir) {
80106842:	0f b6 13             	movzbl (%ebx),%edx
80106845:	84 d2                	test   %dl,%dl
80106847:	75 ef                	jne    80106838 <create_full_pathchar+0x18>
    if (*(p - 1) != '/') {
80106849:	89 f3                	mov    %esi,%ebx
8010684b:	80 fb 2f             	cmp    $0x2f,%bl
8010684e:	74 18                	je     80106868 <create_full_pathchar+0x48>
        *p++ = '/';
80106850:	c6 00 2f             	movb   $0x2f,(%eax)
80106853:	83 c0 01             	add    $0x1,%eax
    while (*filename) {
80106856:	eb 10                	jmp    80106868 <create_full_pathchar+0x48>
80106858:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010685f:	90                   	nop
        *p++ = *filename++;
80106860:	88 10                	mov    %dl,(%eax)
80106862:	83 c0 01             	add    $0x1,%eax
80106865:	83 c1 01             	add    $0x1,%ecx
    while (*filename) {
80106868:	0f b6 11             	movzbl (%ecx),%edx
8010686b:	84 d2                	test   %dl,%dl
8010686d:	75 f1                	jne    80106860 <create_full_pathchar+0x40>
    *p = '\0';
8010686f:	c6 00 00             	movb   $0x0,(%eax)
}
80106872:	5b                   	pop    %ebx
80106873:	5e                   	pop    %esi
80106874:	5d                   	pop    %ebp
80106875:	c3                   	ret    
80106876:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010687d:	8d 76 00             	lea    0x0(%esi),%esi
    if (*(p - 1) != '/') {
80106880:	0f b6 70 ff          	movzbl -0x1(%eax),%esi
80106884:	eb c3                	jmp    80106849 <create_full_pathchar+0x29>
80106886:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010688d:	8d 76 00             	lea    0x0(%esi),%esi

80106890 <remove_file>:
int remove_file(struct inode *dp, char *name) {
80106890:	55                   	push   %ebp
80106891:	89 e5                	mov    %esp,%ebp
80106893:	57                   	push   %edi
80106894:	56                   	push   %esi
80106895:	53                   	push   %ebx
80106896:	83 ec 2c             	sub    $0x2c,%esp
80106899:	8b 5d 08             	mov    0x8(%ebp),%ebx
    for (i = 0; i < dp->size; i += sizeof(de)) {
8010689c:	8b 43 58             	mov    0x58(%ebx),%eax
8010689f:	85 c0                	test   %eax,%eax
801068a1:	74 44                	je     801068e7 <remove_file+0x57>
801068a3:	31 ff                	xor    %edi,%edi
801068a5:	8d 75 d8             	lea    -0x28(%ebp),%esi
801068a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068af:	90                   	nop
        if (readi(dp, (char*)&de, i, sizeof(de)) != sizeof(de)) {
801068b0:	6a 10                	push   $0x10
801068b2:	57                   	push   %edi
801068b3:	56                   	push   %esi
801068b4:	53                   	push   %ebx
801068b5:	e8 e6 c5 ff ff       	call   80102ea0 <readi>
801068ba:	83 c4 10             	add    $0x10,%esp
801068bd:	83 f8 10             	cmp    $0x10,%eax
801068c0:	75 76                	jne    80106938 <remove_file+0xa8>
        if (de.inum == 0) {
801068c2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801068c7:	74 16                	je     801068df <remove_file+0x4f>
        if (namecmp(name, de.name) == 0) {
801068c9:	83 ec 08             	sub    $0x8,%esp
801068cc:	8d 45 da             	lea    -0x26(%ebp),%eax
801068cf:	50                   	push   %eax
801068d0:	ff 75 0c             	push   0xc(%ebp)
801068d3:	e8 f8 c7 ff ff       	call   801030d0 <namecmp>
801068d8:	83 c4 10             	add    $0x10,%esp
801068db:	85 c0                	test   %eax,%eax
801068dd:	74 21                	je     80106900 <remove_file+0x70>
    for (i = 0; i < dp->size; i += sizeof(de)) {
801068df:	83 c7 10             	add    $0x10,%edi
801068e2:	39 7b 58             	cmp    %edi,0x58(%ebx)
801068e5:	77 c9                	ja     801068b0 <remove_file+0x20>
    return -1;
801068e7:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
}
801068ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068ef:	89 c8                	mov    %ecx,%eax
801068f1:	5b                   	pop    %ebx
801068f2:	5e                   	pop    %esi
801068f3:	5f                   	pop    %edi
801068f4:	5d                   	pop    %ebp
801068f5:	c3                   	ret    
801068f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068fd:	8d 76 00             	lea    0x0(%esi),%esi
            memset(&de, 0, sizeof(de));
80106900:	83 ec 04             	sub    $0x4,%esp
80106903:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80106906:	6a 10                	push   $0x10
80106908:	6a 00                	push   $0x0
8010690a:	56                   	push   %esi
8010690b:	e8 00 f9 ff ff       	call   80106210 <memset>
            if (writei(dp, (char*)&de, i, sizeof(de)) != sizeof(de)) {
80106910:	6a 10                	push   $0x10
80106912:	57                   	push   %edi
80106913:	56                   	push   %esi
80106914:	53                   	push   %ebx
80106915:	e8 86 c6 ff ff       	call   80102fa0 <writei>
8010691a:	83 c4 20             	add    $0x20,%esp
8010691d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80106920:	83 f8 10             	cmp    $0x10,%eax
80106923:	74 c7                	je     801068ec <remove_file+0x5c>
                panic("remove_file: writei");
80106925:	83 ec 0c             	sub    $0xc,%esp
80106928:	68 d5 9a 10 80       	push   $0x80109ad5
8010692d:	e8 4e 9a ff ff       	call   80100380 <panic>
80106932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            panic("remove_file: readi");
80106938:	83 ec 0c             	sub    $0xc,%esp
8010693b:	68 c2 9a 10 80       	push   $0x80109ac2
80106940:	e8 3b 9a ff ff       	call   80100380 <panic>
80106945:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010694c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106950 <sys_dup>:
{
80106950:	55                   	push   %ebp
80106951:	89 e5                	mov    %esp,%ebp
80106953:	56                   	push   %esi
80106954:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106955:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106958:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010695b:	50                   	push   %eax
8010695c:	6a 00                	push   $0x0
8010695e:	e8 6d fb ff ff       	call   801064d0 <argint>
80106963:	83 c4 10             	add    $0x10,%esp
80106966:	85 c0                	test   %eax,%eax
80106968:	78 36                	js     801069a0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010696a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010696e:	77 30                	ja     801069a0 <sys_dup+0x50>
80106970:	e8 5b e6 ff ff       	call   80104fd0 <myproc>
80106975:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106978:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010697c:	85 f6                	test   %esi,%esi
8010697e:	74 20                	je     801069a0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80106980:	e8 4b e6 ff ff       	call   80104fd0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106985:	31 db                	xor    %ebx,%ebx
80106987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010698e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80106990:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106994:	85 d2                	test   %edx,%edx
80106996:	74 18                	je     801069b0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80106998:	83 c3 01             	add    $0x1,%ebx
8010699b:	83 fb 10             	cmp    $0x10,%ebx
8010699e:	75 f0                	jne    80106990 <sys_dup+0x40>
}
801069a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801069a3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801069a8:	89 d8                	mov    %ebx,%eax
801069aa:	5b                   	pop    %ebx
801069ab:	5e                   	pop    %esi
801069ac:	5d                   	pop    %ebp
801069ad:	c3                   	ret    
801069ae:	66 90                	xchg   %ax,%ax
  filedup(f);
801069b0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801069b3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801069b7:	56                   	push   %esi
801069b8:	e8 f3 b8 ff ff       	call   801022b0 <filedup>
  return fd;
801069bd:	83 c4 10             	add    $0x10,%esp
}
801069c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801069c3:	89 d8                	mov    %ebx,%eax
801069c5:	5b                   	pop    %ebx
801069c6:	5e                   	pop    %esi
801069c7:	5d                   	pop    %ebp
801069c8:	c3                   	ret    
801069c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801069d0 <sys_read>:
{
801069d0:	55                   	push   %ebp
801069d1:	89 e5                	mov    %esp,%ebp
801069d3:	56                   	push   %esi
801069d4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801069d5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801069d8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801069db:	53                   	push   %ebx
801069dc:	6a 00                	push   $0x0
801069de:	e8 ed fa ff ff       	call   801064d0 <argint>
801069e3:	83 c4 10             	add    $0x10,%esp
801069e6:	85 c0                	test   %eax,%eax
801069e8:	78 5e                	js     80106a48 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801069ea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801069ee:	77 58                	ja     80106a48 <sys_read+0x78>
801069f0:	e8 db e5 ff ff       	call   80104fd0 <myproc>
801069f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801069f8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801069fc:	85 f6                	test   %esi,%esi
801069fe:	74 48                	je     80106a48 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106a00:	83 ec 08             	sub    $0x8,%esp
80106a03:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a06:	50                   	push   %eax
80106a07:	6a 02                	push   $0x2
80106a09:	e8 c2 fa ff ff       	call   801064d0 <argint>
80106a0e:	83 c4 10             	add    $0x10,%esp
80106a11:	85 c0                	test   %eax,%eax
80106a13:	78 33                	js     80106a48 <sys_read+0x78>
80106a15:	83 ec 04             	sub    $0x4,%esp
80106a18:	ff 75 f0             	push   -0x10(%ebp)
80106a1b:	53                   	push   %ebx
80106a1c:	6a 01                	push   $0x1
80106a1e:	e8 fd fa ff ff       	call   80106520 <argptr>
80106a23:	83 c4 10             	add    $0x10,%esp
80106a26:	85 c0                	test   %eax,%eax
80106a28:	78 1e                	js     80106a48 <sys_read+0x78>
  return fileread(f, p, n);
80106a2a:	83 ec 04             	sub    $0x4,%esp
80106a2d:	ff 75 f0             	push   -0x10(%ebp)
80106a30:	ff 75 f4             	push   -0xc(%ebp)
80106a33:	56                   	push   %esi
80106a34:	e8 f7 b9 ff ff       	call   80102430 <fileread>
80106a39:	83 c4 10             	add    $0x10,%esp
}
80106a3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106a3f:	5b                   	pop    %ebx
80106a40:	5e                   	pop    %esi
80106a41:	5d                   	pop    %ebp
80106a42:	c3                   	ret    
80106a43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106a47:	90                   	nop
    return -1;
80106a48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a4d:	eb ed                	jmp    80106a3c <sys_read+0x6c>
80106a4f:	90                   	nop

80106a50 <sys_write>:
{
80106a50:	55                   	push   %ebp
80106a51:	89 e5                	mov    %esp,%ebp
80106a53:	56                   	push   %esi
80106a54:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106a55:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80106a58:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80106a5b:	53                   	push   %ebx
80106a5c:	6a 00                	push   $0x0
80106a5e:	e8 6d fa ff ff       	call   801064d0 <argint>
80106a63:	83 c4 10             	add    $0x10,%esp
80106a66:	85 c0                	test   %eax,%eax
80106a68:	78 5e                	js     80106ac8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80106a6a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80106a6e:	77 58                	ja     80106ac8 <sys_write+0x78>
80106a70:	e8 5b e5 ff ff       	call   80104fd0 <myproc>
80106a75:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a78:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80106a7c:	85 f6                	test   %esi,%esi
80106a7e:	74 48                	je     80106ac8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106a80:	83 ec 08             	sub    $0x8,%esp
80106a83:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a86:	50                   	push   %eax
80106a87:	6a 02                	push   $0x2
80106a89:	e8 42 fa ff ff       	call   801064d0 <argint>
80106a8e:	83 c4 10             	add    $0x10,%esp
80106a91:	85 c0                	test   %eax,%eax
80106a93:	78 33                	js     80106ac8 <sys_write+0x78>
80106a95:	83 ec 04             	sub    $0x4,%esp
80106a98:	ff 75 f0             	push   -0x10(%ebp)
80106a9b:	53                   	push   %ebx
80106a9c:	6a 01                	push   $0x1
80106a9e:	e8 7d fa ff ff       	call   80106520 <argptr>
80106aa3:	83 c4 10             	add    $0x10,%esp
80106aa6:	85 c0                	test   %eax,%eax
80106aa8:	78 1e                	js     80106ac8 <sys_write+0x78>
  return filewrite(f, p, n);
80106aaa:	83 ec 04             	sub    $0x4,%esp
80106aad:	ff 75 f0             	push   -0x10(%ebp)
80106ab0:	ff 75 f4             	push   -0xc(%ebp)
80106ab3:	56                   	push   %esi
80106ab4:	e8 07 ba ff ff       	call   801024c0 <filewrite>
80106ab9:	83 c4 10             	add    $0x10,%esp
}
80106abc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106abf:	5b                   	pop    %ebx
80106ac0:	5e                   	pop    %esi
80106ac1:	5d                   	pop    %ebp
80106ac2:	c3                   	ret    
80106ac3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ac7:	90                   	nop
    return -1;
80106ac8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106acd:	eb ed                	jmp    80106abc <sys_write+0x6c>
80106acf:	90                   	nop

80106ad0 <sys_close>:
{
80106ad0:	55                   	push   %ebp
80106ad1:	89 e5                	mov    %esp,%ebp
80106ad3:	56                   	push   %esi
80106ad4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106ad5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106ad8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80106adb:	50                   	push   %eax
80106adc:	6a 00                	push   $0x0
80106ade:	e8 ed f9 ff ff       	call   801064d0 <argint>
80106ae3:	83 c4 10             	add    $0x10,%esp
80106ae6:	85 c0                	test   %eax,%eax
80106ae8:	78 3e                	js     80106b28 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80106aea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80106aee:	77 38                	ja     80106b28 <sys_close+0x58>
80106af0:	e8 db e4 ff ff       	call   80104fd0 <myproc>
80106af5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106af8:	8d 5a 08             	lea    0x8(%edx),%ebx
80106afb:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80106aff:	85 f6                	test   %esi,%esi
80106b01:	74 25                	je     80106b28 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80106b03:	e8 c8 e4 ff ff       	call   80104fd0 <myproc>
  fileclose(f);
80106b08:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80106b0b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80106b12:	00 
  fileclose(f);
80106b13:	56                   	push   %esi
80106b14:	e8 e7 b7 ff ff       	call   80102300 <fileclose>
  return 0;
80106b19:	83 c4 10             	add    $0x10,%esp
80106b1c:	31 c0                	xor    %eax,%eax
}
80106b1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106b21:	5b                   	pop    %ebx
80106b22:	5e                   	pop    %esi
80106b23:	5d                   	pop    %ebp
80106b24:	c3                   	ret    
80106b25:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106b28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b2d:	eb ef                	jmp    80106b1e <sys_close+0x4e>
80106b2f:	90                   	nop

80106b30 <sys_fstat>:
{
80106b30:	55                   	push   %ebp
80106b31:	89 e5                	mov    %esp,%ebp
80106b33:	56                   	push   %esi
80106b34:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106b35:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80106b38:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80106b3b:	53                   	push   %ebx
80106b3c:	6a 00                	push   $0x0
80106b3e:	e8 8d f9 ff ff       	call   801064d0 <argint>
80106b43:	83 c4 10             	add    $0x10,%esp
80106b46:	85 c0                	test   %eax,%eax
80106b48:	78 46                	js     80106b90 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80106b4a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80106b4e:	77 40                	ja     80106b90 <sys_fstat+0x60>
80106b50:	e8 7b e4 ff ff       	call   80104fd0 <myproc>
80106b55:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106b58:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80106b5c:	85 f6                	test   %esi,%esi
80106b5e:	74 30                	je     80106b90 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106b60:	83 ec 04             	sub    $0x4,%esp
80106b63:	6a 14                	push   $0x14
80106b65:	53                   	push   %ebx
80106b66:	6a 01                	push   $0x1
80106b68:	e8 b3 f9 ff ff       	call   80106520 <argptr>
80106b6d:	83 c4 10             	add    $0x10,%esp
80106b70:	85 c0                	test   %eax,%eax
80106b72:	78 1c                	js     80106b90 <sys_fstat+0x60>
  return filestat(f, st);
80106b74:	83 ec 08             	sub    $0x8,%esp
80106b77:	ff 75 f4             	push   -0xc(%ebp)
80106b7a:	56                   	push   %esi
80106b7b:	e8 60 b8 ff ff       	call   801023e0 <filestat>
80106b80:	83 c4 10             	add    $0x10,%esp
}
80106b83:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106b86:	5b                   	pop    %ebx
80106b87:	5e                   	pop    %esi
80106b88:	5d                   	pop    %ebp
80106b89:	c3                   	ret    
80106b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80106b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b95:	eb ec                	jmp    80106b83 <sys_fstat+0x53>
80106b97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b9e:	66 90                	xchg   %ax,%ax

80106ba0 <sys_link>:
{
80106ba0:	55                   	push   %ebp
80106ba1:	89 e5                	mov    %esp,%ebp
80106ba3:	57                   	push   %edi
80106ba4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106ba5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80106ba8:	53                   	push   %ebx
80106ba9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106bac:	50                   	push   %eax
80106bad:	6a 00                	push   $0x0
80106baf:	e8 dc f9 ff ff       	call   80106590 <argstr>
80106bb4:	83 c4 10             	add    $0x10,%esp
80106bb7:	85 c0                	test   %eax,%eax
80106bb9:	0f 88 fb 00 00 00    	js     80106cba <sys_link+0x11a>
80106bbf:	83 ec 08             	sub    $0x8,%esp
80106bc2:	8d 45 d0             	lea    -0x30(%ebp),%eax
80106bc5:	50                   	push   %eax
80106bc6:	6a 01                	push   $0x1
80106bc8:	e8 c3 f9 ff ff       	call   80106590 <argstr>
80106bcd:	83 c4 10             	add    $0x10,%esp
80106bd0:	85 c0                	test   %eax,%eax
80106bd2:	0f 88 e2 00 00 00    	js     80106cba <sys_link+0x11a>
  begin_op();
80106bd8:	e8 93 d5 ff ff       	call   80104170 <begin_op>
  if((ip = namei(old)) == 0){
80106bdd:	83 ec 0c             	sub    $0xc,%esp
80106be0:	ff 75 d4             	push   -0x2c(%ebp)
80106be3:	e8 c8 c8 ff ff       	call   801034b0 <namei>
80106be8:	83 c4 10             	add    $0x10,%esp
80106beb:	89 c3                	mov    %eax,%ebx
80106bed:	85 c0                	test   %eax,%eax
80106bef:	0f 84 e4 00 00 00    	je     80106cd9 <sys_link+0x139>
  ilock(ip);
80106bf5:	83 ec 0c             	sub    $0xc,%esp
80106bf8:	50                   	push   %eax
80106bf9:	e8 92 bf ff ff       	call   80102b90 <ilock>
  if(ip->type == T_DIR){
80106bfe:	83 c4 10             	add    $0x10,%esp
80106c01:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106c06:	0f 84 b5 00 00 00    	je     80106cc1 <sys_link+0x121>
  iupdate(ip);
80106c0c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80106c0f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80106c14:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80106c17:	53                   	push   %ebx
80106c18:	e8 c3 be ff ff       	call   80102ae0 <iupdate>
  iunlock(ip);
80106c1d:	89 1c 24             	mov    %ebx,(%esp)
80106c20:	e8 4b c0 ff ff       	call   80102c70 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80106c25:	58                   	pop    %eax
80106c26:	5a                   	pop    %edx
80106c27:	57                   	push   %edi
80106c28:	ff 75 d0             	push   -0x30(%ebp)
80106c2b:	e8 a0 c8 ff ff       	call   801034d0 <nameiparent>
80106c30:	83 c4 10             	add    $0x10,%esp
80106c33:	89 c6                	mov    %eax,%esi
80106c35:	85 c0                	test   %eax,%eax
80106c37:	74 5b                	je     80106c94 <sys_link+0xf4>
  ilock(dp);
80106c39:	83 ec 0c             	sub    $0xc,%esp
80106c3c:	50                   	push   %eax
80106c3d:	e8 4e bf ff ff       	call   80102b90 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106c42:	8b 03                	mov    (%ebx),%eax
80106c44:	83 c4 10             	add    $0x10,%esp
80106c47:	39 06                	cmp    %eax,(%esi)
80106c49:	75 3d                	jne    80106c88 <sys_link+0xe8>
80106c4b:	83 ec 04             	sub    $0x4,%esp
80106c4e:	ff 73 04             	push   0x4(%ebx)
80106c51:	57                   	push   %edi
80106c52:	56                   	push   %esi
80106c53:	e8 98 c7 ff ff       	call   801033f0 <dirlink>
80106c58:	83 c4 10             	add    $0x10,%esp
80106c5b:	85 c0                	test   %eax,%eax
80106c5d:	78 29                	js     80106c88 <sys_link+0xe8>
  iunlockput(dp);
80106c5f:	83 ec 0c             	sub    $0xc,%esp
80106c62:	56                   	push   %esi
80106c63:	e8 b8 c1 ff ff       	call   80102e20 <iunlockput>
  iput(ip);
80106c68:	89 1c 24             	mov    %ebx,(%esp)
80106c6b:	e8 50 c0 ff ff       	call   80102cc0 <iput>
  end_op();
80106c70:	e8 6b d5 ff ff       	call   801041e0 <end_op>
  return 0;
80106c75:	83 c4 10             	add    $0x10,%esp
80106c78:	31 c0                	xor    %eax,%eax
}
80106c7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c7d:	5b                   	pop    %ebx
80106c7e:	5e                   	pop    %esi
80106c7f:	5f                   	pop    %edi
80106c80:	5d                   	pop    %ebp
80106c81:	c3                   	ret    
80106c82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80106c88:	83 ec 0c             	sub    $0xc,%esp
80106c8b:	56                   	push   %esi
80106c8c:	e8 8f c1 ff ff       	call   80102e20 <iunlockput>
    goto bad;
80106c91:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80106c94:	83 ec 0c             	sub    $0xc,%esp
80106c97:	53                   	push   %ebx
80106c98:	e8 f3 be ff ff       	call   80102b90 <ilock>
  ip->nlink--;
80106c9d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80106ca2:	89 1c 24             	mov    %ebx,(%esp)
80106ca5:	e8 36 be ff ff       	call   80102ae0 <iupdate>
  iunlockput(ip);
80106caa:	89 1c 24             	mov    %ebx,(%esp)
80106cad:	e8 6e c1 ff ff       	call   80102e20 <iunlockput>
  end_op();
80106cb2:	e8 29 d5 ff ff       	call   801041e0 <end_op>
  return -1;
80106cb7:	83 c4 10             	add    $0x10,%esp
80106cba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cbf:	eb b9                	jmp    80106c7a <sys_link+0xda>
    iunlockput(ip);
80106cc1:	83 ec 0c             	sub    $0xc,%esp
80106cc4:	53                   	push   %ebx
80106cc5:	e8 56 c1 ff ff       	call   80102e20 <iunlockput>
    end_op();
80106cca:	e8 11 d5 ff ff       	call   801041e0 <end_op>
    return -1;
80106ccf:	83 c4 10             	add    $0x10,%esp
80106cd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cd7:	eb a1                	jmp    80106c7a <sys_link+0xda>
    end_op();
80106cd9:	e8 02 d5 ff ff       	call   801041e0 <end_op>
    return -1;
80106cde:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ce3:	eb 95                	jmp    80106c7a <sys_link+0xda>
80106ce5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106cf0 <sys_unlink>:
{
80106cf0:	55                   	push   %ebp
80106cf1:	89 e5                	mov    %esp,%ebp
80106cf3:	57                   	push   %edi
80106cf4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80106cf5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80106cf8:	53                   	push   %ebx
80106cf9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80106cfc:	50                   	push   %eax
80106cfd:	6a 00                	push   $0x0
80106cff:	e8 8c f8 ff ff       	call   80106590 <argstr>
80106d04:	83 c4 10             	add    $0x10,%esp
80106d07:	85 c0                	test   %eax,%eax
80106d09:	0f 88 7a 01 00 00    	js     80106e89 <sys_unlink+0x199>
  begin_op();
80106d0f:	e8 5c d4 ff ff       	call   80104170 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106d14:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80106d17:	83 ec 08             	sub    $0x8,%esp
80106d1a:	53                   	push   %ebx
80106d1b:	ff 75 c0             	push   -0x40(%ebp)
80106d1e:	e8 ad c7 ff ff       	call   801034d0 <nameiparent>
80106d23:	83 c4 10             	add    $0x10,%esp
80106d26:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80106d29:	85 c0                	test   %eax,%eax
80106d2b:	0f 84 62 01 00 00    	je     80106e93 <sys_unlink+0x1a3>
  ilock(dp);
80106d31:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80106d34:	83 ec 0c             	sub    $0xc,%esp
80106d37:	57                   	push   %edi
80106d38:	e8 53 be ff ff       	call   80102b90 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80106d3d:	58                   	pop    %eax
80106d3e:	5a                   	pop    %edx
80106d3f:	68 b0 9a 10 80       	push   $0x80109ab0
80106d44:	53                   	push   %ebx
80106d45:	e8 86 c3 ff ff       	call   801030d0 <namecmp>
80106d4a:	83 c4 10             	add    $0x10,%esp
80106d4d:	85 c0                	test   %eax,%eax
80106d4f:	0f 84 fb 00 00 00    	je     80106e50 <sys_unlink+0x160>
80106d55:	83 ec 08             	sub    $0x8,%esp
80106d58:	68 af 9a 10 80       	push   $0x80109aaf
80106d5d:	53                   	push   %ebx
80106d5e:	e8 6d c3 ff ff       	call   801030d0 <namecmp>
80106d63:	83 c4 10             	add    $0x10,%esp
80106d66:	85 c0                	test   %eax,%eax
80106d68:	0f 84 e2 00 00 00    	je     80106e50 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
80106d6e:	83 ec 04             	sub    $0x4,%esp
80106d71:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80106d74:	50                   	push   %eax
80106d75:	53                   	push   %ebx
80106d76:	57                   	push   %edi
80106d77:	e8 74 c3 ff ff       	call   801030f0 <dirlookup>
80106d7c:	83 c4 10             	add    $0x10,%esp
80106d7f:	89 c3                	mov    %eax,%ebx
80106d81:	85 c0                	test   %eax,%eax
80106d83:	0f 84 c7 00 00 00    	je     80106e50 <sys_unlink+0x160>
  ilock(ip);
80106d89:	83 ec 0c             	sub    $0xc,%esp
80106d8c:	50                   	push   %eax
80106d8d:	e8 fe bd ff ff       	call   80102b90 <ilock>
  if(ip->nlink < 1)
80106d92:	83 c4 10             	add    $0x10,%esp
80106d95:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80106d9a:	0f 8e 1c 01 00 00    	jle    80106ebc <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106da0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106da5:	8d 7d d8             	lea    -0x28(%ebp),%edi
80106da8:	74 66                	je     80106e10 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80106daa:	83 ec 04             	sub    $0x4,%esp
80106dad:	6a 10                	push   $0x10
80106daf:	6a 00                	push   $0x0
80106db1:	57                   	push   %edi
80106db2:	e8 59 f4 ff ff       	call   80106210 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106db7:	6a 10                	push   $0x10
80106db9:	ff 75 c4             	push   -0x3c(%ebp)
80106dbc:	57                   	push   %edi
80106dbd:	ff 75 b4             	push   -0x4c(%ebp)
80106dc0:	e8 db c1 ff ff       	call   80102fa0 <writei>
80106dc5:	83 c4 20             	add    $0x20,%esp
80106dc8:	83 f8 10             	cmp    $0x10,%eax
80106dcb:	0f 85 de 00 00 00    	jne    80106eaf <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80106dd1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106dd6:	0f 84 94 00 00 00    	je     80106e70 <sys_unlink+0x180>
  iunlockput(dp);
80106ddc:	83 ec 0c             	sub    $0xc,%esp
80106ddf:	ff 75 b4             	push   -0x4c(%ebp)
80106de2:	e8 39 c0 ff ff       	call   80102e20 <iunlockput>
  ip->nlink--;
80106de7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80106dec:	89 1c 24             	mov    %ebx,(%esp)
80106def:	e8 ec bc ff ff       	call   80102ae0 <iupdate>
  iunlockput(ip);
80106df4:	89 1c 24             	mov    %ebx,(%esp)
80106df7:	e8 24 c0 ff ff       	call   80102e20 <iunlockput>
  end_op();
80106dfc:	e8 df d3 ff ff       	call   801041e0 <end_op>
  return 0;
80106e01:	83 c4 10             	add    $0x10,%esp
80106e04:	31 c0                	xor    %eax,%eax
}
80106e06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e09:	5b                   	pop    %ebx
80106e0a:	5e                   	pop    %esi
80106e0b:	5f                   	pop    %edi
80106e0c:	5d                   	pop    %ebp
80106e0d:	c3                   	ret    
80106e0e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106e10:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80106e14:	76 94                	jbe    80106daa <sys_unlink+0xba>
80106e16:	be 20 00 00 00       	mov    $0x20,%esi
80106e1b:	eb 0b                	jmp    80106e28 <sys_unlink+0x138>
80106e1d:	8d 76 00             	lea    0x0(%esi),%esi
80106e20:	83 c6 10             	add    $0x10,%esi
80106e23:	3b 73 58             	cmp    0x58(%ebx),%esi
80106e26:	73 82                	jae    80106daa <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106e28:	6a 10                	push   $0x10
80106e2a:	56                   	push   %esi
80106e2b:	57                   	push   %edi
80106e2c:	53                   	push   %ebx
80106e2d:	e8 6e c0 ff ff       	call   80102ea0 <readi>
80106e32:	83 c4 10             	add    $0x10,%esp
80106e35:	83 f8 10             	cmp    $0x10,%eax
80106e38:	75 68                	jne    80106ea2 <sys_unlink+0x1b2>
    if(de.inum != 0)
80106e3a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80106e3f:	74 df                	je     80106e20 <sys_unlink+0x130>
    iunlockput(ip);
80106e41:	83 ec 0c             	sub    $0xc,%esp
80106e44:	53                   	push   %ebx
80106e45:	e8 d6 bf ff ff       	call   80102e20 <iunlockput>
    goto bad;
80106e4a:	83 c4 10             	add    $0x10,%esp
80106e4d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80106e50:	83 ec 0c             	sub    $0xc,%esp
80106e53:	ff 75 b4             	push   -0x4c(%ebp)
80106e56:	e8 c5 bf ff ff       	call   80102e20 <iunlockput>
  end_op();
80106e5b:	e8 80 d3 ff ff       	call   801041e0 <end_op>
  return -1;
80106e60:	83 c4 10             	add    $0x10,%esp
80106e63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e68:	eb 9c                	jmp    80106e06 <sys_unlink+0x116>
80106e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80106e70:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80106e73:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80106e76:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80106e7b:	50                   	push   %eax
80106e7c:	e8 5f bc ff ff       	call   80102ae0 <iupdate>
80106e81:	83 c4 10             	add    $0x10,%esp
80106e84:	e9 53 ff ff ff       	jmp    80106ddc <sys_unlink+0xec>
    return -1;
80106e89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e8e:	e9 73 ff ff ff       	jmp    80106e06 <sys_unlink+0x116>
    end_op();
80106e93:	e8 48 d3 ff ff       	call   801041e0 <end_op>
    return -1;
80106e98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e9d:	e9 64 ff ff ff       	jmp    80106e06 <sys_unlink+0x116>
      panic("isdirempty: readi");
80106ea2:	83 ec 0c             	sub    $0xc,%esp
80106ea5:	68 fb 9a 10 80       	push   $0x80109afb
80106eaa:	e8 d1 94 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
80106eaf:	83 ec 0c             	sub    $0xc,%esp
80106eb2:	68 0d 9b 10 80       	push   $0x80109b0d
80106eb7:	e8 c4 94 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
80106ebc:	83 ec 0c             	sub    $0xc,%esp
80106ebf:	68 e9 9a 10 80       	push   $0x80109ae9
80106ec4:	e8 b7 94 ff ff       	call   80100380 <panic>
80106ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ed0 <sys_open>:

int
sys_open(void)
{
80106ed0:	55                   	push   %ebp
80106ed1:	89 e5                	mov    %esp,%ebp
80106ed3:	57                   	push   %edi
80106ed4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106ed5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80106ed8:	53                   	push   %ebx
80106ed9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106edc:	50                   	push   %eax
80106edd:	6a 00                	push   $0x0
80106edf:	e8 ac f6 ff ff       	call   80106590 <argstr>
80106ee4:	83 c4 10             	add    $0x10,%esp
80106ee7:	85 c0                	test   %eax,%eax
80106ee9:	0f 88 8e 00 00 00    	js     80106f7d <sys_open+0xad>
80106eef:	83 ec 08             	sub    $0x8,%esp
80106ef2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106ef5:	50                   	push   %eax
80106ef6:	6a 01                	push   $0x1
80106ef8:	e8 d3 f5 ff ff       	call   801064d0 <argint>
80106efd:	83 c4 10             	add    $0x10,%esp
80106f00:	85 c0                	test   %eax,%eax
80106f02:	78 79                	js     80106f7d <sys_open+0xad>
    return -1;

  begin_op();
80106f04:	e8 67 d2 ff ff       	call   80104170 <begin_op>

  if(omode & O_CREATE){
80106f09:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80106f0d:	75 79                	jne    80106f88 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80106f0f:	83 ec 0c             	sub    $0xc,%esp
80106f12:	ff 75 e0             	push   -0x20(%ebp)
80106f15:	e8 96 c5 ff ff       	call   801034b0 <namei>
80106f1a:	83 c4 10             	add    $0x10,%esp
80106f1d:	89 c6                	mov    %eax,%esi
80106f1f:	85 c0                	test   %eax,%eax
80106f21:	0f 84 7e 00 00 00    	je     80106fa5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80106f27:	83 ec 0c             	sub    $0xc,%esp
80106f2a:	50                   	push   %eax
80106f2b:	e8 60 bc ff ff       	call   80102b90 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106f30:	83 c4 10             	add    $0x10,%esp
80106f33:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80106f38:	0f 84 c2 00 00 00    	je     80107000 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106f3e:	e8 fd b2 ff ff       	call   80102240 <filealloc>
80106f43:	89 c7                	mov    %eax,%edi
80106f45:	85 c0                	test   %eax,%eax
80106f47:	74 23                	je     80106f6c <sys_open+0x9c>
  struct proc *curproc = myproc();
80106f49:	e8 82 e0 ff ff       	call   80104fd0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106f4e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80106f50:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106f54:	85 d2                	test   %edx,%edx
80106f56:	74 60                	je     80106fb8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80106f58:	83 c3 01             	add    $0x1,%ebx
80106f5b:	83 fb 10             	cmp    $0x10,%ebx
80106f5e:	75 f0                	jne    80106f50 <sys_open+0x80>
    if(f)
      fileclose(f);
80106f60:	83 ec 0c             	sub    $0xc,%esp
80106f63:	57                   	push   %edi
80106f64:	e8 97 b3 ff ff       	call   80102300 <fileclose>
80106f69:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80106f6c:	83 ec 0c             	sub    $0xc,%esp
80106f6f:	56                   	push   %esi
80106f70:	e8 ab be ff ff       	call   80102e20 <iunlockput>
    end_op();
80106f75:	e8 66 d2 ff ff       	call   801041e0 <end_op>
    return -1;
80106f7a:	83 c4 10             	add    $0x10,%esp
80106f7d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106f82:	eb 6d                	jmp    80106ff1 <sys_open+0x121>
80106f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80106f88:	83 ec 0c             	sub    $0xc,%esp
80106f8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f8e:	31 c9                	xor    %ecx,%ecx
80106f90:	ba 02 00 00 00       	mov    $0x2,%edx
80106f95:	6a 00                	push   $0x0
80106f97:	e8 e4 f6 ff ff       	call   80106680 <create>
    if(ip == 0){
80106f9c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80106f9f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80106fa1:	85 c0                	test   %eax,%eax
80106fa3:	75 99                	jne    80106f3e <sys_open+0x6e>
      end_op();
80106fa5:	e8 36 d2 ff ff       	call   801041e0 <end_op>
      return -1;
80106faa:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106faf:	eb 40                	jmp    80106ff1 <sys_open+0x121>
80106fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80106fb8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80106fbb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80106fbf:	56                   	push   %esi
80106fc0:	e8 ab bc ff ff       	call   80102c70 <iunlock>
  end_op();
80106fc5:	e8 16 d2 ff ff       	call   801041e0 <end_op>

  f->type = FD_INODE;
80106fca:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80106fd0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106fd3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80106fd6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80106fd9:	89 d0                	mov    %edx,%eax
  f->off = 0;
80106fdb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80106fe2:	f7 d0                	not    %eax
80106fe4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106fe7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80106fea:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106fed:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80106ff1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ff4:	89 d8                	mov    %ebx,%eax
80106ff6:	5b                   	pop    %ebx
80106ff7:	5e                   	pop    %esi
80106ff8:	5f                   	pop    %edi
80106ff9:	5d                   	pop    %ebp
80106ffa:	c3                   	ret    
80106ffb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106fff:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80107000:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107003:	85 c9                	test   %ecx,%ecx
80107005:	0f 84 33 ff ff ff    	je     80106f3e <sys_open+0x6e>
8010700b:	e9 5c ff ff ff       	jmp    80106f6c <sys_open+0x9c>

80107010 <sys_mkdir>:

int
sys_mkdir(void)
{
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80107016:	e8 55 d1 ff ff       	call   80104170 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010701b:	83 ec 08             	sub    $0x8,%esp
8010701e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107021:	50                   	push   %eax
80107022:	6a 00                	push   $0x0
80107024:	e8 67 f5 ff ff       	call   80106590 <argstr>
80107029:	83 c4 10             	add    $0x10,%esp
8010702c:	85 c0                	test   %eax,%eax
8010702e:	78 30                	js     80107060 <sys_mkdir+0x50>
80107030:	83 ec 0c             	sub    $0xc,%esp
80107033:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107036:	31 c9                	xor    %ecx,%ecx
80107038:	ba 01 00 00 00       	mov    $0x1,%edx
8010703d:	6a 00                	push   $0x0
8010703f:	e8 3c f6 ff ff       	call   80106680 <create>
80107044:	83 c4 10             	add    $0x10,%esp
80107047:	85 c0                	test   %eax,%eax
80107049:	74 15                	je     80107060 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010704b:	83 ec 0c             	sub    $0xc,%esp
8010704e:	50                   	push   %eax
8010704f:	e8 cc bd ff ff       	call   80102e20 <iunlockput>
  end_op();
80107054:	e8 87 d1 ff ff       	call   801041e0 <end_op>
  return 0;
80107059:	83 c4 10             	add    $0x10,%esp
8010705c:	31 c0                	xor    %eax,%eax
}
8010705e:	c9                   	leave  
8010705f:	c3                   	ret    
    end_op();
80107060:	e8 7b d1 ff ff       	call   801041e0 <end_op>
    return -1;
80107065:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010706a:	c9                   	leave  
8010706b:	c3                   	ret    
8010706c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107070 <sys_move_file>:

// Kernel function for copying a file and deleting the source
int sys_move_file(void) {
80107070:	55                   	push   %ebp
80107071:	89 e5                	mov    %esp,%ebp
80107073:	57                   	push   %edi
80107074:	56                   	push   %esi
    struct inode *ip_dst;
    struct inode *ip_src;
    int red_bytes;
    char buffer[1024];

    if (argstr(0, &source) < 0 || argstr(1, &dest) < 0)
80107075:	8d 85 6c fb ff ff    	lea    -0x494(%ebp),%eax
int sys_move_file(void) {
8010707b:	53                   	push   %ebx
8010707c:	81 ec a4 04 00 00    	sub    $0x4a4,%esp
    if (argstr(0, &source) < 0 || argstr(1, &dest) < 0)
80107082:	50                   	push   %eax
80107083:	6a 00                	push   $0x0
80107085:	e8 06 f5 ff ff       	call   80106590 <argstr>
8010708a:	83 c4 10             	add    $0x10,%esp
8010708d:	85 c0                	test   %eax,%eax
8010708f:	0f 88 c5 01 00 00    	js     8010725a <sys_move_file+0x1ea>
80107095:	83 ec 08             	sub    $0x8,%esp
80107098:	8d 85 70 fb ff ff    	lea    -0x490(%ebp),%eax
8010709e:	50                   	push   %eax
8010709f:	6a 01                	push   $0x1
801070a1:	e8 ea f4 ff ff       	call   80106590 <argstr>
801070a6:	83 c4 10             	add    $0x10,%esp
801070a9:	85 c0                	test   %eax,%eax
801070ab:	0f 88 a9 01 00 00    	js     8010725a <sys_move_file+0x1ea>
        return -1;

    begin_op();
801070b1:	e8 ba d0 ff ff       	call   80104170 <begin_op>
    if ((ip_src = namei(source)) == 0) {
801070b6:	83 ec 0c             	sub    $0xc,%esp
801070b9:	ff b5 6c fb ff ff    	push   -0x494(%ebp)
801070bf:	e8 ec c3 ff ff       	call   801034b0 <namei>
801070c4:	83 c4 10             	add    $0x10,%esp
801070c7:	89 85 64 fb ff ff    	mov    %eax,-0x49c(%ebp)
801070cd:	85 c0                	test   %eax,%eax
801070cf:	0f 84 af 01 00 00    	je     80107284 <sys_move_file+0x214>
        end_op();
        return -1;
    }

    char full_path[100];
    create_full_pathchar(full_path, dest, source);
801070d5:	8b 9d 70 fb ff ff    	mov    -0x490(%ebp),%ebx
801070db:	8b 8d 6c fb ff ff    	mov    -0x494(%ebp),%ecx
    while (*dir) {
801070e1:	0f b6 13             	movzbl (%ebx),%edx
801070e4:	84 d2                	test   %dl,%dl
801070e6:	0f 84 84 01 00 00    	je     80107270 <sys_move_file+0x200>
    char *p = full_path;
801070ec:	8d bd 84 fb ff ff    	lea    -0x47c(%ebp),%edi
801070f2:	89 f8                	mov    %edi,%eax
801070f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        *p++ = *dir++;
801070f8:	83 c3 01             	add    $0x1,%ebx
801070fb:	89 d6                	mov    %edx,%esi
801070fd:	88 10                	mov    %dl,(%eax)
801070ff:	83 c0 01             	add    $0x1,%eax
    while (*dir) {
80107102:	0f b6 13             	movzbl (%ebx),%edx
80107105:	84 d2                	test   %dl,%dl
80107107:	75 ef                	jne    801070f8 <sys_move_file+0x88>
    if (*(p - 1) != '/') {
80107109:	89 f3                	mov    %esi,%ebx
8010710b:	80 fb 2f             	cmp    $0x2f,%bl
8010710e:	74 18                	je     80107128 <sys_move_file+0xb8>
        *p++ = '/';
80107110:	c6 00 2f             	movb   $0x2f,(%eax)
80107113:	83 c0 01             	add    $0x1,%eax
    while (*filename) {
80107116:	eb 10                	jmp    80107128 <sys_move_file+0xb8>
80107118:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010711f:	90                   	nop
        *p++ = *filename++;
80107120:	88 10                	mov    %dl,(%eax)
80107122:	83 c0 01             	add    $0x1,%eax
80107125:	83 c1 01             	add    $0x1,%ecx
    while (*filename) {
80107128:	0f b6 11             	movzbl (%ecx),%edx
8010712b:	84 d2                	test   %dl,%dl
8010712d:	75 f1                	jne    80107120 <sys_move_file+0xb0>
   
    struct inode *ip_check = namei(full_path);
8010712f:	83 ec 0c             	sub    $0xc,%esp
    *p = '\0';
80107132:	c6 00 00             	movb   $0x0,(%eax)
    struct inode *ip_check = namei(full_path);
80107135:	57                   	push   %edi
80107136:	e8 75 c3 ff ff       	call   801034b0 <namei>
    if (ip_check != 0) {
8010713b:	83 c4 10             	add    $0x10,%esp
8010713e:	85 c0                	test   %eax,%eax
80107140:	0f 85 3e 01 00 00    	jne    80107284 <sys_move_file+0x214>
        end_op();
        return -1;
    }

    ip_dst = create(full_path, T_FILE, 0, 0);
80107146:	83 ec 0c             	sub    $0xc,%esp
80107149:	31 c9                	xor    %ecx,%ecx
8010714b:	ba 02 00 00 00       	mov    $0x2,%edx
80107150:	89 f8                	mov    %edi,%eax
80107152:	6a 00                	push   $0x0
80107154:	e8 27 f5 ff ff       	call   80106680 <create>
    if (ip_dst == 0) {
80107159:	83 c4 10             	add    $0x10,%esp
    ip_dst = create(full_path, T_FILE, 0, 0);
8010715c:	89 85 60 fb ff ff    	mov    %eax,-0x4a0(%ebp)
    if (ip_dst == 0) {
80107162:	85 c0                	test   %eax,%eax
80107164:	0f 84 1a 01 00 00    	je     80107284 <sys_move_file+0x214>

    int written_bytes = 0;
    int read_offset = 0;
    int write_offset = 0;

    ilock(ip_src);
8010716a:	83 ec 0c             	sub    $0xc,%esp
8010716d:	ff b5 64 fb ff ff    	push   -0x49c(%ebp)
    int write_offset = 0;
80107173:	31 f6                	xor    %esi,%esi
    int read_offset = 0;
80107175:	31 db                	xor    %ebx,%ebx
80107177:	8d bd e8 fb ff ff    	lea    -0x418(%ebp),%edi
    ilock(ip_src);
8010717d:	e8 0e ba ff ff       	call   80102b90 <ilock>
    while ((red_bytes = readi(ip_src, buffer, read_offset, sizeof(buffer))) > 0) {
80107182:	83 c4 10             	add    $0x10,%esp
80107185:	eb 26                	jmp    801071ad <sys_move_file+0x13d>
80107187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010718e:	66 90                	xchg   %ax,%ax
        read_offset += red_bytes;
        if ((written_bytes = writei(ip_dst, buffer, write_offset, red_bytes)) <= 0) {
80107190:	50                   	push   %eax
        read_offset += red_bytes;
80107191:	01 c3                	add    %eax,%ebx
        if ((written_bytes = writei(ip_dst, buffer, write_offset, red_bytes)) <= 0) {
80107193:	56                   	push   %esi
80107194:	57                   	push   %edi
80107195:	ff b5 60 fb ff ff    	push   -0x4a0(%ebp)
8010719b:	e8 00 be ff ff       	call   80102fa0 <writei>
801071a0:	83 c4 10             	add    $0x10,%esp
801071a3:	85 c0                	test   %eax,%eax
801071a5:	0f 8e 8d 00 00 00    	jle    80107238 <sys_move_file+0x1c8>
            iunlock(ip_src);
            iunlock(ip_dst);
            end_op();
            return -1;
        }
        write_offset += written_bytes;
801071ab:	01 c6                	add    %eax,%esi
    while ((red_bytes = readi(ip_src, buffer, read_offset, sizeof(buffer))) > 0) {
801071ad:	68 00 04 00 00       	push   $0x400
801071b2:	53                   	push   %ebx
801071b3:	57                   	push   %edi
801071b4:	ff b5 64 fb ff ff    	push   -0x49c(%ebp)
801071ba:	e8 e1 bc ff ff       	call   80102ea0 <readi>
801071bf:	83 c4 10             	add    $0x10,%esp
801071c2:	85 c0                	test   %eax,%eax
801071c4:	7f ca                	jg     80107190 <sys_move_file+0x120>
    }
    iunlock(ip_src);
801071c6:	83 ec 0c             	sub    $0xc,%esp
801071c9:	ff b5 64 fb ff ff    	push   -0x49c(%ebp)
801071cf:	e8 9c ba ff ff       	call   80102c70 <iunlock>
    iunlock(ip_dst);
801071d4:	59                   	pop    %ecx
801071d5:	ff b5 60 fb ff ff    	push   -0x4a0(%ebp)
801071db:	e8 90 ba ff ff       	call   80102c70 <iunlock>

    char src_name[DIRSIZ];
    struct inode *ip_src_parent = nameiparent(source, src_name);
801071e0:	5b                   	pop    %ebx
801071e1:	5e                   	pop    %esi
801071e2:	8d b5 76 fb ff ff    	lea    -0x48a(%ebp),%esi
801071e8:	56                   	push   %esi
801071e9:	ff b5 6c fb ff ff    	push   -0x494(%ebp)
801071ef:	e8 dc c2 ff ff       	call   801034d0 <nameiparent>
    if (ip_src_parent == 0) {
801071f4:	83 c4 10             	add    $0x10,%esp
    struct inode *ip_src_parent = nameiparent(source, src_name);
801071f7:	89 c3                	mov    %eax,%ebx
    if (ip_src_parent == 0) {
801071f9:	85 c0                	test   %eax,%eax
801071fb:	0f 84 83 00 00 00    	je     80107284 <sys_move_file+0x214>
        end_op();
        return -1;
    }
    ilock(ip_src_parent);
80107201:	83 ec 0c             	sub    $0xc,%esp
80107204:	50                   	push   %eax
80107205:	e8 86 b9 ff ff       	call   80102b90 <ilock>
    if (remove_file(ip_src_parent, src_name) < 0) {
8010720a:	58                   	pop    %eax
8010720b:	5a                   	pop    %edx
8010720c:	56                   	push   %esi
8010720d:	53                   	push   %ebx
8010720e:	e8 7d f6 ff ff       	call   80106890 <remove_file>
80107213:	83 c4 10             	add    $0x10,%esp
80107216:	85 c0                	test   %eax,%eax
80107218:	78 76                	js     80107290 <sys_move_file+0x220>
        iunlock(ip_src_parent);
        end_op();
        return -1;
    }
    iunlock(ip_src_parent);
8010721a:	83 ec 0c             	sub    $0xc,%esp
8010721d:	53                   	push   %ebx
8010721e:	e8 4d ba ff ff       	call   80102c70 <iunlock>

    end_op();
80107223:	e8 b8 cf ff ff       	call   801041e0 <end_op>
    return 0;
80107228:	83 c4 10             	add    $0x10,%esp
8010722b:	31 c0                	xor    %eax,%eax
}
8010722d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107230:	5b                   	pop    %ebx
80107231:	5e                   	pop    %esi
80107232:	5f                   	pop    %edi
80107233:	5d                   	pop    %ebp
80107234:	c3                   	ret    
80107235:	8d 76 00             	lea    0x0(%esi),%esi
            iunlock(ip_src);
80107238:	83 ec 0c             	sub    $0xc,%esp
8010723b:	ff b5 64 fb ff ff    	push   -0x49c(%ebp)
80107241:	e8 2a ba ff ff       	call   80102c70 <iunlock>
            iunlock(ip_dst);
80107246:	5f                   	pop    %edi
80107247:	ff b5 60 fb ff ff    	push   -0x4a0(%ebp)
8010724d:	e8 1e ba ff ff       	call   80102c70 <iunlock>
            end_op();
80107252:	e8 89 cf ff ff       	call   801041e0 <end_op>
            return -1;
80107257:	83 c4 10             	add    $0x10,%esp
}
8010725a:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
8010725d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107262:	5b                   	pop    %ebx
80107263:	5e                   	pop    %esi
80107264:	5f                   	pop    %edi
80107265:	5d                   	pop    %ebp
80107266:	c3                   	ret    
80107267:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010726e:	66 90                	xchg   %ax,%ax
    char *p = full_path;
80107270:	8d bd 84 fb ff ff    	lea    -0x47c(%ebp),%edi
    if (*(p - 1) != '/') {
80107276:	0f b6 b5 83 fb ff ff 	movzbl -0x47d(%ebp),%esi
    char *p = full_path;
8010727d:	89 f8                	mov    %edi,%eax
8010727f:	e9 85 fe ff ff       	jmp    80107109 <sys_move_file+0x99>
        end_op();
80107284:	e8 57 cf ff ff       	call   801041e0 <end_op>
        return -1;
80107289:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010728e:	eb 9d                	jmp    8010722d <sys_move_file+0x1bd>
        iunlock(ip_src_parent);
80107290:	83 ec 0c             	sub    $0xc,%esp
80107293:	53                   	push   %ebx
80107294:	e8 d7 b9 ff ff       	call   80102c70 <iunlock>
        end_op();
80107299:	e8 42 cf ff ff       	call   801041e0 <end_op>
        return -1;
8010729e:	83 c4 10             	add    $0x10,%esp
801072a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801072a6:	eb 85                	jmp    8010722d <sys_move_file+0x1bd>
801072a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072af:	90                   	nop

801072b0 <sys_mknod>:



int
sys_mknod(void)
{
801072b0:	55                   	push   %ebp
801072b1:	89 e5                	mov    %esp,%ebp
801072b3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801072b6:	e8 b5 ce ff ff       	call   80104170 <begin_op>
  if((argstr(0, &path)) < 0 ||
801072bb:	83 ec 08             	sub    $0x8,%esp
801072be:	8d 45 ec             	lea    -0x14(%ebp),%eax
801072c1:	50                   	push   %eax
801072c2:	6a 00                	push   $0x0
801072c4:	e8 c7 f2 ff ff       	call   80106590 <argstr>
801072c9:	83 c4 10             	add    $0x10,%esp
801072cc:	85 c0                	test   %eax,%eax
801072ce:	78 60                	js     80107330 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801072d0:	83 ec 08             	sub    $0x8,%esp
801072d3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801072d6:	50                   	push   %eax
801072d7:	6a 01                	push   $0x1
801072d9:	e8 f2 f1 ff ff       	call   801064d0 <argint>
  if((argstr(0, &path)) < 0 ||
801072de:	83 c4 10             	add    $0x10,%esp
801072e1:	85 c0                	test   %eax,%eax
801072e3:	78 4b                	js     80107330 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801072e5:	83 ec 08             	sub    $0x8,%esp
801072e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801072eb:	50                   	push   %eax
801072ec:	6a 02                	push   $0x2
801072ee:	e8 dd f1 ff ff       	call   801064d0 <argint>
     argint(1, &major) < 0 ||
801072f3:	83 c4 10             	add    $0x10,%esp
801072f6:	85 c0                	test   %eax,%eax
801072f8:	78 36                	js     80107330 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801072fa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801072fe:	83 ec 0c             	sub    $0xc,%esp
80107301:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80107305:	ba 03 00 00 00       	mov    $0x3,%edx
8010730a:	50                   	push   %eax
8010730b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010730e:	e8 6d f3 ff ff       	call   80106680 <create>
     argint(2, &minor) < 0 ||
80107313:	83 c4 10             	add    $0x10,%esp
80107316:	85 c0                	test   %eax,%eax
80107318:	74 16                	je     80107330 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010731a:	83 ec 0c             	sub    $0xc,%esp
8010731d:	50                   	push   %eax
8010731e:	e8 fd ba ff ff       	call   80102e20 <iunlockput>
  end_op();
80107323:	e8 b8 ce ff ff       	call   801041e0 <end_op>
  return 0;
80107328:	83 c4 10             	add    $0x10,%esp
8010732b:	31 c0                	xor    %eax,%eax
}
8010732d:	c9                   	leave  
8010732e:	c3                   	ret    
8010732f:	90                   	nop
    end_op();
80107330:	e8 ab ce ff ff       	call   801041e0 <end_op>
    return -1;
80107335:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010733a:	c9                   	leave  
8010733b:	c3                   	ret    
8010733c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107340 <sys_chdir>:

int
sys_chdir(void)
{
80107340:	55                   	push   %ebp
80107341:	89 e5                	mov    %esp,%ebp
80107343:	56                   	push   %esi
80107344:	53                   	push   %ebx
80107345:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80107348:	e8 83 dc ff ff       	call   80104fd0 <myproc>
8010734d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010734f:	e8 1c ce ff ff       	call   80104170 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80107354:	83 ec 08             	sub    $0x8,%esp
80107357:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010735a:	50                   	push   %eax
8010735b:	6a 00                	push   $0x0
8010735d:	e8 2e f2 ff ff       	call   80106590 <argstr>
80107362:	83 c4 10             	add    $0x10,%esp
80107365:	85 c0                	test   %eax,%eax
80107367:	78 77                	js     801073e0 <sys_chdir+0xa0>
80107369:	83 ec 0c             	sub    $0xc,%esp
8010736c:	ff 75 f4             	push   -0xc(%ebp)
8010736f:	e8 3c c1 ff ff       	call   801034b0 <namei>
80107374:	83 c4 10             	add    $0x10,%esp
80107377:	89 c3                	mov    %eax,%ebx
80107379:	85 c0                	test   %eax,%eax
8010737b:	74 63                	je     801073e0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010737d:	83 ec 0c             	sub    $0xc,%esp
80107380:	50                   	push   %eax
80107381:	e8 0a b8 ff ff       	call   80102b90 <ilock>
  if(ip->type != T_DIR){
80107386:	83 c4 10             	add    $0x10,%esp
80107389:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010738e:	75 30                	jne    801073c0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80107390:	83 ec 0c             	sub    $0xc,%esp
80107393:	53                   	push   %ebx
80107394:	e8 d7 b8 ff ff       	call   80102c70 <iunlock>
  iput(curproc->cwd);
80107399:	58                   	pop    %eax
8010739a:	ff 76 68             	push   0x68(%esi)
8010739d:	e8 1e b9 ff ff       	call   80102cc0 <iput>
  end_op();
801073a2:	e8 39 ce ff ff       	call   801041e0 <end_op>
  curproc->cwd = ip;
801073a7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801073aa:	83 c4 10             	add    $0x10,%esp
801073ad:	31 c0                	xor    %eax,%eax
}
801073af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801073b2:	5b                   	pop    %ebx
801073b3:	5e                   	pop    %esi
801073b4:	5d                   	pop    %ebp
801073b5:	c3                   	ret    
801073b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073bd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801073c0:	83 ec 0c             	sub    $0xc,%esp
801073c3:	53                   	push   %ebx
801073c4:	e8 57 ba ff ff       	call   80102e20 <iunlockput>
    end_op();
801073c9:	e8 12 ce ff ff       	call   801041e0 <end_op>
    return -1;
801073ce:	83 c4 10             	add    $0x10,%esp
801073d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073d6:	eb d7                	jmp    801073af <sys_chdir+0x6f>
801073d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073df:	90                   	nop
    end_op();
801073e0:	e8 fb cd ff ff       	call   801041e0 <end_op>
    return -1;
801073e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073ea:	eb c3                	jmp    801073af <sys_chdir+0x6f>
801073ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801073f0 <sys_exec>:

int
sys_exec(void)
{
801073f0:	55                   	push   %ebp
801073f1:	89 e5                	mov    %esp,%ebp
801073f3:	57                   	push   %edi
801073f4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801073f5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801073fb:	53                   	push   %ebx
801073fc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80107402:	50                   	push   %eax
80107403:	6a 00                	push   $0x0
80107405:	e8 86 f1 ff ff       	call   80106590 <argstr>
8010740a:	83 c4 10             	add    $0x10,%esp
8010740d:	85 c0                	test   %eax,%eax
8010740f:	0f 88 87 00 00 00    	js     8010749c <sys_exec+0xac>
80107415:	83 ec 08             	sub    $0x8,%esp
80107418:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010741e:	50                   	push   %eax
8010741f:	6a 01                	push   $0x1
80107421:	e8 aa f0 ff ff       	call   801064d0 <argint>
80107426:	83 c4 10             	add    $0x10,%esp
80107429:	85 c0                	test   %eax,%eax
8010742b:	78 6f                	js     8010749c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010742d:	83 ec 04             	sub    $0x4,%esp
80107430:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80107436:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80107438:	68 80 00 00 00       	push   $0x80
8010743d:	6a 00                	push   $0x0
8010743f:	56                   	push   %esi
80107440:	e8 cb ed ff ff       	call   80106210 <memset>
80107445:	83 c4 10             	add    $0x10,%esp
80107448:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010744f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80107450:	83 ec 08             	sub    $0x8,%esp
80107453:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80107459:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80107460:	50                   	push   %eax
80107461:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80107467:	01 f8                	add    %edi,%eax
80107469:	50                   	push   %eax
8010746a:	e8 d1 ef ff ff       	call   80106440 <fetchint>
8010746f:	83 c4 10             	add    $0x10,%esp
80107472:	85 c0                	test   %eax,%eax
80107474:	78 26                	js     8010749c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80107476:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010747c:	85 c0                	test   %eax,%eax
8010747e:	74 30                	je     801074b0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80107480:	83 ec 08             	sub    $0x8,%esp
80107483:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80107486:	52                   	push   %edx
80107487:	50                   	push   %eax
80107488:	e8 f3 ef ff ff       	call   80106480 <fetchstr>
8010748d:	83 c4 10             	add    $0x10,%esp
80107490:	85 c0                	test   %eax,%eax
80107492:	78 08                	js     8010749c <sys_exec+0xac>
  for(i=0;; i++){
80107494:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80107497:	83 fb 20             	cmp    $0x20,%ebx
8010749a:	75 b4                	jne    80107450 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010749c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010749f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074a4:	5b                   	pop    %ebx
801074a5:	5e                   	pop    %esi
801074a6:	5f                   	pop    %edi
801074a7:	5d                   	pop    %ebp
801074a8:	c3                   	ret    
801074a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801074b0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801074b7:	00 00 00 00 
  return exec(path, argv);
801074bb:	83 ec 08             	sub    $0x8,%esp
801074be:	56                   	push   %esi
801074bf:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801074c5:	e8 f6 a9 ff ff       	call   80101ec0 <exec>
801074ca:	83 c4 10             	add    $0x10,%esp
}
801074cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074d0:	5b                   	pop    %ebx
801074d1:	5e                   	pop    %esi
801074d2:	5f                   	pop    %edi
801074d3:	5d                   	pop    %ebp
801074d4:	c3                   	ret    
801074d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801074e0 <sys_pipe>:

int
sys_pipe(void)
{
801074e0:	55                   	push   %ebp
801074e1:	89 e5                	mov    %esp,%ebp
801074e3:	57                   	push   %edi
801074e4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801074e5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801074e8:	53                   	push   %ebx
801074e9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801074ec:	6a 08                	push   $0x8
801074ee:	50                   	push   %eax
801074ef:	6a 00                	push   $0x0
801074f1:	e8 2a f0 ff ff       	call   80106520 <argptr>
801074f6:	83 c4 10             	add    $0x10,%esp
801074f9:	85 c0                	test   %eax,%eax
801074fb:	78 4a                	js     80107547 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801074fd:	83 ec 08             	sub    $0x8,%esp
80107500:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107503:	50                   	push   %eax
80107504:	8d 45 e0             	lea    -0x20(%ebp),%eax
80107507:	50                   	push   %eax
80107508:	e8 33 d3 ff ff       	call   80104840 <pipealloc>
8010750d:	83 c4 10             	add    $0x10,%esp
80107510:	85 c0                	test   %eax,%eax
80107512:	78 33                	js     80107547 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80107514:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80107517:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80107519:	e8 b2 da ff ff       	call   80104fd0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010751e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80107520:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80107524:	85 f6                	test   %esi,%esi
80107526:	74 28                	je     80107550 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80107528:	83 c3 01             	add    $0x1,%ebx
8010752b:	83 fb 10             	cmp    $0x10,%ebx
8010752e:	75 f0                	jne    80107520 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80107530:	83 ec 0c             	sub    $0xc,%esp
80107533:	ff 75 e0             	push   -0x20(%ebp)
80107536:	e8 c5 ad ff ff       	call   80102300 <fileclose>
    fileclose(wf);
8010753b:	58                   	pop    %eax
8010753c:	ff 75 e4             	push   -0x1c(%ebp)
8010753f:	e8 bc ad ff ff       	call   80102300 <fileclose>
    return -1;
80107544:	83 c4 10             	add    $0x10,%esp
80107547:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010754c:	eb 53                	jmp    801075a1 <sys_pipe+0xc1>
8010754e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80107550:	8d 73 08             	lea    0x8(%ebx),%esi
80107553:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80107557:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010755a:	e8 71 da ff ff       	call   80104fd0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010755f:	31 d2                	xor    %edx,%edx
80107561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80107568:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010756c:	85 c9                	test   %ecx,%ecx
8010756e:	74 20                	je     80107590 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80107570:	83 c2 01             	add    $0x1,%edx
80107573:	83 fa 10             	cmp    $0x10,%edx
80107576:	75 f0                	jne    80107568 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80107578:	e8 53 da ff ff       	call   80104fd0 <myproc>
8010757d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80107584:	00 
80107585:	eb a9                	jmp    80107530 <sys_pipe+0x50>
80107587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010758e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80107590:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80107594:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107597:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80107599:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010759c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010759f:	31 c0                	xor    %eax,%eax
}
801075a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075a4:	5b                   	pop    %ebx
801075a5:	5e                   	pop    %esi
801075a6:	5f                   	pop    %edi
801075a7:	5d                   	pop    %ebp
801075a8:	c3                   	ret    
801075a9:	66 90                	xchg   %ax,%ax
801075ab:	66 90                	xchg   %ax,%ax
801075ad:	66 90                	xchg   %ax,%ax
801075af:	90                   	nop

801075b0 <sys_fork>:
// extern struct proc proc[NPROC];

int
sys_fork(void)
{
  return fork();
801075b0:	e9 eb db ff ff       	jmp    801051a0 <fork>
801075b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801075c0 <sys_exit>:
}

int
sys_exit(void)
{
801075c0:	55                   	push   %ebp
801075c1:	89 e5                	mov    %esp,%ebp
801075c3:	83 ec 08             	sub    $0x8,%esp
  exit();
801075c6:	e8 e5 e0 ff ff       	call   801056b0 <exit>
  return 0;  // not reached
}
801075cb:	31 c0                	xor    %eax,%eax
801075cd:	c9                   	leave  
801075ce:	c3                   	ret    
801075cf:	90                   	nop

801075d0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801075d0:	e9 0b e2 ff ff       	jmp    801057e0 <wait>
801075d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801075e0 <sys_kill>:
}

int
sys_kill(void)
{
801075e0:	55                   	push   %ebp
801075e1:	89 e5                	mov    %esp,%ebp
801075e3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801075e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801075e9:	50                   	push   %eax
801075ea:	6a 00                	push   $0x0
801075ec:	e8 df ee ff ff       	call   801064d0 <argint>
801075f1:	83 c4 10             	add    $0x10,%esp
801075f4:	85 c0                	test   %eax,%eax
801075f6:	78 18                	js     80107610 <sys_kill+0x30>
    return -1;
  return kill(pid);
801075f8:	83 ec 0c             	sub    $0xc,%esp
801075fb:	ff 75 f4             	push   -0xc(%ebp)
801075fe:	e8 7d e4 ff ff       	call   80105a80 <kill>
80107603:	83 c4 10             	add    $0x10,%esp
}
80107606:	c9                   	leave  
80107607:	c3                   	ret    
80107608:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010760f:	90                   	nop
80107610:	c9                   	leave  
    return -1;
80107611:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107616:	c3                   	ret    
80107617:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010761e:	66 90                	xchg   %ax,%ax

80107620 <sys_create_palindrome>:

int
sys_create_palindrome(void){
80107620:	55                   	push   %ebp
80107621:	89 e5                	mov    %esp,%ebp
80107623:	53                   	push   %ebx
80107624:	83 ec 04             	sub    $0x4,%esp
  int n = myproc()->tf->ebx;
80107627:	e8 a4 d9 ff ff       	call   80104fd0 <myproc>
  cprintf("KERNEL: sys_create_palindrome(%d)\n", n);
8010762c:	83 ec 08             	sub    $0x8,%esp
  int n = myproc()->tf->ebx;
8010762f:	8b 40 18             	mov    0x18(%eax),%eax
80107632:	8b 58 10             	mov    0x10(%eax),%ebx
  cprintf("KERNEL: sys_create_palindrome(%d)\n", n);
80107635:	53                   	push   %ebx
80107636:	68 1c 9b 10 80       	push   $0x80109b1c
8010763b:	e8 c0 90 ff ff       	call   80100700 <cprintf>
  return create_palindrome(n);
80107640:	89 1c 24             	mov    %ebx,(%esp)
80107643:	e8 78 e5 ff ff       	call   80105bc0 <create_palindrome>
}
80107648:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010764b:	c9                   	leave  
8010764c:	c3                   	ret    
8010764d:	8d 76 00             	lea    0x0(%esi),%esi

80107650 <sys_getpid>:

int
sys_getpid(void)
{
80107650:	55                   	push   %ebp
80107651:	89 e5                	mov    %esp,%ebp
80107653:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80107656:	e8 75 d9 ff ff       	call   80104fd0 <myproc>
8010765b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010765e:	c9                   	leave  
8010765f:	c3                   	ret    

80107660 <sys_sbrk>:

int
sys_sbrk(void)
{
80107660:	55                   	push   %ebp
80107661:	89 e5                	mov    %esp,%ebp
80107663:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80107664:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80107667:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010766a:	50                   	push   %eax
8010766b:	6a 00                	push   $0x0
8010766d:	e8 5e ee ff ff       	call   801064d0 <argint>
80107672:	83 c4 10             	add    $0x10,%esp
80107675:	85 c0                	test   %eax,%eax
80107677:	78 27                	js     801076a0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80107679:	e8 52 d9 ff ff       	call   80104fd0 <myproc>
  if(growproc(n) < 0)
8010767e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80107681:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80107683:	ff 75 f4             	push   -0xc(%ebp)
80107686:	e8 95 da ff ff       	call   80105120 <growproc>
8010768b:	83 c4 10             	add    $0x10,%esp
8010768e:	85 c0                	test   %eax,%eax
80107690:	78 0e                	js     801076a0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80107692:	89 d8                	mov    %ebx,%eax
80107694:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107697:	c9                   	leave  
80107698:	c3                   	ret    
80107699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801076a0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801076a5:	eb eb                	jmp    80107692 <sys_sbrk+0x32>
801076a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076ae:	66 90                	xchg   %ax,%ax

801076b0 <sys_sleep>:

int
sys_sleep(void)
{
801076b0:	55                   	push   %ebp
801076b1:	89 e5                	mov    %esp,%ebp
801076b3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801076b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801076b7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801076ba:	50                   	push   %eax
801076bb:	6a 00                	push   $0x0
801076bd:	e8 0e ee ff ff       	call   801064d0 <argint>
801076c2:	83 c4 10             	add    $0x10,%esp
801076c5:	85 c0                	test   %eax,%eax
801076c7:	0f 88 8a 00 00 00    	js     80107757 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801076cd:	83 ec 0c             	sub    $0xc,%esp
801076d0:	68 00 86 11 80       	push   $0x80118600
801076d5:	e8 76 ea ff ff       	call   80106150 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801076da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801076dd:	8b 1d e0 85 11 80    	mov    0x801185e0,%ebx
  while(ticks - ticks0 < n){
801076e3:	83 c4 10             	add    $0x10,%esp
801076e6:	85 d2                	test   %edx,%edx
801076e8:	75 27                	jne    80107711 <sys_sleep+0x61>
801076ea:	eb 54                	jmp    80107740 <sys_sleep+0x90>
801076ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801076f0:	83 ec 08             	sub    $0x8,%esp
801076f3:	68 00 86 11 80       	push   $0x80118600
801076f8:	68 e0 85 11 80       	push   $0x801185e0
801076fd:	e8 5e e2 ff ff       	call   80105960 <sleep>
  while(ticks - ticks0 < n){
80107702:	a1 e0 85 11 80       	mov    0x801185e0,%eax
80107707:	83 c4 10             	add    $0x10,%esp
8010770a:	29 d8                	sub    %ebx,%eax
8010770c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010770f:	73 2f                	jae    80107740 <sys_sleep+0x90>
    if(myproc()->killed){
80107711:	e8 ba d8 ff ff       	call   80104fd0 <myproc>
80107716:	8b 40 24             	mov    0x24(%eax),%eax
80107719:	85 c0                	test   %eax,%eax
8010771b:	74 d3                	je     801076f0 <sys_sleep+0x40>
      release(&tickslock);
8010771d:	83 ec 0c             	sub    $0xc,%esp
80107720:	68 00 86 11 80       	push   $0x80118600
80107725:	e8 c6 e9 ff ff       	call   801060f0 <release>
  }
  release(&tickslock);
  return 0;
}
8010772a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010772d:	83 c4 10             	add    $0x10,%esp
80107730:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107735:	c9                   	leave  
80107736:	c3                   	ret    
80107737:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010773e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80107740:	83 ec 0c             	sub    $0xc,%esp
80107743:	68 00 86 11 80       	push   $0x80118600
80107748:	e8 a3 e9 ff ff       	call   801060f0 <release>
  return 0;
8010774d:	83 c4 10             	add    $0x10,%esp
80107750:	31 c0                	xor    %eax,%eax
}
80107752:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107755:	c9                   	leave  
80107756:	c3                   	ret    
    return -1;
80107757:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010775c:	eb f4                	jmp    80107752 <sys_sleep+0xa2>
8010775e:	66 90                	xchg   %ax,%ax

80107760 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80107760:	55                   	push   %ebp
80107761:	89 e5                	mov    %esp,%ebp
80107763:	53                   	push   %ebx
80107764:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80107767:	68 00 86 11 80       	push   $0x80118600
8010776c:	e8 df e9 ff ff       	call   80106150 <acquire>
  xticks = ticks;
80107771:	8b 1d e0 85 11 80    	mov    0x801185e0,%ebx
  release(&tickslock);
80107777:	c7 04 24 00 86 11 80 	movl   $0x80118600,(%esp)
8010777e:	e8 6d e9 ff ff       	call   801060f0 <release>
  return xticks;
}
80107783:	89 d8                	mov    %ebx,%eax
80107785:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107788:	c9                   	leave  
80107789:	c3                   	ret    
8010778a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107790 <sys_SJF_init>:

int sys_SJF_init(void){
80107790:	55                   	push   %ebp
80107791:	89 e5                	mov    %esp,%ebp
80107793:	83 ec 20             	sub    $0x20,%esp
  int pid, burst, certainty;
  if(argint(0, &pid) < 0 || argint(1, &burst) < 0 || argint(2, &certainty) < 0)
80107796:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107799:	50                   	push   %eax
8010779a:	6a 00                	push   $0x0
8010779c:	e8 2f ed ff ff       	call   801064d0 <argint>
801077a1:	83 c4 10             	add    $0x10,%esp
801077a4:	85 c0                	test   %eax,%eax
801077a6:	78 48                	js     801077f0 <sys_SJF_init+0x60>
801077a8:	83 ec 08             	sub    $0x8,%esp
801077ab:	8d 45 f0             	lea    -0x10(%ebp),%eax
801077ae:	50                   	push   %eax
801077af:	6a 01                	push   $0x1
801077b1:	e8 1a ed ff ff       	call   801064d0 <argint>
801077b6:	83 c4 10             	add    $0x10,%esp
801077b9:	85 c0                	test   %eax,%eax
801077bb:	78 33                	js     801077f0 <sys_SJF_init+0x60>
801077bd:	83 ec 08             	sub    $0x8,%esp
801077c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801077c3:	50                   	push   %eax
801077c4:	6a 02                	push   $0x2
801077c6:	e8 05 ed ff ff       	call   801064d0 <argint>
801077cb:	83 c4 10             	add    $0x10,%esp
801077ce:	85 c0                	test   %eax,%eax
801077d0:	78 1e                	js     801077f0 <sys_SJF_init+0x60>
    return -1;
  return SJF_init(pid, burst, certainty); 
801077d2:	83 ec 04             	sub    $0x4,%esp
801077d5:	ff 75 f4             	push   -0xc(%ebp)
801077d8:	ff 75 f0             	push   -0x10(%ebp)
801077db:	ff 75 ec             	push   -0x14(%ebp)
801077de:	e8 7d d6 ff ff       	call   80104e60 <SJF_init>
801077e3:	83 c4 10             	add    $0x10,%esp
}
801077e6:	c9                   	leave  
801077e7:	c3                   	ret    
801077e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077ef:	90                   	nop
801077f0:	c9                   	leave  
    return -1;
801077f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801077f6:	c3                   	ret    
801077f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077fe:	66 90                	xchg   %ax,%ax

80107800 <sys_change_queue>:

void sys_change_queue(void){
80107800:	55                   	push   %ebp
80107801:	89 e5                	mov    %esp,%ebp
80107803:	53                   	push   %ebx
  int pid, dest_Q;
  if(argint(0, &pid) < 0 || argint(1, &dest_Q) < 0 || argint(1, &dest_Q) > 2){
80107804:	8d 45 f0             	lea    -0x10(%ebp),%eax
void sys_change_queue(void){
80107807:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &pid) < 0 || argint(1, &dest_Q) < 0 || argint(1, &dest_Q) > 2){
8010780a:	50                   	push   %eax
8010780b:	6a 00                	push   $0x0
8010780d:	e8 be ec ff ff       	call   801064d0 <argint>
80107812:	83 c4 10             	add    $0x10,%esp
80107815:	85 c0                	test   %eax,%eax
80107817:	78 47                	js     80107860 <sys_change_queue+0x60>
80107819:	83 ec 08             	sub    $0x8,%esp
8010781c:	8d 5d f4             	lea    -0xc(%ebp),%ebx
8010781f:	53                   	push   %ebx
80107820:	6a 01                	push   $0x1
80107822:	e8 a9 ec ff ff       	call   801064d0 <argint>
80107827:	83 c4 10             	add    $0x10,%esp
8010782a:	85 c0                	test   %eax,%eax
8010782c:	78 32                	js     80107860 <sys_change_queue+0x60>
8010782e:	83 ec 08             	sub    $0x8,%esp
80107831:	53                   	push   %ebx
80107832:	6a 01                	push   $0x1
80107834:	e8 97 ec ff ff       	call   801064d0 <argint>
80107839:	83 c4 10             	add    $0x10,%esp
8010783c:	83 f8 02             	cmp    $0x2,%eax
8010783f:	7f 1f                	jg     80107860 <sys_change_queue+0x60>
    cprintf("Invalid arguments!\n");
    return;
  }
  return change_queue(pid, dest_Q);
80107841:	83 ec 08             	sub    $0x8,%esp
80107844:	ff 75 f4             	push   -0xc(%ebp)
80107847:	ff 75 f0             	push   -0x10(%ebp)
8010784a:	e8 81 d6 ff ff       	call   80104ed0 <change_queue>
8010784f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return change_queue(pid, dest_Q);
80107852:	83 c4 10             	add    $0x10,%esp
80107855:	c9                   	leave  
80107856:	c3                   	ret    
80107857:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010785e:	66 90                	xchg   %ax,%ax
    cprintf("Invalid arguments!\n");
80107860:	83 ec 0c             	sub    $0xc,%esp
80107863:	68 3f 9b 10 80       	push   $0x80109b3f
80107868:	e8 93 8e ff ff       	call   80100700 <cprintf>
8010786d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return;
80107870:	83 c4 10             	add    $0x10,%esp
80107873:	c9                   	leave  
80107874:	c3                   	ret    

80107875 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80107875:	1e                   	push   %ds
  pushl %es
80107876:	06                   	push   %es
  pushl %fs
80107877:	0f a0                	push   %fs
  pushl %gs
80107879:	0f a8                	push   %gs
  pushal
8010787b:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010787c:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80107880:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80107882:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80107884:	54                   	push   %esp
  call trap
80107885:	e8 c6 00 00 00       	call   80107950 <trap>
  addl $4, %esp
8010788a:	83 c4 04             	add    $0x4,%esp

8010788d <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010788d:	61                   	popa   
  popl %gs
8010788e:	0f a9                	pop    %gs
  popl %fs
80107890:	0f a1                	pop    %fs
  popl %es
80107892:	07                   	pop    %es
  popl %ds
80107893:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80107894:	83 c4 08             	add    $0x8,%esp
  iret
80107897:	cf                   	iret   
80107898:	66 90                	xchg   %ax,%ax
8010789a:	66 90                	xchg   %ax,%ax
8010789c:	66 90                	xchg   %ax,%ax
8010789e:	66 90                	xchg   %ax,%ax

801078a0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801078a0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801078a1:	31 c0                	xor    %eax,%eax
{
801078a3:	89 e5                	mov    %esp,%ebp
801078a5:	83 ec 08             	sub    $0x8,%esp
801078a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078af:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801078b0:	8b 14 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%edx
801078b7:	c7 04 c5 42 86 11 80 	movl   $0x8e000008,-0x7fee79be(,%eax,8)
801078be:	08 00 00 8e 
801078c2:	66 89 14 c5 40 86 11 	mov    %dx,-0x7fee79c0(,%eax,8)
801078c9:	80 
801078ca:	c1 ea 10             	shr    $0x10,%edx
801078cd:	66 89 14 c5 46 86 11 	mov    %dx,-0x7fee79ba(,%eax,8)
801078d4:	80 
  for(i = 0; i < 256; i++)
801078d5:	83 c0 01             	add    $0x1,%eax
801078d8:	3d 00 01 00 00       	cmp    $0x100,%eax
801078dd:	75 d1                	jne    801078b0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801078df:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801078e2:	a1 0c c1 10 80       	mov    0x8010c10c,%eax
801078e7:	c7 05 42 88 11 80 08 	movl   $0xef000008,0x80118842
801078ee:	00 00 ef 
  initlock(&tickslock, "time");
801078f1:	68 53 9b 10 80       	push   $0x80109b53
801078f6:	68 00 86 11 80       	push   $0x80118600
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801078fb:	66 a3 40 88 11 80    	mov    %ax,0x80118840
80107901:	c1 e8 10             	shr    $0x10,%eax
80107904:	66 a3 46 88 11 80    	mov    %ax,0x80118846
  initlock(&tickslock, "time");
8010790a:	e8 71 e6 ff ff       	call   80105f80 <initlock>
}
8010790f:	83 c4 10             	add    $0x10,%esp
80107912:	c9                   	leave  
80107913:	c3                   	ret    
80107914:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010791b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010791f:	90                   	nop

80107920 <idtinit>:

void
idtinit(void)
{
80107920:	55                   	push   %ebp
  pd[0] = size-1;
80107921:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80107926:	89 e5                	mov    %esp,%ebp
80107928:	83 ec 10             	sub    $0x10,%esp
8010792b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010792f:	b8 40 86 11 80       	mov    $0x80118640,%eax
80107934:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107938:	c1 e8 10             	shr    $0x10,%eax
8010793b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010793f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107942:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80107945:	c9                   	leave  
80107946:	c3                   	ret    
80107947:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010794e:	66 90                	xchg   %ax,%ax

80107950 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80107950:	55                   	push   %ebp
80107951:	89 e5                	mov    %esp,%ebp
80107953:	57                   	push   %edi
80107954:	56                   	push   %esi
80107955:	53                   	push   %ebx
80107956:	83 ec 1c             	sub    $0x1c,%esp
80107959:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010795c:	8b 43 30             	mov    0x30(%ebx),%eax
8010795f:	83 f8 40             	cmp    $0x40,%eax
80107962:	0f 84 a0 01 00 00    	je     80107b08 <trap+0x1b8>
    syscall();
    if(myproc()->killed)
      exit();
    return;
  }
  switch(tf->trapno){
80107968:	83 e8 20             	sub    $0x20,%eax
8010796b:	83 f8 1f             	cmp    $0x1f,%eax
8010796e:	0f 87 8c 00 00 00    	ja     80107a00 <trap+0xb0>
80107974:	ff 24 85 fc 9b 10 80 	jmp    *-0x7fef6404(,%eax,4)
8010797b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010797f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80107980:	e8 cb bc ff ff       	call   80103650 <ideintr>
    lapiceoi();
80107985:	e8 96 c3 ff ff       	call   80103d20 <lapiceoi>
  

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010798a:	e8 41 d6 ff ff       	call   80104fd0 <myproc>
8010798f:	85 c0                	test   %eax,%eax
80107991:	74 1d                	je     801079b0 <trap+0x60>
80107993:	e8 38 d6 ff ff       	call   80104fd0 <myproc>
80107998:	8b 48 24             	mov    0x24(%eax),%ecx
8010799b:	85 c9                	test   %ecx,%ecx
8010799d:	74 11                	je     801079b0 <trap+0x60>
8010799f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801079a3:	83 e0 03             	and    $0x3,%eax
801079a6:	66 83 f8 03          	cmp    $0x3,%ax
801079aa:	0f 84 20 02 00 00    	je     80107bd0 <trap+0x280>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801079b0:	e8 1b d6 ff ff       	call   80104fd0 <myproc>
801079b5:	85 c0                	test   %eax,%eax
801079b7:	74 0f                	je     801079c8 <trap+0x78>
801079b9:	e8 12 d6 ff ff       	call   80104fd0 <myproc>
801079be:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801079c2:	0f 84 b8 00 00 00    	je     80107a80 <trap+0x130>
      }
    }
  }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801079c8:	e8 03 d6 ff ff       	call   80104fd0 <myproc>
801079cd:	85 c0                	test   %eax,%eax
801079cf:	74 1d                	je     801079ee <trap+0x9e>
801079d1:	e8 fa d5 ff ff       	call   80104fd0 <myproc>
801079d6:	8b 40 24             	mov    0x24(%eax),%eax
801079d9:	85 c0                	test   %eax,%eax
801079db:	74 11                	je     801079ee <trap+0x9e>
801079dd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801079e1:	83 e0 03             	and    $0x3,%eax
801079e4:	66 83 f8 03          	cmp    $0x3,%ax
801079e8:	0f 84 47 01 00 00    	je     80107b35 <trap+0x1e5>
    exit();
}
801079ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079f1:	5b                   	pop    %ebx
801079f2:	5e                   	pop    %esi
801079f3:	5f                   	pop    %edi
801079f4:	5d                   	pop    %ebp
801079f5:	c3                   	ret    
801079f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079fd:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80107a00:	e8 cb d5 ff ff       	call   80104fd0 <myproc>
80107a05:	8b 7b 38             	mov    0x38(%ebx),%edi
80107a08:	85 c0                	test   %eax,%eax
80107a0a:	0f 84 da 01 00 00    	je     80107bea <trap+0x29a>
80107a10:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80107a14:	0f 84 d0 01 00 00    	je     80107bea <trap+0x29a>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107a1a:	0f 20 d1             	mov    %cr2,%ecx
80107a1d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107a20:	e8 8b d5 ff ff       	call   80104fb0 <cpuid>
80107a25:	8b 73 30             	mov    0x30(%ebx),%esi
80107a28:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107a2b:	8b 43 34             	mov    0x34(%ebx),%eax
80107a2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80107a31:	e8 9a d5 ff ff       	call   80104fd0 <myproc>
80107a36:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107a39:	e8 92 d5 ff ff       	call   80104fd0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107a3e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80107a41:	8b 55 dc             	mov    -0x24(%ebp),%edx
80107a44:	51                   	push   %ecx
80107a45:	57                   	push   %edi
80107a46:	52                   	push   %edx
80107a47:	ff 75 e4             	push   -0x1c(%ebp)
80107a4a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80107a4b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80107a4e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107a51:	56                   	push   %esi
80107a52:	ff 70 10             	push   0x10(%eax)
80107a55:	68 b8 9b 10 80       	push   $0x80109bb8
80107a5a:	e8 a1 8c ff ff       	call   80100700 <cprintf>
    myproc()->killed = 1;
80107a5f:	83 c4 20             	add    $0x20,%esp
80107a62:	e8 69 d5 ff ff       	call   80104fd0 <myproc>
80107a67:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107a6e:	e8 5d d5 ff ff       	call   80104fd0 <myproc>
80107a73:	85 c0                	test   %eax,%eax
80107a75:	0f 85 18 ff ff ff    	jne    80107993 <trap+0x43>
80107a7b:	e9 30 ff ff ff       	jmp    801079b0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80107a80:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80107a84:	0f 85 3e ff ff ff    	jne    801079c8 <trap+0x78>
    if((myproc()->level_queue != 1) && (myproc()->level_queue != 2))
80107a8a:	e8 41 d5 ff ff       	call   80104fd0 <myproc>
80107a8f:	83 b8 ec 00 00 00 01 	cmpl   $0x1,0xec(%eax)
80107a96:	0f 84 2c ff ff ff    	je     801079c8 <trap+0x78>
80107a9c:	e8 2f d5 ff ff       	call   80104fd0 <myproc>
80107aa1:	83 b8 ec 00 00 00 02 	cmpl   $0x2,0xec(%eax)
80107aa8:	0f 84 1a ff ff ff    	je     801079c8 <trap+0x78>
      if(num_of_interr == 0)
80107aae:	8b 15 08 c0 10 80    	mov    0x8010c008,%edx
80107ab4:	85 d2                	test   %edx,%edx
80107ab6:	0f 85 0c ff ff ff    	jne    801079c8 <trap+0x78>
        yield();
80107abc:	e8 4f de ff ff       	call   80105910 <yield>
        num_of_interr = 5;
80107ac1:	c7 05 08 c0 10 80 05 	movl   $0x5,0x8010c008
80107ac8:	00 00 00 
80107acb:	e9 f8 fe ff ff       	jmp    801079c8 <trap+0x78>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107ad0:	8b 7b 38             	mov    0x38(%ebx),%edi
80107ad3:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80107ad7:	e8 d4 d4 ff ff       	call   80104fb0 <cpuid>
80107adc:	57                   	push   %edi
80107add:	56                   	push   %esi
80107ade:	50                   	push   %eax
80107adf:	68 60 9b 10 80       	push   $0x80109b60
80107ae4:	e8 17 8c ff ff       	call   80100700 <cprintf>
    lapiceoi();
80107ae9:	e8 32 c2 ff ff       	call   80103d20 <lapiceoi>
    break;
80107aee:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107af1:	e8 da d4 ff ff       	call   80104fd0 <myproc>
80107af6:	85 c0                	test   %eax,%eax
80107af8:	0f 85 95 fe ff ff    	jne    80107993 <trap+0x43>
80107afe:	e9 ad fe ff ff       	jmp    801079b0 <trap+0x60>
80107b03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107b07:	90                   	nop
    if(myproc()->killed)
80107b08:	e8 c3 d4 ff ff       	call   80104fd0 <myproc>
80107b0d:	8b 70 24             	mov    0x24(%eax),%esi
80107b10:	85 f6                	test   %esi,%esi
80107b12:	0f 85 c8 00 00 00    	jne    80107be0 <trap+0x290>
    myproc()->tf = tf;
80107b18:	e8 b3 d4 ff ff       	call   80104fd0 <myproc>
80107b1d:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80107b20:	e8 eb ea ff ff       	call   80106610 <syscall>
    if(myproc()->killed)
80107b25:	e8 a6 d4 ff ff       	call   80104fd0 <myproc>
80107b2a:	8b 58 24             	mov    0x24(%eax),%ebx
80107b2d:	85 db                	test   %ebx,%ebx
80107b2f:	0f 84 b9 fe ff ff    	je     801079ee <trap+0x9e>
}
80107b35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b38:	5b                   	pop    %ebx
80107b39:	5e                   	pop    %esi
80107b3a:	5f                   	pop    %edi
80107b3b:	5d                   	pop    %ebp
      exit();
80107b3c:	e9 6f db ff ff       	jmp    801056b0 <exit>
80107b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80107b48:	e8 43 02 00 00       	call   80107d90 <uartintr>
    lapiceoi();
80107b4d:	e8 ce c1 ff ff       	call   80103d20 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107b52:	e8 79 d4 ff ff       	call   80104fd0 <myproc>
80107b57:	85 c0                	test   %eax,%eax
80107b59:	0f 85 34 fe ff ff    	jne    80107993 <trap+0x43>
80107b5f:	e9 4c fe ff ff       	jmp    801079b0 <trap+0x60>
80107b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80107b68:	e8 73 c0 ff ff       	call   80103be0 <kbdintr>
    lapiceoi();
80107b6d:	e8 ae c1 ff ff       	call   80103d20 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107b72:	e8 59 d4 ff ff       	call   80104fd0 <myproc>
80107b77:	85 c0                	test   %eax,%eax
80107b79:	0f 85 14 fe ff ff    	jne    80107993 <trap+0x43>
80107b7f:	e9 2c fe ff ff       	jmp    801079b0 <trap+0x60>
80107b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80107b88:	e8 23 d4 ff ff       	call   80104fb0 <cpuid>
80107b8d:	85 c0                	test   %eax,%eax
80107b8f:	0f 85 f0 fd ff ff    	jne    80107985 <trap+0x35>
      acquire(&tickslock);
80107b95:	83 ec 0c             	sub    $0xc,%esp
80107b98:	68 00 86 11 80       	push   $0x80118600
80107b9d:	e8 ae e5 ff ff       	call   80106150 <acquire>
      wakeup(&ticks);
80107ba2:	c7 04 24 e0 85 11 80 	movl   $0x801185e0,(%esp)
      ticks++;
80107ba9:	83 05 e0 85 11 80 01 	addl   $0x1,0x801185e0
      num_of_interr--;
80107bb0:	83 2d 08 c0 10 80 01 	subl   $0x1,0x8010c008
      wakeup(&ticks);
80107bb7:	e8 64 de ff ff       	call   80105a20 <wakeup>
      release(&tickslock);
80107bbc:	c7 04 24 00 86 11 80 	movl   $0x80118600,(%esp)
80107bc3:	e8 28 e5 ff ff       	call   801060f0 <release>
80107bc8:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80107bcb:	e9 b5 fd ff ff       	jmp    80107985 <trap+0x35>
    exit();
80107bd0:	e8 db da ff ff       	call   801056b0 <exit>
80107bd5:	e9 d6 fd ff ff       	jmp    801079b0 <trap+0x60>
80107bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80107be0:	e8 cb da ff ff       	call   801056b0 <exit>
80107be5:	e9 2e ff ff ff       	jmp    80107b18 <trap+0x1c8>
80107bea:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107bed:	e8 be d3 ff ff       	call   80104fb0 <cpuid>
80107bf2:	83 ec 0c             	sub    $0xc,%esp
80107bf5:	56                   	push   %esi
80107bf6:	57                   	push   %edi
80107bf7:	50                   	push   %eax
80107bf8:	ff 73 30             	push   0x30(%ebx)
80107bfb:	68 84 9b 10 80       	push   $0x80109b84
80107c00:	e8 fb 8a ff ff       	call   80100700 <cprintf>
      panic("trap");
80107c05:	83 c4 14             	add    $0x14,%esp
80107c08:	68 58 9b 10 80       	push   $0x80109b58
80107c0d:	e8 6e 87 ff ff       	call   80100380 <panic>
80107c12:	66 90                	xchg   %ax,%ax
80107c14:	66 90                	xchg   %ax,%ax
80107c16:	66 90                	xchg   %ax,%ax
80107c18:	66 90                	xchg   %ax,%ax
80107c1a:	66 90                	xchg   %ax,%ax
80107c1c:	66 90                	xchg   %ax,%ax
80107c1e:	66 90                	xchg   %ax,%ax

80107c20 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80107c20:	a1 40 8e 11 80       	mov    0x80118e40,%eax
80107c25:	85 c0                	test   %eax,%eax
80107c27:	74 17                	je     80107c40 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107c29:	ba fd 03 00 00       	mov    $0x3fd,%edx
80107c2e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80107c2f:	a8 01                	test   $0x1,%al
80107c31:	74 0d                	je     80107c40 <uartgetc+0x20>
80107c33:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107c38:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80107c39:	0f b6 c0             	movzbl %al,%eax
80107c3c:	c3                   	ret    
80107c3d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80107c40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107c45:	c3                   	ret    
80107c46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c4d:	8d 76 00             	lea    0x0(%esi),%esi

80107c50 <uartinit>:
{
80107c50:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107c51:	31 c9                	xor    %ecx,%ecx
80107c53:	89 c8                	mov    %ecx,%eax
80107c55:	89 e5                	mov    %esp,%ebp
80107c57:	57                   	push   %edi
80107c58:	bf fa 03 00 00       	mov    $0x3fa,%edi
80107c5d:	56                   	push   %esi
80107c5e:	89 fa                	mov    %edi,%edx
80107c60:	53                   	push   %ebx
80107c61:	83 ec 1c             	sub    $0x1c,%esp
80107c64:	ee                   	out    %al,(%dx)
80107c65:	be fb 03 00 00       	mov    $0x3fb,%esi
80107c6a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80107c6f:	89 f2                	mov    %esi,%edx
80107c71:	ee                   	out    %al,(%dx)
80107c72:	b8 0c 00 00 00       	mov    $0xc,%eax
80107c77:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107c7c:	ee                   	out    %al,(%dx)
80107c7d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80107c82:	89 c8                	mov    %ecx,%eax
80107c84:	89 da                	mov    %ebx,%edx
80107c86:	ee                   	out    %al,(%dx)
80107c87:	b8 03 00 00 00       	mov    $0x3,%eax
80107c8c:	89 f2                	mov    %esi,%edx
80107c8e:	ee                   	out    %al,(%dx)
80107c8f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80107c94:	89 c8                	mov    %ecx,%eax
80107c96:	ee                   	out    %al,(%dx)
80107c97:	b8 01 00 00 00       	mov    $0x1,%eax
80107c9c:	89 da                	mov    %ebx,%edx
80107c9e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107c9f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80107ca4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80107ca5:	3c ff                	cmp    $0xff,%al
80107ca7:	74 78                	je     80107d21 <uartinit+0xd1>
  uart = 1;
80107ca9:	c7 05 40 8e 11 80 01 	movl   $0x1,0x80118e40
80107cb0:	00 00 00 
80107cb3:	89 fa                	mov    %edi,%edx
80107cb5:	ec                   	in     (%dx),%al
80107cb6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107cbb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80107cbc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80107cbf:	bf 7c 9c 10 80       	mov    $0x80109c7c,%edi
80107cc4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80107cc9:	6a 00                	push   $0x0
80107ccb:	6a 04                	push   $0x4
80107ccd:	e8 be bb ff ff       	call   80103890 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80107cd2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80107cd6:	83 c4 10             	add    $0x10,%esp
80107cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80107ce0:	a1 40 8e 11 80       	mov    0x80118e40,%eax
80107ce5:	bb 80 00 00 00       	mov    $0x80,%ebx
80107cea:	85 c0                	test   %eax,%eax
80107cec:	75 14                	jne    80107d02 <uartinit+0xb2>
80107cee:	eb 23                	jmp    80107d13 <uartinit+0xc3>
    microdelay(10);
80107cf0:	83 ec 0c             	sub    $0xc,%esp
80107cf3:	6a 0a                	push   $0xa
80107cf5:	e8 46 c0 ff ff       	call   80103d40 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107cfa:	83 c4 10             	add    $0x10,%esp
80107cfd:	83 eb 01             	sub    $0x1,%ebx
80107d00:	74 07                	je     80107d09 <uartinit+0xb9>
80107d02:	89 f2                	mov    %esi,%edx
80107d04:	ec                   	in     (%dx),%al
80107d05:	a8 20                	test   $0x20,%al
80107d07:	74 e7                	je     80107cf0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107d09:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80107d0d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107d12:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80107d13:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80107d17:	83 c7 01             	add    $0x1,%edi
80107d1a:	88 45 e7             	mov    %al,-0x19(%ebp)
80107d1d:	84 c0                	test   %al,%al
80107d1f:	75 bf                	jne    80107ce0 <uartinit+0x90>
}
80107d21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d24:	5b                   	pop    %ebx
80107d25:	5e                   	pop    %esi
80107d26:	5f                   	pop    %edi
80107d27:	5d                   	pop    %ebp
80107d28:	c3                   	ret    
80107d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107d30 <uartputc>:
  if(!uart)
80107d30:	a1 40 8e 11 80       	mov    0x80118e40,%eax
80107d35:	85 c0                	test   %eax,%eax
80107d37:	74 47                	je     80107d80 <uartputc+0x50>
{
80107d39:	55                   	push   %ebp
80107d3a:	89 e5                	mov    %esp,%ebp
80107d3c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107d3d:	be fd 03 00 00       	mov    $0x3fd,%esi
80107d42:	53                   	push   %ebx
80107d43:	bb 80 00 00 00       	mov    $0x80,%ebx
80107d48:	eb 18                	jmp    80107d62 <uartputc+0x32>
80107d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80107d50:	83 ec 0c             	sub    $0xc,%esp
80107d53:	6a 0a                	push   $0xa
80107d55:	e8 e6 bf ff ff       	call   80103d40 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107d5a:	83 c4 10             	add    $0x10,%esp
80107d5d:	83 eb 01             	sub    $0x1,%ebx
80107d60:	74 07                	je     80107d69 <uartputc+0x39>
80107d62:	89 f2                	mov    %esi,%edx
80107d64:	ec                   	in     (%dx),%al
80107d65:	a8 20                	test   $0x20,%al
80107d67:	74 e7                	je     80107d50 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107d69:	8b 45 08             	mov    0x8(%ebp),%eax
80107d6c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107d71:	ee                   	out    %al,(%dx)
}
80107d72:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107d75:	5b                   	pop    %ebx
80107d76:	5e                   	pop    %esi
80107d77:	5d                   	pop    %ebp
80107d78:	c3                   	ret    
80107d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d80:	c3                   	ret    
80107d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d8f:	90                   	nop

80107d90 <uartintr>:

void
uartintr(void)
{
80107d90:	55                   	push   %ebp
80107d91:	89 e5                	mov    %esp,%ebp
80107d93:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80107d96:	68 20 7c 10 80       	push   $0x80107c20
80107d9b:	e8 a0 97 ff ff       	call   80101540 <consoleintr>
}
80107da0:	83 c4 10             	add    $0x10,%esp
80107da3:	c9                   	leave  
80107da4:	c3                   	ret    

80107da5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107da5:	6a 00                	push   $0x0
  pushl $0
80107da7:	6a 00                	push   $0x0
  jmp alltraps
80107da9:	e9 c7 fa ff ff       	jmp    80107875 <alltraps>

80107dae <vector1>:
.globl vector1
vector1:
  pushl $0
80107dae:	6a 00                	push   $0x0
  pushl $1
80107db0:	6a 01                	push   $0x1
  jmp alltraps
80107db2:	e9 be fa ff ff       	jmp    80107875 <alltraps>

80107db7 <vector2>:
.globl vector2
vector2:
  pushl $0
80107db7:	6a 00                	push   $0x0
  pushl $2
80107db9:	6a 02                	push   $0x2
  jmp alltraps
80107dbb:	e9 b5 fa ff ff       	jmp    80107875 <alltraps>

80107dc0 <vector3>:
.globl vector3
vector3:
  pushl $0
80107dc0:	6a 00                	push   $0x0
  pushl $3
80107dc2:	6a 03                	push   $0x3
  jmp alltraps
80107dc4:	e9 ac fa ff ff       	jmp    80107875 <alltraps>

80107dc9 <vector4>:
.globl vector4
vector4:
  pushl $0
80107dc9:	6a 00                	push   $0x0
  pushl $4
80107dcb:	6a 04                	push   $0x4
  jmp alltraps
80107dcd:	e9 a3 fa ff ff       	jmp    80107875 <alltraps>

80107dd2 <vector5>:
.globl vector5
vector5:
  pushl $0
80107dd2:	6a 00                	push   $0x0
  pushl $5
80107dd4:	6a 05                	push   $0x5
  jmp alltraps
80107dd6:	e9 9a fa ff ff       	jmp    80107875 <alltraps>

80107ddb <vector6>:
.globl vector6
vector6:
  pushl $0
80107ddb:	6a 00                	push   $0x0
  pushl $6
80107ddd:	6a 06                	push   $0x6
  jmp alltraps
80107ddf:	e9 91 fa ff ff       	jmp    80107875 <alltraps>

80107de4 <vector7>:
.globl vector7
vector7:
  pushl $0
80107de4:	6a 00                	push   $0x0
  pushl $7
80107de6:	6a 07                	push   $0x7
  jmp alltraps
80107de8:	e9 88 fa ff ff       	jmp    80107875 <alltraps>

80107ded <vector8>:
.globl vector8
vector8:
  pushl $8
80107ded:	6a 08                	push   $0x8
  jmp alltraps
80107def:	e9 81 fa ff ff       	jmp    80107875 <alltraps>

80107df4 <vector9>:
.globl vector9
vector9:
  pushl $0
80107df4:	6a 00                	push   $0x0
  pushl $9
80107df6:	6a 09                	push   $0x9
  jmp alltraps
80107df8:	e9 78 fa ff ff       	jmp    80107875 <alltraps>

80107dfd <vector10>:
.globl vector10
vector10:
  pushl $10
80107dfd:	6a 0a                	push   $0xa
  jmp alltraps
80107dff:	e9 71 fa ff ff       	jmp    80107875 <alltraps>

80107e04 <vector11>:
.globl vector11
vector11:
  pushl $11
80107e04:	6a 0b                	push   $0xb
  jmp alltraps
80107e06:	e9 6a fa ff ff       	jmp    80107875 <alltraps>

80107e0b <vector12>:
.globl vector12
vector12:
  pushl $12
80107e0b:	6a 0c                	push   $0xc
  jmp alltraps
80107e0d:	e9 63 fa ff ff       	jmp    80107875 <alltraps>

80107e12 <vector13>:
.globl vector13
vector13:
  pushl $13
80107e12:	6a 0d                	push   $0xd
  jmp alltraps
80107e14:	e9 5c fa ff ff       	jmp    80107875 <alltraps>

80107e19 <vector14>:
.globl vector14
vector14:
  pushl $14
80107e19:	6a 0e                	push   $0xe
  jmp alltraps
80107e1b:	e9 55 fa ff ff       	jmp    80107875 <alltraps>

80107e20 <vector15>:
.globl vector15
vector15:
  pushl $0
80107e20:	6a 00                	push   $0x0
  pushl $15
80107e22:	6a 0f                	push   $0xf
  jmp alltraps
80107e24:	e9 4c fa ff ff       	jmp    80107875 <alltraps>

80107e29 <vector16>:
.globl vector16
vector16:
  pushl $0
80107e29:	6a 00                	push   $0x0
  pushl $16
80107e2b:	6a 10                	push   $0x10
  jmp alltraps
80107e2d:	e9 43 fa ff ff       	jmp    80107875 <alltraps>

80107e32 <vector17>:
.globl vector17
vector17:
  pushl $17
80107e32:	6a 11                	push   $0x11
  jmp alltraps
80107e34:	e9 3c fa ff ff       	jmp    80107875 <alltraps>

80107e39 <vector18>:
.globl vector18
vector18:
  pushl $0
80107e39:	6a 00                	push   $0x0
  pushl $18
80107e3b:	6a 12                	push   $0x12
  jmp alltraps
80107e3d:	e9 33 fa ff ff       	jmp    80107875 <alltraps>

80107e42 <vector19>:
.globl vector19
vector19:
  pushl $0
80107e42:	6a 00                	push   $0x0
  pushl $19
80107e44:	6a 13                	push   $0x13
  jmp alltraps
80107e46:	e9 2a fa ff ff       	jmp    80107875 <alltraps>

80107e4b <vector20>:
.globl vector20
vector20:
  pushl $0
80107e4b:	6a 00                	push   $0x0
  pushl $20
80107e4d:	6a 14                	push   $0x14
  jmp alltraps
80107e4f:	e9 21 fa ff ff       	jmp    80107875 <alltraps>

80107e54 <vector21>:
.globl vector21
vector21:
  pushl $0
80107e54:	6a 00                	push   $0x0
  pushl $21
80107e56:	6a 15                	push   $0x15
  jmp alltraps
80107e58:	e9 18 fa ff ff       	jmp    80107875 <alltraps>

80107e5d <vector22>:
.globl vector22
vector22:
  pushl $0
80107e5d:	6a 00                	push   $0x0
  pushl $22
80107e5f:	6a 16                	push   $0x16
  jmp alltraps
80107e61:	e9 0f fa ff ff       	jmp    80107875 <alltraps>

80107e66 <vector23>:
.globl vector23
vector23:
  pushl $0
80107e66:	6a 00                	push   $0x0
  pushl $23
80107e68:	6a 17                	push   $0x17
  jmp alltraps
80107e6a:	e9 06 fa ff ff       	jmp    80107875 <alltraps>

80107e6f <vector24>:
.globl vector24
vector24:
  pushl $0
80107e6f:	6a 00                	push   $0x0
  pushl $24
80107e71:	6a 18                	push   $0x18
  jmp alltraps
80107e73:	e9 fd f9 ff ff       	jmp    80107875 <alltraps>

80107e78 <vector25>:
.globl vector25
vector25:
  pushl $0
80107e78:	6a 00                	push   $0x0
  pushl $25
80107e7a:	6a 19                	push   $0x19
  jmp alltraps
80107e7c:	e9 f4 f9 ff ff       	jmp    80107875 <alltraps>

80107e81 <vector26>:
.globl vector26
vector26:
  pushl $0
80107e81:	6a 00                	push   $0x0
  pushl $26
80107e83:	6a 1a                	push   $0x1a
  jmp alltraps
80107e85:	e9 eb f9 ff ff       	jmp    80107875 <alltraps>

80107e8a <vector27>:
.globl vector27
vector27:
  pushl $0
80107e8a:	6a 00                	push   $0x0
  pushl $27
80107e8c:	6a 1b                	push   $0x1b
  jmp alltraps
80107e8e:	e9 e2 f9 ff ff       	jmp    80107875 <alltraps>

80107e93 <vector28>:
.globl vector28
vector28:
  pushl $0
80107e93:	6a 00                	push   $0x0
  pushl $28
80107e95:	6a 1c                	push   $0x1c
  jmp alltraps
80107e97:	e9 d9 f9 ff ff       	jmp    80107875 <alltraps>

80107e9c <vector29>:
.globl vector29
vector29:
  pushl $0
80107e9c:	6a 00                	push   $0x0
  pushl $29
80107e9e:	6a 1d                	push   $0x1d
  jmp alltraps
80107ea0:	e9 d0 f9 ff ff       	jmp    80107875 <alltraps>

80107ea5 <vector30>:
.globl vector30
vector30:
  pushl $0
80107ea5:	6a 00                	push   $0x0
  pushl $30
80107ea7:	6a 1e                	push   $0x1e
  jmp alltraps
80107ea9:	e9 c7 f9 ff ff       	jmp    80107875 <alltraps>

80107eae <vector31>:
.globl vector31
vector31:
  pushl $0
80107eae:	6a 00                	push   $0x0
  pushl $31
80107eb0:	6a 1f                	push   $0x1f
  jmp alltraps
80107eb2:	e9 be f9 ff ff       	jmp    80107875 <alltraps>

80107eb7 <vector32>:
.globl vector32
vector32:
  pushl $0
80107eb7:	6a 00                	push   $0x0
  pushl $32
80107eb9:	6a 20                	push   $0x20
  jmp alltraps
80107ebb:	e9 b5 f9 ff ff       	jmp    80107875 <alltraps>

80107ec0 <vector33>:
.globl vector33
vector33:
  pushl $0
80107ec0:	6a 00                	push   $0x0
  pushl $33
80107ec2:	6a 21                	push   $0x21
  jmp alltraps
80107ec4:	e9 ac f9 ff ff       	jmp    80107875 <alltraps>

80107ec9 <vector34>:
.globl vector34
vector34:
  pushl $0
80107ec9:	6a 00                	push   $0x0
  pushl $34
80107ecb:	6a 22                	push   $0x22
  jmp alltraps
80107ecd:	e9 a3 f9 ff ff       	jmp    80107875 <alltraps>

80107ed2 <vector35>:
.globl vector35
vector35:
  pushl $0
80107ed2:	6a 00                	push   $0x0
  pushl $35
80107ed4:	6a 23                	push   $0x23
  jmp alltraps
80107ed6:	e9 9a f9 ff ff       	jmp    80107875 <alltraps>

80107edb <vector36>:
.globl vector36
vector36:
  pushl $0
80107edb:	6a 00                	push   $0x0
  pushl $36
80107edd:	6a 24                	push   $0x24
  jmp alltraps
80107edf:	e9 91 f9 ff ff       	jmp    80107875 <alltraps>

80107ee4 <vector37>:
.globl vector37
vector37:
  pushl $0
80107ee4:	6a 00                	push   $0x0
  pushl $37
80107ee6:	6a 25                	push   $0x25
  jmp alltraps
80107ee8:	e9 88 f9 ff ff       	jmp    80107875 <alltraps>

80107eed <vector38>:
.globl vector38
vector38:
  pushl $0
80107eed:	6a 00                	push   $0x0
  pushl $38
80107eef:	6a 26                	push   $0x26
  jmp alltraps
80107ef1:	e9 7f f9 ff ff       	jmp    80107875 <alltraps>

80107ef6 <vector39>:
.globl vector39
vector39:
  pushl $0
80107ef6:	6a 00                	push   $0x0
  pushl $39
80107ef8:	6a 27                	push   $0x27
  jmp alltraps
80107efa:	e9 76 f9 ff ff       	jmp    80107875 <alltraps>

80107eff <vector40>:
.globl vector40
vector40:
  pushl $0
80107eff:	6a 00                	push   $0x0
  pushl $40
80107f01:	6a 28                	push   $0x28
  jmp alltraps
80107f03:	e9 6d f9 ff ff       	jmp    80107875 <alltraps>

80107f08 <vector41>:
.globl vector41
vector41:
  pushl $0
80107f08:	6a 00                	push   $0x0
  pushl $41
80107f0a:	6a 29                	push   $0x29
  jmp alltraps
80107f0c:	e9 64 f9 ff ff       	jmp    80107875 <alltraps>

80107f11 <vector42>:
.globl vector42
vector42:
  pushl $0
80107f11:	6a 00                	push   $0x0
  pushl $42
80107f13:	6a 2a                	push   $0x2a
  jmp alltraps
80107f15:	e9 5b f9 ff ff       	jmp    80107875 <alltraps>

80107f1a <vector43>:
.globl vector43
vector43:
  pushl $0
80107f1a:	6a 00                	push   $0x0
  pushl $43
80107f1c:	6a 2b                	push   $0x2b
  jmp alltraps
80107f1e:	e9 52 f9 ff ff       	jmp    80107875 <alltraps>

80107f23 <vector44>:
.globl vector44
vector44:
  pushl $0
80107f23:	6a 00                	push   $0x0
  pushl $44
80107f25:	6a 2c                	push   $0x2c
  jmp alltraps
80107f27:	e9 49 f9 ff ff       	jmp    80107875 <alltraps>

80107f2c <vector45>:
.globl vector45
vector45:
  pushl $0
80107f2c:	6a 00                	push   $0x0
  pushl $45
80107f2e:	6a 2d                	push   $0x2d
  jmp alltraps
80107f30:	e9 40 f9 ff ff       	jmp    80107875 <alltraps>

80107f35 <vector46>:
.globl vector46
vector46:
  pushl $0
80107f35:	6a 00                	push   $0x0
  pushl $46
80107f37:	6a 2e                	push   $0x2e
  jmp alltraps
80107f39:	e9 37 f9 ff ff       	jmp    80107875 <alltraps>

80107f3e <vector47>:
.globl vector47
vector47:
  pushl $0
80107f3e:	6a 00                	push   $0x0
  pushl $47
80107f40:	6a 2f                	push   $0x2f
  jmp alltraps
80107f42:	e9 2e f9 ff ff       	jmp    80107875 <alltraps>

80107f47 <vector48>:
.globl vector48
vector48:
  pushl $0
80107f47:	6a 00                	push   $0x0
  pushl $48
80107f49:	6a 30                	push   $0x30
  jmp alltraps
80107f4b:	e9 25 f9 ff ff       	jmp    80107875 <alltraps>

80107f50 <vector49>:
.globl vector49
vector49:
  pushl $0
80107f50:	6a 00                	push   $0x0
  pushl $49
80107f52:	6a 31                	push   $0x31
  jmp alltraps
80107f54:	e9 1c f9 ff ff       	jmp    80107875 <alltraps>

80107f59 <vector50>:
.globl vector50
vector50:
  pushl $0
80107f59:	6a 00                	push   $0x0
  pushl $50
80107f5b:	6a 32                	push   $0x32
  jmp alltraps
80107f5d:	e9 13 f9 ff ff       	jmp    80107875 <alltraps>

80107f62 <vector51>:
.globl vector51
vector51:
  pushl $0
80107f62:	6a 00                	push   $0x0
  pushl $51
80107f64:	6a 33                	push   $0x33
  jmp alltraps
80107f66:	e9 0a f9 ff ff       	jmp    80107875 <alltraps>

80107f6b <vector52>:
.globl vector52
vector52:
  pushl $0
80107f6b:	6a 00                	push   $0x0
  pushl $52
80107f6d:	6a 34                	push   $0x34
  jmp alltraps
80107f6f:	e9 01 f9 ff ff       	jmp    80107875 <alltraps>

80107f74 <vector53>:
.globl vector53
vector53:
  pushl $0
80107f74:	6a 00                	push   $0x0
  pushl $53
80107f76:	6a 35                	push   $0x35
  jmp alltraps
80107f78:	e9 f8 f8 ff ff       	jmp    80107875 <alltraps>

80107f7d <vector54>:
.globl vector54
vector54:
  pushl $0
80107f7d:	6a 00                	push   $0x0
  pushl $54
80107f7f:	6a 36                	push   $0x36
  jmp alltraps
80107f81:	e9 ef f8 ff ff       	jmp    80107875 <alltraps>

80107f86 <vector55>:
.globl vector55
vector55:
  pushl $0
80107f86:	6a 00                	push   $0x0
  pushl $55
80107f88:	6a 37                	push   $0x37
  jmp alltraps
80107f8a:	e9 e6 f8 ff ff       	jmp    80107875 <alltraps>

80107f8f <vector56>:
.globl vector56
vector56:
  pushl $0
80107f8f:	6a 00                	push   $0x0
  pushl $56
80107f91:	6a 38                	push   $0x38
  jmp alltraps
80107f93:	e9 dd f8 ff ff       	jmp    80107875 <alltraps>

80107f98 <vector57>:
.globl vector57
vector57:
  pushl $0
80107f98:	6a 00                	push   $0x0
  pushl $57
80107f9a:	6a 39                	push   $0x39
  jmp alltraps
80107f9c:	e9 d4 f8 ff ff       	jmp    80107875 <alltraps>

80107fa1 <vector58>:
.globl vector58
vector58:
  pushl $0
80107fa1:	6a 00                	push   $0x0
  pushl $58
80107fa3:	6a 3a                	push   $0x3a
  jmp alltraps
80107fa5:	e9 cb f8 ff ff       	jmp    80107875 <alltraps>

80107faa <vector59>:
.globl vector59
vector59:
  pushl $0
80107faa:	6a 00                	push   $0x0
  pushl $59
80107fac:	6a 3b                	push   $0x3b
  jmp alltraps
80107fae:	e9 c2 f8 ff ff       	jmp    80107875 <alltraps>

80107fb3 <vector60>:
.globl vector60
vector60:
  pushl $0
80107fb3:	6a 00                	push   $0x0
  pushl $60
80107fb5:	6a 3c                	push   $0x3c
  jmp alltraps
80107fb7:	e9 b9 f8 ff ff       	jmp    80107875 <alltraps>

80107fbc <vector61>:
.globl vector61
vector61:
  pushl $0
80107fbc:	6a 00                	push   $0x0
  pushl $61
80107fbe:	6a 3d                	push   $0x3d
  jmp alltraps
80107fc0:	e9 b0 f8 ff ff       	jmp    80107875 <alltraps>

80107fc5 <vector62>:
.globl vector62
vector62:
  pushl $0
80107fc5:	6a 00                	push   $0x0
  pushl $62
80107fc7:	6a 3e                	push   $0x3e
  jmp alltraps
80107fc9:	e9 a7 f8 ff ff       	jmp    80107875 <alltraps>

80107fce <vector63>:
.globl vector63
vector63:
  pushl $0
80107fce:	6a 00                	push   $0x0
  pushl $63
80107fd0:	6a 3f                	push   $0x3f
  jmp alltraps
80107fd2:	e9 9e f8 ff ff       	jmp    80107875 <alltraps>

80107fd7 <vector64>:
.globl vector64
vector64:
  pushl $0
80107fd7:	6a 00                	push   $0x0
  pushl $64
80107fd9:	6a 40                	push   $0x40
  jmp alltraps
80107fdb:	e9 95 f8 ff ff       	jmp    80107875 <alltraps>

80107fe0 <vector65>:
.globl vector65
vector65:
  pushl $0
80107fe0:	6a 00                	push   $0x0
  pushl $65
80107fe2:	6a 41                	push   $0x41
  jmp alltraps
80107fe4:	e9 8c f8 ff ff       	jmp    80107875 <alltraps>

80107fe9 <vector66>:
.globl vector66
vector66:
  pushl $0
80107fe9:	6a 00                	push   $0x0
  pushl $66
80107feb:	6a 42                	push   $0x42
  jmp alltraps
80107fed:	e9 83 f8 ff ff       	jmp    80107875 <alltraps>

80107ff2 <vector67>:
.globl vector67
vector67:
  pushl $0
80107ff2:	6a 00                	push   $0x0
  pushl $67
80107ff4:	6a 43                	push   $0x43
  jmp alltraps
80107ff6:	e9 7a f8 ff ff       	jmp    80107875 <alltraps>

80107ffb <vector68>:
.globl vector68
vector68:
  pushl $0
80107ffb:	6a 00                	push   $0x0
  pushl $68
80107ffd:	6a 44                	push   $0x44
  jmp alltraps
80107fff:	e9 71 f8 ff ff       	jmp    80107875 <alltraps>

80108004 <vector69>:
.globl vector69
vector69:
  pushl $0
80108004:	6a 00                	push   $0x0
  pushl $69
80108006:	6a 45                	push   $0x45
  jmp alltraps
80108008:	e9 68 f8 ff ff       	jmp    80107875 <alltraps>

8010800d <vector70>:
.globl vector70
vector70:
  pushl $0
8010800d:	6a 00                	push   $0x0
  pushl $70
8010800f:	6a 46                	push   $0x46
  jmp alltraps
80108011:	e9 5f f8 ff ff       	jmp    80107875 <alltraps>

80108016 <vector71>:
.globl vector71
vector71:
  pushl $0
80108016:	6a 00                	push   $0x0
  pushl $71
80108018:	6a 47                	push   $0x47
  jmp alltraps
8010801a:	e9 56 f8 ff ff       	jmp    80107875 <alltraps>

8010801f <vector72>:
.globl vector72
vector72:
  pushl $0
8010801f:	6a 00                	push   $0x0
  pushl $72
80108021:	6a 48                	push   $0x48
  jmp alltraps
80108023:	e9 4d f8 ff ff       	jmp    80107875 <alltraps>

80108028 <vector73>:
.globl vector73
vector73:
  pushl $0
80108028:	6a 00                	push   $0x0
  pushl $73
8010802a:	6a 49                	push   $0x49
  jmp alltraps
8010802c:	e9 44 f8 ff ff       	jmp    80107875 <alltraps>

80108031 <vector74>:
.globl vector74
vector74:
  pushl $0
80108031:	6a 00                	push   $0x0
  pushl $74
80108033:	6a 4a                	push   $0x4a
  jmp alltraps
80108035:	e9 3b f8 ff ff       	jmp    80107875 <alltraps>

8010803a <vector75>:
.globl vector75
vector75:
  pushl $0
8010803a:	6a 00                	push   $0x0
  pushl $75
8010803c:	6a 4b                	push   $0x4b
  jmp alltraps
8010803e:	e9 32 f8 ff ff       	jmp    80107875 <alltraps>

80108043 <vector76>:
.globl vector76
vector76:
  pushl $0
80108043:	6a 00                	push   $0x0
  pushl $76
80108045:	6a 4c                	push   $0x4c
  jmp alltraps
80108047:	e9 29 f8 ff ff       	jmp    80107875 <alltraps>

8010804c <vector77>:
.globl vector77
vector77:
  pushl $0
8010804c:	6a 00                	push   $0x0
  pushl $77
8010804e:	6a 4d                	push   $0x4d
  jmp alltraps
80108050:	e9 20 f8 ff ff       	jmp    80107875 <alltraps>

80108055 <vector78>:
.globl vector78
vector78:
  pushl $0
80108055:	6a 00                	push   $0x0
  pushl $78
80108057:	6a 4e                	push   $0x4e
  jmp alltraps
80108059:	e9 17 f8 ff ff       	jmp    80107875 <alltraps>

8010805e <vector79>:
.globl vector79
vector79:
  pushl $0
8010805e:	6a 00                	push   $0x0
  pushl $79
80108060:	6a 4f                	push   $0x4f
  jmp alltraps
80108062:	e9 0e f8 ff ff       	jmp    80107875 <alltraps>

80108067 <vector80>:
.globl vector80
vector80:
  pushl $0
80108067:	6a 00                	push   $0x0
  pushl $80
80108069:	6a 50                	push   $0x50
  jmp alltraps
8010806b:	e9 05 f8 ff ff       	jmp    80107875 <alltraps>

80108070 <vector81>:
.globl vector81
vector81:
  pushl $0
80108070:	6a 00                	push   $0x0
  pushl $81
80108072:	6a 51                	push   $0x51
  jmp alltraps
80108074:	e9 fc f7 ff ff       	jmp    80107875 <alltraps>

80108079 <vector82>:
.globl vector82
vector82:
  pushl $0
80108079:	6a 00                	push   $0x0
  pushl $82
8010807b:	6a 52                	push   $0x52
  jmp alltraps
8010807d:	e9 f3 f7 ff ff       	jmp    80107875 <alltraps>

80108082 <vector83>:
.globl vector83
vector83:
  pushl $0
80108082:	6a 00                	push   $0x0
  pushl $83
80108084:	6a 53                	push   $0x53
  jmp alltraps
80108086:	e9 ea f7 ff ff       	jmp    80107875 <alltraps>

8010808b <vector84>:
.globl vector84
vector84:
  pushl $0
8010808b:	6a 00                	push   $0x0
  pushl $84
8010808d:	6a 54                	push   $0x54
  jmp alltraps
8010808f:	e9 e1 f7 ff ff       	jmp    80107875 <alltraps>

80108094 <vector85>:
.globl vector85
vector85:
  pushl $0
80108094:	6a 00                	push   $0x0
  pushl $85
80108096:	6a 55                	push   $0x55
  jmp alltraps
80108098:	e9 d8 f7 ff ff       	jmp    80107875 <alltraps>

8010809d <vector86>:
.globl vector86
vector86:
  pushl $0
8010809d:	6a 00                	push   $0x0
  pushl $86
8010809f:	6a 56                	push   $0x56
  jmp alltraps
801080a1:	e9 cf f7 ff ff       	jmp    80107875 <alltraps>

801080a6 <vector87>:
.globl vector87
vector87:
  pushl $0
801080a6:	6a 00                	push   $0x0
  pushl $87
801080a8:	6a 57                	push   $0x57
  jmp alltraps
801080aa:	e9 c6 f7 ff ff       	jmp    80107875 <alltraps>

801080af <vector88>:
.globl vector88
vector88:
  pushl $0
801080af:	6a 00                	push   $0x0
  pushl $88
801080b1:	6a 58                	push   $0x58
  jmp alltraps
801080b3:	e9 bd f7 ff ff       	jmp    80107875 <alltraps>

801080b8 <vector89>:
.globl vector89
vector89:
  pushl $0
801080b8:	6a 00                	push   $0x0
  pushl $89
801080ba:	6a 59                	push   $0x59
  jmp alltraps
801080bc:	e9 b4 f7 ff ff       	jmp    80107875 <alltraps>

801080c1 <vector90>:
.globl vector90
vector90:
  pushl $0
801080c1:	6a 00                	push   $0x0
  pushl $90
801080c3:	6a 5a                	push   $0x5a
  jmp alltraps
801080c5:	e9 ab f7 ff ff       	jmp    80107875 <alltraps>

801080ca <vector91>:
.globl vector91
vector91:
  pushl $0
801080ca:	6a 00                	push   $0x0
  pushl $91
801080cc:	6a 5b                	push   $0x5b
  jmp alltraps
801080ce:	e9 a2 f7 ff ff       	jmp    80107875 <alltraps>

801080d3 <vector92>:
.globl vector92
vector92:
  pushl $0
801080d3:	6a 00                	push   $0x0
  pushl $92
801080d5:	6a 5c                	push   $0x5c
  jmp alltraps
801080d7:	e9 99 f7 ff ff       	jmp    80107875 <alltraps>

801080dc <vector93>:
.globl vector93
vector93:
  pushl $0
801080dc:	6a 00                	push   $0x0
  pushl $93
801080de:	6a 5d                	push   $0x5d
  jmp alltraps
801080e0:	e9 90 f7 ff ff       	jmp    80107875 <alltraps>

801080e5 <vector94>:
.globl vector94
vector94:
  pushl $0
801080e5:	6a 00                	push   $0x0
  pushl $94
801080e7:	6a 5e                	push   $0x5e
  jmp alltraps
801080e9:	e9 87 f7 ff ff       	jmp    80107875 <alltraps>

801080ee <vector95>:
.globl vector95
vector95:
  pushl $0
801080ee:	6a 00                	push   $0x0
  pushl $95
801080f0:	6a 5f                	push   $0x5f
  jmp alltraps
801080f2:	e9 7e f7 ff ff       	jmp    80107875 <alltraps>

801080f7 <vector96>:
.globl vector96
vector96:
  pushl $0
801080f7:	6a 00                	push   $0x0
  pushl $96
801080f9:	6a 60                	push   $0x60
  jmp alltraps
801080fb:	e9 75 f7 ff ff       	jmp    80107875 <alltraps>

80108100 <vector97>:
.globl vector97
vector97:
  pushl $0
80108100:	6a 00                	push   $0x0
  pushl $97
80108102:	6a 61                	push   $0x61
  jmp alltraps
80108104:	e9 6c f7 ff ff       	jmp    80107875 <alltraps>

80108109 <vector98>:
.globl vector98
vector98:
  pushl $0
80108109:	6a 00                	push   $0x0
  pushl $98
8010810b:	6a 62                	push   $0x62
  jmp alltraps
8010810d:	e9 63 f7 ff ff       	jmp    80107875 <alltraps>

80108112 <vector99>:
.globl vector99
vector99:
  pushl $0
80108112:	6a 00                	push   $0x0
  pushl $99
80108114:	6a 63                	push   $0x63
  jmp alltraps
80108116:	e9 5a f7 ff ff       	jmp    80107875 <alltraps>

8010811b <vector100>:
.globl vector100
vector100:
  pushl $0
8010811b:	6a 00                	push   $0x0
  pushl $100
8010811d:	6a 64                	push   $0x64
  jmp alltraps
8010811f:	e9 51 f7 ff ff       	jmp    80107875 <alltraps>

80108124 <vector101>:
.globl vector101
vector101:
  pushl $0
80108124:	6a 00                	push   $0x0
  pushl $101
80108126:	6a 65                	push   $0x65
  jmp alltraps
80108128:	e9 48 f7 ff ff       	jmp    80107875 <alltraps>

8010812d <vector102>:
.globl vector102
vector102:
  pushl $0
8010812d:	6a 00                	push   $0x0
  pushl $102
8010812f:	6a 66                	push   $0x66
  jmp alltraps
80108131:	e9 3f f7 ff ff       	jmp    80107875 <alltraps>

80108136 <vector103>:
.globl vector103
vector103:
  pushl $0
80108136:	6a 00                	push   $0x0
  pushl $103
80108138:	6a 67                	push   $0x67
  jmp alltraps
8010813a:	e9 36 f7 ff ff       	jmp    80107875 <alltraps>

8010813f <vector104>:
.globl vector104
vector104:
  pushl $0
8010813f:	6a 00                	push   $0x0
  pushl $104
80108141:	6a 68                	push   $0x68
  jmp alltraps
80108143:	e9 2d f7 ff ff       	jmp    80107875 <alltraps>

80108148 <vector105>:
.globl vector105
vector105:
  pushl $0
80108148:	6a 00                	push   $0x0
  pushl $105
8010814a:	6a 69                	push   $0x69
  jmp alltraps
8010814c:	e9 24 f7 ff ff       	jmp    80107875 <alltraps>

80108151 <vector106>:
.globl vector106
vector106:
  pushl $0
80108151:	6a 00                	push   $0x0
  pushl $106
80108153:	6a 6a                	push   $0x6a
  jmp alltraps
80108155:	e9 1b f7 ff ff       	jmp    80107875 <alltraps>

8010815a <vector107>:
.globl vector107
vector107:
  pushl $0
8010815a:	6a 00                	push   $0x0
  pushl $107
8010815c:	6a 6b                	push   $0x6b
  jmp alltraps
8010815e:	e9 12 f7 ff ff       	jmp    80107875 <alltraps>

80108163 <vector108>:
.globl vector108
vector108:
  pushl $0
80108163:	6a 00                	push   $0x0
  pushl $108
80108165:	6a 6c                	push   $0x6c
  jmp alltraps
80108167:	e9 09 f7 ff ff       	jmp    80107875 <alltraps>

8010816c <vector109>:
.globl vector109
vector109:
  pushl $0
8010816c:	6a 00                	push   $0x0
  pushl $109
8010816e:	6a 6d                	push   $0x6d
  jmp alltraps
80108170:	e9 00 f7 ff ff       	jmp    80107875 <alltraps>

80108175 <vector110>:
.globl vector110
vector110:
  pushl $0
80108175:	6a 00                	push   $0x0
  pushl $110
80108177:	6a 6e                	push   $0x6e
  jmp alltraps
80108179:	e9 f7 f6 ff ff       	jmp    80107875 <alltraps>

8010817e <vector111>:
.globl vector111
vector111:
  pushl $0
8010817e:	6a 00                	push   $0x0
  pushl $111
80108180:	6a 6f                	push   $0x6f
  jmp alltraps
80108182:	e9 ee f6 ff ff       	jmp    80107875 <alltraps>

80108187 <vector112>:
.globl vector112
vector112:
  pushl $0
80108187:	6a 00                	push   $0x0
  pushl $112
80108189:	6a 70                	push   $0x70
  jmp alltraps
8010818b:	e9 e5 f6 ff ff       	jmp    80107875 <alltraps>

80108190 <vector113>:
.globl vector113
vector113:
  pushl $0
80108190:	6a 00                	push   $0x0
  pushl $113
80108192:	6a 71                	push   $0x71
  jmp alltraps
80108194:	e9 dc f6 ff ff       	jmp    80107875 <alltraps>

80108199 <vector114>:
.globl vector114
vector114:
  pushl $0
80108199:	6a 00                	push   $0x0
  pushl $114
8010819b:	6a 72                	push   $0x72
  jmp alltraps
8010819d:	e9 d3 f6 ff ff       	jmp    80107875 <alltraps>

801081a2 <vector115>:
.globl vector115
vector115:
  pushl $0
801081a2:	6a 00                	push   $0x0
  pushl $115
801081a4:	6a 73                	push   $0x73
  jmp alltraps
801081a6:	e9 ca f6 ff ff       	jmp    80107875 <alltraps>

801081ab <vector116>:
.globl vector116
vector116:
  pushl $0
801081ab:	6a 00                	push   $0x0
  pushl $116
801081ad:	6a 74                	push   $0x74
  jmp alltraps
801081af:	e9 c1 f6 ff ff       	jmp    80107875 <alltraps>

801081b4 <vector117>:
.globl vector117
vector117:
  pushl $0
801081b4:	6a 00                	push   $0x0
  pushl $117
801081b6:	6a 75                	push   $0x75
  jmp alltraps
801081b8:	e9 b8 f6 ff ff       	jmp    80107875 <alltraps>

801081bd <vector118>:
.globl vector118
vector118:
  pushl $0
801081bd:	6a 00                	push   $0x0
  pushl $118
801081bf:	6a 76                	push   $0x76
  jmp alltraps
801081c1:	e9 af f6 ff ff       	jmp    80107875 <alltraps>

801081c6 <vector119>:
.globl vector119
vector119:
  pushl $0
801081c6:	6a 00                	push   $0x0
  pushl $119
801081c8:	6a 77                	push   $0x77
  jmp alltraps
801081ca:	e9 a6 f6 ff ff       	jmp    80107875 <alltraps>

801081cf <vector120>:
.globl vector120
vector120:
  pushl $0
801081cf:	6a 00                	push   $0x0
  pushl $120
801081d1:	6a 78                	push   $0x78
  jmp alltraps
801081d3:	e9 9d f6 ff ff       	jmp    80107875 <alltraps>

801081d8 <vector121>:
.globl vector121
vector121:
  pushl $0
801081d8:	6a 00                	push   $0x0
  pushl $121
801081da:	6a 79                	push   $0x79
  jmp alltraps
801081dc:	e9 94 f6 ff ff       	jmp    80107875 <alltraps>

801081e1 <vector122>:
.globl vector122
vector122:
  pushl $0
801081e1:	6a 00                	push   $0x0
  pushl $122
801081e3:	6a 7a                	push   $0x7a
  jmp alltraps
801081e5:	e9 8b f6 ff ff       	jmp    80107875 <alltraps>

801081ea <vector123>:
.globl vector123
vector123:
  pushl $0
801081ea:	6a 00                	push   $0x0
  pushl $123
801081ec:	6a 7b                	push   $0x7b
  jmp alltraps
801081ee:	e9 82 f6 ff ff       	jmp    80107875 <alltraps>

801081f3 <vector124>:
.globl vector124
vector124:
  pushl $0
801081f3:	6a 00                	push   $0x0
  pushl $124
801081f5:	6a 7c                	push   $0x7c
  jmp alltraps
801081f7:	e9 79 f6 ff ff       	jmp    80107875 <alltraps>

801081fc <vector125>:
.globl vector125
vector125:
  pushl $0
801081fc:	6a 00                	push   $0x0
  pushl $125
801081fe:	6a 7d                	push   $0x7d
  jmp alltraps
80108200:	e9 70 f6 ff ff       	jmp    80107875 <alltraps>

80108205 <vector126>:
.globl vector126
vector126:
  pushl $0
80108205:	6a 00                	push   $0x0
  pushl $126
80108207:	6a 7e                	push   $0x7e
  jmp alltraps
80108209:	e9 67 f6 ff ff       	jmp    80107875 <alltraps>

8010820e <vector127>:
.globl vector127
vector127:
  pushl $0
8010820e:	6a 00                	push   $0x0
  pushl $127
80108210:	6a 7f                	push   $0x7f
  jmp alltraps
80108212:	e9 5e f6 ff ff       	jmp    80107875 <alltraps>

80108217 <vector128>:
.globl vector128
vector128:
  pushl $0
80108217:	6a 00                	push   $0x0
  pushl $128
80108219:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010821e:	e9 52 f6 ff ff       	jmp    80107875 <alltraps>

80108223 <vector129>:
.globl vector129
vector129:
  pushl $0
80108223:	6a 00                	push   $0x0
  pushl $129
80108225:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010822a:	e9 46 f6 ff ff       	jmp    80107875 <alltraps>

8010822f <vector130>:
.globl vector130
vector130:
  pushl $0
8010822f:	6a 00                	push   $0x0
  pushl $130
80108231:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80108236:	e9 3a f6 ff ff       	jmp    80107875 <alltraps>

8010823b <vector131>:
.globl vector131
vector131:
  pushl $0
8010823b:	6a 00                	push   $0x0
  pushl $131
8010823d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80108242:	e9 2e f6 ff ff       	jmp    80107875 <alltraps>

80108247 <vector132>:
.globl vector132
vector132:
  pushl $0
80108247:	6a 00                	push   $0x0
  pushl $132
80108249:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010824e:	e9 22 f6 ff ff       	jmp    80107875 <alltraps>

80108253 <vector133>:
.globl vector133
vector133:
  pushl $0
80108253:	6a 00                	push   $0x0
  pushl $133
80108255:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010825a:	e9 16 f6 ff ff       	jmp    80107875 <alltraps>

8010825f <vector134>:
.globl vector134
vector134:
  pushl $0
8010825f:	6a 00                	push   $0x0
  pushl $134
80108261:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80108266:	e9 0a f6 ff ff       	jmp    80107875 <alltraps>

8010826b <vector135>:
.globl vector135
vector135:
  pushl $0
8010826b:	6a 00                	push   $0x0
  pushl $135
8010826d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80108272:	e9 fe f5 ff ff       	jmp    80107875 <alltraps>

80108277 <vector136>:
.globl vector136
vector136:
  pushl $0
80108277:	6a 00                	push   $0x0
  pushl $136
80108279:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010827e:	e9 f2 f5 ff ff       	jmp    80107875 <alltraps>

80108283 <vector137>:
.globl vector137
vector137:
  pushl $0
80108283:	6a 00                	push   $0x0
  pushl $137
80108285:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010828a:	e9 e6 f5 ff ff       	jmp    80107875 <alltraps>

8010828f <vector138>:
.globl vector138
vector138:
  pushl $0
8010828f:	6a 00                	push   $0x0
  pushl $138
80108291:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80108296:	e9 da f5 ff ff       	jmp    80107875 <alltraps>

8010829b <vector139>:
.globl vector139
vector139:
  pushl $0
8010829b:	6a 00                	push   $0x0
  pushl $139
8010829d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801082a2:	e9 ce f5 ff ff       	jmp    80107875 <alltraps>

801082a7 <vector140>:
.globl vector140
vector140:
  pushl $0
801082a7:	6a 00                	push   $0x0
  pushl $140
801082a9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801082ae:	e9 c2 f5 ff ff       	jmp    80107875 <alltraps>

801082b3 <vector141>:
.globl vector141
vector141:
  pushl $0
801082b3:	6a 00                	push   $0x0
  pushl $141
801082b5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801082ba:	e9 b6 f5 ff ff       	jmp    80107875 <alltraps>

801082bf <vector142>:
.globl vector142
vector142:
  pushl $0
801082bf:	6a 00                	push   $0x0
  pushl $142
801082c1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801082c6:	e9 aa f5 ff ff       	jmp    80107875 <alltraps>

801082cb <vector143>:
.globl vector143
vector143:
  pushl $0
801082cb:	6a 00                	push   $0x0
  pushl $143
801082cd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801082d2:	e9 9e f5 ff ff       	jmp    80107875 <alltraps>

801082d7 <vector144>:
.globl vector144
vector144:
  pushl $0
801082d7:	6a 00                	push   $0x0
  pushl $144
801082d9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801082de:	e9 92 f5 ff ff       	jmp    80107875 <alltraps>

801082e3 <vector145>:
.globl vector145
vector145:
  pushl $0
801082e3:	6a 00                	push   $0x0
  pushl $145
801082e5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801082ea:	e9 86 f5 ff ff       	jmp    80107875 <alltraps>

801082ef <vector146>:
.globl vector146
vector146:
  pushl $0
801082ef:	6a 00                	push   $0x0
  pushl $146
801082f1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801082f6:	e9 7a f5 ff ff       	jmp    80107875 <alltraps>

801082fb <vector147>:
.globl vector147
vector147:
  pushl $0
801082fb:	6a 00                	push   $0x0
  pushl $147
801082fd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80108302:	e9 6e f5 ff ff       	jmp    80107875 <alltraps>

80108307 <vector148>:
.globl vector148
vector148:
  pushl $0
80108307:	6a 00                	push   $0x0
  pushl $148
80108309:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010830e:	e9 62 f5 ff ff       	jmp    80107875 <alltraps>

80108313 <vector149>:
.globl vector149
vector149:
  pushl $0
80108313:	6a 00                	push   $0x0
  pushl $149
80108315:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010831a:	e9 56 f5 ff ff       	jmp    80107875 <alltraps>

8010831f <vector150>:
.globl vector150
vector150:
  pushl $0
8010831f:	6a 00                	push   $0x0
  pushl $150
80108321:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80108326:	e9 4a f5 ff ff       	jmp    80107875 <alltraps>

8010832b <vector151>:
.globl vector151
vector151:
  pushl $0
8010832b:	6a 00                	push   $0x0
  pushl $151
8010832d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80108332:	e9 3e f5 ff ff       	jmp    80107875 <alltraps>

80108337 <vector152>:
.globl vector152
vector152:
  pushl $0
80108337:	6a 00                	push   $0x0
  pushl $152
80108339:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010833e:	e9 32 f5 ff ff       	jmp    80107875 <alltraps>

80108343 <vector153>:
.globl vector153
vector153:
  pushl $0
80108343:	6a 00                	push   $0x0
  pushl $153
80108345:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010834a:	e9 26 f5 ff ff       	jmp    80107875 <alltraps>

8010834f <vector154>:
.globl vector154
vector154:
  pushl $0
8010834f:	6a 00                	push   $0x0
  pushl $154
80108351:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80108356:	e9 1a f5 ff ff       	jmp    80107875 <alltraps>

8010835b <vector155>:
.globl vector155
vector155:
  pushl $0
8010835b:	6a 00                	push   $0x0
  pushl $155
8010835d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80108362:	e9 0e f5 ff ff       	jmp    80107875 <alltraps>

80108367 <vector156>:
.globl vector156
vector156:
  pushl $0
80108367:	6a 00                	push   $0x0
  pushl $156
80108369:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010836e:	e9 02 f5 ff ff       	jmp    80107875 <alltraps>

80108373 <vector157>:
.globl vector157
vector157:
  pushl $0
80108373:	6a 00                	push   $0x0
  pushl $157
80108375:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010837a:	e9 f6 f4 ff ff       	jmp    80107875 <alltraps>

8010837f <vector158>:
.globl vector158
vector158:
  pushl $0
8010837f:	6a 00                	push   $0x0
  pushl $158
80108381:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80108386:	e9 ea f4 ff ff       	jmp    80107875 <alltraps>

8010838b <vector159>:
.globl vector159
vector159:
  pushl $0
8010838b:	6a 00                	push   $0x0
  pushl $159
8010838d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80108392:	e9 de f4 ff ff       	jmp    80107875 <alltraps>

80108397 <vector160>:
.globl vector160
vector160:
  pushl $0
80108397:	6a 00                	push   $0x0
  pushl $160
80108399:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010839e:	e9 d2 f4 ff ff       	jmp    80107875 <alltraps>

801083a3 <vector161>:
.globl vector161
vector161:
  pushl $0
801083a3:	6a 00                	push   $0x0
  pushl $161
801083a5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801083aa:	e9 c6 f4 ff ff       	jmp    80107875 <alltraps>

801083af <vector162>:
.globl vector162
vector162:
  pushl $0
801083af:	6a 00                	push   $0x0
  pushl $162
801083b1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801083b6:	e9 ba f4 ff ff       	jmp    80107875 <alltraps>

801083bb <vector163>:
.globl vector163
vector163:
  pushl $0
801083bb:	6a 00                	push   $0x0
  pushl $163
801083bd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801083c2:	e9 ae f4 ff ff       	jmp    80107875 <alltraps>

801083c7 <vector164>:
.globl vector164
vector164:
  pushl $0
801083c7:	6a 00                	push   $0x0
  pushl $164
801083c9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801083ce:	e9 a2 f4 ff ff       	jmp    80107875 <alltraps>

801083d3 <vector165>:
.globl vector165
vector165:
  pushl $0
801083d3:	6a 00                	push   $0x0
  pushl $165
801083d5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801083da:	e9 96 f4 ff ff       	jmp    80107875 <alltraps>

801083df <vector166>:
.globl vector166
vector166:
  pushl $0
801083df:	6a 00                	push   $0x0
  pushl $166
801083e1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801083e6:	e9 8a f4 ff ff       	jmp    80107875 <alltraps>

801083eb <vector167>:
.globl vector167
vector167:
  pushl $0
801083eb:	6a 00                	push   $0x0
  pushl $167
801083ed:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801083f2:	e9 7e f4 ff ff       	jmp    80107875 <alltraps>

801083f7 <vector168>:
.globl vector168
vector168:
  pushl $0
801083f7:	6a 00                	push   $0x0
  pushl $168
801083f9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801083fe:	e9 72 f4 ff ff       	jmp    80107875 <alltraps>

80108403 <vector169>:
.globl vector169
vector169:
  pushl $0
80108403:	6a 00                	push   $0x0
  pushl $169
80108405:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010840a:	e9 66 f4 ff ff       	jmp    80107875 <alltraps>

8010840f <vector170>:
.globl vector170
vector170:
  pushl $0
8010840f:	6a 00                	push   $0x0
  pushl $170
80108411:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80108416:	e9 5a f4 ff ff       	jmp    80107875 <alltraps>

8010841b <vector171>:
.globl vector171
vector171:
  pushl $0
8010841b:	6a 00                	push   $0x0
  pushl $171
8010841d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80108422:	e9 4e f4 ff ff       	jmp    80107875 <alltraps>

80108427 <vector172>:
.globl vector172
vector172:
  pushl $0
80108427:	6a 00                	push   $0x0
  pushl $172
80108429:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010842e:	e9 42 f4 ff ff       	jmp    80107875 <alltraps>

80108433 <vector173>:
.globl vector173
vector173:
  pushl $0
80108433:	6a 00                	push   $0x0
  pushl $173
80108435:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010843a:	e9 36 f4 ff ff       	jmp    80107875 <alltraps>

8010843f <vector174>:
.globl vector174
vector174:
  pushl $0
8010843f:	6a 00                	push   $0x0
  pushl $174
80108441:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80108446:	e9 2a f4 ff ff       	jmp    80107875 <alltraps>

8010844b <vector175>:
.globl vector175
vector175:
  pushl $0
8010844b:	6a 00                	push   $0x0
  pushl $175
8010844d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80108452:	e9 1e f4 ff ff       	jmp    80107875 <alltraps>

80108457 <vector176>:
.globl vector176
vector176:
  pushl $0
80108457:	6a 00                	push   $0x0
  pushl $176
80108459:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010845e:	e9 12 f4 ff ff       	jmp    80107875 <alltraps>

80108463 <vector177>:
.globl vector177
vector177:
  pushl $0
80108463:	6a 00                	push   $0x0
  pushl $177
80108465:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010846a:	e9 06 f4 ff ff       	jmp    80107875 <alltraps>

8010846f <vector178>:
.globl vector178
vector178:
  pushl $0
8010846f:	6a 00                	push   $0x0
  pushl $178
80108471:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80108476:	e9 fa f3 ff ff       	jmp    80107875 <alltraps>

8010847b <vector179>:
.globl vector179
vector179:
  pushl $0
8010847b:	6a 00                	push   $0x0
  pushl $179
8010847d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80108482:	e9 ee f3 ff ff       	jmp    80107875 <alltraps>

80108487 <vector180>:
.globl vector180
vector180:
  pushl $0
80108487:	6a 00                	push   $0x0
  pushl $180
80108489:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010848e:	e9 e2 f3 ff ff       	jmp    80107875 <alltraps>

80108493 <vector181>:
.globl vector181
vector181:
  pushl $0
80108493:	6a 00                	push   $0x0
  pushl $181
80108495:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010849a:	e9 d6 f3 ff ff       	jmp    80107875 <alltraps>

8010849f <vector182>:
.globl vector182
vector182:
  pushl $0
8010849f:	6a 00                	push   $0x0
  pushl $182
801084a1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801084a6:	e9 ca f3 ff ff       	jmp    80107875 <alltraps>

801084ab <vector183>:
.globl vector183
vector183:
  pushl $0
801084ab:	6a 00                	push   $0x0
  pushl $183
801084ad:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801084b2:	e9 be f3 ff ff       	jmp    80107875 <alltraps>

801084b7 <vector184>:
.globl vector184
vector184:
  pushl $0
801084b7:	6a 00                	push   $0x0
  pushl $184
801084b9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801084be:	e9 b2 f3 ff ff       	jmp    80107875 <alltraps>

801084c3 <vector185>:
.globl vector185
vector185:
  pushl $0
801084c3:	6a 00                	push   $0x0
  pushl $185
801084c5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801084ca:	e9 a6 f3 ff ff       	jmp    80107875 <alltraps>

801084cf <vector186>:
.globl vector186
vector186:
  pushl $0
801084cf:	6a 00                	push   $0x0
  pushl $186
801084d1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801084d6:	e9 9a f3 ff ff       	jmp    80107875 <alltraps>

801084db <vector187>:
.globl vector187
vector187:
  pushl $0
801084db:	6a 00                	push   $0x0
  pushl $187
801084dd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801084e2:	e9 8e f3 ff ff       	jmp    80107875 <alltraps>

801084e7 <vector188>:
.globl vector188
vector188:
  pushl $0
801084e7:	6a 00                	push   $0x0
  pushl $188
801084e9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801084ee:	e9 82 f3 ff ff       	jmp    80107875 <alltraps>

801084f3 <vector189>:
.globl vector189
vector189:
  pushl $0
801084f3:	6a 00                	push   $0x0
  pushl $189
801084f5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801084fa:	e9 76 f3 ff ff       	jmp    80107875 <alltraps>

801084ff <vector190>:
.globl vector190
vector190:
  pushl $0
801084ff:	6a 00                	push   $0x0
  pushl $190
80108501:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80108506:	e9 6a f3 ff ff       	jmp    80107875 <alltraps>

8010850b <vector191>:
.globl vector191
vector191:
  pushl $0
8010850b:	6a 00                	push   $0x0
  pushl $191
8010850d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80108512:	e9 5e f3 ff ff       	jmp    80107875 <alltraps>

80108517 <vector192>:
.globl vector192
vector192:
  pushl $0
80108517:	6a 00                	push   $0x0
  pushl $192
80108519:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010851e:	e9 52 f3 ff ff       	jmp    80107875 <alltraps>

80108523 <vector193>:
.globl vector193
vector193:
  pushl $0
80108523:	6a 00                	push   $0x0
  pushl $193
80108525:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010852a:	e9 46 f3 ff ff       	jmp    80107875 <alltraps>

8010852f <vector194>:
.globl vector194
vector194:
  pushl $0
8010852f:	6a 00                	push   $0x0
  pushl $194
80108531:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80108536:	e9 3a f3 ff ff       	jmp    80107875 <alltraps>

8010853b <vector195>:
.globl vector195
vector195:
  pushl $0
8010853b:	6a 00                	push   $0x0
  pushl $195
8010853d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80108542:	e9 2e f3 ff ff       	jmp    80107875 <alltraps>

80108547 <vector196>:
.globl vector196
vector196:
  pushl $0
80108547:	6a 00                	push   $0x0
  pushl $196
80108549:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010854e:	e9 22 f3 ff ff       	jmp    80107875 <alltraps>

80108553 <vector197>:
.globl vector197
vector197:
  pushl $0
80108553:	6a 00                	push   $0x0
  pushl $197
80108555:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010855a:	e9 16 f3 ff ff       	jmp    80107875 <alltraps>

8010855f <vector198>:
.globl vector198
vector198:
  pushl $0
8010855f:	6a 00                	push   $0x0
  pushl $198
80108561:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80108566:	e9 0a f3 ff ff       	jmp    80107875 <alltraps>

8010856b <vector199>:
.globl vector199
vector199:
  pushl $0
8010856b:	6a 00                	push   $0x0
  pushl $199
8010856d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80108572:	e9 fe f2 ff ff       	jmp    80107875 <alltraps>

80108577 <vector200>:
.globl vector200
vector200:
  pushl $0
80108577:	6a 00                	push   $0x0
  pushl $200
80108579:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010857e:	e9 f2 f2 ff ff       	jmp    80107875 <alltraps>

80108583 <vector201>:
.globl vector201
vector201:
  pushl $0
80108583:	6a 00                	push   $0x0
  pushl $201
80108585:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010858a:	e9 e6 f2 ff ff       	jmp    80107875 <alltraps>

8010858f <vector202>:
.globl vector202
vector202:
  pushl $0
8010858f:	6a 00                	push   $0x0
  pushl $202
80108591:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80108596:	e9 da f2 ff ff       	jmp    80107875 <alltraps>

8010859b <vector203>:
.globl vector203
vector203:
  pushl $0
8010859b:	6a 00                	push   $0x0
  pushl $203
8010859d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801085a2:	e9 ce f2 ff ff       	jmp    80107875 <alltraps>

801085a7 <vector204>:
.globl vector204
vector204:
  pushl $0
801085a7:	6a 00                	push   $0x0
  pushl $204
801085a9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801085ae:	e9 c2 f2 ff ff       	jmp    80107875 <alltraps>

801085b3 <vector205>:
.globl vector205
vector205:
  pushl $0
801085b3:	6a 00                	push   $0x0
  pushl $205
801085b5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801085ba:	e9 b6 f2 ff ff       	jmp    80107875 <alltraps>

801085bf <vector206>:
.globl vector206
vector206:
  pushl $0
801085bf:	6a 00                	push   $0x0
  pushl $206
801085c1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801085c6:	e9 aa f2 ff ff       	jmp    80107875 <alltraps>

801085cb <vector207>:
.globl vector207
vector207:
  pushl $0
801085cb:	6a 00                	push   $0x0
  pushl $207
801085cd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801085d2:	e9 9e f2 ff ff       	jmp    80107875 <alltraps>

801085d7 <vector208>:
.globl vector208
vector208:
  pushl $0
801085d7:	6a 00                	push   $0x0
  pushl $208
801085d9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801085de:	e9 92 f2 ff ff       	jmp    80107875 <alltraps>

801085e3 <vector209>:
.globl vector209
vector209:
  pushl $0
801085e3:	6a 00                	push   $0x0
  pushl $209
801085e5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801085ea:	e9 86 f2 ff ff       	jmp    80107875 <alltraps>

801085ef <vector210>:
.globl vector210
vector210:
  pushl $0
801085ef:	6a 00                	push   $0x0
  pushl $210
801085f1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801085f6:	e9 7a f2 ff ff       	jmp    80107875 <alltraps>

801085fb <vector211>:
.globl vector211
vector211:
  pushl $0
801085fb:	6a 00                	push   $0x0
  pushl $211
801085fd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80108602:	e9 6e f2 ff ff       	jmp    80107875 <alltraps>

80108607 <vector212>:
.globl vector212
vector212:
  pushl $0
80108607:	6a 00                	push   $0x0
  pushl $212
80108609:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010860e:	e9 62 f2 ff ff       	jmp    80107875 <alltraps>

80108613 <vector213>:
.globl vector213
vector213:
  pushl $0
80108613:	6a 00                	push   $0x0
  pushl $213
80108615:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010861a:	e9 56 f2 ff ff       	jmp    80107875 <alltraps>

8010861f <vector214>:
.globl vector214
vector214:
  pushl $0
8010861f:	6a 00                	push   $0x0
  pushl $214
80108621:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80108626:	e9 4a f2 ff ff       	jmp    80107875 <alltraps>

8010862b <vector215>:
.globl vector215
vector215:
  pushl $0
8010862b:	6a 00                	push   $0x0
  pushl $215
8010862d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80108632:	e9 3e f2 ff ff       	jmp    80107875 <alltraps>

80108637 <vector216>:
.globl vector216
vector216:
  pushl $0
80108637:	6a 00                	push   $0x0
  pushl $216
80108639:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010863e:	e9 32 f2 ff ff       	jmp    80107875 <alltraps>

80108643 <vector217>:
.globl vector217
vector217:
  pushl $0
80108643:	6a 00                	push   $0x0
  pushl $217
80108645:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010864a:	e9 26 f2 ff ff       	jmp    80107875 <alltraps>

8010864f <vector218>:
.globl vector218
vector218:
  pushl $0
8010864f:	6a 00                	push   $0x0
  pushl $218
80108651:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80108656:	e9 1a f2 ff ff       	jmp    80107875 <alltraps>

8010865b <vector219>:
.globl vector219
vector219:
  pushl $0
8010865b:	6a 00                	push   $0x0
  pushl $219
8010865d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80108662:	e9 0e f2 ff ff       	jmp    80107875 <alltraps>

80108667 <vector220>:
.globl vector220
vector220:
  pushl $0
80108667:	6a 00                	push   $0x0
  pushl $220
80108669:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010866e:	e9 02 f2 ff ff       	jmp    80107875 <alltraps>

80108673 <vector221>:
.globl vector221
vector221:
  pushl $0
80108673:	6a 00                	push   $0x0
  pushl $221
80108675:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010867a:	e9 f6 f1 ff ff       	jmp    80107875 <alltraps>

8010867f <vector222>:
.globl vector222
vector222:
  pushl $0
8010867f:	6a 00                	push   $0x0
  pushl $222
80108681:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80108686:	e9 ea f1 ff ff       	jmp    80107875 <alltraps>

8010868b <vector223>:
.globl vector223
vector223:
  pushl $0
8010868b:	6a 00                	push   $0x0
  pushl $223
8010868d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80108692:	e9 de f1 ff ff       	jmp    80107875 <alltraps>

80108697 <vector224>:
.globl vector224
vector224:
  pushl $0
80108697:	6a 00                	push   $0x0
  pushl $224
80108699:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010869e:	e9 d2 f1 ff ff       	jmp    80107875 <alltraps>

801086a3 <vector225>:
.globl vector225
vector225:
  pushl $0
801086a3:	6a 00                	push   $0x0
  pushl $225
801086a5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801086aa:	e9 c6 f1 ff ff       	jmp    80107875 <alltraps>

801086af <vector226>:
.globl vector226
vector226:
  pushl $0
801086af:	6a 00                	push   $0x0
  pushl $226
801086b1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801086b6:	e9 ba f1 ff ff       	jmp    80107875 <alltraps>

801086bb <vector227>:
.globl vector227
vector227:
  pushl $0
801086bb:	6a 00                	push   $0x0
  pushl $227
801086bd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801086c2:	e9 ae f1 ff ff       	jmp    80107875 <alltraps>

801086c7 <vector228>:
.globl vector228
vector228:
  pushl $0
801086c7:	6a 00                	push   $0x0
  pushl $228
801086c9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801086ce:	e9 a2 f1 ff ff       	jmp    80107875 <alltraps>

801086d3 <vector229>:
.globl vector229
vector229:
  pushl $0
801086d3:	6a 00                	push   $0x0
  pushl $229
801086d5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801086da:	e9 96 f1 ff ff       	jmp    80107875 <alltraps>

801086df <vector230>:
.globl vector230
vector230:
  pushl $0
801086df:	6a 00                	push   $0x0
  pushl $230
801086e1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801086e6:	e9 8a f1 ff ff       	jmp    80107875 <alltraps>

801086eb <vector231>:
.globl vector231
vector231:
  pushl $0
801086eb:	6a 00                	push   $0x0
  pushl $231
801086ed:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801086f2:	e9 7e f1 ff ff       	jmp    80107875 <alltraps>

801086f7 <vector232>:
.globl vector232
vector232:
  pushl $0
801086f7:	6a 00                	push   $0x0
  pushl $232
801086f9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801086fe:	e9 72 f1 ff ff       	jmp    80107875 <alltraps>

80108703 <vector233>:
.globl vector233
vector233:
  pushl $0
80108703:	6a 00                	push   $0x0
  pushl $233
80108705:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010870a:	e9 66 f1 ff ff       	jmp    80107875 <alltraps>

8010870f <vector234>:
.globl vector234
vector234:
  pushl $0
8010870f:	6a 00                	push   $0x0
  pushl $234
80108711:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80108716:	e9 5a f1 ff ff       	jmp    80107875 <alltraps>

8010871b <vector235>:
.globl vector235
vector235:
  pushl $0
8010871b:	6a 00                	push   $0x0
  pushl $235
8010871d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80108722:	e9 4e f1 ff ff       	jmp    80107875 <alltraps>

80108727 <vector236>:
.globl vector236
vector236:
  pushl $0
80108727:	6a 00                	push   $0x0
  pushl $236
80108729:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010872e:	e9 42 f1 ff ff       	jmp    80107875 <alltraps>

80108733 <vector237>:
.globl vector237
vector237:
  pushl $0
80108733:	6a 00                	push   $0x0
  pushl $237
80108735:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010873a:	e9 36 f1 ff ff       	jmp    80107875 <alltraps>

8010873f <vector238>:
.globl vector238
vector238:
  pushl $0
8010873f:	6a 00                	push   $0x0
  pushl $238
80108741:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80108746:	e9 2a f1 ff ff       	jmp    80107875 <alltraps>

8010874b <vector239>:
.globl vector239
vector239:
  pushl $0
8010874b:	6a 00                	push   $0x0
  pushl $239
8010874d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80108752:	e9 1e f1 ff ff       	jmp    80107875 <alltraps>

80108757 <vector240>:
.globl vector240
vector240:
  pushl $0
80108757:	6a 00                	push   $0x0
  pushl $240
80108759:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010875e:	e9 12 f1 ff ff       	jmp    80107875 <alltraps>

80108763 <vector241>:
.globl vector241
vector241:
  pushl $0
80108763:	6a 00                	push   $0x0
  pushl $241
80108765:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010876a:	e9 06 f1 ff ff       	jmp    80107875 <alltraps>

8010876f <vector242>:
.globl vector242
vector242:
  pushl $0
8010876f:	6a 00                	push   $0x0
  pushl $242
80108771:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80108776:	e9 fa f0 ff ff       	jmp    80107875 <alltraps>

8010877b <vector243>:
.globl vector243
vector243:
  pushl $0
8010877b:	6a 00                	push   $0x0
  pushl $243
8010877d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80108782:	e9 ee f0 ff ff       	jmp    80107875 <alltraps>

80108787 <vector244>:
.globl vector244
vector244:
  pushl $0
80108787:	6a 00                	push   $0x0
  pushl $244
80108789:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010878e:	e9 e2 f0 ff ff       	jmp    80107875 <alltraps>

80108793 <vector245>:
.globl vector245
vector245:
  pushl $0
80108793:	6a 00                	push   $0x0
  pushl $245
80108795:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010879a:	e9 d6 f0 ff ff       	jmp    80107875 <alltraps>

8010879f <vector246>:
.globl vector246
vector246:
  pushl $0
8010879f:	6a 00                	push   $0x0
  pushl $246
801087a1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801087a6:	e9 ca f0 ff ff       	jmp    80107875 <alltraps>

801087ab <vector247>:
.globl vector247
vector247:
  pushl $0
801087ab:	6a 00                	push   $0x0
  pushl $247
801087ad:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801087b2:	e9 be f0 ff ff       	jmp    80107875 <alltraps>

801087b7 <vector248>:
.globl vector248
vector248:
  pushl $0
801087b7:	6a 00                	push   $0x0
  pushl $248
801087b9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801087be:	e9 b2 f0 ff ff       	jmp    80107875 <alltraps>

801087c3 <vector249>:
.globl vector249
vector249:
  pushl $0
801087c3:	6a 00                	push   $0x0
  pushl $249
801087c5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801087ca:	e9 a6 f0 ff ff       	jmp    80107875 <alltraps>

801087cf <vector250>:
.globl vector250
vector250:
  pushl $0
801087cf:	6a 00                	push   $0x0
  pushl $250
801087d1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801087d6:	e9 9a f0 ff ff       	jmp    80107875 <alltraps>

801087db <vector251>:
.globl vector251
vector251:
  pushl $0
801087db:	6a 00                	push   $0x0
  pushl $251
801087dd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801087e2:	e9 8e f0 ff ff       	jmp    80107875 <alltraps>

801087e7 <vector252>:
.globl vector252
vector252:
  pushl $0
801087e7:	6a 00                	push   $0x0
  pushl $252
801087e9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801087ee:	e9 82 f0 ff ff       	jmp    80107875 <alltraps>

801087f3 <vector253>:
.globl vector253
vector253:
  pushl $0
801087f3:	6a 00                	push   $0x0
  pushl $253
801087f5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801087fa:	e9 76 f0 ff ff       	jmp    80107875 <alltraps>

801087ff <vector254>:
.globl vector254
vector254:
  pushl $0
801087ff:	6a 00                	push   $0x0
  pushl $254
80108801:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80108806:	e9 6a f0 ff ff       	jmp    80107875 <alltraps>

8010880b <vector255>:
.globl vector255
vector255:
  pushl $0
8010880b:	6a 00                	push   $0x0
  pushl $255
8010880d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80108812:	e9 5e f0 ff ff       	jmp    80107875 <alltraps>
80108817:	66 90                	xchg   %ax,%ax
80108819:	66 90                	xchg   %ax,%ax
8010881b:	66 90                	xchg   %ax,%ax
8010881d:	66 90                	xchg   %ax,%ax
8010881f:	90                   	nop

80108820 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80108820:	55                   	push   %ebp
80108821:	89 e5                	mov    %esp,%ebp
80108823:	57                   	push   %edi
80108824:	56                   	push   %esi
80108825:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80108826:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010882c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80108832:	83 ec 1c             	sub    $0x1c,%esp
80108835:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108838:	39 d3                	cmp    %edx,%ebx
8010883a:	73 49                	jae    80108885 <deallocuvm.part.0+0x65>
8010883c:	89 c7                	mov    %eax,%edi
8010883e:	eb 0c                	jmp    8010884c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80108840:	83 c0 01             	add    $0x1,%eax
80108843:	c1 e0 16             	shl    $0x16,%eax
80108846:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80108848:	39 da                	cmp    %ebx,%edx
8010884a:	76 39                	jbe    80108885 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
8010884c:	89 d8                	mov    %ebx,%eax
8010884e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80108851:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80108854:	f6 c1 01             	test   $0x1,%cl
80108857:	74 e7                	je     80108840 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80108859:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010885b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80108861:	c1 ee 0a             	shr    $0xa,%esi
80108864:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010886a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80108871:	85 f6                	test   %esi,%esi
80108873:	74 cb                	je     80108840 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80108875:	8b 06                	mov    (%esi),%eax
80108877:	a8 01                	test   $0x1,%al
80108879:	75 15                	jne    80108890 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
8010887b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108881:	39 da                	cmp    %ebx,%edx
80108883:	77 c7                	ja     8010884c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80108885:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108888:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010888b:	5b                   	pop    %ebx
8010888c:	5e                   	pop    %esi
8010888d:	5f                   	pop    %edi
8010888e:	5d                   	pop    %ebp
8010888f:	c3                   	ret    
      if(pa == 0)
80108890:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108895:	74 25                	je     801088bc <deallocuvm.part.0+0x9c>
      kfree(v);
80108897:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010889a:	05 00 00 00 80       	add    $0x80000000,%eax
8010889f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801088a2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
801088a8:	50                   	push   %eax
801088a9:	e8 22 b0 ff ff       	call   801038d0 <kfree>
      *pte = 0;
801088ae:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
801088b4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801088b7:	83 c4 10             	add    $0x10,%esp
801088ba:	eb 8c                	jmp    80108848 <deallocuvm.part.0+0x28>
        panic("kfree");
801088bc:	83 ec 0c             	sub    $0xc,%esp
801088bf:	68 d6 94 10 80       	push   $0x801094d6
801088c4:	e8 b7 7a ff ff       	call   80100380 <panic>
801088c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801088d0 <mappages>:
{
801088d0:	55                   	push   %ebp
801088d1:	89 e5                	mov    %esp,%ebp
801088d3:	57                   	push   %edi
801088d4:	56                   	push   %esi
801088d5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801088d6:	89 d3                	mov    %edx,%ebx
801088d8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801088de:	83 ec 1c             	sub    $0x1c,%esp
801088e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801088e4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801088e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801088ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
801088f0:	8b 45 08             	mov    0x8(%ebp),%eax
801088f3:	29 d8                	sub    %ebx,%eax
801088f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801088f8:	eb 3d                	jmp    80108937 <mappages+0x67>
801088fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80108900:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108902:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80108907:	c1 ea 0a             	shr    $0xa,%edx
8010890a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80108910:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108917:	85 c0                	test   %eax,%eax
80108919:	74 75                	je     80108990 <mappages+0xc0>
    if(*pte & PTE_P)
8010891b:	f6 00 01             	testb  $0x1,(%eax)
8010891e:	0f 85 86 00 00 00    	jne    801089aa <mappages+0xda>
    *pte = pa | perm | PTE_P;
80108924:	0b 75 0c             	or     0xc(%ebp),%esi
80108927:	83 ce 01             	or     $0x1,%esi
8010892a:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010892c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
8010892f:	74 6f                	je     801089a0 <mappages+0xd0>
    a += PGSIZE;
80108931:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80108937:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
8010893a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010893d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80108940:	89 d8                	mov    %ebx,%eax
80108942:	c1 e8 16             	shr    $0x16,%eax
80108945:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80108948:	8b 07                	mov    (%edi),%eax
8010894a:	a8 01                	test   $0x1,%al
8010894c:	75 b2                	jne    80108900 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010894e:	e8 3d b1 ff ff       	call   80103a90 <kalloc>
80108953:	85 c0                	test   %eax,%eax
80108955:	74 39                	je     80108990 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80108957:	83 ec 04             	sub    $0x4,%esp
8010895a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010895d:	68 00 10 00 00       	push   $0x1000
80108962:	6a 00                	push   $0x0
80108964:	50                   	push   %eax
80108965:	e8 a6 d8 ff ff       	call   80106210 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010896a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010896d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80108970:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80108976:	83 c8 07             	or     $0x7,%eax
80108979:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010897b:	89 d8                	mov    %ebx,%eax
8010897d:	c1 e8 0a             	shr    $0xa,%eax
80108980:	25 fc 0f 00 00       	and    $0xffc,%eax
80108985:	01 d0                	add    %edx,%eax
80108987:	eb 92                	jmp    8010891b <mappages+0x4b>
80108989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80108990:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108993:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108998:	5b                   	pop    %ebx
80108999:	5e                   	pop    %esi
8010899a:	5f                   	pop    %edi
8010899b:	5d                   	pop    %ebp
8010899c:	c3                   	ret    
8010899d:	8d 76 00             	lea    0x0(%esi),%esi
801089a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801089a3:	31 c0                	xor    %eax,%eax
}
801089a5:	5b                   	pop    %ebx
801089a6:	5e                   	pop    %esi
801089a7:	5f                   	pop    %edi
801089a8:	5d                   	pop    %ebp
801089a9:	c3                   	ret    
      panic("remap");
801089aa:	83 ec 0c             	sub    $0xc,%esp
801089ad:	68 84 9c 10 80       	push   $0x80109c84
801089b2:	e8 c9 79 ff ff       	call   80100380 <panic>
801089b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801089be:	66 90                	xchg   %ax,%ax

801089c0 <seginit>:
{
801089c0:	55                   	push   %ebp
801089c1:	89 e5                	mov    %esp,%ebp
801089c3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801089c6:	e8 e5 c5 ff ff       	call   80104fb0 <cpuid>
  pd[0] = size-1;
801089cb:	ba 2f 00 00 00       	mov    $0x2f,%edx
801089d0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801089d6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801089da:	c7 80 98 3f 11 80 ff 	movl   $0xffff,-0x7feec068(%eax)
801089e1:	ff 00 00 
801089e4:	c7 80 9c 3f 11 80 00 	movl   $0xcf9a00,-0x7feec064(%eax)
801089eb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801089ee:	c7 80 a0 3f 11 80 ff 	movl   $0xffff,-0x7feec060(%eax)
801089f5:	ff 00 00 
801089f8:	c7 80 a4 3f 11 80 00 	movl   $0xcf9200,-0x7feec05c(%eax)
801089ff:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80108a02:	c7 80 a8 3f 11 80 ff 	movl   $0xffff,-0x7feec058(%eax)
80108a09:	ff 00 00 
80108a0c:	c7 80 ac 3f 11 80 00 	movl   $0xcffa00,-0x7feec054(%eax)
80108a13:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80108a16:	c7 80 b0 3f 11 80 ff 	movl   $0xffff,-0x7feec050(%eax)
80108a1d:	ff 00 00 
80108a20:	c7 80 b4 3f 11 80 00 	movl   $0xcff200,-0x7feec04c(%eax)
80108a27:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80108a2a:	05 90 3f 11 80       	add    $0x80113f90,%eax
  pd[1] = (uint)p;
80108a2f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80108a33:	c1 e8 10             	shr    $0x10,%eax
80108a36:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80108a3a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80108a3d:	0f 01 10             	lgdtl  (%eax)
}
80108a40:	c9                   	leave  
80108a41:	c3                   	ret    
80108a42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108a50 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108a50:	a1 44 8e 11 80       	mov    0x80118e44,%eax
80108a55:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108a5a:	0f 22 d8             	mov    %eax,%cr3
}
80108a5d:	c3                   	ret    
80108a5e:	66 90                	xchg   %ax,%ax

80108a60 <switchuvm>:
{
80108a60:	55                   	push   %ebp
80108a61:	89 e5                	mov    %esp,%ebp
80108a63:	57                   	push   %edi
80108a64:	56                   	push   %esi
80108a65:	53                   	push   %ebx
80108a66:	83 ec 1c             	sub    $0x1c,%esp
80108a69:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80108a6c:	85 f6                	test   %esi,%esi
80108a6e:	0f 84 cb 00 00 00    	je     80108b3f <switchuvm+0xdf>
  if(p->kstack == 0)
80108a74:	8b 46 08             	mov    0x8(%esi),%eax
80108a77:	85 c0                	test   %eax,%eax
80108a79:	0f 84 da 00 00 00    	je     80108b59 <switchuvm+0xf9>
  if(p->pgdir == 0)
80108a7f:	8b 46 04             	mov    0x4(%esi),%eax
80108a82:	85 c0                	test   %eax,%eax
80108a84:	0f 84 c2 00 00 00    	je     80108b4c <switchuvm+0xec>
  pushcli();
80108a8a:	e8 71 d5 ff ff       	call   80106000 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80108a8f:	e8 bc c4 ff ff       	call   80104f50 <mycpu>
80108a94:	89 c3                	mov    %eax,%ebx
80108a96:	e8 b5 c4 ff ff       	call   80104f50 <mycpu>
80108a9b:	89 c7                	mov    %eax,%edi
80108a9d:	e8 ae c4 ff ff       	call   80104f50 <mycpu>
80108aa2:	83 c7 08             	add    $0x8,%edi
80108aa5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108aa8:	e8 a3 c4 ff ff       	call   80104f50 <mycpu>
80108aad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80108ab0:	ba 67 00 00 00       	mov    $0x67,%edx
80108ab5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80108abc:	83 c0 08             	add    $0x8,%eax
80108abf:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80108ac6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80108acb:	83 c1 08             	add    $0x8,%ecx
80108ace:	c1 e8 18             	shr    $0x18,%eax
80108ad1:	c1 e9 10             	shr    $0x10,%ecx
80108ad4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80108ada:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80108ae0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80108ae5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80108aec:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80108af1:	e8 5a c4 ff ff       	call   80104f50 <mycpu>
80108af6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80108afd:	e8 4e c4 ff ff       	call   80104f50 <mycpu>
80108b02:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80108b06:	8b 5e 08             	mov    0x8(%esi),%ebx
80108b09:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108b0f:	e8 3c c4 ff ff       	call   80104f50 <mycpu>
80108b14:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80108b17:	e8 34 c4 ff ff       	call   80104f50 <mycpu>
80108b1c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80108b20:	b8 28 00 00 00       	mov    $0x28,%eax
80108b25:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80108b28:	8b 46 04             	mov    0x4(%esi),%eax
80108b2b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108b30:	0f 22 d8             	mov    %eax,%cr3
}
80108b33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108b36:	5b                   	pop    %ebx
80108b37:	5e                   	pop    %esi
80108b38:	5f                   	pop    %edi
80108b39:	5d                   	pop    %ebp
  popcli();
80108b3a:	e9 11 d5 ff ff       	jmp    80106050 <popcli>
    panic("switchuvm: no process");
80108b3f:	83 ec 0c             	sub    $0xc,%esp
80108b42:	68 8a 9c 10 80       	push   $0x80109c8a
80108b47:	e8 34 78 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80108b4c:	83 ec 0c             	sub    $0xc,%esp
80108b4f:	68 b5 9c 10 80       	push   $0x80109cb5
80108b54:	e8 27 78 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80108b59:	83 ec 0c             	sub    $0xc,%esp
80108b5c:	68 a0 9c 10 80       	push   $0x80109ca0
80108b61:	e8 1a 78 ff ff       	call   80100380 <panic>
80108b66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108b6d:	8d 76 00             	lea    0x0(%esi),%esi

80108b70 <inituvm>:
{
80108b70:	55                   	push   %ebp
80108b71:	89 e5                	mov    %esp,%ebp
80108b73:	57                   	push   %edi
80108b74:	56                   	push   %esi
80108b75:	53                   	push   %ebx
80108b76:	83 ec 1c             	sub    $0x1c,%esp
80108b79:	8b 45 0c             	mov    0xc(%ebp),%eax
80108b7c:	8b 75 10             	mov    0x10(%ebp),%esi
80108b7f:	8b 7d 08             	mov    0x8(%ebp),%edi
80108b82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80108b85:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80108b8b:	77 4b                	ja     80108bd8 <inituvm+0x68>
  mem = kalloc();
80108b8d:	e8 fe ae ff ff       	call   80103a90 <kalloc>
  memset(mem, 0, PGSIZE);
80108b92:	83 ec 04             	sub    $0x4,%esp
80108b95:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80108b9a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80108b9c:	6a 00                	push   $0x0
80108b9e:	50                   	push   %eax
80108b9f:	e8 6c d6 ff ff       	call   80106210 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80108ba4:	58                   	pop    %eax
80108ba5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80108bab:	5a                   	pop    %edx
80108bac:	6a 06                	push   $0x6
80108bae:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108bb3:	31 d2                	xor    %edx,%edx
80108bb5:	50                   	push   %eax
80108bb6:	89 f8                	mov    %edi,%eax
80108bb8:	e8 13 fd ff ff       	call   801088d0 <mappages>
  memmove(mem, init, sz);
80108bbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108bc0:	89 75 10             	mov    %esi,0x10(%ebp)
80108bc3:	83 c4 10             	add    $0x10,%esp
80108bc6:	89 5d 08             	mov    %ebx,0x8(%ebp)
80108bc9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80108bcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108bcf:	5b                   	pop    %ebx
80108bd0:	5e                   	pop    %esi
80108bd1:	5f                   	pop    %edi
80108bd2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80108bd3:	e9 d8 d6 ff ff       	jmp    801062b0 <memmove>
    panic("inituvm: more than a page");
80108bd8:	83 ec 0c             	sub    $0xc,%esp
80108bdb:	68 c9 9c 10 80       	push   $0x80109cc9
80108be0:	e8 9b 77 ff ff       	call   80100380 <panic>
80108be5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108bf0 <loaduvm>:
{
80108bf0:	55                   	push   %ebp
80108bf1:	89 e5                	mov    %esp,%ebp
80108bf3:	57                   	push   %edi
80108bf4:	56                   	push   %esi
80108bf5:	53                   	push   %ebx
80108bf6:	83 ec 1c             	sub    $0x1c,%esp
80108bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
80108bfc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80108bff:	a9 ff 0f 00 00       	test   $0xfff,%eax
80108c04:	0f 85 bb 00 00 00    	jne    80108cc5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80108c0a:	01 f0                	add    %esi,%eax
80108c0c:	89 f3                	mov    %esi,%ebx
80108c0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108c11:	8b 45 14             	mov    0x14(%ebp),%eax
80108c14:	01 f0                	add    %esi,%eax
80108c16:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80108c19:	85 f6                	test   %esi,%esi
80108c1b:	0f 84 87 00 00 00    	je     80108ca8 <loaduvm+0xb8>
80108c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80108c28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80108c2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80108c2e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80108c30:	89 c2                	mov    %eax,%edx
80108c32:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80108c35:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80108c38:	f6 c2 01             	test   $0x1,%dl
80108c3b:	75 13                	jne    80108c50 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80108c3d:	83 ec 0c             	sub    $0xc,%esp
80108c40:	68 e3 9c 10 80       	push   $0x80109ce3
80108c45:	e8 36 77 ff ff       	call   80100380 <panic>
80108c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80108c50:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108c53:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80108c59:	25 fc 0f 00 00       	and    $0xffc,%eax
80108c5e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108c65:	85 c0                	test   %eax,%eax
80108c67:	74 d4                	je     80108c3d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80108c69:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108c6b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80108c6e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80108c73:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80108c78:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80108c7e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108c81:	29 d9                	sub    %ebx,%ecx
80108c83:	05 00 00 00 80       	add    $0x80000000,%eax
80108c88:	57                   	push   %edi
80108c89:	51                   	push   %ecx
80108c8a:	50                   	push   %eax
80108c8b:	ff 75 10             	push   0x10(%ebp)
80108c8e:	e8 0d a2 ff ff       	call   80102ea0 <readi>
80108c93:	83 c4 10             	add    $0x10,%esp
80108c96:	39 f8                	cmp    %edi,%eax
80108c98:	75 1e                	jne    80108cb8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80108c9a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80108ca0:	89 f0                	mov    %esi,%eax
80108ca2:	29 d8                	sub    %ebx,%eax
80108ca4:	39 c6                	cmp    %eax,%esi
80108ca6:	77 80                	ja     80108c28 <loaduvm+0x38>
}
80108ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108cab:	31 c0                	xor    %eax,%eax
}
80108cad:	5b                   	pop    %ebx
80108cae:	5e                   	pop    %esi
80108caf:	5f                   	pop    %edi
80108cb0:	5d                   	pop    %ebp
80108cb1:	c3                   	ret    
80108cb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108cb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108cbb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108cc0:	5b                   	pop    %ebx
80108cc1:	5e                   	pop    %esi
80108cc2:	5f                   	pop    %edi
80108cc3:	5d                   	pop    %ebp
80108cc4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80108cc5:	83 ec 0c             	sub    $0xc,%esp
80108cc8:	68 84 9d 10 80       	push   $0x80109d84
80108ccd:	e8 ae 76 ff ff       	call   80100380 <panic>
80108cd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108ce0 <allocuvm>:
{
80108ce0:	55                   	push   %ebp
80108ce1:	89 e5                	mov    %esp,%ebp
80108ce3:	57                   	push   %edi
80108ce4:	56                   	push   %esi
80108ce5:	53                   	push   %ebx
80108ce6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80108ce9:	8b 45 10             	mov    0x10(%ebp),%eax
{
80108cec:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80108cef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108cf2:	85 c0                	test   %eax,%eax
80108cf4:	0f 88 b6 00 00 00    	js     80108db0 <allocuvm+0xd0>
  if(newsz < oldsz)
80108cfa:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80108cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80108d00:	0f 82 9a 00 00 00    	jb     80108da0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80108d06:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80108d0c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80108d12:	39 75 10             	cmp    %esi,0x10(%ebp)
80108d15:	77 44                	ja     80108d5b <allocuvm+0x7b>
80108d17:	e9 87 00 00 00       	jmp    80108da3 <allocuvm+0xc3>
80108d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80108d20:	83 ec 04             	sub    $0x4,%esp
80108d23:	68 00 10 00 00       	push   $0x1000
80108d28:	6a 00                	push   $0x0
80108d2a:	50                   	push   %eax
80108d2b:	e8 e0 d4 ff ff       	call   80106210 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80108d30:	58                   	pop    %eax
80108d31:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80108d37:	5a                   	pop    %edx
80108d38:	6a 06                	push   $0x6
80108d3a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108d3f:	89 f2                	mov    %esi,%edx
80108d41:	50                   	push   %eax
80108d42:	89 f8                	mov    %edi,%eax
80108d44:	e8 87 fb ff ff       	call   801088d0 <mappages>
80108d49:	83 c4 10             	add    $0x10,%esp
80108d4c:	85 c0                	test   %eax,%eax
80108d4e:	78 78                	js     80108dc8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80108d50:	81 c6 00 10 00 00    	add    $0x1000,%esi
80108d56:	39 75 10             	cmp    %esi,0x10(%ebp)
80108d59:	76 48                	jbe    80108da3 <allocuvm+0xc3>
    mem = kalloc();
80108d5b:	e8 30 ad ff ff       	call   80103a90 <kalloc>
80108d60:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80108d62:	85 c0                	test   %eax,%eax
80108d64:	75 ba                	jne    80108d20 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80108d66:	83 ec 0c             	sub    $0xc,%esp
80108d69:	68 01 9d 10 80       	push   $0x80109d01
80108d6e:	e8 8d 79 ff ff       	call   80100700 <cprintf>
  if(newsz >= oldsz)
80108d73:	8b 45 0c             	mov    0xc(%ebp),%eax
80108d76:	83 c4 10             	add    $0x10,%esp
80108d79:	39 45 10             	cmp    %eax,0x10(%ebp)
80108d7c:	74 32                	je     80108db0 <allocuvm+0xd0>
80108d7e:	8b 55 10             	mov    0x10(%ebp),%edx
80108d81:	89 c1                	mov    %eax,%ecx
80108d83:	89 f8                	mov    %edi,%eax
80108d85:	e8 96 fa ff ff       	call   80108820 <deallocuvm.part.0>
      return 0;
80108d8a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80108d91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108d97:	5b                   	pop    %ebx
80108d98:	5e                   	pop    %esi
80108d99:	5f                   	pop    %edi
80108d9a:	5d                   	pop    %ebp
80108d9b:	c3                   	ret    
80108d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80108da0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80108da3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108da6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108da9:	5b                   	pop    %ebx
80108daa:	5e                   	pop    %esi
80108dab:	5f                   	pop    %edi
80108dac:	5d                   	pop    %ebp
80108dad:	c3                   	ret    
80108dae:	66 90                	xchg   %ax,%ax
    return 0;
80108db0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80108db7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108dba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108dbd:	5b                   	pop    %ebx
80108dbe:	5e                   	pop    %esi
80108dbf:	5f                   	pop    %edi
80108dc0:	5d                   	pop    %ebp
80108dc1:	c3                   	ret    
80108dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80108dc8:	83 ec 0c             	sub    $0xc,%esp
80108dcb:	68 19 9d 10 80       	push   $0x80109d19
80108dd0:	e8 2b 79 ff ff       	call   80100700 <cprintf>
  if(newsz >= oldsz)
80108dd5:	8b 45 0c             	mov    0xc(%ebp),%eax
80108dd8:	83 c4 10             	add    $0x10,%esp
80108ddb:	39 45 10             	cmp    %eax,0x10(%ebp)
80108dde:	74 0c                	je     80108dec <allocuvm+0x10c>
80108de0:	8b 55 10             	mov    0x10(%ebp),%edx
80108de3:	89 c1                	mov    %eax,%ecx
80108de5:	89 f8                	mov    %edi,%eax
80108de7:	e8 34 fa ff ff       	call   80108820 <deallocuvm.part.0>
      kfree(mem);
80108dec:	83 ec 0c             	sub    $0xc,%esp
80108def:	53                   	push   %ebx
80108df0:	e8 db aa ff ff       	call   801038d0 <kfree>
      return 0;
80108df5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80108dfc:	83 c4 10             	add    $0x10,%esp
}
80108dff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108e02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108e05:	5b                   	pop    %ebx
80108e06:	5e                   	pop    %esi
80108e07:	5f                   	pop    %edi
80108e08:	5d                   	pop    %ebp
80108e09:	c3                   	ret    
80108e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108e10 <deallocuvm>:
{
80108e10:	55                   	push   %ebp
80108e11:	89 e5                	mov    %esp,%ebp
80108e13:	8b 55 0c             	mov    0xc(%ebp),%edx
80108e16:	8b 4d 10             	mov    0x10(%ebp),%ecx
80108e19:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80108e1c:	39 d1                	cmp    %edx,%ecx
80108e1e:	73 10                	jae    80108e30 <deallocuvm+0x20>
}
80108e20:	5d                   	pop    %ebp
80108e21:	e9 fa f9 ff ff       	jmp    80108820 <deallocuvm.part.0>
80108e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108e2d:	8d 76 00             	lea    0x0(%esi),%esi
80108e30:	89 d0                	mov    %edx,%eax
80108e32:	5d                   	pop    %ebp
80108e33:	c3                   	ret    
80108e34:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108e3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108e3f:	90                   	nop

80108e40 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108e40:	55                   	push   %ebp
80108e41:	89 e5                	mov    %esp,%ebp
80108e43:	57                   	push   %edi
80108e44:	56                   	push   %esi
80108e45:	53                   	push   %ebx
80108e46:	83 ec 0c             	sub    $0xc,%esp
80108e49:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80108e4c:	85 f6                	test   %esi,%esi
80108e4e:	74 59                	je     80108ea9 <freevm+0x69>
  if(newsz >= oldsz)
80108e50:	31 c9                	xor    %ecx,%ecx
80108e52:	ba 00 00 00 80       	mov    $0x80000000,%edx
80108e57:	89 f0                	mov    %esi,%eax
80108e59:	89 f3                	mov    %esi,%ebx
80108e5b:	e8 c0 f9 ff ff       	call   80108820 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108e60:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80108e66:	eb 0f                	jmp    80108e77 <freevm+0x37>
80108e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108e6f:	90                   	nop
80108e70:	83 c3 04             	add    $0x4,%ebx
80108e73:	39 df                	cmp    %ebx,%edi
80108e75:	74 23                	je     80108e9a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80108e77:	8b 03                	mov    (%ebx),%eax
80108e79:	a8 01                	test   $0x1,%al
80108e7b:	74 f3                	je     80108e70 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108e7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80108e82:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108e85:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108e88:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80108e8d:	50                   	push   %eax
80108e8e:	e8 3d aa ff ff       	call   801038d0 <kfree>
80108e93:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108e96:	39 df                	cmp    %ebx,%edi
80108e98:	75 dd                	jne    80108e77 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80108e9a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80108e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108ea0:	5b                   	pop    %ebx
80108ea1:	5e                   	pop    %esi
80108ea2:	5f                   	pop    %edi
80108ea3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80108ea4:	e9 27 aa ff ff       	jmp    801038d0 <kfree>
    panic("freevm: no pgdir");
80108ea9:	83 ec 0c             	sub    $0xc,%esp
80108eac:	68 35 9d 10 80       	push   $0x80109d35
80108eb1:	e8 ca 74 ff ff       	call   80100380 <panic>
80108eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108ebd:	8d 76 00             	lea    0x0(%esi),%esi

80108ec0 <setupkvm>:
{
80108ec0:	55                   	push   %ebp
80108ec1:	89 e5                	mov    %esp,%ebp
80108ec3:	56                   	push   %esi
80108ec4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80108ec5:	e8 c6 ab ff ff       	call   80103a90 <kalloc>
80108eca:	89 c6                	mov    %eax,%esi
80108ecc:	85 c0                	test   %eax,%eax
80108ece:	74 42                	je     80108f12 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80108ed0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108ed3:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80108ed8:	68 00 10 00 00       	push   $0x1000
80108edd:	6a 00                	push   $0x0
80108edf:	50                   	push   %eax
80108ee0:	e8 2b d3 ff ff       	call   80106210 <memset>
80108ee5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80108ee8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80108eeb:	83 ec 08             	sub    $0x8,%esp
80108eee:	8b 4b 08             	mov    0x8(%ebx),%ecx
80108ef1:	ff 73 0c             	push   0xc(%ebx)
80108ef4:	8b 13                	mov    (%ebx),%edx
80108ef6:	50                   	push   %eax
80108ef7:	29 c1                	sub    %eax,%ecx
80108ef9:	89 f0                	mov    %esi,%eax
80108efb:	e8 d0 f9 ff ff       	call   801088d0 <mappages>
80108f00:	83 c4 10             	add    $0x10,%esp
80108f03:	85 c0                	test   %eax,%eax
80108f05:	78 19                	js     80108f20 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108f07:	83 c3 10             	add    $0x10,%ebx
80108f0a:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80108f10:	75 d6                	jne    80108ee8 <setupkvm+0x28>
}
80108f12:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108f15:	89 f0                	mov    %esi,%eax
80108f17:	5b                   	pop    %ebx
80108f18:	5e                   	pop    %esi
80108f19:	5d                   	pop    %ebp
80108f1a:	c3                   	ret    
80108f1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108f1f:	90                   	nop
      freevm(pgdir);
80108f20:	83 ec 0c             	sub    $0xc,%esp
80108f23:	56                   	push   %esi
      return 0;
80108f24:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80108f26:	e8 15 ff ff ff       	call   80108e40 <freevm>
      return 0;
80108f2b:	83 c4 10             	add    $0x10,%esp
}
80108f2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108f31:	89 f0                	mov    %esi,%eax
80108f33:	5b                   	pop    %ebx
80108f34:	5e                   	pop    %esi
80108f35:	5d                   	pop    %ebp
80108f36:	c3                   	ret    
80108f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108f3e:	66 90                	xchg   %ax,%ax

80108f40 <kvmalloc>:
{
80108f40:	55                   	push   %ebp
80108f41:	89 e5                	mov    %esp,%ebp
80108f43:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108f46:	e8 75 ff ff ff       	call   80108ec0 <setupkvm>
80108f4b:	a3 44 8e 11 80       	mov    %eax,0x80118e44
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108f50:	05 00 00 00 80       	add    $0x80000000,%eax
80108f55:	0f 22 d8             	mov    %eax,%cr3
}
80108f58:	c9                   	leave  
80108f59:	c3                   	ret    
80108f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108f60 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108f60:	55                   	push   %ebp
80108f61:	89 e5                	mov    %esp,%ebp
80108f63:	83 ec 08             	sub    $0x8,%esp
80108f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80108f69:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80108f6c:	89 c1                	mov    %eax,%ecx
80108f6e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80108f71:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80108f74:	f6 c2 01             	test   $0x1,%dl
80108f77:	75 17                	jne    80108f90 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80108f79:	83 ec 0c             	sub    $0xc,%esp
80108f7c:	68 46 9d 10 80       	push   $0x80109d46
80108f81:	e8 fa 73 ff ff       	call   80100380 <panic>
80108f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108f8d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80108f90:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108f93:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80108f99:	25 fc 0f 00 00       	and    $0xffc,%eax
80108f9e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80108fa5:	85 c0                	test   %eax,%eax
80108fa7:	74 d0                	je     80108f79 <clearpteu+0x19>
  *pte &= ~PTE_U;
80108fa9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80108fac:	c9                   	leave  
80108fad:	c3                   	ret    
80108fae:	66 90                	xchg   %ax,%ax

80108fb0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108fb0:	55                   	push   %ebp
80108fb1:	89 e5                	mov    %esp,%ebp
80108fb3:	57                   	push   %edi
80108fb4:	56                   	push   %esi
80108fb5:	53                   	push   %ebx
80108fb6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108fb9:	e8 02 ff ff ff       	call   80108ec0 <setupkvm>
80108fbe:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108fc1:	85 c0                	test   %eax,%eax
80108fc3:	0f 84 bd 00 00 00    	je     80109086 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108fc9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80108fcc:	85 c9                	test   %ecx,%ecx
80108fce:	0f 84 b2 00 00 00    	je     80109086 <copyuvm+0xd6>
80108fd4:	31 f6                	xor    %esi,%esi
80108fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108fdd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80108fe0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80108fe3:	89 f0                	mov    %esi,%eax
80108fe5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80108fe8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
80108feb:	a8 01                	test   $0x1,%al
80108fed:	75 11                	jne    80109000 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80108fef:	83 ec 0c             	sub    $0xc,%esp
80108ff2:	68 50 9d 10 80       	push   $0x80109d50
80108ff7:	e8 84 73 ff ff       	call   80100380 <panic>
80108ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80109000:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80109002:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80109007:	c1 ea 0a             	shr    $0xa,%edx
8010900a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80109010:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80109017:	85 c0                	test   %eax,%eax
80109019:	74 d4                	je     80108fef <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010901b:	8b 00                	mov    (%eax),%eax
8010901d:	a8 01                	test   $0x1,%al
8010901f:	0f 84 9f 00 00 00    	je     801090c4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80109025:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80109027:	25 ff 0f 00 00       	and    $0xfff,%eax
8010902c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010902f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80109035:	e8 56 aa ff ff       	call   80103a90 <kalloc>
8010903a:	89 c3                	mov    %eax,%ebx
8010903c:	85 c0                	test   %eax,%eax
8010903e:	74 64                	je     801090a4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80109040:	83 ec 04             	sub    $0x4,%esp
80109043:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80109049:	68 00 10 00 00       	push   $0x1000
8010904e:	57                   	push   %edi
8010904f:	50                   	push   %eax
80109050:	e8 5b d2 ff ff       	call   801062b0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80109055:	58                   	pop    %eax
80109056:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010905c:	5a                   	pop    %edx
8010905d:	ff 75 e4             	push   -0x1c(%ebp)
80109060:	b9 00 10 00 00       	mov    $0x1000,%ecx
80109065:	89 f2                	mov    %esi,%edx
80109067:	50                   	push   %eax
80109068:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010906b:	e8 60 f8 ff ff       	call   801088d0 <mappages>
80109070:	83 c4 10             	add    $0x10,%esp
80109073:	85 c0                	test   %eax,%eax
80109075:	78 21                	js     80109098 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80109077:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010907d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80109080:	0f 87 5a ff ff ff    	ja     80108fe0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80109086:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109089:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010908c:	5b                   	pop    %ebx
8010908d:	5e                   	pop    %esi
8010908e:	5f                   	pop    %edi
8010908f:	5d                   	pop    %ebp
80109090:	c3                   	ret    
80109091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80109098:	83 ec 0c             	sub    $0xc,%esp
8010909b:	53                   	push   %ebx
8010909c:	e8 2f a8 ff ff       	call   801038d0 <kfree>
      goto bad;
801090a1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801090a4:	83 ec 0c             	sub    $0xc,%esp
801090a7:	ff 75 e0             	push   -0x20(%ebp)
801090aa:	e8 91 fd ff ff       	call   80108e40 <freevm>
  return 0;
801090af:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801090b6:	83 c4 10             	add    $0x10,%esp
}
801090b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801090bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801090bf:	5b                   	pop    %ebx
801090c0:	5e                   	pop    %esi
801090c1:	5f                   	pop    %edi
801090c2:	5d                   	pop    %ebp
801090c3:	c3                   	ret    
      panic("copyuvm: page not present");
801090c4:	83 ec 0c             	sub    $0xc,%esp
801090c7:	68 6a 9d 10 80       	push   $0x80109d6a
801090cc:	e8 af 72 ff ff       	call   80100380 <panic>
801090d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801090d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801090df:	90                   	nop

801090e0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801090e0:	55                   	push   %ebp
801090e1:	89 e5                	mov    %esp,%ebp
801090e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801090e6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801090e9:	89 c1                	mov    %eax,%ecx
801090eb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801090ee:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801090f1:	f6 c2 01             	test   $0x1,%dl
801090f4:	0f 84 00 01 00 00    	je     801091fa <uva2ka.cold>
  return &pgtab[PTX(va)];
801090fa:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801090fd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80109103:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80109104:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80109109:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80109110:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80109112:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80109117:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010911a:	05 00 00 00 80       	add    $0x80000000,%eax
8010911f:	83 fa 05             	cmp    $0x5,%edx
80109122:	ba 00 00 00 00       	mov    $0x0,%edx
80109127:	0f 45 c2             	cmovne %edx,%eax
}
8010912a:	c3                   	ret    
8010912b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010912f:	90                   	nop

80109130 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80109130:	55                   	push   %ebp
80109131:	89 e5                	mov    %esp,%ebp
80109133:	57                   	push   %edi
80109134:	56                   	push   %esi
80109135:	53                   	push   %ebx
80109136:	83 ec 0c             	sub    $0xc,%esp
80109139:	8b 75 14             	mov    0x14(%ebp),%esi
8010913c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010913f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80109142:	85 f6                	test   %esi,%esi
80109144:	75 51                	jne    80109197 <copyout+0x67>
80109146:	e9 a5 00 00 00       	jmp    801091f0 <copyout+0xc0>
8010914b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010914f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80109150:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80109156:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010915c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80109162:	74 75                	je     801091d9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80109164:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80109166:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80109169:	29 c3                	sub    %eax,%ebx
8010916b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80109171:	39 f3                	cmp    %esi,%ebx
80109173:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80109176:	29 f8                	sub    %edi,%eax
80109178:	83 ec 04             	sub    $0x4,%esp
8010917b:	01 c1                	add    %eax,%ecx
8010917d:	53                   	push   %ebx
8010917e:	52                   	push   %edx
8010917f:	51                   	push   %ecx
80109180:	e8 2b d1 ff ff       	call   801062b0 <memmove>
    len -= n;
    buf += n;
80109185:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80109188:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010918e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80109191:	01 da                	add    %ebx,%edx
  while(len > 0){
80109193:	29 de                	sub    %ebx,%esi
80109195:	74 59                	je     801091f0 <copyout+0xc0>
  if(*pde & PTE_P){
80109197:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010919a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010919c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010919e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801091a1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801091a7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801091aa:	f6 c1 01             	test   $0x1,%cl
801091ad:	0f 84 4e 00 00 00    	je     80109201 <copyout.cold>
  return &pgtab[PTX(va)];
801091b3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801091b5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801091bb:	c1 eb 0c             	shr    $0xc,%ebx
801091be:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801091c4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801091cb:	89 d9                	mov    %ebx,%ecx
801091cd:	83 e1 05             	and    $0x5,%ecx
801091d0:	83 f9 05             	cmp    $0x5,%ecx
801091d3:	0f 84 77 ff ff ff    	je     80109150 <copyout+0x20>
  }
  return 0;
}
801091d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801091dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801091e1:	5b                   	pop    %ebx
801091e2:	5e                   	pop    %esi
801091e3:	5f                   	pop    %edi
801091e4:	5d                   	pop    %ebp
801091e5:	c3                   	ret    
801091e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801091ed:	8d 76 00             	lea    0x0(%esi),%esi
801091f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801091f3:	31 c0                	xor    %eax,%eax
}
801091f5:	5b                   	pop    %ebx
801091f6:	5e                   	pop    %esi
801091f7:	5f                   	pop    %edi
801091f8:	5d                   	pop    %ebp
801091f9:	c3                   	ret    

801091fa <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801091fa:	a1 00 00 00 00       	mov    0x0,%eax
801091ff:	0f 0b                	ud2    

80109201 <copyout.cold>:
80109201:	a1 00 00 00 00       	mov    0x0,%eax
80109206:	0f 0b                	ud2    
