const std = @import("std");
const print = @import("std").debug.print;
const Gpa = std.heap.GeneralPurposeAllocator;

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

    pub fn init() !*Object {
        // https://dev.to/pmalhaire/ziglang-first-contact-with-memory-safety-and-simplicity-83p
        // based off example from https://ziglearn.org/chapter-2/
        var gpa = Gpa(.{}){};
        const allocator = &gpa.allocator;
        var obj = try allocator.alloc(Object, 1);
        return obj;
    }
};

const Data = union { value: i32, pair: struct { head: ?*Object, tail: ?*Object } };

//const Pair = struct {
//    head: *Object,
//    tail: *Object,
//};

const VM = struct {
    stack: []*Object,
    stackSize: u32,

    // The first object in the linked list of all objects on the heap. */
    firstObject: ?*Object,

    // The total number of currently allocated objects. */
    numObjects: u32,

    // The number of objects required to trigger a GC. */
    maxObjects: u32,

    // TODO: pub fn init() *VM {}
    // TODO: void push(VM* vm, Object* value) {
    // TODO: Object* pop(VM* vm) {

    pub fn push(self: *VM, value: *Object) void {
        // TODO: assert(vm->stackSize < STACK_MAX, "Stack overflow!");
        //vm->stack[vm->stackSize++] = value;
        self.stack[self.stackSize] = value;
        self.stackSize += 1;
    }

    //Object* pop(VM* vm) {
    //  assert(vm->stackSize > 0, "Stack underflow!");
    //  return vm->stack[--vm->stackSize];
    //}
};

test "test 1" {
    print("Test 1: Objects on stack are preserved.\n", .{});
    // From: https://stackoverflow.com/questions/61422445/malloc-to-a-list-of-struct-in-zig
    const llocator: std.mem.Allocator = std.heap.page_allocator; // this is not the best choice of allocator, see below.
    const my_slice_of_foo: []*Object = try llocator.alloc(*Object, STACK_MAX);
    defer llocator.free(my_slice_of_foo);

    var vm = VM{
        .stack = my_slice_of_foo,
        .stackSize = 0,
        .firstObject = null,
        .numObjects = 0,
        .maxObjects = STACK_MAX,
    };

    var obj = Object.init();
    obj.type = ObjectType.OBJ_INT;
    obj.marked = 0;
    obj.data.value = 1;
    vm.push(obj);

    //  VM* vm = newVM();
    //  pushInt(vm, 1);
    //  pushInt(vm, 2);
    //
    //  gc(vm);
    //  assert(vm->numObjects == 2, "Should have preserved objects.");
    //  freeVM(vm);

    try std.testing.expect(vm.numObjects == 0);
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Hello, {s}!\n", .{"world"});
}
