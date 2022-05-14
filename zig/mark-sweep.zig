const std = @import("std");
const print = @import("std").debug.print;
//const Gpa = std.heap.GeneralPurposeAllocator;

const STACK_MAX = 256;
const INIT_OBJ_NUM_MAX = 8;

const ObjectType = enum {
    OBJ_INT,
    OBJ_PAIR,
};

const Object = struct {
    type: ObjectType,
    marked: u8,
    data: Data,

    // The next object in the linked list of heap allocated objects.
    next: ?*Object,
};

const Data = union { value: i32, pair: struct { head: ?*Object, tail: ?*Object } };

const VM = struct {
    //const Self = @This();

    stack: []*Object, // TODO: Slice ? See ArrayList source code, pub fn init
    stackSize: u32,

    // The first object in the linked list of all objects on the heap. */
    firstObject: ?*Object,

    // The total number of currently allocated objects. */
    numObjects: u32,

    // The number of objects required to trigger a GC. */
    maxObjects: u32,

    allocator: std.mem.Allocator,

    pub fn init(alloc: std.mem.Allocator) !VM {
        // From: https://stackoverflow.com/questions/61422445/malloc-to-a-list-of-struct-in-zig
        //const llocator: std.mem.Allocator = std.heap.page_allocator; // this is not the best choice of allocator, see below.
        //const my_slice_of_foo: []*Object = try llocator.alloc(*Object, STACK_MAX);
        //defer llocator.free(my_slice_of_foo);

        const stack: []*Object = try alloc.alloc(*Object, STACK_MAX);

        return VM{
            .stack = stack,
            .stackSize = 0,
            .firstObject = null,
            .numObjects = 0,
            .maxObjects = STACK_MAX,
            .allocator = alloc,
        };
    }

    pub fn deinit(self: *VM) void {
        vm.stackSize = 0;
        vm.gc();
        self.allocator.free(self.stack);
    }

TODO: 

//void mark(Object* object) {
//  /* If already marked, we're done. Check this first to avoid recursing
//     on cycles in the object graph. */
//  if (object->marked) return;
//
//  object->marked = 1;
//
//  if (object->type == OBJ_PAIR) {
//    mark(object->head);
//    mark(object->tail);
//  }
//}
//
//void markAll(VM* vm)
//{
//  for (int i = 0; i < vm->stackSize; i++) {
//    mark(vm->stack[i]);
//  }
//}
//
//void sweep(VM* vm)
//{
//  Object** object = &vm->firstObject;
//  while (*object) {
//    if (!(*object)->marked) {
//      /* This object wasn't reached, so remove it from the list and free it. */
//      Object* unreached = *object;
//
//      *object = unreached->next;
//      free(unreached);
//
//      vm->numObjects--;
//    } else {
//      /* This object was reached, so unmark it (for the next GC) and move on to
//       the next. */
//      (*object)->marked = 0;
//      object = &(*object)->next;
//    }
//  }
//}
//
//    pub fn gc(self: *VM) void {
//      int numObjects = vm->numObjects;
//
//      markAll(vm);
//      sweep(vm);
//
//      vm->maxObjects = vm->numObjects == 0 ? INIT_OBJ_NUM_MAX : vm->numObjects * 2;
//
//      printf("Collected %d objects, %d remaining.\n", numObjects - vm->numObjects,
//             vm->numObjects);
//    }

    fn newObject(self: *VM, otype: ObjectType) !*Object {
        var obj = try self.allocator.create(Object);
        obj.type = otype;
        obj.marked = 0;
        obj.next = self.firstObject;
        self.firstObject = obj;
        self.numObjects += 1;
        return obj;
    }

    pub fn pushInt(self: *VM, value: i32) !void {
        var obj = try self.newObject(ObjectType.OBJ_INT);
        obj.data = Data{ .value = value };
        self.push(obj);
    }

    pub fn pushPair(self: *VM) !void {
        var obj = try self.newObject(ObjectType.OBJ_PAIR);
        var t = self.pop();
        var h = self.pop();
        obj.data = Data{ .head = h, .tail = t };
        self.push(obj);
    }

    pub fn push(self: *VM, value: *Object) void {
        // TODO: assert(vm->stackSize < STACK_MAX, "Stack overflow!");
        //vm->stack[vm->stackSize++] = value;
        self.stack[self.stackSize] = value;
        self.stackSize += 1;
    }

    pub fn pop(self: *VM) *Object {
        // TODO:  assert(vm->stackSize > 0, "Stack underflow!");
        return self.stack[--self.stackSize];
    }
};

test "test 1" {
    const allocator = std.testing.allocator;
    print("Test 1: Objects on stack are preserved.\n", .{});

    var _vm = try VM.init(allocator);
    var vm = &_vm;
    try vm.pushInt(1);
    try vm.pushInt(2);

    vm.gc();

    try std.testing.expect(vm.numObjects == 2);
    vm.deinit();
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Hello, {s}!\n", .{"world"});
}

// Older notes / code:

// TODO: pass allocator in
//    pub fn init() !*Object {
//        // https://dev.to/pmalhaire/ziglang-first-contact-with-memory-safety-and-simplicity-83p
//        // based off example from https://ziglearn.org/chapter-2/
//        //var gpa = Gpa(.{}){};
//        //const allocator = &gpa.allocator;
//        //var obj = try allocator.alloc(Object, 1);
//        return obj;
//    }
